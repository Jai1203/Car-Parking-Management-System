const express = require('express');
const router = express.Router();
const db = require('../db_connect');

// Auth middleware
const checkAuth = (req, res, next) => {
    if (!req.session.customer_id) {
        return res.status(403).json({ success: false, message: 'Please login first' });
    }
    next();
};

// CSRF middleware
// Get active bookings
router.get('/', checkAuth, async (req, res) => {
    const customerId = req.session.customer_id;

    try {
        const [bookings] = await db.query(`
            SELECT pt.*, ps.parking_slot_type, v.vehicle_company, v.vehicle_type 
            FROM Parking_Transactions pt
            JOIN Parking_Slots ps ON pt.parking_slot_id = ps.parking_slot_id
            JOIN Vehicles v ON pt.vehicle_id = v.vehicle_id
            WHERE pt.customer_id = ? AND pt.exit_time IS NULL
        `, [customerId]);

        res.json(bookings);
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, message: 'Error fetching bookings' });
    }
});

// Get bookings by customer ID
router.get('/:customerId', checkAuth, async (req, res) => {
    const { customerId } = req.params;
    
    if (parseInt(customerId) !== req.session.customer_id) {
        return res.status(403).json({ success: false, message: 'Unauthorized access' });
    }

    try {
        const [bookings] = await db.query(`
            SELECT 
                pt.transaction_id as id,
                pt.parking_slot_id as slotId,
                pt.entry_time as startTime,
                v.vehicle_company,
                v.vehicle_model
            FROM Parking_Transactions pt
            JOIN Vehicles v ON pt.vehicle_id = v.vehicle_id
            WHERE pt.customer_id = ? AND pt.exit_time IS NULL
        `, [customerId]);

        res.json({ success: true, bookings });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, message: 'Error fetching bookings' });
    }
});

// Book a slot
router.post('/book', [checkAuth], async (req, res) => {
    const { vehicle_id, slot_id } = req.body;
    const customerId = req.session.customer_id;

    if (!vehicle_id || !slot_id) {
        return res.status(400).json({ success: false, message: 'Missing required data' });
    }

    const connection = await db.getConnection();
    await connection.beginTransaction();

    try {
        // Verify vehicle ownership
        const [vehicle] = await connection.query(
            'SELECT vehicle_owner_id FROM Vehicles WHERE vehicle_id = ? AND vehicle_owner_id = ?',
            [vehicle_id, customerId]
        );

        if (vehicle.length !== 1) {
            throw new Error('Unauthorized vehicle access');
        }

        // Check if slot is available
        const [slots] = await connection.query(
            'SELECT parking_slot_id FROM Parking_Slots WHERE parking_slot_id = ? AND customer_id IS NULL FOR UPDATE',
            [slot_id]
        );

        if (slots.length === 0) {
            throw new Error('Slot is not available');
        }

        // Assign slot
        await connection.query(
            'UPDATE Parking_Slots SET customer_id = ?, parking_slot_car_id = ?, entry_time = NOW() WHERE parking_slot_id = ? AND customer_id IS NULL',
            [customerId, vehicle_id, slot_id]
        );

        // Create transaction
        await connection.query(
            'INSERT INTO Parking_Transactions (parking_slot_id, customer_id, vehicle_id, entry_time) VALUES (?, ?, ?, NOW())',
            [slot_id, customerId, vehicle_id]
        );

        await connection.commit();
        res.json({ success: true, slot_id: slot_id });

    } catch (error) {
        await connection.rollback();
        res.status(400).json({ success: false, message: error.message });
    } finally {
        connection.release();
    }
});

// Release slot
router.post('/release', [checkAuth], async (req, res) => {
    const { transaction_id } = req.body;
    const customerId = req.session.customer_id;

    const connection = await db.getConnection();
    await connection.beginTransaction();

    try {
        // Verify transaction
        const [transaction] = await connection.query(`
            SELECT pt.parking_slot_id, ps.parking_slot_type, pt.entry_time, pt.customer_id
            FROM Parking_Transactions pt
            JOIN Parking_Slots ps ON pt.parking_slot_id = ps.parking_slot_id
            WHERE pt.transaction_id = ? AND pt.exit_time IS NULL
            FOR UPDATE
        `, [transaction_id]);

        if (transaction.length !== 1) {
            throw new Error('Transaction not found or already completed');
        }

        if (transaction[0].customer_id !== customerId) {
            throw new Error('Unauthorized access to this transaction');
        }

        const { parking_slot_id, parking_slot_type, entry_time } = transaction[0];

        // Get hourly rate
        const [fees] = await connection.query(
            'SELECT parking_fees_amount FROM Parking_Fees WHERE parking_fees_type = ?',
            [parking_slot_type]
        );

        const hourlyRate = fees[0].parking_fees_amount;
        const exitTime = new Date();
        const hoursParked = Math.round((exitTime - new Date(entry_time)) / (1000 * 60 * 60) * 100) / 100;
        const totalFee = hoursParked * hourlyRate;

        // Release slot
        await connection.query(`
            UPDATE Parking_Slots 
            SET customer_id = NULL, parking_slot_car_id = NULL, entry_time = NULL, exit_time = NOW()
            WHERE parking_slot_id = ?
        `, [parking_slot_id]);

        // Update transaction
        await connection.query(`
            UPDATE Parking_Transactions 
            SET exit_time = NOW(), total_fee = ?
            WHERE transaction_id = ?
        `, [totalFee, transaction_id]);

        await connection.commit();
        res.json({ success: true, total_fee: totalFee });

    } catch (error) {
        await connection.rollback();
        res.status(400).json({ success: false, message: error.message });
    } finally {
        connection.release();
    }
});

// Delete (release) booking
router.delete('/:bookingId', [checkAuth], async (req, res) => {
    const { bookingId } = req.params;
    const customerId = req.session.customer_id;

    const connection = await db.getConnection();
    await connection.beginTransaction();

    try {
        const [booking] = await connection.query(`
            SELECT pt.*, ps.parking_slot_type
            FROM Parking_Transactions pt
            JOIN Parking_Slots ps ON pt.parking_slot_id = ps.parking_slot_id
            WHERE pt.transaction_id = ? AND pt.customer_id = ? AND pt.exit_time IS NULL
            FOR UPDATE
        `, [bookingId, customerId]);

        if (booking.length === 0) {
            throw new Error('Booking not found or unauthorized');
        }

        const [fees] = await connection.query(
            'SELECT parking_fees_amount FROM Parking_Fees WHERE parking_fees_id = ?',
            [booking[0].parking_slot_id]
        );
        console.log(fees)
        const hourlyRate = fees[0].parking_fees_amount;
        const exitTime = new Date();
        const hoursParked = Math.ceil((exitTime - booking[0].entry_time) / (1000 * 60 * 60));
        const totalFee = hoursParked * hourlyRate;

        await connection.query(`
            UPDATE Parking_Slots 
            SET customer_id = NULL, parking_slot_car_id = NULL 
            WHERE parking_slot_id = ?
        `, [booking[0].parking_slot_id]);

        await connection.query(`
            UPDATE Parking_Transactions 
            SET exit_time = NOW(), total_fee = ?
            WHERE transaction_id = ?
        `, [totalFee, bookingId]);

        await connection.commit();
        res.json({ success: true, fee: totalFee });

    } catch (error) {
        await connection.rollback();
        res.status(400).json({ success: false, message: error.message });
    } finally {
        connection.release();
    }
});

module.exports = router;