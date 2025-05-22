-- Hotel Management System Database
-- Created: May 20, 2025

-- Drop database if it exists
DROP DATABASE IF EXISTS hotel_management;

-- Create database
CREATE DATABASE hotel_management;

-- Use the database
USE hotel_management;

-- -----------------------------------------------------
-- Table structure for departments
-- -----------------------------------------------------
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table structure for employees
-- -----------------------------------------------------
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    department_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    position VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10, 2),
    address VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(20),
    country VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table structure for room_types
-- -----------------------------------------------------
CREATE TABLE room_types (
    room_type_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    base_price DECIMAL(10, 2) NOT NULL,
    capacity INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table structure for room_amenities
-- -----------------------------------------------------
CREATE TABLE room_amenities (
    amenity_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    icon VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table structure for rooms
-- -----------------------------------------------------
CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    room_type_id INT NOT NULL,
    floor_number INT NOT NULL,
    square_feet INT,
    max_occupancy INT NOT NULL,
    is_smoking BOOLEAN DEFAULT FALSE,
    status ENUM('Available', 'Occupied', 'Maintenance', 'Cleaning', 'Reserved') DEFAULT 'Available',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table structure for room_amenity_mapping (M:M relationship)
-- -----------------------------------------------------
CREATE TABLE room_amenity_mapping (
    room_id INT NOT NULL,
    amenity_id INT NOT NULL,
    PRIMARY KEY (room_id, amenity_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    FOREIGN KEY (amenity_id) REFERENCES room_amenities(amenity_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table structure for guests
-- -----------------------------------------------------
CREATE TABLE guests (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(20),
    country VARCHAR(50),
    id_type ENUM('Passport', 'Driver License', 'ID Card', 'Other'),
    id_number VARCHAR(50),
    date_of_birth DATE,
    vip_status BOOLEAN DEFAULT FALSE,
    loyalty_points INT DEFAULT 0,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table structure for payment_methods
-- -----------------------------------------------------
CREATE TABLE payment_methods (
    payment_method_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table structure for reservations
-- -----------------------------------------------------
CREATE TABLE reservations (
    reservation_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT NOT NULL,
    reservation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    adults INT NOT NULL DEFAULT 1,
    children INT DEFAULT 0,
    status ENUM('Confirmed', 'Checked-in', 'Checked-out', 'Cancelled', 'No-show') DEFAULT 'Confirmed',
    source ENUM('Direct', 'Website', 'Phone', 'Email', 'Walk-in', 'Third-party') DEFAULT 'Direct',
    special_requests TEXT,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id),
    FOREIGN KEY (created_by) REFERENCES employees(employee_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table structure for reservation_rooms (M:M relationship)
-- -----------------------------------------------------
CREATE TABLE reservation_rooms (
    reservation_room_id INT PRIMARY KEY AUTO_INCREMENT,
    reservation_id INT NOT NULL,
    room_id INT NOT NULL,
    rate_per_night DECIMAL(10, 2) NOT NULL,
    discount_percent DECIMAL(5, 2) DEFAULT 0.00,
    total_price DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table structure for invoices
-- -----------------------------------------------------
CREATE TABLE invoices (
    invoice_id INT PRIMARY KEY AUTO_INCREMENT,
    reservation_id INT NOT NULL,
    invoice_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    due_date DATE,
    total_amount DECIMAL(10, 2) NOT NULL,
    paid_amount DECIMAL(10, 2) DEFAULT 0.00,
    payment_method_id INT,
    payment_date DATETIME,
    status ENUM('Pending', 'Paid', 'Partially Paid', 'Cancelled', 'Refunded') DEFAULT 'Pending',
    notes TEXT,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(payment_method_id),
    FOREIGN KEY (created_by) REFERENCES employees(employee_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table structure for services
-- -----------------------------------------------------
CREATE TABLE services (
    service_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    department_id INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table structure for service_orders
-- -----------------------------------------------------
CREATE TABLE service_orders (
    service_order_id INT PRIMARY KEY AUTO_INCREMENT,
    reservation_id INT NOT NULL,
    service_id INT NOT NULL,
    employee_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    quantity INT NOT NULL DEFAULT 1,
    price DECIMAL(10, 2) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('Pending', 'In Progress', 'Completed', 'Cancelled') DEFAULT 'Pending',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id),
    FOREIGN KEY (service_id) REFERENCES services(service_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table structure for invoice_items
-- -----------------------------------------------------
CREATE TABLE invoice_items (
    invoice_item_id INT PRIMARY KEY AUTO_INCREMENT,
    invoice_id INT NOT NULL,
    item_type ENUM('Room', 'Service', 'Tax', 'Discount', 'Other') NOT NULL,
    description VARCHAR(255) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    reservation_room_id INT,
    service_order_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id),
    FOREIGN KEY (reservation_room_id) REFERENCES reservation_rooms(reservation_room_id),
    FOREIGN KEY (service_order_id) REFERENCES service_orders(service_order_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table structure for maintenance_requests
-- -----------------------------------------------------
CREATE TABLE maintenance_requests (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    room_id INT NOT NULL,
    reported_by INT,
    assigned_to INT,
    issue_description TEXT NOT NULL,
    priority ENUM('Low', 'Medium', 'High', 'Critical') DEFAULT 'Medium',
    status ENUM('Reported', 'In Progress', 'Completed', 'Verified', 'Cancelled') DEFAULT 'Reported',
    reported_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    assigned_date DATETIME,
    completed_date DATETIME,
    resolution_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    FOREIGN KEY (reported_by) REFERENCES employees(employee_id),
    FOREIGN KEY (assigned_to) REFERENCES employees(employee_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table structure for housekeeping_schedule
-- -----------------------------------------------------
CREATE TABLE housekeeping_schedule (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    room_id INT NOT NULL,
    employee_id INT,
    scheduled_date DATE NOT NULL,
    status ENUM('Pending', 'In Progress', 'Completed', 'Verified', 'Skipped') DEFAULT 'Pending',
    notes TEXT,
    start_time DATETIME,
    end_time DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table structure for inventory_categories
-- -----------------------------------------------------
CREATE TABLE inventory_categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    parent_category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_category_id) REFERENCES inventory_categories(category_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table structure for inventory_items
-- -----------------------------------------------------
CREATE TABLE inventory_items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    unit VARCHAR(20) NOT NULL,
    quantity_in_stock INT NOT NULL DEFAULT 0,
    reorder_level INT NOT NULL DEFAULT 10,
    cost_per_unit DECIMAL(10, 2) NOT NULL,
    supplier VARCHAR(100),
    last_ordered_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES inventory_categories(category_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table structure for inventory_transactions
-- -----------------------------------------------------
CREATE TABLE inventory_transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    item_id INT NOT NULL,
    transaction_type ENUM('Purchase', 'Consumption', 'Adjustment', 'Return') NOT NULL,
    quantity INT NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    department_id INT,
    room_id INT,
    employee_id INT NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES inventory_items(item_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table structure for promotions
-- -----------------------------------------------------
CREATE TABLE promotions (
    promotion_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    discount_type ENUM('Percentage', 'Fixed Amount') NOT NULL,
    discount_value DECIMAL(10, 2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    min_stay INT,
    room_type_id INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id),
    FOREIGN KEY (created_by) REFERENCES employees(employee_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table structure for reservation_promotions (M:M relationship)
-- -----------------------------------------------------
CREATE TABLE reservation_promotions (
    reservation_id INT NOT NULL,
    promotion_id INT NOT NULL,
    discount_amount DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (reservation_id, promotion_id),
    FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id),
    FOREIGN KEY (promotion_id) REFERENCES promotions(promotion_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table structure for feedback
-- -----------------------------------------------------
CREATE TABLE feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    reservation_id INT,
    guest_id INT NOT NULL,
    rating INT NOT NULL,
    comments TEXT,
    feedback_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    category ENUM('Room', 'Service', 'Cleanliness', 'Food', 'Staff', 'Overall', 'Other'),
    status ENUM('New', 'In Review', 'Addressed', 'Closed') DEFAULT 'New',
    response TEXT,
    responded_by INT,
    response_date DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id),
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id),
    FOREIGN KEY (responded_by) REFERENCES employees(employee_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table structure for room_pricing_history
-- -----------------------------------------------------
CREATE TABLE room_pricing_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    room_type_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    reason VARCHAR(255),
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id),
    FOREIGN KEY (created_by) REFERENCES employees(employee_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Triggers
-- -----------------------------------------------------

-- Update total_price in reservation_rooms when rate or discount changes
DELIMITER //
CREATE TRIGGER update_reservation_room_total_price
BEFORE INSERT ON reservation_rooms
FOR EACH ROW
BEGIN
    SET NEW.total_price = NEW.rate_per_night * (1 - NEW.discount_percent / 100);
END //
DELIMITER ;

-- Update total_price in reservation_rooms when rate or discount changes during update
DELIMITER //
CREATE TRIGGER update_reservation_room_total_price_on_update
BEFORE UPDATE ON reservation_rooms
FOR EACH ROW
BEGIN
    SET NEW.total_price = NEW.rate_per_night * (1 - NEW.discount_percent / 100);
END //
DELIMITER ;

-- Update service_orders total_amount when price or quantity changes
DELIMITER //
CREATE TRIGGER update_service_order_total_amount
BEFORE INSERT ON service_orders
FOR EACH ROW
BEGIN
    SET NEW.total_amount = NEW.price * NEW.quantity;
END //
DELIMITER ;

-- Update service_orders total_amount when price or quantity changes during update
DELIMITER //
CREATE TRIGGER update_service_order_total_amount_on_update
BEFORE UPDATE ON service_orders
FOR EACH ROW
BEGIN
    SET NEW.total_amount = NEW.price * NEW.quantity;
END //
DELIMITER ;

-- Update inventory_items stock level on transaction
DELIMITER //
CREATE TRIGGER update_inventory_on_transaction
AFTER INSERT ON inventory_transactions
FOR EACH ROW
BEGIN
    IF NEW.transaction_type = 'Purchase' OR NEW.transaction_type = 'Return' THEN
        UPDATE inventory_items
        SET quantity_in_stock = quantity_in_stock + NEW.quantity
        WHERE item_id = NEW.item_id;
    ELSEIF NEW.transaction_type = 'Consumption' OR NEW.transaction_type = 'Adjustment' THEN
        UPDATE inventory_items
        SET quantity_in_stock = quantity_in_stock - NEW.quantity
        WHERE item_id = NEW.item_id;
    END IF;
END //
DELIMITER ;

-- -----------------------------------------------------
-- Create indexes to improve query performance
-- -----------------------------------------------------
CREATE INDEX idx_employees_department ON employees(department_id);
CREATE INDEX idx_rooms_room_type ON rooms(room_type_id);
CREATE INDEX idx_reservations_guest ON reservations(guest_id);
CREATE INDEX idx_reservations_dates ON reservations(check_in_date, check_out_date);
CREATE INDEX idx_reservation_rooms_reservation ON reservation_rooms(reservation_id);
CREATE INDEX idx_reservation_rooms_room ON reservation_rooms(room_id);
CREATE INDEX idx_invoices_reservation ON invoices(reservation_id);
CREATE INDEX idx_service_orders_reservation ON service_orders(reservation_id);
CREATE INDEX idx_service_orders_service ON service_orders(service_id);
CREATE INDEX idx_invoice_items_invoice ON invoice_items(invoice_id);
CREATE INDEX idx_maintenance_requests_room ON maintenance_requests(room_id);
CREATE INDEX idx_housekeeping_schedule_room ON housekeeping_schedule(room_id);
CREATE INDEX idx_inventory_items_category ON inventory_items(category_id);
CREATE INDEX idx_inventory_transactions_item ON inventory_transactions(item_id);
CREATE INDEX idx_feedback_reservation ON feedback(reservation_id);
CREATE INDEX idx_feedback_guest ON feedback(guest_id);

-- -----------------------------------------------------
-- Insert default data
-- -----------------------------------------------------

-- Insert departments
INSERT INTO departments (name, description) VALUES 
('Front Desk', 'Handles check-ins, check-outs, and guest inquiries'),
('Housekeeping', 'Responsible for room cleaning and maintenance'),
('Food & Beverage', 'Manages restaurant and room service'),
('Maintenance', 'Handles repairs and facility upkeep'),
('Management', 'Oversees hotel operations');

-- Insert room types
INSERT INTO room_types (name, description, base_price, capacity) VALUES 
('Standard', 'Basic room with essential amenities', 100.00, 2),
('Deluxe', 'Larger room with additional amenities', 150.00, 2),
('Suite', 'Separate living area and bedroom', 250.00, 4),
('Executive Suite', 'Premium suite with luxury amenities', 350.00, 4),
('Presidential Suite', 'Ultimate luxury accommodation', 500.00, 6);

-- Insert room amenities
INSERT INTO room_amenities (name, description) VALUES 
('Wi-Fi', 'High-speed wireless internet'),
('TV', 'Flat-screen television'),
('Mini Bar', 'In-room refrigerator with beverages'),
('Air Conditioning', 'Climate control system'),
('Safe', 'In-room safe for valuables'),
('Coffee Maker', 'In-room coffee brewing facility'),
('Bathtub', 'Private bathtub'),
('Shower', 'Private shower'),
('Hair Dryer', 'In-room hair dryer'),
('Workspace', 'Desk and chair for working');

-- Insert payment methods
INSERT INTO payment_methods (name) VALUES 
('Cash'),
('Credit Card'),
('Debit Card'),
('Bank Transfer'),
('Online Payment'),
('Mobile Payment');

-- Insert services
INSERT INTO services (name, description, price, department_id) VALUES 
('Room Cleaning', 'Standard room cleaning service', 0.00, 2),
('Laundry Service', 'Clothes washing and ironing', 25.00, 2),
('Room Service', 'Food delivery to room', 15.00, 3),
('Breakfast Buffet', 'Morning breakfast buffet', 20.00, 3),
('Airport Shuttle', 'Transportation to/from airport', 50.00, 1),
('Spa Service', 'Massage and wellness treatments', 80.00, 2),
('Concierge Service', 'Assistance with bookings and recommendations', 0.00, 1);

-- Insert inventory categories
INSERT INTO inventory_categories (name, description) VALUES 
('Toiletries', 'Bathroom supplies for guests'),
('Linens', 'Bed sheets, towels, and pillow cases'),
('Cleaning Supplies', 'Products used for room cleaning'),
('Food & Beverage', 'Items for restaurant and mini bar'),
('Office Supplies', 'Items used by administrative staff');

-- Create example rooms (10 rooms total, 2 of each type)
INSERT INTO rooms (room_number, room_type_id, floor_number, max_occupancy, is_smoking) VALUES 
('101', 1, 1, 2, false),
('102', 1, 1, 2, false),
('201', 2, 2, 2, false),
('202', 2, 2, 2, false),
('301', 3, 3, 4, false),
('302', 3, 3, 4, false),
('401', 4, 4, 4, false),
('402', 4, 4, 4, false),
('501', 5, 5, 6, false),
('502', 5, 5, 6, false);

-- Map amenities to rooms
-- Standard rooms have basic amenities
INSERT INTO room_amenity_mapping (room_id, amenity_id) VALUES 
(1, 1), (1, 2), (1, 4), (1, 8), (1, 9),
(2, 1), (2, 2), (2, 4), (2, 8), (2, 9);

-- Deluxe rooms have more amenities
INSERT INTO room_amenity_mapping (room_id, amenity_id) VALUES 
(3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (3, 8), (3, 9), (3, 10),
(4, 1), (4, 2), (4, 3), (4, 4), (4, 5), (4, 8), (4, 9), (4, 10);

-- Suites have most amenities
INSERT INTO room_amenity_mapping (room_id, amenity_id) VALUES 
(5, 1), (5, 2), (5, 3), (5, 4), (5, 5), (5, 6), (5, 7), (5, 8), (5, 9), (5, 10),
(6, 1), (6, 2), (6, 3), (6, 4), (6, 5), (6, 6), (6, 7), (6, 8), (6, 9), (6, 10);

-- Executive suites have all amenities
INSERT INTO room_amenity_mapping (room_id, amenity_id) VALUES 
(7, 1), (7, 2), (7, 3), (7, 4), (7, 5), (7, 6), (7, 7), (7, 8), (7, 9), (7, 10),
(8, 1), (8, 2), (8, 3), (8, 4), (8, 5), (8, 6), (8, 7), (8, 8), (8, 9), (8, 10);

-- Presidential suites have all amenities
INSERT INTO room_amenity_mapping (room_id, amenity_id) VALUES 
(9, 1), (9, 2), (9, 3), (9, 4), (9, 5), (9, 6), (9, 7), (9, 8), (9, 9), (9, 10),
(10, 1), (10, 2), (10, 3), (10, 4), (10, 5), (10, 6), (10, 7), (10, 8), (10, 9), (10, 10);

-- Create a promotion for off-season discount
INSERT INTO promotions (name, description, discount_type, discount_value, start_date, end_date, min_stay) VALUES 
('Off-Season Special', '15% discount for stays during off-season period', 'Percentage', 15.00, '2025-05-01', '2025-09-30', 2),
('Weekend Getaway', '10% discount for weekend stays', 'Percentage', 10.00, '2025-01-01', '2025-12-31', 2),
('Extended Stay', 'Discount for stays longer than 7 days', 'Percentage', 20.00, '2025-01-01', '2025-12-31', 7);

-- Create some inventory items
INSERT INTO inventory_items (category_id, name, description, unit, quantity_in_stock, reorder_level, cost_per_unit, supplier) VALUES 
(1, 'Shampoo', 'Individual-sized bottles', 'Bottle', 500, 100, 1.50, 'Amenities Supplier Inc.'),
(1, 'Soap', 'Hand soap bars', 'Bar', 600, 120, 1.00, 'Amenities Supplier Inc.'),
(2, 'Bed Sheets', 'Queen-sized bed sheets', 'Set', 200, 50, 25.00, 'Linen Master Ltd.'),
(2, 'Bath Towels', 'Large bath towels', 'Piece', 400, 80, 12.00, 'Linen Master Ltd.'),
(3, 'All-Purpose Cleaner', 'General surface cleaner', 'Bottle', 100, 20, 5.00, 'CleanPro Supplies'),
(3, 'Glass Cleaner', 'For windows and mirrors', 'Bottle', 80, 20, 4.50, 'CleanPro Supplies'),
(4, 'Coffee', 'Ground coffee for in-room coffee makers', 'Packet', 1000, 200, 0.75, 'Gourmet Foods Inc.'),
(5, 'Printer Paper', 'A4 size paper for office printers', 'Ream', 50, 10, 4.00, 'Office Supplies Co.');