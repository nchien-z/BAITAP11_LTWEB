<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản Trị Người Dùng - VideoHub Admin</title>
</head>
<body>
    <div class="container-fluid">
        <!-- Tiêu đề trang & Nút thêm mới -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold text-dark mb-1">
                    <i class="fa-solid fa-users text-primary me-2"></i>Quản Trị Người Dùng
                </h3>
                <p class="text-secondary mb-0">
                    Quản lý danh sách tài khoản thành viên và phân quyền trong hệ thống.
                </p>
            </div>
            <div class="d-flex gap-2 mt-3 mt-md-0">
                <a href="${pageContext.request.contextPath}/admin/users/add" class="btn btn-primary fw-semibold shadow-sm">
                    <i class="fa-solid fa-user-plus me-1"></i> Thêm Người Dùng Mới
                </a>
            </div>
        </div>

        <!-- Thông báo thao tác -->
        <c:if test="${param.success == 'added'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Thêm người dùng mới thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.success == 'updated'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Cập nhật thông tin người dùng thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.success == 'deleted'}">
            <div class="alert alert-info alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-trash-can me-2"></i> Đã xóa người dùng khỏi hệ thống.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Thẻ thống kê nhanh -->
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="card border-0 bg-white shadow-sm p-3 rounded-3 border-start border-primary border-4">
                    <div class="text-secondary small">Tổng số tài khoản</div>
                    <div class="fs-4 fw-bold text-dark">${totalUsers} người dùng</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 bg-white shadow-sm p-3 rounded-3 border-start border-success border-4">
                    <div class="text-secondary small">Số lượng hiển thị</div>
                    <div class="fs-4 fw-bold text-success">${pageSize} người dùng / trang</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 bg-white shadow-sm p-3 rounded-3 border-start border-info border-4">
                    <div class="text-secondary small">Trang hiện tại</div>
                    <div class="fs-4 fw-bold text-info">Trang ${currentPage} / ${totalPages}</div>
                </div>
            </div>
        </div>

        <!-- Bảng danh sách Users -->
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
            <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
                <span class="fw-bold text-dark">
                    <i class="fa-solid fa-table-list text-muted me-2"></i>Danh Sách Tài Khoản (Trang ${currentPage})
                </span>
                <span class="badge bg-light text-secondary border">Hiển thị ${userList.size()} bản ghi</span>
            </div>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light text-uppercase small text-secondary">
                        <tr>
                            <th scope="col" style="width: 70px;">Ảnh</th>
                            <th scope="col">Tên đăng nhập</th>
                            <th scope="col">Họ và tên</th>
                            <th scope="col">Email</th>
                            <th scope="col">Điện thoại</th>
                            <th scope="col" class="text-center">Vai trò</th>
                            <th scope="col" class="text-center">Trạng thái</th>
                            <th scope="col" class="text-center" style="width: 140px;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${userList}" var="u">
                            <tr>
                                <td>
                                    <img src="${u.images}" onerror="this.src='https://ui-avatars.com/api/?name=${u.fullname}'" 
                                         class="rounded-circle shadow-sm" style="width: 44px; height: 44px; object-fit: cover;">
                                </td>
                                <td>
                                    <strong class="text-dark">${u.username}</strong>
                                </td>
                                <td>${u.fullname}</td>
                                <td>
                                    <span class="text-muted">${u.email}</span>
                                </td>
                                <td>${u.phone}</td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${u.admin}">
                                            <span class="badge bg-danger-subtle text-danger px-2 py-1 fw-bold">Admin</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary-subtle text-secondary px-2 py-1">User</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${u.active}">
                                            <span class="badge bg-success-subtle text-success px-2 py-1"><i class="fa-solid fa-check me-1"></i>Active</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-warning-subtle text-warning-emphasis px-2 py-1"><i class="fa-solid fa-clock me-1"></i>Chờ OTP</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <div class="btn-group btn-group-sm">
                                        <a href="${pageContext.request.contextPath}/admin/users/edit?username=${u.username}" class="btn btn-outline-primary" title="Sửa thông tin">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/users/delete?username=${u.username}" 
                                           class="btn btn-outline-danger" 
                                           onclick="return confirm('Bạn có chắc chắn muốn xóa user [${u.username}] không?');"
                                           title="Xóa người dùng">
                                            <i class="fa-solid fa-trash-can"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Phân trang 6 user/trang -->
            <div class="card-footer bg-white py-3 border-top d-flex justify-content-between align-items-center flex-wrap gap-2">
                <div class="text-muted small">
                    Đang xem <strong>${userList.size()}</strong> / tổng số <strong>${totalUsers}</strong> người dùng
                </div>
                <nav aria-label="Page navigation">
                    <ul class="pagination mb-0 pagination-sm">
                        <!-- Nút First / Prev -->
                        <c:choose>
                            <c:when test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=1">&laquo;</a>
                                </li>
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${currentPage - 1}">&lsaquo;</a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="page-item disabled"><span class="page-link">&laquo;</span></li>
                                <li class="page-item disabled"><span class="page-link">&lsaquo;</span></li>
                            </c:otherwise>
                        </c:choose>

                        <!-- Số trang -->
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <li class="page-item ${p == currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${p}">${p}</a>
                            </li>
                        </c:forEach>

                        <!-- Nút Next / Last -->
                        <c:choose>
                            <c:when test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${currentPage + 1}">&rsaquo;</a>
                                </li>
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${totalPages}">&raquo;</a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="page-item disabled"><span class="page-link">&rsaquo;</span></li>
                                <li class="page-item disabled"><span class="page-link">&raquo;</span></li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</body>
</html>
