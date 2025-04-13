const mysql = require('mysql2/promise');

const dbConfig = {
  host: 'localhost',
  user: 'root',
  password: 'password123@',
  database: 'CarParkingManagement'
};

const pool = mysql.createPool(dbConfig);

module.exports = pool;