-- trans.sql

USE SIS;

-- TRANSACTION Example 1: Account, Role, Account Role tables
-- WARING: This example uses the SIS Account, Role and AccountRole tables. 
--         Be ready to recreate the SIS tables, as needed.

Print '';
Print 'TRANSACTION Example 1: Account, Role, Account Role tables';
Print '';

-- Step 1: Declare variables and clean up SIS tables (autocommit by default)
DECLARE @UserId NVARCHAR(20) = 'mtanuan';
DECLARE @RoleName NVARCHAR(30) = 'Teacher';
DECLARE @FrenchRoleName NVARCHAR(30) = 'Professeur';

DELETE FROM AccountRole
WHERE userId = @UserId;

DELETE FROM Account
WHERE userId = @UserId;

DELETE FROM Role
WHERE name = @RoleName;

-- display contents (optional)
SELECT * FROM Account;
SELECT * FROM Role;
SELECT * FROM AccountRole;

-- Step 2: Insert all records (explicit transaction)
BEGIN TRAN;
	INSERT INTO Account
		(userId, password)
	VALUES (@UserId, NEWID());
	INSERT INTO Role
		(name, frenchName)
	VALUES (@RoleName, @FrenchRoleName);
	INSERT INTO AccountRole
--		(userId, roleName, frenchRoleName)
	VALUES (@UserId, @RoleName, @FrenchRoleName);
	Print 'New ID created for AccountRole table: '; 
	Print @@IDENTITY;
	Print '';
COMMIT TRAN;

-- display contents (optional)
SELECT * FROM Account;
SELECT * FROM Role;
SELECT * FROM AccountRole;


-- TRANSACTION Example 2: Person2 and Employee2 tables
Print '';
Print 'TRANSACTION Example 2: Person2 and Employee2 tables';
Print '';

-- Step 1: Prepare empty Person2 and Employee2 tables and declare variables
Print '';
Print '=== Example 2: STEP 1 ===';
Print '';

DROP TABLE Person2;
SELECT *
	INTO Person2
FROM Person;
TRUNCATE TABLE Person2;

DROP TABLE Employee2;
SELECT *
	INTO Employee2
FROM Employee;
TRUNCATE TABLE Employee2;

-- display contents (optional)
SELECT * FROM Person2;
SELECT * FROM Employee2;

DECLARE @Number NCHAR(7) = 'ABC1234';
DECLARE @LastName NVARCHAR(50) = 'Tanuan';
DECLARE @FirstName NVARCHAR(50) = 'Meyer';
DECLARE @SchoolCode NCHAR(3) = 'BUS';
DECLARE @CampusCode NCHAR(1) = 'W';
DECLARE @Location NCHAR(30) = '3G24';

-- Step 2: Insert all records (explicit transaction)
Print '';
Print '=== Example 2: STEP 2 ===';
Print '';

-- Get ready with transactions
IF (@@TRANCOUNT > 0) 
	COMMIT;
Print 'Step 2 (Before BEGIN TRAN): TRANCOUNT => ' + CONVERT( CHAR(3), @@TRANCOUNT );

BEGIN TRAN;
	Print 'Inside Step 2 BEGIN TRAN (Before INSERT Row 1): TRANCOUNT => ' + CONVERT( CHAR(3), @@TRANCOUNT );

	-- add row to table 1
	INSERT INTO Person2
		(number, lastName, firstName) 
	VALUES 
		(@Number, @LastName, @FirstName);
	Print 'Inside Step 2 BEGIN TRAN (After INSERT Row 1): TRANCOUNT => ' + CONVERT( CHAR(3), @@TRANCOUNT );

	-- add row to table 2
	INSERT INTO Employee2
		(number, schoolCode, campusCode, location) -- for runtime error: disable column list
	VALUES 
		(@Number, @SchoolCode, @CampusCode, @Location);
	Print 'Inside Step 2 BEGIN TRAN (Ater INSERT Row 2): TRANCOUNT => ' + CONVERT( CHAR(3), @@TRANCOUNT );

COMMIT TRAN;
Print 'Step 2 (After COMMIT TRAN): TRANCOUNT => ' + CONVERT( CHAR(3), @@TRANCOUNT );

-- display contents (optional)
SELECT * FROM Person2;
SELECT * FROM Employee2;


-- Step 3: UPDATE with implicit transactions (unseen BEGIN followed by ROLLBACK)
Print '';
Print '=== Example 2: STEP 3 ===';
Print '';
-- Get ready with transactions
IF (@@TRANCOUNT > 0) 
	COMMIT;

SET IMPLICIT_TRANSACTIONS ON; 
-- to see how ROLLBACK works with implicit transactions
-- If IMPLICIT_TRANSACTIONS is OFF (default), comment out ROLLBACK statement below. Autocommit will succeed (i.e., reportsTo is NOT NULL).

Print '';
Print '=== UPDATE with IMPLICIT transactions: ON ===';
Print '';
Print 'Before UPDATE: TRANCOUNT => ' + CONVERT( CHAR(3), @@TRANCOUNT );

DECLARE @Number2 NCHAR(7) = 'ABC1234';
DECLARE @ReportsTo2 NCHAR(7) = 'ABC1234';

UPDATE Employee2
SET reportsTo = @ReportsTo2
WHERE number = @Number2;

Print 'After UPDATE: TRANCOUNT => ' + CONVERT( CHAR(3), @@TRANCOUNT );
-- Rollback will succeed () if IMPLICIT_TRANSACTION is ON
ROLLBACK;	

Print 'After ROLLBACK: TRANCOUNT => ' + CONVERT( CHAR(3), @@TRANCOUNT );

-- display contents to confirm reportsTo is NULL after ROLLBACK
SELECT * FROM Employee2;


Print '';
Print '=== Example 2: STEP 4 (AUTOCOMMIT DEMO) ===';
Print '=== UPDATE with AUTOCOMMIT (i.e., IMPLICIT transactions: OFF ===';

SET IMPLICIT_TRANSACTIONS OFF; 
-- TEST with default
UPDATE Employee2
SET reportsTo = 'XYZ'
WHERE number = 'ABC1234';

-- display contents to confirm reportsTo is 'XYZ' due to AUTOCOMMIT
SELECT * FROM Employee2;