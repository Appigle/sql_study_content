-- aggregates.sql

USE SIS;

--COUNT function
SELECT COUNT( * ) AS [COUNT( * )] 
FROM Person;

SELECT COUNT( fax) AS [COUNT( fax )]
FROM Employee;

SELECT COUNT( ALL fax ) AS [COUNT( ALL fax )]
FROM Employee;

SELECT COUNT( DISTINCT fax ) AS [COUNT( DISTINCT fax )]
FROM Employee;

SELECT COUNT( DISTINCT fax ) AS [COUNT( DISTINCT fax ) with WHERE]
FROM Employee
WHERE schoolCode = 'TAP' ;

-- AVG
SELECT '$' + CONVERT(CHAR(7), CAST(AVG(amount) AS money),1) -- SELECT FORMAT( AVG(amount), 'c') 
	AS 'Average amount' 
FROM InvoiceItem;

-- MIN
SELECT '$' + CONVERT(CHAR(7), CAST(MIN(amount) AS money),1) 
		AS [Minimum Price] 
FROM InvoiceItem;

-- MAX
SELECT '$' + CONVERT(CHAR(9), CAST(MAX(amount) AS money),1) 
	AS [Maximum Price] 
FROM InvoiceItem;

-- SUM
SELECT '$' + CONVERT(CHAR(9), CAST(SUM(amount) AS money),1) 
	AS [Sum of all Items] 
FROM InvoiceItem;

-- Aggregates with WHERE
SELECT '$' + CONVERT(CHAR(10), CAST(AVG(amount) AS money),1) 
	AS [Avg of all items] 
FROM InvoiceItem 
WHERE item LIKE '%CSI%';

-- GROUP BY
SELECT studentNumber, SUM(amount)
FROM Payment
GROUP BY studentNumber;

-- Empty input with GROUP BY: empty result set
SELECT sessionCode, AVG(amount) AS AverageAmount
FROM Invoice
WHERE amount > 0
GROUP BY sessionCode;

-- Empty input without GROUP BY: result set has 1 row
SELECT AVG(amount) AS AverageAmount
FROM Invoice
WHERE amount > 0;

-- GROUP BY and HAVING
SELECT studentNumber,
 	'$' + CONVERT( CHAR(12), CAST( SUM(amount) AS money ), 1 ) AS [Invoice Total]
FROM Payment
GROUP BY studentNumber
HAVING COUNT(*) > 1;

-- Order of clauses
SELECT studentNumber
	, '$' + CONVERT( CHAR(12), CAST( SUM(amount) AS money ), 1 )
	AS [Invoice Total]
FROM Payment
WHERE studentNumber <> 8431710
GROUP BY studentNumber
HAVING COUNT(*) > 1
ORDER BY 2 DESC;

-- Example 

-- Count number of persons: 434
SELECT COUNT(*)
FROM Person;

-- Count unique letters: 24
SELECT COUNT(DISTINCT LEFT(LastName,1)) AS UniqueFirstLetterOfLastName
FROM Person;

-- WITH ROLLUP
-- Display the tally board for all persons (with count per unique first letter with final summary row) 
SELECT LEFT(LastName,1), COUNT(LEFT(LastName,1))
FROM Person
GROUP BY LEFT(LastName,1)
	WITH ROLLUP;

-- Count number of students: 420
SELECT COUNT(*)
FROM Student;

-- Display the tally board for all students: 420
SELECT LEFT(LastName,1), COUNT(LEFT(LastName,1))
FROM Student s JOIN Person p
	ON s.number = p.number
GROUP BY (LEFT(LastName,1))
	WITH ROLLUP;

-- Count number of international students: 44
SELECT COUNT(*)
FROM Student
WHERE isInternational=1;

-- Display the tally board for international students: 44
-- Using  WHERE clause (search condition): Only shows 17 unique first letters instead of 24
SELECT LEFT(LastName,1), COUNT(LEFT(LastName,1))
FROM Student s JOIN Person p
	ON s.number = p.number
WHERE isInternational=1
GROUP BY (LEFT(LastName,1))
	WITH ROLLUP;
	
-- To show all the original 24 unique first letters: 
-- (a) RIGHT OUTER JOIN
-- (b) Use join table expression (move search condition from WHERE clause to ON clause)
SELECT LEFT(LastName,1), COUNT(s.number)
FROM Student s RIGHT OUTER JOIN Person p
	ON (s.number = p.number
		AND isInternational=1)
GROUP BY (LEFT(LastName,1))
	WITH ROLLUP;
