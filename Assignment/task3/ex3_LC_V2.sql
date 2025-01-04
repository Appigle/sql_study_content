-- ex3_LC.sql
-- Exercise 0
-- Revision History:
-- <Lei Chen>, Section 4, 2024.07.12: Created
-- <Lei Chen>, Section 4, 2024.07.18: Modified

PRINT 'S24 PROG8081 Section 4';
PRINT '<Task #3>';
PRINT '';
PRINT 'Student Name:Lei Chen';
PRINT '';
PRINT '<current timestamp>';
PRINT GETDATE();

USE AP;

-- 1
/**
List the Invoice Number and Vendor Name columns for invoices with a Vendor Name of ’Compuserve’. Use implicit syntax for the inner join. 
*/
PRINT '*** Question 1 ***';
PRINT '';

SELECT i.InvoiceNumber,
       v.VendorName
FROM dbo.Invoices i,
     dbo.Vendors v
WHERE i.VendorID = v.VendorID
      AND v.VendorName = 'Compuserve';

-- 2
/**
List the 5 columns (Invoice Number, Vendor ID, Vendor Name, Invoice Due Date and Balance Due) for invoices with “Balance Due” greater than $500. Use explicit syntax for the inner join. Sort the result by “Balance Due” in ascending order. 
*/
PRINT '*** Question 2 ***';
PRINT '';

SELECT i.InvoiceNumber,
       i.VendorID,
       v.VendorName,
       i.InvoiceDueDate,
       (i.InvoiceTotal - i.PaymentTotal - i.CreditTotal) AS [Balance Due]
FROM dbo.Vendors v
    JOIN dbo.Invoices i
        ON i.VendorID = v.VendorID
WHERE (i.InvoiceTotal - i.PaymentTotal - i.CreditTotal) > 500
ORDER BY [Balance Due] ASC;

-- 3
/**
List the 4 columns: Vendor ID and Vendor Name of vendors, along with the Invoice Number and Invoice Total of the vendors with vendor name that starts with ‘in’. Display the vendor even if they do not have any invoices. Use explicit syntax for the outer join. Sort the result by Vendor Name in descending order. Do not use any correlation name or table alias.
*/
PRINT '*** Question 3 ***';
PRINT '';

SELECT dbo.Vendors.VendorID,
       dbo.Vendors.VendorName,
       dbo.Invoices.InvoiceNumber,
       dbo.Invoices.InvoiceTotal
FROM dbo.Vendors
    LEFT OUTER JOIN dbo.Invoices
        ON dbo.Invoices.VendorID = dbo.Vendors.VendorID
WHERE dbo.Vendors.VendorName LIKE 'in%'
ORDER BY dbo.Vendors.VendorName DESC;

-- 4
/**
List the 3 columns for invoices with Invoice Date after Dec. 31, 2018. The first column displays ’After 12/31/2018’ followed by 2 columns using MIN() and MAX() aggregate functions with the Invoice Total column as the argument.  The column headers are: SelectionDate, LowestInvoiceTotal, and HighestInvoiceTotal.
*/
PRINT '*** Question 4 ***';
PRINT '';

SELECT 'After 12/31/2018' AS SelectionDate,
       MIN(InvoiceTotal) AS LowestInvoiceTotal,
       MAX(InvoiceTotal) AS HighestInvoiceTotal
FROM dbo.Invoices
WHERE InvoiceDate > '2018-12-31'

-- 5
/**
Construct a summary query that groups by two columns (Vendor State and Vendor City). List the same two columns followed by the COUNT() and AVG() aggregate functions with the Invoice Total column as the argument. Use FORMAT() to display the Average Amount column in currency format. Sort the result by Vendor State and Vendor City columns. Hint: Study Murach’s “SQL Server 2019\Scripts\Chapter 05\Figure 5-04b.sql”. The column headers are: VendorState, VendorCity, InvoiceQty, and AvgAmount.
*/
PRINT '*** Question 5 ***';
PRINT '';

SELECT v.VendorState AS VendorState,
       v.VendorCity AS VendorCity,
       COUNT(*) AS InvoiceQty,
       FORMAT(AVG(i.InvoiceTotal), 'C') AS AvgAmount
