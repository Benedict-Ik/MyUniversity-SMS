-- Creating database
CREATE DATABASE [My University]
DROP DATABASE [My University]

-- CREATING TABLES
-- Creating Students Table
CREATE TABLE STUDENTS(
 ID INT PRIMARY KEY IDENTITY(1,1),
 TempID VARCHAR(10) UNIQUE,
 MatricNumber VARCHAR(10) UNIQUE DEFAULT NULL,
 LastName VARCHAR(50) NOT NULL,
 OtherNames VARCHAR(70) NOT NULL,
 Gender Char(1) NOT NULL,
 DateOfBirth date NOT NULL,
 DateOfEntry date NOT NULL,
 Phone VARCHAR(50),
 Address VARCHAR(50),
 Email VARCHAR(50) UNIQUE NOT NULL,
 DepartmentID INT NOT NULL,
 Level INT NOT NULL,
 FOREIGN KEY (DepartmentID) REFERENCES Department(ID),
 FOREIGN KEY (Level) REFERENCES Level(Code)
)

-- Permitting NULL values in UNIQUE columns
ALTER TABLE STUDENTS
ADD CONSTRAINT UQ_STUDENTS_TEMPID_MATRICNUMBER UNIQUE (TempID, MatricNumber) 
DROP CONSTRAINT UQ__STUDENTS__AF1D2E54A178F10D


-- Creating Courses Table
CREATE TABLE COURSES(
	ID INT PRIMARY KEY IDENTITY(1,1),
	Code VARCHAR(7) UNIQUE NOT NULL,
	Name VARCHAR(50) NOT NULL,
	Units INT NOT NULL,
	DepartmentID INT NOT NULL,
	FOREIGN KEY (DepartmentID) REFERENCES Department(ID)
)

SELECT * FROM COURSES
SELECT * FROM STUDENT_COURSE
-- Creating Student_Courses Table
-- Tracks the relationship between students and courses (enrollment data).
CREATE TABLE STUDENT_COURSE(
	StudentID INT NOT NULL,
	CourseID INT NOT NULL,
	SessionID INT NOT NULL,
	SemesterID INT NOT NULL
	PRIMARY KEY(StudentID, CourseID),
	CONSTRAINT FK_Session_Semester
	FOREIGN KEY (SessionID, SemesterID) REFERENCES Session_Semester (SessionID, SemesterID),
	FOREIGN KEY (StudentID) REFERENCES Students(ID),
	FOREIGN KEY (CourseID) REFERENCES Courses(ID)
)

-- Creating Faculty Table
CREATE TABLE FACULTY(
	ID INT PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(20)  NOT NULL
)


-- Creating Department Table
CREATE TABLE DEPARTMENT(
	ID INT PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(50) NOT NULL,
	FacultyID INT NOT NULL,
	FOREIGN KEY (FacultyID) REFERENCES Faculty(ID)
)


-- Creating Class Table
CREATE TABLE LEVEL(
	Code INT PRIMARY KEY,
	Title VARCHAR(10) NOT NULL
)


-- Creating Session Table
CREATE TABLE SESSION(
	ID INT PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(20) UNIQUE NOT NULL,
	StartDate date NOT NULL,
	EndDate date NOT NULL
)

-- Creating Semester Table
CREATE TABLE SEMESTER(
	ID INT PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(20) NOT NULL
)

-- Creating Session_Semester Table
CREATE TABLE SESSION_SEMESTER(
	SessionID INT NOT NULL,
	SemesterID INT NOT NULL,
	PRIMARY KEY(SessionID, SemesterID),
	FOREIGN KEY (SessionID) REFERENCES Session(ID),
	FOREIGN KEY (SemesterID) REFERENCES Semester(ID)
)


-- Creating Lecturers Table
CREATE TABLE LECTURERS(
	ID INT PRIMARY KEY IDENTITY(1,1),
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Email VARCHAR(50) NOT NULL,
	Phone VARCHAR(14) NOT NULL,
	DepartmentID INT NOT NULL,
	FOREIGN KEY (DepartmentID) REFERENCES Department(ID)
)
SELECT * FROM LECTURERS

-- Creating Lecturer_Course Table
CREATE TABLE Lecturer_Course(
	LecturerID INT NOT NULL,
	CourseID INT NOT NULL,
	PRIMARY KEY(LecturerID, CourseID),
	FOREIGN KEY (LecturerID) REFERENCES Lecturers(ID),
	FOREIGN KEY (CourseID) REFERENCES Courses(ID)
)

/* 
	Attendance will be deleted as it is basically redundant as
	Gradebook table has most columns it has
*/

-- Creating Attendance Table
/*
CREATE TABLE ATTENDANCE(
	ID INT PRIMARY KEY IDENTITY(1,1),
	IsPresent BIT NOT NULL,
	Date date NOT NULL,
	StudentID INT NOT NULL,
	CourseID INT NOT NULL,
	Level INT NOT NULL,
	FOREIGN KEY (StudentID) REFERENCES Students(ID),
	FOREIGN KEY (CourseID) REFERENCES Courses(ID),
	FOREIGN KEY (Level) REFERENCES Level(Code)
)
*/

DROP TABLE GRADEBOOK
SELECT * FROM GRADEBOOK
-- Creating Gradebook Table
CREATE TABLE GRADEBOOK(
	ID INT PRIMARY KEY IDENTITY(1,1),
	StudentID INT NOT NULL,
	CourseID INT NOT NULL,
	Level INT NOT NULL,
	CA INT NOT NULL CHECK(CA <= 30),
	Exam INT NOT NULL CHECK(Exam <= 70),
	MarksObtained  AS (CA + Exam) PERSISTED NOT NULL,
	TotalMarks INT NOT NULL DEFAULT 100,
	Grade AS(
		CASE
			WHEN (CA + Exam) IS NULL THEN NULL
			When (CA + Exam) > 69 THEN 'A'
			When (CA + Exam) > 59 THEN 'B'
			When (CA + Exam) > 49 THEN 'C'
			When (CA + Exam) > 44 THEN 'D'
			--When (CA + Exam) > 44 AND (CA + Exam) <50 THEN 'D'
			ELSE 'F'
		END
	) PERSISTED,
	FOREIGN KEY (StudentID) REFERENCES Students(ID),
	FOREIGN KEY (CourseID) REFERENCES Courses(ID),
	FOREIGN KEY (Level) REFERENCES Level(Code)
)


-- Displaying Constraints in STUDENTS table
SELECT 
    tc.TABLE_NAME,
    tc.CONSTRAINT_NAME,
    tc.CONSTRAINT_TYPE,
    kcu.COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc
JOIN 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS kcu
    ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
WHERE 
    tc.TABLE_NAME = 'STUDENTS';



-- POPULATING TABLES
-- Populating FACULTY Table
INSERT INTO FACULTY (Name)
VALUES
('Engineering'),
('Physical Sciences')


SELECT * FROM DEPARTMENT
-- Populating DEPARTMENTS Table
INSERT INTO DEPARTMENT (Name, FacultyID) VALUES
('Computer Science and Engineering', 1),
('Mechanical Engineering', 1),
('Electrical Engineering', 1),
('Civil Engineering', 1),
('Chemical Engineering', 1),
('Physics', 2),
('Mathematics', 2),
('Chemistry', 2),
('Biology', 2),
('Geology', 2);

-- Deleting all records from STUDENTS table and resetting auto-increment counter
-- Delete all records from the table
DELETE FROM STUDENTS;

-- Reset the auto-increment counter
DBCC CHECKIDENT ('STUDENTS', RESEED, 0);


SELECT * FROM STUDENTS
-- Populating STUDENTS Table
-- Computer Science and Engineering (DepartmentID: 1)
INSERT INTO STUDENTS (TempID, MatricNumber, LastName, OtherNames, Gender, DateOfBirth, DateOfEntry, Phone, Address, Email, DepartmentID, Level)
VALUES
(NULL, 'ENG1000001', 'Smith', 'John', 'M', '2001-05-15', '2020-09-01', '08012345678', '123 Engineering Lane', 'john.smith@school.edu', 1, 100),
(NULL, 'ENG1000002', 'Johnson', 'Emily', 'F', '2002-06-20', '2021-09-01', '08012345679', '124 Engineering Lane', 'emily.johnson@school.edu', 1, 100),
(NULL, 'ENG1000003', 'Brown', 'Michael', 'M', '2000-12-14', '2019-09-01', '08012345680', '125 Engineering Lane', 'michael.brown@school.edu', 1, 200),
('TEMP0001', NULL, 'Taylor', 'Sophia', 'F', '2003-08-19', '2022-09-01', '08012345681', '126 Engineering Lane', 'sophia.taylor@school.edu', 1, 200),
(NULL, 'ENG1000004', 'Williams', 'Liam', 'M', '2001-09-10', '2020-09-01', '08012345682', '127 Engineering Lane', 'liam.williams@school.edu', 1, 300),
(NULL, 'ENG1000005', 'Davis', 'Olivia', 'F', '2002-03-05', '2021-09-01', '08012345683', '128 Engineering Lane', 'olivia.davis@school.edu', 1, 300),
('TEMP0002', NULL, 'Martinez', 'Lucas', 'M', '2000-07-11', '2019-09-01', '08012345684', '129 Engineering Lane', 'lucas.martinez@school.edu', 1, 400),
(NULL, 'ENG1000006', 'Garcia', 'Amelia', 'F', '2003-01-23', '2022-09-01', '08012345685', '130 Engineering Lane', 'amelia.garcia@school.edu', 1, 400),
(NULL, 'ENG1000007', 'Anderson', 'Noah', 'M', '2001-02-28', '2020-09-01', '08012345686', '131 Engineering Lane', 'noah.anderson@school.edu', 1, 500),
(NULL, 'ENG1000008', 'Rodriguez', 'Ava', 'F', '2002-11-17', '2021-09-01', '08012345687', '132 Engineering Lane', 'ava.rodriguez@school.edu', 1, 500);

-- Mechanical Engineering (DepartmentID: 2)
INSERT INTO STUDENTS (TempID, MatricNumber, LastName, OtherNames, Gender, DateOfBirth, DateOfEntry, Phone, Address, Email, DepartmentID, Level)
VALUES
(NULL, 'ENG1000009', 'Hernandez', 'James', 'M', '2001-06-04', '2020-09-01', '08012345688', '133 Engineering Lane', 'james.hernandez@school.edu', 2, 100),
(NULL, 'ENG1000010', 'Moore', 'Mia', 'F', '2002-05-19', '2021-09-01', '08012345689', '134 Engineering Lane', 'mia.moore@school.edu', 2, 100),
('TEMP0003', NULL, 'Jackson', 'Alexander', 'M', '2000-09-14', '2019-09-01', '08012345690', '135 Engineering Lane', 'alexander.jackson@school.edu', 2, 200),
(NULL, 'ENG1000011', 'Martin', 'Charlotte', 'F', '2003-04-07', '2022-09-01', '08012345691', '136 Engineering Lane', 'charlotte.martin@school.edu', 2, 200),
(NULL, 'ENG1000012', 'Lee', 'Henry', 'M', '2001-12-25', '2020-09-01', '08012345692', '137 Engineering Lane', 'henry.lee@school.edu', 2, 300),
(NULL, 'ENG1000013', 'Perez', 'Ella', 'F', '2002-08-09', '2021-09-01', '08012345693', '138 Engineering Lane', 'ella.perez@school.edu', 2, 300),
('TEMP0004', NULL, 'Thompson', 'William', 'M', '2000-11-01', '2019-09-01', '08012345694', '139 Engineering Lane', 'william.thompson@school.edu', 2, 400),
(NULL, 'ENG1000014', 'White', 'Sophia', 'F', '2003-03-21', '2022-09-01', '08012345695', '140 Engineering Lane', 'sophia.white@school.edu', 2, 400),
(NULL, 'ENG1000015', 'Lopez', 'Benjamin', 'M', '2001-10-12', '2020-09-01', '08012345696', '141 Engineering Lane', 'benjamin.lopez@school.edu', 2, 500),
(NULL, 'ENG1000016', 'Gonzalez', 'Isabella', 'F', '2002-01-30', '2021-09-01', '08012345697', '142 Engineering Lane', 'isabella.gonzalez@school.edu', 2, 500);

-- Electrical Engineering (DepartmentID: 3)
INSERT INTO STUDENTS (TempID, MatricNumber, LastName, OtherNames, Gender, DateOfBirth, DateOfEntry, Phone, Address, Email, DepartmentID, Level)
VALUES
(NULL, 'ENG1000017', 'Harris', 'Ethan', 'M', '2001-04-20', '2020-09-01', '08012345698', '143 Engineering Lane', 'ethan.harris@school.edu', 3, 100),
(NULL, 'ENG1000018', 'Clark', 'Ava', 'F', '2002-10-15', '2021-09-01', '08012345699', '144 Engineering Lane', 'ava.clark@school.edu', 3, 100),
('TEMP0005', NULL, 'Lewis', 'Logan', 'M', '2000-06-29', '2019-09-01', '08012345700', '145 Engineering Lane', 'logan.lewis@school.edu', 3, 200),
(NULL, 'ENG1000019', 'Young', 'Zoe', 'F', '2003-12-08', '2022-09-01', '08012345701', '146 Engineering Lane', 'zoe.young@school.edu', 3, 200),
(NULL, 'ENG1000020', 'King', 'Luke', 'M', '2001-03-02', '2020-09-01', '08012345702', '147 Engineering Lane', 'luke.king@school.edu', 3, 300),
(NULL, 'ENG1000021', 'Wright', 'Harper', 'F', '2002-07-14', '2021-09-01', '08012345703', '148 Engineering Lane', 'harper.wright@school.edu', 3, 300),
('TEMP0006', NULL, 'Scott', 'Levi', 'M', '2000-05-17', '2019-09-01', '08012345704', '149 Engineering Lane', 'levi.scott@school.edu', 3, 400),
(NULL, 'ENG1000022', 'Green', 'Aria', 'F', '2003-11-23', '2022-09-01', '08012345705', '150 Engineering Lane', 'aria.green@school.edu', 3, 400),
(NULL, 'ENG1000023', 'Adams', 'Mason', 'M', '2001-01-31', '2020-09-01', '08012345706', '151 Engineering Lane', 'mason.adams@school.edu', 3, 500),
(NULL, 'ENG1000024', 'Baker', 'Scarlett', 'F', '2002-09-07', '2021-09-01', '08012345707', '152 Engineering Lane', 'scarlett.baker@school.edu', 3, 500);

-- Civil Engineering (DepartmentID: 4)
INSERT INTO STUDENTS (TempID, MatricNumber, LastName, OtherNames, Gender, DateOfBirth, DateOfEntry, Phone, Address, Email, DepartmentID, Level)
VALUES
(NULL, 'ENG1000025', 'Mitchell', 'Jack', 'M', '2000-04-12', '2019-09-01', '08012345708', '153 Civil Lane', 'jack.mitchell@school.edu', 4, 100),
(NULL, 'ENG1000026', 'Perez', 'Ella', 'F', '2001-11-03', '2020-09-01', '08012345709', '154 Civil Lane', 'ella.perezmartinez@school.edu', 4, 100),
('TEMP0007', NULL, 'Roberts', 'Liam', 'M', '2002-06-24', '2021-09-01', '08012345710', '155 Civil Lane', 'liam.roberts@school.edu', 4, 200),
(NULL, 'ENG1000027', 'Turner', 'Mila', 'F', '2003-09-19', '2022-09-01', '08012345711', '156 Civil Lane', 'mila.turner@school.edu', 4, 200),
(NULL, 'ENG1000028', 'Phillips', 'James', 'M', '2000-02-17', '2019-09-01', '08012345712', '157 Civil Lane', 'james.phillips@school.edu', 4, 300),
(NULL, 'ENG1000029', 'Campbell', 'Ava', 'F', '2001-07-08', '2020-09-01', '08012345713', '158 Civil Lane', 'ava.campbell@school.edu', 4, 300),
('TEMP0008', NULL, 'Parker', 'Lucas', 'M', '2002-05-05', '2021-09-01', '08012345714', '159 Civil Lane', 'lucas.parker@school.edu', 4, 400),
(NULL, 'ENG1000030', 'Evans', 'Lily', 'F', '2003-01-15', '2022-09-01', '08012345715', '160 Civil Lane', 'lily.evans@school.edu', 4, 400),
(NULL, 'ENG1000031', 'Edwards', 'Henry', 'M', '2000-10-30', '2019-09-01', '08012345716', '161 Civil Lane', 'henry.edwards@school.edu', 4, 500),
(NULL, 'ENG1000032', 'Collins', 'Emma', 'F', '2001-12-12', '2020-09-01', '08012345717', '162 Civil Lane', 'emma.collins@school.edu', 4, 500);

-- Chemical Engineering (DepartmentID: 5)
INSERT INTO STUDENTS (TempID, MatricNumber, LastName, OtherNames, Gender, DateOfBirth, DateOfEntry, Phone, Address, Email, DepartmentID, Level)
VALUES
(NULL, 'ENG1000033', 'Stewart', 'Nathan', 'M', '2000-03-14', '2019-09-01', '08012345718', '163 Chemical Lane', 'nathan.stewart@school.edu', 5, 100),
(NULL, 'ENG1000034', 'Sanchez', 'Chloe', 'F', '2001-08-09', '2020-09-01', '08012345719', '164 Chemical Lane', 'chloe.sanchez@school.edu', 5, 100),
('TEMP0009', NULL, 'Morris', 'Daniel', 'M', '2002-04-21', '2021-09-01', '08012345720', '165 Chemical Lane', 'daniel.morris@school.edu', 5, 200),
(NULL, 'ENG1000035', 'Rogers', 'Ella', 'F', '2003-12-03', '2022-09-01', '08012345721', '166 Chemical Lane', 'ella.rogers@school.edu', 5, 200),
(NULL, 'ENG1000036', 'Reed', 'Ethan', 'M', '2000-06-30', '2019-09-01', '08012345722', '167 Chemical Lane', 'ethan.reed@school.edu', 5, 300),
(NULL, 'ENG1000037', 'Cook', 'Scarlett', 'F', '2001-09-27', '2020-09-01', '08012345723', '168 Chemical Lane', 'scarlett.cook@school.edu', 5, 300),
('TEMP0010', NULL, 'Morgan', 'Luke', 'M', '2002-07-18', '2021-09-01', '08012345724', '169 Chemical Lane', 'luke.morgan@school.edu', 5, 400),
(NULL, 'ENG1000038', 'Bell', 'Isabella', 'F', '2003-11-06', '2022-09-01', '08012345725', '170 Chemical Lane', 'isabella.bell@school.edu', 5, 400),
(NULL, 'ENG1000039', 'Murphy', 'James', 'M', '2000-01-05', '2019-09-01', '08012345726', '171 Chemical Lane', 'james.murphy@school.edu', 5, 500),
(NULL, 'ENG1000040', 'Bailey', 'Charlotte', 'F', '2001-10-20', '2020-09-01', '08012345727', '172 Chemical Lane', 'charlotte.bailey@school.edu', 5, 500);

-- Physics (DepartmentID: 6)
INSERT INTO STUDENTS (TempID, MatricNumber, LastName, OtherNames, Gender, DateOfBirth, DateOfEntry, Phone, Address, Email, DepartmentID, Level)
VALUES
(NULL, 'PHY1000001', 'Foster', 'Benjamin', 'M', '2001-03-23', '2020-09-01', '08012345728', '123 Science Lane', 'benjamin.foster@school.edu', 6, 100),
(NULL, 'PHY1000002', 'Griffin', 'Sophia', 'F', '2002-12-14', '2021-09-01', '08012345729', '124 Science Lane', 'sophia.griffin@school.edu', 6, 100),
('TEMP0011', NULL, 'Russell', 'Logan', 'M', '2000-07-11', '2019-09-01', '08012345730', '125 Science Lane', 'logan.russell@school.edu', 6, 100),
(NULL, 'PHY1000003', 'Dean', 'Olivia', 'F', '2003-01-27', '2022-09-01', '08012345731', '126 Science Lane', 'olivia.dean@school.edu', 6, 200),
(NULL, 'PHY1000004', 'Garrett', 'Henry', 'M', '2001-05-16', '2020-09-01', '08012345732', '127 Science Lane', 'henry.garrett@school.edu', 6, 200),
(NULL, 'PHY1000005', 'Webb', 'Mia', 'F', '2002-06-24', '2021-09-01', '08012345733', '128 Science Lane', 'mia.webb@school.edu', 6, 200),
('TEMP0012', NULL, 'Cruz', 'Nathan', 'M', '2000-09-29', '2019-09-01', '08012345734', '129 Science Lane', 'nathan.cruz@school.edu', 6, 300),
(NULL, 'PHY1000006', 'Patterson', 'Zoe', 'F', '2003-02-09', '2022-09-01', '08012345735', '130 Science Lane', 'zoe.patterson@school.edu', 6, 300),
(NULL, 'PHY1000007', 'Mason', 'Aiden', 'M', '2001-08-02', '2020-09-01', '08012345736', '131 Science Lane', 'aiden.mason@school.edu', 6, 400),
(NULL, 'PHY1000008', 'Chavez', 'Ella', 'F', '2002-03-18', '2021-09-01', '08012345737', '132 Science Lane', 'ella.chavez@school.edu', 6, 400);

-- Mathematics (DepartmentID: 7)6INSERT INTO STUDENTS (TempID, MatricNumber, LastName, OtherNames, Gender, DateOfBirth, DateOfEntry, Phone, Address, Email, DepartmentID, Level)
INSERT INTO STUDENTS (TempID, MatricNumber, LastName, OtherNames, Gender, DateOfBirth, DateOfEntry, Phone, Address, Email, DepartmentID, Level)
VALUES
(NULL, 'PHY1000009', 'Hughes', 'Evelyn', 'F', '2001-04-22', '2020-09-01', '08012345738', '201 Math Lane', 'evelyn.hughes@school.edu', 7, 100),
(NULL, 'PHY1000010', 'Price', 'William', 'M', '2000-08-15', '2019-09-01', '08012345739', '202 Math Lane', 'william.price@school.edu', 7, 100),
('TEMP0013', NULL, 'Reynolds', 'Grace', 'F', '2002-12-02', '2021-09-01', '08012345740', '203 Math Lane', 'grace.reynolds@school.edu', 7, 100),
(NULL, 'PHY1000011', 'Sullivan', 'Liam', 'M', '2003-09-14', '2022-09-01', '08012345741', '204 Math Lane', 'liam.sullivan@school.edu', 7, 200),
(NULL, 'PHY1000012', 'Fisher', 'Sophia', 'F', '2001-11-08', '2020-09-01', '08012345742', '205 Math Lane', 'sophia.fisher@school.edu', 7, 200),
(NULL, 'PHY1000013', 'Ward', 'Alexander', 'M', '2002-06-19', '2021-09-01', '08012345743', '206 Math Lane', 'alexander.ward@school.edu', 7, 200),
('TEMP0014', NULL, 'Hunter', 'Emily', 'F', '2000-05-29', '2019-09-01', '08012345744', '207 Math Lane', 'emily.hunter@school.edu', 7, 300),
(NULL, 'PHY1000014', 'Watkins', 'Noah', 'M', '2003-07-04', '2022-09-01', '08012345745', '208 Math Lane', 'noah.watkins@school.edu', 7, 300),
(NULL, 'PHY1000015', 'Gibson', 'Isabella', 'F', '2001-10-17', '2020-09-01', '08012345746', '209 Math Lane', 'isabella.gibson@school.edu', 7, 400),
(NULL, 'PHY1000016', 'Perry', 'Lucas', 'M', '2002-02-24', '2021-09-01', '08012345747', '210 Math Lane', 'lucas.perry@school.edu', 7, 400);

-- Chemistry (DepartmentID: 8)
INSERT INTO STUDENTS (TempID, MatricNumber, LastName, OtherNames, Gender, DateOfBirth, DateOfEntry, Phone, Address, Email, DepartmentID, Level)
VALUES
(NULL, 'PHY1000017', 'Bryant', 'Chloe', 'F', '2001-03-30', '2020-09-01', '08012345748', '301 Chem Lane', 'chloe.bryant@school.edu', 8, 100),
(NULL, 'PHY1000018', 'Alexander', 'Mason', 'M', '2000-07-11', '2019-09-01', '08012345749', '302 Chem Lane', 'mason.alexander@school.edu', 8, 100),
('TEMP0015', NULL, 'Hansen', 'Amelia', 'F', '2002-11-12', '2021-09-01', '08012345750', '303 Chem Lane', 'amelia.hansen@school.edu', 8, 100),
(NULL, 'PHY1000019', 'Harper', 'Ethan', 'M', '2003-01-25', '2022-09-01', '08012345751', '304 Chem Lane', 'ethan.harper@school.edu', 8, 200),
(NULL, 'PHY1000020', 'Beck', 'Scarlett', 'F', '2001-09-08', '2020-09-01', '08012345752', '305 Chem Lane', 'scarlett.beck@school.edu', 8, 200),
(NULL, 'PHY1000021', 'Ward', 'Oliver', 'M', '2002-04-19', '2021-09-01', '08012345753', '306 Chem Lane', 'oliver.ward@school.edu', 8, 200),
('TEMP0016', NULL, 'Day', 'Grace', 'F', '2000-06-01', '2019-09-01', '08012345754', '307 Chem Lane', 'grace.day@school.edu', 8, 300),
(NULL, 'PHY1000022', 'Arnold', 'Henry', 'M', '2003-03-07', '2022-09-01', '08012345755', '308 Chem Lane', 'henry.arnold@school.edu', 8, 300),
(NULL, 'PHY1000023', 'Henderson', 'Lily', 'F', '2001-10-19', '2020-09-01', '08012345756', '309 Chem Lane', 'lily.henderson@school.edu', 8, 400),
(NULL, 'PHY1000024', 'Robinson', 'James', 'M', '2002-12-28', '2021-09-01', '08012345757', '310 Chem Lane', 'james.robinson@school.edu', 8, 400);

-- Biology (DepartmentID: 9)
INSERT INTO STUDENTS (TempID, MatricNumber, LastName, OtherNames, Gender, DateOfBirth, DateOfEntry, Phone, Address, Email, DepartmentID, Level)
VALUES
(NULL, 'PHY1000025', 'Carroll', 'Sofia', 'F', '2000-04-03', '2019-09-01', '08012345758', '401 Bio Lane', 'sofia.carroll@school.edu', 9, 100),
(NULL, 'PHY1000026', 'Riley', 'Daniel', 'M', '2001-09-27', '2020-09-01', '08012345759', '402 Bio Lane', 'daniel.riley@school.edu', 9, 100),
('TEMP0017', NULL, 'Stone', 'Ella', 'F', '2002-01-06', '2021-09-01', '08012345760', '403 Bio Lane', 'ella.stone@school.edu', 9, 100),
(NULL, 'PHY1000027', 'Blake', 'Alexander', 'M', '2003-11-18', '2022-09-01', '08012345761', '404 Bio Lane', 'alexander.blake@school.edu', 9, 200),
(NULL, 'PHY1000028', 'Wallace', 'Ava', 'F', '2001-02-09', '2020-09-01', '08012345762', '405 Bio Lane', 'ava.wallace@school.edu', 9, 200),
(NULL, 'PHY1000029', 'Torres', 'Noah', 'M', '2002-05-14', '2021-09-01', '08012345763', '406 Bio Lane', 'noah.torres@school.edu', 9, 200),
('TEMP0018', NULL, 'Mack', 'Chloe', 'F', '2000-07-30', '2019-09-01', '08012345764', '407 Bio Lane', 'chloe.mack@school.edu', 9, 300),
(NULL, 'PHY1000030', 'Pope', 'Lucas', 'M', '2003-03-24', '2022-09-01', '08012345765', '408 Bio Lane', 'lucas.pope@school.edu', 9, 300),
(NULL, 'PHY1000031', 'Carter', 'Emily', 'F', '2001-06-20', '2020-09-01', '08012345766', '409 Bio Lane', 'emily.carter@school.edu', 9, 400),
(NULL, 'PHY1000032', 'Bell', 'William', 'M', '2002-08-13', '2021-09-01', '08012345767', '410 Bio Lane', 'william.bell@school.edu', 9, 400);

-- Geology (DepartmentID: 10)
INSERT INTO STUDENTS (TempID, MatricNumber, LastName, OtherNames, Gender, DateOfBirth, DateOfEntry, Phone, Address, Email, DepartmentID, Level)
VALUES
(NULL, 'PHY1000033', 'Cole', 'Hannah', 'F', '2001-03-05', '2020-09-01', '08012345768', '501 Geo Lane', 'hannah.cole@school.edu', 10, 100),
(NULL, 'PHY1000034', 'Ward', 'Benjamin', 'M', '2000-11-22', '2019-09-01', '08012345769', '502 Geo Lane', 'benjamin.ward@school.edu', 10, 100),
('TEMP0019', NULL, 'Grant', 'Sophia', 'F', '2002-08-12', '2021-09-01', '08012345770', '503 Geo Lane', 'sophia.grant@school.edu', 10, 100),
(NULL, 'PHY1000035', 'Wood', 'James', 'M', '2003-01-15', '2022-09-01', '08012345771', '504 Geo Lane', 'james.wood@school.edu', 10, 200),
(NULL, 'PHY1000036', 'Reed', 'Olivia', 'F', '2001-12-18', '2020-09-01', '08012345772', '505 Geo Lane', 'olivia.reed@school.edu', 10, 200),
(NULL, 'PHY1000037', 'Pierce', 'Mason', 'M', '2002-04-07', '2021-09-01', '08012345773', '506 Geo Lane', 'mason.pierce@school.edu', 10, 200),
('TEMP0020', NULL, 'Hale', 'Avery', 'F', '2000-09-21', '2019-09-01', '08012345774', '507 Geo Lane', 'avery.hale@school.edu', 10, 300),
(NULL, 'PHY1000038', 'Craig', 'Elijah', 'M', '2003-05-06', '2022-09-01', '08012345775', '508 Geo Lane', 'elijah.craig@school.edu', 10, 300),
(NULL, 'PHY1000039', 'Black', 'Mia', 'F', '2001-07-30', '2020-09-01', '08012345776', '509 Geo Lane', 'mia.black@school.edu', 10, 400),
(NULL, 'PHY1000040', 'Ford', 'Jacob', 'M', '2002-03-19', '2021-09-01', '08012345777', '510 Geo Lane', 'jacob.ford@school.edu', 10, 400);


-- Verifying UNIQUE constraints in TempID and MatricNumber
INSERT INTO STUDENTS (TempID, MatricNumber, LastName, OtherNames, Gender, DateOfBirth, DateOfEntry, Phone, Address, Email, DepartmentID, Level)
VALUES
(NULL, 'PHY1000033', 'French', 'Johnny', 'M', '2001-09-15', '2020-09-05', '08025345778', '501 French Street', 'johnnyfrench@example.com', 13, 300)
-- Above should throw a duplicate key value error

SELECT * FROM DEPARTMENT
-- Inserting into COURSES table
/* 
	Obeys the following rules:
	The first three letters denotes the department.
	The first digit denotes the level.
	The second digit denotes the semester.
	The third digit denotes the course number in the department.
*/
-- Computer Science Department Courses
INSERT INTO COURSES (Code, Name, Units, DepartmentID) 
VALUES
-- 100 Level
('CSE-111', 'Introduction to Programming', 3, 1),
('CSE-112', 'Discrete Mathematics I', 3, 1),
('CSE-113', 'Computer Organization', 3, 1),
('CSE-114', 'Digital Logic Design', 3, 1),
('CSE-115', 'Data Structures', 3, 1),
('CSE-121', 'Object-Oriented Programming', 3, 1),
('CSE-122', 'Discrete Mathematics II', 3, 1),
('CSE-123', 'Introduction to Databases', 3, 1),
('CSE-124', 'Computer Networks I', 3, 1),
('CSE-125', 'Operating Systems', 3, 1),

