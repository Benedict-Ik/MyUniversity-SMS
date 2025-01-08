-- Display all students that failed a course
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


-- Display all courses alongide the departments they are offered in
SELECT  
C.ID AS CourseID,
C.Code AS 'Course Code',
C.Name AS Course,
D.ID AS DeptID,
D.Name AS Department
FROM COURSES C INNER JOIN DEPARTMENT D ON D.ID = C.DepartmentID


-- BEGIN
-- 1.	Determine the lecturer taking what course
SELECT 
CONCAT(L.FirstName, ' ', L.LastName) AS 'Lecturer Name',
C.Code AS 'Course Code',
C.Name AS Course
FROM Lecturer_Course LC
INNER JOIN LECTURERS L ON L.ID = LC.LecturerID
INNER JOIN COURSES C ON C.ID = LC.CourseID


-- 2.	Display all students, with their IDs, names, levels, department and courses offered.
SELECT 
S.ID AS 'StudentID',
CONCAT(S.LastName, ' ' , S.OtherNames) AS 'Student Name',
S.LEVEL AS Level,
C.Code AS 'Course Code',
C.Name AS Course,
D.Name AS Department

FROM STUDENT_COURSE SC
INNER JOIN STUDENTS S ON  S.ID = SC.StudentID
INNER JOIN COURSES C ON C.ID = SC.CourseID
INNER JOIN DEPARTMENT D ON D.ID = S.DepartmentID


--3.	List students grouped by gender and department.
SELECT
D.Name AS Department,
S.Gender AS Gender,
COUNT(S.ID) AS 'Total Count'
FROM STUDENTS S 
INNER JOIN DEPARTMENT D ON D.ID = S.DepartmentID
GROUP BY S.Gender, D.Name


-- 4.	List all students who belong to a specific level across all departments.
SELECT 
S.ID AS 'StudentID',
CONCAT(S.LastName, ' ' , S.OtherNames) AS 'Student Name',
S.Level AS Level,
D.Name AS Department
FROM STUDENTS S
INNER JOIN DEPARTMENT D ON D.ID = S.DepartmentID
WHERE S.Level = 300


-- 5.	Retrieve all courses a student is enrolled in for a specific session and semester.
SELECT
CONCAT(S.LastName, ' ' , S.OtherNames) AS 'Student Name',
C.Name AS Course,
SESSION.Name,
SEMESTER.Name,
D.Name AS Department

FROM STUDENT_COURSE SC
INNER JOIN STUDENTS S ON S.ID = SC.StudentID
INNER JOIN COURSES C ON C.ID = SC.CourseID
INNER JOIN DEPARTMENT D ON D.ID = S.DepartmentID
INNER JOIN SESSION_SEMESTER SS ON SS.SemesterID = SC.SemesterID AND SS.SessionID = SC.SessionID
INNER JOIN SESSION ON SESSION.ID = SS.SessionID
INNER JOIN SEMESTER ON SEMESTER.ID = SS.SemesterID
WHERE SESSION.Name = '2024/2025'
AND SEMESTER.Name = 'First Semester'
AND S.ID = 4


--6.	Display the grades gotten for all students for each specific course within a department with their breakdown (CA & Exam Scores).
SELECT 
CONCAT(S.LastName, ' ', S.LastName) AS 'Student Name',
C.ID AS CourseID,
GB.CA AS CA,
GB.Exam AS Exam,
GB.MarksObtained AS 'Total Score',
GB.Grade AS Grade,
C.Code AS 'Course Code',
C.Name AS 'Course',
D.Name AS Department
FROM GRADEBOOK GB
INNER JOIN STUDENTS S ON S.ID = GB.StudentID
INNER JOIN COURSES C ON C.ID = GB.CourseID
INNER JOIN DEPARTMENT D ON D.ID = S.DepartmentID
WHERE C.Code = 'CHE-111'


-- 7.	List all students who scored an "A" in a specific course.
SELECT 
CONCAT(S.LastName, ' ', S.LastName) AS 'Student Name',
GB.MarksObtained AS 'Total Score',
GB.Grade AS Grade,
C.Code AS 'Course Code',
C.Name AS 'Course',
D.Name AS Department
FROM GRADEBOOK GB
INNER JOIN STUDENTS S ON S.ID = GB.StudentID
INNER JOIN COURSES C ON C.ID = GB.CourseID
INNER JOIN DEPARTMENT D ON D.ID = S.DepartmentID
WHERE Grade = 'A'


--8.	Identify students who failed a course (grade "F") in a specific session and semester.
SELECT
CONCAT(S.LastName, ' ' , S.OtherNames) AS 'Student Name',
C.Code AS 'Course Code',
C.Name AS Course,
GB.MarksObtained AS 'Total Score',
GB.Grade AS Grade,
SESSION.Name,
SEMESTER.Name,
D.Name AS Department

