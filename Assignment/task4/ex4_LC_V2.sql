-- ex4_LC.sql
-- Exercise 0
-- Revision History:
-- <Lei Chen>, Section 4, 2024.07.17: Created
-- <Lei Chen>, Section 4, 2024.07.18: modify

PRINT 'S24 PROG8081 Section 4';
PRINT '<Task #4>';
PRINT '';
PRINT 'Student Name: Lei Chen';
PRINT '';
PRINT '<current timestamp>';
PRINT GETDATE();

USE AP;

-- 1
/**
Remove the VendorCopyXX table (where XX is your initials), if it exists. Create a copy of the Vendors table and name it VendorCopyXX. Then, display the number of rows in the new VendorCopyXX table.
*/
PRINT '*** Question 1 ***';
PRINT '';

-- DROP TABLE IF EXISTS VendorCopyLC;
IF OBJECT_ID('VendorCopyLC', 'U') IS NOT NULL
BEGIN
    DROP TABLE VendorCopyLC;
    PRINT 'VendorCopyLC is exist and executing delete action';
END;
ELSE
    PRINT 'VendorCopyLC is not exist';



SELECT *
INTO VendorCopyLC
FROM dbo.Vendors;

SELECT COUNT(*) AS [The Number of Rows]
FROM dbo.VendorCopyLC;


-- 2
/**
Remove the InvoiceBalancesXX table, if it exists. Create a copy of the Invoices table for invoices with a non-zero balance, and name it InvoiceBalancesXX. Then, display the number of rows in the new InvoiceBalancesXX table. *TBD*
*/
PRINT '*** Question 2 ***';
PRINT '';

IF OBJECT_ID('InvoiceBalancesLC', 'U') IS NOT NULL
BEGIN
    DROP TABLE InvoiceBalancesLC;
    PRINT 'InvoiceBalancesLC is exist and executing delete action';
END;
ELSE
    PRINT 'InvoiceBalancesLC is not exist';

SELECT *
INTO InvoiceBalancesLC
FROM dbo.Invoices i
WHERE (i.InvoiceTotal - i.PaymentTotal -i.CreditTotal) != 0;

SELECT COUNT(*) AS [The Number of Rows]
FROM InvoiceBalancesLC;


-- 3
/**
Add a row to the InvoiceBalancesXX table without using a column list. 
Then, display the newly added row using the Vendor ID as part of your query.
*/
PRINT '*** Question 3 ***';
PRINT '';

INSERT INTO dbo.InvoiceBalancesLC -- Inserting data into the table
VALUES
(   86,                         -- VendorID - int
    '4591178',                  -- InvoiceNumber - varchar(50)
    CAST('9/01/2022' AS DATE),  -- InvoiceDate - date
    9345.60,                    -- InvoiceTotal - money
    0,                          -- PaymentTotal - money
    0,                          -- CreditTotal - money
    1,                          -- TermsID - int
    CAST('10/01/2022' AS DATE), -- InvoiceDueDate - date
    NULL                        -- PaymentDate - date
    );

SELECT *
FROM InvoiceBalancesLC
WHERE VendorID = 86;

-- 4
/**
Add another row to the InvoiceBalancesXX table using a column list. Only use the columns listed above. Then, display the newly added row using the Vendor ID as part of your query.
*/
PRINT '*** Question 4 ***';
PRINT '';

INSERT INTO dbo.InvoiceBalancesLC
(
    VendorID,
    InvoiceNumber,
    InvoiceDate,
    InvoiceTotal,
    PaymentTotal,
    CreditTotal,
    TermsID,
    InvoiceDueDate,
    PaymentDate
)
VALUES
(   30,                         -- VendorID - int
    'COSTCO345',                -- InvoiceNumber - varchar(50)
    GETDATE(),                  -- InvoiceDate - date
    2800.00,                    -- InvoiceTotal - money
    0,                          -- PaymentTotal - money
    0,                          -- CreditTotal - money
    1,                          -- TermsID - int
    GETDATE(),                  -- InvoiceDueDate - date
    DATEADD(DAY, 30, GETDATE()) -- PaymentDate - date
    );

SELECT *
FROM dbo.InvoiceBalancesLC
WHERE VendorID = 30;

-- 5
/**
Update the Credit Total column of the InvoiceBalancesXX table to $300.00 for Invoice Number COSTCO345 added in the previous question. Then, display the updated row using the Invoice Number as part of your query.
*/
PRINT '*** Question 5 ***';
PRINT '';

UPDATE dbo.InvoiceBalancesLC
SET CreditTotal = 300.00
WHERE InvoiceNumber = 'COSTCO345';

SELECT *
FROM dbo.InvoiceBalancesLC
WHERE InvoiceNumber = 'COSTCO345';



-- 6 
/**
Increase the Credit Total by $90 for the TOP 5 invoices in the InvoiceBalancesXX table, with an unpaid balance of over $900. Use a subquery in the FROM clause as part of your solution. Then, display the following columns: InvoiceID, InvoiceNumber, VendorID, InvoiceTotal, CreditTotal. Note the 5 rows that have Credit Total increased by $90.
*/
PRINT '*** Question 6 ***';
PRINT '';

