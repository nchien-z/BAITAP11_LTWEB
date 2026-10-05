<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${video.title} - VideoHub</title>
    <style>
        .video-player-container {
            background-color: #0b0f19;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            position: relative;
        }
        .video-player-poster {
            width: 100%;
            max-height: 480px;
            object-fit: cover;
            display: block;
        }
        .play-btn-large {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 80px;
            height: 80px;
            background: rgba(37, 99, 235, 0.9);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2rem;
            box-shadow: 0 0 30px rgba(37, 99, 235, 0.6);
            cursor: pointer;
            transition: transform 0.3s, background-color 0.3s;
        }
        .play-btn-large:hover {
            transform: translate(-50%, -50%) scale(1.1);
            background: #2563eb;
        }
        .video-info-box {
            background: #ffffff;
            border-radius: 16px;
            padding: 2rem;
            border: 1px solid rgba(0, 0, 0, 0.06);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.03);
        }
        .btn-action-round {
            border-radius: 50px;
            padding: 0.5rem 1.25rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s;
        }
    </style>
</head>
<body>
    <div class="container py-3">
        <!-- Video Player Section -->
        <div class="video-player-container mb-4">
            <c:choose><c:when test="${canWatch}">
            <c:choose>
                <c:when test="${not empty video.videoUrl}">
                    <%-- Embed YouTube or MP4 --%>
                    <div class="ratio ratio-16x9">
                        <c:choose>
                            <c:when test="${video.videoUrl.contains('youtube.com') || video.videoUrl.contains('youtu.be')}">
                                <%-- Extract YouTube ID and embed --%>
                                <iframe
                                    src="${fn:replace(fn:replace(video.videoUrl, 'watch?v=', 'embed/'), 'youtu.be/', 'www.youtube.com/embed/')}"
                                    allowfullscreen
                                    allow="autoplay; encrypted-media; picture-in-picture"
                                    frameborder="0"
                                    style="border-radius:16px;">
                                </iframe>
                            </c:when>
                            <c:otherwise>
                                <%-- Direct MP4/WebM video --%>
                                <video controls autoplay style="border-radius:16px; background:#000;">
                                    <source src="${video.videoUrl}" type="video/mp4">
                                    Trinh duyet cua ban khong ho tro the video.
                                </video>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>
                <c:otherwise>
                    <%-- Fallback: show poster image with play icon overlay --%>
                    <img src="${video.poster}" alt="${video.title}" class="video-player-poster"
                         onerror="this.src='https://images.unsplash.com/photo-1587620962725-abab7fe55159?w=1200'">
                    <div class="play-btn-large">
                        <i class="fa-solid fa-play"></i>
                    </div>
                </c:otherwise>
            </c:choose>
            </c:when><c:otherwise>
                <div class="p-5 text-center text-white">
                    <i class="fa-solid fa-lock fs-1 mb-3"></i><h2 class="h4">Video private của khóa học</h2>
                    <p>Bạn cần đăng nhập và nhập mã kích hoạt được giao theo đơn COD để xem bài học này.</p>
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/activate">Nhập mã kích hoạt</a>
                    <a class="btn btn-outline-light" href="${pageContext.request.contextPath}/products">Mua khóa học</a>
                </div>
            </c:otherwise></c:choose>
            <div class="position-absolute bottom-0 start-0 w-100 p-3" style="background: linear-gradient(to top, rgba(0,0,0,0.7), transparent); pointer-events:none;">
                <span class="badge bg-primary px-3 py-2 fs-6">${video.categoryName}</span>
                <span class="badge bg-dark bg-opacity-75 text-white ms-2 px-3 py-2"><i class="fa-solid fa-barcode me-1"></i> Ma: ${video.videoId}</span>
            </div>
        </div>


        <!-- Video Detail Information -->
        <div class="video-info-box mb-4">
            <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 pb-3 border-bottom mb-3">
                <div class="flex-grow-1">
                    <h2 class="fw-bold text-dark mb-2">${video.title}</h2>
                    <span class="badge ${video.privateVideo ? 'bg-warning text-dark' : 'bg-success'} mb-2">${video.privateVideo ? 'Private • Cần kích hoạt khóa học' : 'Public • Xem miễn phí'}</span>
                    <div class="d-flex flex-wrap align-items-center gap-3 text-secondary small">
                        <span><i class="fa-solid fa-eye text-primary me-1"></i><strong>${video.views}</strong> lượt xem</span>
                        <span>•</span>
                        <span><i class="fa-solid fa-folder text-warning me-1"></i>Danh mục: <strong>${video.categoryName}</strong></span>
                        <span>•</span>
                        <span><i class="fa-solid fa-calendar text-muted me-1"></i>Năm 2026</span>
                    </div>
                </div>

                <!-- Interaction Buttons: Like, Share -->
                <div class="d-flex gap-2">
                    <button class="btn btn-outline-danger btn-action-round">
                        <i class="fa-solid fa-heart"></i>
                        <span>Thích (${video.likeCount})</span>
                    </button>
                    <button class="btn btn-outline-primary btn-action-round">
                        <i class="fa-solid fa-share-nodes"></i>
                        <span>Chia sẻ (${video.shareCount})</span>
                    </button>
                    <button class="btn btn-light btn-action-round border">
                        <i class="fa-regular fa-bookmark"></i>
                        <span>Lưu</span>
                    </button>
                </div>
            </div>

            <!-- Description -->
            <div>
                <h6 class="fw-bold text-dark text-uppercase small mb-2 text-muted">Mô tả nội dung:</h6>
                <p class="text-secondary mb-0" style="line-height: 1.8; font-size: 1.05rem;">
                    ${video.description}
                </p>
            </div>
        </div>

        <!-- Back to list & Navigation -->
        <div class="d-flex justify-content-between align-items-center">
            <a href="${pageContext.request.contextPath}/video/category" class="btn btn-outline-secondary rounded-pill px-4">
                <i class="fa-solid fa-arrow-left me-2"></i> Quay lại danh sách Video
            </a>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary rounded-pill px-4">
                <i class="fa-solid fa-house me-2"></i> Trang chủ
            </a>
        </div>
    </div>
</body>
</html>