FROM dbo.Vendors v
    JOIN dbo.Invoices i
        ON i.VendorID = v.VendorID
GROUP BY v.VendorState,
         v.VendorCity
ORDER BY v.VendorState,
         v.VendorCity;


-- 6 
/**
Construct a summary query with a search condition in the WHERE clause for invoices in December, 2019. The query displays the Invoice Date followed by the “Invoice Qty” and “Invoice Sum”. Only display the result with “Invoices Qty” above 2 and “Invoice Sum” of over $1,000. Sort the result by “Invoice Date” in descending order. 
*/
-- This result is different with the recommended rpt result
PRINT '*** Question 6 ***';
PRINT '';

SELECT i.InvoiceDate AS [Invoice Date],
       COUNT(i.InvoiceTotal) AS [Invoice Qty],
       SUM(i.InvoiceTotal) AS [Invoice Sum]
FROM dbo.Invoices i
WHERE i.InvoiceDate
BETWEEN '2019-12-01' AND '2019-12-31'
GROUP BY i.InvoiceDate
HAVING COUNT(i.InvoiceTotal) > 2
       AND SUM(i.InvoiceTotal) > 1000
ORDER BY i.InvoiceDate DESC;

-- 2022-12-01 and 2022-12-31

SELECT i.InvoiceDate AS [Invoice Date],
       COUNT(i.InvoiceTotal) AS [Invoice Qty],
       SUM(i.InvoiceTotal) AS [Invoice Sum]
FROM dbo.Invoices i
WHERE i.InvoiceDate
BETWEEN '2022-12-01' AND '2022-12-31'
GROUP BY i.InvoiceDate
HAVING COUNT(i.InvoiceTotal) > 2
       AND SUM(i.InvoiceTotal) > 1000
ORDER BY i.InvoiceDate DESC;


-- 7 
/**
Construct a nested subquery that returns a list of Invoice Number, Invoice Date and Invoice Total columns for vendors in the state of Texas (TX). The inner query must use the Vendors table. Sort the result by Invoice Date in descending order.
*/
PRINT '*** Question 7 ***';
PRINT '';

SELECT i.InvoiceNumber,
       i.InvoiceDate,
       i.InvoiceTotal
FROM dbo.Invoices i
WHERE i.VendorID IN
(
    SELECT v.VendorID FROM dbo.Vendors v WHERE v.VendorState = 'TX'
)
ORDER BY i.InvoiceDate DESC;

-- 8
/**
Construct a nested subquery that returns a list of invoices for a vendor with Invoice Total above the Average Invoice Total for that vendor. Use a correlated subquery in the WHERE clause. Only include invoices with Invoice Total above $1,000. Order the results by Vendor ID in ascending order, followed by Invoice Total in descending order. 
*/
PRINT '*** Question 8 ***';
PRINT '';

SELECT i.VendorID,
       i.InvoiceNumber,
       i.InvoiceTotal
FROM dbo.Invoices i
WHERE i.InvoiceTotal > 1000
      AND i.InvoiceTotal >
      (
          SELECT AVG(i2.InvoiceTotal)
          FROM dbo.Invoices i2
          WHERE i.VendorID = i2.VendorID
      )
ORDER BY i.VendorID ASC,
         i.InvoiceTotal DESC;



-- 9 
/**
Construct a correlated subquery in the SELECT clause. Display the Vendor Name from the Vendors table and the “Latest Invoice Date” from the Invoices table. Show the Vendor Name and “Latest Invoice Date” only once (i.e., no duplicates). Only display rows with Vendor Name that starts with ‘C’. Sort the result by the “Latest Invoice Date” in ascending order. Note: Do not use a LEFT JOIN similar to the restated query in Figure 6- 10b.sql.
*/
PRINT '*** Question 9 ***';
PRINT '';

SELECT DISTINCT
    v.VendorName,
    (SELECT MAX(i.InvoiceDate)
     FROM Invoices i
     WHERE i.VendorID = v.VendorID) AS LatestInvoiceDate
FROM
    Vendors v
WHERE
    v.VendorName LIKE 'C%'
ORDER BY
    LatestInvoiceDate ASC;


