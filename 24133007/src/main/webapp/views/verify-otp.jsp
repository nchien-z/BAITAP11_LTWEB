<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Xác Thực OTP - VideoHub</title>
</head>
<body>
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card border-0 shadow-lg rounded-4 overflow-hidden text-center">
                    <div class="bg-primary text-white p-4">
                        <div class="rounded-circle bg-white bg-opacity-25 d-inline-flex align-items-center justify-content-center text-white mb-2" style="width: 70px; height: 70px;">
                            <i class="fa-solid fa-envelope-circle-check fa-2x"></i>
                        </div>
                        <h4 class="fw-bold mb-1">Xác Thực Mã OTP</h4>
                        <p class="small text-white-50 mb-0">Mã kích hoạt đã được gửi tới email đăng ký của bạn</p>
                    </div>

                    <div class="card-body p-4">
                        <c:if test="${not empty message}">
                            <div class="alert alert-info py-2 small mb-3">
                                ${message}
                            </div>
                        </c:if>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger py-2 small mb-3">
                                ${error}
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/verify-otp" method="post">
                            <div class="mb-4">
                                <label for="otp" class="form-label fw-semibold">Nhập mã OTP 6 chữ số:</label>
                                <input type="text" class="form-control form-control-lg text-center fw-bold letter-spacing-lg" 
                                       id="otp" name="otp" maxlength="6" placeholder="------" 
                                       style="letter-spacing: 0.5rem; font-size: 1.8rem;" required autofocus>
                                <div class="form-text mt-2 text-muted">Mã xác thực có hiệu lực trong vòng 5 phút</div>
                            </div>

                            <div class="d-grid gap-2 mb-3">
                                <button type="submit" class="btn btn-primary btn-lg fw-semibold shadow-sm">
                                    <i class="fa-solid fa-circle-check me-2"></i> Kích Hoạt Tài Khoản
                                </button>
                            </div>
                        </form>

                        <div class="text-center mt-3 pt-3 border-top">
                            <span class="text-muted small">Chưa nhận được mã? </span>
                            <a href="${pageContext.request.contextPath}/register" class="fw-semibold text-decoration-none">
                                Gửi lại mã hoặc đổi email
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
