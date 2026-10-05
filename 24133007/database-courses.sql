-- Chạy sau database-shopping.sql; chỉ bổ sung/cập nhật dữ liệu mẫu liên quan khóa học.
USE WebVideo_24133007;
GO
IF COL_LENGTH('Videos','VideoUrl') IS NULL ALTER TABLE Videos ADD VideoUrl NVARCHAR(1000) NULL;
IF COL_LENGTH('Videos','UploadedBy') IS NULL ALTER TABLE Videos ADD UploadedBy NVARCHAR(50) NULL;
IF COL_LENGTH('Videos','IsPrivate') IS NULL ALTER TABLE Videos ADD IsPrivate BIT NOT NULL DEFAULT 0;
IF COL_LENGTH('Videos','CourseId') IS NULL ALTER TABLE Videos ADD CourseId INT NULL REFERENCES Products(ProductId);
GO
IF OBJECT_ID('ActivationCodes','U') IS NULL
BEGIN
    CREATE TABLE ActivationCodes (
        Code VARCHAR(36) PRIMARY KEY,
        OrderId BIGINT NOT NULL,
        ProductId INT NOT NULL,
        CodeIndex INT NOT NULL CHECK(CodeIndex BETWEEN 1 AND 99),
        ActivatedBy NVARCHAR(50) NULL REFERENCES Users(Username),
        ActivatedAt DATETIME2 NULL,
        FOREIGN KEY(OrderId,ProductId) REFERENCES OrderItems(OrderId,ProductId),
        UNIQUE(OrderId,ProductId,CodeIndex),
        CHECK ((ActivatedBy IS NULL AND ActivatedAt IS NULL) OR (ActivatedBy IS NOT NULL AND ActivatedAt IS NOT NULL))
    );
    CREATE INDEX IX_ActivationCodes_User ON ActivationCodes(ActivatedBy,ProductId);
END;
GO
UPDATE Products SET Name=N'Khóa học Servlet và JSP', Description=N'Khóa học xây dựng ứng dụng web Java. Mã kích hoạt được giao theo địa chỉ nhận hàng.' WHERE Name=N'Giáo trình Servlet và JSP';
UPDATE Products SET Name=N'Khóa học SQL Server', Description=N'Khóa học thiết kế và tối ưu cơ sở dữ liệu. Nhập mã để xem bài học private.' WHERE Name=N'Giáo trình SQL Server';
UPDATE Products SET Name=N'Khóa học Spring Boot', Description=N'Khóa học REST API và bảo mật. Mỗi suất mua có một mã kích hoạt.' WHERE Name=N'Bộ tài liệu Spring Boot';
UPDATE Products SET Name=N'Khóa học Java nâng cao', Description=N'Khóa học kiến trúc ứng dụng và lập trình bất đồng bộ.', Price=180000 WHERE Name=N'Sổ tay lập trình';
GO
-- Chỉ áp dụng phân quyền mẫu lần đầu, không ghi đè lựa chọn public/private đã chỉnh sau đó.
UPDATE Videos SET CourseId=(SELECT TOP 1 ProductId FROM Products WHERE Name=N'Khóa học Servlet và JSP'), IsPrivate=1 WHERE VideoId='VID001' AND CourseId IS NULL;
UPDATE Videos SET CourseId=(SELECT TOP 1 ProductId FROM Products WHERE Name=N'Khóa học SQL Server'), IsPrivate=1 WHERE VideoId='VID002' AND CourseId IS NULL;
UPDATE Videos SET CourseId=(SELECT TOP 1 ProductId FROM Products WHERE Name=N'Khóa học Spring Boot'), IsPrivate=1 WHERE VideoId='VID003' AND CourseId IS NULL;
UPDATE Videos SET CourseId=(SELECT TOP 1 ProductId FROM Products WHERE Name=N'Khóa học Servlet và JSP'), IsPrivate=0 WHERE VideoId='VID004' AND CourseId IS NULL;
UPDATE Videos SET CourseId=(SELECT TOP 1 ProductId FROM Products WHERE Name=N'Khóa học Java nâng cao'), IsPrivate=1 WHERE VideoId='VID005' AND CourseId IS NULL;
UPDATE Videos SET CourseId=(SELECT TOP 1 ProductId FROM Products WHERE Name=N'Khóa học Java nâng cao'), IsPrivate=0 WHERE VideoId='VID006' AND CourseId IS NULL;
GO
-- Bổ sung mã cho đơn hiện có, một mã cho mỗi suất khóa học đã mua.
WITH Numbers AS (SELECT 1 AS n UNION ALL SELECT n+1 FROM Numbers WHERE n<99)
INSERT INTO ActivationCodes(Code,OrderId,ProductId,CodeIndex)
SELECT UPPER(CONVERT(VARCHAR(36),NEWID())), i.OrderId,i.ProductId,n.n
FROM OrderItems i JOIN Numbers n ON n.n<=i.Quantity
WHERE NOT EXISTS (SELECT 1 FROM ActivationCodes a WHERE a.OrderId=i.OrderId AND a.ProductId=i.ProductId AND a.CodeIndex=n.n)
OPTION(MAXRECURSION 100);
GO
