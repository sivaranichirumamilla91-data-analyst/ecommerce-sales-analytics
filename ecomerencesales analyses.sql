create database E_CommerceSales
go
use E_CommerceSales
go
CREATE TABLE Customers
(
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    City VARCHAR(50),
    State VARCHAR(50),
    Country VARCHAR(50)
);
INSERT INTO Customers VALUES
(101, 'Ravi Kumar', 'Hyderabad', 'Telangana', 'India'),
(102, 'Priya Sharma', 'Bangalore', 'Karnataka', 'India'),
(103, 'Anil Reddy', 'Chennai', 'Tamil Nadu', 'India'),
(104, 'Sneha Rao', 'Mumbai', 'Maharashtra', 'India'),
(105, 'Rahul Verma', 'Delhi', 'Delhi', 'India'),
(106, 'Kiran Patel', 'Ahmedabad', 'Gujarat', 'India'),
(107, 'Meena Das', 'Kolkata', 'West Bengal', 'India'),
(108, 'Arjun Singh', 'Pune', 'Maharashtra', 'India'),
(109, 'Divya Reddy', 'Hyderabad', 'Telangana', 'India'),
(110, 'Suresh Kumar', 'Bangalore', 'Karnataka', 'India');
select * from Customers

CREATE TABLE Products
(
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);
INSERT INTO Products VALUES
(201, 'Laptop', 'Electronics', 55000),
(202, 'Mobile Phone', 'Electronics', 25000),
(203, 'Headphones', 'Electronics', 3000),
(204, 'Office Chair', 'Furniture', 8000),
(205, 'Desk', 'Furniture', 12000),
(206, 'Keyboard', 'Accessories', 1500),
(207, 'Mouse', 'Accessories', 800),
(208, 'Monitor', 'Electronics', 18000),
(209, 'Printer', 'Electronics', 15000),
(210, 'Table Lamp', 'Furniture', 2500);
select * from Products

CREATE TABLE Orders
(
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    OrderStatus VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
select * from Orders
INSERT INTO Orders VALUES
(1001, 101, '2026-01-05', 'Completed'),
(1002, 102, '2026-01-10', 'Completed'),
(1003, 103, '2026-01-15', 'Pending'),
(1004, 104, '2026-02-02', 'Completed'),
(1005, 105, '2026-02-10', 'Cancelled'),
(1006, 106, '2026-02-18', 'Completed'),
(1007, 107, '2026-03-05', 'Completed'),
(1008, 108, '2026-03-12', 'Pending'),
(1009, 109, '2026-03-20', 'Completed'),
(1010, 110, '2026-04-01', 'Completed'),
(1011, 101, '2026-04-15', 'Completed'),
(1012, 103, '2026-05-05', 'Completed'),
(1013, 105, '2026-05-20', 'Completed'),
(1014, 107, '2026-06-10', 'Completed'),
(1015, 109, '2026-06-25', 'Completed');

CREATE TABLE OrderDetails
(
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),

    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
INSERT INTO OrderDetails VALUES
(1,  1001, 201, 1, 55000),
(2,  1001, 203, 2, 3000),
(3,  1002, 202, 1, 25000),
(4,  1002, 206, 2, 1500),
(5,  1003, 204, 1, 8000),
(6,  1004, 205, 1, 12000),
(7,  1004, 207, 2, 800),
(8,  1005, 208, 1, 18000),
(9,  1006, 209, 1, 15000),
(10, 1006, 203, 1, 3000),
(11, 1007, 201, 1, 55000),
(12, 1008, 202, 2, 25000),
(13, 1009, 204, 2, 8000),
(14, 1010, 205, 1, 12000),
(15, 1011, 208, 2, 18000),
(16, 1012, 206, 3, 1500),
(17, 1013, 207, 5, 800),
(18, 1014, 209, 1, 15000),
(19, 1015, 210, 2, 2500),
(20, 1015, 203, 1, 3000);

select * from OrderDetails

Find the total sales amount for each customers

SELECT c.CustomerID,
       c.CustomerName,
       SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM Orders as o join OrderDetails as od on o.OrderID =od.OrderID join Customers as c on c.CustomerID=o.CustomerID
group by c.CustomerID,
       c.CustomerName

	  2) Find the Top 3 Customers based on Total Sales.
	  WITH CTE AS
