CREATE DATABASE CarParkingManagement;
USE CarParkingManagement;
CREATE TABLE User (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    number VARCHAR(15) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    address TEXT NOT NULL
);
CREATE TABLE Role (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) NOT NULL,
    role_description TEXT
);
CREATE TABLE Login (
    login_id INT PRIMARY KEY AUTO_INCREMENT,
    login_role_id INT NOT NULL,
    login_username VARCHAR(50) UNIQUE NOT NULL,
    user_password VARCHAR(255) NOT NULL,
    FOREIGN KEY (login_role_id) REFERENCES Role(role_id) ON DELETE CASCADE
);
CREATE TABLE Permission (
    permission_id INT PRIMARY KEY AUTO_INCREMENT,
    permission_role_id INT NOT NULL,
    permission_module VARCHAR(50) NOT NULL,
    permission_name VARCHAR(50) NOT NULL,
    FOREIGN KEY (permission_role_id) REFERENCES Role(role_id)
);
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    customer_mobile VARCHAR(15) NOT NULL,
    customer_email VARCHAR(100) UNIQUE NOT NULL,
    customer_username VARCHAR(50) UNIQUE NOT NULL,
    customer_password VARCHAR(255) NOT NULL,
    customer_address TEXT NOT NULL
);
CREATE TABLE Duration (
    duration_id INT PRIMARY KEY AUTO_INCREMENT,
    duration_name VARCHAR(50) NOT NULL,
    duration_type VARCHAR(50) NOT NULL,
    duration_time INT NOT NULL,
    duration_description TEXT
);
CREATE TABLE Vehicles (
    vehicle_id INT PRIMARY KEY AUTO_INCREMENT,
    vehicle_owner_id INT NOT NULL,
    vehicle_company VARCHAR(100) NOT NULL,
    vehicle_model VARCHAR(100) NOT NULL,
    vehicle_year INT NOT NULL,
    vehicle_color VARCHAR(50) NOT NULL,
    vehicle_number VARCHAR(20) UNIQUE NOT NULL,
    vehicle_type VARCHAR(50) NOT NULL,
    vehicle_description TEXT,
    FOREIGN KEY (vehicle_owner_id) REFERENCES Customer(customer_id)
);
CREATE TABLE Parking_Slots (
    parking_slot_id INT PRIMARY KEY AUTO_INCREMENT,
    parking_slot_car_id INT NOT NULL,
    parking_slot_type VARCHAR(50) NOT NULL,
    parking_slot_description TEXT,
    FOREIGN KEY (parking_slot_car_id) REFERENCES Vehicles(vehicle_id)
);
CREATE TABLE Parking_Fees (
    parking_fees_id INT PRIMARY KEY AUTO_INCREMENT,
    parking_fees_type VARCHAR(50) NOT NULL,
    parking_fees_amount DECIMAL(10,2) NOT NULL,
    parking_fees_description TEXT
);

ALTER TABLE Parking_Slots ADD COLUMN customer_id INT;
ALTER TABLE Parking_Slots ADD CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id);
SET SQL_SAFE_UPDATES = 0;

