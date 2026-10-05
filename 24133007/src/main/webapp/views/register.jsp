<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>Đăng Ký Tài Khoản - VideoHub</title>
</head>
<body>
    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-md-7 col-lg-6">
                <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
                    <div class="bg-primary text-white text-center p-4">
                        <i class="fa-solid fa-user-plus fa-3x mb-2"></i>
                        <h4 class="fw-bold mb-1">Đăng Ký Tài Khoản Mới</h4>
                        <p class="small text-white-50 mb-0">Tạo tài khoản để trải nghiệm toàn bộ tính năng</p>
                    </div>

                    <div class="card-body p-4">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger d-flex align-items-center mb-3" role="alert">
                                <i class="fa-solid fa-triangle-exclamation me-2"></i>
                                <div>${error}</div>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/register" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label fw-semibold">Tên đăng nhập: <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light"><i class="fa-solid fa-user text-muted"></i></span>
                                    <input type="text" class="form-control" id="username" name="username" placeholder="Nhập tên đăng nhập duy nhất" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="password" class="form-label fw-semibold">Mật khẩu: <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light"><i class="fa-solid fa-lock text-muted"></i></span>
                                    <input type="password" class="form-control" id="password" name="password" placeholder="Nhập mật khẩu an toàn" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="fullname" class="form-label fw-semibold">Họ và tên: <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light"><i class="fa-solid fa-id-badge text-muted"></i></span>
                                    <input type="text" class="form-control" id="fullname" name="fullname" placeholder="Nguyễn Văn A" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label fw-semibold">Email nhận mã OTP: <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light"><i class="fa-solid fa-envelope text-muted"></i></span>
                                    <input type="email" class="form-control" id="email" name="email" placeholder="example@gmail.com" required>
                                </div>
                                <div class="form-text text-muted">Mã kích hoạt OTP 6 số sẽ được gửi tới địa chỉ email này.</div>
                            </div>

                            <div class="mb-4">
                                <label for="phone" class="form-label fw-semibold">Số điện thoại:</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light"><i class="fa-solid fa-phone text-muted"></i></span>
                                    <input type="tel" class="form-control" id="phone" name="phone" placeholder="0912345678">
                                </div>
                            </div>

                            <div class="d-grid gap-2 mb-3">
                                <button type="submit" class="btn btn-primary btn-lg fw-semibold shadow-sm">
                                    <i class="fa-solid fa-paper-plane me-2"></i> Tiếp Tục & Nhận Mã OTP
                                </button>
                            </div>
                        </form>

                        <div class="text-center mt-3 pt-3 border-top">
                            <span class="text-muted small">Đã có tài khoản? </span>
                            <a href="${pageContext.request.contextPath}/login" class="fw-semibold text-decoration-none">
                                Đăng nhập ngay
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
