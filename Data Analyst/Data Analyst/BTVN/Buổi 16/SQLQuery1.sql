--Bài 1
CREATE TABLE sales (
    id INT PRIMARY KEY,
    province VARCHAR(50),
    product_category VARCHAR(50),
    value DECIMAL(10, 2)
);

INSERT INTO sales (id, province, product_category, value) VALUES
	(1, 'Hà Nội', 'Office Supplies', 1000.00),
	(2, 'Hà Nội', 'Furniture', 2000.00),
	(3, 'Hà Nội', 'Technology', 3000.00),
	(4, 'Hồ Chí Minh', 'Office Supplies', 1500.00),
	(5, 'Hồ Chí Minh', 'Furniture', 2500.00),
	(6, 'Đà Nẵng', 'Technology', 3500.00),
	(7, 'Đà Nẵng', 'Office Supplies', 500.00),
	(8, 'Cần Thơ', 'Furniture', 1200.00),
	(9, 'Hải Phòng', 'Technology', 800.00),
	(10, 'Hải Phòng', 'Office Supplies', 700.00);


SELECT
    province,
    SUM(CASE WHEN product_category = 'Office Supplies' THEN value ELSE NULL END) AS Office_Supplies,
    SUM(CASE WHEN product_category = 'Furniture' THEN value ELSE NULL END) AS Furniture,
    SUM(CASE WHEN product_category = 'Technology' THEN value ELSE NULL END) AS Technology
FROM sales
GROUP BY province;

SELECT *
FROM sales

--Bài 2
CREATE TABLE sales_v2 (
    id INT PRIMARY KEY,
    province VARCHAR(50),
    product_category VARCHAR(50),
    product_name VARCHAR(100),
    value DECIMAL(10, 2)
);

INSERT INTO sales_v2 (id, province, product_category, product_name, value) VALUES
	(1, 'Hà Nội', 'Office Supplies', 'Paper', 100.00),
	(2, 'Hà Nội', 'Office Supplies', 'Pens', 200.00),
	(3, 'Hà Nội', 'Office Supplies', 'Stapler', 150.00),
	(4, 'Hà Nội', 'Office Supplies', 'Notepad', 80.00),
	(5, 'Hà Nội', 'Office Supplies', 'Markers', 300.00),
	(6, 'Hà Nội', 'Furniture', 'Chair', 500.00),
	(7, 'Hà Nội', 'Furniture', 'Table', 700.00),
	(8, 'Hà Nội', 'Furniture', 'Cabinet', 600.00),
	(9, 'Hà Nội', 'Furniture', 'Bookshelf', 400.00),
	(10, 'Hà Nội', 'Furniture', 'Lamp', 250.00),
	(11, 'Hà Nội', 'Technology', 'Laptop', 1500.00),
	(12, 'Hà Nội', 'Technology', 'Mouse', 100.00),
	(13, 'Hà Nội', 'Technology', 'Keyboard', 120.00),
	(14, 'Hà Nội', 'Technology', 'Monitor', 200.00),
	(15, 'Hà Nội', 'Technology', 'Printer', 300.00),
	(16, 'Đà Nẵng', 'Office Supplies', 'Paper', 200.00),
	(17, 'Đà Nẵng', 'Office Supplies', 'Pens', 150.00),
	(18, 'Đà Nẵng', 'Office Supplies', 'Stapler', 100.00),
	(19, 'Đà Nẵng', 'Office Supplies', 'Notepad', 50.00),
	(20, 'Đà Nẵng', 'Office Supplies', 'Markers', 250.00),
	(21, 'Đà Nẵng', 'Furniture', 'Chair', 300.00),
	(22, 'Đà Nẵng', 'Furniture', 'Table', 400.00),
	(23, 'Đà Nẵng', 'Furniture', 'Cabinet', 350.00),
	(24, 'Đà Nẵng', 'Furniture', 'Bookshelf', 450.00),
	(25, 'Đà Nẵng', 'Furniture', 'Lamp', 200.00),
	(26, 'Hồ Chí Minh', 'Technology', 'Laptop', 1700.00),
	(27, 'Hồ Chí Minh', 'Technology', 'Mouse', 80.00),
	(28, 'Hồ Chí Minh', 'Technology', 'Keyboard', 90.00),
	(29, 'Hồ Chí Minh', 'Technology', 'Monitor', 150.00),
	(30, 'Hồ Chí Minh', 'Technology', 'Printer', 180.00);


SELECT *
FROM sales_v2

WITH ranked_sales AS (
    SELECT
        product_category,
        product_name,
        SUM(value) AS total_value,
        ROW_NUMBER() OVER (PARTITION BY product_category ORDER BY SUM(value) ASC) AS row_num
    FROM sales_v2
    GROUP BY product_category, product_name
)
SELECT 
    product_category,
    product_name,
    total_value,
    row_num
FROM ranked_sales
WHERE row_num <= 3
ORDER BY product_category, total_value;

----Bài 3
WITH ranked_sales AS (
    SELECT
        province,
        product_name,
        SUM(value) AS total_value,
        DENSE_RANK() OVER (PARTITION BY province ORDER BY SUM(value) ASC) AS rank
    FROM sales_v2
    GROUP BY province, product_name
)
SELECT 
    province,
    product_name,
    total_value,
    rank
FROM ranked_sales
WHERE rank = 3
ORDER BY province, total_value ASC;

--Bài 4

WITH ranked_sales AS (
    SELECT
        province,
        product_name,
        SUM(value) AS total_value,
        RANK() OVER (PARTITION BY province ORDER BY SUM(value) DESC) AS rank
    FROM sales_v2
    GROUP BY province, product_name
)
SELECT 
    province,
    product_name,
    total_value,
    rank
FROM ranked_sales
WHERE rank = 3
ORDER BY province, total_value DESC;
