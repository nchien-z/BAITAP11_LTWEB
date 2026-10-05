package vn.iotstar.controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.entity.Category_24133007;
import vn.iotstar.entity.Video_24133007;
import vn.iotstar.service.CategoryService_24133007;
import vn.iotstar.service.ICategoryService_24133007;
import vn.iotstar.service.IVideoService_24133007;
import vn.iotstar.service.VideoService_24133007;

@WebServlet(urlPatterns = {"/home", "/trang-chu"})
public class HomeController_24133007 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ICategoryService_24133007 categoryService = new CategoryService_24133007();
    private final IVideoService_24133007 videoService = new VideoService_24133007();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Category_24133007> categories = categoryService.findAllWithVideoCount();
        List<Video_24133007> topVideos = videoService.findAll();

        req.setAttribute("categories", categories);
        req.setAttribute("videos", topVideos);
        req.getRequestDispatcher("/views/home.jsp").forward(req, resp);
    }
}
