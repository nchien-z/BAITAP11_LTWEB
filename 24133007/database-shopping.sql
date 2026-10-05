-- Chạy sau database.sql trên database hiện có. Script này không xóa dữ liệu cũ.
USE WebVideo_24133007;
GO
IF OBJECT_ID('Products', 'U') IS NULL
BEGIN
    CREATE TABLE Products (
        ProductId INT IDENTITY PRIMARY KEY,
        Name NVARCHAR(200) NOT NULL,
        Description NVARCHAR(500) NULL,
        Price DECIMAL(18,2) NOT NULL CHECK (Price > 0),
        Stock INT NOT NULL CHECK (Stock >= 0),
        Active BIT NOT NULL DEFAULT 1
    );
    INSERT INTO Products(Name, Description, Price, Stock) VALUES
    (N'Giáo trình Servlet và JSP', N'Sách thực hành xây dựng ứng dụng web Java.', 150000, 20),
    (N'Giáo trình SQL Server', N'Sách thiết kế và tối ưu cơ sở dữ liệu.', 120000, 10),
    (N'Bộ tài liệu Spring Boot', N'Tài liệu thực hành REST API và bảo mật.', 200000, 5),
    (N'Sổ tay lập trình', N'Sổ ghi chú dành cho sinh viên.', 35000, 100);
END;
GO
IF OBJECT_ID('Orders', 'U') IS NULL
BEGIN
    CREATE TABLE Orders (
        OrderId BIGINT IDENTITY PRIMARY KEY,
        Username NVARCHAR(50) NOT NULL REFERENCES Users(Username),
        CheckoutToken VARCHAR(36) NOT NULL UNIQUE,
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
        Status VARCHAR(20) NOT NULL DEFAULT 'NEW'
            CHECK (Status IN ('NEW','CONFIRMED','PREPARING','SHIPPING','DELIVERING','DELIVERED','CANCELLED','RETURNED')),
        Recipient NVARCHAR(100) NOT NULL,
        Phone VARCHAR(15) NOT NULL,
        Address NVARCHAR(500) NOT NULL,
        Note NVARCHAR(500) NULL,
        PaymentMethod VARCHAR(10) NOT NULL DEFAULT 'COD' CHECK (PaymentMethod = 'COD'),
        Total DECIMAL(18,2) NOT NULL CHECK (Total > 0)
    );
    CREATE INDEX IX_Orders_User_Status ON Orders(Username, Status, CreatedAt DESC);
END;
GO
IF OBJECT_ID('OrderItems', 'U') IS NULL
BEGIN
    CREATE TABLE OrderItems (
        OrderId BIGINT NOT NULL REFERENCES Orders(OrderId),
        ProductId INT NOT NULL REFERENCES Products(ProductId),
        ProductName NVARCHAR(200) NOT NULL,
        UnitPrice DECIMAL(18,2) NOT NULL CHECK (UnitPrice > 0),
        Quantity INT NOT NULL CHECK (Quantity BETWEEN 1 AND 99),
        PRIMARY KEY (OrderId, ProductId)
    );
END;
GO
