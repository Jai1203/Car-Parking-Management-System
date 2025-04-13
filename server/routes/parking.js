const express = require('express');
const router = express.Router();
const db = require('../db_connect');

// Get all parking slots
router.get('/', async (req, res) => {
    try {
        const [slots] = await db.query(`
            SELECT 
                ps.parking_slot_id as id,
                ps.parking_slot_type as type,
                ps.parking_slot_description as description,
                pf.parking_fees_amount as rate,
                CASE WHEN ps.customer_id IS NULL THEN false ELSE true END as isOccupied
            FROM Parking_Slots ps
            LEFT JOIN Parking_Fees pf ON ps.parking_slot_id = pf.parking_fees_id
            ORDER BY ps.parking_slot_id
        `);

        res.json({ success: true, slots });
    } catch (error) {
        console.error(error);
        res.status(500).json({
            success: false,
            message: 'Error fetching parking slots'
        });
    }
});

module.exports = router;