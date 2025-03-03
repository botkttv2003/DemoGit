﻿--------------------------Bài 1-------------------------------------------------
-- Tạo bảng Orders
CREATE TABLE Orders (
    order_id INT,
    order_date DATE,
    quantity INT
);

-- Thêm dữ liệu vào bảng Orders
INSERT INTO Orders (order_id, order_date, quantity)
VALUES 
	(1, '2009-01-15', 50),
	(2, '2009-02-10', 30),
	(3, '2009-03-05', 40),
	(4, '2009-05-20', 20);

SELECT *
FROM Orders

-- Tạo bảng Returns
CREATE TABLE Returns (
    return_id INT,
    order_id INT,
    return_date DATE,
    return_quantity INT
);
-- Thêm dữ liệu vào bảng Returns
INSERT INTO Returns (
				return_id,
				order_id,
				return_date,
				return_quantity
)
VALUES 
	(1, 1, '2009-01-20', 10),
	(2, 3, '2009-03-10', 5),
	(3, 4, '2009-05-25', 3);

SELECT *
FROM Returns


-- Phương pháp CTE
WITH MonthlyOrders AS (
    SELECT 
        YEAR(order_date) AS year,
        MONTH(order_date) AS month,
        SUM(quantity) AS total_orders
    FROM Orders
    GROUP BY YEAR(order_date), MONTH(order_date)
),
MonthlyReturns AS (
    SELECT 
        YEAR(r.return_date) AS year,
        MONTH(r.return_date) AS month,
        SUM(r.return_quantity) AS total_returns
    FROM Returns r
    INNER JOIN Orders o ON r.order_id = o.order_id
    GROUP BY YEAR(r.return_date), MONTH(r.return_date)
)
SELECT 
    o.year,
    o.month,
    o.total_orders,
    COALESCE(r.total_returns, 0) AS total_returns
FROM MonthlyOrders o
LEFT JOIN MonthlyReturns r
ON o.year = r.year AND o.month = r.month;

-- Phương pháp Subquery
SELECT 
    o.year,
    o.month,
    o.total_orders,
    COALESCE(r.total_returns, 0) AS total_returns
FROM (
    SELECT 
        YEAR(order_date) AS year,
        MONTH(order_date) AS month,
        SUM(quantity) AS total_orders
    FROM Orders
    GROUP BY YEAR(order_date), MONTH(order_date)
) o
LEFT JOIN (
    SELECT 
        YEAR(r.return_date) AS year,
        MONTH(r.return_date) AS month,
        SUM(r.return_quantity) AS total_returns
    FROM Returns r
    INNER JOIN Orders o ON r.order_id = o.order_id
    GROUP BY YEAR(r.return_date), MONTH(r.return_date)
) r
ON o.year = r.year AND o.month = r.month;


-------------------------Bài 2---------------------------------------------
-- Tạo bảng Orders
CREATE TABLE Orders2 (
    order_id INT,
    order_date DATE,
    product_category VARCHAR(50),
    total_value DECIMAL(15, 2)
);

SELECT *
FROM Orders2


-- Thêm dữ liệu vào bảng Orders
INSERT INTO Orders2 (
			order_id,
			order_date,
			product_category,
			total_value
)
VALUES 
	(1, '2009-01-15', 'Furniture', 200000.00),
	(2, '2009-01-20', 'Office Supplies', 107000.00),
	(3, '2009-02-10', 'Furniture', 130000.00),
	(4, '2009-02-18', 'Technology', 145000.00);

-- Tạo bảng Returns
CREATE TABLE Returns2 (
	return_id INT,
	order_id INT,
	return_date DATE,
	return_value DECIMAL(15, 2)
);

-- Thêm dữ liệu vào bảng Returns
INSERT INTO Returns2 (return_id, order_id, return_date, return_value)
VALUES 
	(1, 1, '2009-01-22', 39000.00),
	(2, 2, '2009-01-30', 25600.00),
	(3, 3, '2009-02-15', 5000.00),
	(4, 4, '2009-02-25', 3500.00);

SELECT *
FROM Returns2


-- Phương pháp CTE
WITH MonthlyOrders AS (
    SELECT 
        YEAR(order_date) AS year,
        MONTH(order_date) AS month,
        product_category,
        SUM(total_value) AS total_value
    FROM Orders2
    GROUP BY YEAR(order_date), MONTH(order_date), product_category
),
MonthlyReturns AS (
    SELECT 
        YEAR(o.order_date) AS year,
        MONTH(o.order_date) AS month,
        o.product_category,
        SUM(r.return_value) AS total_value_return
    FROM Returns2 r
    INNER JOIN Orders2 o ON r.order_id = o.order_id
    GROUP BY YEAR(o.order_date), MONTH(o.order_date), o.product_category
)
SELECT 
    o.year,
    o.month,
    o.product_category,
    o.total_value,
    COALESCE(r.total_value_return, 0) AS total_value_return
FROM MonthlyOrders o
LEFT JOIN MonthlyReturns r
ON o.year = r.year AND o.month = r.month AND o.product_category = r.product_category;

-- Phương pháp Subquery
SELECT 
    o.year,
    o.month,
    o.product_category,
    o.total_value,
    COALESCE(r.total_value_return, 0) AS total_value_return
