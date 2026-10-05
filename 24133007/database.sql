USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'WebVideo_24133007')
BEGIN
    CREATE DATABASE WebVideo_24133007;
END
GO

USE WebVideo_24133007;
GO

-- Xóa bảng cũ nếu tồn tại theo thứ tự khóa ngoại
IF OBJECT_ID('ActivationCodes', 'U') IS NOT NULL DROP TABLE ActivationCodes;
IF OBJECT_ID('OrderItems', 'U') IS NOT NULL DROP TABLE OrderItems;
IF OBJECT_ID('Orders', 'U') IS NOT NULL DROP TABLE Orders;
IF OBJECT_ID('Shares', 'U') IS NOT NULL DROP TABLE Shares;
IF OBJECT_ID('Favorites', 'U') IS NOT NULL DROP TABLE Favorites;
IF OBJECT_ID('Videos', 'U') IS NOT NULL DROP TABLE Videos;
IF OBJECT_ID('Products', 'U') IS NOT NULL DROP TABLE Products;
IF OBJECT_ID('Category', 'U') IS NOT NULL DROP TABLE Category;
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;
GO

-- 1. Bảng Category
CREATE TABLE Category (
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    Categoryname NVARCHAR(100) NOT NULL,
    Categorycode NVARCHAR(100) NULL,
    Images NVARCHAR(500) NULL,
    Status BIT DEFAULT 1
);
GO

-- 2. Bảng Users
CREATE TABLE Users (
    Username NVARCHAR(50) PRIMARY KEY,
    Password NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(15) NULL,
    Fullname NVARCHAR(50) NULL,
    Email NVARCHAR(150) NULL,
    Admin BIT DEFAULT 0,
    Active BIT DEFAULT 0,
    Images NVARCHAR(500) NULL
);
GO

-- 3. Bảng Videos
CREATE TABLE Videos (
    VideoId NVARCHAR(50) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    Poster NVARCHAR(500) NULL,
    Views INT DEFAULT 0,
    Description NVARCHAR(500) NULL,
    Active BIT DEFAULT 1,
    CategoryId INT FOREIGN KEY REFERENCES Category(CategoryId) ON DELETE CASCADE
);
GO

-- 4. Bảng Favorites
CREATE TABLE Favorites (
    FavoriteId INT IDENTITY(1,1) PRIMARY KEY,
    LikedDate DATE DEFAULT GETDATE(),
    VideoId NVARCHAR(50) FOREIGN KEY REFERENCES Videos(VideoId) ON DELETE CASCADE,
    Username NVARCHAR(50) FOREIGN KEY REFERENCES Users(Username) ON DELETE CASCADE
);
GO

-- 5. Bảng Shares
CREATE TABLE Shares (
    ShareId INT IDENTITY(1,1) PRIMARY KEY,
    Emails NVARCHAR(50) NULL,
    SharedDate DATE DEFAULT GETDATE(),
    Username NVARCHAR(50) FOREIGN KEY REFERENCES Users(Username) ON DELETE CASCADE,
    VideoId NVARCHAR(50) FOREIGN KEY REFERENCES Videos(VideoId) ON DELETE CASCADE
);
GO

-- =============================================
-- THÊM DỮ LIỆU MẪU (SEED DATA)
-- =============================================

