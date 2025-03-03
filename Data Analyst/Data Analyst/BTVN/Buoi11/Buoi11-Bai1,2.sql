USE master;
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

-- Create the database if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'QUANLYBANHANG')
BEGIN
    CREATE DATABASE QUANLYBANHANG;
END
GO
USE QUANLYBANHANG;


IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'KHACHHANG')
-- Bảng KHACHHANG
create table KHACHHANG (
	MAKH char(10) primary key,
	HOTEN nvarchar(40),
	DCHI nvarchar(50),
	SODT varchar(13),
	NGSINH smalldatetime,
	DOANHSO DECIMAL(18, 3),
)

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'NHANVIEN')
-- Bảng NHANVIEN
CREATE TABLE NHANVIEN (
    MANV CHAR(10) PRIMARY KEY,        -- Mã nhân viên, duy nhất
    HOTEN NVARCHAR(50),               -- Họ tên nhân viên
    NGVL DATE,                        -- Ngày vào làm
    SODT CHAR(15)                     -- Số điện thoại liên lạc
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'SANPHAM')
-- Bảng SANPHAM
CREATE TABLE SANPHAM (
    MASP CHAR(10) PRIMARY KEY,        -- Mã sản phẩm, duy nhất
    TENSP NVARCHAR(100),              -- Tên sản phẩm
    DVT NVARCHAR(20),                 -- Đơn vị tính
    NUOCSX NVARCHAR(50),              -- Nước sản xuất
    GIA DECIMAL(18, 3)                -- Giá bán 
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'HOADON')
-- Bảng HOADON
CREATE TABLE HOADON (
    SOHD CHAR(10) PRIMARY KEY,        -- Số hóa đơn, duy nhất
    NGHD DATE,                        -- Ngày hóa đơn
    MAKH CHAR(10),                    -- Mã khách hàng
    MANV CHAR(10),                    -- Mã nhân viên bán hàng
    TRIGIA DECIMAL(18, 3),            -- Trị giá hóa đơn
    FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH) ON DELETE CASCADE, -- Ràng buộc quan hệ tới KHACHHANG
    FOREIGN KEY (MANV) REFERENCES NHANVIEN(MANV) ON DELETE CASCADE   -- Ràng buộc quan hệ tới NHANVIEN
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'CTHD')
-- Bảng CTHD
CREATE TABLE CTHD (
    SOHD CHAR(10),                    -- Số hóa đơn
    MASP CHAR(10),                    -- Mã sản phẩm
    SL INT,                           -- Số lượng
    PRIMARY KEY (SOHD, MASP),         -- Khóa chính gồm SOHD và MASP
    FOREIGN KEY (SOHD) REFERENCES HOADON(SOHD) ON DELETE CASCADE, -- Ràng buộc quan hệ tới HOADON
    FOREIGN KEY (MASP) REFERENCES SANPHAM(MASP) ON DELETE CASCADE -- Ràng buộc quan hệ tới SANPHAM
);


-- Bảng KHACHHANG
INSERT INTO KHACHHANG (MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO)
VALUES 
('KH21', 'Nguyễn Văn An', 'Hà Nội', '0123456789', '1985-05-15', 15000.000),
('KH22', 'Lê Thị Hoa', 'Hồ Chí Minh', '0987654321', '1990-07-20', 8500.500),
('KH23', 'Phạm Văn Nam', 'Đà Nẵng', '0908765432', '1975-11-11', 22000.000),
('KH24', 'Trần Thị Minh', 'Cần Thơ', '0945654321', '1982-04-25', 5000.250);


-- Bảng NHANVIEN
INSERT INTO NHANVIEN (MANV, HOTEN, NGVL, SODT)
VALUES 
('NV21', 'Nguyễn Văn Bình', '2020-01-01', '0932123456'),
('NV22', 'Trần Văn Tâm', '2019-06-15', '0928765432'),
('NV23', 'Lê Thị Nga', '2021-10-20', '0942123456'),
('NV24', 'Lê Thị Hoa', '2021-10-20', '0942123456');


-- Bảng SANPHAM
INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA)
VALUES 
('SP21', 'Điện thoại Samsung Galaxy', 'Chiếc', 'Hàn Quốc', 15000.000),
('SP22', 'Laptop Dell Inspiron', 'Chiếc', 'Mỹ', 20000.000),
('SP23', 'Tai nghe Bluetooth Sony', 'Cái', 'Nhật Bản', 2500.000),
('SP24', 'Bàn phím cơ Logitech', 'Chiếc', 'Thụy Sỹ', 3000.000);


-- Bảng HOADON
INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA)
VALUES 
('HD21', '2023-12-01', 'KH21', 'NV21', 17500.000),
('HD22', '2023-12-15', 'KH22', 'NV22', 8500.000),
('HD23', '2023-12-20', 'KH23', 'NV23', 22000.000),
('HD24', '2023-12-22', 'KH24', 'NV24', 3000.000);


-- Bảng CTHD
INSERT INTO CTHD (SOHD, MASP, SL)
VALUES 
('HD21', 'SP21', 2),
('HD22', 'SP22', 1),
('HD23', 'SP23', 1),
('HD24', 'SP24', 3);

-- 2.2.Thêm vào thuộc tính GHICHU có kiểu dữ liệu varchar(20) cho quan hệ SANPHAM.
ALTER TABLE SANPHAM
ADD GHICHU nvarchar(20);

-- 2.3.Thêm vào thuộc tính LOAIKH có kiểu dữ liệu là tinyint cho quan hệ KHACHHANG.
ALTER TABLE KHACHHANG
ADD LOAIKH tinyint;

-- 2.4.Cập nhật tên “Nguyễn Văn B” cho dữ liệu Khách Hàng có mã là KH21
UPDATE KHACHHANG
SET HOTEN = 'Nguyễn Văn B'
WHERE MAKH = 'KH21';

-- 2.5.Cập nhật tên “Nguyễn Văn Hoan” cho dữ liệu Khách Hàng có mã là KH22 và số điện thoại là 093243215324
UPDATE KHACHHANG
SET HOTEN = 'Nguyễn Văn Hoan', NGSINH = '1990'
WHERE MAKH = 'KH22';

-- 2.6.Sửa kiểu dữ liệu của thuộc tính GHICHU trong quan hệ SANPHAM thành varchar(100).
ALTER TABLE SANPHAM
ALTER COLUMN GHICHU varchar(100);

-- 2.7.Xóa thuộc tính GHICHU trong quan hệ SANPHAM.
ALTER TABLE SANPHAM
DROP COLUMN GHICHU;

-- 2.8.Xóa tất cả dữ liệu khách hàng có năm sinh 1982
DELETE FROM KHACHHANG
WHERE YEAR(NGSINH) = 1982;

--2.9.Xoá tất cả dữ liệu khách hàng có năm sinh 1971 và năm đăng ký 2006

--2.10.Xóa tất cả hóa đơn có mã khách hàng là KH21
DELETE FROM HOADON
WHERE MAKH = 'KH21';

-- In ra bảng
SELECT * FROM KHACHHANG
SELECT * FROM HOADON