INSERT INTO User (id, name, number, email, address) VALUES
(1, 'Jai Chadha', '9876543210', 'jai@example.com', '123 Main St,Bagru'),
(2, 'Bob Smith', '8765432109', 'bob@example.com', '456 Elm St, Bhakrota'),
(3, 'Charlie Davis', '7654321098', 'charlie@example.com', '789 Pine St, Vatika'),
(4, 'David Williams', '6543210987', 'david@example.com', '159 Oak St, Vintage'),
(5, 'Emma Wilson', '5432109876', 'emma@example.com', '753 Maple St,Highland');
INSERT INTO Role (role_id, role_name, role_description) VALUES
(1, 'Admin', 'Has full access'),
(2, 'Manager', 'Can manage parking and customers'),
(3, 'Staff', 'Handles parking operations'),
(4, 'Security', 'Monitors security'),
(5, 'Customer', 'Regular parking user');
INSERT INTO Login (login_id, login_role_id, login_username, user_password) VALUES
(1, 1, 'admin1', 'admin123'),
(2, 2, 'manager1', 'manager123'),
(3, 3, 'staff1', 'staff123'),
(4, 4, 'security1', 'security123'),
(5, 5, 'customer1', 'customer123');
INSERT INTO Permission (permission_id, permission_role_id, permission_module, permission_name) VALUES
(1, 1, 'User Management', 'Full Access'),
(2, 2, 'Parking Management', 'Edit'),
(3, 3, 'Slot Assignment', 'Manage'),
(4, 4, 'Security Logs', 'View'),
(5, 5, 'Booking', 'Limited Access');
INSERT INTO Customer (customer_id, customer_name, customer_mobile, customer_email, customer_username, customer_password, customer_address) VALUES
(1, 'Jai Chauhan', '9123456789', 'jai@example.com', 'johndoe', 'pass123', '987 Willow St, Bagru'),
(2, 'Jane Smith', '9234567890', 'jane@example.com', 'janesmith', 'pass456', '321 Birch St, Bhakrota'),
(3, 'Mike Brown', '9345678901', 'mike@example.com', 'mikebrown', 'pass789', '654 Cedar St, Vatika'),
(4, 'Lucy Green', '9456789012', 'lucy@example.com', 'lucygreen', 'pass111', '852 Spruce St, Vintage'),
(5, 'Tom White', '9567890123', 'tom@example.com', 'tomwhite', 'pass222', '753 Redwood St, Highland');
INSERT INTO Duration (duration_id, duration_name, duration_type, duration_time, duration_description) VALUES
(1, 'Short Term', 'Hours', 2, 'Short term parking for visitors'),
(2, 'Half Day', 'Hours', 6, 'Parking for half a day'),
(3, 'Full Day', 'Hours', 12, 'Parking for a full working day'),
(4, 'Overnight', 'Hours', 24, 'Overnight parking option'),
(5, 'Monthly Pass', 'Days', 30, 'Monthly parking subscription');
INSERT INTO Vehicles (vehicle_id, vehicle_owner_id, vehicle_company, vehicle_model, vehicle_year, vehicle_color, vehicle_number, vehicle_type, vehicle_description) VALUES
(1, 1, 'Toyota', 'Corolla', 2020, 'Silver', 'RJ01AB1234', 'Sedan', 'Silver Corolla'),
(2, 2, 'Honda', 'CR-V', 2021, 'Black', 'RJ02CD5678', 'SUV', 'Black CR-V'),
(3, 3, 'Ford', 'F-150', 2019, 'Blue', 'RJ03EF9012', 'Truck', 'Blue F-150'),
(4, 4, 'Tesla', 'Model 3', 2022, 'Red', 'RJ04GH3456', 'Electric', 'Red Model 3'),
(5, 5, 'BMW', '5 Series', 2021, 'White', 'RJ05IJ7890', 'Sedan', 'White 5 Series');
INSERT INTO Parking_Slots (parking_slot_id, parking_slot_car_id, parking_slot_type, parking_slot_description) VALUES
(1, 1, 'Compact', 'Near entrance'),
(2, 2, 'Regular', 'Covered area'),
(3, 3, 'Large', 'Truck Parking'),
(4, 4, 'Electric', 'Near charging station');
ALTER TABLE Parking_Slots MODIFY parking_slot_car_id INT NULL;
INSERT INTO Parking_Slots (parking_slot_id, parking_slot_car_id, parking_slot_type, parking_slot_description, customer_id) VALUES
(6, NULL, 'Compact', 'Near entrance', NULL),
(7, NULL, 'Regular', 'Covered area', NULL),
(8, NULL, 'Large', 'Truck Parking', NULL),
(9, NULL, 'Electric', 'Near charging station', NULL),
(10, NULL, 'VIP', 'Premium parking', NULL);
INSERT INTO Parking_Fees (parking_fees_id, parking_fees_type, parking_fees_amount, parking_fees_description) VALUES
(1, 'Short Term', 5.00, 'Hourly Rate'),
(2, 'Half Day', 20.00, 'Discounted rate for half day'),
(3, 'Full Day', 35.00, 'Fixed rate for full day'),
(4, 'Overnight', 50.00, 'Flat fee for overnight parking'),
(5, 'Monthly', 200.00, 'Subscription for a month');
INSERT INTO Parking_Fees (parking_fees_id, parking_fees_type, parking_fees_amount, parking_fees_description) VALUES
(6, 'Weekly', 50.00, 'Subscription for a week'),
(7, 'Daily', 10.00, 'Subscription for a day'),
(8, 'Weekly', 50.00, 'Subscription for a week'),
(9, 'Monthly', 200.00, 'Subscription for a month'),
(10, 'Yearly', 2000.00, 'Subscription for a year');

