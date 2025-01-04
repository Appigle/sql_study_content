-- dml.sql

USE SIS;

-- The examples below will use a duplicate (second) copy of the original table to demonstrate SQL insert, update and delete operations.
-- These SQL statements can be reused without re-creating the entire SIS database from scratch.

-- Prepare Duplicate Table 1
DROP TABLE School2;
SELECT *
	INTO School2
FROM School;

SELECT *
FROM School2;

-- INSERT with ALL column values
INSERT INTO School2
	(code, name, frenchName) 
VALUES 
	('LIB', 'Liberal Studies', 'Liberal Studies');

-- INSERT without a COLUMN list
INSERT INTO School2
VALUES 
	('LBS', 'Liberal Studies', 'Liberal Studies');

SELECT *
FROM School2
ORDER BY code;

-- Prepare Duplicate Table 2
DROP TABLE Person2;
SELECT *
	INTO Person2
FROM Person;

-- INSERT with PARTIAL set of column values

INSERT INTO Person2
	(number, lastName, firstName) 
VALUES 
	('A123456', 'TANUAN', 'MEYER');

SELECT *
FROM Person2
WHERE number = 'A123456';

-- INSERT FROM SELECT
INSERT INTO Person2 (number, firstName, LastName, personalEmail, collegeEmail)
SELECT number
	, firstName + '0'
	, lastName + '0'
	, personalEmail + '0'
	, collegeEmail + '0'
FROM Person
WHERE firstName LIKE 'P%';

SELECT *
FROM Person2
WHERE firstName LIKE 'P%';

-- Prepare Duplicate Table 3
DROP TABLE Course2;
SELECT * 
	INTO Course2
FROM Course;

-- Display before update
SELECT *
FROM Course2
WHERE number = 'ACCT1025';

UPDATE Course2
SET credits = 4, hours = 60
WHERE number = 'ACCT1025';

-- Confirm update for a specific course
SELECT *
FROM Course2
WHERE number = 'ACCT1025';

-- UPDATE without WHERE clause
UPDATE Person2 
SET personalEmail = NULL;

-- Confirm update for all records
SELECT *
FROM Person2;

-- Prepare Duplicate Table 4
DROP TABLE Employee2;
SELECT *
	INTO Employee2
FROM Employee;

-- Before UPDATE
SELECT *
FROM Employee2
WHERE number = 5512736;

-- UPDATE with subquery
UPDATE Employee2
SET reportsTo = 
  (SELECT number
   FROM Employee2
   WHERE location = '3B117' 
   AND schoolCode = 'EIT')
WHERE number = 5512736;

-- After UPDATE
SELECT *
FROM Employee2
WHERE number = 5512736;

-- Prepare Duplicate Table 5
DROP TABLE CourseOffering2;
SELECT *
	INTO CourseOffering2
FROM CourseOffering;

-- Count number of rows before DELETE
SELECT COUNT(*)
FROM CourseOffering2;

-- DELETE example
DELETE FROM CourseOffering2
WHERE courseNumber = 'PROG8080' 
AND sessionCode = 'F08';

-- Count number of rows after DELETE
SELECT COUNT(*)
FROM CourseOffering2;

-- TRUNCATE example
TRUNCATE TABLE CourseOffering2;

-- Count number of rows after TRUNCATE (expecting zero)
SELECT COUNT(*)
FROM CourseOffering2;


-- Using Variables 
-- Equivalent to UPDATE with subquery example
DECLARE @NewMgr NCHAR(7);
DECLARE @EmpNum NCHAR(7) = '5512736';

SET @NewMgr = 
   (SELECT number
    FROM Employee2
    WHERE location = '3B117' 
        AND schoolCode = 'EIT');

UPDATE Employee2
SET reportsTo = @NewMgr
WHERE number = @EmpNum;

-- After UPDATE
SELECT *
FROM Employee2
WHERE number = @EmpNum;