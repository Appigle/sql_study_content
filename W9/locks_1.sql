-- week7_locks_1.sql
-- https://www.linkedin.com/learning/sql-server-performance-for-developers/transaction-isolation
-- Prepared By: Meyer Tanuan

USE master
GO

/****** Object:  Database AP     ******/
IF DB_ID('DemoDB') IS NOT NULL
	DROP DATABASE DemoDB
GO

CREATE DATABASE DemoDB
GO 

USE DemoDB
GO


CREATE TABLE dbo.TestIsolationLevels (
EmpID INT NOT NULL,
EmpName VARCHAR(100),
EmpSalary MONEY,
CONSTRAINT pk_EmpID PRIMARY KEY(EmpID) );

INSERT INTO dbo.TestIsolationLevels 
VALUES 
(2322, 'Drew Brees', 3115000),
(2900, 'Alvin Kamara', 211000),
(2219, 'Mark Ingram', 43000),
(2950, 'Cam Jordan', 13000);


-- Step 1: Run UPDATE on an open transaction

-- Start Transaction
BEGIN TRAN
UPDATE dbo.TestIsolationLevels 
SET EmpSalary = 25000
WHERE EmpID = 2900;

-- Step 4: Uncomment the rollback after locks_3.sql
-- ROLLBACK;