(
    SELECT c.CustomerID,
           c.CustomerName,
           SUM(od.Quantity * od.UnitPrice) AS TotalSales
    FROM Orders AS o
    JOIN OrderDetails AS od
        ON o.OrderID = od.OrderID
    JOIN Customers AS c
        ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
),
RankedCustomers AS
(
    SELECT *,
           DENSE_RANK() OVER (ORDER BY TotalSales DESC) AS rnk
    FROM CTE
)
SELECT *
FROM RankedCustomers
WHERE rnk <= 3;

3)Find the product with the highest total quantity sold.
WITH CTE AS
(
    SELECT p.ProductID,
           p.ProductName,
           p.Category,
           SUM(od.Quantity) AS TotalQuantity
    FROM Products AS p
    JOIN OrderDetails AS od
        ON p.ProductID = od.ProductID
    GROUP BY p.ProductID,
             p.ProductName,
             p.Category
),
RankedProducts AS
(
    SELECT *,
           DENSE_RANK() OVER (ORDER BY TotalQuantity DESC) AS rnk
    FROM CTE
)
SELECT *
FROM RankedProducts
WHERE rnk = 1;

4)Find the total sales for each month.
SELECT YEAR(o.OrderDate) AS SalesYear,
       MONTH(o.OrderDate) AS SalesMonth,
       SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM Orders AS o
JOIN OrderDetails AS od
    ON o.OrderID = od.OrderID
GROUP BY YEAR(o.OrderDate),
         MONTH(o.OrderDate)
ORDER BY SalesYear,
         SalesMonth;
		 5)Customers with No Orders
		 SELECT c.*
FROM Customers AS c
LEFT JOIN Orders AS o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;
6)Find the total number of orders and total sales for each customer.
A)SELECT c.CustomerName,
       COUNT(DISTINCT o.OrderID) AS TotalOrders,
       SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM Orders AS o
JOIN OrderDetails AS od
    ON o.OrderID = od.OrderID
JOIN Customers AS c
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerName;
7)Find the total sales for each product category.
SELECT p.Category,
       SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM Products AS p
JOIN OrderDetails AS od
    ON p.ProductID = od.ProductID
GROUP BY p.Category;

8)Find the highest-priced product in each category.
with cte as (select *,DENSE_RANK()over(PARTITION by category order by price desc)as rnk from Products)
select * from cte where rnk=1

9)Find customers whose total sales are greater than ₹50,000.
SELECT c.CustomerID,
       c.CustomerName,
       SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM Orders AS o
JOIN OrderDetails AS od
    ON o.OrderID = od.OrderID
JOIN Customers AS c
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID,
         c.CustomerName
HAVING SUM(od.Quantity * od.UnitPrice) > 50000;
10)Find the second-highest priced product in each category.
A) SELECT *
FROM
(
    SELECT p.*,
           DENSE_RANK() OVER
           (
               PARTITION BY Category
               ORDER BY Price DESC
           ) AS rnk
    FROM Products AS p
) AS CTE
WHERE rnk = 2;
11)Find the customer who placed the highest number of orders.
A)WITH CTE AS
(
    SELECT c.CustomerID,
           c.CustomerName,
           COUNT(DISTINCT o.OrderID) AS TotalOrders
    FROM Customers AS c
    JOIN Orders AS o
        ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID,
             c.CustomerName
),
RankedCustomers AS
(
    SELECT *,
           DENSE_RANK() OVER (
               ORDER BY TotalOrders DESC
           ) AS rnk
    FROM CTE
)
SELECT *
FROM RankedCustomers
WHERE rnk = 1;
12)Find customers who placed orders in more than one different month.
A)SELECT c.CustomerID,
       c.CustomerName,
       COUNT(DISTINCT MONTH(o.OrderDate)) AS MonthSales
