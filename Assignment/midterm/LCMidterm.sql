USE ap;

/**
Question 1 (2 pts) 
Write a SELECT statement without a FROM clause that uses the GETDATE() function to return the 
current date in its default format. Use the DATEFROMPARTS function to format the current date 
in this format: yyyy-mm-dd 
This displays the four-digit year, month and day of the current date. Give this column an alias of 
CURRENT_DATE.
*/
SELECT CONVERT(VARCHAR(10), DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), DAY(GETDATE())), 23) AS [CURRENT_DATE];

/**

Question 2 (4 pts) 
Write a SELECT statement that returns one column from the Vendors table named full_name that 
joins the vendor_contact_last_name and vendor_contact_first_name columns. Format this 
column with the last name, a comma, a space, and the first name like this: 
Doe, John 
Sort the result set by last name and then first name in ascending sequence. Return only the 
contacts whose last name begins with the letter A, B, C, or E. This should retrieve 41 rows.

*/
SELECT 
    VendorContactLName + ', ' + VendorContactFName AS [full_name]
FROM 
    Vendors
WHERE 
    VendorContactLName LIKE 'A%' 
    OR VendorContactLName LIKE 'B%'
    OR VendorContactLName LIKE 'C%'
    OR VendorContactLName LIKE 'E%'
ORDER BY 
    VendorContactLName , 
    VendorContactFName ASC;


/**
Question 3 (4 pts) 
Write a SELECT statement that returns two columns:  
VendorName and PaymentSum, where PaymentSum is the sum of the PaymentTotal column.  
Group the result set by VendorName. Return only 10 rows, corresponding to the 10 vendors  
who¡¯ve been paid the most. 
Hint: Use the TOP clause and join the Vendors table to the Invoices table.
*/
SELECT TOP 10 V.VendorName,
       SUM(I.PaymentTotal) AS [PaymentSum]
FROM Vendors V
    JOIN Invoices I
        ON V.VendorID = I.VendorID
GROUP BY V.VendorName
ORDER BY PaymentSum;