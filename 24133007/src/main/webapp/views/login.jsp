<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Đăng Nhập - VideoHub</title>
</head>
<body>
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
                    <div class="bg-primary text-white text-center p-4">
                        <i class="fa-solid fa-circle-user fa-3x mb-2"></i>
                        <h4 class="fw-bold mb-1">Đăng Nhập Tài Khoản</h4>
                        <p class="small text-white-50 mb-0">Chào mừng bạn quay trở lại với VideoHub</p>
                    </div>

                    <div class="card-body p-4">
                        <!-- Thông báo lỗi -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger d-flex align-items-center mb-3" role="alert">
                                <i class="fa-solid fa-triangle-exclamation me-2"></i>
                                <div>${error}</div>
                            </div>
                        </c:if>

                        <!-- Thông báo thành công -->
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success d-flex align-items-center mb-3" role="alert">
                                <i class="fa-solid fa-circle-check me-2"></i>
                                <div>${successMessage}</div>
                            </div>
                        </c:if>

                        <!-- Cảnh báo vai trò -->
                        <c:if test="${not empty warningMessage}">
                            <div class="alert alert-warning d-flex align-items-center mb-3" role="alert">
                                <i class="fa-solid fa-circle-info me-2"></i>
                                <div>${warningMessage}</div>
                            </div>
                        </c:if>

                        <c:if test="${param.message == 'logout_success'}">
                            <div class="alert alert-info d-flex align-items-center mb-3" role="alert">
                                <i class="fa-solid fa-circle-info me-2"></i>
                                <div>Bạn đã đăng xuất khỏi hệ thống thành công.</div>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/login" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label fw-semibold">Tên đăng nhập:</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light"><i class="fa-solid fa-user text-muted"></i></span>
                                    <input type="text" class="form-control" id="username" name="username" placeholder="Nhập tên đăng nhập của bạn" required autofocus>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label for="password" class="form-label fw-semibold">Mật khẩu:</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light"><i class="fa-solid fa-key text-muted"></i></span>
                                    <input type="password" class="form-control" id="password" name="password" placeholder="Nhập mật khẩu" required>
                                </div>
                            </div>

                            <div class="d-grid gap-2 mb-3">
                                <button type="submit" class="btn btn-primary btn-lg fw-semibold shadow-sm">
                                    <i class="fa-solid fa-arrow-right-to-bracket me-2"></i> Đăng Nhập
                                </button>
                            </div>
                        </form>

                        <div class="text-center mt-3 pt-3 border-top">
                            <p class="text-muted small mb-1">Chưa có tài khoản?</p>
                            <a href="${pageContext.request.contextPath}/register" class="fw-semibold text-decoration-none">
                                <i class="fa-solid fa-user-plus me-1"></i> Đăng ký tài khoản mới
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
