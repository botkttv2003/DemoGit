﻿-- Bài 1 --
-- Tạo bảng manager
CREATE TABLE manager(
	manager_id int, ​
	manager_name varchar(50), ​
	manager_level int, ​
	region varchar(50), ​
	salary float
)
-- Cách 1

INSERT INTO manager (manager_id,manager_name,manager_level,region,salary) VALUES (111​,'Chris'​,2​,'Nunavut'​,370​);
INSERT INTO manager (manager_id,manager_level,region,salary) VALUES (112,3,'West',240);
INSERT INTO manager (manager_id,manager_name,region,salary) VALUES (113,'Erin','Prarie',377);
INSERT INTO manager (manager_id,manager_name,salary) VALUES (114,'Sam',454);
INSERT INTO manager (manager_id) VALUES (115);

SELECT*
FROM manager

-- Cách 2

INSERT INTO manager (manager_id,manager_name,manager_level,region,salary) VALUES
	(116 ,'A' ,2 ,'Nunavut' ,370 ),
	(117 ,'B',3,'West',240),
	(118 ,'C',3,'Prarie',377),
	(119 ,'D',4,'West',454),
	(120 ,'F',3,'Ontario',168);

SELECT*
FROM manager

-- Bài 2
INSERT INTO manager (manager_id,manager_name,manager_level,region,salary) VALUES
	(121​,'Parker',1​,'Quebec',390​),
	(122​,'Robert'​,2​,'Prarie'​,407​);

SELECT*
FROM manager

-- Bài 3
DELETE manager WHERE manager_level = 2; 

SELECT*
FROM manager


-- Bài 4
UPDATE manager ​
SET salary = 500
WHERE region in ( 'West','Quebec');

SELECT *
FROM manager

CREATE TABLE luong_moi(
	id int, ​
	salary float
)

INSERT INTO luong_moi(id,salary) VALUES
	(112,100),
	(113,200),
	(114,300),
	(115,400),
	(117,500),
	(118,600),
	(119,700),
	(120,800),
	(121,900);

SELECT *
FROM luong_moi

UPDATE manager
SET manager.salary = luong_moi.salary
FROM luong_moi
WHERE manager.manager_id = luong_moi.id

SELECT *
FROM manager