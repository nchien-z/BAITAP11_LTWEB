package vn.iotstar.controller;

import java.io.IOException;
import java.util.List;
import java.sql.SQLException;
import java.util.UUID;
import vn.iotstar.dao.ShoppingDao_24133007;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.Category_24133007;
import vn.iotstar.entity.User_24133007;
import vn.iotstar.entity.Video_24133007;
import vn.iotstar.service.CategoryService_24133007;
import vn.iotstar.service.ICategoryService_24133007;
import vn.iotstar.service.IVideoService_24133007;
import vn.iotstar.service.VideoService_24133007;
import vn.iotstar.util.Constant_24133007;

@WebServlet(urlPatterns = {
    "/admin/videos", 
    "/admin/videos/add", 
    "/admin/videos/edit", 
    "/admin/videos/delete",
    "/video/upload"
})
public class VideoAdminController_24133007 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final IVideoService_24133007 videoService = new VideoService_24133007();
    private final ICategoryService_24133007 categoryService = new CategoryService_24133007();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        // Kiểm tra quyền đăng nhập
        HttpSession session = req.getSession(true);
        User_24133007 currentUser = (User_24133007) session.getAttribute(Constant_24133007.SESSION_USER);
        if (currentUser != null && currentUser.isAdmin()) {
            if (session.getAttribute("videoCsrf") == null) session.setAttribute("videoCsrf", UUID.randomUUID().toString());
            if (!populateCourses(req, resp)) return;
        }

        if (path.equals("/video/upload")) {
            // Cho phép người dùng đăng nhập hoặc Admin đăng video
            if (currentUser == null) {
                resp.sendRedirect(req.getContextPath() + "/login?error=need_login");
                return;
            }
            req.setAttribute("categories", categoryService.findAll());
            req.getRequestDispatcher("/views/admin/video-form.jsp").forward(req, resp);
            return;
        }

        // Các đường dẫn /admin/videos yêu cầu quyền Admin
        if (currentUser == null || !currentUser.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/login?error=unauthorized");
            return;
        }

        if (path.endsWith("/delete")) {
            handleDelete(req, resp);
        } else if (path.endsWith("/edit")) {
            handleShowEdit(req, resp);
        } else if (path.endsWith("/add")) {
            req.setAttribute("categories", categoryService.findAll());
            req.getRequestDispatcher("/views/admin/video-form.jsp").forward(req, resp);
        } else {
            handleList(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        User_24133007 currentUser = (session != null) ? (User_24133007) session.getAttribute(Constant_24133007.SESSION_USER) : null;
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=need_login");
            return;
        }

        String path = req.getServletPath();
        if (path.startsWith("/admin/") && !currentUser.isAdmin()) { resp.sendError(403); return; }
        if (currentUser.isAdmin()) {
            if (session.getAttribute("videoCsrf") == null || !session.getAttribute("videoCsrf").equals(req.getParameter("videoCsrf"))) {
                resp.sendError(403); return;
            }
            if (!populateCourses(req, resp)) return;
        }
        if (path.endsWith("/add") || path.equals("/video/upload")) {
            handleAdd(req, resp, currentUser);
        } else if (path.endsWith("/edit")) {
            if (!currentUser.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/login?error=unauthorized");
                return;
            }
            handleEdit(req, resp);
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int page = 1;
        int pageSize = 6;
        try {
            String p = req.getParameter("page");
            if (p != null) page = Math.max(1, Integer.parseInt(p));
        } catch (NumberFormatException ignored) {}

        int totalVideos = videoService.countAll();
        int totalPages = (int) Math.ceil((double) totalVideos / pageSize);
        if (page > totalPages && totalPages > 0) page = totalPages;

        List<Video_24133007> videoList = videoService.findAll(page, pageSize);

        req.setAttribute("videoList", videoList);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalVideos", totalVideos);
        req.setAttribute("pageSize", pageSize);

        req.getRequestDispatcher("/views/admin/video-list.jsp").forward(req, resp);
    }

    private void handleShowEdit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String videoId = req.getParameter("id");
        Video_24133007 video = videoService.findById(videoId);
        if (video == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/videos?error=notfound");
            return;
        }
        req.setAttribute("video", video);
        req.setAttribute("isEdit", true);
        req.setAttribute("categories", categoryService.findAll());
        req.getRequestDispatcher("/views/admin/video-form.jsp").forward(req, resp);
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp, User_24133007 user) throws ServletException, IOException {
        String videoId = req.getParameter("videoId");
        String title = req.getParameter("title");
        String poster = req.getParameter("poster");
        String videoUrl = req.getParameter("videoUrl");
        String description = req.getParameter("description");
        String catIdStr = req.getParameter("categoryId");
        boolean active = "true".equals(req.getParameter("active"));

        if (videoId == null || videoId.trim().isEmpty() || title == null || title.trim().isEmpty()) {
            req.setAttribute("error", "Mã video và tiêu đề không được để trống!");
            req.setAttribute("categories", categoryService.findAll());
            req.getRequestDispatcher("/views/admin/video-form.jsp").forward(req, resp);
            return;
        }

        videoId = videoId.trim().toUpperCase();
        if (videoService.findById(videoId) != null) {
            req.setAttribute("error", "Mã video '" + videoId + "' đã tồn tại! Vui lòng chọn mã khác.");
            req.setAttribute("categories", categoryService.findAll());
            req.getRequestDispatcher("/views/admin/video-form.jsp").forward(req, resp);
            return;
        }

        int categoryId = 1;
        try {
            if (catIdStr != null) categoryId = Integer.parseInt(catIdStr);
        } catch (NumberFormatException ignored) {}

        if (poster == null || poster.trim().isEmpty()) {
            poster = "https://images.unsplash.com/photo-1587620962725-abab7fe55159?w=600";
        }

        Video_24133007 v = new Video_24133007();
        v.setVideoId(videoId);
        v.setTitle(title.trim());
        v.setPoster(poster.trim());
        v.setVideoUrl(videoUrl != null ? videoUrl.trim() : "");
        v.setDescription(description != null ? description.trim() : "");
        v.setActive(active);
        v.setViews(0);
        v.setCategoryId(categoryId);
        v.setUploadedBy(user.getUsername());
        if (!courseSettings(req, resp, v, user)) return;

        boolean success = videoService.insert(v);
        if (success) {
            if (user.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin/videos?success=added");
            } else {
                resp.sendRedirect(req.getContextPath() + "/video/detail?id=" + videoId);
            }
        } else {
            req.setAttribute("error", "Đã xảy ra lỗi khi lưu video vào CSDL!");
            req.setAttribute("categories", categoryService.findAll());
            req.getRequestDispatcher("/views/admin/video-form.jsp").forward(req, resp);
        }
    }

    private void handleEdit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String videoId = req.getParameter("videoId");
        String title = req.getParameter("title");
        String poster = req.getParameter("poster");
        String videoUrl = req.getParameter("videoUrl");
        String description = req.getParameter("description");
        String catIdStr = req.getParameter("categoryId");
        boolean active = "true".equals(req.getParameter("active"));

        Video_24133007 v = videoService.findById(videoId);
        if (v == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/videos?error=notfound");
            return;
        }

        int categoryId = v.getCategoryId();
        try {
            if (catIdStr != null) categoryId = Integer.parseInt(catIdStr);
        } catch (NumberFormatException ignored) {}

        v.setTitle(title != null ? title.trim() : v.getTitle());
        if (poster != null && !poster.trim().isEmpty()) v.setPoster(poster.trim());
        if (videoUrl != null) v.setVideoUrl(videoUrl.trim());
        v.setDescription(description != null ? description.trim() : "");
        v.setActive(active);
        v.setCategoryId(categoryId);

        if (!courseSettings(req, resp, v, (User_24133007) req.getSession().getAttribute(Constant_24133007.SESSION_USER))) return;

        boolean success = videoService.update(v);
        if (success) {
            resp.sendRedirect(req.getContextPath() + "/admin/videos?success=updated");
        } else {
            req.setAttribute("error", "Cập nhật video thất bại!");
            req.setAttribute("video", v);
            req.setAttribute("isEdit", true);
            req.setAttribute("categories", categoryService.findAll());
            req.getRequestDispatcher("/views/admin/video-form.jsp").forward(req, resp);
        }
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String videoId = req.getParameter("id");
        if (videoId != null && !videoId.trim().isEmpty()) {
            videoService.delete(videoId.trim());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/videos?success=deleted");
    }

    private boolean populateCourses(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try { req.setAttribute("courses", new ShoppingDao_24133007().products()); return true; }
        catch (SQLException e) { getServletContext().log("Course list unavailable", e); resp.sendError(503); return false; }
    }
    private boolean courseSettings(HttpServletRequest req, HttpServletResponse resp, Video_24133007 video, User_24133007 user)
            throws ServletException, IOException {
        if (!user.isAdmin()) { video.setPrivateVideo(false); video.setCourseId(null); return true; }
        try {
            boolean privateVideo = "true".equals(req.getParameter("privateVideo"));
            String raw = req.getParameter("courseId");
            Integer courseId = raw == null || raw.isBlank() ? null : Integer.valueOf(raw);
            if (privateVideo && courseId == null) throw new IllegalArgumentException("Video private phải thuộc một khóa học.");
            if (courseId != null && new ShoppingDao_24133007().find(courseId) == null)
                throw new IllegalArgumentException("Khóa học không tồn tại.");
            video.setPrivateVideo(privateVideo); video.setCourseId(courseId); return true;
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", "Phân quyền khóa học không hợp lệ. Video private phải thuộc khóa học có trong danh sách.");
            req.setAttribute("video", video); req.setAttribute("isEdit", req.getServletPath().endsWith("/edit"));
            req.setAttribute("categories", categoryService.findAll());
            req.getRequestDispatcher("/views/admin/video-form.jsp").forward(req, resp); return false;
        } catch (SQLException e) { getServletContext().log("Course settings failure",e);resp.sendError(503);return false; }
    }
}