FROM (
    SELECT 
        YEAR(order_date) AS year,
        MONTH(order_date) AS month,
        product_category,
        SUM(total_value) AS total_value
    FROM Orders2
    GROUP BY YEAR(order_date), MONTH(order_date), product_category
) o
LEFT JOIN (
    SELECT 
        YEAR(o.order_date) AS year,
        MONTH(o.order_date) AS month,
        o.product_category,
        SUM(r.return_value) AS total_value_return
    FROM Returns2 r
    INNER JOIN Orders2 o ON r.order_id = o.order_id
    GROUP BY YEAR(o.order_date), MONTH(o.order_date), o.product_category
) r
ON o.year = r.year AND o.month = r.month AND o.product_category = r.product_category;

-----------------------Bài 3----------------------------------------------
-- Tạo bảng Managers
CREATE TABLE Managers (
    manager_id INT,
    manager_name VARCHAR(50),
    manager_level INT
);

-- Thêm dữ liệu vào bảng Managers
INSERT INTO Managers (manager_id, manager_name, manager_level)
VALUES 
	(111, 'Chris', 2),
	(112, 'William', 3),
	(113, 'Erin', 3),
	(114, 'Sam', 4),
	(115, 'Pat', 3);

SELECT *
FROM Managers

-- Tạo bảng Orders
CREATE TABLE Orders3 (
    order_id INT,
    order_date DATE,
    manager_id INT,
    total_quantity INT,
    total_value DECIMAL(15, 2),
    total_profit DECIMAL(15, 2)
);

-- Thêm dữ liệu vào bảng Orders
INSERT INTO Orders3 (order_id, order_date, manager_id, total_quantity, total_value, total_profit)
VALUES 
	(1, '2012-01-15', 115, 264, 560685.68, 226740.44),
	(2, '2012-03-10', 113, 452, 819830.62, 335563.50),
	(3, '2012-05-20', 111, 138, 204636.14, 82910.16),
	(4, '2012-07-18', 112, 655, 1089018.91, 448907.84),
	(5, '2012-10-30', 114, 386, 557977.31, 222439.61);

SELECT *
FROM Orders3

-- Tạo bảng Returns
CREATE TABLE Returns3 (
    return_id INT,
    order_id INT,
    return_date DATE,
    return_quantity INT
);

-- Thêm dữ liệu vào bảng Returns
INSERT INTO Returns3 (return_id, order_id, return_date, return_quantity)
VALUES 
	(1, 1, '2012-01-20', 50),
	(2, 2, '2012-03-15', 100),
	(3, 3, '2012-05-25', 20),
	(4, 4, '2012-07-22', 150);

SELECT *
FROM Returns3

118
352
214
386
505

118
505
352
386
214

-- Truy vấn tóm tắt thông tin theo yêu cầu
SELECT 
    m.manager_name,
    m.manager_level,
    o.manager_id,
    COUNT(o.order_id) AS number_items,
    SUM(o.total_quantity) - COALESCE(SUM(r.return_quantity), 0) AS total_quantity,
    SUM(o.total_value) AS total_value,
    SUM(o.total_profit) AS total_profit
FROM Orders3 o
LEFT JOIN Returns3 r ON o.order_id = r.order_id
INNER JOIN Managers m ON o.manager_id = m.manager_id
WHERE o.order_date BETWEEN '2012-01-01' AND '2012-12-31'
GROUP BY m.manager_name, m.manager_level, o.manager_id;

-- Sub query cách 2
SELECT 
    m.manager_name,
    m.manager_level,
    o.manager_id,
    (SELECT COUNT(order_id) FROM Orders3 WHERE manager_id = o.manager_id AND order_date BETWEEN '2012-01-01' AND '2012-12-31') AS number_items,
    (SELECT SUM(total_quantity) - COALESCE(SUM(return_quantity), 0)
     FROM Orders3 o2
     LEFT JOIN Returns3 r ON o2.order_id = r.order_id
     WHERE o2.manager_id = o.manager_id AND o2.order_date BETWEEN '2012-01-01' AND '2012-12-31') AS total_quantity,
    (SELECT SUM(total_value) 
     FROM Orders3 
     WHERE manager_id = o.manager_id AND order_date BETWEEN '2012-01-01' AND '2012-12-31') AS total_value,
    (SELECT SUM(total_profit) 
     FROM Orders3 
     WHERE manager_id = o.manager_id AND order_date BETWEEN '2012-01-01' AND '2012-12-31') AS total_profit
FROM Orders3 o
INNER JOIN Managers m ON o.manager_id = m.manager_id
GROUP BY m.manager_name, m.manager_level, o.manager_id;

------------Phương pháp CTE
WITH OrderSummary AS (
    SELECT 
        manager_id,
        COUNT(order_id) AS number_items,
        SUM(total_quantity) AS total_quantity,
        SUM(total_value) AS total_value,
        SUM(total_profit) AS total_profit
    FROM Orders3
    WHERE order_date BETWEEN '2012-01-01' AND '2012-12-31'
    GROUP BY manager_id
),
ReturnSummary AS (
    SELECT 
        o.manager_id,
        COALESCE(SUM(r.return_quantity), 0) AS total_return_quantity
    FROM Orders3 o
    LEFT JOIN Returns3 r ON o.order_id = r.order_id
    WHERE o.order_date BETWEEN '2012-01-01' AND '2012-12-31'
    GROUP BY o.manager_id
)
SELECT 
    m.manager_name,
    m.manager_level,
    os.manager_id,
    os.number_items,
    os.total_quantity - rs.total_return_quantity AS total_quantity,
    os.total_value,
    os.total_profit
FROM Managers m
INNER JOIN OrderSummary os ON m.manager_id = os.manager_id
LEFT JOIN ReturnSummary rs ON m.manager_id = rs.manager_id
ORDER BY m.manager_id;