INSERT INTO Parking_Slots (parking_slot_id, parking_slot_car_id, parking_slot_type, parking_slot_description, customer_id) VALUES
(5, NULL, 'Electric', 'Rear mall parking', NULL);

INSERT INTO Parking_Slots (parking_slot_id, parking_slot_car_id, parking_slot_type, parking_slot_description, customer_id) VALUES
(11, NULL, 'Helicopter', 'VIP Helipad', NULL);
/*ALTER TABLE User ADD status VARCHAR(100);
ALTER TABLE User MODIFY id SMALLINT;
ALTER TABLE User MODIFY Name VARCHAR(100) NOT NULL;
ALTER TABLE User ADD CONSTRAINT unique_number UNIQUE (Number);*/


UPDATE Parking_Slots 
SET customer_id = (SELECT vehicle_owner_id FROM Vehicles WHERE Vehicles.vehicle_id = Parking_Slots.parking_slot_car_id)
WHERE EXISTS (SELECT 1 FROM Vehicles WHERE Vehicles.vehicle_id = Parking_Slots.parking_slot_car_id);

SET SQL_SAFE_UPDATES = 1;

SELECT
    ps.parking_slot_id,
    ps.parking_slot_type,
    ps.parking_slot_description,
    pf.parking_fees_amount,
    pf.parking_fees_description,
    CASE
        WHEN ps.customer_id IS NULL THEN 'Available'
        ELSE 'Occupied'
        END AS Slot_Status
FROM Parking_Slots ps
         LEFT JOIN Parking_Fees pf ON ps.parking_slot_type = pf.parking_fees_type
WHERE ps.parking_slot_id > 0      -- Ensures valid slot IDs
ORDER BY ps.parking_slot_id ASC;  -- Orders results by slot ID

INSERT INTO Parking_Fees (parking_fees_id, parking_fees_type, parking_fees_amount, parking_fees_description) VALUES
(11, 'Custom', 5000, 'Hourly Rate');

UPDATE Parking_Slots ps
JOIN Vehicles v ON ps.parking_slot_car_id = v.vehicle_id
SET ps.customer_id = v.vehicle_owner_id
WHERE ps.customer_id IS NULL;
SELECT 
    ps.parking_slot_id, 
    ps.parking_slot_type, 
    ps.parking_slot_description, 
    ps.customer_id,
    CASE 
        WHEN ps.customer_id IS NULL THEN 'Available'
        ELSE 'Occupied'
    END AS Slot_Status
FROM Parking_Slots ps;


ALTER TABLE Parking_Slots 
ADD COLUMN entry_time DATETIME,
ADD COLUMN exit_time DATETIME;
CREATE TABLE Parking_Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    parking_slot_id INT NOT NULL,
    customer_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    entry_time DATETIME NOT NULL,
    exit_time DATETIME,
    total_fee DECIMAL(10,2),
    FOREIGN KEY (parking_slot_id) REFERENCES Parking_Slots(parking_slot_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)
);
-- Assign a parking slot to a customer and record the entry time
UPDATE Parking_Slots 
SET customer_id = 1, entry_time = NOW() 
WHERE parking_slot_id = (
    SELECT parking_slot_id FROM (SELECT parking_slot_id FROM Parking_Slots WHERE customer_id IS NULL LIMIT 1) AS temp_table
);

-- Update exit time and calculate total fee
UPDATE Parking_Transactions pt
JOIN Parking_Slots ps ON pt.parking_slot_id = ps.parking_slot_id
JOIN Parking_Fees pf ON ps.parking_slot_type = pf.parking_fees_type
SET pt.exit_time = NOW(),
    pt.total_fee = pf.parking_fees_amount * TIMESTAMPDIFF(HOUR, ps.entry_time, NOW())
WHERE pt.parking_slot_id = 1 AND pt.exit_time IS NULL;

-- Retrieve updated slot and fee details
SELECT 
    ps.parking_slot_id, 
    ps.parking_slot_type, 
    ps.parking_slot_description, 
    ps.customer_id,
    pt.entry_time, 
    pt.exit_time, 
    pt.total_fee,
    CASE 
        WHEN ps.customer_id IS NULL THEN 'Available'
        ELSE 'Occupied'
    END AS Slot_Status