FROM Customers AS c
JOIN Orders AS o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(DISTINCT MONTH(o.OrderDate)) > 1;
Q13. Find the customer who has spent the highest amount on a single order.
WITH CTE AS
(
    SELECT o.OrderID,
           c.CustomerID,
           c.CustomerName,
           SUM(od.Quantity * od.UnitPrice) AS Total
    FROM Orders AS o
    JOIN OrderDetails AS od
        ON o.OrderID = od.OrderID
    JOIN Customers AS c
        ON c.CustomerID = o.CustomerID
    GROUP BY o.OrderID,
             c.CustomerID,
             c.CustomerName
),
CTE1 AS
(
    SELECT *,
           DENSE_RANK() OVER (ORDER BY Total DESC) AS rnk
    FROM CTE
)
SELECT *
FROM CTE1
WHERE rnk = 1;
Q14. Find the customer who placed the order with the highest total amount.
WITH CTE AS
(
    SELECT c.CustomerID,
           c.CustomerName,
           o.OrderID,
           SUM(od.Quantity * od.UnitPrice) AS Total
    FROM Orders AS o
    JOIN OrderDetails AS od
        ON o.OrderID = od.OrderID
    JOIN Customers AS c
        ON o.CustomerID = c.CustomerID
    GROUP BY c.CustomerID,
             c.CustomerName,
             o.OrderID
),
CTE1 AS
(
    SELECT *,
           DENSE_RANK() OVER (ORDER BY Total DESC) AS rnk
    FROM CTE
)
SELECT *
FROM CTE1
WHERE rnk = 1;
Q13. Find the product that generated the highest total sales.
WITH CTE AS
(
    SELECT p.ProductID,
           p.ProductName,
           SUM(od.Quantity * od.UnitPrice) AS Total
    FROM Products AS p
    JOIN OrderDetails AS od
        ON p.ProductID = od.ProductID
    GROUP BY p.ProductID, p.ProductName
),
CTE1 AS
(
    SELECT *,
           DENSE_RANK() OVER (ORDER BY Total DESC) AS rnk
    FROM CTE
)
SELECT *
FROM CTE1
WHERE rnk = 1;

Q15. Find customers whose total sales are greater than the average customer sales.
WITH CTE AS
(
    SELECT c.CustomerID,
           SUM(od.Quantity * od.UnitPrice) AS Total
    FROM Orders AS o
    JOIN OrderDetails AS od
        ON o.OrderID = od.OrderID
    JOIN Customers AS c
        ON o.CustomerID = c.CustomerID
    GROUP BY c.CustomerID
),
CTE1 AS
(
    SELECT AVG(Total) AS AvgSales
    FROM CTE
)
SELECT c.*
FROM CTE AS c
CROSS JOIN CTE1 AS a
WHERE c.Total > a.AvgSales;
Q16. Find the second-highest selling customer based on total sales.
WITH CTE AS
(
    SELECT c.CustomerID,
           SUM(od.Quantity * od.UnitPrice) AS TotalSales
    FROM Orders AS o
    JOIN OrderDetails AS od
        ON o.OrderID = od.OrderID
    JOIN Customers AS c
        ON o.CustomerID = c.CustomerID
    GROUP BY c.CustomerID
),
CTE1 AS
(
    SELECT *,
           DENSE_RANK() OVER (ORDER BY TotalSales DESC) AS rnk
    FROM CTE
)
SELECT *
FROM CTE1
WHERE rnk = 2;

17. Find the customer with the highest number of completed orders.
WITH CTE AS
(
    SELECT c.CustomerID,
           c.CustomerName,
           COUNT(o.OrderID) AS CompletedOrders
    FROM Orders AS o
    JOIN Customers AS c
        ON o.CustomerID = c.CustomerID
    WHERE o.OrderStatus = 'Completed'
    GROUP BY c.CustomerID, c.CustomerName
),
CTE1 AS
(
    SELECT *,
           DENSE_RANK() OVER (ORDER BY CompletedOrders DESC) AS rnk
    FROM CTE
)
SELECT *
FROM CTE1
WHERE rnk = 1;
18)Find products that have never been ordered.
SELECT p.ProductID,
       p.ProductName
FROM Products AS p
LEFT JOIN OrderDetails AS od
    ON p.ProductID = od.ProductID
WHERE od.ProductID IS NULL;
19)Find the customer who has placed orders in every month from January to June.
SELECT c.CustomerID,
       c.CustomerName,
       COUNT(DISTINCT MONTH(o.OrderDate)) AS MonthCount
FROM Customers AS c
JOIN Orders AS o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID,
         c.CustomerName
HAVING COUNT(DISTINCT MONTH(o.OrderDate)) = 6;
20)Find the top-selling product in each category based on total sales.
WITH CTE AS
(
    SELECT p.ProductID,
           p.ProductName,
           p.Category,
           SUM(od.Quantity * od.UnitPrice) AS TotalSales
    FROM Products AS p
    JOIN OrderDetails AS od
        ON p.ProductID = od.ProductID
    GROUP BY p.ProductID,
             p.ProductName,
             p.Category
),
CTE1 AS
(
    SELECT *,
           DENSE_RANK() OVER (
               PARTITION BY Category
               ORDER BY TotalSales DESC
           ) AS rnk
    FROM CTE
)
SELECT *
FROM CTE1
WHERE rnk = 1;
