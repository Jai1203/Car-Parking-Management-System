const express = require('express');
const router = express.Router();
const db = require('../db_connect');
const crypto = require('crypto');

// Register
router.post('/register', async (req, res) => {
    const { name, mobile, email, username, password, address } = req.body;
    
    try {
        const [existing] = await db.query(
            'SELECT customer_id FROM Customer WHERE customer_username = ? OR customer_email = ?',
            [username, email]
        );

        if (existing.length > 0) {
            return res.status(400).json({ success: false, message: 'Username or email already exists' });
        }

        const hashedPassword = password
        
        await db.query(
            'INSERT INTO Customer (customer_name, customer_mobile, customer_email, customer_username, customer_password, customer_address) VALUES (?, ?, ?, ?, ?, ?)',
            [name, mobile, email, username, hashedPassword, address]
        );

        res.json({ success: true });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, message: 'Registration failed' });
    }
});

// Login
router.post('/login', async (req, res) => {
    const { username, password } = req.body;

    try {
        const [rows] = await db.query(
            'SELECT customer_id, customer_name, customer_email, customer_mobile, customer_address, customer_password FROM Customer WHERE customer_username = ?',
            [username]
        );

        if (rows.length === 1) {
            const customer = rows[0];
            const match = password == customer.customer_password;

            if (match) {
                req.session.customer_id = customer.customer_id;
                req.session.customer_name = customer.customer_name;
                req.session.csrf_token = crypto.randomBytes(32).toString('hex');

                delete customer.customer_password;
                res.json({
                    success: true,
                    customer: {
                        ...customer,
                        csrf_token: req.session.csrf_token
                    }
                });
            } else {
                res.status(401).json({ success: false, message: 'Invalid password' });
            }
        } else {
            res.status(401).json({ success: false, message: 'User not found' });
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, message: 'Login failed' });
    }
});

module.exports = router;