FROM Parking_Slots ps
LEFT JOIN Parking_Transactions pt ON ps.parking_slot_id = pt.parking_slot_id;
CREATE VIEW CustomerVehicles AS
SELECT 
    c.customer_id, 
    c.customer_name, 
    c.customer_mobile, 
    c.customer_email, 
    v.vehicle_id, 
    v.vehicle_company,
    v.vehicle_model,
    v.vehicle_year,
    v.vehicle_color,
    v.vehicle_number,
    v.vehicle_type, 
    v.vehicle_description
FROM Customer c
LEFT JOIN Vehicles v ON c.customer_id = v.vehicle_owner_id;

CREATE VIEW ParkingSlotDetails AS
SELECT 
    ps.parking_slot_id, 
    ps.parking_slot_type, 
    ps.parking_slot_description, 
    ps.customer_id, 
    c.customer_name, 
    v.vehicle_company, 
    v.vehicle_type,
    CASE 
        WHEN ps.customer_id IS NULL THEN 'Available'
        ELSE 'Occupied'
    END AS Slot_Status
FROM Parking_Slots ps
LEFT JOIN Customer c ON ps.customer_id = c.customer_id
LEFT JOIN Vehicles v ON ps.parking_slot_car_id = v.vehicle_id;

CREATE VIEW ParkingTransactionDetails AS
SELECT 
    pt.transaction_id, 
    ps.parking_slot_id, 
    ps.parking_slot_type, 
    c.customer_name, 
    v.vehicle_company, 
    pt.entry_time, 
    pt.exit_time, 
    pt.total_fee
FROM Parking_Transactions pt
JOIN Parking_Slots ps ON pt.parking_slot_id = ps.parking_slot_id
JOIN Customer c ON pt.customer_id = c.customer_id
JOIN Vehicles v ON pt.vehicle_id = v.vehicle_id;

SELECT 
    pt.transaction_id,
    c.customer_name,
    v.vehicle_company,
    v.vehicle_type,
    ps.parking_slot_type,
    ps.parking_slot_description,
    pt.entry_time,
    pt.exit_time,
    TIMESTAMPDIFF(HOUR, pt.entry_time, pt.exit_time) AS Duration_Hours,
    pt.total_fee
FROM Parking_Transactions pt
JOIN Customer c ON pt.customer_id = c.customer_id
JOIN Vehicles v ON pt.vehicle_id = v.vehicle_id
JOIN Parking_Slots ps ON pt.parking_slot_id = ps.parking_slot_id
ORDER BY pt.transaction_id DESC;

CREATE INDEX idx_customer_email ON Customer(customer_email);
CREATE INDEX idx_entry_time ON Parking_Transactions(entry_time);
CREATE INDEX idx_vehicle_company_type ON Vehicles(vehicle_company, vehicle_type);

DESCRIBE Customer;
DESCRIBE Vehicles;
DESCRIBE Parking_Slots;

SELECT * FROM CustomerVehicles;
SELECT * FROM ParkingSlotDetails;
SELECT * FROM ParkingTransactionDetails;

EXPLAIN SELECT * FROM Customer WHERE customer_email = 'jai@example.com';
EXPLAIN SELECT * FROM Parking_Transactions WHERE entry_time > '2025-03-01 00:00:00';

-- SQL VIEWS
-- Create a view for available parking slots
CREATE VIEW Available_Parking_Slots AS
SELECT 
    ps.parking_slot_id, 
    ps.parking_slot_type, 
    pf.parking_fees_amount,
    ps.parking_slot_description
FROM Parking_Slots ps
JOIN Parking_Fees pf ON ps.parking_slot_type = pf.parking_fees_type
WHERE ps.customer_id IS NULL;

-- Create a view for customer parking history
CREATE VIEW Customer_Parking_History AS
SELECT 
    c.customer_name,
    v.vehicle_company,
    v.vehicle_type,
    ps.parking_slot_type,
    pt.entry_time,
    pt.exit_time,
    pt.total_fee
FROM Parking_Transactions pt
JOIN Customer c ON pt.customer_id = c.customer_id
JOIN Vehicles v ON pt.vehicle_id = v.vehicle_id
JOIN Parking_Slots ps ON pt.parking_slot_id = ps.parking_slot_id;

