# DB_assignmentWeek-_8

Hotel Management System Database
Project Overview
This project is a comprehensive Hotel Management System database implemented in MySQL. It helps to managing all aspects of hotel operations, including:
•	Room management
•	Guest information
•	Reservations
•	Invoicing and billing
•	Services and amenities
•	Staff and departments
•	Maintenance and housekeeping
•	Inventory tracking
•	Promotions and loyalty programs
•	Feedback and reviews
Database Schema
The database consists of multiple interconnected tables that form a complete relational model for hotel management. Key entities:
Core Tables
•	departments: Different hotel departments (Front Desk, Housekeeping, etc.)
•	employees: Staff information and department assignments
•	room_types: Categories of rooms with pricing
•	rooms: Individual hotel rooms with status and features
•	room_amenities: Available amenities for rooms
•	guests: Guest information and loyalty data
•	reservations: Booking information and status
•	invoices: Financial transactions and payment records
Supporting Tables
•	service_orders: Services requested by guests
•	maintenance_requests: Room maintenance tracking
•	housekeeping_schedule: Room cleaning schedules
•	inventory_items: Supplies and stock management
•	promotions: Special offers and discounts
•	feedback: Guest reviews and satisfaction data
Relationship Tables
•	room_amenity_mapping: Maps amenities to rooms (M:M)
•	reservation_rooms: Links reservations to specific rooms (M:M)
•	reservation_promotions: Associates promotions with reservations (M:M)
•	invoice_items: Itemizes charges on invoices
Features
•	Complete Relational Design: All tables are properly linked with foreign keys
•	Data Integrity: Constraints (PK, FK, NOT NULL, UNIQUE) ensures data consistency
•	Automated Calculations: Triggers automatically update derived values
•	Sample Data: Initial records

