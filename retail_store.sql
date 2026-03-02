
-- STEP 1: Create Tables

-- ===============================
-- 1. PRODUCTS TABLE
-- ===============================

CREATE TABLE Products (
    product_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT CHECK (category IN ('Electronics', 'Clothing', 'Grocery', 'Furniture')),
    price REAL NOT NULL CHECK (price > 0),
    stock_quantity INTEGER CHECK (stock_quantity >= 0)
);

-- ===============================
-- 2. CUSTOMERS TABLE
-- ===============================

CREATE TABLE Customers (
    customer_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT UNIQUE NOT NULL,
    address TEXT DEFAULT 'Not Provided'
);

-- ===============================
-- 3. ORDERS TABLE
-- ===============================

CREATE TABLE Orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date DATE DEFAULT CURRENT_DATE,
    total_amount REAL CHECK (total_amount > 0),
    Remarks_if_any TEXT DEFAULT 'No Remarks',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);


-- STEP 2: Insert Data
-- ===============================
-- INSERT INTO CUSTOMERS
-- ===============================

INSERT INTO Customers (customer_id, name, email, phone, address) VALUES
(1, 'John Doe', 'john.doe@email.com', '9876543210', '123 Main St'),
(2, 'Jane Smith', 'jane.smith@email.com', '9823456789', '45 Elm St'),
(3, 'Alice Brown', 'alice.b@email.com', '9988776655', '78 Pine Ave'),
(4, 'Bob Johnson', 'bob.j@email.com', '9765432109', '90 Oak Lane'),
(5, 'Charlie Lee', 'charlie.l@email.com', '9234567890', 'Not Provided'),
(6, 'David White', 'david.w@email.com', '9678991234', '12 Maple St'),
(7, 'Emily Clark', 'emily.c@email.com', '9345678901', 'Not Provided'),
(8, 'Frank Harris', 'frank.h@email.com', '9763214785', '56 Birch Road'),
(9, 'Grace Kelly', 'grace.k@email.com', '9456123870', '32 Cedar Ave'),
(10, 'Henry Adams', 'henry.a@email.com', '9312465789', '22 Walnut Lane');

-- ===============================
-- INSERT INTO PRODUCTS
-- ===============================

INSERT INTO Products (product_id, name, category, price, stock_quantity) VALUES
(101, 'Apple iPhone 15', 'Electronics', 999.99, 10),
(102, 'Samsung Galaxy S23', 'Electronics', 899.99, 15),
(103, 'Leather Jacket', 'Clothing', 149.99, 25),
(104, 'HP Laptop', 'Electronics', 799.99, 8),
(105, 'Wooden Dining Table', 'Furniture', 499.99, 5),
(106, 'Nike Running Shoes', 'Clothing', 129.99, 20),
(107, 'LED TV 55"', 'Electronics', 699.99, 12),
(108, 'Rice 10kg', 'Grocery', 25.99, 50),
(109, 'Sofa Set (3+1+1)', 'Furniture', 999.99, 4),
(110, 'Organic Honey 500ml', 'Grocery', 15.99, 30);

-- ===============================
-- INSERT INTO ORDERS
-- ===============================

INSERT INTO Orders (order_id, customer_id, order_date, total_amount, Remarks_if_any) VALUES
(1001, 1, '2024-01-15', 999.99, 'No Remarks'),
(1002, 2, '2024-01-16', 299.98, 'Delivered'),
(1003, 3, '2024-01-17', 129.99, 'Payment Pending'),
(1004, 4, '2024-01-18', 899.99, 'No Remarks'),
(1005, 5, '2024-01-19', 799.99, 'Cancelled'),
(1006, 6, '2024-01-20', 499.99, 'Delivered'),
(1007, 7, '2024-01-21', 129.99, 'No Remarks'),
(1008, 8, '2024-01-22', 699.99, 'Refund Issued'),
(1009, 9, '2024-01-23', 25.99, 'No Remarks'),
(1010, 10, '2024-01-24', 15.99, 'Delivered');



-- STEP 3: Data Retrieval Queries
-- First 3 records
SELECT * FROM Customers LIMIT 3;
SELECT * FROM Products LIMIT 3;
SELECT * FROM Orders LIMIT 3;

-- Distinct categories
SELECT DISTINCT category FROM Products;

-- Orders above 900
SELECT * FROM Orders WHERE total_amount > 900;

-- Top 2 expensive products
SELECT * FROM Products ORDER BY price DESC LIMIT 2;

-- Customers without address
SELECT * FROM Customers WHERE address = 'Not Provided';



-- STEP 4: Updates & Alter
-- Increase Electronics price by 10%
UPDATE Products
SET price = price * 1.10
WHERE category = 'Electronics';

-- Add discount column
ALTER TABLE Orders ADD COLUMN discount REAL DEFAULT 0;

-- Apply 5% discount for orders > 900
UPDATE Orders
SET discount = total_amount * 0.05
WHERE total_amount > 900;

-- Add new column to Customers
ALTER TABLE Customers
ADD COLUMN new_address TEXT DEFAULT 'Unknown';

-- Set Unknown to NULL
UPDATE Customers
SET new_address = NULL
WHERE new_address = 'Unknown';

-- Update specific customer
UPDATE Customers
SET new_address = '23 Walnut Lane'
WHERE customer_id = 10 AND new_address IS NULL;

-- Replace 'No Remarks' with NULL
UPDATE Orders
SET Remarks_if_any = NULL
WHERE Remarks_if_any = 'No Remarks';



-- STEP 5: Delete Operations
-- Delete products out of stock
DELETE FROM Products
WHERE stock_quantity = 0;

-- Delete old orders
DELETE FROM Orders
WHERE order_date < '2024-01-20';

-- Delete customers without orders
DELETE FROM Customers
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM Orders);

-- Delete small orders
DELETE FROM Orders
WHERE total_amount < 150;


-- STEP 6: Aggregations
-- Total revenue
SELECT SUM(total_amount) AS total_revenue FROM Orders;

-- Average spending
SELECT AVG(total_amount) AS avg_spending_per_customer FROM Orders;

-- Orders per month
SELECT strftime('%Y-%m', order_date) AS order_month,
       COUNT(order_id) AS total_orders
FROM Orders
GROUP BY order_month
ORDER BY order_month;

-- Most expensive product
SELECT name, price
FROM Products
WHERE price = (SELECT MAX(price) FROM Products);

--STEP 7: Date Functions
-- Orders in January 2024
SELECT order_id, customer_id, order_date
FROM Orders
WHERE strftime('%Y-%m', order_date) = '2024-01';

-- Most recent order
SELECT MAX(order_date) AS most_recent_order
FROM Orders;

-- Orders between specific dates
SELECT order_date, COUNT(*) AS order_count
FROM Orders
WHERE order_date BETWEEN '2024-01-15' AND '2024-01-17'
GROUP BY order_date;

-- Days between first and last order
SELECT JULIANDAY(MAX(order_date)) - JULIANDAY(MIN(order_date)) AS days_between
FROM Orders;

-- Orders in last 5 days from 24th
SELECT order_id, customer_id, order_date, total_amount
FROM Orders
WHERE order_date BETWEEN DATE('2024-01-24', '-5 days') AND '2024-01-24';