-- MULTIPLE TABLE JOINS
-- Join Customer, Vehicles, and Parking_Slots
SELECT 
    c.customer_name,
    c.customer_mobile,
    v.vehicle_company,
    v.vehicle_type,
    ps.parking_slot_type,
    ps.entry_time
FROM Customer c
JOIN Vehicles v ON c.customer_id = v.vehicle_owner_id
JOIN Parking_Slots ps ON v.vehicle_id = ps.parking_slot_car_id;

-- Complex join with aggregation
SELECT 
    c.customer_name,
    COUNT(v.vehicle_id) AS number_of_vehicles,
    SUM(pt.total_fee) AS total_spent
FROM Customer c
LEFT JOIN Vehicles v ON c.customer_id = v.vehicle_owner_id
LEFT JOIN Parking_Transactions pt ON c.customer_id = pt.customer_id
GROUP BY c.customer_name;



-- DESCRIBE STATEMENTS
-- Describe table structures
DESCRIBE User;
DESCRIBE Role;
DESCRIBE Login;
DESCRIBE Permission;
DESCRIBE Customer;
DESCRIBE Duration;
DESCRIBE Vehicles;
DESCRIBE Parking_Slots;
DESCRIBE Parking_Fees;
DESCRIBE Parking_Transactions;

-- Show view definitions
SHOW CREATE VIEW Available_Parking_Slots;
SHOW CREATE VIEW Customer_Parking_History;

-- Show indexes
SHOW INDEX FROM Customer;
SHOW INDEX FROM Vehicles;
SHOW INDEX FROM Parking_Slots;
SHOW INDEX FROM Parking_Transactions;

-- 1. Procedure for customer registration
DELIMITER //
CREATE PROCEDURE RegisterCustomer(
    IN p_name VARCHAR(100),
    IN p_mobile VARCHAR(15),
    IN p_email VARCHAR(100),
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(255),
    IN p_address TEXT
)
BEGIN
    INSERT INTO Customer (customer_name, customer_mobile, customer_email, customer_username, customer_password, customer_address)
    VALUES (p_name, p_mobile, p_email, p_username, p_password, p_address);
END //
DELIMITER ;

-- 2. Procedure for vehicle registration
DELIMITER //
CREATE PROCEDURE RegisterVehicle(
    IN p_owner_id INT,
    IN p_company VARCHAR(100),
    IN p_model VARCHAR(100),
    IN p_year INT,
    IN p_color VARCHAR(50),
    IN p_number VARCHAR(20),
    IN p_type VARCHAR(50),
    IN p_description TEXT
)
BEGIN
    INSERT INTO Vehicles (vehicle_owner_id, vehicle_company, vehicle_model, vehicle_year, vehicle_color, vehicle_number, vehicle_type, vehicle_description)
    VALUES (p_owner_id, p_company, p_model, p_year, p_color, p_number, p_type, p_description);
END //
DELIMITER ;

-- 3. Procedure for parking slot assignment
DELIMITER //
CREATE PROCEDURE AssignParkingSlot(
    IN p_customer_id INT,
    IN p_vehicle_id INT,
    IN p_slot_type VARCHAR(50),
    OUT p_slot_id INT
)
BEGIN
    -- Find first available slot of requested type
    SELECT parking_slot_id INTO p_slot_id 
    FROM Parking_Slots 
    WHERE parking_slot_type = p_slot_type AND customer_id IS NULL 
    LIMIT 1;
    
    IF p_slot_id IS NOT NULL THEN
        UPDATE Parking_Slots 
        SET customer_id = p_customer_id, 
            parking_slot_car_id = p_vehicle_id,
            entry_time = NOW()
        WHERE parking_slot_id = p_slot_id;
        
        -- Record transaction
        INSERT INTO Parking_Transactions (parking_slot_id, customer_id, vehicle_id, entry_time)
        VALUES (p_slot_id, p_customer_id, p_vehicle_id, NOW());
    END IF;
END //
DELIMITER ;

