create database students;
use students;
CREATE TABLE Student (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    dateofbirth DATE,
    gender VARCHAR(10),
    email VARCHAR(100)
);
CREATE TABLE Courses (
    courseID INT PRIMARY KEY AUTO_INCREMENT,
    coursename VARCHAR(100),
    coursecode VARCHAR(10),
    credits INT
);
CREATE TABLE Enrollments (
    enrollmentID INT PRIMARY KEY AUTO_INCREMENT,
    studentID INT,
    courseID INT,
    enrollmentdate DATE,
    grade CHAR(2),
    FOREIGN KEY (studentID) REFERENCES Students(studentID),
    FOREIGN KEY (courseID) REFERENCES Courses(courseID)
);
INSERT INTO Student (firstname, lastname, dateofbirth, gender, email) 
VALUES 
('john', 'doe', '2005-03-15', 'Male', 'john.doe@example.com'),
('Jane', 'Smith', '2004-07-22', 'Female', 'jane.smith@example.com'),
('Michael', 'Johnson', '2006-11-09', 'Male', 'michael.johnson@example.com');
INSERT INTO Courses (coursename, coursecode, credits) 
VALUES 
('Mathematics', 'MATH101', 3),
('Science', 'SCI102', 4),
('History', 'HIST103', 2);
INSERT INTO Enrollments (studentID, courseID, enrollmentdate, grade) 
VALUES 
(1, 1, '2023-09-01', 'A'),
(1, 2, '2023-09-01', 'B'),
(2, 2, '2023-09-01', 'A'),
(2, 3, '2023-09-01', 'B'),
(3, 1, '2023-09-01', 'C'),
(3, 3, '2023-09-01', 'B');
#1)find students born between January 1, 2004, and December 31, 2005?
SELECT firstname, lastname, dateofbirth from Student where dateofbirth between '2004-01-01' and '2005-12-31';

#2)find students who enrolled in courses between September 1, 2023, and October 1, 2023?
SELECT studentID, courseID, enrollmentdate FROM Enrollments WHERE enrollmentdate BETWEEN '2023-09-01' AND '2023-10-01';

#3)find all students whose StudentID is either 1, 2, or 3?
SELECT firstname, lastname from Student where studentID in (1, 2, 3);

#4)find students whose grades are 'A' or 'B'?
Select studentID, courseID, grade from Enrollments where grade in ('A', 'B');

#5)find students who enrolled in courses between September 1, 2023, and September 30, 2023, and whose first names start with 'J'?
select firstname, lastname, enrollmentdate from Student join Enrollments on Student.studentID = Enrollments.studentID where enrollmentdate between '2023-09-01' and '2023-09-30' and firstname like 'J%';

#6)find all courses that contain the word "Math" in the course name?
select coursename from courses where coursename like '%Math%';

#7)find students whose email addresses end with "example.com"?
select firstname, lastname, email from Student where email like '%example.com';

#8)find the number of students enrolled in each course, only for courses that have more than one student enrolled?
select courseID, COUNT(studentID) AS StudentCount from enrollments group by courseID having COUNT(studentID) > 1;

#9)find the pass/fail status based on the grade in the Enrollments table?
select studentID, courseID, if(grade in ('A', 'B', 'C'), 'Pass', 'Fail') as Statu from Enrollments;

#10)find the letter grades to numerical scores in the Enrollments table?
SELECT studentID, courseID, 
       CASE 
           WHEN Grade = 'A' THEN 'Excellent'
           WHEN Grade = 'B' THEN 'Good'
           WHEN Grade = 'C' THEN 'Satisfactory'
           ELSE 'Needs Improvement'
       END AS Performance FROM Enrollments;

#11)find unique courses in the Enrollments table?
select distinct courseID from Enrollments;

#12)round the average grade of students to two decimal places?
select ROUND(avg(case 
           WHEN Grade = 'A' THEN 4 
           WHEN Grade = 'B' THEN 3 
           WHEN Grade = 'C' THEN 2 
           ELSE 0 END), 2) AS AverageGrade from Enrollments;

#14)Display the StudentID, FirstName, and LastName of students who either have 'A' or 'B' as their grade but are not enrolled in the "Science" course.
select studentID, firstname, lastname from Student where studentID in (select studentID from Enrollments where grade in ('A', 'B'))and studentID not in (select studentID from Enrollments where courseID = (select courseID from Courses where coursename = 'Science'));

#15)Display the CourseID, CourseName, and Credits of courses with more than 3 credits but exclude the "History" course.
SELECT courseID, coursename, credits from Courses where credits > 3 and coursename != 'History';

#16)Display the StudentID, FirstName, and LastName of students who enrolled after January 1, 2023, but are not enrolled in the "Mathematics" course.
select studentID, firstname, lastname from Student where studentID in (select studentID from Enrollments where EnrollmentDate > '2023-01-01')and studentID not in (select studentID from Enrollments where courseID = (select courseID from Courses where coursename = 'Mathematics'));

#17)Display the StudentID, FirstName, and LastName of students whose DateOfBirth is between January 1, 2004, and December 31, 2005, but are not enrolled in any course with more than 4 credits.
select studentID, firstname, lastname from Student where dateofbirth between '2004-01-01' and '2005-12-31'and studentID not in (select studentID from Enrollments where courseID in (select courseID from Courses where credits > 4));

#18)Display the CourseID, CourseName, and Credits of courses with "Math" in the name but exclude courses that have 3 credits
select courseID, coursename, credits from Courses where coursename like '%Math%'and credits != 3;

#19)Display the StudentID, FirstName, and LastName of students who received an 'A' in any course but did not enroll in the "English" course.
select studentID, firstname, lastname from Student where studentID in (select studentID from Enrollments where grade = 'A')and studentID not IN (select studentID from Enrollments where courseID = (select courseID from Courses where coursename = 'English'));

#20)Display the StudentID, FirstName, and LastName of students who enrolled in any course before March 1, 2023, but did not receive a grade of 'C' or 'D'.
select studentID, firstname, lastname from Student where studentID in (select studentID from Enrollments where enrollmentdate < '2023-03-01')and studentID not in (select studentID from Enrollments where grade in ('C', 'D'));

#21)Display the CourseID, CourseName, and Credits of courses that have either 2 or 3 credits but are not named "Science."
select courseID, coursename, credits from Courses where Credits in (2, 3)and coursename != 'Science';

#22)Display the StudentID, FirstName, and LastName of students who were enrolled before September 1, 2023, but were not enrolled in any course with "History" in its name.
SELECT studentID, firstname, lastname FROM Student WHERE studentID IN (SELECT studentID FROM Enrollments WHERE enrollmentdate < '2023-09-01')AND studentID NOT IN (SELECT studentID FROM Enrollments WHERE courseID = (SELECT courseID FROM Courses WHERE coursename LIKE '%History%'));

#23)Display the StudentID, FirstName, and LastName of students who have 'a' in their first name but are not enrolled in the "Mathematics" or "Science" courses.
SELECT studentID, firstname, lastname FROM Student WHERE firstname LIKE '%a%'AND studentID NOT IN (SELECT studentID FROM Enrollments WHERE courseID IN (SELECT courseID FROM Courses WHERE coursename IN ('Mathematics', 'Science')));