-- Dữ liệu Users (Gồm admin và nhiều user để kiểm tra phân trang 6 user/trang)
INSERT INTO Users (Username, Password, Phone, Fullname, Email, Admin, Active, Images) VALUES
('admin', 'admin123', '0901234567', N'Quản Trị Viên', 'admin@ute.edu.vn', 1, 1, 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150'),
('chien24133007', '123456', '0912345678', N'Nguyễn Chiến', '24133007@student.hcmute.edu.vn', 1, 1, 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150'),
('user01', '123456', '0901112223', N'Trần Thị Mai', 'user01@gmail.com', 0, 1, 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150'),
('user02', '123456', '0902223334', N'Lê Hoàng Long', 'user02@gmail.com', 0, 1, 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150'),
('user03', '123456', '0903334445', N'Phạm Thu Hà', 'user03@gmail.com', 0, 1, 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150'),
('user04', '123456', '0904445556', N'Đỗ Minh Quân', 'user04@gmail.com', 0, 1, 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150'),
('user05', '123456', '0905556667', N'Hoàng Yến Nhi', 'user05@gmail.com', 0, 1, 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150'),
('user06', '123456', '0906667778', N'Ngô Gia Bảo', 'user06@gmail.com', 0, 1, 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150'),
('user07', '123456', '0907778889', N'Vũ Phương Linh', 'user07@gmail.com', 0, 1, 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150'),
('user08', '123456', '0908889990', N'Bùi Thanh Tùng', 'user08@gmail.com', 0, 1, 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150'),
('user09', '123456', '0909990001', N'Đinh Thùy Dung', 'user09@gmail.com', 0, 0, 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=150'),
('user10', '123456', '0901239876', N'Phan Quốc Việt', 'user10@gmail.com', 0, 1, 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=150');
GO

-- Dữ liệu Category
INSERT INTO Category (Categoryname, Categorycode, Images, Status) VALUES
(N'Công Nghệ & Lập Trình', 'TECH', 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=300', 1),
(N'Âm Nhạc Tuyển Chọn', 'MUSIC', 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=300', 1),
(N'Phim & Giải Trí', 'MOVIE', 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=300', 1),
(N'Khám Phá & Du Lịch', 'TRAVEL', 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=300', 1);
GO

-- Dữ liệu Videos (Đặc biệt Category 1 có nhiều hơn 6 video để phân trang 3 video/trang)
INSERT INTO Videos (VideoId, Title, Poster, Views, Description, Active, CategoryId) VALUES
('VID001', N'Khóa học Lập trình Web Servlet JSP cơ bản đến nâng cao', 'https://images.unsplash.com/photo-1587620962725-abab7fe55159?w=600', 15200, N'Hướng dẫn chi tiết xây dựng ứng dụng web với Java Servlet, JDBC và JSP theo mô hình MVC 3 lớp.', 1, 1),
('VID002', N'Tối ưu hóa Cơ sở dữ liệu SQL Server với Indexing', 'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=600', 8900, N'Bí quyết thiết kế schema, query optimization và sử dụng chỉ mục nâng cao hiệu năng hệ thống.', 1, 1),
('VID003', N'Xây dựng RESTful API chuyên nghiệp với Spring Boot 3', 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=600', 23400, N'Thiết kế chuẩn REST API, xác thực JWT, Swagger Documentation và bảo mật Spring Security.', 1, 1),
('VID004', N'Thực chiến GraphQL API trên nền tảng Spring Framework', 'https://images.unsplash.com/photo-1607799279861-4dd421887fb3?w=600', 6500, N'Tìm hiểu Schema GraphQL, Query, Mutation và tối ưu truy vấn N+1 problem hiệu quả.', 1, 1),
('VID005', N'Kiến trúc Microservices với Docker và Kubernetes', 'https://images.unsplash.com/photo-1618401471353-b98aedd04e11?w=600', 19800, N'Triển khai cụm microservices phân tán, API Gateway, Service Discovery và Config Server.', 1, 1),
('VID006', N'Lập trình Bất đồng bộ và Reactive Programming trong Java', 'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?w=600', 4100, N'Khám phá Spring WebFlux, Project Reactor và Non-blocking I/O model thế hệ mới.', 1, 1),
('VID007', N'Tuyển tập Acoustic Guitar nhẹ nhàng thư giãn học bài', 'https://images.unsplash.com/photo-1510915361894-db8b60106cb1?w=600', 45000, N'Những giai điệu guitar acoustic trong trẻo, mộc mạc giúp tập trung làm việc và giảm căng thẳng.', 1, 2),
('VID008', N'Top Bản Hit V-Pop Thịnh Hành Hay Nhất Năm 2026', 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=600', 78900, N'Bảng xếp hạng những ca khúc ballad và pop đình đám được yêu thích nhất.', 1, 2),
('VID009', N'Hậu trường kỹ xảo điện ảnh Hollywood đỉnh cao', 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=600', 31200, N'Khám phá công nghệ CGI, Motion Capture và kỹ xảo âm thanh trong các bộ phim bom tấn.', 1, 3),
('VID010', N'Hành trình khám phá Đảo Ngọc Phú Quốc 4K Tuyệt Đẹp', 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600', 54000, N'Trải nghiệm lặn ngắm san hô, ẩm thực hải sản và cảnh hoàng hôn tuyệt mỹ tại Bãi Sao.', 1, 4);
GO

-- Dữ liệu Favorites (Likes) - Tạo chính xác 10 likes cho VID001 để khớp Share(10) và Like(10) theo mẫu đề bài
INSERT INTO Favorites (LikedDate, VideoId, Username) VALUES
('2026-09-01', 'VID001', 'admin'),
('2026-09-02', 'VID001', 'chien24133007'),
('2026-09-03', 'VID001', 'user01'),
('2026-09-04', 'VID001', 'user02'),
('2026-09-05', 'VID001', 'user03'),
('2026-09-06', 'VID001', 'user04'),
('2026-09-07', 'VID001', 'user05'),
('2026-09-08', 'VID001', 'user06'),
('2026-09-09', 'VID001', 'user07'),
('2026-09-10', 'VID001', 'user08'),
('2026-09-11', 'VID002', 'user01'),
('2026-09-12', 'VID003', 'user02');
GO

-- Dữ liệu Shares - Tạo chính xác 10 shares cho VID001
INSERT INTO Shares (Emails, SharedDate, Username, VideoId) VALUES
('friend1@gmail.com', '2026-09-01', 'admin', 'VID001'),
('friend2@gmail.com', '2026-09-02', 'chien24133007', 'VID001'),
('friend3@gmail.com', '2026-09-03', 'user01', 'VID001'),
('friend4@gmail.com', '2026-09-04', 'user02', 'VID001'),
('friend5@gmail.com', '2026-09-05', 'user03', 'VID001'),
('friend6@gmail.com', '2026-09-06', 'user04', 'VID001'),
('friend7@gmail.com', '2026-09-07', 'user05', 'VID001'),
('friend8@gmail.com', '2026-09-08', 'user06', 'VID001'),
('friend9@gmail.com', '2026-09-09', 'user07', 'VID001'),
('friend10@gmail.com', '2026-09-10', 'user08', 'VID001'),
('friend11@gmail.com', '2026-09-11', 'user01', 'VID002');
GO

PRINT N'Khởi tạo Cơ sở dữ liệu WebVideo_24133007 và nạp dữ liệu mẫu thành công!';
