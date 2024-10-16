create database hospital;
use hospital;
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DateOfBirth DATE,
    Gender VARCHAR(10),
    PhoneNumber VARCHAR(15)
);
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Specialization VARCHAR(100),
    PhoneNumber VARCHAR(15)
);
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATE,
    ReasonForVisit VARCHAR(255),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID));
INSERT INTO Patients (FirstName, LastName, DateOfBirth, Gender, PhoneNumber) VALUES
('John', 'Doe', '1985-06-15', 'Male', '123-456-7890'),
('Jane', 'Smith', '1990-08-22', 'Female', '234-567-8901'),
('Michael', 'Johnson', '1975-12-10', 'Male', '345-678-9012'),
('Emily', 'Davis', '2001-02-25', 'Female', '456-789-0123'),
('Robert', 'Brown', '1980-11-30', 'Male', '567-890-1234'),
('Linda', 'White', '1965-07-18', 'Female', '678-901-2345');
INSERT INTO Doctors (FirstName, LastName, Specialization, PhoneNumber) VALUES
('Emily', 'Clark', 'Cardiologist', '123-456-7890'),
('David', 'Lee', 'Pediatrician', '234-567-8901'),
('Sarah', 'Kim', 'Dermatologist', '345-678-9012'),
('James', 'Taylor', 'Orthopedic Surgeon', '456-789-0123'),
('Lisa', 'Wilson', 'Neurologist', '567-890-1234'),
('Paul', 'Martin', 'General Practitioner', '678-901-2345');
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, ReasonForVisit)
VALUES
(1, 1, '2024-09-01', 'Chest Pain'),
(2, 2, '2024-09-03', 'Routine Checkup'),
(3, 3, '2024-09-05', 'Skin Rash'),
(4, 4, '2024-09-07', 'Knee Pain'),
(5, 5, '2024-09-10', 'Headaches'),
(6, 6, '2024-09-12', 'General Checkup');
#1,Retrieve the FirstName, LastName, and PhoneNumber of patients who have an appointment with the Cardiologist.
select FirstName, LastName, PhoneNumber from Patients where PatientID in (select PatientID from Appointments where DoctorID = (select DoctorID from Doctors where Specialization = 'Cardiologist'));

#2)Display the FirstName and LastName of doctors who have treated patients with knee pain.
select FirstName, LastName from Doctors where DoctorID in (select DoctorID from Appointments where ReasonForVisit = 'Knee Pain');

#3)Find the FirstName and LastName of patients who had appointments after September 5, 2024.
select FirstName,LastName from Patients where PatientID in(select PatientID from Appointments where AppointmentDate>'2024-09-05');

#4)Retrieve the FirstName, LastName, and Specialization of doctors who are not Dermatologists
select FirstName,LastName from Doctors where Specialization!='Dermatologist';

#5)List all patients (FirstName, LastName) who visited either the General Practitioner or the Pediatrician.
select FirstName, LastName from Patients where PatientID in (select PatientID from Appointments where DoctorID in (select DoctorID from Doctors where Specialization in ('General Practitioner', 'Pediatrician')));

#6)display the details (AppointmentID, AppointmentDate, ReasonForVisit) of all appointments for male patients.
select AppointmentID, AppointmentDate, ReasonForVisit from Appointments where PatientID in(select PatientID from Patients where Gender='male');

#7)Retrieve the FirstName and LastName of patients who have a phone number starting with '123'.
select FirstName,LastName from Patients where PhoneNumber like '%123';

#8)Find the FirstName, LastName, and DateOfBirth of patients who were born in the 1980s.
select FirstName, LastName, DateOfBirth from Patients where DateOfBirth between '1980-01-01' and '1989-12-31';

#9)Show the number of appointments for each doctor.
select DoctorID,count(*) as appointments from Appointments group by DoctorID;

#10)Display the average age of patients who have an appointment on or after '2024-09-01'.
SELECT AVG(TIMESTAMPDIFF(YEAR, DateOfBirth, CURDATE())) AS AverageAge FROM Patients WHERE PatientID IN (SELECT PatientID FROM Appointments WHERE AppointmentDate >= '2024-09-01');

