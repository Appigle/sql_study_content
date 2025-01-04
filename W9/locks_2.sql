-- week7_locks_2.sql
-- https://www.linkedin.com/learning/sql-server-performance-for-developers/transaction-isolation
-- Prepared By: Meyer Tanuan

USE DemoDB;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED -- default
SET NOCOUNT ON
GO

-- Step 2 (no result yet) and repeat later (Step 5)

-- Example of query being blocked (hang when transaction is open in locks_1.sql
SELECT EmpID, EmpName, EmpSalary
FROM dbo.TestIsolationLevels 
WHERE EmpID = 2900;
