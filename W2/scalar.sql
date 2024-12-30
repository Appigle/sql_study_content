-- scalar.sql

-- Scalar function examples
SELECT 2 + 2;

SELECT GETDATE( );

SELECT SQRT( 2 );

SELECT SOUNDEX( 'Roselius');
SELECT SOUNDEX( 'Rosalis');

-- SQL Functions in the SELECT clause
SELECT a.invoiceNumber, date, DATEPART(MM, [date] ) as [month]
FROM dbo.Audit a;

SELECT DISTINCT SUBSTRING(mainPhone, 1, 3) AS prefix 
FROM Person;

-- SQL Functions in the WHERE clause
SELECT a.invoiceNumber, [date], DATEPART(MM, [date] )
FROM dbo.Audit a
WHERE DATEPART(MM, [date] ) = 8;

SELECT lastName, firstName
FROM Person 
WHERE UPPER(SUBSTRING(lastName,1,2)) = 'MC';

-- String Functions
SELECT TOP 10 SUBSTRING( city, 1, 3 ) AS [abbreviation] 
FROM Person;

SELECT TOP 10 LEFT( city, 3 ) AS [abbreviation] 
FROM Person;

SELECT * 
FROM Person 
WHERE CHARINDEX( 'Mc', lastName ) > 0;

-- String Concatenation
SELECT TOP 10 lastName + ' (' + firstName + ')' AS completeName
FROM Person;

-- Formatting Money Amounts
-- '$' + CONVERT( CHAR(12), CAST( amount AS MONEY ), 1)
SELECT	code, semester, Tuition,
		Tuition * 1.1074 as "Expression",
		CAST( Tuition * 1.1074 AS MONEY ) as "CAST" ,
		'$' + CONVERT( CHAR(12), CAST( Tuition * 1.1074 AS MONEY ), 1) as "CONVERT" 
FROM ProgramFee;

-- Math Functions: ROUND( )
SELECT id, item, amountPerSemester,
ROUND( amountPerSemester, 0 ) AS rounded, 
ROUND( amountPerSemester, 0, 1 ) AS truncated
FROM IncidentalFee
ORDER BY amountPerSemester;

-- Date Arithmetic
SELECT dueDate, dueDate + 7 AS 'one week later'
FROM dbo.Invoice
ORDER BY dueDate;

SELECT dueDate, dueDate - 7 AS 'one week earlier'
FROM dbo.Invoice
ORDER BY dueDate;

-- DATEADD() example
SELECT [date],
	DATEADD(day, 1, [date]) AS 'tomorrow',
	DATEADD(ww, 1, [date]) AS 'next week',
	DATEADD(mm, 1, [date]) AS 'next month',
	DATEADD(yy, -1, [date]) AS 'last year',
	DATEADD(yy, 1, [date]) AS 'next year'
FROM StudentOffence;

-- DATDIFF() example
SELECT 
 transactionDate, dueDate, 
 DATEDIFF(DAY, transactionDate, dueDate) AS 'Days to Pay'
FROM Invoice

-- returns weird result
SELECT GETDATE( );

-- CASTing Dates: returns correct result
SELECT CAST( (GETDATE() - '2000-01-01') AS INTEGER ) AS 'Days since the millenium';

-- DATE Formatting: CONVERT()
SELECT CONVERT( CHAR(10), GETDATE( ), 102 );

-- DATE Formatting: FORMAT()
SELECT FORMAT ( GETDATE(), 'yyyy.MM.dd') AS FormattedDate;

-- More date formatting using FORMAT()
SELECT transactionDate, FORMAT ( transactionDate, 'yyyy.MM.dd') AS FormattedDate
FROM Invoice;
