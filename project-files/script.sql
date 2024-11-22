CREATE TABLE Patient (
    patient_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    dob DATE,
    contact_info VARCHAR(255)
);

CREATE TABLE PatientAllergies (
    allergy_id INT PRIMARY KEY,
    allergy_name VARCHAR(100),
    patient_id INT,
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);

CREATE TABLE PatientTreatment (
    treatment_id INT PRIMARY KEY,
    treatment_details VARCHAR(255),
    treatment_date DATE,
    patient_id INT,
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);

CREATE TABLE LabTest (
    test_id INT PRIMARY KEY,
    test_name VARCHAR(100),
    procedure_details VARCHAR(255)
);

CREATE TABLE TestResult (
    result_id INT PRIMARY KEY,
    test_id INT,
    result_description TEXT,
    FOREIGN KEY (test_id) REFERENCES LabTest(test_id)
);

CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    role VARCHAR(50),
    contact_info VARCHAR(255)
);

CREATE TABLE PatientEmployee (
    patient_id INT,
    employee_id INT,
    role VARCHAR(100),
    PRIMARY KEY (patient_id, employee_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);

CREATE TABLE Bed (
    bed_id INT PRIMARY KEY,
    bed_type VARCHAR(50),
    bed_status VARCHAR(50),
    bed_location VARCHAR(100)
);

CREATE TABLE BedAssignment (
    patient_id INT,
    bed_id INT,
    assignment_date DATE,
    PRIMARY KEY (patient_id, bed_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (bed_id) REFERENCES Bed(bed_id)
);

CREATE TABLE Patient_Lab_Test (
    patient_id INT,
    test_id INT,
    PRIMARY KEY (patient_id, test_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (test_id) REFERENCES LabTest(test_id)
);

INSERT INTO Patient (patient_id, first_name, last_name, dob, contact_info) VALUES
(1, 'Liam', 'Miller', '1984-03-15', '1234 Elm St, Atlanta'),
(2, 'Sophia', 'Garcia', '1990-06-22', '5678 Pine St, Woodstock'),
(3, 'Lucas', 'Martinez', '1975-11-11', '9101 Oak St, Roswell'),
(4, 'Emma', 'Taylor', '1988-01-05', '2345 Maple St, Atlanta'),
(5, 'Aiden', 'Wilson', '1995-08-30', '6789 Cedar St, Roswell');

INSERT INTO PatientAllergies (allergy_id, allergy_name, patient_id) VALUES
(1, 'Peanut', 1),
(2, 'Penicillin', 2),
(3, 'Dust', 3),
(4, 'Shellfish', 4),
(5, 'Latex', 5);

INSERT INTO PatientTreatment (treatment_id, treatment_details, treatment_date, patient_id) VALUES
(1, 'Knee Surgery', '2023-01-10', 1),
(2, 'Chemotherapy', '2023-03-15', 2),
(3, 'Physical Therapy', '2023-02-01', 3),
(4, 'Dental Filling', '2023-04-20', 4),
(5, 'Vaccination', '2023-05-10', 5);

INSERT INTO LabTest (test_id, test_name, procedure_details) VALUES
(1, 'Blood Test', 'Complete Blood Count (CBC)'),
(2, 'X-Ray', 'Chest X-Ray'),
(3, 'MRI', 'Magnetic Resonance Imaging'),
(4, 'Ultrasound', 'Abdominal Ultrasound'),
(5, 'CT Scan', 'Head CT Scan');

INSERT INTO TestResult (result_id, test_id, result_description) VALUES
(1, 1, 'Normal CBC levels'),
(2, 2, 'No abnormalities detected'),
(3, 3, 'Minor ligament tear'),
(4, 4, 'Abnormal growth detected'),
(5, 5, 'No signs of brain injury');

INSERT INTO Employee (employee_id, first_name, last_name, role, contact_info) VALUES
(1, 'James', 'Carter', 'Doctor', '555-1234'),
(2, 'Alice', 'Roberts', 'Nurse', '555-5678'),
(3, 'Olivia', 'Moore', 'Doctor', '555-8765'),
(4, 'William', 'Turner', 'Nurse', '555-4321'),
(5, 'Emily', 'Harris', 'Doctor', '555-6789');

INSERT INTO PatientEmployee (patient_id, employee_id, role) VALUES
(1, 1, 'Primary Doctor'),
(1, 2, 'Nurse'),
(2, 3, 'Primary Doctor'),
(3, 4, 'Nurse'),
(4, 5, 'Primary Doctor'),
(5, 1, 'Primary Doctor');

INSERT INTO Bed (bed_id, bed_type, bed_status, bed_location) VALUES
(1, 'ICU', 'Occupied', 'Room 101'),
(2, 'General', 'Occupied', 'Room 102'),
(3, 'General', 'Available', 'Room 103'),
(4, 'ICU', 'Occupied', 'Room 104'),
(5, 'General', 'Occupied', 'Room 105');

INSERT INTO BedAssignment (patient_id, bed_id, assignment_date) VALUES
(1, 1, '2023-01-10'),
(2, 2, '2023-03-15'),
(3, 3, '2023-02-01'),
(4, 4, '2023-04-20'),
(5, 5, '2023-05-10');

INSERT INTO Patient_Lab_Test (patient_id, test_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- List all Patients and what Bed they are assigned to
SELECT p.patient_id, p.first_name, p.last_name, b.bed_id, b.bed_type, b.bed_location
FROM Patient p
LEFT JOIN BedAssignment ba ON p.patient_id = ba.patient_id
LEFT JOIN Bed b ON ba.bed_id = b.bed_id;

--  List all patients who had Treatments and what Treatment they received
SELECT p.patient_id, p.first_name, p.last_name, t.treatment_details, t.treatment_date
FROM Patient p
INNER JOIN PatientTreatment t ON p.patient_id = t.patient_id;

-- List all patients who had tests and what Test they had
SELECT p.patient_id, p.first_name, p.last_name, lt.test_name, tr.result_description
FROM Patient p
INNER JOIN Patient_Lab_Test plt ON p.patient_id = plt.patient_id
INNER JOIN LabTest lt ON plt.test_id = lt.test_id
INNER JOIN TestResult tr ON lt.test_id = tr.test_id;

-- List the employees (doctors, nurses, etc.) who assisted each patient.
SELECT p.patient_id, p.first_name, p.last_name, e.first_name AS employee_first_name, e.last_name AS employee_last_name, pe.role
FROM Patient p
INNER JOIN PatientEmployee pe ON p.patient_id = pe.patient_id
INNER JOIN Employee e ON pe.employee_id = e.employee_id;

-- List all patients in alphabetical order
SELECT patient_id, first_name, last_name
FROM Patient
ORDER BY last_name, first_name;

-- List all patients who live in Atlanta and had a test completed
SELECT p.patient_id, p.first_name, p.last_name, lt.test_name
FROM Patient p
INNER JOIN Patient_Lab_Test plt ON p.patient_id = plt.patient_id
INNER JOIN LabTest lt ON plt.test_id = lt.test_id
WHERE p.contact_info LIKE '%Atlanta%';

-- List all patients who live in either Woodstock or Roswell who had a treatment completed.
SELECT p.patient_id, p.first_name, p.last_name, t.treatment_details
FROM Patient p
INNER JOIN PatientTreatment t ON p.patient_id = t.patient_id
WHERE p.contact_info LIKE '%Woodstock%' OR p.contact_info LIKE '%Roswell%';



