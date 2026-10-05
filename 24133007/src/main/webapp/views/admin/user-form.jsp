<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${isEdit ? 'Cập Nhật' : 'Thêm Mới'} Người Dùng - VideoHub Admin</title>
</head>
<body>
    <div class="container py-3">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                    <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
                        <h5 class="fw-bold text-dark mb-0">
                            <i class="fa-solid ${isEdit ? 'fa-user-pen text-warning' : 'fa-user-plus text-primary'} me-2"></i>
                            ${isEdit ? 'Cập Nhật Thông Tin Người Dùng' : 'Thêm Người Dùng Mới'}
                        </h5>
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-sm btn-outline-secondary">
                            <i class="fa-solid fa-arrow-left me-1"></i> Quay lại danh sách
                        </a>
                    </div>

                    <div class="card-body p-4">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger mb-3" role="alert">
                                <i class="fa-solid fa-triangle-exclamation me-2"></i> ${error}
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/admin/users/${isEdit ? 'edit' : 'add'}" method="post">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="username" class="form-label fw-semibold">Tên đăng nhập: <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control ${isEdit ? 'bg-light' : ''}" id="username" name="username" 
                                           value="${user.username}" ${isEdit ? 'readonly' : 'required'}>
                                    <c:if test="${isEdit}">
                                        <div class="form-text text-muted">Không thể thay đổi Username khi sửa.</div>
                                    </c:if>
                                </div>

                                <div class="col-md-6">
                                    <label for="password" class="form-label fw-semibold">Mật khẩu: <c:if test="${!isEdit}"><span class="text-danger">*</span></c:if></label>
                                    <input type="password" class="form-control" id="password" name="password" 
                                           value="${user.password}" ${isEdit ? '' : 'required'} 
                                           placeholder="${isEdit ? 'Để trống nếu không đổi mật khẩu' : 'Nhập mật khẩu'}">
                                </div>

                                <div class="col-md-6">
                                    <label for="fullname" class="form-label fw-semibold">Họ và tên: <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="fullname" name="fullname" 
                                           value="${user.fullname}" required placeholder="Nguyễn Văn A">
                                </div>

                                <div class="col-md-6">
                                    <label for="email" class="form-label fw-semibold">Email: <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           value="${user.email}" required placeholder="example@gmail.com">
                                </div>

                                <div class="col-md-6">
                                    <label for="phone" class="form-label fw-semibold">Số điện thoại:</label>
                                    <input type="tel" class="form-control" id="phone" name="phone" 
                                           value="${user.phone}" placeholder="0912345678">
                                </div>

                                <div class="col-md-6">
                                    <label for="images" class="form-label fw-semibold">URL Ảnh đại diện:</label>
                                    <input type="url" class="form-control" id="images" name="images" 
                                           value="${user.images}" placeholder="https://...">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold d-block">Vai trò hệ thống:</label>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="admin" id="roleUser" value="false" ${!user.admin ? 'checked' : ''}>
                                        <label class="form-check-label" for="roleUser">Người dùng thường (User)</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="admin" id="roleAdmin" value="true" ${user.admin ? 'checked' : ''}>
                                        <label class="form-check-label fw-bold text-danger" for="roleAdmin">Quản trị viên (Admin)</label>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold d-block">Trạng thái kích hoạt:</label>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="active" id="statusActive" value="true" ${user.active ? 'checked' : ''}>
                                        <label class="form-check-label text-success fw-semibold" for="statusActive">Đã kích hoạt (Active)</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="active" id="statusInactive" value="false" ${!user.active ? 'checked' : ''}>
                                        <label class="form-check-label text-warning-emphasis" for="statusInactive">Chưa kích hoạt (Chờ OTP)</label>
                                    </div>
                                </div>
                            </div>

                            <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-light border px-4">
                                    Hủy bỏ
                                </a>
                                <button type="submit" class="btn btn-primary px-4 fw-semibold">
                                    <i class="fa-solid fa-floppy-disk me-1"></i> Lưu thông tin
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
