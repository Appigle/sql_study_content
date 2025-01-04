-- subquery.sql

USE SIS;

-- Example 1
SELECT * 
FROM StudentOffence;

SELECT studentNumber 
FROM StudentOffence 
WHERE penaltyCode = 'A';

SELECT studentNumber, finalMark
FROM CourseStudent;

-- Course grades for students with Type “A” academic offences

-- (a) Using a join
SELECT cs.studentNumber, cs.finalMark
FROM CourseStudent cs, StudentOffence so
WHERE cs.studentNumber = so.studentNumber
	AND so.penaltyCode = 'A';

-- (b) using a subquery
SELECT studentNumber, finalMark
FROM CourseStudent
WHERE studentNumber =
  (SELECT studentNumber 
   FROM StudentOffence 
   WHERE penaltyCode = 'A');

-- Example 2
SELECT studentNumber, finalMark
FROM CourseStudent
WHERE studentNumber <>
  (SELECT studentNumber 
   FROM StudentOffence 
   WHERE penaltyCode = 'A');

-- Example 3: run-time error since the subquery returns more than 1 value
SELECT studentNumber, finalMark
FROM CourseStudent
WHERE studentNumber = 
  (SELECT number
   FROM Student
   WHERE balance < 0);

-- Example 4a: IN
SELECT studentNumber, finalMark
FROM CourseStudent
WHERE studentNumber IN
  (SELECT number 
   FROM Student 
   WHERE balance < 0);

-- Example 4b: NOT IN
SELECT studentNumber, finalMark
FROM CourseStudent
WHERE studentNumber NOT IN
	(SELECT number 
	 FROM Student 
	 WHERE balance < 0);

-- Example 5
SELECT lastName, firstName
FROM Person
WHERE number IN
	(SELECT number 
     FROM Employee 
     WHERE schoolCode = 'BUS');

-- Example 6
-- 6a
SELECT lastName, firstName
FROM Person
WHERE number = ANY 
	(SELECT number 
	 FROM Employee 
	 WHERE schoolCode = 'BUS');

-- 6b
SELECT lastName, firstName
FROM Person
WHERE number = SOME 
	(SELECT number 
	 FROM Employee 
	 WHERE schoolCode = 'BUS');

-- Example 7
SELECT lastName, firstName
FROM Person p
WHERE EXISTS
   (SELECT * 
    FROM Employee e 
    WHERE p.number = e.number
		AND schoolCode = 'BUS');

-- EXISTS: 7 rows
SELECT lastname, firstname
FROM Person p
WHERE EXISTS
   (SELECT * 
    FROM Employee e
    WHERE location = '4A17' AND p.number = e.number);

-- NOT EXISTS: 427 rows
SELECT lastname, firstname
FROM Person p
WHERE NOT EXISTS
   (SELECT * 
    FROM Employee e
    WHERE location = '4A17' AND p.number = e.number);

-- Example 8
SELECT studentNumber, finalMark
FROM CourseStudent
WHERE studentNumber =
	(SELECT TOP 1 number 
	 FROM Student 
	 ORDER BY balance DESC);

-- Example 9a: Subquery in SELECT list (1:1)
SELECT e.number, e.schoolCode
	, (SELECT p.firstName+' '+p.lastName 
	   FROM Person p 
	   WHERE p.number=e.number) AS EmployeeName 
FROM Employee e 
WHERE e.location = '4A17';


-- Example 9b: Subquery in SELECT list (1:M)
-- In a one-to-many relationship (e.g., Person to Payment)
-- Start with the Person table will fail because subquery returns multiple values
SELECT p.FirstName
	, p.LastName
	, (SELECT amount 
	   FROM Payment
	   WHERE studentNumber = p.Number)
FROM Person p
WHERE p.number IN 
  (SELECT studentNumber
   FROM Payment
   WHERE amount > 1000);

-- Example 9c: Start with the Payment table works (subquery returns one person per payment)
SELECT 
	(SELECT firstName
     FROM Person
     WHERE number = pay.studentNumber)
   ,(SELECT lastName
	 FROM Person
     WHERE number = pay.studentNumber)
   , pay.amount
FROM Payment pay
WHERE pay.amount > 1000;

-- Example 9d: Complex example (1:M,M:1)
-- Find all software in labs starting with LabSoftware
SELECT 
    (SELECT product 
     FROM Software
     WHERE uniqueId = ls.softwareUniqueId)
   ,(SELECT number 
     FROM Room
     WHERE id = ls.roomId)
FROM LabSoftware ls
WHERE ls.roomId IN 
	(SELECT id 
	 FROM Room
     WHERE campusCode = 'D' and isLab = 1);


-- Practice: Find courses in the CPA program

-- Using Implicit JOIN: 30 rows
SELECT Campus.name AS Campus, Course.name AS Course, PC.semester AS Semester
FROM Program, Course, ProgramCourse PC, Campus
WHERE PC.programCode = program.code 
	AND PC.courseNumber = course.number
	AND Campus.code = Program.campusCode
	AND acronym = 'CPA'
ORDER BY semester;

-- Using Subquery: 30 rows
SELECT 
   (SELECT name 
    FROM campus 
	WHERE code = 
	   (SELECT campusCode 
		FROM program 
		WHERE code = programCode)) AS Campus
  ,(SELECT name 
	FROM course 
	WHERE number = courseNumber) AS Course
  , semester as Semester
FROM ProgramCourse
WHERE programCode = 
   (SELECT code 
    FROM program 
	WHERE acronym = 'CPA')
ORDER BY semester;
