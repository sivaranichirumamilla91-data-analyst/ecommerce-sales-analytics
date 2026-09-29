
create database salary
go
use salary 
go
INSERT INTO Employee VALUES

(101, 'Ravi', 'IT', 60000),
(102, 'Priya', 'HR', 50000),
(103, 'Anil', 'IT', 80000),
(104, 'Sita', 'Finance', 70000),
(105, 'Rahul', 'IT', 80000),
(106, 'Neha', 'HR', 55000),
(107, 'Kiran', 'Finance', 65000),
(108, 'Meena', 'IT', 75000),
(109, 'Arjun', 'Finance', 70000),
(110, 'Divya', 'HR', 60000);
CREATE TABLE Employee
(
    EmpID INT,
    EmpName VARCHAR(50),
    Department VARCHAR(50),
    Salary INT
	);
	INSERT INTO Employee VALUES
(101, 'Ravi', 'IT', 60000),
(102, 'Priya', 'HR', 50000),
(103, 'Anil', 'IT', 80000),
(104, 'Sita', 'Finance', 70000),
(105, 'Rahul', 'IT', 80000),
(106, 'Neha', 'HR', 55000),
(107, 'Kiran', 'Finance', 65000),
(108, 'Meena', 'IT', 75000),
(109, 'Arjun', 'Finance', 70000),
(110, 'Divya', 'HR', 60000);
--Find the 2nd highest salary from the Employee table.
with cte as (select *,DENSE_RANK()over(order by salary desc)as rnk from Employee) select * from
cte where rnk=2