FROM STUDENT_COURSE SC
INNER JOIN STUDENTS S ON S.ID = SC.StudentID
INNER JOIN COURSES C ON C.ID = SC.CourseID
INNER JOIN GRADEBOOK GB ON GB.StudentID = S.ID
INNER JOIN DEPARTMENT D ON D.ID = S.DepartmentID
INNER JOIN SESSION_SEMESTER SS ON SS.SemesterID = SC.SemesterID AND SS.SessionID = SC.SessionID
INNER JOIN SESSION ON SESSION.ID = SS.SessionID
INNER JOIN SEMESTER ON SEMESTER.ID = SS.SemesterID
WHERE SESSION.Name = '2024/2025'
AND SEMESTER.Name = 'First Semester'
AND  GB.Grade = 'F'


--9.	Identify the top 10 performing students in a specific session and semester.
SELECT TOP 10
CONCAT(S.LastName, ' ' , S.OtherNames) AS 'Student Name',
C.Code AS 'Course Code',
C.Name AS Course,
GB.MarksObtained AS 'Total Score',
GB.Grade AS Grade,
SESSION.Name,
SEMESTER.Name,
D.Name AS Department

FROM STUDENT_COURSE SC
INNER JOIN STUDENTS S ON S.ID = SC.StudentID
INNER JOIN COURSES C ON C.ID = SC.CourseID
INNER JOIN GRADEBOOK GB ON GB.StudentID = S.ID
INNER JOIN DEPARTMENT D ON D.ID = S.DepartmentID
INNER JOIN SESSION_SEMESTER SS ON SS.SemesterID = SC.SemesterID AND SS.SessionID = SC.SessionID
INNER JOIN SESSION ON SESSION.ID = SS.SessionID
INNER JOIN SEMESTER ON SEMESTER.ID = SS.SemesterID
WHERE SESSION.Name = '2024/2025' AND SEMESTER.Name = 'First Semester'
ORDER BY [Total Score] DESC


--10.	Generate a summary of grades (A-F) gotten by students for all courses in a specific session and semester.
SELECT 
    C.Code AS CourseCode,
    C.Name AS CourseName,
    G.Grade,
    COUNT(G.Grade) AS GradeCount
FROM 
    GRADEBOOK G
INNER JOIN 
    COURSES C ON G.CourseID = C.ID
INNER JOIN 
    STUDENT_COURSE SC ON G.StudentID = SC.StudentID AND G.CourseID = SC.CourseID
INNER JOIN 
    SESSION_SEMESTER SS ON SC.SessionID = SS.SessionID AND SC.SemesterID = SS.SemesterID
INNER JOIN 
    SESSION S ON SS.SessionID = S.ID
INNER JOIN 
    SEMESTER SEM ON SS.SemesterID = SEM.ID
WHERE 
    S.Name = '2024/2025'
    AND SEM.Name = 'Second Semester'

GROUP BY 
    C.Code, C.Name, G.Grade
ORDER BY 
    C.Code, G.Grade;


--11.	List students who scored above 75 in any course.
SELECT 
CONCAT(S.LastName, ' ' , S.OtherNames) AS 'Student Name',
C.Code AS 'Course Code',
C.Name AS CourseID,
GB.MarksObtained AS Score

FROM GRADEBOOK GB
INNER JOIN STUDENTS S ON GB.StudentID = S.ID
INNER JOIN COURSES C ON GB.CourseID = C.ID
WHERE GB.MarksObtained > 75


--12.	Create a summary report showing the average CA, exam, and total marks for all courses.
SELECT 
    C.Code AS CourseCode,
    C.Name AS CourseName,
    AVG(GB.CA) AS AverageCA,
    AVG(GB.Exam) AS AverageExam,
    AVG(GB.MarksObtained) AS AverageTotalMarks
FROM 
    GRADEBOOK GB
INNER JOIN 
    COURSES C ON GB.CourseID = C.ID
GROUP BY 
    C.Code, C.Name;


--13.	Retrieve all students profile without a matric number
SELECT 
    S.ID AS StudentID,
    S.TempID,
    S.MatricNumber,
    CONCAT(S.LastName, ' ', S.OtherNames) AS FullName,
    S.Gender,
    S.DateOfBirth,
    S.DateOfEntry,
    S.Phone,
    S.Address,
    S.Email,
    D.Name AS DepartmentName,
    L.Title AS Level
FROM 
    STUDENTS S
INNER JOIN 
    DEPARTMENT D ON S.DepartmentID = D.ID
INNER JOIN 
    LEVEL L ON S.Level = L.Code
WHERE 
    S.MatricNumber IS NULL



-- 14.	List all students in a specific department.
SELECT 
CONCAT(S.LastName, ' ', S.OtherNames) AS FullName,
D.Name AS Department

FROM STUDENTS S
INNER JOIN DEPARTMENT D ON S.DepartmentID = D.ID
WHERE D.Name = 'Physics'


-- 