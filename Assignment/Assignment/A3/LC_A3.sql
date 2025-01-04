-- A3_LC.sql
-- Exercise 0
-- Revision History:
-- <Lei Chen>, Section 4, 2024.07.24: Created

PRINT 'S24 PROG8081 Section 4';
PRINT '<Assignment #3>';
PRINT '';
PRINT 'Student Name:Lei Chen';
PRINT '';
PRINT '<current timestamp>';
PRINT GETDATE();

USE SIS;

-- 1
/**
List person number and birth date for the youngest person. Use a subquery to produce your result.  
Hint: Use an aggregate function in your subquery.
*/
PRINT '*** Question 1 ***';
PRINT '';

SELECT p.number,
       p.birthdate
FROM dbo.Person p
WHERE p.birthdate =
(
    SELECT MAX(p2.birthdate) FROM dbo.Person p2
);


-- 2
/**
List the students whose home (permanent) country is USA or Canada, but not 
from Ontario, Canada. Include the student number, last name, first name, 
province and country in the result. Display the first 20 characters of last name 
and first name. Order your answer by last name and first name ascending. Use 
a subquery to produce your result.
*/
PRINT '*** Question 2 ***';
PRINT '';

SELECT p.number AS [Student Number],
       SUBSTRING(p.lastName, 1, 20) AS [Last Name],
       SUBSTRING(p.firstName, 1, 20) AS [First Name],
       p.provinceCode AS [Provice],
       p.countryCode AS [Country]
FROM dbo.Person p
WHERE p.number IN
      (
          SELECT p.number FROM dbo.Student s WHERE s.isInternational = 1
      )
      AND p.countryCode IN ( 'CAN', 'USA' )
      AND p.provinceCode != 'ON'
ORDER BY p.lastName ASC,
         p.firstName ASC;

-- 3
/**
List the courses that are offered in the first semester in the ITSS program.
 Include the course number, credit hours, credits, and course name in the 
 result. Order your answer by course number ascending. Use only subqueries to   
 produce your answer. The only literal string constant you can use is “ITSS”. Use   
 subqueries to produce your result.   
 Course Number Hours Credits Course name   
     
COMM1180 45 3 Effective Technical Comunication I 
COMP1380 45 3 Advanced User Applications 
INFO1570 60 4 Technology Infrastructure: Fundamentals 
MATH1910 45 3 Mathematics for IT I 
PROG1780 90 6 Programming: Fundamentals 
  
 Hint: Examples 9a to 9d of SUBQUERY.pdf to code a subquery in the SELECT list. 
*/
PRINT '*** Question 3 ***';
PRINT '';

SELECT c.number AS [Course Number],
       c.hours AS [Hours],
       c.credits AS [Credits],
       c.name AS [Course Name]
FROM dbo.Course c
WHERE c.number IN
      (
          SELECT pc.courseNumber
          FROM dbo.ProgramCourse pc
          WHERE pc.semester = 1
                AND pc.programCode =
                (
                    SELECT p.code FROM dbo.Program p WHERE p.acronym = 'ITSS'
                )
      );

-- 4
/**
List the names of the international students who are actively enrolled in any 
 college program that leads to a post-graduate certificate. Order the result by 
 student number. Use the literal string constant credential name “Ontario  
 College Graduate Certificate” as part of your solution. Use subqueries to 
 produce your result. Number of rows expected: 32   
 studentNumber First Name Last Name   
  
1448422 SARDAR SINGH 
1524560 RAJKUMAR RAYCHAUDHURI 
1525872 XIAO-LAN HE 
... 
  Person, 
  Student,  
  StudentProgram, 
  Program,  
  Credential
*/
PRINT '*** Question 4 ***';
PRINT '';

SELECT p.number AS [Student Number],
       p.firstName AS [First Name],
       p.lastName AS [Last Name]
