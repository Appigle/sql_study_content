-- A1_LC.sql
-- Spring 2024

PRINT 'S24 PROG8081';
PRINT 'Assignment 1';
PRINT '';
PRINT 'Lei Chen';
PRINT '';
PRINT GETDATE();
PRINT '';

USE SIS;

-- 1. List the province code the persons are from, but show each province code only once (i.e., no duplicates). List the results in descending order by province code. Number of rows expected: 5
SELECT DISTINCT
       provinceCode
FROM dbo.Person
ORDER BY provinceCode DESC;

-- 2. List the province code the persons are from (i.e., no duplicates) with the NULL value excluded in the output. Number of rows expected: 4
SELECT DISTINCT
       provinceCode
FROM dbo.Person
WHERE LEN(provinceCode) > 0
ORDER BY provinceCode DESC;

-- 3. List number, last name, first name, city, and country for persons who does not have a province code assigned. Number of rows expected: 41
SELECT number,
       lastName,
       firstName,
       city,
       countryCode
FROM dbo.Person
WHERE provinceCode IS NULL
ORDER BY provinceCode DESC;

-- 4. List all data from the Program table with program name that starts with ¡®Computer¡¯.  Number of rows expected: 3
SELECT *
FROM dbo.Program
WHERE name LIKE 'Computer%';

-- 5. List the code, acronym and name of the programs with program name that contains ¡®coop¡¯. Number of rows expected: 4
SELECT code,
       acronym,
       name
FROM dbo.Program
WHERE name LIKE '%coop%';

-- 6. List all data for students with final mark that is lower than 55. Do not display final mark that is zero. Number of rows expected: 11
SELECT *
FROM dbo.CourseStudent
WHERE finalMark < 55
      AND finalMark > 0;

-- 7. List the number, capacity and memory of any room that has a capacity greater than or equal to 40, is a lab, has computers with 4GB memory, and is located at the Doon campus. Number of rows expected: 1
SELECT number,
       capacity,
       memory
FROM dbo.Room
WHERE capacity >= 40
      AND isLab = 1
      AND memory = '4GB'
      AND campusCode = 'D';

-- 8. List all employees who teach in the School of Trades and Apprenticeship and are located at the Doon, Guelph or Waterloo campus. Number of rows expected: 3
SELECT *
FROM dbo.Employee
WHERE campusCode IN ( 'D', 'W', 'G' )
      AND schoolCode = 'TAP';

-- 9. N/A

-- 10. List the ¡°last name¡± and the ¡°user id¡± for all persons whose last name starts with ¡®J¡¯. The user id consists of the first letter of the first name and the first seven letters of the last name, all in lower case. Alias the user id ¡®User ID¡¯, and sort the results in descending ¡®User ID¡¯ order. Use either LEFT() or SUBSTRING() as you wish. Number of rows expected: 10
SELECT lastName,
       LOWER(LEFT(firstName, 1) + SUBSTRING(lastName, 0, 7 + 1)) AS 'User ID'
FROM dbo.Person
WHERE LEFT(lastName, 1) = 'J'
ORDER BY LOWER(LEFT(firstName, 1) + SUBSTRING(lastName, 0, 7)) DESC;


-- 11. List number, birth date aliased as ¡®dob¡¯, and calculated age aliased as ¡®age¡¯, for persons that are over 60 years old as of today. Use FORMAT() to display ¡®dob¡¯ in the format similar to ¡°January 01, 2022¡±. Use DATEDIFF() to calculate the ¡®age¡¯. Number of rows expected: 5
-- comment: 
/**
    (7 rows affected)

    Completion time: 2024-05-23T12:16:04.1076205-04:00
*/
SELECT number,
       FORMAT(birthdate, 'MMMM dd, yyyy') AS dob,
       DATEDIFF(YEAR, birthdate, GETDATE()) AS age
FROM dbo.Person
WHERE DATEDIFF(YEAR, birthdate, GETDATE()) > 60;

-- 12. List number aliased as ¡®Course Code¡¯ and name aliased as ¡®Course Name¡¯ for all courses that have the word ¡®Game¡¯ in their name. Use CHARINDEX() as part of your solution. Do not use LIKE. Number of rows expected: 2
SELECT number AS 'Course Code',
       name AS 'Course Name'
FROM dbo.Course
WHERE CHARINDEX('Game', name) > 0;
SELECT number AS 'Course Code',
       name AS 'Course Name'
FROM dbo.Course
WHERE name LIKE '%Game%';