<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property="title">VideoHub - Nền Tảng Video & Giải Trí Trực Tuyến</sitemesh:write></title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome 6 -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --primary-dark: #1d4ed8;
            --dark-bg: #0b0f19;
            --dark-card: #111827;
        }
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background-color: #f8fafc;
            color: #1e293b;
        }
        .main-navbar {
            background: rgba(11, 15, 25, 0.95);
            backdrop-filter: blur(12px);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
            padding: 0.85rem 0;
        }
        .navbar-brand {
            font-weight: 800;
            font-size: 1.4rem;
            letter-spacing: -0.5px;
            color: #ffffff !important;
        }
        .navbar-brand span {
            color: #38bdf8;
        }
        .nav-link {
            font-weight: 500;
            color: #94a3b8 !important;
            padding: 0.5rem 1rem !important;
            border-radius: 8px;
            transition: all 0.2s ease;
        }
        .nav-link:hover, .nav-link.active {
            color: #ffffff !important;
            background-color: rgba(255, 255, 255, 0.08);
        }
        .btn-admin-nav {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: white !important;
            font-weight: 600;
            border-radius: 8px;
            padding: 0.45rem 1rem;
            box-shadow: 0 2px 10px rgba(245, 158, 11, 0.25);
            border: none;
            transition: transform 0.2s ease;
        }
        .btn-admin-nav:hover {
            transform: translateY(-2px);
            background: linear-gradient(135deg, #fbbf24, #d97706);
        }
        .btn-login-nav {
            border: 1.5px solid rgba(56, 189, 248, 0.6);
            color: #38bdf8 !important;
            border-radius: 8px;
            font-weight: 600;
            padding: 0.45rem 1.1rem;
            transition: all 0.2s ease;
        }
        .btn-login-nav:hover {
            background-color: #38bdf8;
            color: #0b0f19 !important;
        }
        .btn-register-nav {
            background: #2563eb;
            color: white !important;
            font-weight: 600;
            border-radius: 8px;
            padding: 0.45rem 1.1rem;
            border: none;
            transition: all 0.2s ease;
        }
        .btn-register-nav:hover {
            background: #1d4ed8;
            transform: translateY(-1px);
        }
        /* Real Website Footer */
        .footer-custom {
            margin-top: auto;
            background: #0b0f19;
            color: #94a3b8;
            border-top: 1px solid rgba(255, 255, 255, 0.08);
            padding: 3.5rem 0 1.5rem;
        }
        .footer-heading {
            color: #ffffff;
            font-weight: 700;
            font-size: 0.95rem;
            margin-bottom: 1.25rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .footer-links {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .footer-links li {
            margin-bottom: 0.75rem;
        }
        .footer-links a {
            color: #94a3b8;
            text-decoration: none;
            transition: color 0.2s;
            font-size: 0.9rem;
        }
        .footer-links a:hover {
            color: #38bdf8;
        }
        .footer-social a {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.08);
            color: #cbd5e1;
            text-decoration: none;
            transition: all 0.2s;
        }
        .footer-social a:hover {
            background: #2563eb;
            color: #ffffff;
            transform: translateY(-2px);
        }
        .footer-bottom {
            margin-top: 3rem;
            padding-top: 1.5rem;
            border-top: 1px solid rgba(255, 255, 255, 0.06);
            font-size: 0.85rem;
        }
    </style>
    <sitemesh:write property="head"/>
</head>
<body>

    <!-- Main Navigation Header -->
    <header>
        <nav class="navbar navbar-expand-lg main-navbar sticky-top">
            <div class="container">
                <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/home">
                    <i class="fa-solid fa-circle-play text-primary fs-3 me-2"></i>
                    <span>Video<strong>Hub</strong></span>
                </a>
                <button class="navbar-toggler text-white border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
                    <i class="fa-solid fa-bars"></i>
                </button>

                <div class="collapse navbar-collapse" id="navbarContent">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/home">
                                <i class="fa-solid fa-house me-1"></i> Trang Chủ
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/video/category">
                                <i class="fa-solid fa-film me-1"></i> Khám Phá Video
                            </a>
                        </li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/products">Khóa học</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/my-courses">Khóa học của tôi</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/activate">Kích hoạt</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cart">Giỏ hàng</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/orders">Đơn hàng</a></li>
                    </ul>

                    <div class="d-flex align-items-center gap-2">
                        <!-- Nút Đăng Video trực quan -->
                        <a href="${pageContext.request.contextPath}/admin/videos/add" class="btn btn-outline-info me-1 d-inline-flex align-items-center">
                            <i class="fa-solid fa-cloud-arrow-up me-1"></i> Đăng Video
                        </a>

                        <!-- Trang quản trị: Chỉ hiển thị cho tài khoản Admin -->
                        <c:if test="${sessionScope.account != null && sessionScope.account.admin}">
                            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-admin-nav me-1">
                                <i class="fa-solid fa-gauge me-1"></i> Quản Trị
                            </a>
                        </c:if>

                        <c:choose>
                            <c:when test="${sessionScope.account != null}">
                                <div class="dropdown">
                                    <button class="btn btn-outline-light dropdown-toggle d-flex align-items-center gap-2" type="button" data-bs-toggle="dropdown">
                                        <img src="${sessionScope.account.images}" onerror="this.src='https://ui-avatars.com/api/?name=${sessionScope.account.fullname}'" class="rounded-circle" style="width: 28px; height: 28px; object-fit: cover;">
                                        <span>${sessionScope.account.fullname}</span>
                                    </button>
                                    <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2">
                                        <li><span class="dropdown-item-text text-muted small">@${sessionScope.account.username}</span></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/videos/add"><i class="fa-solid fa-cloud-arrow-up text-primary me-2"></i>Đăng Video Mới</a></li>
                                        <c:if test="${sessionScope.account.admin}">
                                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/videos"><i class="fa-solid fa-film me-2"></i>Quản Trị Video</a></li>
                                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-gear me-2"></i>Quản Trị Người Dùng</a></li>
                                        </c:if>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket me-2"></i>Đăng Xuất</a></li>
                                    </ul>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-login-nav">
                                    <i class="fa-solid fa-arrow-right-to-bracket me-1"></i> Đăng Nhập
                                </a>
                                <a href="${pageContext.request.contextPath}/register" class="btn btn-register-nav">
                                    <i class="fa-solid fa-user-plus me-1"></i> Đăng Ký
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </nav>
    </header>

    <!-- Main Content Area -->
    <main class="flex-grow-1 py-4">
        <sitemesh:write property="body"/>
    </main>

    <!-- Realistic Commercial Footer -->
    <footer class="footer-custom">
        <div class="container">
            <div class="row g-4">
                <div class="col-lg-4 col-md-6">
                    <div class="d-flex align-items-center mb-3">
                        <i class="fa-solid fa-circle-play text-primary fs-3 me-2"></i>
                        <span class="fs-4 fw-bold text-white">Video<strong>Hub</strong></span>
                    </div>
                    <p class="small text-secondary mb-4" style="line-height: 1.7;">
                        Nền tảng chia sẻ và trình chiếu video trực tuyến chất lượng cao. Khám phá hàng ngàn nội dung giải trí, công nghệ, âm nhạc và kiến thức hấp dẫn mỗi ngày.
                    </p>
                    <div class="footer-social d-flex gap-2">
                        <a href="#" title="Facebook"><i class="fa-brands fa-facebook-f"></i></a>
                        <a href="#" title="Youtube"><i class="fa-brands fa-youtube"></i></a>
                        <a href="#" title="TikTok"><i class="fa-brands fa-tiktok"></i></a>
                        <a href="#" title="Twitter"><i class="fa-brands fa-x-twitter"></i></a>
                    </div>
                </div>

                <div class="col-lg-2 col-md-6 col-6">
                    <div class="footer-heading">Khám Phá</div>
                    <ul class="footer-links">
                        <li><a href="${pageContext.request.contextPath}/home">Trang Chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/video/category">Tất Cả Video</a></li>
                        <li><a href="${pageContext.request.contextPath}/video/category?categoryId=1">Công Nghệ & Lập Trình</a></li>
                        <li><a href="${pageContext.request.contextPath}/video/category?categoryId=2">Âm Nhạc Tuyển Chọn</a></li>
                        <li><a href="${pageContext.request.contextPath}/video/category?categoryId=3">Phim Ngắn & Hoạt Hình</a></li>
                    </ul>
                </div>

                <div class="col-lg-2 col-md-6 col-6">
                    <div class="footer-heading">Tài Khoản</div>
                    <ul class="footer-links">
                        <li><a href="${pageContext.request.contextPath}/login">Đăng Nhập</a></li>
                        <li><a href="${pageContext.request.contextPath}/register">Đăng Ký Thành Viên</a></li>
                        <li><a href="${pageContext.request.contextPath}/verify-otp">Xác Thực Tài Khoản</a></li>
                        <li><a href="#">Video Yêu Thích</a></li>
                    </ul>
                </div>

                <div class="col-lg-4 col-md-6">
                    <div class="footer-heading">Hỗ Trợ & Liên Hệ</div>
                    <p class="small text-secondary mb-3">
                        Đăng ký nhận thông báo về các video mới nhất và xu hướng nổi bật hàng tuần.
                    </p>
                    <div class="input-group mb-3">
                        <input type="email" class="form-control bg-dark border-secondary text-white small" placeholder="Nhập email của bạn...">
                        <button class="btn btn-primary" type="button"><i class="fa-solid fa-paper-plane"></i></button>
                    </div>
                    <div class="small text-secondary">
                        <i class="fa-solid fa-shield-halved text-success me-1"></i> Cam kết bảo mật thông tin 100%
                    </div>
                </div>
            </div>

            <div class="footer-bottom d-flex flex-wrap justify-content-between align-items-center">
                <div>
                    © 2026 VideoHub Entertainment. Tất cả các quyền được bảo lưu.
                </div>
                <div class="d-flex gap-3 mt-2 mt-md-0">
                    <a href="#" class="text-secondary text-decoration-none">Điều Khoản Sử Dụng</a>
                    <a href="#" class="text-secondary text-decoration-none">Chính Sách Bảo Mật</a>
                    <a href="#" class="text-secondary text-decoration-none">Cookies</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
