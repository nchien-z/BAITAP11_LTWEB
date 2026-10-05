<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Khám Phá Video - VideoHub</title>
    <style>
        .category-header-title {
            font-size: 1.85rem;
            font-weight: 800;
            color: #0f172a;
            letter-spacing: -0.5px;
        }
        .video-card-table {
            border-radius: 14px;
            overflow: hidden;
            background: #ffffff;
            border: 1px solid rgba(0, 0, 0, 0.06);
            transition: all 0.3s ease;
        }
        .video-card-table:hover {
            transform: translateY(-5px);
            box-shadow: 0 14px 28px rgba(0, 0, 0, 0.08);
            border-color: rgba(37, 99, 235, 0.3);
        }
        .video-poster-box {
            position: relative;
            height: 200px;
            background-color: #0b0f19;
            overflow: hidden;
        }
        .video-poster-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.4s ease;
        }
        .video-card-table:hover .video-poster-box img {
            transform: scale(1.05);
        }
        .stat-badge {
            background: #f1f5f9;
            color: #475569;
            padding: 0.35rem 0.65rem;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        .stat-badge-like {
            background: #ffe4e6;
            color: #e11d48;
            padding: 0.35rem 0.65rem;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        .stat-badge-share {
            background: #e0f2fe;
            color: #0284c7;
            padding: 0.35rem 0.65rem;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        .page-link {
            border-radius: 8px !important;
            margin: 0 3px;
            font-weight: 600;
            color: #334155;
            border: 1px solid #e2e8f0;
        }
        .page-item.active .page-link {
            background-color: #2563eb;
            border-color: #2563eb;
            color: #ffffff;
        }
    </style>
</head>
<body>
    <div class="container py-2">
        <!-- Thanh chọn danh mục Category Tabs -->
        <div class="mb-4">
            <div class="d-flex align-items-center justify-content-between mb-2">
                <span class="fw-bold text-secondary small text-uppercase"><i class="fa-solid fa-filter me-1"></i> Lọc theo danh mục:</span>
                <span class="text-muted small">${totalVideos} video trong danh mục</span>
            </div>
            <div class="nav nav-pills gap-2 flex-wrap">
                <c:forEach items="${categories}" var="cat">
                    <a class="nav-link ${cat.categoryId == categoryId ? 'active fw-bold' : 'bg-white border text-dark'}" 
                       href="${pageContext.request.contextPath}/video/category?categoryId=${cat.categoryId}&page=1"
                       style="border-radius: 10px;">
                        <i class="fa-solid fa-folder me-1"></i> ${cat.categoryname}
                        <span class="badge ${cat.categoryId == categoryId ? 'bg-light text-primary' : 'bg-secondary-subtle text-secondary'} ms-1">
                            ${cat.videoCount}
                        </span>
                    </a>
                </c:forEach>
            </div>
        </div>

        <!-- Tiêu đề Category Header -->
        <div class="mb-4 pb-2 border-bottom d-flex justify-content-between align-items-center flex-wrap gap-2">
            <div class="category-header-title">
                <i class="fa-solid fa-clapperboard text-primary me-2"></i>
                <c:out value="${currentCategory != null ? currentCategory.categoryname : 'Tất Cả Video'}"/>
                <span class="badge bg-primary-subtle text-primary fs-6 ms-2">${totalVideos} video</span>
            </div>
            <div class="text-secondary small">
                Hiển thị 3 video mỗi trang
            </div>
        </div>

        <!-- Lưới video 3 cột -->
        <div class="row g-4 mb-4">
            <c:choose>
                <c:when test="${not empty videos}">
                    <c:forEach items="${videos}" var="v">
                        <div class="col-lg-4 col-md-6">
                            <div class="video-card-table shadow-sm h-100 d-flex flex-column">
                                <!-- Poster -->
                                <div class="video-poster-box">
                                    <img src="${v.poster}" alt="${v.title}" onerror="this.src='https://images.unsplash.com/photo-1587620962725-abab7fe55159?w=600'">
                                    <span class="position-absolute top-0 end-0 bg-dark bg-opacity-75 text-white small px-2 py-1 m-2 rounded">
                                        <i class="fa-solid fa-eye me-1"></i>${v.views} lượt xem
                                    </span>
                                    <span class="position-absolute bottom-0 start-0 bg-primary text-white small px-2 py-1 m-2 rounded fw-semibold">
                                        ${v.categoryName}
                                    </span>
                                </div>

                                <!-- Body -->
                                <div class="p-3 d-flex flex-column flex-grow-1 justify-content-between">
                                    <div>
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <span class="badge bg-light text-muted border">ID: ${v.videoId}</span>
                                            <span class="badge ${v.privateVideo ? 'bg-warning text-dark' : 'bg-success'}">${v.privateVideo ? 'Private' : 'Public'}</span>
                                        </div>
                                        <h5 class="fw-bold text-dark mb-2" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; min-height: 48px;">
                                            ${v.title}
                                        </h5>
                                        <p class="text-muted small mb-3 text-truncate">
                                            ${v.description}
                                        </p>
                                    </div>

                                    <!-- Footer card -->
                                    <div>
                                        <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                                            <div class="d-flex gap-2">
                                                <span class="stat-badge-like">
                                                    <i class="fa-solid fa-heart me-1"></i>${v.likeCount}
                                                </span>
                                                <span class="stat-badge-share">
                                                    <i class="fa-solid fa-share-nodes me-1"></i>${v.shareCount}
                                                </span>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" 
                                               class="btn btn-sm btn-primary rounded-pill px-3">
                                                <i class="fa-solid fa-play me-1"></i> Xem Chi Tiết
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12 text-center py-5">
                        <div class="p-5 bg-white rounded-4 shadow-sm border">
                            <i class="fa-regular fa-folder-open text-muted fa-3x mb-3"></i>
                            <h5 class="text-secondary fw-semibold">Chưa có video nào trong danh mục này</h5>
                            <p class="text-muted small">Vui lòng chọn danh mục khác để xem thêm nội dung.</p>
                            <a href="${pageContext.request.contextPath}/video/category" class="btn btn-outline-primary btn-sm">
                                Về tất cả danh mục
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Thanh phân trang Pagination -->
        <c:if test="${totalPages > 0}">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 pt-3 border-top">
                <div class="text-muted small">
                    Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong>
                </div>

                <nav aria-label="Page navigation">
                    <ul class="pagination mb-0">
                        <!-- Nút First / Prev << -->
                        <c:choose>
                            <c:when test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/video/category?categoryId=${categoryId}&page=1" title="Trang đầu">&laquo;</a>
                                </li>
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/video/category?categoryId=${categoryId}&page=${currentPage - 1}" title="Trang trước">&lsaquo;</a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="page-item disabled"><span class="page-link">&laquo;</span></li>
                                <li class="page-item disabled"><span class="page-link">&lsaquo;</span></li>
                            </c:otherwise>
                        </c:choose>

                        <!-- Các trang số: 1 2 3 ... -->
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <li class="page-item ${p == currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/video/category?categoryId=${categoryId}&page=${p}">
                                    ${p}
                                </a>
                            </li>
                        </c:forEach>

                        <!-- Nút Next / Last >> -->
                        <c:choose>
                            <c:when test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/video/category?categoryId=${categoryId}&page=${currentPage + 1}" title="Trang sau">&rsaquo;</a>
                                </li>
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/video/category?categoryId=${categoryId}&page=${totalPages}" title="Trang cuối">&raquo;</a>
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
        </c:if>
    </div>
</body>
</html>
