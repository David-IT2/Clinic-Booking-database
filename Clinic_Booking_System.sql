-- Clinic Booking System Database
-- Created by: David K
-- Date: 3/05/2025

-- Create database
DROP DATABASE IF EXISTS clinic_booking_system;
CREATE DATABASE clinic_booking_system;
USE clinic_booking_system;

-- 1. Patients table
CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other', 'Prefer not to say') NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) NOT NULL,
    address VARCHAR(200),
    insurance_provider VARCHAR(100),
    insurance_policy_number VARCHAR(50),
    registration_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    CHECK (email LIKE '%@%.%' OR email IS NULL),
    CHECK (YEAR(date_of_birth) BETWEEN 1900 AND 2100)
);
-- 2. Doctors table
CREATE TABLE doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    hire_date DATE NOT NULL,
    status ENUM('Active', 'On Leave', 'Inactive') DEFAULT 'Active',
    CHECK (email LIKE '%@%.%')
);

-- 3. Specializations table
CREATE TABLE specializations (
    specialization_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
);

-- 4. Doctor_Specialization junction table (M-M relationship)
CREATE TABLE doctor_specialization (
    doctor_id INT NOT NULL,
    specialization_id INT NOT NULL,
    PRIMARY KEY (doctor_id, specialization_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (specialization_id) REFERENCES specializations(specialization_id) ON DELETE CASCADE
);

-- 5. Appointments table
CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Cancelled', 'No-Show') DEFAULT 'Scheduled',
    reason TEXT,
    notes TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE RESTRICT,
    CHECK (end_time > start_time)
    -- Removed the date check constraint
);

-- 6. Medical_records table
CREATE TABLE medical_records (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_id INT,
    diagnosis TEXT,
    treatment TEXT,
    prescription TEXT,
    notes TEXT,
    record_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE RESTRICT,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE SET NULL
);

-- 7. Clinic_staff table
CREATE TABLE clinic_staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    hire_date DATE NOT NULL,
    status ENUM('Active', 'On Leave', 'Inactive') DEFAULT 'Active',
    CHECK (email LIKE '%@%.%')
);

-- 8. Rooms table
CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(20) UNIQUE NOT NULL,
    room_type ENUM('Consultation', 'Examination', 'Procedure', 'Operating') NOT NULL,
    description TEXT
);

