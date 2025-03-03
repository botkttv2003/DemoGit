-- Bài 1:

﻿USE master;
GO
-- Drop the database if it exists
ALTER DATABASE QUANLYBANHANG SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'QUANLYBANHANG')
BEGIN
    DROP DATABASE QUANLYBANHANG;
END

GO
-- Create the database if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'QUANLYBANHANG')
BEGIN
    CREATE DATABASE QUANLYBANHANG;
END
GO
USE QUANLYBANHANG;

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Orders')
-- Tạo bảng Orders
Create table Orders(
	order_id char(10),
	order_date  smalldatetime, 
	order_quantity float,
	value money,
	profit money
);

-- In ra bảng Orders
Select *
From Orders; 

-- Tạo thêm các cột hỗ trợ cho công thức của revenue
Alter table Orders
Add unit_price money, 
	discount float;

-- Tạo thêm các cột hỗ trợ cho công thức của total_cost
Alter table Orders
Add product_base_margin money, 
	shipping_cost money;

--- Lưu ý: Chỉ chạy 1 trong 2 cách; chạy phần phía bên trên trước ( tạo bảng)

-- Cách 1: Thêm từng cột
-- Tạo cột revenue với công thức order_quantity* unit_price*(1- discount) --  unit_price: giá 1 sp, discount: % giảm
Select order_id, order_date, order_quantity, value, profit, 
order_quantity* unit_price*(1- discount) as revenue	
From Orders;

-- Tạo cột total_cost với công thức product_base_margin* unit_price+shipping_cost
Select order_id, order_date, order_quantity, value, profit,
product_base_margin* unit_price+shipping_cost as total_cost
From Orders;

-- Tạo cột “net_profit” với công thức là revenue - total_cost
Select order_id, order_date, order_quantity, value, profit,
revenue - total_cost as net_profit
FROM Orders;

-- Cách 2: Thêm cả 3 cột
SELECT 
    order_id, 
    order_date, 
    order_quantity, 
    value, 
    profit,
    -- Tính toán cột revenue
    order_quantity * unit_price * (1 - discount) AS revenue,
    -- Tính toán cột total_cost
    product_base_margin * unit_price + shipping_cost AS total_cost,
    -- Tính toán cột net_profit
    (order_quantity * unit_price * (1 - discount)) - 
    (product_base_margin * unit_price + shipping_cost) AS net_profit
FROM Orders;


-- Bài 2
Alter table Orders
Add region nvarchar(15),
	order_priority char(10),
	Province nvarchar(20),
	shipping_mode nvarchar(20),
	product_subcategory nvarchar(20),
	custumer_segment nvarchar(40);

-- Sửa dữ liệu order_priority
Alter table Orders
Alter column order_priority char(20);

-- Đổ dữ liệu:
INSERT INTO Orders (
    order_id,
    order_date,
    order_quantity,
    value,
    profit,
    unit_price,
    discount,
    product_base_margin,
    shipping_cost,
    region,
    order_priority,
    Province,
    shipping_mode,
    product_subcategory,
    custumer_segment
) 
VALUES
    ('O001', '2023-12-01 08:30:00', 11, 1100.00, 50.00, 100.00, 0.1, 0.3, 20.00, 'North', 'High', 'New Hanoi', 'Air Express', 'Co Electronics', 'Corporate'),
    ('O002', '2023-12-02 14:00:00', 2, 180.00, 30.00, 90.00, 0.05, 0.25, 15.00, 'West', 'Low', 'HCMC', 'Standard', 'Furniture', 'Consumer'),
	('O003', '2023-12-03 09:45:00', 10, 1500.00, 200.00, 150.00, 0.2, 0.35, 50.00, 'Central', 'Medium', 'New Da Nang', 'Express', 'Office Supplies', 'Small Business'),
	('O004', '2023-12-05 16:20:00', 12, 3000.00, 100.00, 250.00, 0.15, 0.4, 30.00, 'South', 'Not Specified', 'Can Tho', 'Standard', 'Co Clothing', 'Corporate');

-- Viết câu lệnh theo điều kiện region là "West"
Select *
From Orders
Where region = 'West';

--Viết câu lệnh theo điều kiện order_priority không bao gồm Critical
Select *
From Orders
Where order_priority <> 'Critical';

-- Viết câu lệnh theo điều kiện order_priority là “High” hoặc order_priority là “Low” hoặc order_priority là “Medium” hoặc order_priority là “Not Specified”
Select *
From Orders
Where order_priority in ('High', 'Low', 'Medium');

-- Viết câu lệnh theo điều kiện province chứa từ New
Select *
From Orders
Where province like '%New%';

-- Viết câu lệnh theo điều kiện shipping_mode không chứa từ Air và value nhỏ hơn 500
Select *
From Orders
Where shipping_mode not like '%Air%' and value < 500;

-- Viết câu lệnh theo điều kiện product_subcategory bắt đầu với từ Co
Select *
From Orders
Where product_subcategory like 'Co%';

-- Viết câu lệnh theo điều kiện custumer_segment kết thúc là "e" và order_quantity lớn hơn 10
Select *
From Orders
Where custumer_segment like '%e' and order_quantity > 10;

-- Bài 3
Select top 3
	order_id,
	province,
	sum(profit) as total_profit
From Orders
where province = 'HCMC'
Group by order_id, province
Order by total_profit desc;

-- Thêm dữ liệu
INSERT INTO Orders (
    order_id,
    order_date,
    order_quantity,
    value,
    profit,
    unit_price,
    discount,
    product_base_margin,
    shipping_cost,
    region,
    order_priority,
    Province,
    shipping_mode,
    product_subcategory,
    custumer_segment
) 
VALUES
	('O005', '2023-12-05 16:20:00', 3, 750.00, 100.00, 250.00, 0.15, 0.4, 30.00, 'South', 'Medium', 'HCMC', 'Standard Shipping', 'Clothing', 'Corporate'),
    ('O006', '2023-12-06 10:00:00', 7, 800.00, 120.00, 110.00, 0.05, 0.3, 25.00, 'East', 'High', 'HCMC', 'Air Cargo', 'Furniture', 'Government'),
    ('O007', '2023-12-07 09:00:00', 4, 400.00, 80.00, 100.00, 0.1, 0.3, 15.00, 'West', 'Low', 'HCMC', 'Ground Shipping', 'Books', 'Non-Profit');

Select*
From Orders;