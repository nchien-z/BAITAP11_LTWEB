<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Trang Chủ - VideoHub Nền Tảng Video Đỉnh Cao</title>
    <style>
        .hero-banner {
            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
            border-radius: 20px;
            color: white;
            padding: 3.5rem 3rem;
            position: relative;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.15);
        }
        .hero-banner::after {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(56, 189, 248, 0.15) 0%, transparent 70%);
            border-radius: 50%;
            pointer-events: none;
        }
        .category-card {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border-radius: 14px;
            overflow: hidden;
            background: #ffffff;
            border: 1px solid rgba(0,0,0,0.05);
        }
        .category-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.08);
            border-color: #38bdf8;
        }
        .video-card-modern {
            transition: all 0.3s ease;
            border-radius: 14px;
            overflow: hidden;
            background: #ffffff;
            border: 1px solid rgba(0,0,0,0.05);
        }
        .video-card-modern:hover {
            transform: translateY(-5px);
            box-shadow: 0 14px 28px rgba(0,0,0,0.09);
        }
        .video-thumb-container {
            position: relative;
            height: 200px;
            overflow: hidden;
        }
        .video-thumb-container img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.4s ease;
        }
        .video-card-modern:hover .video-thumb-container img {
            transform: scale(1.05);
        }
        .play-overlay {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) scale(0.8);
            width: 50px;
            height: 50px;
            background: rgba(37, 99, 235, 0.85);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.25rem;
            opacity: 0;
            transition: all 0.3s ease;
        }
        .video-card-modern:hover .play-overlay {
            opacity: 1;
            transform: translate(-50%, -50%) scale(1);
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Hero Section -->
        <div class="hero-banner mb-5">
            <div class="row align-items-center position-relative" style="z-index: 1;">
                <div class="col-lg-8">
                    <span class="badge bg-primary px-3 py-2 fw-semibold mb-3 rounded-pill">
                        <i class="fa-solid fa-sparkles me-1"></i> Nền Tảng Video & Giải Trí Trực Tuyến
                    </span>
                    <h1 class="display-5 fw-extrabold text-white mb-3" style="letter-spacing: -1px;">
                        Khám Phá Thế Giới Video Đỉnh Cao Cùng <span class="text-info">VideoHub</span>
                    </h1>
                    <p class="lead text-light opacity-75 mb-4" style="font-size: 1.15rem; max-width: 600px;">
                        Trải nghiệm hàng ngàn video hấp dẫn về Công nghệ, Âm nhạc và Phim ngắn với chất lượng hình ảnh sắc nét cùng tốc độ truyền tải mượt mà.
                    </p>
                    <div class="d-flex flex-wrap gap-3">
                        <a href="${pageContext.request.contextPath}/video/category" class="btn btn-primary btn-lg px-4 fw-semibold rounded-3 shadow">
                            <i class="fa-solid fa-play me-2"></i> Khám Phá Ngay
                        </a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-light btn-lg px-4 fw-semibold rounded-3">
                            <i class="fa-solid fa-user-plus me-2"></i> Tham Gia Ngay
                        </a>
                    </div>
                </div>
                <div class="col-lg-4 d-none d-lg-block text-center">
                    <div class="p-3 bg-white bg-opacity-10 rounded-4 border border-white border-opacity-10 backdrop-blur">
                        <i class="fa-solid fa-film text-info" style="font-size: 5rem;"></i>
                        <h5 class="text-white mt-3 fw-bold">Nội Dung Đa Dạng</h5>
                        <p class="text-white-50 small mb-0">Cập nhật liên tục những video mới và thịnh hành nhất</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Danh mục Nổi Bật -->
        <div class="mb-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold text-dark mb-1">
                        <i class="fa-solid fa-layer-group text-primary me-2"></i>Danh Mục Nổi Bật
                    </h3>
                    <p class="text-secondary small mb-0">Lựa chọn những chủ đề bạn yêu thích nhất</p>
                </div>
                <a href="${pageContext.request.contextPath}/video/category" class="btn btn-sm btn-outline-primary fw-semibold rounded-pill px-3">
                    Xem tất cả <i class="fa-solid fa-arrow-right ms-1"></i>
                </a>
            </div>

            <div class="row g-3">
                <c:forEach items="${categories}" var="cat">
                    <div class="col-lg-4 col-md-4 col-sm-6">
                        <a href="${pageContext.request.contextPath}/video/category?categoryId=${cat.categoryId}" class="text-decoration-none">
                            <div class="card category-card h-100 shadow-sm">
                                <img src="${cat.images}" class="card-img-top" alt="${cat.categoryname}" style="height: 150px; object-fit: cover;">
                                <div class="card-body p-3 text-center">
                                    <h6 class="card-title fw-bold text-dark mb-1">${cat.categoryname}</h6>
                                    <span class="badge bg-primary-subtle text-primary fw-semibold">
                                        ${cat.videoCount} Video
                                    </span>
                                </div>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Video Nổi Bật / Mới Nhất -->
        <div class="mb-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold text-dark mb-1">
                        <i class="fa-solid fa-fire text-danger me-2"></i>Video Được Xem Nhiều Nhất
                    </h3>
                    <p class="text-secondary small mb-0">Các video đang thu hút sự quan tâm của cộng đồng</p>
                </div>
                <a href="${pageContext.request.contextPath}/video/category" class="btn btn-sm btn-outline-primary fw-semibold rounded-pill px-3">
                    Xem thêm video <i class="fa-solid fa-arrow-right ms-1"></i>
                </a>
            </div>

            <div class="row g-4">
                <c:forEach items="${videos}" var="v" begin="0" end="5">
                    <div class="col-lg-4 col-md-6">
                        <div class="card video-card-modern h-100 shadow-sm">
                            <div class="video-thumb-container">
                                <img src="${v.poster}" alt="${v.title}" onerror="this.src='https://images.unsplash.com/photo-1587620962725-abab7fe55159?w=600'">
                                <div class="play-overlay">
                                    <i class="fa-solid fa-play"></i>
                                </div>
                                <span class="position-absolute bottom-0 end-0 bg-dark bg-opacity-75 text-white small px-2 py-1 m-2 rounded">
                                    <i class="fa-solid fa-eye me-1"></i>${v.views}
                                </span>
                            </div>
                            <div class="card-body p-3 d-flex flex-column justify-content-between">
                                <div>
                                    <span class="badge bg-secondary-subtle text-secondary mb-2">${v.categoryName}</span>
                                    <span class="badge ${v.privateVideo ? 'bg-warning text-dark' : 'bg-success'} mb-2">${v.privateVideo ? 'Private' : 'Public'}</span>
                                    <h6 class="card-title fw-bold text-dark mb-2" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; min-height: 42px;">
                                        ${v.title}
                                    </h6>
                                    <p class="card-text text-muted small mb-3 text-truncate">${v.description}</p>
                                </div>
                                <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                                    <div class="d-flex gap-3 text-muted small">
                                        <span><i class="fa-solid fa-heart text-danger me-1"></i>${v.likeCount}</span>
                                        <span><i class="fa-solid fa-share-nodes text-primary me-1"></i>${v.shareCount}</span>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" class="btn btn-sm btn-primary rounded-pill px-3">
                                        Xem Ngay
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</body>
</html>
