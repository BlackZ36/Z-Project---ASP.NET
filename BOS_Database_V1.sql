USE master
GO

DROP DATABASE IF EXISTS BOS_Database_V1
GO

CREATE DATABASE BOS_Database_V1
GO

USE BOS_Database_V1
GO

-- Tạo bảng [User]
CREATE TABLE [User] (
    [user_id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    [google_id] NVARCHAR(100),
    [email] NVARCHAR(100) NOT NULL,
    [password] NVARCHAR(100) NOT NULL,
    [phone_number] NVARCHAR(20),
    [created_date] DATETIME NOT NULL,
    [status] INT NOT NULL,
    [role_id] UNIQUEIDENTIFIER
);

-- Tạo bảng [Admin]
CREATE TABLE [Admin] (
    [admin_id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    [username] NVARCHAR(50) NOT NULL,
    [password] NVARCHAR(100) NOT NULL
);

-- Tạo bảng [Role]
CREATE TABLE [Role] (
    [role_id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    [role_name] NVARCHAR(50) NOT NULL
);

-- Tạo bảng [UserDetail]
CREATE TABLE [UserDetail] (
    [user_detail_id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    [user_id] UNIQUEIDENTIFIER,
    [full_name] NVARCHAR(100),
    [default_address_id] UNIQUEIDENTIFIER,
    [balance] DECIMAL(18, 2)
);

-- Tạo bảng [Address]
CREATE TABLE [Address] (
    [address_id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    [user_id] UNIQUEIDENTIFIER,
    [province] NVARCHAR(100),
    [district] NVARCHAR(100),
    [ward] NVARCHAR(100),
    [detail] NVARCHAR(200)
);

-- Tạo bảng [Category]
CREATE TABLE [Category] (
    [category_id] INT PRIMARY KEY IDENTITY,
    [parent_id] INT,
    [category_name] NVARCHAR(100) NOT NULL,
    [sort_order] INT,
    [status] INT NOT NULL
);

-- Tạo bảng [Product]
CREATE TABLE [Product] (
    [product_id] INT PRIMARY KEY IDENTITY,
    [category_id] INT,
    [product_name] NVARCHAR(100) NOT NULL,
    [created] DATETIME NOT NULL,
    [modified] DATETIME NOT NULL,
    [status] INT NOT NULL
);

-- Tạo bảng [ProductDetail]
CREATE TABLE [ProductDetail] (
    [product_detail_id] INT PRIMARY KEY IDENTITY,
    [product_id] INT,
    [price] DECIMAL(18, 2) NOT NULL,
    [content] NVARCHAR(MAX),
    [discount] DECIMAL(18, 2),
    [img_url] NVARCHAR(MAX),
    [img_list] NVARCHAR(MAX),
    [view] INT NOT NULL
);

-- Tạo bảng [Order]
CREATE TABLE [Order] (
    [order_id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    [user_id] UNIQUEIDENTIFIER,
    [order_date] DATETIME NOT NULL,
    [address_id] UNIQUEIDENTIFIER,
    [total_amount] DECIMAL(18, 2) NOT NULL,
    [payment_status] INT NOT NULL,
    [promotion_code] NVARCHAR(50),
    [discount_value] DECIMAL(18, 2),
    [status] INT NOT NULL
);

-- Tạo bảng [OrderDetail]
CREATE TABLE [OrderDetail] (
    [order_detail_id] NVARCHAR(10) PRIMARY KEY IDENTITY,
    [order_id] UNIQUEIDENTIFIER,
    [product_id] INT,
    [quantity] INT NOT NULL,
    [price] DECIMAL(18, 2) NOT NULL
);

-- Tạo bảng [Transaction]
CREATE TABLE [Transaction] (
    [transaction_id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    [user_id] UNIQUEIDENTIFIER,
    [amount] DECIMAL(18, 2) NOT NULL,
    [type] INT NOT NULL,
    [order_id] UNIQUEIDENTIFIER,
    [created_at] DATETIME NOT NULL
);

-- Tạo bảng [Setting]
CREATE TABLE [Setting] (
    [setting_id] INT PRIMARY KEY IDENTITY,
    [setting_key] NVARCHAR(100) NOT NULL,
    [setting_value] NVARCHAR(MAX) NOT NULL
);

-- Tạo bảng [PaymentMethod]
CREATE TABLE [PaymentMethod] (
    [payment_method_id] INT PRIMARY KEY IDENTITY,
    [method_name] NVARCHAR(100) NOT NULL,
    [status] INT NOT NULL
);

-- Tạo bảng [UserRole]
CREATE TABLE [UserRole] (
    [user_role_id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    [user_id] UNIQUEIDENTIFIER,
    [role_id] UNIQUEIDENTIFIER
);

-- Tạo bảng [Claim]
CREATE TABLE [Claim] (
    [claim_id] INT PRIMARY KEY IDENTITY,
    [claim_name] NVARCHAR(100) NOT NULL
);

-- Tạo bảng [UserClaim]
CREATE TABLE [UserClaim] (
    [user_claim_id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    [user_id] UNIQUEIDENTIFIER,
    [claim_id] INT
);

-- Tạo bảng [RefreshToken]
CREATE TABLE [RefreshToken] (
    [refresh_token_id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    [user_id] UNIQUEIDENTIFIER,
    [token] NVARCHAR(200) NOT NULL,
    [expiry_date] DATETIME NOT NULL
);

-- Tạo bảng [AuditLog]
CREATE TABLE [AuditLog] (
    [audit_log_id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    [user_id] UNIQUEIDENTIFIER,
    [action] NVARCHAR(100) NOT NULL,
    [created_at] DATETIME NOT NULL
);

-- Tạo bảng [BlacklistToken]
CREATE TABLE [BlacklistToken] (
    [token_id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    [token] NVARCHAR(200) NOT NULL
);

-- Thêm các ràng buộc khóa ngoại

ALTER TABLE [UserDetail]
ADD CONSTRAINT FK_UserDetail_User FOREIGN KEY ([user_id]) REFERENCES [User]([user_id]);

ALTER TABLE [Address]
ADD CONSTRAINT FK_Address_User FOREIGN KEY ([user_id]) REFERENCES [User]([user_id]);

ALTER TABLE [Category]
ADD CONSTRAINT FK_Category_Category FOREIGN KEY ([parent_id]) REFERENCES [Category]([category_id]);

ALTER TABLE [Product]
ADD CONSTRAINT FK_Product_Category FOREIGN KEY ([category_id]) REFERENCES [Category]([category_id]);

ALTER TABLE [ProductDetail]
ADD CONSTRAINT FK_ProductDetail_Product FOREIGN KEY ([product_id]) REFERENCES [Product]([product_id]);

ALTER TABLE [Order]
ADD CONSTRAINT FK_Order_User FOREIGN KEY ([user_id]) REFERENCES [User]([user_id]);

ALTER TABLE [Order]
ADD CONSTRAINT FK_Order_Address FOREIGN KEY ([address_id]) REFERENCES [Address]([address_id]);

ALTER TABLE [OrderDetail]
ADD CONSTRAINT FK_OrderDetail_Order FOREIGN KEY ([order_id]) REFERENCES [Order]([order_id]);

ALTER TABLE [OrderDetail]
ADD CONSTRAINT FK_OrderDetail_Product FOREIGN KEY ([product_id]) REFERENCES [Product]([product_id]);

ALTER TABLE [Transaction]
ADD CONSTRAINT FK_Transaction_User FOREIGN KEY ([user_id]) REFERENCES [User]([user_id]);

ALTER TABLE [Transaction]
ADD CONSTRAINT FK_Transaction_Order FOREIGN KEY ([order_id]) REFERENCES [Order]([order_id]);

ALTER TABLE [UserRole]
ADD CONSTRAINT FK_UserRole_User FOREIGN KEY ([user_id]) REFERENCES [User]([user_id]);

ALTER TABLE [UserRole]
ADD CONSTRAINT FK_UserRole_Role FOREIGN KEY ([role_id]) REFERENCES [Role]([role_id]);

ALTER TABLE [UserClaim]
ADD CONSTRAINT FK_UserClaim_User FOREIGN KEY ([user_id]) REFERENCES [User]([user_id]);

ALTER TABLE [UserClaim]
ADD CONSTRAINT FK_UserClaim_Claim FOREIGN KEY ([claim_id]) REFERENCES [Claim]([claim_id]);

ALTER TABLE [RefreshToken]
ADD CONSTRAINT FK_RefreshToken_User FOREIGN KEY ([user_id]) REFERENCES [User]([user_id]);

ALTER TABLE [AuditLog]
ADD CONSTRAINT FK_AuditLog_User FOREIGN KEY ([user_id]) REFERENCES [User]([user_id]);



-- Thêm dữ liệu vào bảng
-- Thêm dữ liệu vào bảng Role
INSERT INTO [Role] (role_id, role_name)
VALUES 
    (NEWID(), 'Customer'), -- Role Customer
    (NEWID(), 'Manager'),  -- Role Manager
    (NEWID(), 'Admin');    -- Role Admin

-- Lưu lại các giá trị role_id để sử dụng trong các bảng khác
DECLARE @CustomerRoleId UNIQUEIDENTIFIER = (SELECT role_id FROM [Role] WHERE role_name = 'Customer');
DECLARE @ManagerRoleId UNIQUEIDENTIFIER = (SELECT role_id FROM [Role] WHERE role_name = 'Manager');
DECLARE @AdminRoleId UNIQUEIDENTIFIER = (SELECT role_id FROM [Role] WHERE role_name = 'Admin');

-- Thêm dữ liệu vào bảng User
INSERT INTO [User] (google_id, email, password, phone_number, created_date, status, role_id)
VALUES 
    (NULL, 'customer@example.com', '123', NULL, GETDATE(), 1, @CustomerRoleId), -- Customer
    (NULL, 'manager@example.com', '123', NULL, GETDATE(), 1, @ManagerRoleId),  -- Manager
    (NULL, 'admin@example.com', '123', NULL, GETDATE(), 1, @AdminRoleId);      -- Admin

-- Lưu lại các giá trị user_id để sử dụng trong các bảng khác
DECLARE @CustomerUserId UNIQUEIDENTIFIER = (SELECT user_id FROM [User] WHERE email = 'customer@example.com');
DECLARE @ManagerUserId UNIQUEIDENTIFIER = (SELECT user_id FROM [User] WHERE email = 'manager@example.com');
DECLARE @AdminUserId UNIQUEIDENTIFIER = (SELECT user_id FROM [User] WHERE email = 'admin@example.com');

-- Thêm dữ liệu vào bảng Admin (Chỉ để minh họa, không cần nếu đã lưu trong bảng User)
INSERT INTO [Admin] (username, [password])
VALUES 
    ('admin', 'admin');   -- Admin password

-- Thêm dữ liệu vào bảng Category
INSERT INTO [Category] (category_id, parent_id, category_name, sort_order, status)
VALUES 
    (NEWID(), NULL, 'Phần mềm', 1, 1),                -- Phần mềm
    (NEWID(), NULL, 'Bàn phím', 2, 1),                -- Bàn phím
    (NEWID(), (SELECT category_id FROM [Category] WHERE category_name = 'Phần mềm'), 'Phần mềm đồ họa', 3, 1),    -- Phần mềm đồ họa
    (NEWID(), (SELECT category_id FROM [Category] WHERE category_name = 'Phần mềm'), 'Phần mềm lập trình', 4, 1), -- Phần mềm lập trình
    (NEWID(), (SELECT category_id FROM [Category] WHERE category_name = 'Bàn phím'), '60%', 5, 1),                -- 60%
    (NEWID(), (SELECT category_id FROM [Category] WHERE category_name = 'Bàn phím'), '70%', 6, 1),                -- 70%
    (NEWID(), (SELECT category_id FROM [Category] WHERE category_name = 'Bàn phím'), 'TKL', 7, 1),                -- TKL
    (NEWID(), (SELECT category_id FROM [Category] WHERE category_name = 'Bàn phím'), 'Fullsize', 8, 1),           -- Fullsize
    (NEWID(), (SELECT category_id FROM [Category] WHERE category_name = 'Bàn phím'), 'Alice', 9, 1),              -- Alice
    (NEWID(), (SELECT category_id FROM [Category] WHERE category_name = 'Bàn phím'), 'Split', 10, 1);             -- Split

-- Thêm dữ liệu vào bảng UserRole
INSERT INTO [UserRole] (user_role_id, user_id, role_id)
VALUES
    (NEWID(), @CustomerUserId, @CustomerRoleId), -- Customer UserRole
    (NEWID(), @ManagerUserId, @ManagerRoleId),   -- Manager UserRole
    (NEWID(), @AdminUserId, @AdminRoleId);       -- Admin UserRole