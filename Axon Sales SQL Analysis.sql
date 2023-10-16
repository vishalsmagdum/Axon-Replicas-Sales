-- Unique customers
SELECT COUNT(DISTINCT customerNumber) AS Unique_Customers FROM orders;

-- Total Quantity ordered
SELECT SUM(quantityOrdered) AS Total_Quantity FROM orderdetails;

-- Total sales
SELECT SUM(quantityOrdered * priceEach) AS Total_Sales FROM orderdetails;

-- Actaul Sales
SELECT SUM(quantityOrdered * buyPrice) AS Actual_Sales
FROM orderdetails o
JOIN products p ON o.productCode=p.productCode;

-- Total Profit
SELECT 
    Total_Sales,
    Actual_Sales,
    (Total_Sales - Actual_Sales) AS Profit
FROM (
    SELECT 
        SUM(quantityordered * priceEach) AS Total_Sales,
        SUM(quantityordered * buyprice) AS Actual_Sales
    FROM orderdetails 
    INNER JOIN products ON products.productcode=orderdetails.productCode
)Profit;

-- Top 7 Order count by Year and Month
SELECT LEFT(orderDate, 7) AS Year_Mon,
COUNT(DISTINCT ordl.orderNumber) AS Distinct_Orders 
FROM orders ord 
JOIN orderdetails ordl ON ord.orderNumber=ordl.orderNumber
GROUP BY Year_Mon
ORDER BY Distinct_Orders DESC
LIMIT 7;

-- Top 10 Total Sales by Year and Month
SELECT LEFT(orderDate, 7) AS Year_Mon,
SUM(quantityordered * priceEach) AS Total_Sales 
FROM orders ord 
JOIN orderdetails ordl ON ord.orderNumber=ordl.orderNumber
GROUP BY Year_Mon
ORDER BY Total_Sales DESC
LIMIT 10;

-- Top 5 Customers by Total Sales
SELECT customerName, 
SUM(quantityordered * priceEach) AS Total_Sales
FROM orders ord 
JOIN orderdetails ordl ON ord.orderNumber=ordl.orderNumber
JOIN customers c ON ord.customerNumber=c.customerNumber
GROUP BY customerName
ORDER BY Total_Sales DESC
LIMIT 5;

-- Product Line by Actual Sales
SELECT productLine, 
SUM(quantityordered * buyprice) AS Actual_Sales
FROM orders ord 
JOIN orderdetails ordl ON ord.orderNumber=ordl.orderNumber
JOIN customers c ON ord.customerNumber=c.customerNumber
JOIN products p ON ordl.productCode=p.productCode
GROUP BY productLine
ORDER BY Actual_Sales DESC
LIMIT 10;

-- Bottom 10 Products by Total Sales
SELECT productName, 
SUM(quantityordered * priceEach) AS Total_Sales
FROM orders ord 
JOIN orderdetails ordl ON ord.orderNumber=ordl.orderNumber
JOIN customers c ON ord.customerNumber=c.customerNumber
JOIN products p ON ordl.productCode=p.productCode
GROUP BY productName
ORDER BY Total_Sales
LIMIT 10;

-- Top 10 Employees with their order count
ALTER TABLE customers
CHANGE salesRepEmployeeNumber employeeNumber INT;

SELECT CONCAT(e.firstName, ' ', e.lastName) AS Employee_Name,
COUNT(ordl.orderNumber) AS Order_Count
FROM employees e 
JOIN customers c ON e.employeeNumber=c.employeeNumber
JOIN orders ord ON c.customerNumber=ord.customerNumber
JOIN orderdetails ordl ON ord.orderNumber=ordl.orderNumber
GROUP BY Employee_Name
ORDER BY Order_Count DESC
LIMIT 10;

-- Total Sales, Actual Sales, Quantity ordered by Country
SELECT country, 
COUNT(o.orderNumber) AS Quantity_Ordered,
SUM(quantityordered * priceEach) AS Total_Sales,
SUM(quantityordered * buyprice) AS Actual_Sales
FROM orderdetails o
JOIN products p ON o.productCode=p.productCode
JOIN orders ord ON o.orderNumber=ord.orderNumber
JOIN customers c ON ord.customerNumber=c.customerNumber
GROUP BY country
ORDER BY Quantity_Ordered DESC;
