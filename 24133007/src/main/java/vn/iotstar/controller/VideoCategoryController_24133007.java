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
import vn.iotstar.util.Constant_24133007;

@WebServlet(urlPatterns = {"/video/category", "/san-pham", "/danh-muc-video"})
public class VideoCategoryController_24133007 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ICategoryService_24133007 categoryService = new CategoryService_24133007();
    private final IVideoService_24133007 videoService = new VideoService_24133007();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Category_24133007> categories = categoryService.findAllWithVideoCount();

        int categoryId = 1; // Mặc định Category 1 (Công Nghệ & Lập Trình)
        String catParam = req.getParameter("categoryId");
        if (catParam != null && !catParam.isEmpty()) {
            try {
                categoryId = Integer.parseInt(catParam);
            } catch (NumberFormatException ignored) {
            }
        } else if (!categories.isEmpty()) {
            categoryId = categories.get(0).getCategoryId();
        }

        int page = 1;
        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException ignored) {
            }
        }

        int pageSize = Constant_24133007.PAGE_SIZE_VIDEO; // Phân trang 3 video / trang theo Câu 5

        // Câu 6: Đếm số lượng Video theo từng Category hiển thị ở câu 5
        int totalVideos = videoService.countByCategoryId(categoryId);
        int totalPages = (int) Math.ceil((double) totalVideos / pageSize);
        if (totalPages == 0) totalPages = 1;
        if (page > totalPages) page = totalPages;

        List<Video_24133007> videos = videoService.findByCategoryId(categoryId, page, pageSize);
        Category_24133007 currentCategory = categoryService.findById(categoryId);

        req.setAttribute("categories", categories);
        req.setAttribute("currentCategory", currentCategory);
        req.setAttribute("categoryId", categoryId);
        req.setAttribute("videos", videos);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalVideos", totalVideos); // Số lượng video phục vụ Câu 6: "Category Name (X)"
        req.setAttribute("pageSize", pageSize);

        req.getRequestDispatcher("/views/video-category.jsp").forward(req, resp);
    }
}