FROM dbo.Person p
WHERE p.number IN
      (
          SELECT s.number
          FROM dbo.Student s
          WHERE s.isInternational = 1
                AND s.number IN
                    (
                        SELECT sp.studentNumber
                        FROM dbo.StudentProgram sp
                        WHERE sp.programStatusCode = 'A'
                              AND sp.programCode IN
                                  (
                                      SELECT pg.code
                                      FROM dbo.Program pg
                                      WHERE pg.credentialCode IN
                                            (
                                                SELECT c.code
                                                FROM dbo.Credential c
                                                WHERE c.name = 'Ontario College Graduate Certificate'
                                            )
                                  )
                    )
      )
ORDER BY p.number;

/**
Use the following information to answer the remaining questions:  
Name Joe Joe 
Person Number 7424478 
Home Street Address Use college Street address 
Home City Guelph 
Home Province ON 
Home Country Canada 
Home Postal Code Use college PC 
Local Street Address 445 GIBSON ST N 
Local City Kitchener 
Local Postal Code N2M 4T4 
Main Phone 001-1111111111 
Other Phone 001-2222222222 
Local Phone (226) 147-2985 
College Email xyz@conestogac.on.ca  
Personal Email abc@gmail.com  
Birth Date October 7, 2002 
International student? Yes 
Account balance $1,130.00 
Academic Status No problems 
Financial Status Has arranged with the Registrar’s office to pay the remainder of her tuition by 
the end of October 
Program Computer Applications Development 
Program Status Currently studying and enrolled in the first semester 
Sequential Number 0 (zero) 
*/

-- 5
/**
Delete the Person record for Joe Joe 
Why delete this record now?  Because as soon as you add the code to 
INSERT the record below, it will fail if the record already exists.  When 
you delete the record at the beginning of the script, you can run the 
script as many times as you need to without this error. 
Note how ON DELETE CASCADE uses number to delete references to Joe 
joe in related tables. 
Delete Course records  for  'BUS9070' and  'LIBS9010';
*/
PRINT '*** Question 5 ***';
PRINT '';

DELETE FROM dbo.Person
WHERE number = 7424478;

DELETE FROM dbo.Course
WHERE number IN ( 'BUS9070', 'LIBS9010' );

-- 6 
/**
Insert a Person record for Joe Joe. 
Show all columns for the person record you just added. 
*/

PRINT '*** Question 6 ***';
PRINT '';

DECLARE @JoeJoeNumber INT = 7424478; 
INSERT INTO Person
(
    number,
    lastName,
    firstName,
    street,
    city,
    provinceCode,
    countryCode,
    postalCode,
    mainPhone,
    alternatePhone,
    collegeEmail,
    personalEmail,
    birthdate
)
VALUES
(   @JoeJoeNumber, -- Use declared variable for Person Number
    'Joe', 'Joe', 'Speedvale Ave', 'Guelph', 'ON', 'CAN', 'N1K 1E6', '001-1111111111', '001-2222222222',
    'xyz@conestogac.on.ca', 'abc@gmail.com', '2002-12-07');

PRINT 'Display the added person info:';
PRINT '';
SELECT *
FROM dbo.Person p
WHERE p.number = 7424478;

-- 7 
/**
Insert a Student record for Joe Joe. 
Show these columns of the student record you just added: 
• number, isInternational,  academicStatusCode, financialStatusCode 
• sequentialNumber, balance, localStreet, localCity and localPostalCode
*/
PRINT '*** Question 7 ***';
PRINT '';
INSERT INTO dbo.Student
(
    number,
    isInternational,
    academicStatusCode,
    financialStatusCode,
    sequentialNumber,
    balance,
    localStreet,
    localCity,
    localProvinceCode,
    localCountryCode,
    localPostalCode,
    localPhone
)
VALUES
(   7424478,           -- number - PersonNumberType
    1,                 -- isInternational - bit
    'N',               -- academicStatusCode - nchar(1)
    'P',               -- financialStatusCode - nchar(1)
    0,                 -- sequentialNumber - int
    1130.00,           -- balance - money
    '445 GIBSON ST N', -- localStreet - nvarchar(80)
    'Kitchener',       -- localCity - nvarchar(30)
    'ON',              -- localProvinceCode - nchar(2)
    'CAN',             -- localCountryCode - nchar(3)
    'N2M 4T4',         -- localPostalCode - nchar(7)
    '(226) 147-2985'   -- localPhone - PhoneNumberType
    );


