# Clinic Booking System - Database README

## Project Title
**Clinic Booking System Database**

## Description
This project is a comprehensive MySQL database for managing a medical clinic's operations, including patient appointments, doctor schedules, medical records, and billing. The database supports:

- Patient registration and management
- Doctor information and specialization tracking
- Appointment scheduling with rooms assignment
- Medical records linked to appointments
- Billing and payment tracking
- Clinic staff management

The database is designed with proper relationships, constraints, and sample data to demonstrate a fully functional clinic management system.

## Setup Instructions

### Prerequisites
- MySQL Server (version 5.7 or higher recommended)
- MySQL client or workbench (optional)

### Installation

#### Method 1: Using MySQL Command Line
1. Open your MySQL command line client
2. Run the entire SQL script provided to:
   - Create the database
   - Create all tables with relationships
   - Insert sample data
   - Create indexes for performance

```bash
mysql -u [username] -p < clinic_booking_system.sql
```

#### Method 2: Using MySQL Workbench
1. Open MySQL Workbench and connect to your server
2. Create a new SQL tab
3. Copy and paste the entire SQL script
4. Execute the script (click the lightning bolt icon or press Ctrl+Enter)

### Verification
After successful installation, you can verify the database by running:

```sql
USE clinic_booking_system;
SHOW TABLES;
SELECT * FROM patients LIMIT 5;
```

## Database Structure
The database contains these main tables:
- `patients` - Stores patient information
- `doctors` - Manages doctor details and specializations
- `appointments` - Tracks all scheduled appointments
- `medical_records` - Stores patient medical history
- `billing` - Handles financial transactions
- `rooms` - Manages clinic rooms and facilities
- `clinic_staff` - Stores non-doctor staff information

## Sample Queries

1. Get all upcoming appointments:
```sql
SELECT a.appointment_id, p.first_name, p.last_name, d.first_name AS doctor_first, 
       d.last_name AS doctor_last, a.appointment_date, a.start_time, a.end_time
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
WHERE a.appointment_date >= CURRENT_DATE()
ORDER BY a.appointment_date, a.start_time;
```

2. Find available doctors by specialization:
```sql
SELECT d.doctor_id, d.first_name, d.last_name, s.name AS specialization
FROM doctors d
JOIN doctor_specialization ds ON d.doctor_id = ds.doctor_id
JOIN specializations s ON ds.specialization_id = s.specialization_id
WHERE d.status = 'Active';
```

## Troubleshooting
If you encounter any errors during setup:
1. Check your MySQL version (`SELECT VERSION();`)
2. Verify you have sufficient privileges to create databases
3. Ensure no syntax errors were introduced when copying the script
4. For constraint errors, check the table creation order in the script

## License
This database schema is provided as a personal project purposes. Feel free to modify and use it in your projects.