-- 200 Level
('CSE-211', 'Algorithm Design and Analysis', 3, 1),
('CSE-212', 'Web Development', 3, 1),
('CSE-213', 'Computer Architecture', 3, 1),
('CSE-214', 'Software Engineering I', 3, 1),
('CSE-215', 'Human-Computer Interaction', 3, 1),
('CSE-221', 'Artificial Intelligence I', 3, 1),
('CSE-222', 'Mobile Application Development', 3, 1),
('CSE-223', 'Computer Networks II', 3, 1),
('CSE-224', 'Database Systems', 3, 1),
('CSE-225', 'Software Engineering II', 3, 1),

-- 300 Level
('CSE-311', 'Advanced Programming Techniques', 3, 1),
('CSE-312', 'Machine Learning Basics', 3, 1),
('CSE-313', 'Compiler Design', 3, 1),
('CSE-314', 'Cloud Computing', 3, 1),
('CSE-315', 'Parallel Computing', 3, 1),
('CSE-321', 'Cybersecurity', 3, 1),
('CSE-322', 'Big Data Analytics', 3, 1),
('CSE-323', 'Data Mining', 3, 1),
('CSE-324', 'Robotics', 3, 1),
('CSE-325', 'Game Development', 3, 1),

-- 400 Level
('CSE-411', 'Advanced AI Techniques', 3, 1),
('CSE-412', 'Blockchain Technology', 3, 1),
('CSE-413', 'Advanced Operating Systems', 3, 1),
('CSE-414', 'Computer Vision', 3, 1),
('CSE-415', 'Research Methods', 3, 1),
('CSE-421', 'Natural Language Processing', 3, 1),
('CSE-422', 'IoT Systems', 3, 1),
('CSE-423', 'Advanced Cybersecurity', 3, 1),
('CSE-424', 'Research Project', 6, 1),
('CSE-425', 'Ethics in Computing', 3, 1),

-- 500 Level
('CSE-511', 'Advanced Machine Learning', 3, 1),
('CSE-512', 'Quantum Computing', 3, 1),
('CSE-513', 'Neural Networks', 3, 1),
('CSE-514', 'Augmented Reality', 3, 1),
('CSE-515', 'Thesis/Dissertation', 6, 1),
('CSE-521', 'Entrepreneurship in IT', 3, 1),
('CSE-522', 'Advanced Database Systems', 3, 1),
('CSE-523', 'Research Seminar', 3, 1),
('CSE-524', 'Special Topics in CSE', 3, 1),
('CSE-525', 'Industry Internship', 6, 1);


-- Mechanical Engineering Department Courses
INSERT INTO COURSES (Code, Name, Units, DepartmentID) 
VALUES
-- 100 Level
('MEE-111', 'Engineering Mechanics', 3, 2),
('MEE-112', 'Introduction to Thermodynamics', 3, 2),
('MEE-113', 'Engineering Drawing I', 3, 2),
('MEE-114', 'Material Science', 3, 2),
('MEE-115', 'Workshop Practice I', 2, 2),
('MEE-121', 'Engineering Mathematics I', 3, 2),
('MEE-122', 'Fluid Mechanics I', 3, 2),
('MEE-123', 'Engineering Drawing II', 3, 2),
('MEE-124', 'Workshop Practice II', 2, 2),
('MEE-125', 'Statics and Dynamics', 3, 2),

-- 200 Level
('MEE-211', 'Applied Thermodynamics', 3, 2),
('MEE-212', 'Strength of Materials', 3, 2),
('MEE-213', 'Manufacturing Processes I', 3, 2),
('MEE-214', 'Electrical Machines', 3, 2),
('MEE-215', 'Heat Transfer I', 3, 2),
('MEE-221', 'Advanced Fluid Mechanics', 3, 2),
('MEE-222', 'Mechanics of Machines', 3, 2),
('MEE-223', 'Control Systems', 3, 2),
('MEE-224', 'Manufacturing Processes II', 3, 2),
('MEE-225', 'Engineering Mathematics II', 3, 2),

-- 300 Level
('MEE-311', 'Machine Design I', 3, 2),
('MEE-312', 'Energy Conversion Systems', 3, 2),
('MEE-313', 'Automotive Engineering', 3, 2),
('MEE-314', 'Advanced Heat Transfer', 3, 2),
('MEE-315', 'Engineering Metrology', 3, 2),
('MEE-321', 'Finite Element Analysis', 3, 2),
('MEE-322', 'Robotics and Automation', 3, 2),
('MEE-323', 'Dynamics of Machinery', 3, 2),
('MEE-324', 'Advanced Machine Design', 3, 2),
('MEE-325', 'Project Management', 3, 2),

-- 400 Level
('MEE-411', 'Renewable Energy Systems', 3, 2),
('MEE-412', 'Industrial Automation', 3, 2),
('MEE-413', 'Machine Tools and Manufacturing', 3, 2),
('MEE-414', 'Research Methods', 3, 2),
('MEE-415', 'Production Engineering', 3, 2),
('MEE-421', 'HVAC Systems', 3, 2),
('MEE-422', 'Turbo Machines', 3, 2),
('MEE-423', 'Mechatronics', 3, 2),
('MEE-424', 'Final Year Project', 6, 2),
('MEE-425', 'Engineering Ethics', 3, 2),

-- 500 Level
('MEE-511', 'Advanced Control Systems', 3, 2),
('MEE-512', 'Advanced Robotics', 3, 2),
('MEE-513', 'Advanced Energy Systems', 3, 2),
('MEE-514', 'Advanced Machine Tools', 3, 2),
('MEE-515', 'Thesis/Dissertation', 6, 2),
('MEE-521', 'Industrial Engineering', 3, 2),
('MEE-522', 'Advanced Materials Engineering', 3, 2),
('MEE-523', 'Advanced Manufacturing', 3, 2),
('MEE-524', 'Research Seminar', 3, 2),
('MEE-525', 'Industry Internship', 6, 2);


-- Electrical Engineering Department Courses
INSERT INTO COURSES (Code, Name, Units, DepartmentID) 
VALUES
-- 100 Level
('ELE-111', 'Basic Electrical Engineering', 3, 3),
('ELE-112', 'Circuit Analysis I', 3, 3),
('ELE-113', 'Electronic Devices I', 3, 3),
('ELE-114', 'Engineering Mathematics I', 3, 3),
('ELE-115', 'Workshop Practice I', 2, 3),
('ELE-121', 'Circuit Analysis II', 3, 3),
('ELE-122', 'Electronic Devices II', 3, 3),
('ELE-123', 'Engineering Drawing', 3, 3),
('ELE-124', 'Workshop Practice II', 2, 3),
('ELE-125', 'Introduction to Programming', 3, 3),

-- 200 Level
('ELE-211', 'Electromagnetic Fields', 3, 3),
('ELE-212', 'Signals and Systems', 3, 3),
('ELE-213', 'Digital Electronics', 3, 3),
('ELE-214', 'Electrical Machines I', 3, 3),
('ELE-215', 'Control Systems I', 3, 3),
('ELE-221', 'Electrical Measurements', 3, 3),
('ELE-222', 'Power Systems I', 3, 3),
('ELE-223', 'Microprocessors', 3, 3),
('ELE-224', 'Digital Signal Processing', 3, 3),
('ELE-225', 'Engineering Mathematics II', 3, 3),

-- 300 Level
('ELE-311', 'Electrical Machines II', 3, 3),
('ELE-312', 'Power Electronics', 3, 3),
('ELE-313', 'Renewable Energy Systems', 3, 3),
('ELE-314', 'High Voltage Engineering', 3, 3),
('ELE-315', 'Embedded Systems', 3, 3),
('ELE-321', 'Industrial Electronics', 3, 3),
('ELE-322', 'Communication Systems', 3, 3),
('ELE-323', 'Advanced Control Systems', 3, 3),
('ELE-324', 'Power Systems II', 3, 3),
('ELE-325', 'Energy Management', 3, 3),

-- 400 Level
('ELE-411', 'Electrical Drives', 3, 3),
('ELE-412', 'Smart Grid Technology', 3, 3),
('ELE-413', 'Research Methods', 3, 3),
('ELE-414', 'Robotics and Automation', 3, 3),
('ELE-415', 'VLSI Design', 3, 3),
('ELE-421', 'Final Year Project', 6, 3),
('ELE-422', 'Advanced Communication Systems', 3, 3),
('ELE-423', 'Power System Protection', 3, 3),
('ELE-424', 'Biomedical Electronics', 3, 3),
('ELE-425', 'Industrial Training', 6, 3),

-- 500 Level
('ELE-511', 'Advanced Power Systems', 3, 3),
('ELE-512', 'Wireless Communication', 3, 3),
('ELE-513', 'IoT Systems', 3, 3),
('ELE-514', 'Thesis/Dissertation', 6, 3),
('ELE-515', 'Research Seminar', 3, 3),
('ELE-521', 'Advanced Control Engineering', 3, 3),
('ELE-522', 'Energy Conversion Systems', 3, 3),
('ELE-523', 'Power System Stability', 3, 3),
('ELE-524', 'Special Topics in Electrical Engineering', 3, 3),
('ELE-525', 'Industry Internship', 6, 3);


-- Civil Engineering Department Courses
INSERT INTO COURSES (Code, Name, Units, DepartmentID) 
VALUES
-- 100 Level
('CIV-111', 'Introduction to Civil Engineering', 3, 4),
('CIV-112', 'Engineering Drawing I', 3, 4),
('CIV-113', 'Strength of Materials I', 3, 4),
('CIV-114', 'Surveying I', 3, 4),
('CIV-115', 'Building Materials', 3, 4),
('CIV-121', 'Strength of Materials II', 3, 4),
('CIV-122', 'Surveying II', 3, 4),
('CIV-123', 'Fluid Mechanics I', 3, 4),
('CIV-124', 'Engineering Geology', 3, 4),
('CIV-125', 'Workshop Practice I', 2, 4),

-- 200 Level
('CIV-211', 'Structural Analysis I', 3, 4),
('CIV-212', 'Concrete Technology', 3, 4),
('CIV-213', 'Highway Engineering I', 3, 4),
('CIV-214', 'Hydrology', 3, 4),
('CIV-215', 'Steel Structures I', 3, 4),
('CIV-221', 'Structural Analysis II', 3, 4),
('CIV-222', 'Environmental Engineering I', 3, 4),
('CIV-223', 'Soil Mechanics', 3, 4),
('CIV-224', 'Highway Engineering II', 3, 4),
('CIV-225', 'Engineering Mathematics', 3, 4),

-- 300 Level
('CIV-311', 'Design of Reinforced Concrete Structures', 3, 4),
('CIV-312', 'Structural Analysis III', 3, 4),
('CIV-313', 'Water Resources Engineering', 3, 4),
('CIV-314', 'Steel Structures II', 3, 4),
('CIV-315', 'Advanced Surveying', 3, 4),
('CIV-321', 'Foundation Engineering', 3, 4),
('CIV-322', 'Environmental Engineering II', 3, 4),
('CIV-323', 'Transport Engineering', 3, 4),
('CIV-324', 'Advanced Fluid Mechanics', 3, 4),
('CIV-325', 'Project Management', 3, 4),

-- 400 Level
('CIV-411', 'Bridge Engineering', 3, 4),
('CIV-412', 'Research Methods', 3, 4),
('CIV-413', 'Final Year Project I', 6, 4),
('CIV-414', 'Structural Dynamics', 3, 4),
('CIV-415', 'Construction Management', 3, 4),
('CIV-421', 'Advanced Concrete Design', 3, 4),
('CIV-422', 'Final Year Project II', 6, 4),
('CIV-423', 'Urban Planning', 3, 4),
('CIV-424', 'Special Topics in Civil Engineering', 3, 4),
('CIV-425', 'Industrial Internship', 6, 4),

-- 500 Level
('CIV-511', 'Advanced Structural Design', 3, 4),
('CIV-512', 'Seismic Engineering', 3, 4),
('CIV-513', 'Hydraulic Structures', 3, 4),
('CIV-514', 'Thesis/Dissertation', 6, 4),
('CIV-515', 'Research Seminar', 3, 4),
('CIV-521', 'Advanced Transport Engineering', 3, 4),
('CIV-522', 'Construction Technology', 3, 4),
('CIV-523', 'Water Quality Engineering', 3, 4),
('CIV-524', 'Advanced Soil Mechanics', 3, 4),
('CIV-525', 'Industry Internship', 6, 4);

SELECT * FROM COURSES
ORDER BY ID DESC
-- Chemical Engineering Department Courses
INSERT INTO COURSES (Code, Name, Units, DepartmentID) 
VALUES
-- 100 Level
('CHE-111', 'Introduction to Chemical Engineering', 3, 5),
('CHE-112', 'Engineering Chemistry', 3, 5),
('CHE-113', 'Chemical Process Calculations I', 3, 5),
('CHE-114', 'Engineering Drawing I', 3, 5),
('CHE-115', 'Workshop Practice I', 2, 5),
('CHE-121', 'Chemical Process Calculations II', 3, 5),
('CHE-122', 'Fluid Mechanics I', 3, 5),
('CHE-123', 'Introduction to Thermodynamics', 3, 5),
('CHE-124', 'Material Science', 3, 5),
('CHE-125', 'Engineering Mathematics I', 3, 5),

-- 200 Level
('CHE-211', 'Chemical Thermodynamics', 3, 5),
('CHE-212', 'Fluid Mechanics II', 3, 5),
('CHE-213', 'Heat Transfer I', 3, 5),
('CHE-214', 'Process Dynamics', 3, 5),
('CHE-215', 'Chemical Engineering Materials', 3, 5),
('CHE-221', 'Reaction Engineering I', 3, 5),
('CHE-222', 'Mass Transfer Operations', 3, 5),
('CHE-223', 'Process Control', 3, 5),
('CHE-224', 'Environmental Engineering', 3, 5),
('CHE-225', 'Engineering Mathematics II', 3, 5),

-- 300 Level
('CHE-311', 'Advanced Thermodynamics', 3, 5),
('CHE-312', 'Chemical Reaction Engineering II', 3, 5),
('CHE-313', 'Unit Operations I', 3, 5),
('CHE-314', 'Process Plant Design', 3, 5),
('CHE-315', 'Process Optimization', 3, 5),
('CHE-321', 'Biochemical Engineering', 3, 5),
('CHE-322', 'Unit Operations II', 3, 5),
('CHE-323', 'Transport Phenomena', 3, 5),
('CHE-324', 'Advanced Mass Transfer', 3, 5),
('CHE-325', 'Industrial Safety', 3, 5),

-- 400 Level
('CHE-411', 'Advanced Heat Transfer', 3, 5),
('CHE-412', 'Petroleum Refining', 3, 5),
('CHE-413', 'Research Methods', 3, 5),
('CHE-414', 'Final Year Project I', 6, 5),
('CHE-415', 'Chemical Process Safety', 3, 5),
('CHE-421', 'Final Year Project II', 6, 5),
('CHE-422', 'Special Topics in Chemical Engineering', 3, 5),
('CHE-423', 'Chemical Engineering Economics', 3, 5),
('CHE-424', 'Polymer Technology', 3, 5),
('CHE-425', 'Industrial Training', 6, 5),

-- 500 Level
('CHE-511', 'Advanced Process Control', 3, 5),
('CHE-512', 'Sustainable Process Design', 3, 5),
('CHE-513', 'Catalysis', 3, 5),
('CHE-514', 'Thesis/Dissertation', 6, 5),
('CHE-515', 'Research Seminar', 3, 5),
('CHE-521', 'Chemical Engineering Design Project', 3, 5),
('CHE-522', 'Advanced Biochemical Engineering', 3, 5),
('CHE-523', 'Environmental Process Engineering', 3, 5),
('CHE-524', 'Special Topics in Process Engineering', 3, 5),
('CHE-525', 'Industry Internship', 6, 5);

SELECT * FROM COURSES
ORDER BY ID DESC
-- Physics Department Courses
INSERT INTO COURSES (Code, Name, Units, DepartmentID)
VALUES
-- 100 Level
('PHY-111', 'General Physics I', 3, 6),
('PHY-112', 'Mechanics', 3, 6),
('PHY-113', 'Heat and Thermodynamics', 3, 6),
('PHY-114', 'Physics Laboratory I', 2, 6),
('PHY-115', 'Introduction to Astronomy', 3, 6),
('PHY-121', 'General Physics II', 3, 6),
('PHY-122', 'Electricity and Magnetism', 3, 6),
('PHY-123', 'Optics', 3, 6),
('PHY-124', 'Physics Laboratory II', 2, 6),
('PHY-125', 'Introduction to Modern Physics', 3, 6),

-- 200 Level
('PHY-211', 'Advanced Mechanics', 3, 6),
('PHY-212', 'Wave Phenomena', 3, 6),
('PHY-213', 'Electromagnetic Fields', 3, 6),
('PHY-214', 'Mathematical Methods in Physics', 3, 6),
('PHY-215', 'Acoustics', 3, 6),
('PHY-221', 'Quantum Physics I', 3, 6),
('PHY-222', 'Statistical Physics', 3, 6),
('PHY-223', 'Solid State Physics', 3, 6),
('PHY-224', 'Physics Laboratory III', 2, 6),
('PHY-225', 'Numerical Methods in Physics', 3, 6),

-- 300 Level
('PHY-311', 'Quantum Physics II', 3, 6),
('PHY-312', 'Electronics', 3, 6),
('PHY-313', 'Atomic and Molecular Physics', 3, 6),
('PHY-314', 'Nuclear Physics', 3, 6),
('PHY-315', 'Geophysics', 3, 6),
('PHY-321', 'Solid State Physics II', 3, 6),
('PHY-322', 'Relativity', 3, 6),
('PHY-323', 'Physics of Materials', 3, 6),
('PHY-324', 'Computational Physics', 3, 6),
('PHY-325', 'Physics Laboratory IV', 2, 6),

-- 400 Level
('PHY-411', 'Advanced Quantum Mechanics', 3, 6),
('PHY-412', 'Advanced Nuclear Physics', 3, 6),
('PHY-413', 'Research Methods', 3, 6),
('PHY-414', 'Final Year Project I', 6, 6),
('PHY-415', 'Seminar in Physics', 3, 6),
('PHY-421', 'Final Year Project II', 6, 6),
('PHY-422', 'Special Topics in Physics', 3, 6),
('PHY-423', 'Condensed Matter Physics', 3, 6),
('PHY-424', 'Medical Physics', 3, 6),
('PHY-425', 'Astrophysics', 3, 6),

-- 500 Level
('PHY-511', 'Advanced Electromagnetic Theory', 3, 6),
('PHY-512', 'Quantum Field Theory', 3, 6),
('PHY-513', 'Advanced Statistical Mechanics', 3, 6),
('PHY-514', 'Thesis/Dissertation', 6, 6),
('PHY-515', 'Seminar in Physics', 3, 6),
('PHY-521', 'Advanced Materials Physics', 3, 6),
('PHY-522', 'Special Relativity and Cosmology', 3, 6),
('PHY-523', 'Nonlinear Dynamics', 3, 6),
('PHY-524', 'Nanotechnology', 3, 6),
('PHY-525', 'Introduction to the Multiverse', 3, 6);


-- Mathematics Department Courses
INSERT INTO COURSES (Code, Name, Units, DepartmentID)
VALUES
-- 100 Level
('MAT-111', 'Algebra I', 3, 7),
('MAT-112', 'Calculus I', 3, 7),
('MAT-113', 'Statistics I', 3, 7),
('MAT-114', 'Mathematical Logic', 3, 7),
('MAT-115', 'Introduction to Programming', 3, 7),
('MAT-121', 'Algebra II', 3, 7),
('MAT-122', 'Calculus II', 3, 7),
('MAT-123', 'Numerical Analysis I', 3, 7),
('MAT-124', 'Probability Theory', 3, 7),
('MAT-125', 'Discrete Mathematics', 3, 7),

-- 200 Level
('MAT-211', 'Real Analysis I', 3, 7),
('MAT-212', 'Linear Algebra', 3, 7),
('MAT-213', 'Differential Equations', 3, 7),
('MAT-214', 'Mathematical Methods I', 3, 7),
('MAT-215', 'Graph Theory', 3, 7),
('MAT-221', 'Real Analysis II', 3, 7),
('MAT-222', 'Complex Analysis I', 3, 7),
('MAT-223', 'Numerical Analysis II', 3, 7),
('MAT-224', 'Vector Analysis', 3, 7),
('MAT-225', 'Abstract Algebra I', 3, 7),

-- 300 Level
('MAT-311', 'Abstract Algebra II', 3, 7),
('MAT-312', 'Functional Analysis I', 3, 7),
('MAT-313', 'Topology I', 3, 7),
('MAT-314', 'Differential Geometry', 3, 7),
('MAT-315', 'Set Theory', 3, 7),
('MAT-321', 'Complex Analysis II', 3, 7),
('MAT-322', 'Mathematical Methods II', 3, 7),
('MAT-323', 'Statistics II', 3, 7),
('MAT-324', 'Optimization Theory', 3, 7),
('MAT-325', 'Operations Research', 3, 7),

-- 400 Level
('MAT-411', 'Functional Analysis II', 3, 7),
('MAT-412', 'Advanced Topology', 3, 7),
('MAT-413', 'Research Methods', 3, 7),
('MAT-414', 'Final Year Project I', 6, 7),
('MAT-415', 'Seminar in Mathematics', 3, 7),
('MAT-421', 'Final Year Project II', 6, 7),
('MAT-422', 'Special Topics in Mathematics', 3, 7),
('MAT-423', 'Advanced Numerical Methods', 3, 7),
('MAT-424', 'Stochastic Processes', 3, 7),
('MAT-425', 'Nonlinear Optimization', 3, 7);


-- Chemistry Department Courses
INSERT INTO COURSES (Code, Name, Units, DepartmentID)
VALUES
-- 100 Level
('CHM-111', 'Introduction to Chemistry', 3, 8),
('CHM-112', 'Organic Chemistry I', 3, 8),
('CHM-113', 'Inorganic Chemistry I', 3, 8),
('CHM-114', 'Physical Chemistry I', 3, 8),
('CHM-115', 'General Laboratory Techniques', 2, 8),
('CHM-121', 'Analytical Chemistry I', 3, 8),
('CHM-122', 'Biochemistry Basics', 3, 8),
('CHM-123', 'Introduction to Environmental Chemistry', 3, 8),
('CHM-124', 'Computational Chemistry', 3, 8),
('CHM-125', 'Chemical Safety and Ethics', 2, 8),

-- 200 Level
('CHM-211', 'Organic Chemistry II', 3, 8),
('CHM-212', 'Inorganic Chemistry II', 3, 8),
('CHM-213', 'Physical Chemistry II', 3, 8),
('CHM-214', 'Chemical Thermodynamics', 3, 8),
('CHM-215', 'Quantitative Analysis', 2, 8),
('CHM-221', 'Spectroscopy Techniques', 3, 8),
('CHM-222', 'Polymer Chemistry', 3, 8),
('CHM-223', 'Advanced Biochemistry', 3, 8),
('CHM-224', 'Electrochemistry', 3, 8),
('CHM-225', 'Research Methods in Chemistry', 3, 8),

-- 300 Level
('CHM-311', 'Advanced Organic Chemistry', 3, 8),
('CHM-312', 'Advanced Inorganic Chemistry', 3, 8),
('CHM-313', 'Chemical Kinetics', 3, 8),
('CHM-314', 'Surface Chemistry', 3, 8),
('CHM-315', 'Instrumental Methods of Analysis', 3, 8),
('CHM-321', 'Industrial Chemistry I', 3, 8),
('CHM-322', 'Applied Environmental Chemistry', 3, 8),
('CHM-323', 'Natural Products Chemistry', 3, 8),
('CHM-324', 'Photochemistry', 3, 8),
('CHM-325', 'Materials Chemistry', 3, 8),

-- 400 Level
('CHM-411', 'Advanced Analytical Chemistry', 3, 8),
('CHM-412', 'Chemistry of Transition Metals', 3, 8),
('CHM-413', 'Research Project I', 6, 8),
('CHM-414', 'Environmental Risk Assessment', 3, 8),
('CHM-415', 'Industrial Chemistry II', 3, 8),
('CHM-421', 'Research Project II', 6, 8),
('CHM-422', 'Medicinal Chemistry', 3, 8),
('CHM-423', 'Advanced Computational Chemistry', 3, 8),
('CHM-424', 'Sustainable Chemistry', 3, 8),
('CHM-425', 'Seminar in Chemistry', 3, 8);


-- Biology Department Courses
INSERT INTO COURSES (Code, Name, Units, DepartmentID)
VALUES
-- 100 Level
('BIO-111', 'Introduction to Biology', 3, 9),
('BIO-112', 'Cell Biology', 3, 9),
('BIO-113', 'Genetics I', 3, 9),
('BIO-114', 'Ecology I', 3, 9),
('BIO-115', 'Laboratory Techniques in Biology', 2, 9),
('BIO-121', 'Evolutionary Biology', 3, 9),
('BIO-122', 'Plant Biology', 3, 9),
('BIO-123', 'Animal Biology', 3, 9),
('BIO-124', 'Microbiology Basics', 3, 9),
('BIO-125', 'Biostatistics', 2, 9),

-- 200 Level
('BIO-211', 'Molecular Biology', 3, 9),
('BIO-212', 'Advanced Genetics', 3, 9),
('BIO-213', 'Ecology II', 3, 9),
('BIO-214', 'Biochemistry for Biologists', 3, 9),
('BIO-215', 'Research Methods in Biology', 2, 9),
('BIO-221', 'Immunology', 3, 9),
('BIO-222', 'Parasitology', 3, 9),
('BIO-223', 'Environmental Biology', 3, 9),
('BIO-224', 'Developmental Biology', 3, 9),
('BIO-225', 'Advanced Biostatistics', 3, 9),

-- 300 Level
('BIO-311', 'Advanced Molecular Biology', 3, 9),
('BIO-312', 'Population Genetics', 3, 9),
('BIO-313', 'Ecotoxicology', 3, 9),
('BIO-314', 'Applied Microbiology', 3, 9),
('BIO-315', 'Bioinformatics Basics', 3, 9),
('BIO-321', 'Industrial Microbiology', 3, 9),
('BIO-322', 'Conservation Biology', 3, 9),
('BIO-323', 'Plant Physiology', 3, 9),
('BIO-324', 'Animal Physiology', 3, 9),
('BIO-325', 'Experimental Biology', 3, 9),

-- 400 Level
('BIO-411', 'Advanced Bioinformatics', 3, 9),
('BIO-412', 'Biotechnology', 3, 9),
('BIO-413', 'Research Project I', 6, 9),
('BIO-414', 'Environmental Management', 3, 9),
('BIO-415', 'Seminar in Biology', 3, 9),
('BIO-421', 'Research Project II', 6, 9),
('BIO-422', 'Advanced Plant Biology', 3, 9),
('BIO-423', 'Advanced Animal Biology', 3, 9),
('BIO-424', 'Aquatic Biology', 3, 9),
('BIO-425', 'Evolutionary Development', 3, 9);


-- Geology Department Courses
INSERT INTO COURSES (Code, Name, Units, DepartmentID)
VALUES
-- 100 Level
('GEO-111', 'Introduction to Geology', 3, 10),
('GEO-112', 'Mineralogy I', 3, 10),
('GEO-113', 'Structural Geology I', 3, 10),
('GEO-114', 'Geological Field Methods', 3, 10),
('GEO-115', 'Earth Materials', 2, 10),
('GEO-121', 'Geomorphology', 3, 10),
('GEO-122', 'Paleontology I', 3, 10),
('GEO-123', 'Geochemistry Basics', 3, 10),
('GEO-124', 'Introduction to Geophysics', 3, 10),
('GEO-125', 'Geological Mapping', 2, 10),

-- 200 Level
('GEO-211', 'Advanced Mineralogy', 3, 10),
('GEO-212', 'Structural Geology II', 3, 10),
('GEO-213', 'Sedimentology I', 3, 10),
('GEO-214', 'Igneous Petrology', 3, 10),
('GEO-215', 'Geological Data Analysis', 2, 10),
('GEO-221', 'Metamorphic Petrology', 3, 10),
('GEO-222', 'Paleontology II', 3, 10),
('GEO-223', 'Hydrogeology', 3, 10),
('GEO-224', 'Economic Geology', 3, 10),
('GEO-225', 'Remote Sensing in Geology', 3, 10),

-- 300 Level
('GEO-311', 'Advanced Structural Geology', 3, 10),
('GEO-312', 'Sedimentology II', 3, 10),
('GEO-313', 'Advanced Geophysics', 3, 10),
('GEO-314', 'Ore Deposits Geology', 3, 10),
('GEO-315', 'Environmental Geology', 3, 10),
('GEO-321', 'Engineering Geology', 3, 10),
('GEO-322', 'Petroleum Geology', 3, 10),
('GEO-323', 'Geostatistics', 3, 10),
('GEO-324', 'Seismic Methods', 3, 10),
('GEO-325', 'Marine Geology', 3, 10),

-- 400 Level
('GEO-411', 'Advanced Isotope Geochemistry', 3, 10),
('GEO-412', 'Geodynamic Modeling', 3, 10),
('GEO-413', 'Seismic Tomography', 3, 10),
('GEO-414', 'Climate Change and Paleoclimatology', 3, 10),
('GEO-415', 'Geoinformatics and GIS Applications', 3, 10),
('GEO-421', 'Advanced Structural Geology and Tectonics', 3, 10),
('GEO-422', 'Magmatic and Metamorphic Petrogenesis', 3, 10),
('GEO-423', 'Hydrogeochemical Modeling', 3, 10),
('GEO-424', 'Geophysical Exploration Methods', 3, 10),
('GEO-425', 'Environmental Geochemistry', 3, 10),

-- 500 Level
('GEO-511', 'Advanced Geochemistry', 3, 10),
('GEO-512', 'Environmental Impact Assessment', 3, 10),
('GEO-513', 'Research Project I', 6, 10),
('GEO-514', 'Petrophysics', 3, 10),
('GEO-515', 'Seminar in Geology', 3, 10),
('GEO-521', 'Research Project II', 6, 10),
('GEO-522', 'Advanced Petroleum Geology', 3, 10),
('GEO-523', 'Mining Geology', 3, 10),
('GEO-524', 'Geological Hazards', 3, 10),
('GEO-525', 'Sustainable Resource Development', 3, 10);


SELECT * FROM COURSES
INNER JOIN DEPARTMENT ON DEPARTMENT.ID = COURSES.DepartmentID
WHERE DepartmentID = 11

SELECT * FROM LEVEL
-- Inserting into CLASS Table
INSERT INTO LEVEL(Code, Title)
VALUES
(100, '100 Level'),
(200, '200 Level'),
(300, '300 Level'),
(400, '400 Level'),
(500, '500 Level');


SELECT * FROM SESSION
INSERT INTO SESSION (StartDate, EndDate, Name)
VALUES
('2024-09-01', '2025-07-31', '2024/2025')