PRINT 'Display the added Student info:';
PRINT '';
SELECT s.number,
       s.isInternational,
       s.academicStatusCode,
       s.financialStatusCode,
       s.sequentialNumber,
       s.balance,
       s.localStreet,
       s.localCity,
       s.localPostalCode
FROM dbo.Student s
WHERE s.number = 7424478;

-- 8
/**
Inspect the Program table to find the program code for the CAD program. 
 
Insert a StudentProgram record that puts Joe Joe in the CAD program. Use 
the Program code that you looked up. 
Show studentNumber, programCode, semester and  programStatusCode for 
Joe Joe.
*/
PRINT '*** Question 8 ***';
PRINT '';
INSERT INTO dbo.StudentProgram
(
    studentNumber,
    programCode,
    semester,
    programStatusCode
)
VALUES
(   7424478, -- studentNumber - nchar(7)
    (
        SELECT pg.code FROM dbo.Program pg WHERE pg.acronym = 'CAD'
    ),       -- programCode - nchar(5)
    1,       -- semester - int
    N'A'     -- programStatusCode - nchar(1)
    );

SELECT sp.studentNumber AS [Student Number],
       sp.programCode AS [Program Code],
       sp.semester,
       sp.programStatusCode AS [Program Status Code]
FROM dbo.StudentProgram sp
WHERE sp.studentNumber = 7424478;



-- 9 
/**
Inspect the CourseOffering table and find the id for INFO8000 in the Winter 
2024 (W24) session. 
Insert a CourseStudent record that puts Joe Joe in INFO8000 in the Winter 
2024 session.  Use the CourseOffering id that you looked up. 
 
Show courseOfferingId, studentNumber and finalMark for Joe Joe. 

*/
PRINT '*** Question 9 ***';
PRINT '';

/**
  -- Cannot insert the value NULL into column 'CourseOfferingId', table 'SIS.dbo.CourseStudent'; column does not allow nulls. INSERT fails.
INSERT INTO dbo.CourseStudent
(
    CourseOfferingId,
    studentNumber,
    finalMark
)
VALUES
(
    (
        SELECT co.id
        FROM dbo.CourseOffering co
        WHERE co.courseNumber = 'INFO8000'
              AND co.sessionCode = 'W24' <-- sessionCode can't be supportted
    ),          -- CourseOfferingId - int
    N'7424478', -- studentNumber - nchar(7)
    DEFAULT     -- finalMark - float
    );
*/

-- Assuming the session is the Fall 2021(F21)

INSERT INTO dbo.CourseStudent
(
    CourseOfferingId,
    studentNumber,
    finalMark
)
VALUES
(
    (
        SELECT co.id
        FROM dbo.CourseOffering co
        WHERE co.courseNumber = 'INFO8000'
              AND co.sessionCode = 'F21'
    ),          -- CourseOfferingId - int
    N'7424478', -- studentNumber - nchar(7)
    DEFAULT     -- finalMark - float
    );

PRINT 'Display the added info:';
PRINT '';
SELECT cs.CourseOfferingId,
       cs.studentNumber,
       cs.finalMark
FROM dbo.CourseStudent cs
WHERE cs.studentNumber = '7424478';



-- 10
/**
Insert a Course record for LIBS9010.  Use a column list in your INSERT 
statement. 
 
Show all columns for LIBS9010. 
 
LIBS9010 Critical Thinking Skills 
Pensée Critique 
 
Description: This course is designed to provide students with knowledge and skills 
to make decisions based on carefully focused and deliberately determined ways of 
thinking. The course will take a balanced approach to learning critical thinking skills 
and will include theory, analysis and experiential applications. 
Hours: 45 
Credits: 3 
Pre-Requisites: 
CoRequisites:

*/
PRINT '*** Question 10 ***';
PRINT '';

