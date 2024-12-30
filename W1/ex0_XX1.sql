-- ex0_XX.sql
-- Exercise 0
-- Revision History:
-- <Student Name>, Section 0, YYYY.MM.DD: Created
-- <Student Name>, Section 0, YYYY.MM.DD: Updated

Print 'W24 PROG8081 Section 5';
Print '<Task #';
Print '';
Print '<Student Name>';
Print '';
Print '<current timestamp>';

USE SIS;

-- 1
Print '*** Question 1 ***';
Print '';

SELECT *
FROM Employee;

-- 2
Print '*** Question 2 ***';
Print '';

SELECT number
FROM Employee;


-- 3
Print '*** Question 3 ***';
Print '';

SELECT number, reportsTo, campusCode
FROM Employee;


-- 4
Print '*** Question 4 ***';
Print '';

SELECT lastName AS surname
FROM Person;


-- 5
Print '*** Question 5 ***';
Print '';

SELECT lastName surname, city
FROM Person;


-- 6 
Print '*** Question 6 ***';
Print '';

SELECT studentNumber, amount * 1.02
FROM Payment;


-- 7 
Print '*** Question 7 ***';
Print '';

SELECT amount * 1.02 AS "penalty"
FROM Payment;


-- 8
Print '*** Question 8 ***';
Print '';

SELECT DISTINCT studentNumber
FROM Payment;


-- 9 
Print '*** Question 9 ***';
Print '';

SELECT lastName, firstName
FROM Person
ORDER BY lastName ASC;


-- 10
Print '*** Question 10 ***';
Print '';

SELECT lastName, firstName
FROM Person
ORDER BY lastName;


-- 11
Print '*** Question 11 ***';
Print '';

SELECT lastName, firstName
FROM Person
ORDER BY lastName DESC;


-- 12
Print '*** Question 12 ***';
Print '';

SELECT lastName, firstName
FROM Person
ORDER BY lastName, firstName;


-- 13
Print '*** Question 13 ***';
Print '';

SELECT lastName, firstName
FROM Person
ORDER BY lastName DESC, firstName;


-- 14
Print '*** Question 14 ***';
Print '';

SELECT lastName AS surname, firstName
FROM Person
ORDER BY surname DESC, firstName;


-- 15
Print '*** Question 15 ***';
Print '';

SELECT studentNumber, invoiceNumber
FROM Payment
WHERE amount = 1000.00;


-- 16
Print '*** Question 16 ***';
Print '';

SELECT * 
FROM Employee 
WHERE location <> '4A17';


-- 17
Print '*** Question 17 ***';
Print '';

SELECT number, campusCode, location 
FROM Employee 
WHERE number > 6860000 
ORDER BY number;

-- 18
Print '*** Question 18 ***';
Print '';

SELECT *  
FROM School 
WHERE NOT code = 'BUS';

-- 19
Print '*** Question 19 ***';
Print '';

SELECT studentNumber, amount, transactionDate  
FROM Payment 
WHERE id > 10 AND paymentMethodID = 3;

-- 20
Print '*** Question 20 ***';
Print '';

SELECT *
FROM Person 
WHERE firstName = 'John' OR firstName = 'Jon';

