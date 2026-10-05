<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${isEdit ? 'Chinh Sua Video' : 'Dang Video Moi'} - VideoHub</title>
</head>
<body>
    <div class="container py-3">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                    <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
                        <h5 class="fw-bold text-dark mb-0">
                            <i class="fa-solid fa-cloud-arrow-up text-primary me-2"></i>
                            ${isEdit ? 'Chinh Sua Thong Tin Video' : 'Dang Video Moi Len He Thong'}
                        </h5>
                        <a href="${pageContext.request.contextPath}/admin/videos" class="btn btn-sm btn-outline-secondary">
                            <i class="fa-solid fa-arrow-left me-1"></i> Quay lai danh sach
                        </a>
                    </div>

                    <div class="card-body p-4">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger mb-3" role="alert">
                                <i class="fa-solid fa-triangle-exclamation me-2"></i> ${error}
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/admin/videos/${isEdit ? 'edit' : 'add'}" method="post">
                            <div class="row g-3">

                                <!-- Ma Video -->
                                <div class="col-md-6">
                                    <label for="videoId" class="form-label fw-semibold">Ma Video (Video ID): <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="videoId" name="videoId"
                                           value="${video.videoId}" ${isEdit ? 'readonly' : 'required'}
                                           placeholder="Vi du: VID007, TECH2026...">
                                    <c:if test="${isEdit}">
                                        <div class="form-text text-muted">Khong the thay doi Ma Video khi sua.</div>
                                    </c:if>
                                </div>

                                <!-- Danh muc -->
                                <div class="col-md-6">
                                    <label for="categoryId" class="form-label fw-semibold">Danh Muc Video: <span class="text-danger">*</span></label>
                                    <select class="form-select" id="categoryId" name="categoryId" required>
                                        <c:forEach items="${categories}" var="cat">
                                            <option value="${cat.categoryId}" ${video != null && video.categoryId == cat.categoryId ? 'selected' : ''}>
                                                ${cat.categoryname}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <!-- Tieu de -->
                                <div class="col-12">
                                    <label for="title" class="form-label fw-semibold">Tieu De Video: <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="title" name="title"
                                           value="${video.title}" required placeholder="Nhap tieu de video day du, hap dan">
                                </div>

                                <!-- URL Video - TRUONG MOI -->
                                <div class="col-12">
                                    <label for="videoUrl" class="form-label fw-semibold">
                                        <i class="fa-brands fa-youtube text-danger me-1"></i>
                                        URL Video: <span class="text-danger">*</span>
                                    </label>
                                    <input type="url" class="form-control" id="videoUrl" name="videoUrl"
                                           value="${video.videoUrl}"
                                           placeholder="https://www.youtube.com/watch?v=... hoac https://example.com/video.mp4"
                                           oninput="previewVideo(this.value)">
                                    <div class="form-text text-muted">
                                        Ho tro: YouTube (<code>youtube.com/watch?v=...</code> hoac <code>youtu.be/...</code>), hoac link MP4 truc tiep.
                                    </div>
                                    <!-- Preview embed video -->
                                    <div id="videoPreviewBox" class="mt-2" style="display:none;">
                                        <div class="ratio ratio-16x9 rounded-3 overflow-hidden border shadow-sm">
                                            <iframe id="videoPreviewFrame" src="" allowfullscreen
                                                    allow="autoplay; encrypted-media" frameborder="0"></iframe>
                                        </div>
                                        <div class="form-text text-success mt-1">
                                            <i class="fa-solid fa-circle-check me-1"></i>Xem truoc video thanh cong!
                                        </div>
                                    </div>
                                </div>

                                <!-- Poster / Thumbnail -->
                                <div class="col-12">
                                    <label for="poster" class="form-label fw-semibold">Duong dan anh Thumbnail (Poster URL):</label>
                                    <input type="url" class="form-control" id="poster" name="poster"
                                           value="${video.poster}" placeholder="https://images.unsplash.com/photo-...">
                                    <div class="form-text text-muted">De trong he thong se tu dong gan anh mac dinh chat luong cao.</div>
                                </div>

                                <!-- Mo ta -->
                                <div class="col-12">
                                    <label for="description" class="form-label fw-semibold">Mo Ta Noi Dung Video:</label>
                                    <textarea class="form-control" id="description" name="description" rows="4"
                                              placeholder="Nhap tom tat hoac noi dung chi tiet ve video...">${video.description}</textarea>
                                </div>

                                <!-- Trang thai -->
                                <div class="col-12">
                                    <input type="hidden" name="videoCsrf" value="${sessionScope.videoCsrf}">
                                    <c:if test="${sessionScope.account.admin}">
                                        <label for="courseId" class="form-label">Khóa học</label>
                                        <select id="courseId" name="courseId" class="form-select mb-3"><option value="">Không thuộc khóa học</option>
                                            <c:forEach var="course" items="${courses}"><option value="${course.id}" ${video.courseId == course.id ? 'selected' : ''}><c:out value="${course.name}"/></option></c:forEach>
                                        </select>
                                        <label for="privateVideo" class="form-label">Quyền xem video</label>
                                        <select id="privateVideo" name="privateVideo" class="form-select mb-3">
                                            <option value="false" ${!video.privateVideo ? 'selected' : ''}>Public — Xem miễn phí</option>
                                            <option value="true" ${video.privateVideo ? 'selected' : ''}>Private — Cần mã kích hoạt khóa học</option>
                                        </select>
                                    </c:if>
                                    <label class="form-label fw-semibold d-block">Trang thai hien thi:</label>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="active" id="activeYes" value="true"
                                               ${video == null || video.active ? 'checked' : ''}>
                                        <label class="form-check-label text-success fw-semibold" for="activeYes">Hiển thị (quyền xem theo Public / Private ở trên)</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="active" id="activeNo" value="false"
                                               ${video != null && !video.active ? 'checked' : ''}>
                                        <label class="form-check-label text-secondary" for="activeNo">Tam an (Chi luu nhap)</label>
                                    </div>
                                </div>
                            </div>

                            <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                                <a href="${pageContext.request.contextPath}/admin/videos" class="btn btn-light border px-4">
                                    Huy bo
                                </a>
                                <button type="submit" class="btn btn-primary px-4 fw-semibold shadow-sm">
                                    <i class="fa-solid fa-cloud-arrow-up me-1"></i>
                                    ${isEdit ? 'Cap Nhat Video' : 'Dang Video Ngay'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
    function previewVideo(url) {
        var frame = document.getElementById('videoPreviewFrame');
        var box   = document.getElementById('videoPreviewBox');
        if (!url || url.trim() === '') {
            box.style.display = 'none';
            frame.src = '';
            return;
        }
        var embedUrl = toEmbedUrl(url.trim());
        if (embedUrl) {
            frame.src = embedUrl;
            box.style.display = 'block';
        } else {
            box.style.display = 'none';
            frame.src = '';
        }
    }

    function toEmbedUrl(url) {
        // YouTube: youtube.com/watch?v=ID or youtu.be/ID
        var yt = url.match(/(?:youtube\.com\/watch\?v=|youtu\.be\/)([a-zA-Z0-9_-]{11})/);
        if (yt) return 'https://www.youtube.com/embed/' + yt[1] + '?autoplay=0';

        // YouTube Shorts
        var yts = url.match(/youtube\.com\/shorts\/([a-zA-Z0-9_-]{11})/);
        if (yts) return 'https://www.youtube.com/embed/' + yts[1];

        // Direct MP4 / WebM / OGG
        if (/\.(mp4|webm|ogg)(\?.*)?$/i.test(url)) return url;

        return null;
    }

    // Auto-preview khi load trang (che do sua video)
    window.addEventListener('DOMContentLoaded', function () {
        var input = document.getElementById('videoUrl');
        if (input && input.value) previewVideo(input.value);
    });
    </script>
</body>
</html>
