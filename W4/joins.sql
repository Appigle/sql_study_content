-- joins.sql

USE SIS;

-- What are the available courses?
SELECT courseNumber
    ,Course.name
    ,sessionCode
    ,capacity
    ,enrollment
FROM CourseOffering, Course
WHERE Course.number = CourseOffering.courseNumber;

-- Table aliases
SELECT co.courseNumber
	,c.name
 	,co.sessionCode
  	,co.capacity
    ,co.enrollment
FROM CourseOffering AS co
	, Course AS c
WHERE c.number = co.courseNumber;

-- More complex joins
SELECT co.courseNumber, c.name, co.sessionCode
	, p.name AS 'program', co.capacity, co.enrollment
FROM CourseOffering co, Course c, ProgramCourse pc, Program p
WHERE c.number = co.courseNumber AND c.number = pc.courseNumber 
	AND pc.programCode = p.code
ORDER BY co.courseNumber;

-- Cross Joins
SELECT p.lastName, p.firstName, e.businessPhone 
FROM Person p, Employee e;

-- Explicit syntax
SELECT Person.lastName, Person.firstName, Employee.businessPhone
FROM Person CROSS JOIN Employee;

-- Self-Joins: What are the IDs and phone extensions of all employees and their immediate managers?
SELECT e.number, e.extension, m.number, m.extension
FROM Employee e, Employee m
WHERE e.reportsTo = m.number;

-- Explicit syntax
SELECT e.number, e.extension, m.number, m.extension
FROM Employee e INNER JOIN Employee m
	ON e.reportsTo = m.number;

-- LEFT outer join
SELECT e.number, e.extension, m.number, m.extension
FROM Employee AS e LEFT OUTER JOIN Employee AS m 
	ON e.reportsTo = m.number;

-- LEFT OUTER JOIN 2: Pre-req of COMP courses
SELECT c.number, c.name, cp.prerequisiteNumber
FROM Course c LEFT OUTER JOIN CoursePrerequisiteAnd cp
     ON( c.number = cp.courseNumber )
WHERE c.number LIKE 'COMP%';

SELECT number, name 
FROM Course c
WHERE number LIKE 'COMP1%';

-- Result:
-- COMP1230 Database Design and Integration
-- COMP1380 Advanced User Applications

SELECT courseNumber, prerequisiteNumber
FROM CoursePrerequisiteAnd cp
WHERE courseNumber LIKE 'COMP1%';

-- Result:
-- COMP1230     INFO1570

-- RIGHT OUTER JOIN: Pre-req of COMP courses
SELECT c.number, c.name, cp.prerequisiteNumber
FROM CoursePrerequisiteAnd cp RIGHT OUTER JOIN Course c 
     ON( c.number = cp.courseNumber )
WHERE c.number LIKE 'COMP%';

-- FULL OUTER JOIN:
-- Find employees and the schools they work at

-- Step 1 (no join)
SELECT code, name
FROM dbo.School
ORDER BY code;

-- Step 2 (inner join)
SELECT School.code, School.name, Employee.number, Employee.extension
FROM School INNER JOIN Employee 
	ON (School.code = Employee.schoolCode)
ORDER BY School.code;

-- Step 3 (LEFT outer join)
SELECT School.code, School.name, Employee.number, Employee.extension
FROM School LEFT OUTER JOIN Employee 
	ON (School.code = Employee.schoolCode)
ORDER BY School.code;

-- Step 4 (RIGHT outer join)
SELECT School.code, School.name, Employee.number, Employee.extension
FROM School RIGHT OUTER JOIN Employee 
	ON (School.code = Employee.schoolCode)
ORDER BY School.code;


-- Step 5 (FULL outer join)
SELECT School.code, School.name, Employee.number, Employee.extension
FROM School FULL OUTER JOIN Employee 
	ON (School.code = Employee.schoolCode)
ORDER BY School.code;