INSERT INTO dbo.Course
(
    number,
    hours,
    credits,
    name,
    frenchName
)
VALUES
(   'LIBS9010',                  -- number - CourseNumberType
    45,                          -- hours - int
    3,                           -- credits - int
    N'Critical Thinking Skills', -- name - nvarchar(70)
    N'Pensée Critique '          -- frenchName - nvarchar(70)
    );

PRINT 'Display the added info:';
PRINT '';
SELECT *
FROM dbo.Course c
WHERE c.number = 'LIBS9010';


-- 11
/**
Insert a Course record for BUS9070.  Do not use a column list in your INSERT 
statement. 
Show all columns for BUS9070. 

BUS9070 Introduction To Human Relations 
Introduction aux relations humaines

Description: This course provides students with an introduction to human 
relations, focusing on self-development and interpersonal effectiveness. 
Students will develop various interpersonal skills by examining theories 
relevant to those skills. The following topics constitute the specific areas of 
study in the course: developing self-awareness, building and maintaining 
relationships, communicating with others, coping with stress, managing 
one's feelings, and resolving interpersonal conflicts. 
Hours: 45 
Credits: 3 
Pre-Requisites: 
CoRequisites: 
*/
PRINT '*** Question 11 ***';
PRINT '';

INSERT INTO dbo.Course
VALUES
(   'BUS9070',                             -- number - CourseNumberType
    45,                                    -- hours - int
    3,                                     -- credits - int
    N'Introduction To Human Relations',    -- name - nvarchar(70)
    N'Introduction aux relations humaines' -- frenchName - nvarchar(70)
    );

PRINT 'Display the added info:';
PRINT '';
SELECT *
FROM dbo.Course c
WHERE c.number = 'BUS9070';


-- 12
/**
Inspect the IncidentalFee table to find the id for the 'Technology Enhancement 
Fee'. 
Update the  'Technology Enhancement Fee' to $100.00. 
Begin a transaction. 
Update the 'Technology Enhancement Fee' to set amountPerSemester to 
$120.00. 
Rollback the transaction. 
 
Show the 'Technology Enhancement Fee'.  The amountPerSemester should 
revert to the original amount. 
*/
PRINT '*** Question 12 ***';
PRINT '';

DECLARE @TEFID INT;
SELECT @TEFID = ife.id
FROM dbo.IncidentalFee ife
WHERE ife.item = 'Technology Enhancement Fee';

UPDATE dbo.IncidentalFee
SET amountPerSemester = 100.00
WHERE id = @TEFID;

BEGIN TRAN;

UPDATE dbo.IncidentalFee
SET amountPerSemester = 120.00
WHERE id = @TEFID;

ROLLBACK TRAN;

PRINT 'Display the updated info:';
PRINT '';

SELECT *
FROM dbo.IncidentalFee ife
WHERE id = @TEFID;


-- 13
/**
Begin a transaction. 
 
Update the 'Technology Enhancement Fee' to set amountPerSemester to 
$190.00. 
 
Commit the transaction. 
Show the 'Technology Enhancement Fee'.  The amountPerSemester should be 
$190.00. 
*/
PRINT '*** Question 13 ***';
PRINT '';

DECLARE @TEFID2 INT;
SELECT @TEFID2 = ife.id
FROM dbo.IncidentalFee ife
WHERE ife.item = 'Technology Enhancement Fee';

BEGIN TRAN;
UPDATE dbo.IncidentalFee
SET amountPerSemester = 190.00
WHERE id = @TEFID2;
COMMIT TRAN;

PRINT 'Display the updated info:';
PRINT '';
SELECT *
FROM dbo.IncidentalFee ife
WHERE id = @TEFID2;