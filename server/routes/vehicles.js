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

// Get customer vehicles
router.get('/', checkAuth, async (req, res) => {
    const customerId = req.session.customer_id;
    
    try {
        const [vehicles] = await db.query(
            'SELECT vehicle_id, vehicle_company, vehicle_type, vehicle_model, vehicle_number, vehicle_owner_id FROM Vehicles WHERE vehicle_owner_id = ?',
            [customerId]
        );
        
        res.json({ success: true, vehicles });
    } catch (error) {
        console.error(error);
        res.status(500).json({ 
            success: false, 
            message: 'Error fetching vehicles' 
        });
    }
});

// Register a new vehicle
router.post('/', checkAuth, async (req, res) => {
    const { make, model, year, color, licensePlate } = req.body;
    const customerId = req.session.customer_id;

    try {
        await db.query(
            'INSERT INTO Vehicles (vehicle_company, vehicle_model, vehicle_year, vehicle_color, vehicle_number, vehicle_owner_id, vehicle_type) VALUES (?, ?, ?, ?, ?, ?, "car")',
            [make, model, year, color, licensePlate, customerId]
        );
        
        res.json({ success: true });
    } catch (error) {
        console.error(error);
        res.status(500).json({ 
            success: false, 
            message: 'Failed to register vehicle' 
        });
    }
});

module.exports = router;