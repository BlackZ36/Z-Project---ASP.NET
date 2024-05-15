USE master
GO

DROP DATABASE IF EXISTS BOS_Database_V1
GO

CREATE DATABASE BOS_Database_V1
GO

USE BOS_Database_V1
GO

CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY,
    google_id NVARCHAR(100),
    email NVARCHAR(100) NOT NULL,
	[password] NVARCHAR(50) NOT NULL,
    phone_number NVARCHAR(15),
    created_date DATETIME NOT NULL,
    status INT NOT NULL,
    role_id INT
);

CREATE TABLE Admins (
    admin_id INT PRIMARY KEY IDENTITY,
    username NVARCHAR(50) NOT NULL,
    [password] NVARCHAR(100) NOT NULL
);

CREATE TABLE Roles (
    role_id INT PRIMARY KEY IDENTITY,
    role_name NVARCHAR(50) NOT NULL
);

CREATE TABLE User_Details (
    user_detail_id INT PRIMARY KEY IDENTITY,
    user_id INT,
    full_name NVARCHAR(100),
    default_address_id INT,
    balance DECIMAL(18, 2)
);

CREATE TABLE Addresses (
    address_id INT PRIMARY KEY IDENTITY,
    user_id INT,
    province NVARCHAR(100),
    district NVARCHAR(100),
    ward NVARCHAR(100),
    detail NVARCHAR(200)
);

CREATE TABLE Categories (
    category_id INT PRIMARY KEY IDENTITY,
    parent_id INT,
    category_name NVARCHAR(100) NOT NULL,
    sort_order INT,
    status INT NOT NULL
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY IDENTITY,
    category_id INT,
    product_name NVARCHAR(100) NOT NULL,
    price DECIMAL(18, 2) NOT NULL,
    content NVARCHAR(MAX),
    discount DECIMAL(18, 2),
    img_url NVARCHAR(MAX),
    img_list NVARCHAR(MAX),
    created DATETIME NOT NULL,
    modified DATETIME NOT NULL,
    [view] INT NOT NULL,
    [status] INT NOT NULL
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY IDENTITY,
    user_id INT,
    order_date DATETIME NOT NULL,
    address_id INT,
    total_amount DECIMAL(18, 2) NOT NULL,
    payment_status INT NOT NULL,
    promotion_code NVARCHAR(50),
    discount_value DECIMAL(18, 2),
    [status] INT NOT NULL
);

CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY IDENTITY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(18, 2) NOT NULL
);

CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY IDENTITY,
    user_id INT,
    amount DECIMAL(18, 2) NOT NULL,
    [type] INT NOT NULL,
    order_id INT,
    created_at DATETIME NOT NULL
);

CREATE TABLE Settings (
    setting_id INT PRIMARY KEY IDENTITY,
    setting_key NVARCHAR(100) NOT NULL,
    setting_value NVARCHAR(MAX) NOT NULL
);

CREATE TABLE Payment_Methods (
    payment_method_id INT PRIMARY KEY IDENTITY,
    method_name NVARCHAR(100) NOT NULL,
    [status] INT NOT NULL
);

CREATE TABLE UserRoles (
    user_role_id INT PRIMARY KEY IDENTITY,
    user_id INT,
    role_id INT
);

CREATE TABLE Claims (
    claim_id INT PRIMARY KEY IDENTITY,
    claim_name NVARCHAR(100) NOT NULL
);

CREATE TABLE UserClaims (
    user_claim_id INT PRIMARY KEY IDENTITY,
    user_id INT,
    claim_id INT
);

CREATE TABLE RefreshTokens (
    refresh_token_id INT PRIMARY KEY IDENTITY,
    user_id INT,
    token NVARCHAR(200) NOT NULL,
    expiry_date DATETIME NOT NULL
);

CREATE TABLE AuditLogs (
    audit_log_id INT PRIMARY KEY IDENTITY,
    user_id INT,
    [action] NVARCHAR(100) NOT NULL,
    created_at DATETIME NOT NULL
);

