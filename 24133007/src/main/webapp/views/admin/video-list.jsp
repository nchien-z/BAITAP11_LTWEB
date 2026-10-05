<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản Lý Video - VideoHub Admin</title>
</head>
<body>
    <div class="container-fluid">
        <!-- Tiêu đề trang & Nút Đăng Video Mới -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold text-dark mb-1">
                    <i class="fa-solid fa-film text-primary me-2"></i>Quản Lý Video
                </h3>
                <p class="text-secondary mb-0">
                    Danh sách toàn bộ video trong hệ thống, quản lý nội dung và đăng video mới.
                </p>
            </div>
            <div class="d-flex gap-2 mt-3 mt-md-0">
                <a href="${pageContext.request.contextPath}/admin/videos/add" class="btn btn-primary fw-semibold shadow-sm">
                    <i class="fa-solid fa-cloud-arrow-up me-1"></i> Đăng Video Mới
                </a>
            </div>
        </div>

        <!-- Thông báo thao tác -->
        <c:if test="${param.success == 'added'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Đăng video mới thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.success == 'updated'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Cập nhật video thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.success == 'deleted'}">
            <div class="alert alert-info alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-trash-can me-2"></i> Đã xóa video khỏi hệ thống.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Thống kê nhanh -->
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="card border-0 bg-white shadow-sm p-3 rounded-3 border-start border-primary border-4">
                    <div class="text-secondary small">Tổng số video</div>
                    <div class="fs-4 fw-bold text-dark">${totalVideos} video</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 bg-white shadow-sm p-3 rounded-3 border-start border-success border-4">
                    <div class="text-secondary small">Hiển thị mỗi trang</div>
                    <div class="fs-4 fw-bold text-success">${pageSize} video / trang</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 bg-white shadow-sm p-3 rounded-3 border-start border-info border-4">
                    <div class="text-secondary small">Trang hiện tại</div>
                    <div class="fs-4 fw-bold text-info">Trang ${currentPage} / ${totalPages}</div>
                </div>
            </div>
        </div>

        <!-- Bảng danh sách Video -->
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
            <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
                <span class="fw-bold text-dark">
                    <i class="fa-solid fa-table-cells text-muted me-2"></i>Danh Sách Video (Trang ${currentPage})
                </span>
                <span class="badge bg-light text-secondary border">Hiển thị ${videoList.size()} bản ghi</span>
            </div>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light text-uppercase small text-secondary">
                        <tr>
                            <th scope="col" style="width: 100px;">Poster</th>
                            <th scope="col" style="width: 110px;">Mã Video</th>
                            <th scope="col">Tiêu Đề</th>
                            <th scope="col">Danh Mục</th>
                            <th scope="col" class="text-center">Người Đăng</th>
                            <th scope="col" class="text-center">Lượt Xem</th>
                            <th scope="col" class="text-center">Tương Tác</th>
                            <th scope="col" class="text-center">Trạng Thái</th>
                            <th scope="col" class="text-center" style="width: 150px;">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${videoList}" var="v">
                            <tr>
                                <td>
                                    <img src="${v.poster}" alt="${v.title}" onerror="this.src='https://images.unsplash.com/photo-1587620962725-abab7fe55159?w=600'" 
                                         class="rounded-3 shadow-sm" style="width: 80px; height: 50px; object-fit: cover;">
                                </td>
                                <td>
                                    <span class="badge bg-dark">${v.videoId}</span>
                                </td>
                                <td>
                                    <strong class="text-dark d-block" style="max-width: 260px; text-overflow: ellipsis; overflow: hidden; white-space: nowrap;">
                                        ${v.title}
                                    </strong>
                                    <small class="text-muted text-truncate d-block" style="max-width: 260px;">${v.description}</small>
                                </td>
                                <td>
                                    <span class="badge bg-primary-subtle text-primary">${v.categoryName}</span>
                                    <span class="badge ${v.privateVideo ? 'bg-warning text-dark' : 'bg-success'}">${v.privateVideo ? 'Private' : 'Public'}</span>
                                </td>
                                <!-- Cột Người Đăng -->
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${not empty v.uploadedBy}">
                                            <span class="badge bg-info-subtle text-info d-inline-flex align-items-center gap-1">
                                                <i class="fa-solid fa-user fa-xs"></i>
                                                ${v.uploadedBy}
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted small">—</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <span class="fw-semibold text-secondary"><i class="fa-solid fa-eye me-1"></i>${v.views}</span>
                                </td>
                                <td class="text-center small">
                                    <span class="text-danger me-2"><i class="fa-solid fa-heart me-1"></i>${v.likeCount}</span>
                                    <span class="text-primary"><i class="fa-solid fa-share me-1"></i>${v.shareCount}</span>
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${v.active}">
                                            <span class="badge bg-success-subtle text-success px-2 py-1"><i class="fa-solid fa-check me-1"></i>Hiển thị</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary-subtle text-secondary px-2 py-1">Ẩn</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <div class="btn-group btn-group-sm">
                                        <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" class="btn btn-outline-info" title="Xem trên web" target="_blank">
                                            <i class="fa-solid fa-arrow-up-right-from-square"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/videos/edit?id=${v.videoId}" class="btn btn-outline-primary" title="Sửa video">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/videos/delete?id=${v.videoId}" 
                                           class="btn btn-outline-danger" 
                                           onclick="return confirm('Xac nhan xoa video [${v.videoId}]?');"
                                           title="Xóa video">
                                            <i class="fa-solid fa-trash-can"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Phân trang -->
            <div class="card-footer bg-white py-3 border-top d-flex justify-content-between align-items-center flex-wrap gap-2">
                <div class="text-muted small">
                    Đang xem <strong>${videoList.size()}</strong> / tổng số <strong>${totalVideos}</strong> video
                </div>
                <nav aria-label="Page navigation">
                    <ul class="pagination mb-0 pagination-sm">
                        <c:choose>
                            <c:when test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/videos?page=1">&laquo;</a>
                                </li>
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/videos?page=${currentPage - 1}">&lsaquo;</a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="page-item disabled"><span class="page-link">&laquo;</span></li>
                                <li class="page-item disabled"><span class="page-link">&lsaquo;</span></li>
                            </c:otherwise>
                        </c:choose>

                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <li class="page-item ${p == currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/videos?page=${p}">${p}</a>
                            </li>
                        </c:forEach>

                        <c:choose>
                            <c:when test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/videos?page=${currentPage + 1}">&rsaquo;</a>
                                </li>
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/videos?page=${totalPages}">&raquo;</a>
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
