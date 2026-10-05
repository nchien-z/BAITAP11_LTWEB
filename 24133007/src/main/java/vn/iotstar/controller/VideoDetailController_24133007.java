package vn.iotstar.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.entity.Video_24133007;
import vn.iotstar.service.IVideoService_24133007;
import vn.iotstar.service.VideoService_24133007;
import vn.iotstar.service.CourseService_24133007;
import vn.iotstar.entity.User_24133007;
import vn.iotstar.util.Constant_24133007;
import java.sql.SQLException;

@WebServlet(urlPatterns = {"/video/detail", "/chi-tiet-video"})
public class VideoDetailController_24133007 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final IVideoService_24133007 videoService = new VideoService_24133007();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String videoId = req.getParameter("id");
        if (videoId == null || videoId.trim().isEmpty()) {
            videoId = "VID001"; // Mặc định mở video VID001 như dữ liệu mẫu đề bài
        }

        resp.setHeader("Cache-Control", "no-store");
        Video_24133007 video = videoService.findById(videoId);
        if (video == null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        User_24133007 user = req.getSession(false) == null ? null :
                (User_24133007) req.getSession(false).getAttribute(Constant_24133007.SESSION_USER);
        if (!video.isActive() && (user == null || !user.isAdmin())) { resp.sendError(404); return; }
        try {
            boolean canWatch = new CourseService_24133007().canWatch(video, user);
            req.setAttribute("canWatch", canWatch);
            if (canWatch) videoService.incrementView(videoId);
            else video.setVideoUrl(null); // Không gửi URL private vào HTML của người chưa kích hoạt.
        } catch (SQLException e) {
            getServletContext().log("Video access database failure", e);
            resp.sendError(503); return;
        }
        req.setAttribute("video", video);
        req.getRequestDispatcher("/views/video-detail.jsp").forward(req, resp);
    }
}
