CREATE DATABASE library;
USE library;

CREATE TABLE Branch (
Branch_no INT PRIMARY KEY,
Manager_Id INT,
Branch_address VARCHAR(255),
contact_no VARCHAR(255)
);

CREATE TABLE Employee(
Emp_Id INT PRIMARY KEY,
Emp_name VARCHAR(255),
Position VARCHAR(255),
Salary DECIMAL(10, 2),
Branch_no INT,
FOREIGN KEY(Branch_no) REFERENCES Branch(Branch_no)
);

CREATE TABLE Customer (
Customer_Id INT PRIMARY KEY,
Customer_name VARCHAR(255),
Customer_address VARCHAR(255),
Reg_date DATE
);


CREATE TABLE Books (
ISBN VARCHAR(13) PRIMARY KEY,
Book_title VARCHAR(255),
Category VARCHAR(255),
Rental_Price DECIMAL(10, 2),
Status_ ENUM('yes', 'no'),
Author VARCHAR(255),
Publisher VARCHAR(255)
);

CREATE TABLE IssueStatus (
Issue_Id INT PRIMARY KEY,
Issued_cust INT,
Issued_book_name VARCHAR(255),
Issue_date DATE,
Isbn_book VARCHAR(13),
FOREIGN KEY (Issued_cust) REFERENCES Customer(Customer_Id),
FOREIGN KEY (Isbn_book) REFERENCES Books(ISBN)
);


CREATE TABLE ReturnStatus (
Return_Id INT PRIMARY KEY,
Return_cust INT,
Return_book_name VARCHAR(255),
Return_date DATE,
Isbn_book2 VARCHAR(13),
FOREIGN KEY (Return_cust) REFERENCES Customer(Customer_Id),
FOREIGN KEY (Isbn_book2) REFERENCES Books(ISBN)
);

DESC Branch;
DESC employee;
DESC Customer;
DESC IssueStatus;
DESC ReturnStatus;
DESC Books;

INSERT INTO Branch
VALUES
(1,100,'30 Corner Road, New York, NY 10012','212-312-1234'),
(2,102,'31 Corner Road, New York, NY 10012','212-312-2345'),
(3,104,'32 Corner Road, New York, NY 10012','212-312-3456'),
(4,103,'33 Corner Road, New York, NY 10012','212-312-4567'),
(5,101,'34 Corner Road, New York, NY 10012','212-312-5678'),
(6,103,'35 Corner Road, New York, NY 10012','212-312-6789'),
(7,102,'36 Corner Road, New York, NY 10012','212-312-7891'),
(8,100,'37 Corner Road, New York, NY 10012','212-312-8912');


INSERT INTO employee
VALUES
(11,'Tarek Hossain','Lib_mgr',81000,2),
(12,'Tina dabi','Lib_mgr',49000,4),
(13,'pritan','Lib_clerk',20000,1),
(14,'sachdev','Lib_assistant',55000,8);

INSERT INTO Customer
VALUES
(0001,'shalu','shalus home, New York','2022-07-06'),
(0002,'shanu','789 street, New York','2008-07-09'),
(0003,'piku','merut home, New York','2021-09-16'),
(0005,'hakim','shalus home, choori','2019-08-25'),
(0006,'ritu','sweet home, New York','2023-04-21'),
(0007,'akash','st home, New York','2024-01-01');


INSERT INTO Books
VALUES
('A001', 'Let Us C', 'Science',50, 'yes','Yashavant Kanetkar ','BPB Publications'),
('A009', 'Java: The Complete Reference', 'Science',30, 'yes','Herbert Schildt','Mc Grawhill'),
('A002', 'The India Story', 'fiction',40, 'no','Bimal Jalal ','penguin publications'),
('A003', 'Harry Potter and the Half-Blood Prince', 'fiction',60, 'no','J.K. Rowling ','Mc Grawhill'),
('A005', 'The Subtle Art of Not Giving a Fck', 'self-help',40, 'yes','Mark Manson','penguin publications'),
('A006', 'Atomic Habits', 'self-help',30, 'no','James Clear','BPB Publications'),
('A007', 'Java: The Complete Reference', 'Science',30, 'yes','Herbert Schildt','Mc Grawhill'),
('A008', 'Computer Networks', 'Science',40, 'yes','Saurabh Singhal ','Thakur Publications ');


INSERT INTO IssueStatus
VALUES
(0101,0005,'Java: The Complete Reference','2019-12-12','A009'),
(0104,0005,'Computer Networks','2020-02-12','A008'),
(0103,0006,'The India Story','2023-06-01','A002'),
(0105,0007,'Atomic Habits','2024-01-12','A006'),
(0102,0001,'Computer Networks','2022-09-25','A008'),
(0106,0002,'The Subtle Art of Not Giving a Fck','2009-02-27','A005'),
(0109,0003,'Java: The Complete Reference','2022-04-17','A007');


INSERT INTO ReturnStatus
VALUES
(4001,0005,'Java: The Complete Reference','2020-08-09','A009'),
(4002,0005,'Computer Networks','2020-03-19','A008'),
(4003,0001,'Computer Networks','2023-01-03','A008'),
(4004,0002,'The Subtle Art of Not Giving a Fck','2010-02-14','A005'),
(4005,0003,'Java: The Complete Reference','2022-08-29','A007');

SELECT * FROM  Branch;
SELECT * FROM  employee;
SELECT * FROM  Customer;
SELECT * FROM  IssueStatus;
SELECT * FROM  ReturnStatus;
SELECT * FROM  Books;

-- 1) Retrieve the book title, category, and rental price of all available books.
SELECT Book_title, Category, Rental_price FROM Books
WHERE Status_='yes';

-- 2) List the employee names and their respective salaries in descending order of salary.
SELECT Emp_name,Salary FROM employee
ORDER BY SALARY DESC;

-- 3) Retrieve the book titles and the corresponding customers who have issued those books.
SELECT i.Issued_book_name , c.Customer_name
FROM IssueStatus i
JOIN Customer c
ON i.Issued_cust=c.Customer_Id;

-- 4)  Display the total count of books in each category.
SELECT Category, COUNT(Category)counts FROM Books
GROUP BY Category;

-- 5)  Retrieve the employee names and their positions for the employees whose salaries are above Rs.50,000.
SELECT Emp_name ,Position FROM employee
WHERE salary>50000;

-- 6) List the customer names who registered before 2022-01-01 and have not issued any books yet.
SELECT Customer_name from Customer
WHERE Reg_date < '2022-01-01'
AND Customer_Id
NOT IN(SELECT DISTINCT Issued_cust FROM IssueStatus);

-- 7) Display the branch numbers and the total count of employees in each branch.
SELECT b.Branch_no,e.counts
FROM Branch b
LEFT JOIN
(SELECT Branch_no,COUNT(Emp_id) counts FROM employee
GROUP BY Branch_no) e
ON e.Branch_no=b.branch_no;

-- 8)  Display the names of customers who have issued books in the month of June 2023.
SELECT c.Customer_name,i.Issue_date
FROM Customer c
JOIN IssueStatus i 
ON i.Issued_cust=c.Customer_Id
WHERE month(i.Issue_date)=6 AND year(i.Issue_date)=2023;

-- 9) Retrieve book_title from book table containing history.
SELECT Book_title FROM Books
WHERE Category = 'history';

-- 10)Retrieve the branch numbers along with the count of employees for branches having more than 5 employees
SELECT Branch_no,COUNT(Emp_id) total_employee FROM employee
GROUP BY Branch_no
HAVING total_employee>5;