-- 4. Procedure for releasing parking slot
DELIMITER //
CREATE PROCEDURE ReleaseParkingSlot(
    IN p_slot_id INT,
    OUT p_total_fee DECIMAL(10,2)
)
BEGIN
    DECLARE v_entry_time DATETIME;
    DECLARE v_slot_type VARCHAR(50);
    DECLARE v_hours_parked INT;
    DECLARE v_hourly_rate DECIMAL(10,2);
    
    -- Get slot details
    SELECT entry_time, parking_slot_type INTO v_entry_time, v_slot_type
    FROM Parking_Slots 
    WHERE parking_slot_id = p_slot_id;
    
    -- Get hourly rate
    SELECT parking_fees_amount INTO v_hourly_rate
    FROM Parking_Fees
    WHERE parking_fees_type = v_slot_type;
    
    -- Calculate hours parked
    SET v_hours_parked = TIMESTAMPDIFF(HOUR, v_entry_time, NOW());
    SET p_total_fee = v_hours_parked * v_hourly_rate;
    
    -- Update slot and transaction
    UPDATE Parking_Slots 
    SET customer_id = NULL,
        parking_slot_car_id = NULL,
        entry_time = NULL,
        exit_time = NOW()
    WHERE parking_slot_id = p_slot_id;
    
    UPDATE Parking_Transactions
    SET exit_time = NOW(),
        total_fee = p_total_fee
    WHERE parking_slot_id = p_slot_id AND exit_time IS NULL;
END //
DELIMITER ;

-- 5. Procedure for getting customer parking history
DELIMITER //
CREATE PROCEDURE GetCustomerParkingHistory(
    IN p_customer_id INT
)
BEGIN
    SELECT 
        pt.transaction_id,
        ps.parking_slot_type,
        v.vehicle_company,
        v.vehicle_type,
        pt.entry_time,
        pt.exit_time,
        pt.total_fee
    FROM Parking_Transactions pt
    JOIN Parking_Slots ps ON pt.parking_slot_id = ps.parking_slot_id
    JOIN Vehicles v ON pt.vehicle_id = v.vehicle_id
    WHERE pt.customer_id = p_customer_id
    ORDER BY pt.entry_time DESC;
END //
DELIMITER ;

-- 6. Procedure for checking available slots
DELIMITER //
CREATE PROCEDURE GetAvailableSlots()
BEGIN
    SELECT 
        ps.parking_slot_id,
        ps.parking_slot_type,
        pf.parking_fees_amount,
        ps.parking_slot_description
    FROM Parking_Slots ps
    JOIN Parking_Fees pf ON ps.parking_slot_type = pf.parking_fees_type
    WHERE ps.customer_id IS NULL;
END //
DELIMITER ;
-- 1. Trigger to automatically create a login record when a new customer is registered
DELIMITER //
CREATE TRIGGER after_customer_insert
AFTER INSERT ON Customer
FOR EACH ROW
BEGIN
    -- Add customer to Login table with default 'Customer' role
    INSERT INTO Login (login_role_id, login_username, user_password)
    VALUES (5, NEW.customer_username, NEW.customer_password);
END //
DELIMITER ;

-- 2. Trigger to validate email format before inserting/updating in Customer table
DELIMITER //
CREATE TRIGGER before_customer_email_insert
BEFORE INSERT ON Customer
FOR EACH ROW
BEGIN
    IF NEW.customer_email NOT LIKE '%_@__%.__%' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Invalid email format';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER before_customer_email_update
BEFORE UPDATE ON Customer
FOR EACH ROW
BEGIN
    IF NEW.customer_email NOT LIKE '%_@__%.__%' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Invalid email format';
    END IF;
END //
DELIMITER ;

-- 3. Trigger to automatically update exit_time and calculate fee when a parking slot is released
DELIMITER //
CREATE TRIGGER after_slot_release
AFTER UPDATE ON Parking_Slots
FOR EACH ROW
BEGIN
    IF NEW.customer_id IS NULL AND OLD.customer_id IS NOT NULL THEN
        -- Find the corresponding transaction
        UPDATE Parking_Transactions pt
        JOIN Parking_Fees pf ON (
            SELECT parking_slot_type FROM Parking_Slots 
            WHERE parking_slot_id = NEW.parking_slot_id
        ) = pf.parking_fees_type
        SET pt.exit_time = NOW(),
            pt.total_fee = pf.parking_fees_amount * TIMESTAMPDIFF(HOUR, pt.entry_time, NOW())
        WHERE pt.parking_slot_id = NEW.parking_slot_id 
        AND pt.exit_time IS NULL;
    END IF;
END //
DELIMITER ;