UPDATE dbo.InvoiceBalancesLC
SET CreditTotal = CreditTotal + 90
FROM
(
    SELECT TOP 5
           InvoiceID
    FROM dbo.InvoiceBalancesLC
    WHERE (InvoiceTotal - PaymentTotal - CreditTotal) > 900
) AS Top5Table
WHERE Top5Table.InvoiceID = dbo.InvoiceBalancesLC.InvoiceID;

SELECT InvoiceID,
       InvoiceNumber,
       VendorID,
       InvoiceTotal,
       CreditTotal
FROM dbo.InvoiceBalancesLC;

-- 7 
/**
Delete a single row from the InvoiceBalancesXX table for Invoice Number 4591178. Then, display the entire table. Note the deleted row is no longer in the table.
*/
PRINT '*** Question 7 ***';
PRINT '';

DELETE dbo.InvoiceBalancesLC
WHERE InvoiceNumber = '4591178';

SELECT *
FROM dbo.InvoiceBalancesLC;

-- 8
/**
Display the number of rows in the VendorCopyXX table. Then, delete rows from the VendorCopyXX table for vendors that does not have invoices in the InvoiceBalancesXX table (i.e., no vendor purchases). Use a subquery in the WHERE clause as part of your solution. Then, display the number of rows remaining in the VendorCopyXX table.
*/
PRINT '*** Question 8 ***';
PRINT '';

SELECT COUNT(*) AS [VendorCopyLC Before Delete]
FROM dbo.VendorCopyLC; -- 122 rows

DELETE dbo.VendorCopyLC
FROM dbo.VendorCopyLC vlc
WHERE vlc.VendorID NOT IN
      (
          SELECT DISTINCT ilc.VendorID FROM dbo.InvoiceBalancesLC ilc
      );

SELECT COUNT(*) AS [VendorCopyLC After Delete]
FROM dbo.VendorCopyLC; -- 8 rows 


-- 9 
/**
Create a transaction that will attempt to delete rows from the InvoiceBalancesXX table. Declare a Vendor ID variable with the value 123 (i.e., FedEx). Use the Vendor ID variable to delete FedEx invoices. Rollback the transaction when there are more than one row for deletion with the message “More invoices than expected. Deletions rolled back.” Otherwise, display a message that the deletion was successful. Using the Vendor ID variable, display the number of FedEx invoices to confirm the FedEx invoices are still in the InvoiceBalancesXX table.
*/
PRINT '*** Question 9 ***';
PRINT '';

BEGIN TRAN;
DECLARE @VendorID INT = 123; -- FedEx venderId
DELETE FROM dbo.InvoiceBalancesLC
WHERE VendorID = @VendorID;

IF @@ROWCOUNT > 1
BEGIN
    ROLLBACK TRAN;
    PRINT 'More invoices than expected. Deletions rolled back.';
END;
ELSE
BEGIN
    COMMIT TRAN;
    PRINT 'Deletions commit to the database successfully.';
END;

SELECT COUNT(*) AS [Number of FedEx invoices]
FROM dbo.InvoiceBalancesLC
WHERE VendorID = @VendorID;

-- 10 
/**
*** Warning: Q10 will permanently add rows to the AP database. *** Display the number of rows in the Invoices and InvoiceLineItems tables. Then, add invoice and invoice line items using the transaction defined in the AP scripts under “SQL Server 2019\Scripts\Chapter 16\Figure 16-01b.sql”.
Then, display the number of rows in the Invoices and InvoiceLineItems tables again.
*/
PRINT '*** Question 10 ***';
PRINT '';

-- BEFORE
PRINT 'Count BEFORE Transaction';

SELECT COUNT(*) AS InvoicesCount
FROM dbo.Invoices;
SELECT COUNT(*) AS InvoiceLineItemsCount
FROM dbo.InvoiceLineItems;
PRINT '';

DECLARE @InvoiceiD INT;
BEGIN TRY
    BEGIN TRAN;
    INSERT Invoices
    VALUES
    (34, 'ZXA-080', '2020-03-01', 14092.59, 0, 0, 3, '2020-03-31', NULL);
    SET @InvoiceiD = @@IDENTITY;
    INSERT InvoiceLineItems
    VALUES
    (@InvoiceiD, 1, 160, 4447.23, 'HW upgrade');
    INSERT InvoiceLineItems
    VALUES
    (@InvoiceiD, 2, 167, 9645.36, '0S upgrade');
    COMMIT TRAN;
    PRINT 'Commit Tran!';
END TRY
BEGIN CATCH
    ROLLBACK TRAN;
    PRINT 'Rollback Tran!';
END CATCH;

-- AFTER
PRINT '';
PRINT 'Count AFTER Transaction';

SELECT COUNT(*) AS InvoicesCount
FROM dbo.Invoices;
SELECT COUNT(*) AS InvoiceLineItemsCount
FROM dbo.InvoiceLineItems;

