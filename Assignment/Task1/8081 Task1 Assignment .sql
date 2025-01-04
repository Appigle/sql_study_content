-- ex1_LC.sql
-- Spring 2024 Exercise 1
-- Revision History:
-- Student Name, Section 1, 20240522: Created

PRINT 's24 PROG8081 Section 5';
PRINT 'Exercise 1';
PRINT '';
PRINT 'Lei Chen';
PRINT '';
PRINT GETDATE();
PRINT '';

USE AP;

-- 1. List the columns of the Terms table in the AP database.
SELECT *
FROM dbo.Terms;
SELECT *
FROM dbo.Vendors;

-- 2. List the ¡®state code¡¯ vendors are from, but show each ¡®state code¡¯ only once (i.e., no duplicates). List the results in descending order.
SELECT DISTINCT
       VendorState AS 'state code'
FROM dbo.Vendors
ORDER BY VendorState DESC;

-- 3. Display all the columns of vendors from Texas. You must use ¡®TX¡¯ as part of your solution. The expected result has a Vendor ID of 83.
SELECT *
FROM dbo.Vendors
WHERE VendorState = 'TX';

-- 4. List all the columns of invoices with a Vendor ID of 83. Do not include single quotes (¡®) or double quotes (¡°) as part of your solution. The expected result has 2 rows.
SELECT *
FROM dbo.Invoices
WHERE VendorID = 83;

-- 5. List the 5 columns (Invoice ID, Vendor ID, Invoice Total, Credit Total and Payment Total) for invoices with Invoice ID of 17. The expected result has a Vendor ID of 123.
SELECT InvoiceID,
       VendorID,
       InvoiceTotal,
       CreditTotal,
       PaymentTotal
FROM dbo.Invoices
WHERE InvoiceID = 17;

-- 6. List the 4 columns (Vendor ID, Vendor Name, Default Terms ID and a string expression that includes Vendor City, Vendor State and Vendor Zip Code separates by commas) for vendors with a Vendor ID of 123. Do not assign an alias for the string expression (i.e., no column name). Take note of the Default Terms ID.
SELECT VendorID,
       VendorName,
       DefaultTermsID,
       VendorCity + ',' + VendorState + ',' + VendorZipCode
FROM dbo.Vendors
WHERE VendorID = 123;

-- 7. Are there any outstanding invoices (i.e., unpaid invoices) for Vendor ID 123? List the 7 columns (Vendor ID, Terms ID, Invoice ID, Invoice Total, Credit Total, Payment Total and an arithmetic expression for ¡°Balance Due¡± calculated as ¡®Invoice Amount minus Credit Amount minus Payment Amount¡¯) for invoices with Vendor ID of 123 and ¡°Balance Due¡± greater than zero. Take note if there are any Terms ID that differs from the Default Terms ID from the previous question.
SELECT VendorID,
       InvoiceID,
       InvoiceTotal,
       CreditTotal,
       PaymentTotal,
       InvoiceTotal - CreditTotal - PaymentTotal AS 'Balance_Due'
FROM dbo.Invoices
WHERE VendorID = 123
      AND InvoiceTotal - CreditTotal - PaymentTotal > 0;

-- 8. List all the columns of the invoice line items with Invoice IDs listed in the previous question. Use the IN operator as part of your solution. Do not use any quotes in your solution.
SELECT *
FROM dbo.InvoiceLineItems
WHERE InvoiceID IN
      (
          SELECT InvoiceID
          FROM dbo.Invoices
          WHERE VendorID = 123
                AND InvoiceTotal - CreditTotal - PaymentTotal > 0
      );

-- 9. List the Vendor State and Vendor Contact First Name columns, followed by 6 columns using the following string functions with the Vendor Contact First Name as the argument: LEN(), LOWER(), UPPER(),LEFT(), RIGHT(), and TRIM() for vendors from Florida (FL) or Texas (TX). Do not use the IN operator as part of your solution. Hint: Review Week 2 slides 7 and 10. The column header names are as follows: VendorState, FirstName, LengthOfName, LowerCase, UpperCase, FirstThreeLetters, LastThreeLetters, and TrimmedName.
SELECT VendorState,
       VendorContactFName,
       LEN(VendorContactFName) AS LENGTH_,
       LOWER(VendorContactFName) AS LOWER_,
       UPPER(VendorContactFName) AS UPPER_,
       LEFT(VendorContactFName, 3) AS LEFT_3,
       RIGHT(VendorContactFName, 3) AS RIGHT_3,
       TRIM(VendorContactFName) AS TRIM_
FROM dbo.Vendors
WHERE VendorState = 'FL'
      OR VendorState = 'TX';


-- 10. List the 3 columns (Invoice Number, Invoice Date, and Invoice Total) for invoices with Invoice Date of January 8, 2020. You must use the MONTH(), DAY() and YEAR() functions in your WHERE clause. Hint: Study Murach¡¯s ¡°SQL Server 2019\Scripts\Chapter 09\Figure 9-08e.sql¡±.  Format the Invoice Total money column with a ¡®$¡¯, CONVERT() and CHAR(12). For the Invoice Date column, use FORMAT() with model ¡®yyyy.MM.dd¡¯. Hint: Review SCALAR.pdf slides 11 and 31.
SELECT InvoiceNumber,
       FORMAT(InvoiceDate, 'yyyy.MM.dd'),
       '$' + CONVERT(CHAR(12), InvoiceTotal, 1)
FROM dbo.Invoices
WHERE MONTH(InvoiceDate) = 1
      AND DAY(InvoiceDate) = 8
      AND YEAR(InvoiceDate) = 2020;

-- 10.1 There is no record from invoice on Jan 1, 2020, so change condition of the InvoiceDate to Jan 1, 2023
SELECT InvoiceNumber,
       FORMAT(InvoiceDate, 'yyyy.MM.dd'),
       '$' + CONVERT(CHAR(12), InvoiceTotal, 1)
FROM dbo.Invoices
WHERE MONTH(InvoiceDate) = 1
      AND DAY(InvoiceDate) = 8
      AND YEAR(InvoiceDate) = 2023;