SELECT * FROM SEMESTER
INSERT INTO SEMESTER (Name) 
VALUES
('First Semester'),
('Second Semester')


SELECT * FROM SESSION_SEMESTER
INSERT INTO SESSION_SEMESTER (SessionID, SemesterID)
VALUES
(1,1),
(1,2)

-- Query to find all 400L courses
SELECT * FROM COURSES
where Code LIKE '[A-Z][A-Z][A-Z]-4%'


SELECT * FROM STUDENTS
WHERE DepartmentID = 13
ORDER BY ID DESC
SELECT * FROM DEPARTMENT D
INNER JOIN
COURSES C ON C.DepartmentID = D.ID

/* 
	Obeys the following rules:
	The first three letters denotes the department.
	The first digit denotes the level.
	The second digit denotes the semester.
	The third digit denotes the course number in the department.
*/
SELECT * FROM STUDENTS S INNER JOIN DEPARTMENT D ON D.ID = S.DepartmentID ORDER BY S.ID DESC;
SELECT S.ID, S.LastName, S.OtherNames,S.Level, D.Name, D.ID
FROM STUDENTS S INNER JOIN DEPARTMENT D ON D.ID = S.DepartmentID
WHERE S.ID BETWEEN 61 AND 70
--WHERE D.Name LIKE 'PHY%'

SELECT * FROM COURSES WHERE DepartmentID = 7
SELECT * FROM LEVEL
SELECT * FROM STUDENT_COURSE ORDER BY StudentID DESC
SELECT * FROM SESSION
SELECT * FROM SEMESTER
SELECT * FROM SESSION_SEMESTER

-- Finding constraints in a table
SELECT 
    fk.name AS ForeignKeyName,
    tp.name AS ParentTable,
    cp.name AS ParentColumn,
    tr.name AS ReferencedTable,
    cr.name AS ReferencedColumn
FROM 
    sys.foreign_keys AS fk
INNER JOIN 
    sys.foreign_key_columns AS fkc ON fk.object_id = fkc.constraint_object_id
INNER JOIN 
    sys.tables AS tp ON fkc.parent_object_id = tp.object_id
INNER JOIN 
    sys.columns AS cp ON fkc.parent_object_id = cp.object_id AND fkc.parent_column_id = cp.column_id
INNER JOIN 
    sys.tables AS tr ON fkc.referenced_object_id = tr.object_id
INNER JOIN 
    sys.columns AS cr ON fkc.referenced_object_id = cr.object_id AND fkc.referenced_column_id = cr.column_id
WHERE 
    tr.name = 'Session_Semester';

SELECT * FROM COURSES WHERE DepartmentID = 8
SELECT SC.StudentID, SC.CourseID, SC.SessionID, SC.SemesterID, S.Level AS 'Student Level', C.Code AS 'Course Code', C.Name AS C_Name, C.DepartmentID AS Dept_ID
FROM STUDENT_COURSE SC INNER JOIN COURSES C ON SC.CourseID = C.ID INNER JOIN STUDENTS S ON S.ID = SC.StudentID
ORDER BY StudentID DESC
-- Determining table structure
EXEC sp_help STUDENTS


-- Deleting records from STUDENT_COURSE Table
DELETE FROM STUDENT_COURSE

-- Populating STUDENT_COURSE Table
-- First student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(1, (SELECT ID FROM COURSES WHERE Code = 'CSE-111'), 1, 1), -- CSE-111 (100L, First Semester, 1st Course)
(1, (SELECT ID FROM COURSES WHERE Code = 'CSE-112'), 1, 1), 
(1, (SELECT ID FROM COURSES WHERE Code = 'CSE-113'), 1, 1), 
(1, (SELECT ID FROM COURSES WHERE Code = 'CSE-114'), 1, 1), 
(1, (SELECT ID FROM COURSES WHERE Code = 'CSE-115'), 1, 1);

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(1, (SELECT ID FROM COURSES WHERE Code = 'CSE-121'), 1, 2), -- CSE-121 (100L, Second Semester, 1st Course)
(1, (SELECT ID FROM COURSES WHERE Code = 'CSE-122'), 1, 2), 
(1, (SELECT ID FROM COURSES WHERE Code = 'CSE-123'), 1, 2), 
(1, (SELECT ID FROM COURSES WHERE Code = 'CSE-124'), 1, 2), 
(1, (SELECT ID FROM COURSES WHERE Code = 'CSE-125'), 1, 2); 