-- 9. Appointment_rooms table (relationship between appointments and rooms)
CREATE TABLE appointment_rooms (
    appointment_id INT NOT NULL,
    room_id INT NOT NULL,
    PRIMARY KEY (appointment_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE RESTRICT
);

-- 10. Billing table
CREATE TABLE billing (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    appointment_id INT,
    total_amount DECIMAL(10,2) NOT NULL,
    paid_amount DECIMAL(10,2) DEFAULT 0.00,
    billing_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    due_date DATE NOT NULL,
    status ENUM('Pending', 'Partially Paid', 'Paid', 'Cancelled') DEFAULT 'Pending',
    payment_method ENUM('Cash', 'Credit Card', 'Insurance', 'Bank Transfer', 'Other'),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE RESTRICT,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE SET NULL,
    CHECK (paid_amount <= total_amount),
    CHECK (due_date >= billing_date)
);

-- Insert sample data

-- Specializations
INSERT INTO specializations (name, description) VALUES
('Cardiology', 'Heart and cardiovascular system specialist'),
('Dermatology', 'Skin, hair, and nail conditions specialist'),
('Pediatrics', 'Medical care for infants, children, and adolescents'),
('Orthopedics', 'Musculoskeletal system specialist'),
('Neurology', 'Nervous system disorders specialist');

-- Doctors
INSERT INTO doctors (first_name, last_name, specialization, email, phone, license_number, hire_date, status) VALUES
('Sarah', 'Johnson', 'Cardiology', 's.johnson@clinic.com', '555-1001', 'MD123456', '2018-06-15', 'Active'),
('Michael', 'Chen', 'Dermatology', 'm.chen@clinic.com', '555-1002', 'MD654321', '2019-03-22', 'Active'),
('Emily', 'Wilson', 'Pediatrics', 'e.wilson@clinic.com', '555-1003', 'MD789012', '2020-01-10', 'Active'),
('David', 'Brown', 'Orthopedics', 'd.brown@clinic.com', '555-1004', 'MD345678', '2017-11-05', 'On Leave'),
('Jennifer', 'Lee', 'Neurology', 'j.lee@clinic.com', '555-1005', 'MD901234', '2021-02-18', 'Active');

-- Doctor_Specialization
INSERT INTO doctor_specialization (doctor_id, specialization_id) VALUES
(1, 1), -- Dr. Johnson - Cardiology
(2, 2), -- Dr. Chen - Dermatology
(3, 3), -- Dr. Wilson - Pediatrics
(4, 4), -- Dr. Brown - Orthopedics
(5, 5); -- Dr. Lee - Neurology

-- Patients
INSERT INTO patients (first_name, last_name, date_of_birth, gender, email, phone, address, insurance_provider, insurance_policy_number, registration_date) VALUES
('John', 'Smith', '1985-07-12', 'Male', 'john.smith@email.com', '555-2001', '123 Main St, Anytown', 'HealthCare Plus', 'HC12345678', '2022-01-15'),
('Maria', 'Garcia', '1990-11-25', 'Female', 'maria.garcia@email.com', '555-2002', '456 Oak Ave, Somewhere', 'MediShield', 'MS87654321', '2022-02-20'),
('Robert', 'Johnson', '1978-03-08', 'Male', 'robert.johnson@email.com', '555-2003', '789 Pine Rd, Nowhere', NULL, NULL, '2022-03-10'),
('Lisa', 'Wang', '1995-09-14', 'Female', 'lisa.wang@email.com', '555-2004', '321 Elm St, Anywhere', 'Family Health', 'FH11223344', '2021-11-05'),
('James', 'Davis', '1982-12-30', 'Male', 'james.davis@email.com', '555-2005', '654 Maple Dr, Everywhere', 'HealthCare Plus', 'HC55667788', '2022-04-22');

-- Rooms
INSERT INTO rooms (room_number, room_type, description) VALUES
('101', 'Consultation', 'Standard consultation room'),
('102', 'Consultation', 'Standard consultation room'),
('201', 'Examination', 'Examination room with basic equipment'),
('202', 'Examination', 'Examination room with advanced equipment'),
('301', 'Procedure', 'Minor procedures room'),
('401', 'Operating', 'Operating room for major procedures');

-- Appointments
INSERT INTO appointments (patient_id, doctor_id, appointment_date, start_time, end_time, status, reason) VALUES
(1, 1, DATE_ADD(CURRENT_DATE, INTERVAL 1 DAY), '09:00:00', '09:30:00', 'Scheduled', 'Annual heart checkup'),
(2, 2, DATE_ADD(CURRENT_DATE, INTERVAL 2 DAY), '10:15:00', '10:45:00', 'Scheduled', 'Skin rash evaluation'),
(3, 3, DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY), '14:00:00', '14:30:00', 'Scheduled', 'Child vaccination'),
(4, 4, DATE_ADD(CURRENT_DATE, INTERVAL 1 DAY), '11:30:00', '12:00:00', 'Scheduled', 'Knee pain consultation'),
(5, 5, DATE_ADD(CURRENT_DATE, INTERVAL 4 DAY), '15:45:00', '16:15:00', 'Scheduled', 'Headache evaluation'),
(1, 2, DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY), '10:00:00', '10:30:00', 'Completed', 'Follow-up on skin condition'),
(3, 1, DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), '13:30:00', '14:00:00', 'Completed', 'Heart palpitations');

-- Appointment_rooms
INSERT INTO appointment_rooms (appointment_id, room_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 1),
(6, 2),
(7, 1);

-- Medical_records
INSERT INTO medical_records (patient_id, doctor_id, appointment_id, diagnosis, treatment, prescription, notes) VALUES
(1, 2, 6, 'Mild eczema', 'Moisturizing cream application', 'Hydrocortisone cream 1%, apply twice daily', 'Patient advised to avoid harsh soaps'),
(3, 1, 7, 'Normal sinus rhythm', 'No treatment needed', NULL, 'Palpitations likely due to stress');

-- Clinic_staff
INSERT INTO clinic_staff (first_name, last_name, role, email, phone, hire_date, status) VALUES
('Amanda', 'Taylor', 'Receptionist', 'a.taylor@clinic.com', '555-3001', '2020-05-15', 'Active'),
('Thomas', 'Wilson', 'Nurse', 't.wilson@clinic.com', '555-3002', '2019-08-22', 'Active'),
('Jessica', 'Martinez', 'Administrator', 'j.martinez@clinic.com', '555-3003', '2018-03-10', 'Active'),
('Daniel', 'Anderson', 'Medical Assistant', 'd.anderson@clinic.com', '555-3004', '2021-01-18', 'Active');

-- Billing
INSERT INTO billing (patient_id, appointment_id, total_amount, paid_amount, billing_date, due_date, status, payment_method) VALUES
(1, 6, 150.00, 150.00, DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), 'Paid', 'Credit Card'),
(3, 7, 200.00, 0.00, DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 5 DAY), 'Pending', NULL),
(1, NULL, 75.00, 75.00, DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), 'Paid', 'Insurance');

-- Create indexes for performance
CREATE INDEX idx_appointments_doctor ON appointments(doctor_id);
CREATE INDEX idx_appointments_patient ON appointments(patient_id);
CREATE INDEX idx_appointments_date ON appointments(appointment_date);
CREATE INDEX idx_medical_records_patient ON medical_records(patient_id);
CREATE INDEX idx_billing_patient ON billing(patient_id);
CREATE INDEX idx_billing_status ON billing(status);