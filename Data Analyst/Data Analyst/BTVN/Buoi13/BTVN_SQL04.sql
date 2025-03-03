﻿-- BÀI 1
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Orderss')
-- Tạo bảng Orders
Create table Orderss(
	order_id char(10),
	order_date  smalldatetime, 
	order_quantity float,
	value money,
	profit money
);
Select *
From Orderss;

-- Tạo bảng returns
Create table returnss(
	returns_id char(10),
	returned_date  smalldatetime
);

-- Thêm dữ liệu cho bảng orderss
INSERT INTO Orderss (order_id, order_date, order_quantity, value, profit)
VALUES
('45127', '2012-12-30', 10, 13.32, 7.144),
('42945', '2012-12-29', 45, 165.3075, 55.305),
('29505', '2012-12-27', 22, 37.9456, 15.5624),
('30469', '2012-12-25', 46, 293.112, 137.6924),
('23619', '2012-12-21', 100, 4246.1012, 1908.7484);

-- Thêm dữ liệu cho bảng returns
INSERT INTO returnss (returns_id, returned_date)
VALUES
('45127', '2013-01-13'),
('42945', '2013-01-12'),
('29605', '2013-01-11'),
('30469', '2013-01-10'),
('23458', '2013-01-05');

-- Inner join
Select order_id AS order_id_return,
order_date,
sum(order_quantity) AS total_order_quantity,
sum(value) AS total_value,
sum(profit) AS total_profit,
returned_date
from Orderss AS o
inner join Returnss AS r
on o.order_id=r.returns_id
Group by o.order_id, o.order_date, r.returned_date
Order by o.order_date desc;

-- Left join
Select order_id AS order_id_return,
order_date,
sum(order_quantity) AS total_order_quantity,
sum(value) AS total_value,
sum(profit) AS total_profit,
returned_date
from Orderss AS o
left join Returnss AS r
on o.order_id=r.returns_id
Group by o.order_id, o.order_date, r.returned_date
Order by o.order_date desc;

-- Right join
Select order_id AS order_id_return,
order_date,
sum(order_quantity) AS total_order_quantity,
sum(value) AS total_value,
sum(profit) AS total_profit,
returned_date
from Orderss AS o
right join Returnss AS r
on o.order_id=r.returns_id
Group by o.order_id, o.order_date, r.returned_date
Order by o.order_date desc;


--BÀI 2
-- Tạo bảng profiles
Create table profiles(
	manager char(20),
	Province  char(30)
);
-- Thêm thuộc tính province cho bảng Orderss
Alter table Orderss
Add Province  char(30);

-- Thêm dữ liệu cho thuộc tính mới
	-- 1 bảng profiles
INSERT INTO profiles (manager, province) 
VALUES
('Alice', 'Ontario'),
('Bob', 'Quebec'),
('Charlie', 'British Columbia'),
('Diana', 'Alberta'),
('Eve', 'Manitoba');
	-- 2 bảng Orderss
UPDATE Orderss
SET Province=
    CASE												-- CASE là một cấu trúc điều kiện tương tự như "if-else".
        WHEN order_id = 45127 THEN 'Ontario'
        WHEN order_id = 42945 THEN 'Quebec'
        WHEN order_id = 29505 THEN 'British Columbia'
        WHEN order_id = 30469 THEN 'Elbertana'
        WHEN order_id = 23619 THEN 'Anikoba'
        ELSE Province									-- Nếu không có điều kiện nào trong CASE thỏa mãn, thì giữ nguyên giá trị hiện tại của cột Province
    END
WHERE Province IS NULL;

-- xuất dữ liệu dựa trên quan hệ của province
Select manager,
sum(order_quantity) AS total_order_quantity,
sum(value) AS total_value,
sum(profit) AS total_profit
from Orderss AS o
left join Profiles AS p 
on o.province=p.province
Group by manager;

--BÀI 3
-- Thêm thuộc tính order_priority cho bảng Orderss
Alter table Orderss
Add order_priority char(20);

UPDATE Orderss
SET order_priority=
    CASE												
        WHEN order_id = 45127 THEN 'Low'
        WHEN order_id = 42945 THEN 'High'
        WHEN order_id = 29505 THEN 'Not Specified'
        WHEN order_id = 30469 THEN 'Medium'
        WHEN order_id = 23619 THEN 'Critical'
        ELSE order_priority									
    END
WHERE order_priority IS NULL;

-- Thêm dữ liệu
INSERT INTO Orderss (order_id, order_date, order_quantity, value, profit, Province, order_priority) 
VALUES
('25127', '2012-12-15', 26, 13.92, 7.754, 'Tanrio', 'High'),
('22945', '2012-12-06', 41, 174.305, 58.605, 'Ebecque', 'Low');

-- Truy vấn kết quả union all
Select order_priority, sum(profit) AS total_profit
From Orderss
Where order_priority= 'Not Specified'
Group by order_priority
Union all
Select order_priority, sum(profit) AS total_profit
From Orderss
Where order_priority= 'Low'
Group by order_priority
Union all
Select order_priority, sum(profit) AS total_profit
From Orderss
Where order_priority= 'High'
Group by order_priority
Union all
Select order_priority, sum(profit) AS total_profit
From Orderss
Where order_priority= 'Medium'
Group by order_priority
Union all
Select order_priority, sum(profit) AS total_profit
From Orderss
Where order_priority= 'Critical'
Group by order_priority


-- Test Union all
-- Union all 2 bảng có cấu trúc giống nhau
SELECT Province
FROM Profiles
UNION ALL
SELECT Province 
FROM Orderss

--In 2 bảng
select *
from Profiles;
select *
from Orderss;


--BÀI 4

Select order_priority, 
sum(profit) AS total_profit
From Orderss
Group by order_priority
UNION all
Select 'Total' AS order_priority, 
sum(profit) AS total_profit
From Orderss