-- Second student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(2, (SELECT ID FROM COURSES WHERE Code = 'CSE-111'), 1, 1), -- CSE-111 (100L, First Semester, 1st Course)
(2, (SELECT ID FROM COURSES WHERE Code = 'CSE-112'), 1, 1), 
(2, (SELECT ID FROM COURSES WHERE Code = 'CSE-113'), 1, 1), 
(2, (SELECT ID FROM COURSES WHERE Code = 'CSE-114'), 1, 1), 
(2, (SELECT ID FROM COURSES WHERE Code = 'CSE-115'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(2, (SELECT ID FROM COURSES WHERE Code = 'CSE-121'), 1, 2), -- CSE-121 (100L, Second Semester, 1st Course)
(2, (SELECT ID FROM COURSES WHERE Code = 'CSE-122'), 1, 2), 
(2, (SELECT ID FROM COURSES WHERE Code = 'CSE-123'), 1, 2), 
(2, (SELECT ID FROM COURSES WHERE Code = 'CSE-124'), 1, 2), 
(2, (SELECT ID FROM COURSES WHERE Code = 'CSE-125'), 1, 2); 

-- Third student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(3, (SELECT ID FROM COURSES WHERE Code = 'CSE-211'), 1, 1), -- CSE-211 (200L, First Semester, 1st Course)
(3, (SELECT ID FROM COURSES WHERE Code = 'CSE-212'), 1, 1), 
(3, (SELECT ID FROM COURSES WHERE Code = 'CSE-213'), 1, 1), 
(3, (SELECT ID FROM COURSES WHERE Code = 'CSE-214'), 1, 1), 
(3, (SELECT ID FROM COURSES WHERE Code = 'CSE-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(3, (SELECT ID FROM COURSES WHERE Code = 'CSE-221'), 1, 2), -- CSE-221 (200L, Second Semester, 1st Course)
(3, (SELECT ID FROM COURSES WHERE Code = 'CSE-222'), 1, 2), 
(3, (SELECT ID FROM COURSES WHERE Code = 'CSE-223'), 1, 2), 
(3, (SELECT ID FROM COURSES WHERE Code = 'CSE-224'), 1, 2), 
(3, (SELECT ID FROM COURSES WHERE Code = 'CSE-225'), 1, 2); 

-- Fourth student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(4, (SELECT ID FROM COURSES WHERE Code = 'CSE-211'), 1, 1), -- CSE-211 (200L, First Semester, 1st Course)
(4, (SELECT ID FROM COURSES WHERE Code = 'CSE-212'), 1, 1), 
(4, (SELECT ID FROM COURSES WHERE Code = 'CSE-213'), 1, 1), 
(4, (SELECT ID FROM COURSES WHERE Code = 'CSE-214'), 1, 1), 
(4, (SELECT ID FROM COURSES WHERE Code = 'CSE-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(4, (SELECT ID FROM COURSES WHERE Code = 'CSE-221'), 1, 2), -- CSE-221 (200L, Second Semester, 1st Course)
(4, (SELECT ID FROM COURSES WHERE Code = 'CSE-222'), 1, 2), 
(4, (SELECT ID FROM COURSES WHERE Code = 'CSE-223'), 1, 2), 
(4, (SELECT ID FROM COURSES WHERE Code = 'CSE-224'), 1, 2), 
(4, (SELECT ID FROM COURSES WHERE Code = 'CSE-225'), 1, 2); 

-- Fifth student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(5, (SELECT ID FROM COURSES WHERE Code = 'CSE-311'), 1, 1), -- CSE-311 (300L, First Semester, 1st Course)
(5, (SELECT ID FROM COURSES WHERE Code = 'CSE-312'), 1, 1), 
(5, (SELECT ID FROM COURSES WHERE Code = 'CSE-313'), 1, 1), 
(5, (SELECT ID FROM COURSES WHERE Code = 'CSE-314'), 1, 1), 
(5, (SELECT ID FROM COURSES WHERE Code = 'CSE-315'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(5, (SELECT ID FROM COURSES WHERE Code = 'CSE-321'), 1, 2), -- CSE-321 (300L, Second Semester, 1st Course)
(5, (SELECT ID FROM COURSES WHERE Code = 'CSE-322'), 1, 2), 
(5, (SELECT ID FROM COURSES WHERE Code = 'CSE-323'), 1, 2), 
(5, (SELECT ID FROM COURSES WHERE Code = 'CSE-324'), 1, 2), 
(5, (SELECT ID FROM COURSES WHERE Code = 'CSE-325'), 1, 2);

-- Sixth student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(6, (SELECT ID FROM COURSES WHERE Code = 'CSE-311'), 1, 1), -- CSE-311 (300L, First Semester, 1st Course)
(6, (SELECT ID FROM COURSES WHERE Code = 'CSE-312'), 1, 1), 
(6, (SELECT ID FROM COURSES WHERE Code = 'CSE-313'), 1, 1), 
(6, (SELECT ID FROM COURSES WHERE Code = 'CSE-314'), 1, 1), 
(6, (SELECT ID FROM COURSES WHERE Code = 'CSE-315'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(6, (SELECT ID FROM COURSES WHERE Code = 'CSE-321'), 1, 2), -- CSE-321 (300L, Second Semester, 1st Course)
(6, (SELECT ID FROM COURSES WHERE Code = 'CSE-322'), 1, 2), 
(6, (SELECT ID FROM COURSES WHERE Code = 'CSE-323'), 1, 2), 
(6, (SELECT ID FROM COURSES WHERE Code = 'CSE-324'), 1, 2), 
(6, (SELECT ID FROM COURSES WHERE Code = 'CSE-325'), 1, 2);

-- Seventh student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(7, (SELECT ID FROM COURSES WHERE Code = 'CSE-411'), 1, 1), -- CSE-411 (400L, First Semester, 1st Course)
(7, (SELECT ID FROM COURSES WHERE Code = 'CSE-412'), 1, 1), 
(7, (SELECT ID FROM COURSES WHERE Code = 'CSE-413'), 1, 1), 
(7, (SELECT ID FROM COURSES WHERE Code = 'CSE-414'), 1, 1), 
(7, (SELECT ID FROM COURSES WHERE Code = 'CSE-415'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(7, (SELECT ID FROM COURSES WHERE Code = 'CSE-421'), 1, 2), -- CSE-421 (400L, Second Semester, 1st Course)
(7, (SELECT ID FROM COURSES WHERE Code = 'CSE-422'), 1, 2), 
(7, (SELECT ID FROM COURSES WHERE Code = 'CSE-423'), 1, 2), 
(7, (SELECT ID FROM COURSES WHERE Code = 'CSE-424'), 1, 2), 
(7, (SELECT ID FROM COURSES WHERE Code = 'CSE-425'), 1, 2);

-- Eighth student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(8, (SELECT ID FROM COURSES WHERE Code = 'CSE-411'), 1, 1), -- CSE-411 (400L, First Semester, 1st Course)
(8, (SELECT ID FROM COURSES WHERE Code = 'CSE-412'), 1, 1), 
(8, (SELECT ID FROM COURSES WHERE Code = 'CSE-413'), 1, 1), 
(8, (SELECT ID FROM COURSES WHERE Code = 'CSE-414'), 1, 1), 
(8, (SELECT ID FROM COURSES WHERE Code = 'CSE-415'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(8, (SELECT ID FROM COURSES WHERE Code = 'CSE-421'), 1, 2), -- CSE-421 (400L, Second Semester, 1st Course)
(8, (SELECT ID FROM COURSES WHERE Code = 'CSE-422'), 1, 2), 
(8, (SELECT ID FROM COURSES WHERE Code = 'CSE-423'), 1, 2), 
(8, (SELECT ID FROM COURSES WHERE Code = 'CSE-424'), 1, 2), 
(8, (SELECT ID FROM COURSES WHERE Code = 'CSE-425'), 1, 2);

-- Ninth student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(9, (SELECT ID FROM COURSES WHERE Code = 'CSE-511'), 1, 1), -- CSE-511 (500L, First Semester, 1st Course)
(9, (SELECT ID FROM COURSES WHERE Code = 'CSE-512'), 1, 1), 
(9, (SELECT ID FROM COURSES WHERE Code = 'CSE-513'), 1, 1), 
(9, (SELECT ID FROM COURSES WHERE Code = 'CSE-514'), 1, 1), 
(9, (SELECT ID FROM COURSES WHERE Code = 'CSE-515'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(9, (SELECT ID FROM COURSES WHERE Code = 'CSE-521'), 1, 2), -- CSE-521 (500L, Second Semester, 1st Course)
(9, (SELECT ID FROM COURSES WHERE Code = 'CSE-522'), 1, 2), 
(9, (SELECT ID FROM COURSES WHERE Code = 'CSE-523'), 1, 2), 
(9, (SELECT ID FROM COURSES WHERE Code = 'CSE-524'), 1, 2), 
(9, (SELECT ID FROM COURSES WHERE Code = 'CSE-525'), 1, 2);

-- Tenth student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(10, (SELECT ID FROM COURSES WHERE Code = 'CSE-511'), 1, 1), -- CSE-511 (500L, First Semester, 1st Course)
(10, (SELECT ID FROM COURSES WHERE Code = 'CSE-512'), 1, 1), 
(10, (SELECT ID FROM COURSES WHERE Code = 'CSE-513'), 1, 1), 
(10, (SELECT ID FROM COURSES WHERE Code = 'CSE-514'), 1, 1), 
(10, (SELECT ID FROM COURSES WHERE Code = 'CSE-515'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(10, (SELECT ID FROM COURSES WHERE Code = 'CSE-521'), 1, 2), -- CSE-521 (500L, Second Semester, 1st Course)
(10, (SELECT ID FROM COURSES WHERE Code = 'CSE-522'), 1, 2), 
(10, (SELECT ID FROM COURSES WHERE Code = 'CSE-523'), 1, 2), 
(10, (SELECT ID FROM COURSES WHERE Code = 'CSE-524'), 1, 2), 
(10, (SELECT ID FROM COURSES WHERE Code = 'CSE-525'), 1, 2);

-- Eleventh student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(11, (SELECT ID FROM COURSES WHERE Code = 'MEE-111'), 1, 1), -- MEE-111 (100L, First Semester, 1st Course)
(11, (SELECT ID FROM COURSES WHERE Code = 'MEE-112'), 1, 1), 
(11, (SELECT ID FROM COURSES WHERE Code = 'MEE-113'), 1, 1), 
(11, (SELECT ID FROM COURSES WHERE Code = 'MEE-114'), 1, 1), 
(11, (SELECT ID FROM COURSES WHERE Code = 'MEE-115'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(11, (SELECT ID FROM COURSES WHERE Code = 'MEE-121'), 1, 2), -- MEE-121 (100L, Second Semester, 1st Course)
(11, (SELECT ID FROM COURSES WHERE Code = 'MEE-122'), 1, 2), 
(11, (SELECT ID FROM COURSES WHERE Code = 'MEE-123'), 1, 2), 
(11, (SELECT ID FROM COURSES WHERE Code = 'MEE-124'), 1, 2), 
(11, (SELECT ID FROM COURSES WHERE Code = 'MEE-125'), 1, 2);

-- Twelfth student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(12, (SELECT ID FROM COURSES WHERE Code = 'MEE-111'), 1, 1), -- MEE-111 (100L, First Semester, 1st Course)
(12, (SELECT ID FROM COURSES WHERE Code = 'MEE-112'), 1, 1), 
(12, (SELECT ID FROM COURSES WHERE Code = 'MEE-113'), 1, 1), 
(12, (SELECT ID FROM COURSES WHERE Code = 'MEE-114'), 1, 1), 
(12, (SELECT ID FROM COURSES WHERE Code = 'MEE-115'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(12, (SELECT ID FROM COURSES WHERE Code = 'MEE-121'), 1, 2), -- MEE-121 (100L, Second Semester, 1st Course)
(12, (SELECT ID FROM COURSES WHERE Code = 'MEE-122'), 1, 2), 
(12, (SELECT ID FROM COURSES WHERE Code = 'MEE-123'), 1, 2), 
(12, (SELECT ID FROM COURSES WHERE Code = 'MEE-124'), 1, 2), 
(12, (SELECT ID FROM COURSES WHERE Code = 'MEE-125'), 1, 2);

-- Thirteenth student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(13, (SELECT ID FROM COURSES WHERE Code = 'MEE-211'), 1, 1), -- MEE-211 (200L, First Semester, 1st Course)
(13, (SELECT ID FROM COURSES WHERE Code = 'MEE-212'), 1, 1), 
(13, (SELECT ID FROM COURSES WHERE Code = 'MEE-213'), 1, 1), 
(13, (SELECT ID FROM COURSES WHERE Code = 'MEE-214'), 1, 1), 
(13, (SELECT ID FROM COURSES WHERE Code = 'MEE-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(13, (SELECT ID FROM COURSES WHERE Code = 'MEE-221'), 1, 2), -- MEE-221 (200L, Second Semester, 1st Course)
(13, (SELECT ID FROM COURSES WHERE Code = 'MEE-222'), 1, 2), 
(13, (SELECT ID FROM COURSES WHERE Code = 'MEE-223'), 1, 2), 
(13, (SELECT ID FROM COURSES WHERE Code = 'MEE-224'), 1, 2), 
(13, (SELECT ID FROM COURSES WHERE Code = 'MEE-225'), 1, 2);

-- Fourteenth student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(14, (SELECT ID FROM COURSES WHERE Code = 'MEE-211'), 1, 1), -- MEE-211 (200L, First Semester, 1st Course)
(14, (SELECT ID FROM COURSES WHERE Code = 'MEE-212'), 1, 1), 
(14, (SELECT ID FROM COURSES WHERE Code = 'MEE-213'), 1, 1), 
(14, (SELECT ID FROM COURSES WHERE Code = 'MEE-214'), 1, 1), 
(14, (SELECT ID FROM COURSES WHERE Code = 'MEE-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(14, (SELECT ID FROM COURSES WHERE Code = 'MEE-221'), 1, 2), -- MEE-221 (200L, Second Semester, 1st Course)
(14, (SELECT ID FROM COURSES WHERE Code = 'MEE-222'), 1, 2), 
(14, (SELECT ID FROM COURSES WHERE Code = 'MEE-223'), 1, 2), 
(14, (SELECT ID FROM COURSES WHERE Code = 'MEE-224'), 1, 2), 
(14, (SELECT ID FROM COURSES WHERE Code = 'MEE-225'), 1, 2);

-- Fifteenth student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(15, (SELECT ID FROM COURSES WHERE Code = 'MEE-311'), 1, 1), -- MEE-311 (300L, First Semester, 1st Course)
(15, (SELECT ID FROM COURSES WHERE Code = 'MEE-312'), 1, 1), 
(15, (SELECT ID FROM COURSES WHERE Code = 'MEE-313'), 1, 1), 
(15, (SELECT ID FROM COURSES WHERE Code = 'MEE-314'), 1, 1), 
(15, (SELECT ID FROM COURSES WHERE Code = 'MEE-315'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(15, (SELECT ID FROM COURSES WHERE Code = 'MEE-321'), 1, 2), -- MEE-321 (300L, Second Semester, 1st Course)
(15, (SELECT ID FROM COURSES WHERE Code = 'MEE-322'), 1, 2), 
(15, (SELECT ID FROM COURSES WHERE Code = 'MEE-323'), 1, 2), 
(15, (SELECT ID FROM COURSES WHERE Code = 'MEE-324'), 1, 2), 
(15, (SELECT ID FROM COURSES WHERE Code = 'MEE-325'), 1, 2);

-- Sixteenth student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(16, (SELECT ID FROM COURSES WHERE Code = 'MEE-311'), 1, 1), -- MEE-311 (300L, First Semester, 1st Course)
(16, (SELECT ID FROM COURSES WHERE Code = 'MEE-312'), 1, 1), 
(16, (SELECT ID FROM COURSES WHERE Code = 'MEE-313'), 1, 1), 
(16, (SELECT ID FROM COURSES WHERE Code = 'MEE-314'), 1, 1), 
(16, (SELECT ID FROM COURSES WHERE Code = 'MEE-315'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(16, (SELECT ID FROM COURSES WHERE Code = 'MEE-321'), 1, 2), -- MEE-321 (300L, Second Semester, 1st Course)
(16, (SELECT ID FROM COURSES WHERE Code = 'MEE-322'), 1, 2), 
(16, (SELECT ID FROM COURSES WHERE Code = 'MEE-323'), 1, 2), 
(16, (SELECT ID FROM COURSES WHERE Code = 'MEE-324'), 1, 2), 
(16, (SELECT ID FROM COURSES WHERE Code = 'MEE-325'), 1, 2);

-- Seventeenth student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(17, (SELECT ID FROM COURSES WHERE Code = 'MEE-411'), 1, 1), -- MEE-411 (400L, First Semester, 1st Course)
(17, (SELECT ID FROM COURSES WHERE Code = 'MEE-412'), 1, 1), 
(17, (SELECT ID FROM COURSES WHERE Code = 'MEE-413'), 1, 1), 
(17, (SELECT ID FROM COURSES WHERE Code = 'MEE-414'), 1, 1), 
(17, (SELECT ID FROM COURSES WHERE Code = 'MEE-415'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(17, (SELECT ID FROM COURSES WHERE Code = 'MEE-421'), 1, 2), -- MEE-421 (400L, Second Semester, 1st Course)
(17, (SELECT ID FROM COURSES WHERE Code = 'MEE-422'), 1, 2), 
(17, (SELECT ID FROM COURSES WHERE Code = 'MEE-423'), 1, 2), 
(17, (SELECT ID FROM COURSES WHERE Code = 'MEE-424'), 1, 2), 
(17, (SELECT ID FROM COURSES WHERE Code = 'MEE-425'), 1, 2);

-- Eighteenth student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(18, (SELECT ID FROM COURSES WHERE Code = 'MEE-411'), 1, 1), -- MEE-411 (400L, First Semester, 1st Course)
(18, (SELECT ID FROM COURSES WHERE Code = 'MEE-412'), 1, 1), 
(18, (SELECT ID FROM COURSES WHERE Code = 'MEE-413'), 1, 1), 
(18, (SELECT ID FROM COURSES WHERE Code = 'MEE-414'), 1, 1), 
(18, (SELECT ID FROM COURSES WHERE Code = 'MEE-415'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(18, (SELECT ID FROM COURSES WHERE Code = 'MEE-421'), 1, 2), -- MEE-421 (400L, Second Semester, 1st Course)
(18, (SELECT ID FROM COURSES WHERE Code = 'MEE-422'), 1, 2), 
(18, (SELECT ID FROM COURSES WHERE Code = 'MEE-423'), 1, 2), 
(18, (SELECT ID FROM COURSES WHERE Code = 'MEE-424'), 1, 2), 
(18, (SELECT ID FROM COURSES WHERE Code = 'MEE-425'), 1, 2);

-- Ninteenth student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(19, (SELECT ID FROM COURSES WHERE Code = 'MEE-511'), 1, 1), -- MEE-511 (500L, First Semester, 1st Course)
(19, (SELECT ID FROM COURSES WHERE Code = 'MEE-512'), 1, 1), 
(19, (SELECT ID FROM COURSES WHERE Code = 'MEE-513'), 1, 1), 
(19, (SELECT ID FROM COURSES WHERE Code = 'MEE-514'), 1, 1), 
(19, (SELECT ID FROM COURSES WHERE Code = 'MEE-515'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(19, (SELECT ID FROM COURSES WHERE Code = 'MEE-521'), 1, 2), -- MEE-521 (500L, Second Semester, 1st Course)
(19, (SELECT ID FROM COURSES WHERE Code = 'MEE-522'), 1, 2), 
(19, (SELECT ID FROM COURSES WHERE Code = 'MEE-523'), 1, 2), 
(19, (SELECT ID FROM COURSES WHERE Code = 'MEE-524'), 1, 2), 
(19, (SELECT ID FROM COURSES WHERE Code = 'MEE-525'), 1, 2);

-- Twentieth student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(20, (SELECT ID FROM COURSES WHERE Code = 'MEE-511'), 1, 1), -- MEE-511 (500L, First Semester, 1st Course)
(20, (SELECT ID FROM COURSES WHERE Code = 'MEE-512'), 1, 1), 
(20, (SELECT ID FROM COURSES WHERE Code = 'MEE-513'), 1, 1), 
(20, (SELECT ID FROM COURSES WHERE Code = 'MEE-514'), 1, 1), 
(20, (SELECT ID FROM COURSES WHERE Code = 'MEE-515'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(20, (SELECT ID FROM COURSES WHERE Code = 'MEE-521'), 1, 2), -- MEE-521 (500L, Second Semester, 1st Course)
(20, (SELECT ID FROM COURSES WHERE Code = 'MEE-522'), 1, 2), 
(20, (SELECT ID FROM COURSES WHERE Code = 'MEE-523'), 1, 2), 
(20, (SELECT ID FROM COURSES WHERE Code = 'MEE-524'), 1, 2), 
(20, (SELECT ID FROM COURSES WHERE Code = 'MEE-525'), 1, 2);

-- Twenty-First student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(21, (SELECT ID FROM COURSES WHERE Code = 'ELE-111'), 1, 1), -- ELE-111 (100L, First Semester, 1st Course)
(21, (SELECT ID FROM COURSES WHERE Code = 'ELE-112'), 1, 1), 
(21, (SELECT ID FROM COURSES WHERE Code = 'ELE-113'), 1, 1), 
(21, (SELECT ID FROM COURSES WHERE Code = 'ELE-114'), 1, 1), 
(21, (SELECT ID FROM COURSES WHERE Code = 'ELE-115'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(21, (SELECT ID FROM COURSES WHERE Code = 'ELE-121'), 1, 2), -- ElE-121 (100L, Second Semester, 1st Course)
(21, (SELECT ID FROM COURSES WHERE Code = 'ELE-122'), 1, 2), 
(21, (SELECT ID FROM COURSES WHERE Code = 'ELE-123'), 1, 2), 
(21, (SELECT ID FROM COURSES WHERE Code = 'ELE-124'), 1, 2), 
(21, (SELECT ID FROM COURSES WHERE Code = 'ELE-125'), 1, 2);

-- Twenty-Second student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(22, (SELECT ID FROM COURSES WHERE Code = 'ELE-111'), 1, 1), -- ELE-111 (100L, First Semester, 1st Course)
(22, (SELECT ID FROM COURSES WHERE Code = 'ELE-112'), 1, 1), 
(22, (SELECT ID FROM COURSES WHERE Code = 'ELE-113'), 1, 1), 
(22, (SELECT ID FROM COURSES WHERE Code = 'ELE-114'), 1, 1), 
(22, (SELECT ID FROM COURSES WHERE Code = 'ELE-115'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(22, (SELECT ID FROM COURSES WHERE Code = 'ELE-121'), 1, 2), -- ElE-121 (100L, Second Semester, 1st Course)
(22, (SELECT ID FROM COURSES WHERE Code = 'ELE-122'), 1, 2), 
(22, (SELECT ID FROM COURSES WHERE Code = 'ELE-123'), 1, 2), 
(22, (SELECT ID FROM COURSES WHERE Code = 'ELE-124'), 1, 2), 
(22, (SELECT ID FROM COURSES WHERE Code = 'ELE-125'), 1, 2);

-- Twenty-Third Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(23, (SELECT ID FROM COURSES WHERE Code = 'ELE-211'), 1, 1), -- ELE-211 (200L, First Semester, 1st Course)
(23, (SELECT ID FROM COURSES WHERE Code = 'ELE-212'), 1, 1), 
(23, (SELECT ID FROM COURSES WHERE Code = 'ELE-213'), 1, 1), 
(23, (SELECT ID FROM COURSES WHERE Code = 'ELE-214'), 1, 1), 
(23, (SELECT ID FROM COURSES WHERE Code = 'ELE-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(23, (SELECT ID FROM COURSES WHERE Code = 'ELE-221'), 1, 2), -- ElE-221 (200L, Second Semester, 1st Course)
(23, (SELECT ID FROM COURSES WHERE Code = 'ELE-222'), 1, 2), 
(23, (SELECT ID FROM COURSES WHERE Code = 'ELE-223'), 1, 2), 
(23, (SELECT ID FROM COURSES WHERE Code = 'ELE-224'), 1, 2), 
(23, (SELECT ID FROM COURSES WHERE Code = 'ELE-225'), 1, 2);

-- Twenty-Fourth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(24, (SELECT ID FROM COURSES WHERE Code = 'ELE-211'), 1, 1), -- ELE-211 (200L, First Semester, 1st Course)
(24, (SELECT ID FROM COURSES WHERE Code = 'ELE-212'), 1, 1), 
(24, (SELECT ID FROM COURSES WHERE Code = 'ELE-213'), 1, 1), 
(24, (SELECT ID FROM COURSES WHERE Code = 'ELE-214'), 1, 1), 
(24, (SELECT ID FROM COURSES WHERE Code = 'ELE-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(24, (SELECT ID FROM COURSES WHERE Code = 'ELE-221'), 1, 2), -- ElE-221 (200L, Second Semester, 1st Course)
(24, (SELECT ID FROM COURSES WHERE Code = 'ELE-222'), 1, 2), 
(24, (SELECT ID FROM COURSES WHERE Code = 'ELE-223'), 1, 2), 
(24, (SELECT ID FROM COURSES WHERE Code = 'ELE-224'), 1, 2), 
(24, (SELECT ID FROM COURSES WHERE Code = 'ELE-225'), 1, 2);

-- Twenty-Fifth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(25, (SELECT ID FROM COURSES WHERE Code = 'ELE-311'), 1, 1), -- ELE-311 (300L, First Semester, 1st Course)
(25, (SELECT ID FROM COURSES WHERE Code = 'ELE-312'), 1, 1), 
(25, (SELECT ID FROM COURSES WHERE Code = 'ELE-313'), 1, 1), 
(25, (SELECT ID FROM COURSES WHERE Code = 'ELE-314'), 1, 1), 
(25, (SELECT ID FROM COURSES WHERE Code = 'ELE-315'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(25, (SELECT ID FROM COURSES WHERE Code = 'ELE-321'), 1, 2), -- ElE-321 (300L, Second Semester, 1st Course)
(25, (SELECT ID FROM COURSES WHERE Code = 'ELE-322'), 1, 2), 
(25, (SELECT ID FROM COURSES WHERE Code = 'ELE-323'), 1, 2), 
(25, (SELECT ID FROM COURSES WHERE Code = 'ELE-324'), 1, 2), 
(25, (SELECT ID FROM COURSES WHERE Code = 'ELE-325'), 1, 2);

-- Twenty-Sixth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(26, (SELECT ID FROM COURSES WHERE Code = 'ELE-311'), 1, 1), -- ELE-311 (300L, First Semester, 1st Course)
(26, (SELECT ID FROM COURSES WHERE Code = 'ELE-312'), 1, 1), 
(26, (SELECT ID FROM COURSES WHERE Code = 'ELE-313'), 1, 1), 
(26, (SELECT ID FROM COURSES WHERE Code = 'ELE-314'), 1, 1), 
(26, (SELECT ID FROM COURSES WHERE Code = 'ELE-315'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(26, (SELECT ID FROM COURSES WHERE Code = 'ELE-321'), 1, 2), -- ElE-321 (300L, Second Semester, 1st Course)
(26, (SELECT ID FROM COURSES WHERE Code = 'ELE-322'), 1, 2), 
(26, (SELECT ID FROM COURSES WHERE Code = 'ELE-323'), 1, 2), 
(26, (SELECT ID FROM COURSES WHERE Code = 'ELE-324'), 1, 2), 
(26, (SELECT ID FROM COURSES WHERE Code = 'ELE-325'), 1, 2);

-- Twenty-Seventh Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(27, (SELECT ID FROM COURSES WHERE Code = 'ELE-411'), 1, 1), -- ELE-411 (400L, First Semester, 1st Course)
(27, (SELECT ID FROM COURSES WHERE Code = 'ELE-412'), 1, 1), 
(27, (SELECT ID FROM COURSES WHERE Code = 'ELE-413'), 1, 1), 
(27, (SELECT ID FROM COURSES WHERE Code = 'ELE-414'), 1, 1), 
(27, (SELECT ID FROM COURSES WHERE Code = 'ELE-415'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(27, (SELECT ID FROM COURSES WHERE Code = 'ELE-421'), 1, 2), -- ElE-421 (400L, Second Semester, 1st Course)
(27, (SELECT ID FROM COURSES WHERE Code = 'ELE-422'), 1, 2), 
(27, (SELECT ID FROM COURSES WHERE Code = 'ELE-423'), 1, 2), 
(27, (SELECT ID FROM COURSES WHERE Code = 'ELE-424'), 1, 2), 
(27, (SELECT ID FROM COURSES WHERE Code = 'ELE-425'), 1, 2);

-- Twenty-Eighth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(28, (SELECT ID FROM COURSES WHERE Code = 'ELE-411'), 1, 1), -- ELE-411 (400L, First Semester, 1st Course)
(28, (SELECT ID FROM COURSES WHERE Code = 'ELE-412'), 1, 1), 
(28, (SELECT ID FROM COURSES WHERE Code = 'ELE-413'), 1, 1), 
(28, (SELECT ID FROM COURSES WHERE Code = 'ELE-414'), 1, 1), 
(28, (SELECT ID FROM COURSES WHERE Code = 'ELE-415'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(28, (SELECT ID FROM COURSES WHERE Code = 'ELE-421'), 1, 2), -- ElE-421 (400L, Second Semester, 1st Course)
(28, (SELECT ID FROM COURSES WHERE Code = 'ELE-422'), 1, 2), 
(28, (SELECT ID FROM COURSES WHERE Code = 'ELE-423'), 1, 2), 
(28, (SELECT ID FROM COURSES WHERE Code = 'ELE-424'), 1, 2), 
(28, (SELECT ID FROM COURSES WHERE Code = 'ELE-425'), 1, 2);

-- Twenty-Ninth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(29, (SELECT ID FROM COURSES WHERE Code = 'ELE-511'), 1, 1), -- ELE-511 (500L, First Semester, 1st Course)
(29, (SELECT ID FROM COURSES WHERE Code = 'ELE-512'), 1, 1), 
(29, (SELECT ID FROM COURSES WHERE Code = 'ELE-513'), 1, 1), 
(29, (SELECT ID FROM COURSES WHERE Code = 'ELE-514'), 1, 1), 
(29, (SELECT ID FROM COURSES WHERE Code = 'ELE-515'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(29, (SELECT ID FROM COURSES WHERE Code = 'ELE-521'), 1, 2), -- ElE-521 (500L, Second Semester, 1st Course)
(29, (SELECT ID FROM COURSES WHERE Code = 'ELE-522'), 1, 2), 
(29, (SELECT ID FROM COURSES WHERE Code = 'ELE-523'), 1, 2), 
(29, (SELECT ID FROM COURSES WHERE Code = 'ELE-524'), 1, 2), 
(29, (SELECT ID FROM COURSES WHERE Code = 'ELE-525'), 1, 2);

-- Thirtieth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(30, (SELECT ID FROM COURSES WHERE Code = 'ELE-511'), 1, 1), -- ELE-511 (500L, First Semester, 1st Course)
(30, (SELECT ID FROM COURSES WHERE Code = 'ELE-512'), 1, 1), 
(30, (SELECT ID FROM COURSES WHERE Code = 'ELE-513'), 1, 1), 
(30, (SELECT ID FROM COURSES WHERE Code = 'ELE-514'), 1, 1), 
(30, (SELECT ID FROM COURSES WHERE Code = 'ELE-515'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(30, (SELECT ID FROM COURSES WHERE Code = 'ELE-521'), 1, 2), -- ElE-521 (500L, Second Semester, 1st Course)
(30, (SELECT ID FROM COURSES WHERE Code = 'ELE-522'), 1, 2), 
(30, (SELECT ID FROM COURSES WHERE Code = 'ELE-523'), 1, 2), 
(30, (SELECT ID FROM COURSES WHERE Code = 'ELE-524'), 1, 2), 
(30, (SELECT ID FROM COURSES WHERE Code = 'ELE-525'), 1, 2);

-- Thirty-First Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(31, (SELECT ID FROM COURSES WHERE Code = 'CIV-111'), 1, 1), -- CIV-111 (100L, First Semester, 1st Course)
(31, (SELECT ID FROM COURSES WHERE Code = 'CIV-112'), 1, 1), 
(31, (SELECT ID FROM COURSES WHERE Code = 'CIV-113'), 1, 1), 
(31, (SELECT ID FROM COURSES WHERE Code = 'CIV-114'), 1, 1), 
(31, (SELECT ID FROM COURSES WHERE Code = 'CIV-115'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(31, (SELECT ID FROM COURSES WHERE Code = 'CIV-521'), 1, 2), -- CIV-121 (100L, Second Semester, 1st Course)
(31, (SELECT ID FROM COURSES WHERE Code = 'CIV-522'), 1, 2), 
(31, (SELECT ID FROM COURSES WHERE Code = 'CIV-523'), 1, 2), 
(31, (SELECT ID FROM COURSES WHERE Code = 'CIV-524'), 1, 2), 
(31, (SELECT ID FROM COURSES WHERE Code = 'CIV-525'), 1, 2);

-- Thirty-Second Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(32, (SELECT ID FROM COURSES WHERE Code = 'CIV-111'), 1, 1), -- CIV-111 (100L, First Semester, 1st Course)
(32, (SELECT ID FROM COURSES WHERE Code = 'CIV-112'), 1, 1), 
(32, (SELECT ID FROM COURSES WHERE Code = 'CIV-113'), 1, 1), 
(32, (SELECT ID FROM COURSES WHERE Code = 'CIV-114'), 1, 1), 
(32, (SELECT ID FROM COURSES WHERE Code = 'CIV-115'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(32, (SELECT ID FROM COURSES WHERE Code = 'CIV-121'), 1, 2), -- CIV-121 (100L, Second Semester, 1st Course)
(32, (SELECT ID FROM COURSES WHERE Code = 'CIV-122'), 1, 2), 
(32, (SELECT ID FROM COURSES WHERE Code = 'CIV-123'), 1, 2), 
(32, (SELECT ID FROM COURSES WHERE Code = 'CIV-124'), 1, 2), 
(32, (SELECT ID FROM COURSES WHERE Code = 'CIV-125'), 1, 2);

-- Thirty-Third Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(33, (SELECT ID FROM COURSES WHERE Code = 'CIV-211'), 1, 1), -- CIV-211 (200L, First Semester, 1st Course)
(33, (SELECT ID FROM COURSES WHERE Code = 'CIV-212'), 1, 1), 
(33, (SELECT ID FROM COURSES WHERE Code = 'CIV-213'), 1, 1), 
(33, (SELECT ID FROM COURSES WHERE Code = 'CIV-214'), 1, 1), 
(33, (SELECT ID FROM COURSES WHERE Code = 'CIV-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(33, (SELECT ID FROM COURSES WHERE Code = 'CIV-221'), 1, 2), -- CIV-221 (200L, Second Semester, 1st Course)
(33, (SELECT ID FROM COURSES WHERE Code = 'CIV-222'), 1, 2), 
(33, (SELECT ID FROM COURSES WHERE Code = 'CIV-223'), 1, 2), 
(33, (SELECT ID FROM COURSES WHERE Code = 'CIV-224'), 1, 2), 
(33, (SELECT ID FROM COURSES WHERE Code = 'CIV-225'), 1, 2);

-- Thirty-Fourth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(34, (SELECT ID FROM COURSES WHERE Code = 'CIV-211'), 1, 1), -- CIV-211 (200L, First Semester, 1st Course)
(34, (SELECT ID FROM COURSES WHERE Code = 'CIV-212'), 1, 1), 
(34, (SELECT ID FROM COURSES WHERE Code = 'CIV-213'), 1, 1), 
(34, (SELECT ID FROM COURSES WHERE Code = 'CIV-214'), 1, 1), 
(34, (SELECT ID FROM COURSES WHERE Code = 'CIV-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(34, (SELECT ID FROM COURSES WHERE Code = 'CIV-221'), 1, 2), -- CIV-221 (200L, Second Semester, 1st Course)
(34, (SELECT ID FROM COURSES WHERE Code = 'CIV-222'), 1, 2), 
(34, (SELECT ID FROM COURSES WHERE Code = 'CIV-223'), 1, 2), 
(34, (SELECT ID FROM COURSES WHERE Code = 'CIV-224'), 1, 2), 
(34, (SELECT ID FROM COURSES WHERE Code = 'CIV-225'), 1, 2);

-- Thirty-Fifth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(35, (SELECT ID FROM COURSES WHERE Code = 'CIV-311'), 1, 1), -- CIV-311 (300L, First Semester, 1st Course)
(35, (SELECT ID FROM COURSES WHERE Code = 'CIV-312'), 1, 1), 
(35, (SELECT ID FROM COURSES WHERE Code = 'CIV-313'), 1, 1), 
(35, (SELECT ID FROM COURSES WHERE Code = 'CIV-314'), 1, 1), 
(35, (SELECT ID FROM COURSES WHERE Code = 'CIV-315'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(35, (SELECT ID FROM COURSES WHERE Code = 'CIV-321'), 1, 2), -- CIV-321 (300L, Second Semester, 1st Course)
(35, (SELECT ID FROM COURSES WHERE Code = 'CIV-322'), 1, 2), 
(35, (SELECT ID FROM COURSES WHERE Code = 'CIV-323'), 1, 2), 
(35, (SELECT ID FROM COURSES WHERE Code = 'CIV-324'), 1, 2), 
(35, (SELECT ID FROM COURSES WHERE Code = 'CIV-325'), 1, 2);

-- Thirty-Sixth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(36, (SELECT ID FROM COURSES WHERE Code = 'CIV-311'), 1, 1), -- CIV-311 (300L, First Semester, 1st Course)
(36, (SELECT ID FROM COURSES WHERE Code = 'CIV-312'), 1, 1), 
(36, (SELECT ID FROM COURSES WHERE Code = 'CIV-313'), 1, 1), 
(36, (SELECT ID FROM COURSES WHERE Code = 'CIV-314'), 1, 1), 
(36, (SELECT ID FROM COURSES WHERE Code = 'CIV-315'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(36, (SELECT ID FROM COURSES WHERE Code = 'CIV-321'), 1, 2), -- CIV-321 (300L, Second Semester, 1st Course)
(36, (SELECT ID FROM COURSES WHERE Code = 'CIV-322'), 1, 2), 
(36, (SELECT ID FROM COURSES WHERE Code = 'CIV-323'), 1, 2), 
(36, (SELECT ID FROM COURSES WHERE Code = 'CIV-324'), 1, 2), 
(36, (SELECT ID FROM COURSES WHERE Code = 'CIV-325'), 1, 2);

-- Thirty-Seventh Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(37, (SELECT ID FROM COURSES WHERE Code = 'CIV-411'), 1, 1), -- CIV-411 (400L, First Semester, 1st Course)
(37, (SELECT ID FROM COURSES WHERE Code = 'CIV-412'), 1, 1), 
(37, (SELECT ID FROM COURSES WHERE Code = 'CIV-413'), 1, 1), 
(37, (SELECT ID FROM COURSES WHERE Code = 'CIV-414'), 1, 1), 
(37, (SELECT ID FROM COURSES WHERE Code = 'CIV-415'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(37, (SELECT ID FROM COURSES WHERE Code = 'CIV-421'), 1, 2), -- CIV-421 (400L, Second Semester, 1st Course)
(37, (SELECT ID FROM COURSES WHERE Code = 'CIV-422'), 1, 2), 
(37, (SELECT ID FROM COURSES WHERE Code = 'CIV-423'), 1, 2), 
(37, (SELECT ID FROM COURSES WHERE Code = 'CIV-424'), 1, 2), 
(37, (SELECT ID FROM COURSES WHERE Code = 'CIV-425'), 1, 2);

-- Thirty-Eighth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(38, (SELECT ID FROM COURSES WHERE Code = 'CIV-411'), 1, 1), -- CIV-411 (400L, First Semester, 1st Course)
(38, (SELECT ID FROM COURSES WHERE Code = 'CIV-412'), 1, 1), 
(38, (SELECT ID FROM COURSES WHERE Code = 'CIV-413'), 1, 1), 
(38, (SELECT ID FROM COURSES WHERE Code = 'CIV-414'), 1, 1), 
(38, (SELECT ID FROM COURSES WHERE Code = 'CIV-415'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(38, (SELECT ID FROM COURSES WHERE Code = 'CIV-421'), 1, 2), -- CIV-421 (400L, Second Semester, 1st Course)
(38, (SELECT ID FROM COURSES WHERE Code = 'CIV-422'), 1, 2), 
(38, (SELECT ID FROM COURSES WHERE Code = 'CIV-423'), 1, 2), 
(38, (SELECT ID FROM COURSES WHERE Code = 'CIV-424'), 1, 2), 
(38, (SELECT ID FROM COURSES WHERE Code = 'CIV-425'), 1, 2);

-- Thirty-Ninth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(39, (SELECT ID FROM COURSES WHERE Code = 'CIV-511'), 1, 1), -- CIV-511 (500L, First Semester, 1st Course)
(39, (SELECT ID FROM COURSES WHERE Code = 'CIV-512'), 1, 1), 
(39, (SELECT ID FROM COURSES WHERE Code = 'CIV-513'), 1, 1), 
(39, (SELECT ID FROM COURSES WHERE Code = 'CIV-514'), 1, 1), 
(39, (SELECT ID FROM COURSES WHERE Code = 'CIV-515'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(39, (SELECT ID FROM COURSES WHERE Code = 'CIV-521'), 1, 2), -- CIV-521 (500L, Second Semester, 1st Course)
(39, (SELECT ID FROM COURSES WHERE Code = 'CIV-522'), 1, 2), 
(39, (SELECT ID FROM COURSES WHERE Code = 'CIV-523'), 1, 2), 
(39, (SELECT ID FROM COURSES WHERE Code = 'CIV-524'), 1, 2), 
(39, (SELECT ID FROM COURSES WHERE Code = 'CIV-525'), 1, 2);

-- Fortieth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(40, (SELECT ID FROM COURSES WHERE Code = 'CIV-511'), 1, 1), -- CIV-511 (500L, First Semester, 1st Course)
(40, (SELECT ID FROM COURSES WHERE Code = 'CIV-512'), 1, 1), 
(40, (SELECT ID FROM COURSES WHERE Code = 'CIV-513'), 1, 1), 
(40, (SELECT ID FROM COURSES WHERE Code = 'CIV-514'), 1, 1), 
(40, (SELECT ID FROM COURSES WHERE Code = 'CIV-515'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(40, (SELECT ID FROM COURSES WHERE Code = 'CIV-521'), 1, 2), -- CIV-521 (500L, Second Semester, 1st Course)
(40, (SELECT ID FROM COURSES WHERE Code = 'CIV-522'), 1, 2), 
(40, (SELECT ID FROM COURSES WHERE Code = 'CIV-523'), 1, 2), 
(40, (SELECT ID FROM COURSES WHERE Code = 'CIV-524'), 1, 2), 
(40, (SELECT ID FROM COURSES WHERE Code = 'CIV-525'), 1, 2);

-- Forty-First Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(41, (SELECT ID FROM COURSES WHERE Code = 'CHE-111'), 1, 1), -- CHE-111 (100L, First Semester, 1st Course)
(41, (SELECT ID FROM COURSES WHERE Code = 'CHE-112'), 1, 1), 
(41, (SELECT ID FROM COURSES WHERE Code = 'CHE-113'), 1, 1), 
(41, (SELECT ID FROM COURSES WHERE Code = 'CHE-114'), 1, 1), 
(41, (SELECT ID FROM COURSES WHERE Code = 'CHE-115'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(41, (SELECT ID FROM COURSES WHERE Code = 'CHE-121'), 1, 2), -- CHE-121 (100L, Second Semester, 1st Course)
(41, (SELECT ID FROM COURSES WHERE Code = 'CHE-122'), 1, 2), 
(41, (SELECT ID FROM COURSES WHERE Code = 'CHE-123'), 1, 2), 
(41, (SELECT ID FROM COURSES WHERE Code = 'CHE-124'), 1, 2), 
(41, (SELECT ID FROM COURSES WHERE Code = 'CHE-125'), 1, 2);

-- Forty-Second Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(42, (SELECT ID FROM COURSES WHERE Code = 'CHE-111'), 1, 1), -- CHE-111 (100L, First Semester, 1st Course)
(42, (SELECT ID FROM COURSES WHERE Code = 'CHE-112'), 1, 1), 
(42, (SELECT ID FROM COURSES WHERE Code = 'CHE-113'), 1, 1), 
(42, (SELECT ID FROM COURSES WHERE Code = 'CHE-114'), 1, 1), 
(42, (SELECT ID FROM COURSES WHERE Code = 'CHE-115'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(42, (SELECT ID FROM COURSES WHERE Code = 'CHE-121'), 1, 2), -- CHE-121 (100L, Second Semester, 1st Course)
(42, (SELECT ID FROM COURSES WHERE Code = 'CHE-122'), 1, 2), 
(42, (SELECT ID FROM COURSES WHERE Code = 'CHE-123'), 1, 2), 
(42, (SELECT ID FROM COURSES WHERE Code = 'CHE-124'), 1, 2), 
(42, (SELECT ID FROM COURSES WHERE Code = 'CHE-125'), 1, 2);

-- Forty-Third Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(43, (SELECT ID FROM COURSES WHERE Code = 'CHE-211'), 1, 1), -- CHE-211 (200L, First Semester, 1st Course)
(43, (SELECT ID FROM COURSES WHERE Code = 'CHE-212'), 1, 1), 
(43, (SELECT ID FROM COURSES WHERE Code = 'CHE-213'), 1, 1), 
(43, (SELECT ID FROM COURSES WHERE Code = 'CHE-214'), 1, 1), 
(43, (SELECT ID FROM COURSES WHERE Code = 'CHE-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(43, (SELECT ID FROM COURSES WHERE Code = 'CHE-221'), 1, 2), -- CHE-221 (200L, Second Semester, 1st Course)
(43, (SELECT ID FROM COURSES WHERE Code = 'CHE-222'), 1, 2), 
(43, (SELECT ID FROM COURSES WHERE Code = 'CHE-223'), 1, 2), 
(43, (SELECT ID FROM COURSES WHERE Code = 'CHE-224'), 1, 2), 
(43, (SELECT ID FROM COURSES WHERE Code = 'CHE-225'), 1, 2);

-- Forty-Fourth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(44, (SELECT ID FROM COURSES WHERE Code = 'CHE-211'), 1, 1), -- CHE-211 (200L, First Semester, 1st Course)
(44, (SELECT ID FROM COURSES WHERE Code = 'CHE-212'), 1, 1), 
(44, (SELECT ID FROM COURSES WHERE Code = 'CHE-213'), 1, 1), 
(44, (SELECT ID FROM COURSES WHERE Code = 'CHE-214'), 1, 1), 
(44, (SELECT ID FROM COURSES WHERE Code = 'CHE-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(44, (SELECT ID FROM COURSES WHERE Code = 'CHE-221'), 1, 2), -- CHE-221 (200L, Second Semester, 1st Course)
(44, (SELECT ID FROM COURSES WHERE Code = 'CHE-222'), 1, 2), 
(44, (SELECT ID FROM COURSES WHERE Code = 'CHE-223'), 1, 2), 
(44, (SELECT ID FROM COURSES WHERE Code = 'CHE-224'), 1, 2), 
(44, (SELECT ID FROM COURSES WHERE Code = 'CHE-225'), 1, 2);

-- Forty-Fifth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(45, (SELECT ID FROM COURSES WHERE Code = 'CHE-311'), 1, 1), -- CHE-311 (300L, First Semester, 1st Course)
(45, (SELECT ID FROM COURSES WHERE Code = 'CHE-312'), 1, 1), 
(45, (SELECT ID FROM COURSES WHERE Code = 'CHE-313'), 1, 1), 
(45, (SELECT ID FROM COURSES WHERE Code = 'CHE-314'), 1, 1), 
(45, (SELECT ID FROM COURSES WHERE Code = 'CHE-315'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(45, (SELECT ID FROM COURSES WHERE Code = 'CHE-321'), 1, 2), -- CHE-321 (300L, Second Semester, 1st Course)
(45, (SELECT ID FROM COURSES WHERE Code = 'CHE-322'), 1, 2), 
(45, (SELECT ID FROM COURSES WHERE Code = 'CHE-323'), 1, 2), 
(45, (SELECT ID FROM COURSES WHERE Code = 'CHE-324'), 1, 2), 
(45, (SELECT ID FROM COURSES WHERE Code = 'CHE-325'), 1, 2);

-- Forty-Sixth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(46, (SELECT ID FROM COURSES WHERE Code = 'CHE-311'), 1, 1), -- CHE-311 (300L, First Semester, 1st Course)
(46, (SELECT ID FROM COURSES WHERE Code = 'CHE-312'), 1, 1), 
(46, (SELECT ID FROM COURSES WHERE Code = 'CHE-313'), 1, 1), 
(46, (SELECT ID FROM COURSES WHERE Code = 'CHE-314'), 1, 1), 
(46, (SELECT ID FROM COURSES WHERE Code = 'CHE-315'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(46, (SELECT ID FROM COURSES WHERE Code = 'CHE-321'), 1, 2), -- CHE-321 (300L, Second Semester, 1st Course)
(46, (SELECT ID FROM COURSES WHERE Code = 'CHE-322'), 1, 2), 
(46, (SELECT ID FROM COURSES WHERE Code = 'CHE-323'), 1, 2), 
(46, (SELECT ID FROM COURSES WHERE Code = 'CHE-324'), 1, 2), 
(46, (SELECT ID FROM COURSES WHERE Code = 'CHE-325'), 1, 2);

-- Forty-Seventh Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(47, (SELECT ID FROM COURSES WHERE Code = 'CHE-411'), 1, 1), -- CHE-411 (400L, First Semester, 1st Course)
(47, (SELECT ID FROM COURSES WHERE Code = 'CHE-412'), 1, 1), 
(47, (SELECT ID FROM COURSES WHERE Code = 'CHE-413'), 1, 1), 
(47, (SELECT ID FROM COURSES WHERE Code = 'CHE-414'), 1, 1), 
(47, (SELECT ID FROM COURSES WHERE Code = 'CHE-415'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(47, (SELECT ID FROM COURSES WHERE Code = 'CHE-421'), 1, 2), -- CHE-421 (400L, Second Semester, 1st Course)
(47, (SELECT ID FROM COURSES WHERE Code = 'CHE-422'), 1, 2), 
(47, (SELECT ID FROM COURSES WHERE Code = 'CHE-423'), 1, 2), 
(47, (SELECT ID FROM COURSES WHERE Code = 'CHE-424'), 1, 2), 
(47, (SELECT ID FROM COURSES WHERE Code = 'CHE-425'), 1, 2);

-- Forty-Eighth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(48, (SELECT ID FROM COURSES WHERE Code = 'CHE-411'), 1, 1), -- CHE-411 (400L, First Semester, 1st Course)
(48, (SELECT ID FROM COURSES WHERE Code = 'CHE-412'), 1, 1), 
(48, (SELECT ID FROM COURSES WHERE Code = 'CHE-413'), 1, 1), 
(48, (SELECT ID FROM COURSES WHERE Code = 'CHE-414'), 1, 1), 
(48, (SELECT ID FROM COURSES WHERE Code = 'CHE-415'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(48, (SELECT ID FROM COURSES WHERE Code = 'CHE-421'), 1, 2), -- CHE-421 (400L, Second Semester, 1st Course)
(48, (SELECT ID FROM COURSES WHERE Code = 'CHE-422'), 1, 2), 
(48, (SELECT ID FROM COURSES WHERE Code = 'CHE-423'), 1, 2), 
(48, (SELECT ID FROM COURSES WHERE Code = 'CHE-424'), 1, 2), 
(48, (SELECT ID FROM COURSES WHERE Code = 'CHE-425'), 1, 2);

-- Forty-Ninth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(49, (SELECT ID FROM COURSES WHERE Code = 'CHE-511'), 1, 1), -- CHE-511 (500L, First Semester, 1st Course)
(49, (SELECT ID FROM COURSES WHERE Code = 'CHE-512'), 1, 1), 
(49, (SELECT ID FROM COURSES WHERE Code = 'CHE-513'), 1, 1), 
(49, (SELECT ID FROM COURSES WHERE Code = 'CHE-514'), 1, 1), 
(49, (SELECT ID FROM COURSES WHERE Code = 'CHE-515'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(49, (SELECT ID FROM COURSES WHERE Code = 'CHE-521'), 1, 2), -- CHE-521 (500L, Second Semester, 1st Course)
(49, (SELECT ID FROM COURSES WHERE Code = 'CHE-522'), 1, 2), 
(49, (SELECT ID FROM COURSES WHERE Code = 'CHE-523'), 1, 2), 
(49, (SELECT ID FROM COURSES WHERE Code = 'CHE-524'), 1, 2), 
(49, (SELECT ID FROM COURSES WHERE Code = 'CHE-525'), 1, 2);

-- Fiftieth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(50, (SELECT ID FROM COURSES WHERE Code = 'CHE-511'), 1, 1), -- CHE-511 (500L, First Semester, 1st Course)
(50, (SELECT ID FROM COURSES WHERE Code = 'CHE-512'), 1, 1), 
(50, (SELECT ID FROM COURSES WHERE Code = 'CHE-513'), 1, 1), 
(50, (SELECT ID FROM COURSES WHERE Code = 'CHE-514'), 1, 1), 
(50, (SELECT ID FROM COURSES WHERE Code = 'CHE-515'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(50, (SELECT ID FROM COURSES WHERE Code = 'CHE-521'), 1, 2), -- CHE-521 (500L, Second Semester, 1st Course)
(50, (SELECT ID FROM COURSES WHERE Code = 'CHE-522'), 1, 2), 
(50, (SELECT ID FROM COURSES WHERE Code = 'CHE-523'), 1, 2), 
(50, (SELECT ID FROM COURSES WHERE Code = 'CHE-524'), 1, 2), 
(50, (SELECT ID FROM COURSES WHERE Code = 'CHE-525'), 1, 2);

-- Fifty-First Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(51, (SELECT ID FROM COURSES WHERE Code = 'PHY-111'), 1, 1), -- PHY-111 (100L, First Semester, 1st Course)
(51, (SELECT ID FROM COURSES WHERE Code = 'PHY-112'), 1, 1), 
(51, (SELECT ID FROM COURSES WHERE Code = 'PHY-113'), 1, 1), 
(51, (SELECT ID FROM COURSES WHERE Code = 'PHY-114'), 1, 1), 
(51, (SELECT ID FROM COURSES WHERE Code = 'PHY-115'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(51, (SELECT ID FROM COURSES WHERE Code = 'PHY-121'), 1, 2), -- PHY-121 (100L, Second Semester, 1st Course)
(51, (SELECT ID FROM COURSES WHERE Code = 'PHY-122'), 1, 2), 
(51, (SELECT ID FROM COURSES WHERE Code = 'PHY-123'), 1, 2), 
(51, (SELECT ID FROM COURSES WHERE Code = 'PHY-124'), 1, 2), 
(51, (SELECT ID FROM COURSES WHERE Code = 'PHY-125'), 1, 2);

-- Fifty-Second Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(52, (SELECT ID FROM COURSES WHERE Code = 'PHY-111'), 1, 1), -- PHY-111 (100L, First Semester, 1st Course)
(52, (SELECT ID FROM COURSES WHERE Code = 'PHY-112'), 1, 1), 
(52, (SELECT ID FROM COURSES WHERE Code = 'PHY-113'), 1, 1), 
(52, (SELECT ID FROM COURSES WHERE Code = 'PHY-114'), 1, 1), 
(52, (SELECT ID FROM COURSES WHERE Code = 'PHY-115'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(52, (SELECT ID FROM COURSES WHERE Code = 'PHY-121'), 1, 2), -- PHY-121 (100L, Second Semester, 1st Course)
(52, (SELECT ID FROM COURSES WHERE Code = 'PHY-122'), 1, 2), 
(52, (SELECT ID FROM COURSES WHERE Code = 'PHY-123'), 1, 2), 
(52, (SELECT ID FROM COURSES WHERE Code = 'PHY-124'), 1, 2), 
(52, (SELECT ID FROM COURSES WHERE Code = 'PHY-125'), 1, 2);

-- Fifty-Third Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(53, (SELECT ID FROM COURSES WHERE Code = 'PHY-111'), 1, 1), -- PHY-111 (100L, First Semester, 1st Course)
(53, (SELECT ID FROM COURSES WHERE Code = 'PHY-112'), 1, 1), 
(53, (SELECT ID FROM COURSES WHERE Code = 'PHY-113'), 1, 1), 
(53, (SELECT ID FROM COURSES WHERE Code = 'PHY-114'), 1, 1), 
(53, (SELECT ID FROM COURSES WHERE Code = 'PHY-115'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(53, (SELECT ID FROM COURSES WHERE Code = 'PHY-121'), 1, 2), -- PHY-121 (100L, Second Semester, 1st Course)
(53, (SELECT ID FROM COURSES WHERE Code = 'PHY-122'), 1, 2), 
(53, (SELECT ID FROM COURSES WHERE Code = 'PHY-123'), 1, 2), 
(53, (SELECT ID FROM COURSES WHERE Code = 'PHY-124'), 1, 2), 
(53, (SELECT ID FROM COURSES WHERE Code = 'PHY-125'), 1, 2);

-- Fifty-Fourth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(54, (SELECT ID FROM COURSES WHERE Code = 'PHY-211'), 1, 1), -- PHY-211 (200L, First Semester, 1st Course)
(54, (SELECT ID FROM COURSES WHERE Code = 'PHY-212'), 1, 1), 
(54, (SELECT ID FROM COURSES WHERE Code = 'PHY-213'), 1, 1), 
(54, (SELECT ID FROM COURSES WHERE Code = 'PHY-214'), 1, 1), 
(54, (SELECT ID FROM COURSES WHERE Code = 'PHY-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(54, (SELECT ID FROM COURSES WHERE Code = 'PHY-221'), 1, 2), -- PHY-221 (200L, Second Semester, 1st Course)
(54, (SELECT ID FROM COURSES WHERE Code = 'PHY-222'), 1, 2), 
(54, (SELECT ID FROM COURSES WHERE Code = 'PHY-223'), 1, 2), 
(54, (SELECT ID FROM COURSES WHERE Code = 'PHY-224'), 1, 2), 
(54, (SELECT ID FROM COURSES WHERE Code = 'PHY-225'), 1, 2);

-- Fifty-Fifth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(55, (SELECT ID FROM COURSES WHERE Code = 'PHY-211'), 1, 1), -- PHY-211 (200L, First Semester, 1st Course)
(55, (SELECT ID FROM COURSES WHERE Code = 'PHY-212'), 1, 1), 
(55, (SELECT ID FROM COURSES WHERE Code = 'PHY-213'), 1, 1), 
(55, (SELECT ID FROM COURSES WHERE Code = 'PHY-214'), 1, 1), 
(55, (SELECT ID FROM COURSES WHERE Code = 'PHY-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(55, (SELECT ID FROM COURSES WHERE Code = 'PHY-221'), 1, 2), -- PHY-221 (200L, Second Semester, 1st Course)
(55, (SELECT ID FROM COURSES WHERE Code = 'PHY-222'), 1, 2), 
(55, (SELECT ID FROM COURSES WHERE Code = 'PHY-223'), 1, 2), 
(55, (SELECT ID FROM COURSES WHERE Code = 'PHY-224'), 1, 2), 
(55, (SELECT ID FROM COURSES WHERE Code = 'PHY-225'), 1, 2);

-- Fifth-Sixth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(56, (SELECT ID FROM COURSES WHERE Code = 'PHY-211'), 1, 1), -- PHY-211 (200L, First Semester, 1st Course)
(56, (SELECT ID FROM COURSES WHERE Code = 'PHY-212'), 1, 1), 
(56, (SELECT ID FROM COURSES WHERE Code = 'PHY-213'), 1, 1), 
(56, (SELECT ID FROM COURSES WHERE Code = 'PHY-214'), 1, 1), 
(56, (SELECT ID FROM COURSES WHERE Code = 'PHY-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(56, (SELECT ID FROM COURSES WHERE Code = 'PHY-221'), 1, 2), -- PHY-221 (200L, Second Semester, 1st Course)
(56, (SELECT ID FROM COURSES WHERE Code = 'PHY-222'), 1, 2), 
(56, (SELECT ID FROM COURSES WHERE Code = 'PHY-223'), 1, 2), 
(56, (SELECT ID FROM COURSES WHERE Code = 'PHY-224'), 1, 2), 
(56, (SELECT ID FROM COURSES WHERE Code = 'PHY-225'), 1, 2);

-- Fifty-Seventh Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(57, (SELECT ID FROM COURSES WHERE Code = 'PHY-311'), 1, 1), -- PHY-311 (300L, First Semester, 1st Course)
(57, (SELECT ID FROM COURSES WHERE Code = 'PHY-312'), 1, 1), 
(57, (SELECT ID FROM COURSES WHERE Code = 'PHY-313'), 1, 1), 
(57, (SELECT ID FROM COURSES WHERE Code = 'PHY-314'), 1, 1), 
(57, (SELECT ID FROM COURSES WHERE Code = 'PHY-315'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(57, (SELECT ID FROM COURSES WHERE Code = 'PHY-321'), 1, 2), -- PHY-321 (300L, Second Semester, 1st Course)
(57, (SELECT ID FROM COURSES WHERE Code = 'PHY-322'), 1, 2), 
(57, (SELECT ID FROM COURSES WHERE Code = 'PHY-323'), 1, 2), 
(57, (SELECT ID FROM COURSES WHERE Code = 'PHY-324'), 1, 2), 
(57, (SELECT ID FROM COURSES WHERE Code = 'PHY-325'), 1, 2);

-- Fifty-Eighth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(58, (SELECT ID FROM COURSES WHERE Code = 'PHY-311'), 1, 1), -- PHY-311 (300L, First Semester, 1st Course)
(58, (SELECT ID FROM COURSES WHERE Code = 'PHY-312'), 1, 1), 
(58, (SELECT ID FROM COURSES WHERE Code = 'PHY-313'), 1, 1), 
(58, (SELECT ID FROM COURSES WHERE Code = 'PHY-314'), 1, 1), 
(58, (SELECT ID FROM COURSES WHERE Code = 'PHY-315'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(58, (SELECT ID FROM COURSES WHERE Code = 'PHY-321'), 1, 2), -- PHY-321 (300L, Second Semester, 1st Course)
(58, (SELECT ID FROM COURSES WHERE Code = 'PHY-322'), 1, 2), 
(58, (SELECT ID FROM COURSES WHERE Code = 'PHY-323'), 1, 2), 
(58, (SELECT ID FROM COURSES WHERE Code = 'PHY-324'), 1, 2), 
(58, (SELECT ID FROM COURSES WHERE Code = 'PHY-325'), 1, 2);

-- Fifty-Ninth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(59, (SELECT ID FROM COURSES WHERE Code = 'PHY-411'), 1, 1), -- PHY-411 (400L, First Semester, 1st Course)
(59, (SELECT ID FROM COURSES WHERE Code = 'PHY-412'), 1, 1), 
(59, (SELECT ID FROM COURSES WHERE Code = 'PHY-413'), 1, 1), 
(59, (SELECT ID FROM COURSES WHERE Code = 'PHY-414'), 1, 1), 
(59, (SELECT ID FROM COURSES WHERE Code = 'PHY-415'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(59, (SELECT ID FROM COURSES WHERE Code = 'PHY-421'), 1, 2), -- PHY-421 (400L, Second Semester, 1st Course)
(59, (SELECT ID FROM COURSES WHERE Code = 'PHY-422'), 1, 2), 
(59, (SELECT ID FROM COURSES WHERE Code = 'PHY-423'), 1, 2), 
(59, (SELECT ID FROM COURSES WHERE Code = 'PHY-424'), 1, 2), 
(59, (SELECT ID FROM COURSES WHERE Code = 'PHY-425'), 1, 2);

-- Sixtieth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(60, (SELECT ID FROM COURSES WHERE Code = 'PHY-411'), 1, 1), -- PHY-411 (400L, First Semester, 1st Course)
(60, (SELECT ID FROM COURSES WHERE Code = 'PHY-412'), 1, 1), 
(60, (SELECT ID FROM COURSES WHERE Code = 'PHY-413'), 1, 1), 
(60, (SELECT ID FROM COURSES WHERE Code = 'PHY-414'), 1, 1), 
(60, (SELECT ID FROM COURSES WHERE Code = 'PHY-415'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(60, (SELECT ID FROM COURSES WHERE Code = 'PHY-421'), 1, 2), -- PHY-421 (400L, Second Semester, 1st Course)
(60, (SELECT ID FROM COURSES WHERE Code = 'PHY-422'), 1, 2), 
(60, (SELECT ID FROM COURSES WHERE Code = 'PHY-423'), 1, 2), 
(60, (SELECT ID FROM COURSES WHERE Code = 'PHY-424'), 1, 2), 
(60, (SELECT ID FROM COURSES WHERE Code = 'PHY-425'), 1, 2);

-- Sixty-First Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(61, (SELECT ID FROM COURSES WHERE Code = 'MAT-111'), 1, 1), -- MAT-111 (100L, First Semester, 1st Course)
(61, (SELECT ID FROM COURSES WHERE Code = 'MAT-112'), 1, 1), 
(61, (SELECT ID FROM COURSES WHERE Code = 'MAT-113'), 1, 1), 
(61, (SELECT ID FROM COURSES WHERE Code = 'MAT-114'), 1, 1), 
(61, (SELECT ID FROM COURSES WHERE Code = 'MAT-115'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(61, (SELECT ID FROM COURSES WHERE Code = 'MAT-121'), 1, 2), -- MAT-121 (100L, Second Semester, 1st Course)
(61, (SELECT ID FROM COURSES WHERE Code = 'MAT-122'), 1, 2), 
(61, (SELECT ID FROM COURSES WHERE Code = 'MAT-123'), 1, 2), 
(61, (SELECT ID FROM COURSES WHERE Code = 'MAT-124'), 1, 2), 
(61, (SELECT ID FROM COURSES WHERE Code = 'MAT-125'), 1, 2);

-- Sixty-Second Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(62, (SELECT ID FROM COURSES WHERE Code = 'MAT-111'), 1, 1), -- MAT-111 (100L, First Semester, 1st Course)
(62, (SELECT ID FROM COURSES WHERE Code = 'MAT-112'), 1, 1), 
(62, (SELECT ID FROM COURSES WHERE Code = 'MAT-113'), 1, 1), 
(62, (SELECT ID FROM COURSES WHERE Code = 'MAT-114'), 1, 1), 
(62, (SELECT ID FROM COURSES WHERE Code = 'MAT-115'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(62, (SELECT ID FROM COURSES WHERE Code = 'MAT-121'), 1, 2), -- MAT-121 (100L, Second Semester, 1st Course)
(62, (SELECT ID FROM COURSES WHERE Code = 'MAT-122'), 1, 2), 
(62, (SELECT ID FROM COURSES WHERE Code = 'MAT-123'), 1, 2), 
(62, (SELECT ID FROM COURSES WHERE Code = 'MAT-124'), 1, 2), 
(62, (SELECT ID FROM COURSES WHERE Code = 'MAT-125'), 1, 2);

-- Sixty-Third Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(63, (SELECT ID FROM COURSES WHERE Code = 'MAT-111'), 1, 1), -- MAT-111 (100L, First Semester, 1st Course)
(63, (SELECT ID FROM COURSES WHERE Code = 'MAT-112'), 1, 1), 
(63, (SELECT ID FROM COURSES WHERE Code = 'MAT-113'), 1, 1), 
(63, (SELECT ID FROM COURSES WHERE Code = 'MAT-114'), 1, 1), 
(63, (SELECT ID FROM COURSES WHERE Code = 'MAT-115'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(63, (SELECT ID FROM COURSES WHERE Code = 'MAT-121'), 1, 2), -- MAT-121 (100L, Second Semester, 1st Course)
(63, (SELECT ID FROM COURSES WHERE Code = 'MAT-122'), 1, 2), 
(63, (SELECT ID FROM COURSES WHERE Code = 'MAT-123'), 1, 2), 
(63, (SELECT ID FROM COURSES WHERE Code = 'MAT-124'), 1, 2), 
(63, (SELECT ID FROM COURSES WHERE Code = 'MAT-125'), 1, 2);

-- Sixty-Fourth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(64, (SELECT ID FROM COURSES WHERE Code = 'MAT-211'), 1, 1), -- MAT-211 (200L, First Semester, 1st Course)
(64, (SELECT ID FROM COURSES WHERE Code = 'MAT-212'), 1, 1), 
(64, (SELECT ID FROM COURSES WHERE Code = 'MAT-213'), 1, 1), 
(64, (SELECT ID FROM COURSES WHERE Code = 'MAT-214'), 1, 1), 
(64, (SELECT ID FROM COURSES WHERE Code = 'MAT-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(64, (SELECT ID FROM COURSES WHERE Code = 'MAT-221'), 1, 2), -- MAT-221 (200L, Second Semester, 1st Course)
(64, (SELECT ID FROM COURSES WHERE Code = 'MAT-222'), 1, 2), 
(64, (SELECT ID FROM COURSES WHERE Code = 'MAT-223'), 1, 2), 
(64, (SELECT ID FROM COURSES WHERE Code = 'MAT-224'), 1, 2), 
(64, (SELECT ID FROM COURSES WHERE Code = 'MAT-225'), 1, 2);

-- Sixty-Fifth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(65, (SELECT ID FROM COURSES WHERE Code = 'MAT-211'), 1, 1), -- MAT-211 (200L, First Semester, 1st Course)
(65, (SELECT ID FROM COURSES WHERE Code = 'MAT-212'), 1, 1), 
(65, (SELECT ID FROM COURSES WHERE Code = 'MAT-213'), 1, 1), 
(65, (SELECT ID FROM COURSES WHERE Code = 'MAT-214'), 1, 1), 
(65, (SELECT ID FROM COURSES WHERE Code = 'MAT-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(65, (SELECT ID FROM COURSES WHERE Code = 'MAT-221'), 1, 2), -- MAT-221 (200L, Second Semester, 1st Course)
(65, (SELECT ID FROM COURSES WHERE Code = 'MAT-222'), 1, 2), 
(65, (SELECT ID FROM COURSES WHERE Code = 'MAT-223'), 1, 2), 
(65, (SELECT ID FROM COURSES WHERE Code = 'MAT-224'), 1, 2), 
(65, (SELECT ID FROM COURSES WHERE Code = 'MAT-225'), 1, 2);

-- Sixty-Sixth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(66, (SELECT ID FROM COURSES WHERE Code = 'MAT-211'), 1, 1), -- MAT-211 (200L, First Semester, 1st Course)
(66, (SELECT ID FROM COURSES WHERE Code = 'MAT-212'), 1, 1), 
(66, (SELECT ID FROM COURSES WHERE Code = 'MAT-213'), 1, 1), 
(66, (SELECT ID FROM COURSES WHERE Code = 'MAT-214'), 1, 1), 
(66, (SELECT ID FROM COURSES WHERE Code = 'MAT-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(66, (SELECT ID FROM COURSES WHERE Code = 'MAT-221'), 1, 2), -- MAT-221 (200L, Second Semester, 1st Course)
(66, (SELECT ID FROM COURSES WHERE Code = 'MAT-222'), 1, 2), 
(66, (SELECT ID FROM COURSES WHERE Code = 'MAT-223'), 1, 2), 
(66, (SELECT ID FROM COURSES WHERE Code = 'MAT-224'), 1, 2), 
(66, (SELECT ID FROM COURSES WHERE Code = 'MAT-225'), 1, 2);

-- Sixty-Seventh Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(67, (SELECT ID FROM COURSES WHERE Code = 'MAT-311'), 1, 1), -- MAT-311 (300L, First Semester, 1st Course)
(67, (SELECT ID FROM COURSES WHERE Code = 'MAT-312'), 1, 1), 
(67, (SELECT ID FROM COURSES WHERE Code = 'MAT-313'), 1, 1), 
(67, (SELECT ID FROM COURSES WHERE Code = 'MAT-314'), 1, 1), 
(67, (SELECT ID FROM COURSES WHERE Code = 'MAT-315'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(67, (SELECT ID FROM COURSES WHERE Code = 'MAT-321'), 1, 2), -- MAT-321 (300L, Second Semester, 1st Course)
(67, (SELECT ID FROM COURSES WHERE Code = 'MAT-322'), 1, 2), 
(67, (SELECT ID FROM COURSES WHERE Code = 'MAT-323'), 1, 2), 
(67, (SELECT ID FROM COURSES WHERE Code = 'MAT-324'), 1, 2), 
(67, (SELECT ID FROM COURSES WHERE Code = 'MAT-325'), 1, 2);

-- Sixty-Eighth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(68, (SELECT ID FROM COURSES WHERE Code = 'MAT-311'), 1, 1), -- MAT-311 (300L, First Semester, 1st Course)
(68, (SELECT ID FROM COURSES WHERE Code = 'MAT-312'), 1, 1), 
(68, (SELECT ID FROM COURSES WHERE Code = 'MAT-313'), 1, 1), 
(68, (SELECT ID FROM COURSES WHERE Code = 'MAT-314'), 1, 1), 
(68, (SELECT ID FROM COURSES WHERE Code = 'MAT-315'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(68, (SELECT ID FROM COURSES WHERE Code = 'MAT-321'), 1, 2), -- MAT-321 (300L, Second Semester, 1st Course)
(68, (SELECT ID FROM COURSES WHERE Code = 'MAT-322'), 1, 2), 
(68, (SELECT ID FROM COURSES WHERE Code = 'MAT-323'), 1, 2), 
(68, (SELECT ID FROM COURSES WHERE Code = 'MAT-324'), 1, 2), 
(68, (SELECT ID FROM COURSES WHERE Code = 'MAT-325'), 1, 2);

--Sixty-Ninth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(69, (SELECT ID FROM COURSES WHERE Code = 'MAT-411'), 1, 1), -- MAT-411 (400L, First Semester, 1st Course)
(69, (SELECT ID FROM COURSES WHERE Code = 'MAT-412'), 1, 1), 
(69, (SELECT ID FROM COURSES WHERE Code = 'MAT-413'), 1, 1), 
(69, (SELECT ID FROM COURSES WHERE Code = 'MAT-414'), 1, 1), 
(69, (SELECT ID FROM COURSES WHERE Code = 'MAT-415'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(69, (SELECT ID FROM COURSES WHERE Code = 'MAT-421'), 1, 2), -- MAT-421 (400L, Second Semester, 1st Course)
(69, (SELECT ID FROM COURSES WHERE Code = 'MAT-422'), 1, 2), 
(69, (SELECT ID FROM COURSES WHERE Code = 'MAT-423'), 1, 2), 
(69, (SELECT ID FROM COURSES WHERE Code = 'MAT-424'), 1, 2), 
(69, (SELECT ID FROM COURSES WHERE Code = 'MAT-425'), 1, 2);

-- Seventieth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(70, (SELECT ID FROM COURSES WHERE Code = 'MAT-411'), 1, 1), -- MAT-411 (400L, First Semester, 1st Course)
(70, (SELECT ID FROM COURSES WHERE Code = 'MAT-412'), 1, 1), 
(70, (SELECT ID FROM COURSES WHERE Code = 'MAT-413'), 1, 1), 
(70, (SELECT ID FROM COURSES WHERE Code = 'MAT-414'), 1, 1), 
(70, (SELECT ID FROM COURSES WHERE Code = 'MAT-415'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(70, (SELECT ID FROM COURSES WHERE Code = 'MAT-421'), 1, 2), -- MAT-421 (400L, Second Semester, 1st Course)
(70, (SELECT ID FROM COURSES WHERE Code = 'MAT-422'), 1, 2), 
(70, (SELECT ID FROM COURSES WHERE Code = 'MAT-423'), 1, 2), 
(70, (SELECT ID FROM COURSES WHERE Code = 'MAT-424'), 1, 2), 
(70, (SELECT ID FROM COURSES WHERE Code = 'MAT-425'), 1, 2);

-- Seventy-First Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(71, (SELECT ID FROM COURSES WHERE Code = 'CHM-111'), 1, 1), -- CHM-111 (100L, First Semester, 1st Course)
(71, (SELECT ID FROM COURSES WHERE Code = 'CHM-112'), 1, 1), 
(71, (SELECT ID FROM COURSES WHERE Code = 'CHM-113'), 1, 1), 
(71, (SELECT ID FROM COURSES WHERE Code = 'CHM-114'), 1, 1), 
(71, (SELECT ID FROM COURSES WHERE Code = 'CHM-115'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(71, (SELECT ID FROM COURSES WHERE Code = 'CHM-121'), 1, 2), -- CHM-121 (100L, Second Semester, 1st Course)
(71, (SELECT ID FROM COURSES WHERE Code = 'CHM-122'), 1, 2), 
(71, (SELECT ID FROM COURSES WHERE Code = 'CHM-123'), 1, 2), 
(71, (SELECT ID FROM COURSES WHERE Code = 'CHM-124'), 1, 2), 
(71, (SELECT ID FROM COURSES WHERE Code = 'CHM-125'), 1, 2);

--Seventy-Second Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(72, (SELECT ID FROM COURSES WHERE Code = 'CHM-111'), 1, 1), -- CHM-111 (100L, First Semester, 1st Course)
(72, (SELECT ID FROM COURSES WHERE Code = 'CHM-112'), 1, 1), 
(72, (SELECT ID FROM COURSES WHERE Code = 'CHM-113'), 1, 1), 
(72, (SELECT ID FROM COURSES WHERE Code = 'CHM-114'), 1, 1), 
(72, (SELECT ID FROM COURSES WHERE Code = 'CHM-115'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(72, (SELECT ID FROM COURSES WHERE Code = 'CHM-121'), 1, 2), -- CHM-121 (100L, Second Semester, 1st Course)
(72, (SELECT ID FROM COURSES WHERE Code = 'CHM-122'), 1, 2), 
(72, (SELECT ID FROM COURSES WHERE Code = 'CHM-123'), 1, 2), 
(72, (SELECT ID FROM COURSES WHERE Code = 'CHM-124'), 1, 2), 
(72, (SELECT ID FROM COURSES WHERE Code = 'CHM-125'), 1, 2);

-- Seventy-Third Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(73, (SELECT ID FROM COURSES WHERE Code = 'CHM-111'), 1, 1), -- CHM-111 (100L, First Semester, 1st Course)
(73, (SELECT ID FROM COURSES WHERE Code = 'CHM-112'), 1, 1), 
(73, (SELECT ID FROM COURSES WHERE Code = 'CHM-113'), 1, 1), 
(73, (SELECT ID FROM COURSES WHERE Code = 'CHM-114'), 1, 1), 
(73, (SELECT ID FROM COURSES WHERE Code = 'CHM-115'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(73, (SELECT ID FROM COURSES WHERE Code = 'CHM-121'), 1, 2), -- CHM-121 (100L, Second Semester, 1st Course)
(73, (SELECT ID FROM COURSES WHERE Code = 'CHM-122'), 1, 2), 
(73, (SELECT ID FROM COURSES WHERE Code = 'CHM-123'), 1, 2), 
(73, (SELECT ID FROM COURSES WHERE Code = 'CHM-124'), 1, 2), 
(73, (SELECT ID FROM COURSES WHERE Code = 'CHM-125'), 1, 2);

-- Seventy-Fourth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(74, (SELECT ID FROM COURSES WHERE Code = 'CHM-211'), 1, 1), -- CHM-211 (200L, First Semester, 1st Course)
(74, (SELECT ID FROM COURSES WHERE Code = 'CHM-212'), 1, 1), 
(74, (SELECT ID FROM COURSES WHERE Code = 'CHM-213'), 1, 1), 
(74, (SELECT ID FROM COURSES WHERE Code = 'CHM-214'), 1, 1), 
(74, (SELECT ID FROM COURSES WHERE Code = 'CHM-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(74, (SELECT ID FROM COURSES WHERE Code = 'CHM-221'), 1, 2), -- CHM-221 (200L, Second Semester, 1st Course)
(74, (SELECT ID FROM COURSES WHERE Code = 'CHM-222'), 1, 2), 
(74, (SELECT ID FROM COURSES WHERE Code = 'CHM-223'), 1, 2), 
(74, (SELECT ID FROM COURSES WHERE Code = 'CHM-224'), 1, 2), 
(74, (SELECT ID FROM COURSES WHERE Code = 'CHM-225'), 1, 2);

-- Seventy-Fifth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(75, (SELECT ID FROM COURSES WHERE Code = 'CHM-211'), 1, 1), -- CHM-211 (200L, First Semester, 1st Course)
(75, (SELECT ID FROM COURSES WHERE Code = 'CHM-212'), 1, 1), 
(75, (SELECT ID FROM COURSES WHERE Code = 'CHM-213'), 1, 1), 
(75, (SELECT ID FROM COURSES WHERE Code = 'CHM-214'), 1, 1), 
(75, (SELECT ID FROM COURSES WHERE Code = 'CHM-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(75, (SELECT ID FROM COURSES WHERE Code = 'CHM-221'), 1, 2), -- CHM-221 (200L, Second Semester, 1st Course)
(75, (SELECT ID FROM COURSES WHERE Code = 'CHM-222'), 1, 2), 
(75, (SELECT ID FROM COURSES WHERE Code = 'CHM-223'), 1, 2), 
(75, (SELECT ID FROM COURSES WHERE Code = 'CHM-224'), 1, 2), 
(75, (SELECT ID FROM COURSES WHERE Code = 'CHM-225'), 1, 2);

-- Seventy-Sixth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(76, (SELECT ID FROM COURSES WHERE Code = 'CHM-211'), 1, 1), -- CHM-211 (200L, First Semester, 1st Course)
(76, (SELECT ID FROM COURSES WHERE Code = 'CHM-212'), 1, 1), 
(76, (SELECT ID FROM COURSES WHERE Code = 'CHM-213'), 1, 1), 
(76, (SELECT ID FROM COURSES WHERE Code = 'CHM-214'), 1, 1), 
(76, (SELECT ID FROM COURSES WHERE Code = 'CHM-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(76, (SELECT ID FROM COURSES WHERE Code = 'CHM-221'), 1, 2), -- CHM-221 (200L, Second Semester, 1st Course)
(76, (SELECT ID FROM COURSES WHERE Code = 'CHM-222'), 1, 2), 
(76, (SELECT ID FROM COURSES WHERE Code = 'CHM-223'), 1, 2), 
(76, (SELECT ID FROM COURSES WHERE Code = 'CHM-224'), 1, 2), 
(76, (SELECT ID FROM COURSES WHERE Code = 'CHM-225'), 1, 2);

-- Seventy-Seventh Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(77, (SELECT ID FROM COURSES WHERE Code = 'CHM-311'), 1, 1), -- CHM-311 (300L, First Semester, 1st Course)
(77, (SELECT ID FROM COURSES WHERE Code = 'CHM-312'), 1, 1), 
(77, (SELECT ID FROM COURSES WHERE Code = 'CHM-313'), 1, 1), 
(77, (SELECT ID FROM COURSES WHERE Code = 'CHM-314'), 1, 1), 
(77, (SELECT ID FROM COURSES WHERE Code = 'CHM-315'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(77, (SELECT ID FROM COURSES WHERE Code = 'CHM-321'), 1, 2), -- CHM-321 (300L, Second Semester, 1st Course)
(77, (SELECT ID FROM COURSES WHERE Code = 'CHM-322'), 1, 2), 
(77, (SELECT ID FROM COURSES WHERE Code = 'CHM-323'), 1, 2), 
(77, (SELECT ID FROM COURSES WHERE Code = 'CHM-324'), 1, 2), 
(77, (SELECT ID FROM COURSES WHERE Code = 'CHM-325'), 1, 2);

-- Seventy-Eighth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(78, (SELECT ID FROM COURSES WHERE Code = 'CHM-311'), 1, 1), -- CHM-311 (300L, First Semester, 1st Course)
(78, (SELECT ID FROM COURSES WHERE Code = 'CHM-312'), 1, 1), 
(78, (SELECT ID FROM COURSES WHERE Code = 'CHM-313'), 1, 1), 
(78, (SELECT ID FROM COURSES WHERE Code = 'CHM-314'), 1, 1), 
(78, (SELECT ID FROM COURSES WHERE Code = 'CHM-315'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(78, (SELECT ID FROM COURSES WHERE Code = 'CHM-321'), 1, 2), -- CHM-321 (300L, Second Semester, 1st Course)
(78, (SELECT ID FROM COURSES WHERE Code = 'CHM-322'), 1, 2), 
(78, (SELECT ID FROM COURSES WHERE Code = 'CHM-323'), 1, 2), 
(78, (SELECT ID FROM COURSES WHERE Code = 'CHM-324'), 1, 2), 
(78, (SELECT ID FROM COURSES WHERE Code = 'CHM-325'), 1, 2);

-- Seventy-Ninth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(79, (SELECT ID FROM COURSES WHERE Code = 'CHM-411'), 1, 1), -- CHM-411 (400L, First Semester, 1st Course)
(79, (SELECT ID FROM COURSES WHERE Code = 'CHM-412'), 1, 1), 
(79, (SELECT ID FROM COURSES WHERE Code = 'CHM-413'), 1, 1), 
(79, (SELECT ID FROM COURSES WHERE Code = 'CHM-414'), 1, 1), 
(79, (SELECT ID FROM COURSES WHERE Code = 'CHM-415'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(79, (SELECT ID FROM COURSES WHERE Code = 'CHM-421'), 1, 2), -- CHM-421 (400L, Second Semester, 1st Course)
(79, (SELECT ID FROM COURSES WHERE Code = 'CHM-422'), 1, 2), 
(79, (SELECT ID FROM COURSES WHERE Code = 'CHM-423'), 1, 2), 
(79, (SELECT ID FROM COURSES WHERE Code = 'CHM-424'), 1, 2), 
(79, (SELECT ID FROM COURSES WHERE Code = 'CHM-425'), 1, 2);

-- Eightieth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(80, (SELECT ID FROM COURSES WHERE Code = 'CHM-411'), 1, 1), -- CHM-411 (400L, First Semester, 1st Course)
(80, (SELECT ID FROM COURSES WHERE Code = 'CHM-412'), 1, 1), 
(80, (SELECT ID FROM COURSES WHERE Code = 'CHM-413'), 1, 1), 
(80, (SELECT ID FROM COURSES WHERE Code = 'CHM-414'), 1, 1), 
(80, (SELECT ID FROM COURSES WHERE Code = 'CHM-415'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(80, (SELECT ID FROM COURSES WHERE Code = 'CHM-421'), 1, 2), -- CHM-421 (400L, Second Semester, 1st Course)
(80, (SELECT ID FROM COURSES WHERE Code = 'CHM-422'), 1, 2), 
(80, (SELECT ID FROM COURSES WHERE Code = 'CHM-423'), 1, 2), 
(80, (SELECT ID FROM COURSES WHERE Code = 'CHM-424'), 1, 2), 
(80, (SELECT ID FROM COURSES WHERE Code = 'CHM-425'), 1, 2);

-- Eighty-First Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(81, (SELECT ID FROM COURSES WHERE Code = 'BIO-111'), 1, 1), -- BIO-111 (100L, First Semester, 1st Course)
(81, (SELECT ID FROM COURSES WHERE Code = 'BIO-112'), 1, 1), 
(81, (SELECT ID FROM COURSES WHERE Code = 'BIO-113'), 1, 1), 
(81, (SELECT ID FROM COURSES WHERE Code = 'BIO-114'), 1, 1), 
(81, (SELECT ID FROM COURSES WHERE Code = 'BIO-115'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(81, (SELECT ID FROM COURSES WHERE Code = 'BIO-121'), 1, 2), -- BIO-121 (100L, Second Semester, 1st Course)
(81, (SELECT ID FROM COURSES WHERE Code = 'BIO-122'), 1, 2), 
(81, (SELECT ID FROM COURSES WHERE Code = 'BIO-123'), 1, 2), 
(81, (SELECT ID FROM COURSES WHERE Code = 'BIO-124'), 1, 2), 
(81, (SELECT ID FROM COURSES WHERE Code = 'BIO-125'), 1, 2);

-- Eighty-Second Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(82, (SELECT ID FROM COURSES WHERE Code = 'BIO-111'), 1, 1), -- BIO-111 (100L, First Semester, 1st Course)
(82, (SELECT ID FROM COURSES WHERE Code = 'BIO-112'), 1, 1), 
(82, (SELECT ID FROM COURSES WHERE Code = 'BIO-113'), 1, 1), 
(82, (SELECT ID FROM COURSES WHERE Code = 'BIO-114'), 1, 1), 
(82, (SELECT ID FROM COURSES WHERE Code = 'BIO-115'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(82, (SELECT ID FROM COURSES WHERE Code = 'BIO-121'), 1, 2), -- BIO-121 (100L, Second Semester, 1st Course)
(82, (SELECT ID FROM COURSES WHERE Code = 'BIO-122'), 1, 2), 
(82, (SELECT ID FROM COURSES WHERE Code = 'BIO-123'), 1, 2), 
(82, (SELECT ID FROM COURSES WHERE Code = 'BIO-124'), 1, 2), 
(82, (SELECT ID FROM COURSES WHERE Code = 'BIO-125'), 1, 2);

-- Eighty-Third Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(83, (SELECT ID FROM COURSES WHERE Code = 'BIO-111'), 1, 1), -- BIO-111 (100L, First Semester, 1st Course)
(83, (SELECT ID FROM COURSES WHERE Code = 'BIO-112'), 1, 1), 
(83, (SELECT ID FROM COURSES WHERE Code = 'BIO-113'), 1, 1), 
(83, (SELECT ID FROM COURSES WHERE Code = 'BIO-114'), 1, 1), 
(83, (SELECT ID FROM COURSES WHERE Code = 'BIO-115'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(83, (SELECT ID FROM COURSES WHERE Code = 'BIO-121'), 1, 2), -- BIO-121 (100L, Second Semester, 1st Course)
(83, (SELECT ID FROM COURSES WHERE Code = 'BIO-122'), 1, 2), 
(83, (SELECT ID FROM COURSES WHERE Code = 'BIO-123'), 1, 2), 
(83, (SELECT ID FROM COURSES WHERE Code = 'BIO-124'), 1, 2), 
(83, (SELECT ID FROM COURSES WHERE Code = 'BIO-125'), 1, 2);

-- Eighty-Fourth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(84, (SELECT ID FROM COURSES WHERE Code = 'BIO-211'), 1, 1), -- BIO-211 (200L, First Semester, 1st Course)
(84, (SELECT ID FROM COURSES WHERE Code = 'BIO-212'), 1, 1), 
(84, (SELECT ID FROM COURSES WHERE Code = 'BIO-213'), 1, 1), 
(84, (SELECT ID FROM COURSES WHERE Code = 'BIO-214'), 1, 1), 
(84, (SELECT ID FROM COURSES WHERE Code = 'BIO-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(84, (SELECT ID FROM COURSES WHERE Code = 'BIO-221'), 1, 2), -- BIO-221 (200L, Second Semester, 1st Course)
(84, (SELECT ID FROM COURSES WHERE Code = 'BIO-222'), 1, 2), 
(84, (SELECT ID FROM COURSES WHERE Code = 'BIO-223'), 1, 2), 
(84, (SELECT ID FROM COURSES WHERE Code = 'BIO-224'), 1, 2), 
(84, (SELECT ID FROM COURSES WHERE Code = 'BIO-225'), 1, 2);

-- Eighty-Fifth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(85, (SELECT ID FROM COURSES WHERE Code = 'BIO-211'), 1, 1), -- BIO-211 (200L, First Semester, 1st Course)
(85, (SELECT ID FROM COURSES WHERE Code = 'BIO-212'), 1, 1), 
(85, (SELECT ID FROM COURSES WHERE Code = 'BIO-213'), 1, 1), 
(85, (SELECT ID FROM COURSES WHERE Code = 'BIO-214'), 1, 1), 
(85, (SELECT ID FROM COURSES WHERE Code = 'BIO-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(85, (SELECT ID FROM COURSES WHERE Code = 'BIO-221'), 1, 2), -- BIO-221 (200L, Second Semester, 1st Course)
(85, (SELECT ID FROM COURSES WHERE Code = 'BIO-222'), 1, 2), 
(85, (SELECT ID FROM COURSES WHERE Code = 'BIO-223'), 1, 2), 
(85, (SELECT ID FROM COURSES WHERE Code = 'BIO-224'), 1, 2), 
(85, (SELECT ID FROM COURSES WHERE Code = 'BIO-225'), 1, 2);

-- Eighty-Sixth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(86, (SELECT ID FROM COURSES WHERE Code = 'BIO-211'), 1, 1), -- BIO-211 (200L, First Semester, 1st Course)
(86, (SELECT ID FROM COURSES WHERE Code = 'BIO-212'), 1, 1), 
(86, (SELECT ID FROM COURSES WHERE Code = 'BIO-213'), 1, 1), 
(86, (SELECT ID FROM COURSES WHERE Code = 'BIO-214'), 1, 1), 
(86, (SELECT ID FROM COURSES WHERE Code = 'BIO-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(86, (SELECT ID FROM COURSES WHERE Code = 'BIO-221'), 1, 2), -- BIO-221 (200L, Second Semester, 1st Course)
(86, (SELECT ID FROM COURSES WHERE Code = 'BIO-222'), 1, 2), 
(86, (SELECT ID FROM COURSES WHERE Code = 'BIO-223'), 1, 2), 
(86, (SELECT ID FROM COURSES WHERE Code = 'BIO-224'), 1, 2), 
(86, (SELECT ID FROM COURSES WHERE Code = 'BIO-225'), 1, 2);

-- Eighty-Seventh Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(87, (SELECT ID FROM COURSES WHERE Code = 'BIO-311'), 1, 1), -- BIO-311 (300L, First Semester, 1st Course)
(87, (SELECT ID FROM COURSES WHERE Code = 'BIO-312'), 1, 1), 
(87, (SELECT ID FROM COURSES WHERE Code = 'BIO-313'), 1, 1), 
(87, (SELECT ID FROM COURSES WHERE Code = 'BIO-314'), 1, 1), 
(87, (SELECT ID FROM COURSES WHERE Code = 'BIO-315'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(87, (SELECT ID FROM COURSES WHERE Code = 'BIO-321'), 1, 2), -- BIO-321 (300L, Second Semester, 1st Course)
(87, (SELECT ID FROM COURSES WHERE Code = 'BIO-322'), 1, 2), 
(87, (SELECT ID FROM COURSES WHERE Code = 'BIO-323'), 1, 2), 
(87, (SELECT ID FROM COURSES WHERE Code = 'BIO-324'), 1, 2), 
(87, (SELECT ID FROM COURSES WHERE Code = 'BIO-325'), 1, 2);

-- Eighty-Eighth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(88, (SELECT ID FROM COURSES WHERE Code = 'BIO-311'), 1, 1), -- BIO-311 (300L, First Semester, 1st Course)
(88, (SELECT ID FROM COURSES WHERE Code = 'BIO-312'), 1, 1), 
(88, (SELECT ID FROM COURSES WHERE Code = 'BIO-313'), 1, 1), 
(88, (SELECT ID FROM COURSES WHERE Code = 'BIO-314'), 1, 1), 
(88, (SELECT ID FROM COURSES WHERE Code = 'BIO-315'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(88, (SELECT ID FROM COURSES WHERE Code = 'BIO-321'), 1, 2), -- BIO-321 (300L, Second Semester, 1st Course)
(88, (SELECT ID FROM COURSES WHERE Code = 'BIO-322'), 1, 2), 
(88, (SELECT ID FROM COURSES WHERE Code = 'BIO-323'), 1, 2), 
(88, (SELECT ID FROM COURSES WHERE Code = 'BIO-324'), 1, 2), 
(88, (SELECT ID FROM COURSES WHERE Code = 'BIO-325'), 1, 2);

-- Eighty-Ninth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(89, (SELECT ID FROM COURSES WHERE Code = 'BIO-411'), 1, 1), -- BIO-411 (400L, First Semester, 1st Course)
(89, (SELECT ID FROM COURSES WHERE Code = 'BIO-412'), 1, 1), 
(89, (SELECT ID FROM COURSES WHERE Code = 'BIO-413'), 1, 1), 
(89, (SELECT ID FROM COURSES WHERE Code = 'BIO-414'), 1, 1), 
(89, (SELECT ID FROM COURSES WHERE Code = 'BIO-415'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(89, (SELECT ID FROM COURSES WHERE Code = 'BIO-421'), 1, 2), -- BIO-421 (400L, Second Semester, 1st Course)
(89, (SELECT ID FROM COURSES WHERE Code = 'BIO-422'), 1, 2), 
(89, (SELECT ID FROM COURSES WHERE Code = 'BIO-423'), 1, 2), 
(89, (SELECT ID FROM COURSES WHERE Code = 'BIO-424'), 1, 2), 
(89, (SELECT ID FROM COURSES WHERE Code = 'BIO-425'), 1, 2);

-- Nintieth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(90, (SELECT ID FROM COURSES WHERE Code = 'BIO-411'), 1, 1), -- BIO-411 (400L, First Semester, 1st Course)
(90, (SELECT ID FROM COURSES WHERE Code = 'BIO-412'), 1, 1), 
(90, (SELECT ID FROM COURSES WHERE Code = 'BIO-413'), 1, 1), 
(90, (SELECT ID FROM COURSES WHERE Code = 'BIO-414'), 1, 1), 
(90, (SELECT ID FROM COURSES WHERE Code = 'BIO-415'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(90, (SELECT ID FROM COURSES WHERE Code = 'BIO-421'), 1, 2), -- BIO-421 (400L, Second Semester, 1st Course)
(90, (SELECT ID FROM COURSES WHERE Code = 'BIO-422'), 1, 2), 
(90, (SELECT ID FROM COURSES WHERE Code = 'BIO-423'), 1, 2), 
(90, (SELECT ID FROM COURSES WHERE Code = 'BIO-424'), 1, 2), 
(90, (SELECT ID FROM COURSES WHERE Code = 'BIO-425'), 1, 2);

-- Ninty-First Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(91, (SELECT ID FROM COURSES WHERE Code = 'GEO-111'), 1, 1), -- GEO-111 (100L, First Semester, 1st Course)
(91, (SELECT ID FROM COURSES WHERE Code = 'GEO-112'), 1, 1), 
(91, (SELECT ID FROM COURSES WHERE Code = 'GEO-113'), 1, 1), 
(91, (SELECT ID FROM COURSES WHERE Code = 'GEO-114'), 1, 1), 
(91, (SELECT ID FROM COURSES WHERE Code = 'GEO-115'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(91, (SELECT ID FROM COURSES WHERE Code = 'GEO-121'), 1, 2), -- GEO-121 (100L, Second Semester, 1st Course)
(91, (SELECT ID FROM COURSES WHERE Code = 'GEO-122'), 1, 2), 
(91, (SELECT ID FROM COURSES WHERE Code = 'GEO-123'), 1, 2), 
(91, (SELECT ID FROM COURSES WHERE Code = 'GEO-124'), 1, 2), 
(91, (SELECT ID FROM COURSES WHERE Code = 'GEO-125'), 1, 2);

-- Ninty-Second Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(92, (SELECT ID FROM COURSES WHERE Code = 'GEO-111'), 1, 1), -- GEO-111 (100L, First Semester, 1st Course)
(92, (SELECT ID FROM COURSES WHERE Code = 'GEO-112'), 1, 1), 
(92, (SELECT ID FROM COURSES WHERE Code = 'GEO-113'), 1, 1), 
(92, (SELECT ID FROM COURSES WHERE Code = 'GEO-114'), 1, 1), 
(92, (SELECT ID FROM COURSES WHERE Code = 'GEO-115'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(92, (SELECT ID FROM COURSES WHERE Code = 'GEO-121'), 1, 2), -- GEO-121 (100L, Second Semester, 1st Course)
(92, (SELECT ID FROM COURSES WHERE Code = 'GEO-122'), 1, 2), 
(92, (SELECT ID FROM COURSES WHERE Code = 'GEO-123'), 1, 2), 
(92, (SELECT ID FROM COURSES WHERE Code = 'GEO-124'), 1, 2), 
(92, (SELECT ID FROM COURSES WHERE Code = 'GEO-125'), 1, 2);

-- Ninty-Third Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(93, (SELECT ID FROM COURSES WHERE Code = 'GEO-111'), 1, 1), -- GEO-111 (100L, First Semester, 1st Course)
(93, (SELECT ID FROM COURSES WHERE Code = 'GEO-112'), 1, 1), 
(93, (SELECT ID FROM COURSES WHERE Code = 'GEO-113'), 1, 1), 
(93, (SELECT ID FROM COURSES WHERE Code = 'GEO-114'), 1, 1), 
(93, (SELECT ID FROM COURSES WHERE Code = 'GEO-115'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(93, (SELECT ID FROM COURSES WHERE Code = 'GEO-121'), 1, 2), -- GEO-121 (100L, Second Semester, 1st Course)
(93, (SELECT ID FROM COURSES WHERE Code = 'GEO-122'), 1, 2), 
(93, (SELECT ID FROM COURSES WHERE Code = 'GEO-123'), 1, 2), 
(93, (SELECT ID FROM COURSES WHERE Code = 'GEO-124'), 1, 2), 
(93, (SELECT ID FROM COURSES WHERE Code = 'GEO-125'), 1, 2);

-- Ninty-Fourth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(94, (SELECT ID FROM COURSES WHERE Code = 'GEO-211'), 1, 1), -- GEO-211 (200L, First Semester, 1st Course)
(94, (SELECT ID FROM COURSES WHERE Code = 'GEO-212'), 1, 1), 
(94, (SELECT ID FROM COURSES WHERE Code = 'GEO-213'), 1, 1), 
(94, (SELECT ID FROM COURSES WHERE Code = 'GEO-214'), 1, 1), 
(94, (SELECT ID FROM COURSES WHERE Code = 'GEO-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(94, (SELECT ID FROM COURSES WHERE Code = 'GEO-221'), 1, 2), -- GEO-221 (200L, Second Semester, 1st Course)
(94, (SELECT ID FROM COURSES WHERE Code = 'GEO-222'), 1, 2), 
(94, (SELECT ID FROM COURSES WHERE Code = 'GEO-223'), 1, 2), 
(94, (SELECT ID FROM COURSES WHERE Code = 'GEO-224'), 1, 2), 
(94, (SELECT ID FROM COURSES WHERE Code = 'GEO-225'), 1, 2);

-- Ninty-Fifth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(95, (SELECT ID FROM COURSES WHERE Code = 'GEO-211'), 1, 1), -- GEO-211 (200L, First Semester, 1st Course)
(95, (SELECT ID FROM COURSES WHERE Code = 'GEO-212'), 1, 1), 
(95, (SELECT ID FROM COURSES WHERE Code = 'GEO-213'), 1, 1), 
(95, (SELECT ID FROM COURSES WHERE Code = 'GEO-214'), 1, 1), 
(95, (SELECT ID FROM COURSES WHERE Code = 'GEO-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(95, (SELECT ID FROM COURSES WHERE Code = 'GEO-221'), 1, 2), -- GEO-221 (200L, Second Semester, 1st Course)
(95, (SELECT ID FROM COURSES WHERE Code = 'GEO-222'), 1, 2), 
(95, (SELECT ID FROM COURSES WHERE Code = 'GEO-223'), 1, 2), 
(95, (SELECT ID FROM COURSES WHERE Code = 'GEO-224'), 1, 2), 
(95, (SELECT ID FROM COURSES WHERE Code = 'GEO-225'), 1, 2);

-- Ninty-Sixth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(96, (SELECT ID FROM COURSES WHERE Code = 'GEO-211'), 1, 1), -- GEO-211 (200L, First Semester, 1st Course)
(96, (SELECT ID FROM COURSES WHERE Code = 'GEO-212'), 1, 1), 
(96, (SELECT ID FROM COURSES WHERE Code = 'GEO-213'), 1, 1), 
(96, (SELECT ID FROM COURSES WHERE Code = 'GEO-214'), 1, 1), 
(96, (SELECT ID FROM COURSES WHERE Code = 'GEO-215'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(96, (SELECT ID FROM COURSES WHERE Code = 'GEO-221'), 1, 2), -- GEO-221 (200L, Second Semester, 1st Course)
(96, (SELECT ID FROM COURSES WHERE Code = 'GEO-222'), 1, 2), 
(96, (SELECT ID FROM COURSES WHERE Code = 'GEO-223'), 1, 2), 
(96, (SELECT ID FROM COURSES WHERE Code = 'GEO-224'), 1, 2), 
(96, (SELECT ID FROM COURSES WHERE Code = 'GEO-225'), 1, 2);

-- Ninty-Seventh Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(97, (SELECT ID FROM COURSES WHERE Code = 'GEO-311'), 1, 1), -- GEO-311 (300L, First Semester, 1st Course)
(97, (SELECT ID FROM COURSES WHERE Code = 'GEO-312'), 1, 1), 
(97, (SELECT ID FROM COURSES WHERE Code = 'GEO-313'), 1, 1), 
(97, (SELECT ID FROM COURSES WHERE Code = 'GEO-314'), 1, 1), 
(97, (SELECT ID FROM COURSES WHERE Code = 'GEO-315'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(97, (SELECT ID FROM COURSES WHERE Code = 'GEO-321'), 1, 2), -- GEO-321 (300L, Second Semester, 1st Course)
(97, (SELECT ID FROM COURSES WHERE Code = 'GEO-322'), 1, 2), 
(97, (SELECT ID FROM COURSES WHERE Code = 'GEO-323'), 1, 2), 
(97, (SELECT ID FROM COURSES WHERE Code = 'GEO-324'), 1, 2), 
(97, (SELECT ID FROM COURSES WHERE Code = 'GEO-325'), 1, 2);

-- Ninty-Eighth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(98, (SELECT ID FROM COURSES WHERE Code = 'GEO-311'), 1, 1), -- GEO-311 (300L, First Semester, 1st Course)
(98, (SELECT ID FROM COURSES WHERE Code = 'GEO-312'), 1, 1), 
(98, (SELECT ID FROM COURSES WHERE Code = 'GEO-313'), 1, 1), 
(98, (SELECT ID FROM COURSES WHERE Code = 'GEO-314'), 1, 1), 
(98, (SELECT ID FROM COURSES WHERE Code = 'GEO-315'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(98, (SELECT ID FROM COURSES WHERE Code = 'GEO-321'), 1, 2), -- GEO-321 (300L, Second Semester, 1st Course)
(98, (SELECT ID FROM COURSES WHERE Code = 'GEO-322'), 1, 2), 
(98, (SELECT ID FROM COURSES WHERE Code = 'GEO-323'), 1, 2), 
(98, (SELECT ID FROM COURSES WHERE Code = 'GEO-324'), 1, 2), 
(98, (SELECT ID FROM COURSES WHERE Code = 'GEO-325'), 1, 2);

-- Ninty-Ninth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(99, (SELECT ID FROM COURSES WHERE Code = 'GEO-411'), 1, 1), -- GEO-411 (400L, First Semester, 1st Course)
(99, (SELECT ID FROM COURSES WHERE Code = 'GEO-412'), 1, 1), 
(99, (SELECT ID FROM COURSES WHERE Code = 'GEO-413'), 1, 1), 
(99, (SELECT ID FROM COURSES WHERE Code = 'GEO-414'), 1, 1), 
(99, (SELECT ID FROM COURSES WHERE Code = 'GEO-415'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(99, (SELECT ID FROM COURSES WHERE Code = 'GEO-421'), 1, 2), -- GEO-421 (400L, Second Semester, 1st Course)
(99, (SELECT ID FROM COURSES WHERE Code = 'GEO-422'), 1, 2), 
(99, (SELECT ID FROM COURSES WHERE Code = 'GEO-423'), 1, 2), 
(99, (SELECT ID FROM COURSES WHERE Code = 'GEO-424'), 1, 2), 
(99, (SELECT ID FROM COURSES WHERE Code = 'GEO-425'), 1, 2);

-- Hundredth Student
INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(100, (SELECT ID FROM COURSES WHERE Code = 'GEO-411'), 1, 1), -- GEO-411 (400L, First Semester, 1st Course)
(100, (SELECT ID FROM COURSES WHERE Code = 'GEO-412'), 1, 1), 
(100, (SELECT ID FROM COURSES WHERE Code = 'GEO-413'), 1, 1), 
(100, (SELECT ID FROM COURSES WHERE Code = 'GEO-414'), 1, 1), 
(100, (SELECT ID FROM COURSES WHERE Code = 'GEO-415'), 1, 1); 

INSERT INTO STUDENT_COURSE (StudentID, CourseID, SessionID, SemesterID) VALUES
(100, (SELECT ID FROM COURSES WHERE Code = 'GEO-421'), 1, 2), -- GEO-421 (400L, Second Semester, 1st Course)
(100, (SELECT ID FROM COURSES WHERE Code = 'GEO-422'), 1, 2), 
(100, (SELECT ID FROM COURSES WHERE Code = 'GEO-423'), 1, 2), 
(100, (SELECT ID FROM COURSES WHERE Code = 'GEO-424'), 1, 2), 
(100, (SELECT ID FROM COURSES WHERE Code = 'GEO-425'), 1, 2);

SELECT * FROM LECTURERS
DELETE FROM LECTURERS
DBCC CHECKIDENT ('LECTURERS', RESEED, 0);

-- Inserting into Lecturers Table
INSERT INTO LECTURERS (FirstName, LastName, Email, Phone, DepartmentID)
VALUES
    ('John', 'Doe', 'john.doe@university.com', '555-0100001', 1),
    ('Jane', 'Smith', 'jane.smith@university.com', '555-0100002', 1),
    ('James', 'Johnson', 'james.johnson@university.com', '555-0100003', 1),
    ('Emily', 'Williams', 'emily.williams@university.com', '555-0100004', 1),
    ('Michael', 'Brown', 'michael.brown@university.com', '555-0100005', 1),
    ('Sarah', 'Jones', 'sarah.jones@university.com', '555-0100006', 1),
    ('David', 'Miller', 'david.miller@university.com', '555-0100007', 1),
    ('Laura', 'Davis', 'laura.davis@university.com', '555-0100008', 1),
    ('Robert', 'Garcia', 'robert.garcia@university.com', '555-0100009', 1),
    ('Sophia', 'Martinez', 'sophia.martinez@university.com', '555-0100010', 1),
    ('William', 'Rodriguez', 'william.rodriguez@university.com', '555-0100011', 1),
    ('Olivia', 'Wilson', 'olivia.wilson@university.com', '555-0100012', 1),
    ('Benjamin', 'Moore', 'benjamin.moore@university.com', '555-0100013', 1),
    ('Ava', 'Taylor', 'ava.taylor@university.com', '555-0100014', 1),
    ('Ethan', 'Anderson', 'ethan.anderson@university.com', '555-0100015', 1),
    ('Isabella', 'Thomas', 'isabella.thomas@university.com', '555-0100016', 1),
    ('James', 'Jackson', 'james.jackson@university.com', '555-0100017', 1),
    ('Mia', 'White', 'mia.white@university.com', '555-0100018', 1),
    ('Liam', 'Harris', 'liam.harris@university.com', '555-0100019', 1),
    ('Charlotte', 'Martin', 'charlotte.martin@university.com', '555-0100020', 1),
    ('Noah', 'Lee', 'noah.lee@university.com', '555-0100021', 1),
    ('Amelia', 'Walker', 'amelia.walker@university.com', '555-0100022', 1),
    ('Lucas', 'Perez', 'lucas.perez@university.com', '555-0100023', 1),
    ('Eleanor', 'Clark', 'eleanor.clark@university.com', '555-0100024', 1),
    ('Jack', 'Lewis', 'jack.lewis@university.com', '555-0100025', 1),
	 ('James', 'Williams', 'james.williams@university.com', '555-0100059', 2),
    ('Sophia', 'Jones', 'sophia.jones@university.com', '555-0100060', 2),
    ('Benjamin', 'Miller', 'benjamin.miller@university.com', '555-0100061', 2),
    ('Charlotte', 'Davis', 'charlotte.davis@university.com', '555-0100062', 2),
    ('Ethan', 'Rodriguez', 'ethan.rodriguez@university.com', '555-0100063', 2),
    ('Mason', 'Wilson', 'mason.wilson@university.com', '555-0100064', 2),
    ('Amelia', 'Martinez', 'amelia.martinez@university.com', '555-0100065', 2),
    ('Olivia', 'Garcia', 'olivia.garcia@university.com', '555-0100066', 2),
    ('Aiden', 'Hernandez', 'aiden.hernandez@university.com', '555-0100067', 2),
    ('Liam', 'Moore', 'liam.moore@university.com', '555-0100068', 2),
    ('Ella', 'Taylor', 'ella.taylor@university.com', '555-0100069', 2),
    ('Lucas', 'Parker', 'lucas.parker@university.com', '555-0100070', 2),
    ('Mia', 'Brown', 'mia.brown@university.com', '555-0100071', 2),
    ('Noah', 'Scott', 'noah.scott@university.com', '555-0100072', 2),
    ('Ava', 'Young', 'ava.young@university.com', '555-0100073', 2),
    ('Zoe', 'Lee', 'zoe.lee@university.com', '555-0100074', 2),
    ('Lily', 'White', 'lily.white@university.com', '555-0100075', 2),
    ('Ethan', 'Jackson', 'ethan.jackson@university.com', '555-0100076', 2),
    ('Benjamin', 'Clark', 'benjamin.clark@university.com', '555-0100077', 2),
    ('Isabella', 'Evans', 'isabella.evans@university.com', '555-0100078', 2),
    ('James', 'Wilson', 'james.wilson@university.com', '555-0100079', 2),
    ('Sophia', 'Lewis', 'sophia.lewis@university.com', '555-0100080', 2),
    ('Grace', 'Lopez', 'grace.lopez@university.com', '555-0100081', 2),
    ('Mason', 'Roberts', 'mason.roberts@university.com', '555-0100082', 2),
    ('Amelia', 'Harris', 'amelia.harris@university.com', '555-0100083', 2),
    ('William', 'Allen', 'william.allen@university.com', '555-0100084', 2),
	('Liam', 'Martinez', 'liam.martinez@university.com', '555-0100085', 3),
    ('Mia', 'Roberts', 'mia.roberts@university.com', '555-0100086', 3),
    ('Ethan', 'Harris', 'ethan.harris@university.com', '555-0100087', 3),
    ('Charlotte', 'Scott', 'charlotte.scott@university.com', '555-0100088', 3),
    ('William', 'Perez', 'william.perez@university.com', '555-0100089', 3),
    ('Isabella', 'Wilson', 'isabella.wilson@university.com', '555-0100090', 3),
    ('Ava', 'Brown', 'ava.brown@university.com', '555-0100091', 3),
    ('James', 'Davis', 'james.davis@university.com', '555-0100092', 3),
    ('Mason', 'Lopez', 'mason.lopez@university.com', '555-0100093', 3),
    ('Sophia', 'Clark', 'sophia.clark@university.com', '555-0100094', 3),
    ('Benjamin', 'Taylor', 'benjamin.taylor@university.com', '555-0100095', 3),
    ('Emma', 'Lee', 'emma.lee@university.com', '555-0100096', 3),
    ('Lucas', 'White', 'lucas.white@university.com', '555-0100097', 3),
    ('Maya', 'Young', 'maya.young@university.com', '555-0100098', 3),
    ('Lily', 'Jackson', 'lily.jackson@university.com', '555-0100099', 3),
    ('Amelia', 'Evans', 'amelia.evans@university.com', '555-0100100', 3),
    ('Oliver', 'Martinez', 'oliver.martinez@university.com', '555-0100101', 3),
    ('Jack', 'Moore', 'jack.moore@university.com', '555-0100102', 3),
    ('Sophia', 'Roberts', 'sophia.roberts@university.com', '555-0100103', 3),
    ('Noah', 'Parker', 'noah.parker@university.com', '555-0100104', 3),
    ('Zoe', 'Allen', 'zoe.allen@university.com', '555-0100105', 3),
    ('Liam', 'Hernandez', 'liam.hernandez@university.com', '555-0100106', 3),
    ('Lucas', 'White', 'lucas.white@university.com', '555-0100107', 3),
    ('Grace', 'Taylor', 'grace.taylor@university.com', '555-0100108', 3),
    ('Ethan', 'Jackson', 'ethan.jackson@university.com', '555-0100109', 3),
	('David', 'Miller', 'david.miller@university.com', '555-0100110', 4),
    ('Sophia', 'Wilson', 'sophia.wilson@university.com', '555-0100111', 4),
    ('Liam', 'Brown', 'liam.brown@university.com', '555-0100112', 4),
    ('Emma', 'Johnson', 'emma.johnson@university.com', '555-0100113', 4),
    ('Olivia', 'White', 'olivia.white@university.com', '555-0100114', 4),
    ('James', 'Evans', 'james.evans@university.com', '555-0100115', 4),
    ('Grace', 'Martinez', 'grace.martinez@university.com', '555-0100116', 4),
    ('Ethan', 'Hernandez', 'ethan.hernandez@university.com', '555-0100117', 4),
    ('Benjamin', 'Parker', 'benjamin.parker@university.com', '555-0100118', 4),
    ('Lily', 'Roberts', 'lily.roberts@university.com', '555-0100119', 4),
    ('Aiden', 'Lewis', 'aiden.lewis@university.com', '555-0100120', 4),
    ('Isabella', 'Thomas', 'isabella.thomas@university.com', '555-0100121', 4),
    ('Lucas', 'Jackson', 'lucas.jackson@university.com', '555-0100122', 4),
    ('Mason', 'Scott', 'mason.scott@university.com', '555-0100123', 4),
    ('Ava', 'White', 'ava.white@university.com', '555-0100124', 4),
    ('Benjamin', 'Roberts', 'benjamin.roberts@university.com', '555-0100125', 4),
    ('Zoe', 'Martinez', 'zoe.martinez@university.com', '555-0100126', 4),
    ('Mia', 'Harris', 'mia.harris@university.com', '555-0100127', 4),
    ('Ethan', 'Clark', 'ethan.clark@university.com', '555-0100128', 4),
    ('Charlotte', 'Lewis', 'charlotte.lewis@university.com', '555-0100129', 4),
    ('Oliver', 'Young', 'oliver.young@university.com', '555-0100130', 4),
    ('James', 'Taylor', 'james.taylor@university.com', '555-0100131', 4),
    ('Mason', 'Roberts', 'mason.roberts@university.com', '555-0100132', 4),
    ('Ava', 'Clark', 'ava.clark@university.com', '555-0100133', 4),
    ('Liam', 'Evans', 'liam.evans@university.com', '555-0100134', 4),
	('Matthew', 'Johnson', 'matthew.johnson@university.com', '555-0100135', 5),
    ('Ava', 'Davis', 'ava.davis@university.com', '555-0100136', 5),
    ('Liam', 'Miller', 'liam.miller@university.com', '555-0100137', 5),
    ('Grace', 'Clark', 'grace.clark@university.com', '555-0100138', 5),
    ('Sophia', 'Lee', 'sophia.lee@university.com', '555-0100139', 5),
    ('Benjamin', 'Hernandez', 'benjamin.hernandez@university.com', '555-0100140', 5),
    ('Lucas', 'Wilson', 'lucas.wilson@university.com', '555-0100141', 5),
    ('Mia', 'Roberts', 'mia.roberts@university.com', '555-0100142', 5),
    ('Zoe', 'Martinez', 'zoe.martinez@university.com', '555-0100143', 5),
    ('Oliver', 'Taylor', 'oliver.taylor@university.com', '555-0100144', 5),
    ('James', 'Clark', 'james.clark@university.com', '555-0100145', 5),
    ('Aiden', 'Parker', 'aiden.parker@university.com', '555-0100146', 5),
    ('Amelia', 'Lopez', 'amelia.lopez@university.com', '555-0100147', 5),
    ('Lily', 'Scott', 'lily.scott@university.com', '555-0100148', 5),
    ('Ethan', 'Thomas', 'ethan.thomas@university.com', '555-0100149', 5),
    ('Charlotte', 'White', 'charlotte.white@university.com', '555-0100150', 5),
    ('Mason', 'Jackson', 'mason.jackson@university.com', '555-0100151', 5),
    ('Sophia', 'Evans', 'sophia.evans@university.com', '555-0100152', 5),
    ('Benjamin', 'Davis', 'benjamin.davis@university.com', '555-0100153', 5),
    ('Olivia', 'Taylor', 'olivia.taylor@university.com', '555-0100154', 5),
    ('Jack', 'Roberts', 'jack.roberts@university.com', '555-0100155', 5),
    ('Amelia', 'Wilson', 'amelia.wilson@university.com', '555-0100156', 5),
    ('Ethan', 'White', 'ethan.white@university.com', '555-0100157', 5),
    ('Lucas', 'Harris', 'lucas.harris@university.com', '555-0100158', 5),
    ('Isabella', 'Lopez', 'isabella.lopez@university.com', '555-0100159', 5),
    ('Mason', 'Evans', 'mason.evans@university.com', '555-0100160', 5),
	('Daniel', 'Anderson', 'daniel.anderson@university.com', '555-0100161', 6),
    ('Sophia', 'Baker', 'sophia.baker@university.com', '555-0100162', 6),
    ('Benjamin', 'Hughes', 'benjamin.hughes@university.com', '555-0100163', 6),
    ('Lily', 'Foster', 'lily.foster@university.com', '555-0100164', 6),
    ('Mia', 'Martinez', 'mia.martinez@university.com', '555-0100165', 6),
    ('Lucas', 'Graham', 'lucas.graham@university.com', '555-0100166', 6),
    ('Grace', 'Miller', 'grace.miller@university.com', '555-0100167', 6),
    ('Ethan', 'Carter', 'ethan.carter@university.com', '555-0100168', 6),
    ('Olivia', 'Bennett', 'olivia.bennett@university.com', '555-0100169', 6),
    ('Aiden', 'Nelson', 'aiden.nelson@university.com', '555-0100170', 6),
    ('Mason', 'Parker', 'mason.parker@university.com', '555-0100171', 6),
    ('Isabella', 'Scott', 'isabella.scott@university.com', '555-0100172', 6),
    ('Zoe', 'Adams', 'zoe.adams@university.com', '555-0100173', 6),
    ('Charlotte', 'Simmons', 'charlotte.simmons@university.com', '555-0100174', 6),
    ('James', 'Rodriguez', 'james.rodriguez@university.com', '555-0100175', 6),
    ('Benjamin', 'Stewart', 'benjamin.stewart@university.com', '555-0100176', 6),
    ('Ethan', 'Davis', 'ethan.davis@university.com', '555-0100177', 6),
    ('Olivia', 'Long', 'olivia.long@university.com', '555-0100178', 6),
    ('Mia', 'Jenkins', 'mia.jenkins@university.com', '555-0100179', 6),
    ('Liam', 'Morris', 'liam.morris@university.com', '555-0100180', 6),
	 ('David', 'Moore', 'david.moore@university.com', '555-0100181', 7),
    ('Ava', 'Taylor', 'ava.taylor@university.com', '555-0100182', 7),
    ('Ethan', 'Baker', 'ethan.baker@university.com', '555-0100183', 7),
    ('Mason', 'Ward', 'mason.ward@university.com', '555-0100184', 7),
    ('Sophia', 'Harris', 'sophia.harris@university.com', '555-0100185', 7),
    ('Lucas', 'Cameron', 'lucas.cameron@university.com', '555-0100186', 7),
    ('Olivia', 'Hill', 'olivia.hill@university.com', '555-0100187', 7),
    ('Lily', 'Evans', 'lily.evans@university.com', '555-0100188', 7),
    ('Benjamin', 'Foster', 'benjamin.foster@university.com', '555-0100189', 7),
    ('James', 'Collins', 'james.collins@university.com', '555-0100190', 7),
    ('Emma', 'Wright', 'emma.wright@university.com', '555-0100191', 7),
    ('Aiden', 'Patterson', 'aiden.patterson@university.com', '555-0100192', 7),
    ('Mia', 'Hughes', 'mia.hughes@university.com', '555-0100193', 7),
    ('Charlotte', 'Jordan', 'charlotte.jordan@university.com', '555-0100194', 7),
    ('Isabella', 'Russell', 'isabella.russell@university.com', '555-0100195', 7),
    ('Liam', 'Edwards', 'liam.edwards@university.com', '555-0100196', 7),
    ('Grace', 'Roberts', 'grace.roberts@university.com', '555-0100197', 7),
    ('Zoe', 'Turner', 'zoe.turner@university.com', '555-0100198', 7),
    ('Noah', 'Martin', 'noah.martin@university.com', '555-0100199', 7),
    ('Oliver', 'Mitchell', 'oliver.mitchell@university.com', '555-0100200', 7),
	('Liam', 'Nelson', 'liam.nelson@university.com', '555-0100201', 8),
    ('Olivia', 'King', 'olivia.king@university.com', '555-0100202', 8),
    ('Sophia', 'Adams', 'sophia.adams@university.com', '555-0100203', 8),
    ('Ethan', 'Barnes', 'ethan.barnes@university.com', '555-0100204', 8),
    ('Mason', 'Stewart', 'mason.stewart@university.com', '555-0100205', 8),
    ('Benjamin', 'Morgan', 'benjamin.morgan@university.com', '555-0100206', 8),
    ('Ava', 'Fletcher', 'ava.fletcher@university.com', '555-0100207', 8),
    ('Lucas', 'Collins', 'lucas.collins@university.com', '555-0100208', 8),
    ('Mia', 'Bennett', 'mia.bennett@university.com', '555-0100209', 8),
    ('James', 'Cooper', 'james.cooper@university.com', '555-0100210', 8),
    ('Charlotte', 'Hill', 'charlotte.hill@university.com', '555-0100211', 8),
    ('Isabella', 'Roberts', 'isabella.roberts@university.com', '555-0100212', 8),
    ('Zoe', 'Mitchell', 'zoe.mitchell@university.com', '555-0100213', 8),
    ('Aiden', 'Carter', 'aiden.carter@university.com', '555-0100214', 8),
    ('Lily', 'Davis', 'lily.davis@university.com', '555-0100215', 8),
    ('Ethan', 'Clark', 'ethan.clark@university.com', '555-0100216', 8),
    ('Mason', 'Scott', 'mason.scott@university.com', '555-0100217', 8),
    ('Benjamin', 'Allen', 'benjamin.allen@university.com', '555-0100218', 8),
    ('Sophia', 'James', 'sophia.james@university.com', '555-0100219', 8),
    ('Olivia', 'Turner', 'olivia.turner@university.com', '555-0100220', 8),
	('Liam', 'Wilson', 'liam.wilson@university.com', '555-0100221', 9),
    ('Ava', 'Davis', 'ava.davis@university.com', '555-0100222', 9),
    ('Ethan', 'Taylor', 'ethan.taylor@university.com', '555-0100223', 9),
    ('Mason', 'Brown', 'mason.brown@university.com', '555-0100224', 9),
    ('Sophia', 'Miller', 'sophia.miller@university.com', '555-0100225', 9),
    ('Benjamin', 'Moore', 'benjamin.moore@university.com', '555-0100226', 9),
    ('Olivia', 'Johnson', 'olivia.johnson@university.com', '555-0100227', 9),
    ('Lucas', 'Harris', 'lucas.harris@university.com', '555-0100228', 9),
    ('Grace', 'Clark', 'grace.clark@university.com', '555-0100229', 9),
    ('Isabella', 'Lee', 'isabella.lee@university.com', '555-0100230', 9),
    ('Zoe', 'Scott', 'zoe.scott@university.com', '555-0100231', 9),
    ('Charlotte', 'Parker', 'charlotte.parker@university.com', '555-0100232', 9),
    ('James', 'Rodriguez', 'james.rodriguez@university.com', '555-0100233', 9),
    ('Oliver', 'Green', 'oliver.green@university.com', '555-0100234', 9),
    ('Benjamin', 'Adams', 'benjamin.adams@university.com', '555-0100235', 9),
    ('Mia', 'Walker', 'mia.walker@university.com', '555-0100236', 9),
    ('Ethan', 'Young', 'ethan.young@university.com', '555-0100237', 9),
    ('Aiden', 'Mitchell', 'aiden.mitchell@university.com', '555-0100238', 9),
    ('Lily', 'Collins', 'lily.collins@university.com', '555-0100239', 9),
    ('Sophia', 'Hughes', 'sophia.hughes@university.com', '555-0100240', 9),
	 ('David', 'King', 'david.king@university.com', '555-0100241', 10),
    ('Ava', 'Moore', 'ava.moore@university.com', '555-0100242', 10),
    ('Sophia', 'Jackson', 'sophia.jackson@university.com', '555-0100243', 10),
    ('Mason', 'Lee', 'mason.lee@university.com', '555-0100244', 10),
    ('Lucas', 'White', 'lucas.white@university.com', '555-0100245', 10),
    ('Isabella', 'Davis', 'isabella.davis@university.com', '555-0100246', 10),
    ('Ethan', 'Taylor', 'ethan.taylor@university.com', '555-0100247', 10),
    ('Olivia', 'Anderson', 'olivia.anderson@university.com', '555-0100248', 10),
    ('Liam', 'Brown', 'liam.brown@university.com', '555-0100249', 10),
    ('Zoe', 'Clark', 'zoe.clark@university.com', '555-0100250', 10),
    ('Benjamin', 'Wilson', 'benjamin.wilson@university.com', '555-0100251', 10),
    ('Aiden', 'Moore', 'aiden.moore@university.com', '555-0100252', 10),
    ('Grace', 'Lopez', 'grace.lopez@university.com', '555-0100253', 10),
    ('Charlotte', 'Harris', 'charlotte.harris@university.com', '555-0100254', 10),
    ('Oliver', 'Martin', 'oliver.martin@university.com', '555-0100255', 10),
    ('Mia', 'Walker', 'mia.walker@university.com', '555-0100256', 10),
    ('Benjamin', 'Young', 'benjamin.young@university.com', '555-0100257', 10),
    ('Aiden', 'Carter', 'aiden.carter@university.com', '555-0100258', 10),
    ('Sophia', 'Adams', 'sophia.adams@university.com', '555-0100259', 10),
    ('Lily', 'Roberts', 'lily.roberts@university.com', '555-0100260', 10);

-- Querying LECTURERS Table
SELECT * FROM LECTURERS
WHERE DepartmentID = 11

SELECT C.ID, C.Code, C.Name, D.ID, D.Name FROM COURSES C INNER JOIN DEPARTMENT D ON D.ID = DepartmentID WHERE D.ID = 10
DELETE FROM Lecturer_Course
SELECT * FROM Lecturer_Course

-- Populating Lecturer_Course Table
-- CSE Lecturers Courses
INSERT INTO Lecturer_Course (LecturerID, CourseID)
VALUES
(1, 1), (1, 2),
(2, 3), (2, 4),
(3, 5), (3, 6),
(4, 7), (4, 8),
(5, 9), (5, 10),
(6, 11), (6, 12),
(7, 13), (7, 14),
(8, 15), (8, 16),
(9, 17), (9, 18),
(10, 19), (10, 20),
(11, 21), (11, 22),
(12, 23), (12, 24),
(13, 25), (13, 26),
(14, 27), (14, 28),
(15, 29), (15, 30),
(16, 31), (16, 32),
(17, 33), (17, 34),
(18, 35), (18, 36),
(19, 37), (19, 38),
(20, 39), (20, 40),
(21, 41), (21, 42),
(22, 43), (22, 44),
(23, 45), (23, 46),
(24, 47), (24, 48),
(25, 49), (25, 50);

-- MEE Lecturers Courses
INSERT INTO Lecturer_Course (LecturerID, CourseID)
VALUES
(26, 51), (26, 52),
(27, 53), (27, 54),
(28, 55), (28, 56),
(29, 57), (29, 58),
(30, 59), (30, 60),
(31, 61), (31, 62),
(32, 63), (32, 64),
(33, 65), (33, 66),
(34, 67), (34, 68),
(35, 69), (35, 70),
(36, 71), (36, 72),
(37, 73), (37, 74),
(38, 75), (38, 76),
(39, 77), (39, 78),
(40, 79), (40, 80),
(41, 81), (41, 82),
(42, 83), (42, 84),
(43, 85), (43, 86),
(44, 87), (44, 88),
(45, 89), (45, 90),
(46, 91), (46, 92),
(47, 93), (47, 94),
(48, 95), (48, 96),
(49, 97), (49, 98),
(50, 99),
(51, 100);

-- ELE Lecturers Courses
INSERT INTO Lecturer_Course (LecturerID, CourseID)
VALUES
(52, 101), (52, 102),
(53, 103), (53, 104),
(54, 105), (54, 106),
(55, 107), (55, 108),
(56, 109), (56, 110),
(57, 111), (57, 112),
(58, 113), (58, 114),
(59, 115), (59, 116),
(60, 117), (60, 118),
(61, 119), (61, 120),
(62, 121), (62, 122),
(63, 123), (63, 124),
(64, 125), (64, 126),
(65, 127), (65, 128),
(66, 129), (66, 130),
(67, 131), (67, 132),
(68, 133), (68, 134),
(69, 135), (69, 136),
(70, 137), (70, 138),
(71, 139), (71, 140),
(72, 141), (72, 142),
(73, 143), (73, 144),
(74, 145), (74, 146),
(75, 147), (75, 148),
(76, 149), (76, 150);

-- CIV Lecturers Courses
INSERT INTO Lecturer_Course (LecturerID, CourseID)
VALUES
(77, 151), (77, 152),
(78, 153), (78, 154),
(79, 155), (79, 156),
(80, 157), (80, 158),
(81, 159), (81, 160),
(82, 161), (82, 162),
(83, 163), (83, 164),
(84, 165), (84, 166),
(85, 167), (85, 168),
(86, 169), (86, 170),
(87, 171), (87, 172),
(88, 173), (88, 174),
(89, 175), (89, 176),
(90, 177), (90, 178),
(91, 179), (91, 180),
(92, 181), (92, 182),
(93, 183), (93, 184),
(94, 185), (94, 186),
(95, 187), (95, 188),
(96, 189), (96, 190),
(97, 191), (97, 192),
(98, 193), (98, 194),
(99, 195), (99, 196),
(100, 197), (100, 198),
(101, 199), (101, 200);

-- CHE Lecturers Courses
INSERT INTO Lecturer_Course (LecturerID, CourseID)
VALUES
(102, 201), (102, 202),
(103, 203), (103, 204),
(104, 205), (104, 206),
(105, 207), (105, 208),
(106, 209), (106, 210),
(107, 211), (107, 212),
(108, 213), (108, 214),
(109, 215), (109, 216),
(110, 217), (110, 218),
(111, 219), (111, 220),
(112, 221), (112, 222),
(113, 223), (113, 224),
(114, 225), (114, 226),
(115, 227), (115, 228),
(116, 229), (116, 230),
(117, 231), (117, 232),
(118, 233), (118, 234),
(119, 235), (119, 236),
(120, 237), (120, 238),
(121, 239), (121, 240),
(122, 241), (122, 242),
(123, 243), (123, 244),
(124, 245), (124, 246),
(125, 247), (125, 248),
(126, 249),
(127, 250);

-- Phy Lecturer Course
INSERT INTO Lecturer_Course (LecturerID, CourseID)
VALUES
(128, 251), (128, 252),
(129, 253), (129, 254),
(130, 255), (130, 256),
(131, 257), (131, 258),
(132, 259), (132, 260),
(133, 261), (133, 262),
(134, 263), (134, 264),
(135, 265), (135, 266),
(136, 267), (136, 268),
(137, 269), (137, 270),
(138, 271), (138, 272),
(139, 273), (139, 274),
(140, 275), (140, 276),
(141, 277), (141, 278),
(142, 279), (142, 280),
(143, 281), (143, 282),
(144, 283), (144, 284),
(145, 285), (145, 286),
(146, 287), (146, 288),
(147, 289), (147, 290),
(128, 291),
(129, 292),
(130, 293),
(131, 294),
(132, 295),
(133, 296),
(134, 297),
(135, 298),
(136, 299),
(137, 300);

-- MAT Lecturer Course
INSERT INTO Lecturer_Course (LecturerID, CourseID)
VALUES
(148, 301), (148, 302),
(149, 303), (149, 304),
(150, 305), (150, 306),
(151, 307), (151, 308),
(152, 309), (152, 310),
(153, 311), (153, 312),
(154, 313), (154, 314),
(155, 315), (155, 316),
(156, 317), (156, 318),
(157, 319), (157, 320),
(158, 321), (158, 322),
(159, 323), (159, 324),
(160, 325), (160, 326),
(161, 327), (161, 328),
(162, 329), (162, 330),
(163, 331), (163, 332),
(164, 333), (164, 334),
(165, 335), (165, 336),
(166, 337), (166, 338),
(167, 339), (167, 340);

-- CHM Lecturer Course
INSERT INTO Lecturer_Course (LecturerID, CourseID)
VALUES
(168, 341), (168, 342),
(169, 343), (169, 344),
(170, 345), (170, 346),
(171, 347), (171, 348),
(172, 349), (172, 350),
(173, 351), (173, 352),
(174, 353), (174, 354),
(175, 355), (175, 356),
(176, 357), (176, 358),
(177, 359), (177, 360),
(178, 361), (178, 362),
(179, 363), (179, 364),
(180, 365), (180, 366),
(181, 367), (181, 368),
(182, 369), (182, 370),
(183, 371), (183, 372),
(184, 373), (184, 374),
(185, 375), (185, 376),
(186, 377), (186, 378),
(187, 379), (187, 380);

-- BIO Lecturer Course
INSERT INTO Lecturer_Course (LecturerID, CourseID)
VALUES
(188, 381), (188, 382),
(189, 383), (189, 384),
(190, 385), (190, 386),
(191, 387), (191, 388),
(192, 389), (192, 390),
(193, 391), (193, 392),
(194, 393), (194, 394),
(195, 395), (195, 396),
(196, 397), (196, 398),
(197, 399), (197, 400),
(198, 401), (198, 402),
(199, 403), (199, 404),
(200, 405), (200, 406),
(201, 407), (201, 408),
(202, 409), (202, 410),
(203, 411), (203, 412),
(204, 413), (204, 414),
(205, 415), (205, 416),
(206, 417), (206, 418),
(207, 419), (207, 420);

-- GEO Lecturer Course
INSERT INTO Lecturer_Course (LecturerID, CourseID)
VALUES
(208, 421), (208, 422), (208, 423),
(209, 424), (209, 425), (209, 426),
(210, 427), (210, 428), (210, 429),
(211, 430), (211, 431), (211, 432),
(212, 433), (212, 434), (212, 435),
(213, 436), (213, 437), (213, 438),
(214, 439), (214, 440), (214, 441),
(215, 442), (215, 443), (215, 444),
(216, 445), (216, 446), (216, 447),
(217, 448), (217, 449), (217, 450),
(218, 451), (218, 452),
(219, 453), (219, 454),
(220, 455), (220, 456),
(221, 457), (221, 458),
(222, 459), (222, 460),
(223, 461), (223, 462),
(224, 463), (224, 464),
(225, 465), (225, 466),
(226, 467), (226, 468),
(227, 469), (227, 470);

-- Determining the lecturer taking what course
SELECT
CONCAT(L.FirstName, ' ', L.LastName) AS 'Lecturer Name',
D.Name,
C.Code,
C.Name
FROM Lecturer_Course LC
INNER JOIN COURSES C ON LC.CourseID = C.ID
INNER JOIN LECTURERS L ON LC.LecturerID = L.ID
INNER JOIN DEPARTMENT D ON C.DepartmentID = D.ID


-- Figuring out stuff
SELECT 
CONCAT(S.LastName, ' ', S.OtherNames) AS 'Student Name',
S.ID AS 'Student ID',
S.Level AS Level,
D.ID AS 'Dept ID',
D.Name AS 'Department',
C.ID AS 'Course ID',
C.Code AS 'Course Code',
C.Name AS 'Course'
FROM STUDENT_COURSE SC
INNER JOIN STUDENTS S ON S.ID = SC.StudentID
INNER JOIN COURSES C ON C.ID = SC.CourseID
INNER JOIN DEPARTMENT D ON D.ID = C.DepartmentID
WHERE D.ID = 1

-- Inserting into Gradebook
-- Populate the GRADEBOOK table for StudentID 1 to 10
INSERT INTO GRADEBOOK (StudentID, CourseID, Level, CA, Exam)
VALUES
-- StudentID 1
(1, 1, 100, 25, 50), (1, 2, 100, 20, 45), (1, 3, 100, 15, 40), 
(1, 4, 100, 28, 42), (1, 5, 100, 10, 30), (1, 6, 100, 22, 30), 
(1, 7, 100, 10, 38), (1, 8, 100, 25, 35), (1, 9, 100, 15, 32), (1, 10, 100, 20, 36),

-- StudentID 2
(2, 1, 100, 10, 30), (2, 2, 100, 15, 40), (2, 3, 100, 20, 45),
(2, 4, 100, 15, 35), (2, 5, 100, 30, 30), (2, 6, 100, 22, 32),
(2, 7, 100, 18, 25), (2, 8, 100, 18, 32), (2, 9, 100, 16, 29), (2, 10, 100, 15, 35),

-- StudentID 3
(3, 11, 200, 28, 45), (3, 12, 200, 24, 46), (3, 13, 200, 20, 38),
(3, 14, 200, 19, 40), (3, 15, 200, 25, 35), (3, 16, 200, 18, 32),
(3, 17, 200, 22, 40), (3, 18, 200, 15, 20), (3, 19, 200, 27, 35), (3, 20, 200, 21, 34),

-- StudentID 4
(4, 11, 200, 26, 39), (4, 12, 200, 7, 22), (4, 13, 200, 20, 42),
(4, 14, 200, 18, 33), (4, 15, 200, 23, 35), (4, 16, 200, 28, 41),
(4, 17, 200, 19, 30), (4, 18, 200, 22, 40), (4, 19, 200, 25, 44), (4, 20, 200, 20, 31),

-- StudentID 5
(5, 21, 300, 18, 40), (5, 22, 300, 28, 35), (5, 23, 300, 22, 38),
(5, 24, 300, 15, 32), (5, 25, 300, 20, 40), (5, 26, 300, 25, 42),
(5, 27, 300, 19, 38), (5, 28, 300, 18, 32), (5, 29, 300, 22, 30), (5, 30, 300, 21, 33),

-- StudentID 6
(6, 21, 300, 25, 35), (6, 22, 300, 18, 38), (6, 23, 300, 19, 34),
(6, 24, 300, 28, 42), (6, 25, 300, 30, 40), (6, 26, 300, 25, 38),
(6, 27, 300, 23, 35), (6, 28, 300, 18, 30), (6, 29, 300, 26, 45), (6, 30, 300, 20, 32),

-- StudentID 7
(7, 31, 400, 28, 40), (7, 32, 400, 24, 39), (7, 33, 400, 20, 35),
(7, 34, 400, 19, 38), (7, 35, 400, 30, 45), (7, 36, 400, 25, 36),
(7, 37, 400, 18, 32), (7, 38, 400, 15, 30), (7, 39, 400, 22, 40), (7, 40, 400, 27, 43),

-- StudentID 8
(8, 31, 400, 20, 40), (8, 32, 400, 15, 38), (8, 33, 400, 25, 42),
(8, 34, 400, 28, 41), (8, 35, 400, 30, 39), (8, 36, 400, 27, 35),
(8, 37, 400, 19, 34), (8, 38, 400, 18, 36), (8, 39, 400, 21, 42), (8, 40, 400, 23, 30),

-- StudentID 9
(9, 41, 500, 30, 38), (9, 42, 500, 24, 40), (9, 43, 500, 20, 30),
(9, 44, 500, 18, 35), (9, 45, 500, 15, 24), (9, 46, 500, 28, 38),
(9, 47, 500, 22, 40), (9, 48, 500, 15, 30), (9, 49, 500, 27, 45), (9, 50, 500, 20, 32),

-- StudentID 10
(10, 41, 500, 25, 39), (10, 42, 500, 18, 40), (10, 43, 500, 19, 32),
(10, 44, 500, 30, 43), (10, 45, 500, 24, 36), (10, 46, 500, 27, 38),
(10, 47, 500, 22, 40), (10, 48, 500, 28, 39), (10, 49, 500, 19, 34), (10, 50, 500, 20, 36);

-- Populate the GRADEBOOK table for StudentID 11 to 20
INSERT INTO GRADEBOOK (StudentID, CourseID, Level, CA, Exam)
VALUES
-- StudentID 11
(11, 51, 100, 25, 50), (11, 52, 100, 18, 40), (11, 53, 100, 22, 35), 
(11, 54, 100, 30, 45), (11, 55, 100, 20, 38), (11, 56, 100, 15, 42), 
(11, 57, 100, 28, 41), (11, 58, 100, 19, 39), (11, 59, 100, 24, 40), (11, 60, 100, 26, 43),

-- StudentID 12
(12, 51, 100, 20, 36), (12, 52, 100, 15, 32), (12, 53, 100, 25, 42), 
(12, 54, 100, 28, 35), (12, 55, 100, 19, 37), (12, 56, 100, 23, 40), 
(12, 57, 100, 30, 39), (12, 58, 100, 27, 36), (12, 59, 100, 22, 44), (12, 60, 100, 26, 45),

-- StudentID 13
(13, 61, 200, 18, 32), (13, 62, 200, 22, 36), (13, 63, 200, 24, 40), 
(13, 64, 200, 20, 38), (13, 65, 200, 15, 34), (13, 66, 200, 28, 42), 
(13, 67, 200, 30, 39), (13, 68, 200, 25, 36), (13, 69, 200, 19, 33), (13, 70, 200, 26, 45),

-- StudentID 14
(14, 61, 200, 22, 40), (14, 62, 200, 25, 38), (14, 63, 200, 27, 35), 
(14, 64, 200, 18, 32), (14, 65, 200, 30, 44), (14, 66, 200, 20, 36), 
(14, 67, 200, 24, 42), (14, 68, 200, 28, 40), (14, 69, 200, 15, 33), (14, 70, 200, 19, 39),

-- StudentID 15
(15, 71, 300, 30, 44), (15, 72, 300, 25, 40), (15, 73, 300, 20, 38), 
(15, 74, 300, 18, 32), (15, 75, 300, 10, 34), (15, 76, 300, 22, 36), 
(15, 77, 300, 19, 42), (15, 78, 300, 24, 39), (15, 79, 300, 28, 37), (15, 80, 300, 26, 45),

-- StudentID 16
(16, 71, 300, 27, 40), (16, 72, 300, 23, 38), (16, 73, 300, 19, 33), 
(16, 74, 300, 30, 44), (16, 75, 300, 20, 36), (16, 76, 300, 15, 35), 
(16, 77, 300, 18, 39), (16, 78, 300, 25, 40), (16, 79, 300, 28, 41), (16, 80, 300, 24, 34),

-- StudentID 17
(17, 81, 400, 28, 42), (17, 82, 400, 26, 44), (17, 83, 400, 20, 36), 
(17, 84, 400, 22, 40), (17, 85, 400, 24, 38), (17, 86, 400, 30, 35), 
(17, 87, 400, 19, 33), (17, 88, 400, 18, 39), (17, 89, 400, 15, 30), (17, 90, 400, 27, 41),

-- StudentID 18
(18, 81, 400, 25, 40), (18, 82, 400, 30, 45), (18, 83, 400, 22, 38), 
(18, 84, 400, 19, 33), (18, 85, 400, 27, 35), (18, 86, 400, 24, 39), 
(18, 87, 400, 15, 31), (18, 88, 400, 18, 37), (18, 89, 400, 23, 44), (18, 90, 400, 28, 43),

-- StudentID 19
(19, 91, 500, 20, 38), (19, 92, 500, 18, 32), (19, 93, 500, 24, 40), 
(19, 94, 500, 30, 45), (19, 95, 500, 27, 36), (19, 96, 500, 19, 31), 
(19, 97, 500, 22, 39), (19, 98, 500, 25, 35), (19, 99, 500, 28, 42), (19, 100, 500, 23, 44),

-- StudentID 20
(20, 91, 500, 28, 40), (20, 92, 500, 26, 43), (20, 93, 500, 20, 35), 
(20, 94, 500, 22, 38), (20, 95, 500, 30, 39), (20, 96, 500, 19, 32), 
(20, 97, 500, 24, 40), (20, 98, 500, 27, 45), (20, 99, 500, 18, 34), (20, 100, 500, 25, 38);

-- Populate the GRADEBOOK table for StudentID 21 to 30
INSERT INTO GRADEBOOK (StudentID, CourseID, Level, CA, Exam)
VALUES
-- StudentID 21
(21, 101, 100, 25, 45), (21, 102, 100, 20, 38), (21, 103, 100, 15, 32), 
(21, 104, 100, 18, 40), (21, 105, 100, 4, 36), (21, 106, 100, 28, 44), 
(21, 107, 100, 26, 39), (21, 108, 100, 19, 33), (21, 109, 100, 30, 43), (21, 110, 100, 22, 41),

-- StudentID 22
(22, 101, 100, 28, 39), (22, 102, 100, 26, 35), (22, 103, 100, 23, 40), 
(22, 104, 100, 18, 34), (22, 105, 100, 20, 36), (22, 106, 100, 25, 38), 
(22, 107, 100, 27, 42), (22, 108, 100, 30, 45), (22, 109, 100, 22, 37), (22, 110, 100, 19, 32),

-- StudentID 23
(23, 111, 200, 30, 43), (23, 112, 200, 28, 45), (23, 113, 200, 24, 39), 
(23, 114, 200, 22, 37), (23, 115, 200, 25, 38), (23, 116, 200, 20, 36), 
(23, 117, 200, 27, 42), (23, 118, 200, 19, 32), (23, 119, 200, 18, 34), (23, 120, 200, 26, 40),

-- StudentID 24
(24, 111, 200, 28, 40), (24, 112, 200, 30, 43), (24, 113, 200, 26, 39), 
(24, 114, 200, 24, 38), (24, 115, 200, 22, 34), (24, 116, 200, 27, 42), 
(24, 117, 200, 19, 35), (24, 118, 200, 18, 37), (24, 119, 200, 20, 40), (24, 120, 200, 25, 38),

-- StudentID 25
(25, 121, 300, 30, 46), (25, 122, 300, 28, 43), (25, 123, 300, 25, 40), 
(25, 124, 300, 24, 39), (25, 125, 300, 19, 34), (25, 126, 300, 22, 36), 
(25, 127, 300, 18, 38), (25, 128, 300, 26, 41), (25, 129, 300, 27, 42), (25, 130, 300, 20, 35),

-- StudentID 26
(26, 121, 300, 28, 42), (26, 122, 300, 30, 44), (26, 123, 300, 22, 36), 
(26, 124, 300, 24, 40), (26, 125, 300, 25, 39), (26, 126, 300, 19, 33), 
(26, 127, 300, 20, 35), (26, 128, 300, 27, 43), (26, 129, 300, 18, 37), (26, 130, 300, 26, 40),

-- StudentID 27
(27, 131, 400, 30, 44), (27, 132, 400, 28, 42), (27, 133, 400, 24, 39), 
(27, 134, 400, 22, 17), (27, 135, 400, 19, 35), (27, 136, 400, 26, 41), 
(27, 137, 400, 25, 38), (27, 138, 400, 18, 34), (27, 139, 400, 27, 43), (27, 140, 400, 20, 36),

-- StudentID 28
(28, 131, 400, 25, 37), (28, 132, 400, 19, 33), (28, 133, 400, 22, 39), 
(28, 134, 400, 26, 42), (28, 135, 400, 30, 45), (28, 136, 400, 27, 41), 
(28, 137, 400, 28, 43), (28, 138, 400, 24, 40), (28, 139, 400, 18, 35), (28, 140, 400, 20, 38),

-- StudentID 29
(29, 141, 500, 30, 47), (29, 142, 500, 28, 44), (29, 143, 500, 27, 41), 
(29, 144, 500, 22, 36), (29, 145, 500, 24, 40), (29, 146, 500, 18, 33), 
(29, 147, 500, 19, 34), (29, 148, 500, 25, 39), (29, 149, 500, 26, 42), (29, 150, 500, 20, 35),

-- StudentID 30
(30, 141, 500, 28, 42), (30, 142, 500, 30, 45), (30, 143, 500, 25, 39), 
(30, 144, 500, 27, 43), (30, 145, 500, 24, 40), (30, 146, 500, 18, 33), 
(30, 147, 500, 20, 36), (30, 148, 500, 26, 41), (30, 149, 500, 19, 34), (30, 150, 500, 22, 37);

-- Populate the GRADEBOOK table for StudentID 31 to 40
INSERT INTO GRADEBOOK (StudentID, CourseID, Level, CA, Exam)
VALUES
-- StudentID 31
(31, 151, 100, 26, 44), (31, 152, 100, 22, 38), (31, 153, 100, 24, 36), 
(31, 154, 100, 30, 43), (31, 155, 100, 18, 34), (31, 156, 100, 20, 39), 
(31, 157, 100, 28, 42), (31, 158, 100, 19, 33), (31, 159, 100, 25, 40), (31, 160, 100, 27, 45),

-- StudentID 32
(32, 151, 100, 29, 44), (32, 152, 100, 26, 41), (32, 153, 100, 24, 37), 
(32, 154, 100, 22, 15), (32, 155, 100, 18, 32), (32, 156, 100, 28, 42), 
(32, 157, 100, 20, 36), (32, 158, 100, 30, 46), (32, 159, 100, 25, 39), (32, 160, 100, 19, 33),

-- StudentID 33
(33, 161, 200, 30, 46), (33, 162, 200, 28, 44), (33, 163, 200, 26, 39), 
(33, 164, 200, 24, 37), (33, 165, 200, 22, 35), (33, 166, 200, 20, 32), 
(33, 167, 200, 18, 30), (33, 168, 200, 25, 38), (33, 169, 200, 27, 43), (33, 170, 200, 19, 33),

-- StudentID 34
(34, 161, 200, 29, 44), (34, 162, 200, 25, 39), (34, 163, 200, 22, 36), 
(34, 164, 200, 18, 34), (34, 165, 200, 30, 47), (34, 166, 200, 28, 42), 
(34, 167, 200, 19, 33), (34, 168, 200, 20, 36), (34, 169, 200, 24, 38), (34, 170, 200, 26, 40),

-- StudentID 35
(35, 171, 300, 30, 45), (35, 172, 300, 26, 41), (35, 173, 300, 24, 39), 
(35, 174, 300, 22, 37), (35, 175, 300, 20, 35), (35, 176, 300, 18, 34), 
(35, 177, 300, 28, 42), (35, 178, 300, 19, 33), (35, 179, 300, 27, 44), (35, 180, 300, 25, 40),

-- StudentID 36
(36, 171, 300, 29, 44), (36, 172, 300, 26, 41), (36, 173, 300, 24, 38), 
(36, 174, 300, 20, 35), (36, 175, 300, 22, 36), (36, 176, 300, 18, 34), 
(36, 177, 300, 30, 47), (36, 178, 300, 28, 42), (36, 179, 300, 19, 33), (36, 180, 300, 25, 39),

-- StudentID 37
(37, 181, 400, 30, 46), (37, 182, 400, 28, 43), (37, 183, 400, 26, 40), 
(37, 184, 400, 24, 39), (37, 185, 400, 20, 35), (37, 186, 400, 22, 36), 
(37, 187, 400, 8, 32), (37, 188, 400, 19, 33), (37, 189, 400, 25, 38), (37, 190, 400, 27, 44),

-- StudentID 38
(38, 181, 400, 28, 43), (38, 182, 400, 30, 47), (38, 183, 400, 25, 39), 
(38, 184, 400, 22, 36), (38, 185, 400, 20, 35), (38, 186, 400, 18, 32), 
(38, 187, 400, 19, 34), (38, 188, 400, 26, 41), (38, 189, 400, 24, 38), (38, 190, 400, 27, 42),

-- StudentID 39
(39, 191, 500, 30, 47), (39, 192, 500, 28, 43), (39, 193, 500, 26, 40), 
(39, 194, 500, 24, 39), (39, 195, 500, 20, 36), (39, 196, 500, 19, 35), 
(39, 197, 500, 22, 38), (39, 198, 500, 18, 32), (39, 199, 500, 27, 43), (39, 200, 500, 25, 41),

-- StudentID 40
(40, 191, 500, 30, 47), (40, 192, 500, 28, 44), (40, 193, 500, 25, 39), 
(40, 194, 500, 24, 38), (40, 195, 500, 22, 37), (40, 196, 500, 18, 33), 
(40, 197, 500, 20, 36), (40, 198, 500, 26, 42), (40, 199, 500, 19, 34), (40, 200, 500, 27, 43);

-- Populate the GRADEBOOK table for StudentID 41 to 50
INSERT INTO GRADEBOOK (StudentID, CourseID, Level, CA, Exam)
VALUES
-- StudentID 41
(41, 201, 100, 26, 44), (41, 202, 100, 22, 38), (41, 203, 100, 24, 36), 
(41, 204, 100, 30, 43), (41, 205, 100, 18, 34), (41, 206, 100, 20, 39), 
(41, 207, 100, 28, 42), (41, 208, 100, 19, 33), (41, 209, 100, 25, 40), (41, 210, 100, 27, 45),

-- StudentID 42
(42, 201, 100, 29, 44), (42, 202, 100, 26, 41), (42, 203, 100, 24, 37), 
(42, 204, 100, 22, 35), (42, 205, 100, 18, 32), (42, 206, 100, 28, 42), 
(42, 207, 100, 20, 36), (42, 208, 100, 30, 46), (42, 209, 100, 25, 39), (42, 210, 100, 19, 33),

-- StudentID 43
(43, 211, 200, 30, 46), (43, 212, 200, 28, 44), (43, 213, 200, 26, 39), 
(43, 214, 200, 24, 37), (43, 215, 200, 22, 35), (43, 216, 200, 20, 32), 
(43, 217, 200, 18, 30), (43, 218, 200, 25, 38), (43, 219, 200, 27, 43), (43, 220, 200, 19, 33),

-- StudentID 44
(44, 211, 200, 29, 44), (44, 212, 200, 25, 39), (44, 213, 200, 22, 36), 
(44, 214, 200, 18, 34), (44, 215, 200, 20, 23), (44, 216, 200, 28, 42), 
(44, 217, 200, 19, 33), (44, 218, 200, 20, 36), (44, 219, 200, 24, 38), (44, 220, 200, 26, 40),

-- StudentID 45
(45, 221, 300, 30, 45), (45, 222, 300, 26, 41), (45, 223, 300, 24, 39), 
(45, 224, 300, 22, 37), (45, 225, 300, 20, 35), (45, 226, 300, 18, 34), 
(45, 227, 300, 28, 42), (45, 228, 300, 19, 33), (45, 229, 300, 27, 44), (45, 230, 300, 25, 40),

-- StudentID 46
(46, 221, 300, 29, 44), (46, 222, 300, 26, 41), (46, 223, 300, 24, 38), 
(46, 224, 300, 20, 35), (46, 225, 300, 22, 36), (46, 226, 300, 18, 34), 
(46, 227, 300, 30, 47), (46, 228, 300, 28, 42), (46, 229, 300, 19, 33), (46, 230, 300, 25, 39),

-- StudentID 47
(47, 231, 400, 30, 46), (47, 232, 400, 28, 43), (47, 233, 400, 26, 40), 
(47, 234, 400, 24, 39), (47, 235, 400, 20, 35), (47, 236, 400, 22, 36), 
(47, 237, 400, 18, 32), (47, 238, 400, 19, 33), (47, 239, 400, 25, 38), (47, 240, 400, 27, 44),

-- StudentID 48
(48, 231, 400, 28, 43), (48, 232, 400, 30, 47), (48, 233, 400, 25, 39), 
(48, 234, 400, 22, 36), (48, 235, 400, 20, 35), (48, 236, 400, 18, 32), 
(48, 237, 400, 19, 34), (48, 238, 400, 26, 41), (48, 239, 400, 24, 38), (48, 240, 400, 27, 42),

-- StudentID 49
(49, 241, 500, 30, 47), (49, 242, 500, 28, 43), (49, 243, 500, 26, 40), 
(49, 244, 500, 24, 39), (49, 245, 500, 20, 36), (49, 246, 500, 19, 35), 
(49, 247, 500, 22, 38), (49, 248, 500, 18, 32), (49, 249, 500, 27, 43), (49, 250, 500, 25, 41),

-- StudentID 50
(50, 241, 500, 30, 47), (50, 242, 500, 28, 44), (50, 243, 500, 25, 39), 
(50, 244, 500, 24, 38), (50, 245, 500, 22, 37), (50, 246, 500, 18, 33), 
(50, 247, 500, 20, 36), (50, 248, 500, 26, 42), (50, 249, 500, 9, 34), (50, 250, 500, 27, 43);

-- Populate the GRADEBOOK table for StudentID 51 to 60
INSERT INTO GRADEBOOK (StudentID, CourseID, Level, CA, Exam)
VALUES
-- StudentID 51
(51, 251, 100, 25, 40), (51, 252, 100, 20, 38), (51, 253, 100, 18, 37), 
(51, 254, 100, 24, 36), (51, 255, 100, 30, 42), (51, 256, 100, 22, 33), 
(51, 257, 100, 19, 35), (51, 258, 100, 23, 39), (51, 259, 100, 21, 34), (51, 260, 100, 28, 41),

-- StudentID 52
(52, 251, 100, 26, 43), (52, 252, 100, 22, 39), (52, 253, 100, 20, 36), 
(52, 254, 100, 24, 37), (52, 255, 100, 28, 44), (52, 256, 100, 19, 32), 
(52, 257, 100, 18, 33), (52, 258, 100, 21, 38), (52, 259, 100, 25, 42), (52, 260, 100, 27, 40),

-- StudentID 53
(53, 251, 100, 28, 46), (53, 252, 100, 24, 40), (53, 253, 100, 21, 37), 
(53, 254, 100, 22, 38), (53, 255, 100, 26, 43), (53, 256, 100, 20, 34), 
(53, 257, 100, 19, 35), (53, 258, 100, 23, 39), (53, 259, 100, 25, 41), (53, 260, 100, 27, 42),

-- StudentID 54
(54, 261, 200, 25, 43), (54, 262, 200, 20, 38), (54, 263, 200, 18, 36), 
(54, 264, 200, 24, 37), (54, 265, 200, 30, 45), (54, 266, 200, 22, 34), 
(54, 267, 200, 19, 33), (54, 268, 200, 23, 40), (54, 269, 200, 21, 35), (54, 270, 200, 28, 42),

-- StudentID 55
(55, 261, 200, 26, 44), (55, 262, 200, 22, 40), (55, 263, 200, 20, 37), 
(55, 264, 200, 24, 38), (55, 265, 200, 28, 46), (55, 266, 200, 19, 35), 
(55, 267, 200, 18, 34), (55, 268, 200, 21, 41), (55, 269, 200, 25, 43), (55, 270, 200, 27, 39),

-- StudentID 56
(56, 261, 200, 28, 47), (56, 262, 200, 24, 41), (56, 263, 200, 21, 38), 
(56, 264, 200, 22, 39), (56, 265, 200, 26, 45), (56, 266, 200, 20, 36), 
(56, 267, 200, 19, 37), (56, 268, 200, 23, 42), (56, 269, 200, 25, 44), (56, 270, 200, 27, 40),

-- StudentID 57
(57, 271, 300, 25, 40), (57, 272, 300, 20, 38), (57, 273, 300, 18, 37), 
(57, 274, 300, 24, 36), (57, 275, 300, 30, 42), (57, 276, 300, 22, 33), 
(57, 277, 300, 19, 35), (57, 278, 300, 23, 39), (57, 279, 300, 21, 34), (57, 280, 300, 28, 41),

-- StudentID 58
(58, 271, 300, 26, 43), (58, 272, 300, 22, 39), (58, 273, 300, 20, 36), 
(58, 274, 300, 24, 37), (58, 275, 300, 28, 44), (58, 276, 300, 19, 32), 
(58, 277, 300, 18, 33), (58, 278, 300, 21, 38), (58, 279, 300, 25, 42), (58, 280, 300, 27, 40),

-- StudentID 59
(59, 281, 400, 28, 46), (59, 282, 400, 24, 40), (59, 283, 400, 21, 37), 
(59, 284, 400, 22, 38), (59, 285, 400, 26, 43), (59, 286, 400, 20, 34), 
(59, 287, 400, 19, 35), (59, 288, 400, 23, 39), (59, 289, 400, 25, 41), (59, 290, 400, 27, 42),

-- StudentID 60
(60, 281, 400, 30, 47), (60, 282, 400, 28, 44), (60, 283, 400, 26, 42), 
(60, 284, 400, 24, 39), (60, 285, 400, 20, 36), (60, 286, 400, 18, 33), 
(60, 287, 400, 22, 37), (60, 288, 400, 19, 34), (60, 289, 400, 25, 40), (60, 290, 400, 27, 43);

-- Populate the GRADEBOOK table for StudentID 61 to 70
INSERT INTO GRADEBOOK (StudentID, CourseID, Level, CA, Exam)
VALUES
-- StudentID 61
(61, 300, 100, 25, 40), (61, 301, 100, 20, 38), (61, 302, 100, 18, 37), 
(61, 303, 100, 24, 36), (61, 304, 100, 30, 42), (61, 305, 100, 22, 33), 
(61, 306, 100, 19, 35), (61, 307, 100, 23, 39), (61, 308, 100, 21, 34), (61, 309, 100, 28, 41),

-- StudentID 62
(62, 300, 100, 26, 43), (62, 301, 100, 22, 39), (62, 302, 100, 20, 36), 
(62, 303, 100, 24, 37), (62, 304, 100, 28, 44), (62, 305, 100, 19, 32), 
(62, 306, 100, 18, 33), (62, 307, 100, 21, 38), (62, 308, 100, 25, 42), (62, 309, 100, 27, 40),

-- StudentID 63
(63, 300, 100, 28, 46), (63, 301, 100, 24, 40), (63, 302, 100, 11, 17), 
(63, 303, 100, 22, 38), (63, 304, 100, 26, 43), (63, 305, 100, 20, 34), 
(63, 306, 100, 19, 35), (63, 307, 100, 23, 39), (63, 308, 100, 25, 41), (63, 309, 100, 27, 42),

-- StudentID 64
(64, 311, 200, 25, 43), (64, 312, 200, 20, 38), (64, 313, 200, 18, 36), 
(64, 314, 200, 24, 37), (64, 315, 200, 30, 45), (64, 316, 200, 22, 34), 
(64, 317, 200, 19, 33), (64, 318, 200, 23, 40), (64, 319, 200, 21, 35), (64, 320, 200, 28, 42),

-- StudentID 65
(65, 311, 200, 26, 44), (65, 312, 200, 22, 40), (65, 313, 200, 20, 37), 
(65, 314, 200, 24, 38), (65, 315, 200, 28, 46), (65, 316, 200, 19, 35), 
(65, 317, 200, 18, 34), (65, 318, 200, 21, 41), (65, 319, 200, 25, 43), (65, 320, 200, 27, 39),

-- StudentID 66
(66, 311, 200, 28, 47), (66, 312, 200, 24, 41), (66, 313, 200, 21, 38), 
(66, 314, 200, 22, 39), (66, 315, 200, 26, 45), (66, 316, 200, 20, 36), 
(66, 317, 200, 19, 37), (66, 318, 200, 23, 42), (66, 319, 200, 25, 44), (66, 320, 200, 27, 40),

-- StudentID 67
(67, 321, 300, 25, 40), (67, 322, 300, 20, 38), (67, 323, 300, 18, 37), 
(67, 324, 300, 24, 36), (67, 325, 300, 30, 42), (67, 326, 300, 22, 33), 
(67, 327, 300, 19, 35), (67, 328, 300, 23, 39), (67, 329, 300, 21, 34), (67, 330, 300, 28, 41),

-- StudentID 68
(68, 321, 300, 26, 43), (68, 322, 300, 22, 39), (68, 323, 300, 20, 36), 
(68, 324, 300, 24, 37), (68, 325, 300, 28, 44), (68, 326, 300, 19, 32), 
(68, 327, 300, 18, 33), (68, 328, 300, 21, 38), (68, 329, 300, 25, 42), (68, 330, 300, 27, 40),

-- StudentID 69
(69, 331, 400, 28, 46), (69, 332, 400, 24, 40), (69, 333, 400, 21, 37), 
(69, 334, 400, 22, 38), (69, 335, 400, 26, 43), (69, 336, 400, 20, 34), 
(69, 337, 400, 19, 35), (69, 338, 400, 23, 39), (69, 339, 400, 25, 41), (69, 340, 400, 27, 12),

-- StudentID 70
(70, 331, 400, 30, 47), (70, 332, 400, 28, 44), (70, 333, 400, 26, 42), 
(70, 334, 400, 24, 39), (70, 335, 400, 20, 36), (70, 336, 400, 18, 33), 
(70, 337, 400, 22, 37), (70, 338, 400, 19, 34), (70, 339, 400, 25, 40), (70, 340, 400, 27, 43);

-- Populate the GRADEBOOK table for StudentID 71 to 80
INSERT INTO GRADEBOOK (StudentID, CourseID, Level, CA, Exam)
VALUES
-- StudentID 71
(71, 341, 100, 25, 40), (71, 342, 100, 20, 38), (71, 343, 100, 18, 37), 
(71, 344, 100, 24, 36), (71, 345, 100, 30, 42), (71, 346, 100, 22, 33), 
(71, 347, 100, 19, 35), (71, 348, 100, 23, 39), (71, 349, 100, 21, 34), (71, 350, 100, 28, 41),

-- StudentID 72
(72, 341, 100, 26, 43), (72, 342, 100, 22, 39), (72, 343, 100, 20, 36), 
(72, 344, 100, 24, 37), (72, 345, 100, 28, 44), (72, 346, 100, 19, 32), 
(72, 347, 100, 18, 33), (72, 348, 100, 21, 38), (72, 349, 100, 25, 42), (72, 350, 100, 27, 40),

-- StudentID 73
(73, 341, 100, 28, 46), (73, 342, 100, 24, 40), (73, 343, 100, 21, 37), 
(73, 344, 100, 22, 38), (73, 345, 100, 26, 43), (73, 346, 100, 20, 34), 
(73, 347, 100, 19, 35), (73, 348, 100, 23, 39), (73, 349, 100, 25, 41), (73, 350, 100, 27, 42),

-- StudentID 74
(74, 351, 200, 25, 43), (74, 352, 200, 20, 38), (74, 353, 200, 18, 36), 
(74, 354, 200, 24, 37), (74, 355, 200, 30, 45), (74, 356, 200, 22, 34), 
(74, 357, 200, 19, 33), (74, 358, 200, 23, 40), (74, 359, 200, 21, 35), (74, 360, 200, 28, 42),

-- StudentID 75
(75, 351, 200, 26, 44), (75, 352, 200, 22, 40), (75, 353, 200, 20, 37), 
(75, 354, 200, 24, 38), (75, 355, 200, 28, 46), (75, 356, 200, 19, 35), 
(75, 357, 200, 18, 34), (75, 358, 200, 21, 41), (75, 359, 200, 25, 43), (75, 360, 200, 27, 39),

-- StudentID 76
(76, 351, 200, 28, 47), (76, 352, 200, 24, 41), (76, 353, 200, 21, 38), 
(76, 354, 200, 22, 39), (76, 355, 200, 26, 45), (76, 356, 200, 20, 16), 
(76, 357, 200, 19, 37), (76, 358, 200, 23, 42), (76, 359, 200, 25, 44), (76, 360, 200, 27, 40),

-- StudentID 77
(77, 361, 300, 25, 40), (77, 362, 300, 20, 38), (77, 363, 300, 18, 37), 
(77, 364, 300, 24, 36), (77, 365, 300, 30, 42), (77, 366, 300, 22, 33), 
(77, 367, 300, 19, 35), (77, 368, 300, 23, 39), (77, 369, 300, 21, 34), (77, 370, 300, 28, 41),

-- StudentID 78
(78, 361, 300, 26, 43), (78, 362, 300, 22, 39), (78, 363, 300, 20, 36), 
(78, 364, 300, 24, 37), (78, 365, 300, 28, 44), (78, 366, 300, 19, 32), 
(78, 367, 300, 18, 33), (78, 368, 300, 21, 38), (78, 369, 300, 25, 42), (78, 370, 300, 27, 40),

-- StudentID 79
(79, 371, 400, 28, 46), (79, 372, 400, 24, 40), (79, 373, 400, 21, 37), 
(79, 374, 400, 22, 38), (79, 375, 400, 26, 43), (79, 376, 400, 20, 34), 
(79, 377, 400, 19, 35), (79, 378, 400, 23, 39), (79, 379, 400, 25, 41), (79, 380, 400, 27, 42),

-- StudentID 80
(80, 371, 400, 30, 47), (80, 372, 400, 28, 44), (80, 373, 400, 26, 42), 
(80, 374, 400, 24, 39), (80, 375, 400, 20, 36), (80, 376, 400, 18, 33), 
(80, 377, 400, 22, 37), (80, 378, 400, 19, 34), (80, 379, 400, 25, 40), (80, 380, 400, 27, 43);

-- Populate the GRADEBOOK table for StudentID 81 to 90
INSERT INTO GRADEBOOK (StudentID, CourseID, Level, CA, Exam)
VALUES
-- StudentID 81
(81, 381, 100, 25, 40), (81, 382, 100, 20, 38), (81, 383, 100, 18, 37), 
(81, 384, 100, 24, 36), (81, 385, 100, 30, 42), (81, 386, 100, 22, 33), 
(81, 387, 100, 19, 35), (81, 388, 100, 23, 39), (81, 389, 100, 21, 34), (81, 390, 100, 28, 41),

-- StudentID 82
(82, 381, 100, 26, 13), (82, 382, 100, 22, 39), (82, 383, 100, 20, 36), 
(82, 384, 100, 24, 37), (82, 385, 100, 28, 44), (82, 386, 100, 19, 32), 
(82, 387, 100, 18, 33), (82, 388, 100, 21, 38), (82, 389, 100, 25, 42), (82, 390, 100, 27, 40),

-- StudentID 83
(83, 381, 100, 28, 46), (83, 382, 100, 24, 40), (83, 383, 100, 21, 37), 
(83, 384, 100, 22, 38), (83, 385, 100, 26, 43), (83, 386, 100, 20, 34), 
(83, 387, 100, 19, 35), (83, 388, 100, 23, 39), (83, 389, 100, 25, 41), (83, 390, 100, 27, 42),

-- StudentID 84
(84, 391, 200, 25, 43), (84, 392, 200, 20, 38), (84, 393, 200, 18, 36), 
(84, 394, 200, 24, 37), (84, 395, 200, 30, 45), (84, 396, 200, 22, 34), 
(84, 397, 200, 19, 33), (84, 398, 200, 23, 40), (84, 399, 200, 21, 35), (84, 400, 200, 28, 42),

-- StudentID 85
(85, 391, 200, 26, 44), (85, 392, 200, 22, 40), (85, 393, 200, 20, 37), 
(85, 394, 200, 24, 38), (85, 395, 200, 28, 46), (85, 396, 200, 19, 35), 
(85, 397, 200, 18, 34), (85, 398, 200, 21, 41), (85, 399, 200, 25, 43), (85, 400, 200, 27, 39),

-- StudentID 86
(86, 391, 200, 28, 47), (86, 392, 200, 24, 41), (86, 393, 200, 21, 38), 
(86, 394, 200, 22, 39), (86, 395, 200, 26, 45), (86, 396, 200, 20, 36), 
(86, 397, 200, 19, 37), (86, 398, 200, 23, 42), (86, 399, 200, 25, 44), (86, 400, 200, 27, 40),

-- StudentID 87
(87, 401, 300, 25, 40), (87, 402, 300, 20, 38), (87, 403, 300, 18, 37), 
(87, 404, 300, 24, 36), (87, 405, 300, 30, 42), (87, 406, 300, 22, 33), 
(87, 407, 300, 19, 35), (87, 408, 300, 23, 39), (87, 409, 300, 21, 34), (87, 410, 300, 28, 41),

-- StudentID 88
(88, 401, 300, 26, 43), (88, 402, 300, 22, 39), (88, 403, 300, 20, 36), 
(88, 404, 300, 24, 37), (88, 405, 300, 28, 44), (88, 406, 300, 19, 32), 
(88, 407, 300, 18, 33), (88, 408, 300, 21, 38), (88, 409, 300, 25, 42), (88, 410, 300, 27, 40),

-- StudentID 89
(89, 411, 400, 28, 46), (89, 412, 400, 24, 40), (89, 413, 400, 21, 37), 
(89, 414, 400, 22, 38), (89, 415, 400, 26, 43), (89, 416, 400, 20, 34), 
(89, 417, 400, 19, 35), (89, 418, 400, 23, 39), (89, 419, 400, 25, 41), (89, 420, 400, 27, 42),

-- StudentID 90
(90, 411, 400, 30, 47), (90, 412, 400, 28, 44), (90, 413, 400, 26, 42), 
(90, 414, 400, 24, 39), (90, 415, 400, 20, 36), (90, 416, 400, 18, 33), 
(90, 417, 400, 22, 37), (90, 418, 400, 19, 34), (90, 419, 400, 25, 40), (90, 420, 400, 27, 43);

-- Populate the GRADEBOOK table for StudentID 91 to 100
INSERT INTO GRADEBOOK (StudentID, CourseID, Level, CA, Exam)
VALUES
-- StudentID 91
(91, 421, 100, 20, 35), (91, 422, 100, 15, 40), (91, 423, 100, 18, 38), 
(91, 424, 100, 22, 37), (91, 425, 100, 25, 41), (91, 426, 100, 19, 34), 
(91, 427, 100, 21, 39), (91, 428, 100, 23, 36), (91, 429, 100, 17, 32), (91, 430, 100, 24, 42),

-- StudentID 92
(92, 421, 100, 18, 39), (92, 422, 100, 22, 40), (92, 423, 100, 21, 35), 
(92, 424, 100, 19, 36), (92, 425, 100, 24, 43), (92, 426, 100, 25, 41), 
(92, 427, 100, 20, 18), (92, 428, 100, 23, 37), (92, 429, 100, 17, 33), (92, 430, 100, 15, 34),

-- StudentID 93
(93, 421, 100, 24, 44), (93, 422, 100, 21, 37), (93, 423, 100, 22, 39), 
(93, 424, 100, 20, 36), (93, 425, 100, 18, 35), (93, 426, 100, 25, 42), 
(93, 427, 100, 23, 38), (93, 428, 100, 19, 33), (93, 429, 100, 17, 40), (93, 430, 100, 16, 31),

-- StudentID 94
(94, 431, 200, 20, 38), (94, 432, 200, 24, 43), (94, 433, 200, 19, 34), 
(94, 434, 200, 23, 39), (94, 435, 200, 18, 37), (94, 436, 200, 22, 36), 
(94, 437, 200, 25, 41), (94, 438, 200, 21, 35), (94, 439, 200, 17, 32), (94, 440, 200, 16, 30),

-- StudentID 95
(95, 431, 200, 19, 34), (95, 432, 200, 21, 37), (95, 433, 200, 22, 40), 
(95, 434, 200, 20, 38), (95, 435, 200, 23, 42), (95, 436, 200, 24, 43), 
(95, 437, 200, 18, 36), (95, 438, 200, 25, 44), (95, 439, 200, 17, 31), (95, 440, 200, 16, 29),

-- StudentID 96
(96, 431, 200, 24, 41), (96, 432, 200, 25, 43), (96, 433, 200, 20, 36), 
(96, 434, 200, 18, 33), (96, 435, 200, 22, 39), (96, 436, 200, 23, 40), 
(96, 437, 200, 19, 35), (96, 438, 200, 21, 37), (96, 439, 200, 17, 31), (96, 440, 200, 16, 30),

-- StudentID 97
(97, 441, 300, 24, 42), (97, 442, 300, 25, 44), (97, 443, 300, 20, 38), 
(97, 444, 300, 18, 36), (97, 445, 300, 22, 40), (97, 446, 300, 19, 35), 
(97, 447, 300, 21, 37), (97, 448, 300, 23, 41), (97, 449, 300, 17, 33), (97, 450, 300, 16, 32),

-- StudentID 98
(98, 441, 300, 25, 44), (98, 442, 300, 20, 36), (98, 443, 300, 18, 35), 
(98, 444, 300, 24, 43), (98, 445, 300, 22, 39), (98, 446, 300, 19, 34), 
(98, 447, 300, 21, 38), (98, 448, 300, 23, 40), (98, 449, 300, 17, 32), (98, 450, 300, 16, 30),

-- StudentID 99
(99, 451, 400, 24, 44), (99, 452, 400, 22, 40), (99, 453, 400, 25, 42), 
(99, 454, 400, 20, 38), (99, 455, 400, 18, 37), (99, 456, 400, 23, 39), 
(99, 457, 400, 21, 36), (99, 458, 400, 19, 33), (99, 459, 400, 16, 19), (99, 460, 400, 17, 30),

-- StudentID 100
(100, 451, 400, 25, 42), (100, 452, 400, 24, 43), (100, 453, 400, 22, 40), 
(100, 454, 400, 20, 36), (100, 455, 400, 18, 35), (100, 456, 400, 23, 41), 
(100, 457, 400, 21, 37), (100, 458, 400, 19, 34), (100, 459, 400, 16, 30), (100, 460, 400, 17, 32);


SELECT * FROM GRADEBOOK WHERE Grade = 'F'

-- Debugging
SELECT 
CONCAT(S.LastName, ' ', S.LastName) AS 'Student Name',
S.ID AS StudentID,
S.Level AS Level,
D.ID AS DeptID,
D.Name AS Department,
C.ID AS CourseID,
C.Name AS Course
FROM STUDENT_COURSE SC
INNER JOIN STUDENTS S ON SC.StudentID = S.ID
INNER JOIN DEPARTMENT D ON D.ID = S.DepartmentID
INNER JOIN COURSES C ON C.ID = SC.CourseID
WHERE D.ID = 6

-- Debugging
SELECT  
C.ID AS CourseID,
C.Code AS 'Course Code',
C.Name AS Course,
D.ID AS DeptID,
D.Name AS Department
FROM COURSES C INNER JOIN DEPARTMENT D ON D.ID = C.DepartmentID
WHERE D.ID = 6

SELECT * FROM GRADEBOOK ORDER BY ID DESC

SELECT 
GB.StudentID AS 'StudentID',
CONCAT(S.LastName, ' ', S.LastName) AS 'Student Name',
C.ID AS CourseID,
S.Level AS 'Level',
GB.CA AS CA,
GB.Exam AS Exam,
GB.MarksObtained AS 'Total Score',
GB.Grade AS Grade,
C.Code AS 'Course Code',
C.Name AS 'Course',
D.ID AS DeptID,
D.Name AS Department
FROM GRADEBOOK GB
INNER JOIN STUDENTS S ON S.ID = GB.StudentID
INNER JOIN COURSES C ON C.ID = GB.CourseID
INNER JOIN DEPARTMENT D ON D.ID = S.DepartmentID
WHERE Grade = 'F'
--WHERE Exam < 30