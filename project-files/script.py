import sqlite3

# Connecting the SQLite database to our script
conn = sqlite3.connect('database.db')
cursor = conn.cursor()

# Fetch all patients
cursor.execute("SELECT patient_id, first_name, last_name, dob, contact_info FROM Patient")
patients = cursor.fetchall()

# Get patient allergies
cursor.execute("SELECT allergy_id, allergy_name, patient_id FROM PatientAllergies")
allergies = cursor.fetchall()

# Print 'Patient' table
print("Patient Table:")
print("-----------------------------------------------------")
print("{:<10} {:<20} {:<20} {:<12} {:<30}".format('Patient ID', 'First Name', 'Last Name', 'Date of Birth', 'Contact Info'))
print("------------------------------------------------------")
for patient in patients:
    patient_id, first_name, last_name, dob, contact_info = patient
    print("{:<10} {:<20} {:<20} {:<12} {:<30}".format(patient_id, first_name, last_name, dob, contact_info))
print("------------------------------------------------------\n")

# Print 'PatientAllergies' table
print("Patient Allergies Table:")
print("------------------------------------------------------")
print("{:<12} {:<20} {:<10}".format('Allergy ID', 'Allergy Name', 'Patient ID'))
print("------------------------------------------------------")
for allergy in allergies:
    allergy_id, allergy_name, patient_id = allergy
    print("{:<12} {:<20} {:<10}".format(allergy_id, allergy_name, patient_id))
print("------------------------------------------------------")


conn.close()
