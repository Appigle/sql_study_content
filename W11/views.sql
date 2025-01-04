-- views.sql

-- A. View Examples
USE AP
GO

-- View 1
CREATE VIEW VW_VendorShortList
AS
SELECT VendorName, VendorContactLName,
    VendorContactFName, VendorPhone
FROM Vendors
WHERE VendorID IN 
    (SELECT VendorID 
     FROM Invoices)
GO


-- View 2
CREATE VIEW VW_BalanceDue1 
    ( InvoiceNumber, InvoiceDate, InvoiceTotal
    , BalanceDue)
AS
SELECT InvoiceNumber, InvoiceDate, InvoiceTotal
    , InvoiceTotal - PaymentTotal - CreditTotal
FROM Invoices
WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0
GO

-- View 3
CREATE VIEW VW_BalanceDue2
AS
SELECT InvoiceNumber, InvoiceDate, InvoiceTotal
    , InvoiceTotal - PaymentTotal - CreditTotal AS     
    BalanceDue
FROM Invoices
WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0
GO

-- View 4
CREATE VIEW VW_InvoiceSummary
AS
SELECT VendorName, COUNT(*) AS InvoiceQty,
    SUM(InvoiceTotal) AS InvoiceSum
FROM Vendors JOIN Invoices
  ON Vendors.VendorID = Invoices.VendorID
GROUP BY VendorName
GO

-- View 5
-- Reference: https://www.linkedin.com/learning/microsoft-sql-server-2019-essential-training/create-a-view-of-the-data
-- Using T-SQL script instead of Query Designer

USE Hotel
GO

CREATE VIEW VW_Reservations
AS
SELECT FirstName, LastName, City, State
    , CheckInDate, CheckOutDate
    , Rooms.RoomNumber, BedType, Rate
FROM Guests INNER JOIN RoomReservations 
        ON Guests.GuestID = RoomReservations.GuestID 
    INNER JOIN Rooms 
        ON RoomReservations.RoomNumber = Rooms.RoomNumber
GO

-- View 6
USE Hotel
GO

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS 
    WHERE TABLE_NAME = 'VW_RoomList')
DROP VIEW VW_RoomList
GO

CREATE VIEW VW_RoomList
WITH SCHEMABINDING 
AS 
SELECT RoomNumber, BedType, Rate
FROM dbo.Rooms
WHERE BedType = 'King'
GO

-- Error unless VW_RoomList is altered or dropped
DROP TABLE Rooms;


-- B. CTE Examples
USE AdventureWorks2017;
GO

-- CTE 1. Employee_CTE
-- This is similar to naming all columns in the CREATE VIEW clause
WITH Employee_CTE (EmployeeNumber, Title)
AS
(SELECT NationalIDNumber, JobTitle
 FROM   HumanResources.Employee)

SELECT EmployeeNumber, Title
FROM   Employee_CTE
GO


-- CTE 2. Sales_CTE
-- Source: https://www.linkedin.com/learning/microsoft-sql-server-2016-query-data/introducing-common-table-expressions
-- Modified by: Meyer Tanuan
-- Match SELECT non-aggregate columns to GROUP BY (WITH ROLLUP) and hide ORDER BY

-- Define the CTE expression name and column list.
-- Here we are naming our CTE as Sales_CTE and we are
-- defining the column names it will use when referenced in a query later.

WITH Sales_CTE (SalesPersonID, SalesOrderID, SalesYear)
AS
-- This is the query that generates the structure of the CTE
-- and returns the data values that will be contained in the CTE.
(
    SELECT SalesPersonID, SalesOrderID, YEAR(OrderDate) AS SalesYear
    FROM Sales.SalesOrderHeader
    WHERE SalesPersonID IS NOT NULL
)

-- Now that the inner query has been created, we can define the CTE outer query
-- that will use the result set from the previous query.
-- Note that the previous query can execute by itself, but this query will
-- generate an error if you execute it alone, demonstrating that the CTE
-- only exists in the scope of the entire query operation
SELECT SalesPersonID, SalesYear, COUNT(SalesOrderID) AS TotalSales 
FROM Sales_CTE
GROUP BY SalesPersonID, SalesYear WITH ROLLUP
-- ORDER BY SalesPersonID, SalesYear
GO


-- C. Indexes Examples

USE AP;

-- DROP INDEX IX_Invoices_VendorID ON Invoices;
-- DROP INDEX IX_Invoices_InvoiceDate_InvoiceTotal ON Invoices;

-- Index 1: single column (defaults to nonclustered index)
CREATE INDEX IX_Invoices_VendorID
    ON Invoices (VendorID);

-- Index 2: multiple columns
CREATE INDEX IX_Invoices_InvoiceDate_InvoiceTotal
    ON Invoices (InvoiceDate DESC, InvoiceTotal);


USE Hotel;

-- DROP INDEX IX_Guests_LastName ON Guests;

-- Index 3: explicit nonclustered index 
-- Create an index on the LastName column of the Hotel's Guests table
CREATE NONCLUSTERED INDEX IX_Guests_LastName
ON dbo.Guests (LastName ASC);


-- DROP INDEX UX_Employees_Email ON Employees;

-- Index 4: Unique index
-- email column of the Hotel's Employees table
CREATE UNIQUE INDEX UX_Employees_Email 
ON dbo.Employees
(
	Email ASC
)


-- Query using System Views

-- list view names
SELECT TABLE_NAME AS [View Name]
FROM INFORMATION_SCHEMA.VIEWS;

-- list table constraints
SELECT LEFT( TABLE_NAME, 20 ) AS [Table Name]
      ,LEFT( CONSTRAINT_NAME, 50 ) AS [Constraint Name]
FROM INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE;

-- list default constraints from the system catalog
SELECT LEFT( name, 20 ) AS [Default Name], definition
FROM sys.default_constraints

-- list database objects
SELECT * 
FROM sys.objects
WHERE type IN ('U', 'PK', 'UQ')
ORDER BY type;

-- list user tables
SELECT * 
FROM sys.tables;

-- list key constraints
SELECT * 
FROM sys.key_constraints;

-- list FKs
SELECT * 
FROM sys.foreign_keys;

