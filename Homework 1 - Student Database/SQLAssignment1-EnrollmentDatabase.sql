USE master;
GO

IF DB_ID('enrollment') IS NOT NULL 
DROP DATABASE enrollment;
GO

CREATE DATABASE enrollment;
GO
USE enrollment;
GO


DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Teachers;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS TeacherCourses;
DROP TABLE IF EXISTS Enrollments;

--ENTITY #1: Students
CREATE TABLE Students
(
StudentID INT PRIMARY KEY,
StudentFirst VARCHAR(50),
StudentLast VARCHAR(50)
);

INSERT INTO Students (StudentID, StudentFirst, StudentLast)
VALUES
('81424', 'Jimmy', 'Erickson'),
('29073', 'Sally', 'Rodriguez'),
('76526', 'Ronald', 'Smith'),
('12345', 'Esther', 'McDonald'),
('52328', 'Parker', 'Williams'),
('82364', 'Amanda', 'Jones'),
('93324', 'Tyler', 'Garcia'),
('78362', 'Meredith', 'Johnson'),
('51255', 'Kyle', 'Nguyen'),
('12829', 'Samantha', 'Davis');
SELECT * FROM Students


--ENTITY #2: Teachers
CREATE TABLE Teachers
(
StaffID INT PRIMARY KEY,
TeacherLast VARCHAR(50)
);

INSERT INTO Teachers (StaffID, TeacherLast)
VALUES
('7156', 'Xiong'),
('1443', 'Anderson'),
('8129', 'Jefferson'),
('3300', 'Carlsen'),
('2064', 'Tran'),
('5967', 'Miller'),
('9722', 'Brown'),
('4971', 'Lee'),
('6398', 'Wilson'),
('2829', 'Baker');
SELECT * FROM Teachers


--ENTITY #3: Courses
CREATE TABLE Courses
(
CourseID INT PRIMARY KEY,
CourseName VARCHAR(100)
);

INSERT INTO Courses (CourseID, CourseName)
VALUES
('923714923', 'Math'),
('923847211', 'Astronomy'),
('230918218', 'Photography'),
('109834625', 'Physics'),
('312905865', 'Lunch'),
('123456789', 'History'),
('623409877', 'Spanish'),
('412938732', 'Writing'),
('109237463', 'Gym'),
('787123805', 'Painting');
SELECT * FROM Courses

--RELATIONSHIP #1: Which teachers are teaching which courses?
CREATE TABLE TeacherCourses
(
StaffID INT,
CourseID INT,
PRIMARY KEY (StaffID, CourseID),
FOREIGN KEY (StaffID) REFERENCES Teachers(StaffID),
FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

INSERT INTO TeacherCourses (StaffID, CourseID)
VALUES
('3300', '230918218'),
('7156', '923847211'),
('2829', '109237463'),
('9722', '787123805'),
('8129', '109834625'),
('7156', '312905865'),
('6398', '412938732'),
('1443', '623409877'),
('2829', '312905865'),
('5967', '123456789');
SELECT * FROM TeacherCourses


--RELATIONSHIP #2: Which students are enrolled in which classes?
CREATE TABLE Enrollments
(
EnrollmentID INT PRIMARY KEY,
StudentID INT,
CourseID INT,
FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID)
VALUES
('1', '82364', '923847211'),
('2', '52328', '312905865'),
('3', '12829', '623409877'),
('4', '29073', '109237463'),
('5', '51255', '787123805'),
('6', '78362', '123456789'),
('7', '81424', '412938732'),
('8', '82364', '230918218'),
('9', '51255', '312905865'),
('10','76526', '787123805');
SELECT * FROM Enrollments


--QUERY #1: Which students are enrolled in "lunch"?
SELECT StudentFirst, StudentLast, CourseName
FROM Students
JOIN Enrollments ON Students.StudentID = Enrollments.StudentID
JOIN Courses ON Enrollments.CourseID = Courses.CourseID
WHERE CourseName = 'Lunch';


--QUERY #2: Who are the instructors for each course?
SELECT CourseName, TeacherLast
FROM Teachers
JOIN TeacherCourses ON Teachers.StaffID = TeacherCourses.StaffID
JOIN Courses ON TeacherCourses.CourseID = Courses.CourseID;


--QUERY #3: How many students are each teacher teaching?
SELECT TeacherLast, COUNT(StudentID) AS StudentCount
FROM Teachers
JOIN TeacherCourses ON Teachers.StaffID = TeacherCourses.StaffID
JOIN Enrollments ON TeacherCourses.CourseID = Enrollments.CourseID
GROUP BY TeacherLast;
