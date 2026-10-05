<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property="title">Quản Trị Hệ Thống - VideoHub Admin</sitemesh:write></title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome 6 -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --admin-sidebar-bg: #0f172a;
            --admin-sidebar-hover: #1e293b;
            --admin-primary: #3b82f6;
        }
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #f1f5f9;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .admin-sidebar {
            width: 260px;
            background: var(--admin-sidebar-bg);
            color: #e2e8f0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
        }
        .sidebar-brand {
            padding: 1.5rem 1.25rem;
            font-size: 1.25rem;
            font-weight: 800;
            color: #ffffff;
            border-bottom: 1px solid #334155;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .sidebar-brand span {
            color: #38bdf8;
        }
        .sidebar-nav {
            list-style: none;
            padding: 1rem 0.75rem;
            margin: 0;
            display: flex;
            flex-direction: column;
            gap: 0.35rem;
        }
        .sidebar-nav .nav-link {
            color: #94a3b8;
            padding: 0.75rem 1rem;
            border-radius: 8px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            transition: all 0.2s;
        }
        .sidebar-nav .nav-link:hover, .sidebar-nav .nav-link.active {
            background-color: var(--admin-sidebar-hover);
            color: #38bdf8;
        }
        .admin-main-wrapper {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }
        .admin-header {
            background: #ffffff;
            border-bottom: 1px solid #e2e8f0;
            padding: 0.85rem 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        .admin-content {
            flex-grow: 1;
            padding: 2rem 1.5rem;
        }
        .admin-footer {
            background: #ffffff;
            border-top: 1px solid #e2e8f0;
            padding: 1rem 1.5rem;
            color: #64748b;
            font-size: 0.875rem;
        }
    </style>
    <sitemesh:write property="head"/>
</head>
<body>
    <div class="d-flex min-vh-100">
        <!-- Sidebar Admin -->
        <aside class="admin-sidebar">
            <div class="sidebar-brand">
                <i class="fa-solid fa-circle-play text-primary fs-4"></i>
                <span>Video<strong>Hub</strong> Admin</span>
            </div>

            <div class="p-3 border-bottom border-secondary border-opacity-25 d-flex align-items-center gap-3">
                <img src="${sessionScope.account.images}" onerror="this.src='https://ui-avatars.com/api/?name=${sessionScope.account.fullname}'" class="rounded-circle" style="width: 42px; height: 42px; object-fit: cover; border: 2px solid #38bdf8;">
                <div>
                    <div class="fw-bold text-white small">${sessionScope.account.fullname}</div>
                    <span class="badge bg-danger" style="font-size: 0.7rem;">ADMINISTRATOR</span>
                </div>
            </div>

            <ul class="sidebar-nav flex-grow-1">
                <li class="sidebar-heading text-uppercase text-secondary small px-3 mt-2 mb-1" style="font-size: 0.75rem; font-weight: 700;">Quản lý dữ liệu</li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/users" class="nav-link active">
                        <i class="fa-solid fa-users"></i> Quản Trị Người Dùng
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/video/category" class="nav-link">
                        <i class="fa-solid fa-video"></i> Quản Lý Video & Thể Loại
                    </a>
                </li>
                <li class="sidebar-heading text-uppercase text-secondary small px-3 mt-3 mb-1" style="font-size: 0.75rem; font-weight: 700;">Hệ thống</li>
                <li>
                    <a href="${pageContext.request.contextPath}/home" class="nav-link">
                        <i class="fa-solid fa-arrow-up-right-from-square"></i> Xem Giao Diện Website
                    </a>
                </li>
                <li><a class="nav-link" href="${pageContext.request.contextPath}/admin/course-codes"><i class="fa-solid fa-key"></i> Giao mã khóa học</a></li>
            </ul>

            <div class="p-3 border-top border-secondary border-opacity-25">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger w-100 btn-sm">
                    <i class="fa-solid fa-right-from-bracket me-1"></i> Đăng Xuất Admin
                </a>
            </div>
        </aside>

        <!-- Main Content Area -->
        <div class="admin-main-wrapper">
            <header class="admin-header d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center gap-2">
                    <span class="badge bg-primary px-3 py-2 fw-semibold"><i class="fa-solid fa-shield-halved me-1"></i> BẢNG ĐIỀU KHIỂN QUẢN TRỊ</span>
                    <span class="text-secondary small d-none d-md-inline">Hệ thống quản lý Video & Tài khoản trực tuyến</span>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-sm btn-outline-secondary">
                        <i class="fa-solid fa-globe me-1"></i> Xem Website
                    </a>
                </div>
            </header>

            <main class="admin-content">
                <sitemesh:write property="body"/>
            </main>

            <!-- Clean Admin Footer -->
            <footer class="admin-footer">
                <div class="container-fluid d-flex flex-wrap justify-content-between align-items-center">
                    <div>
                        © 2026 <strong>VideoHub Management Portal</strong>. Tất cả các quyền được bảo lưu.
                    </div>
                    <div class="text-muted small">
                        Phiên bản 1.0.0 (Production)
                    </div>
                </div>
            </footer>
        </div>
    </div>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