CREATE TABLE BlacklistTokens (
    token_id INT PRIMARY KEY IDENTITY,
    token NVARCHAR(200) NOT NULL
);

-- Add Foreign Key Constraints

ALTER TABLE User_Details
ADD CONSTRAINT FK_UserDetails_Users FOREIGN KEY (user_id) REFERENCES Users(user_id);

ALTER TABLE Addresses
ADD CONSTRAINT FK_Addresses_Users FOREIGN KEY (user_id) REFERENCES Users(user_id);

ALTER TABLE Categories
ADD CONSTRAINT FK_Categories_Categories FOREIGN KEY (parent_id) REFERENCES Categories(category_id);

ALTER TABLE Products
ADD CONSTRAINT FK_Products_Categories FOREIGN KEY (category_id) REFERENCES Categories(category_id);

ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Users FOREIGN KEY (user_id) REFERENCES Users(user_id);

ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Addresses FOREIGN KEY (address_id) REFERENCES Addresses(address_id);

ALTER TABLE Order_Items
ADD CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (order_id) REFERENCES Orders(order_id);

ALTER TABLE Order_Items
ADD CONSTRAINT FK_OrderItems_Products FOREIGN KEY (product_id) REFERENCES Products(product_id);

ALTER TABLE Transactions
ADD CONSTRAINT FK_Transactions_Users FOREIGN KEY (user_id) REFERENCES Users(user_id);

ALTER TABLE Transactions
ADD CONSTRAINT FK_Transactions_Orders FOREIGN KEY (order_id) REFERENCES Orders(order_id);

ALTER TABLE UserRoles
ADD CONSTRAINT FK_UserRoles_Users FOREIGN KEY (user_id) REFERENCES Users(user_id);

ALTER TABLE UserRoles
ADD CONSTRAINT FK_UserRoles_Roles FOREIGN KEY (role_id) REFERENCES Roles(role_id);

ALTER TABLE UserClaims
ADD CONSTRAINT FK_UserClaims_Users FOREIGN KEY (user_id) REFERENCES Users(user_id);

ALTER TABLE UserClaims
ADD CONSTRAINT FK_UserClaims_Claims FOREIGN KEY (claim_id) REFERENCES Claims(claim_id);

ALTER TABLE RefreshTokens
ADD CONSTRAINT FK_RefreshTokens_Users FOREIGN KEY (user_id) REFERENCES Users(user_id);

ALTER TABLE AuditLogs
ADD CONSTRAINT FK_AuditLogs_Users FOREIGN KEY (user_id) REFERENCES Users(user_id);

-- Thêm dữ liệu vào bảng
INSERT INTO Users (google_id, email, phone_number, created_date, status, role_id)
VALUES 
    (NULL, 'customer@example.com', NULL, GETDATE(), 1, 1), -- Customer
    (NULL, 'manager@example.com', NULL, GETDATE(), 1, 2), -- Manager
    (NULL, 'admin@example.com', NULL, GETDATE(), 1, 3);   -- Admin

-- Thêm dữ liệu vào bảng Admins
INSERT INTO Admins (username, [password])
VALUES 
    ('admin', 'admin');   -- Admin password

-- Thêm dữ liệu vào bảng Category
INSERT INTO Categories (parent_id, category_name, sort_order, status)
VALUES 
    (NULL, 'Phần mềm', 1, 1),                -- Phần mềm
    (NULL, 'Bàn phím', 2, 1),                -- Bàn phím
    (1, 'Phần mềm đồ họa', 3, 1),            -- Phần mềm đồ họa
    (1, 'Phần mềm lập trình', 4, 1),         -- Phần mềm lập trình
    (2, '60%', 5, 1),                        -- 60%
    (2, '70%', 6, 1),                        -- 70%
    (2, 'TKL', 7, 1),                        -- TKL
    (2, 'Fullsize', 8, 1),                   -- Fullsize
    (2, 'Alice', 9, 1),                      -- Alice
    (2, 'Split', 10, 1);                     -- Split