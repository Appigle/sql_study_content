-- week7_locks_3.sql
-- https://www.linkedin.com/learning/sql-server-performance-for-developers/transaction-isolation
-- Prepared By: Meyer Tanuan

USE DemoDB;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED -- do not use this option for production
-- use only for access to system metadata/admin (not for business decision making)
SET NOCOUNT ON
GO

-- Step 3 (will see result) and repeat (Step 6)

-- Example of dirty read (will see the uncommitted update in locks_1.sql which is a bad idea)

SELECT EmpID, EmpName, EmpSalary
FROM dbo.TestIsolationLevels 
WHERE EmpID = 2900;