#11)Find the total number of appointments and the earliest appointment date for each patient.
select PatientID, COUNT(*) as Total, MIN(AppointmentDate) as Earliest from Appointments group by PatientID;

#12)Retrieve the FirstName and LastName of patients whose names are either 'John' or 'Jane', but exclude those with 'Smith' as the last name.
select FirstName,LastName from Patients where (FirstName='John' or FirstName='Jane') and LastName!='Smith';

#13)List the patients who have had appointments with more than one different doctor.
select PatientID, COUNT(distinct DoctorID) as NoOfDoc from Appointments group by PatientID having COUNT(distinct DoctorID) > 1;

#14)Change the specialization of the doctor with DoctorID = 5 to 'Endocrinologist'.
update Doctors set Specialization = 'Endocrinologist' where DoctorID = 5;

#15)Rename the Specialization column in the Doctors table to Expertise
alter table doctors rename column Specialization to expertise;

select * from doctors;
#16)Find the DateOfBirth of all patients and display it in the format 'YYYY-MM-DD'.
select DATE_FORMAT(DateOfBirth, '%Y/%m/%d') as FormattedDateOfBirth from Patients;

#17)Find the total number of appointments for patients who were born before '1980-01-01'.
select COUNT(*) as TotalAppointments from Appointments where PatientID in (select PatientID from Patients where DateOfBirth < '1980-01-01');

#18)Determine the number of doctors with the specialization 'Cardiologist'.
select COUNT(*) as NumberOfCardiologists from Doctors where expertise = 'Cardiologist';

#19)Find the DoctorID of doctors who have the highest number of appointments.
select DoctorID from Appointments group BY DoctorID having COUNT(AppointmentID) = (select MAX(AppointmentCount)from (select DoctorID, COUNT(AppointmentID) AS AppointmentCount from Appointments GROUP BY DoctorID) AS AppointmentCounts);

#20)List all patients who do not have any appointments.
select  * from Patients where PatientID not in (select distinct PatientID from Appointments);

#21)Find the AppointmentDate and ReasonForVisit of the most recent appointment for each patient.
select a.PatientID, a.AppointmentDate, a.ReasonForVisit from Appointments a where a.AppointmentDate = (select MAX(AppointmentDate)from Appointments WHERE PatientID = a.PatientID);

#22)Display the PatientID and the total number of appointments for each patient who has had at least 3 appointments.
select PatientID, COUNT(AppointmentID) as TotalAppointments from Appointments group by PatientID having COUNT(AppointmentID) >= 3;

#23)Retrieve the names of patients who have a 'Routine Checkup' reason for their visits and whose total number of appointments exceeds the average number of appointments for all patients with 'Routine Checkup'.
SELECT p.FirstName, p.LastName, COUNT(a.AppointmentID) AS TotalAppointments FROM Patients p JOIN Appointments a ON p.PatientID = a.PatientID WHERE a.ReasonForVisit = 'Routine Checkup'GROUP BY p.PatientID HAVING COUNT(a.AppointmentID) > (SELECT AVG(AppointmentCount)FROM (SELECT PatientID, COUNT(AppointmentID) AS AppointmentCount FROM Appointments WHERE ReasonForVisit = 'Routine Checkup'GROUP BY PatientID) AS RoutineCheckupAppointments);

#24)Retrieve the names of patients who have a date of birth before '1980-01-01' and have had more appointments than the average number of appointments per patient.
SELECT p.FirstName, p.LastName, COUNT(a.AppointmentID) AS TotalAppointments FROM Patients p JOIN Appointments a ON p.PatientID = a.PatientID WHERE p.DateOfBirth < '1980-01-01' GROUP BY p.PatientID HAVING COUNT(a.AppointmentID) > (SELECT AVG(AppointmentCount)FROM (SELECT PatientID, COUNT(AppointmentID) AS AppointmentCount FROM Appointments GROUP BY PatientID) AS PatientAppointments);

#List all patients who do not have any appointments.
SELECT FirstName, LastName FROM Patients WHERE PatientID NOT IN (SELECT DISTINCT PatientID FROM Appointments);
