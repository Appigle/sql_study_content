-- scripts.sql

USE master;

-- Batch Command Example
-- DROP DATABASE DbTest

CREATE DATABASE DbTest
GO

USE DbTest
CREATE TABLE t1 (f1 int)
CREATE TABLE t2 (f1 int)

-- USE Statement Example
USE SIS;

DECLARE @totalPaid MONEY;
SET @totalPaid = 
	(SELECT SUM(amount) FROM Payment)
PRINT @totalPaid

-- Table Variables
DECLARE @TableVar TABLE (f1 INT)
INSERT INTO @TableVar VALUES (1)
SELECT *
FROM @TableVar

INSERT @TableVar
SELECT id FROM Payment

SELECT * FROM @TableVar

-- Temporary Tables
SELECT TOP 1 StudentNumber 
INTO #Student
FROM Payment

SELECT * FROM #Student


-- IF..ELSE
IF OBJECT_ID('Payment') IS NULL
  CREATE TABLE Payment (f1 int)
ELSE
  PRINT 'Payment table exists'

-- CASE..END
SELECT name, object_id, type, CASE type
	WHEN 'C' THEN 'Check Constraint'
	WHEN 'D' THEN 'Default Constraint'
	WHEN 'P' THEN 'Procedure'
	WHEN 'F' THEN 'Foreign Key'
	WHEN 'U' THEN 'User Table'
	WHEN 'S' THEN 'System Table'
	WHEN 'V' THEN 'View'
	ELSE 'Other object type'
  END AS [Object Type Name]
FROM sys.objects
WHERE LEN(type) = 1
ORDER BY type;

-- TRY..CATCH
BEGIN TRY
  CREATE TABLE Payment (f1 int)
END TRY
BEGIN CATCH
  PRINT 'Payment table exists'
  PRINT ERROR_MESSAGE()
END CATCH


-- User Defined Functions (UDF) Demo
USE SIS
GO

-- udf1
-- DROP FUNCTION dbo.ToFahrenheit

-- Source: https://www.linkedin.com/learning/microsoft-sql-server-2019-essential-training/leverage-user-defined-scalar-functions
-- create a custom function to convert degrees celsius into degrees fahrenheit
CREATE FUNCTION dbo.ToFahrenheit (@Celsius decimal(10,2))
RETURNS decimal(10,2)
AS
BEGIN
	DECLARE @Fahrenheit decimal(10,2);
	SET @Fahrenheit = (@Celsius * 1.8 + 32);
	RETURN @Fahrenheit
END
GO

DECLARE @Celsius INT = 0;
SELECT @Celsius AS [Celsius], dbo.ToFahrenheit(@Celsius) AS [Fahrenheit]

SET @Celsius = 100;
SELECT @Celsius AS [Celsius], dbo.ToFahrenheit(@Celsius) AS [Fahrenheit]
GO

-- udf2
-- DROP FUNCTION dbo.getSumPayment

CREATE FUNCTION dbo.getSumPayment()
  RETURNS MONEY
BEGIN
  RETURN (
    SELECT SUM(amount) 
    FROM Payment 
  )
END
GO

SELECT dbo.getSumPayment() 
  AS [Total Payment Collected]
GO


-- Stored Procedure (SP) emo

-- sp1
-- DROP PROC pGetAllEmployees

CREATE PROC pGetAllEmployees AS
  SELECT e.number, p.firstName, p.lastName
  FROM Employee e JOIN Person p
    ON e.number = p.number
  ORDER BY p.lastName
GO
EXEC pGetAllEmployees
GO

-- sp2
-- DROP PROC pGetEmployee

CREATE PROC pGetEmployee
  @School CHAR(3), 
  @Name VARCHAR(20)
AS
  SELECT e.number, p.firstName, p.lastName
  FROM Employee e JOIN Person p
    ON e.number = p.number
  WHERE schoolCode = @School 
    AND lastName LIKE @Name
GO
EXEC pGetEmployee 'EIT','YUROVIC'
GO

-- sp3
-- DROP PROC pGetEmployeeBySchool

CREATE PROC pGetEmployeeBySchool
  @School CHAR(3), 
  @Name VARCHAR(20) = '%'
AS
  SELECT e.number, p.firstName
    , p.lastName
  FROM Employee e JOIN Person p
    ON e.number = p.number
  WHERE schoolCode = @School
    AND lastName LIKE @Name
GO

EXEC pGetEmployeeBySchool 'EIT'
GO

-- sp4
-- DROP PROC pGetAmount

CREATE PROC pGetAmount 
  @studentNum VARCHAR(10), 
  @total MONEY OUTPUT
AS
  SELECT @total = 
    (SELECT SUM(amount)
     FROM Payment
     WHERE studentNumber 
       LIKE @studentNum)
GO

-- sp4a: call params by parameter position
DECLARE @totalAll MONEY
EXEC pGetAmount '%', @totalAll   
     OUTPUT
PRINT @totalAll
GO

-- sp4b: call params by name
DECLARE @totalByName MONEY
EXEC pGetAmount 
  @studentNum = '%', 
  @total = @totalByName OUTPUT

PRINT @totalByName
GO

-- sp5
-- DROP PROC pGetAmountR

CREATE PROC pGetAmountR 
  @studentNum VARCHAR(10)
AS
  DECLARE @total MONEY
  SELECT @total = 
    (SELECT SUM(amount)
     FROM Payment
     WHERE studentNumber 
       LIKE @studentNum)
  RETURN @total
GO

DECLARE @totalR MONEY
EXEC 
  @totalR = pGetAmountR '11144%'
PRINT @totalR
GO

-- System Stored Procedures
EXEC sp_who
GO
EXEC sp_columns_100 'Employee'
GO

-- view all stored procedures in curent database that starts with "p"
SELECT SCHEMA_NAME(schema_id) AS SchemaName
  , name AS ProcedureName
FROM sys.procedures
WHERE name LIKE 'p%'
ORDER BY SchemaName;