-- 4. Trigger to prevent deleting customers with active parking slots
DELIMITER //
CREATE TRIGGER before_customer_delete
BEFORE DELETE ON Customer
FOR EACH ROW
BEGIN
    DECLARE active_slots INT;
    
    SELECT COUNT(*) INTO active_slots
    FROM Parking_Slots
    WHERE customer_id = OLD.customer_id;
    
    IF active_slots > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete customer with active parking slots';
    END IF;
END //
DELIMITER ;

-- 5. Trigger to log all parking slot assignments
CREATE TABLE Parking_Slot_Assignment_Log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    slot_id INT NOT NULL,
    customer_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    assignment_time DATETIME NOT NULL,
    action VARCHAR(10) NOT NULL
);

DELIMITER //
CREATE TRIGGER after_slot_assignment
AFTER UPDATE ON Parking_Slots
FOR EACH ROW
BEGIN
    IF NEW.customer_id IS NOT NULL AND OLD.customer_id IS NULL THEN
        -- Log assignment
        INSERT INTO Parking_Slot_Assignment_Log 
        (slot_id, customer_id, vehicle_id, assignment_time, action)
        VALUES (NEW.parking_slot_id, NEW.customer_id, NEW.parking_slot_car_id, NOW(), 'ASSIGN');
    ELSEIF NEW.customer_id IS NULL AND OLD.customer_id IS NOT NULL THEN
        -- Log release
        INSERT INTO Parking_Slot_Assignment_Log 
        (slot_id, customer_id, vehicle_id, assignment_time, action)
        VALUES (OLD.parking_slot_id, OLD.customer_id, OLD.parking_slot_car_id, NOW(), 'RELEASE');
    END IF;
END //
DELIMITER ;

-- 6. Trigger to enforce parking slot type matches vehicle type
DELIMITER //
CREATE TRIGGER before_slot_assignment
BEFORE UPDATE ON Parking_Slots
FOR EACH ROW
BEGIN
    DECLARE vehicle_type VARCHAR(50);
    DECLARE slot_type VARCHAR(50);
    
    IF NEW.customer_id IS NOT NULL THEN
        -- Get vehicle type
        SELECT vehicle_type INTO vehicle_type
        FROM Vehicles
        WHERE vehicle_id = NEW.parking_slot_car_id;
        
        -- Get slot type
        SET slot_type = NEW.parking_slot_type;
        
        -- Check compatibility
        IF (vehicle_type = 'Truck' AND slot_type != 'Large') OR
           (vehicle_type = 'Electric' AND slot_type != 'Electric') OR
           (vehicle_type = 'SUV' AND slot_type = 'Compact') THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Vehicle type not compatible with parking slot type';
        END IF;
    END IF;
END //
DELIMITER ;

-- 7. Trigger to update parking duration when exit time is recorded
DELIMITER //
CREATE TRIGGER before_transaction_exit_update
BEFORE UPDATE ON Parking_Transactions
FOR EACH ROW
BEGIN
    IF NEW.exit_time IS NOT NULL AND OLD.exit_time IS NULL THEN
        -- Ensure exit time is after entry time
        IF NEW.exit_time < OLD.entry_time THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Exit time cannot be before entry time';
        END IF;
        
        -- Auto-calculate fee if not set
        IF NEW.total_fee IS NULL THEN
            SELECT parking_fees_amount INTO @hourly_rate
            FROM Parking_Fees pf
            JOIN Parking_Slots ps ON pf.parking_fees_type = ps.parking_slot_type
            WHERE ps.parking_slot_id = NEW.parking_slot_id;
            
            SET NEW.total_fee = @hourly_rate * TIMESTAMPDIFF(HOUR, OLD.entry_time, NEW.exit_time);
        END IF;
    END IF;
END //
DELIMITER ;

-- 8. Trigger to prevent duplicate vehicle registration
DELIMITER //
CREATE TRIGGER before_vehicle_insert
BEFORE INSERT ON Vehicles
FOR EACH ROW
BEGIN
    DECLARE vehicle_count INT;
    
    SELECT COUNT(*) INTO vehicle_count
    FROM Vehicles
    WHERE vehicle_company = NEW.vehicle_company 
    AND vehicle_type = NEW.vehicle_type
    AND vehicle_description = NEW.vehicle_description
    AND vehicle_owner_id = NEW.vehicle_owner_id;
    
    IF vehicle_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'This vehicle is already registered for this customer';
    END IF;
END //
DELIMITER ;