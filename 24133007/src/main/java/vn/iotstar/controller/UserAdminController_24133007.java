package vn.iotstar.controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.User_24133007;
import vn.iotstar.service.IUserService_24133007;
import vn.iotstar.service.UserService_24133007;
import vn.iotstar.util.Constant_24133007;

@WebServlet(urlPatterns = {"/admin/users", "/admin/users/add", "/admin/users/edit", "/admin/users/delete"})
public class UserAdminController_24133007 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final IUserService_24133007 userService = new UserService_24133007();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Kiểm tra quyền Admin trong Session
        HttpSession session = req.getSession(true);
        User_24133007 currentUser = (User_24133007) session.getAttribute(Constant_24133007.SESSION_USER);
        if (currentUser == null || !currentUser.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/login?error=unauthorized");
            return;
        }

        String path = req.getServletPath();

        if (path.endsWith("/delete")) {
            handleDelete(req, resp);
        } else if (path.endsWith("/edit")) {
            handleShowEdit(req, resp);
        } else if (path.endsWith("/add")) {
            req.getRequestDispatcher("/views/admin/user-form.jsp").forward(req, resp);
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
        if (currentUser == null || !currentUser.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/login?error=unauthorized");
            return;
        }

        String path = req.getServletPath();
        if (path.endsWith("/add")) {
            handleAdd(req, resp);
        } else if (path.endsWith("/edit")) {
            handleUpdate(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/users");
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int page = 1;
        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException ignored) {
            }
        }

        int pageSize = Constant_24133007.PAGE_SIZE_USER; // 6 user/trang theo Câu 3
        int totalUsers = userService.countAll();
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        if (totalPages == 0) totalPages = 1;
        if (page > totalPages) page = totalPages;

        List<User_24133007> userList = userService.findAll(page, pageSize);

        req.setAttribute("userList", userList);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalUsers", totalUsers);
        req.setAttribute("pageSize", pageSize);

        req.getRequestDispatcher("/views/admin/user-list.jsp").forward(req, resp);
    }

    private void handleShowEdit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        User_24133007 user = userService.findByUsername(username);
        if (user != null) {
            req.setAttribute("user", user);
            req.setAttribute("isEdit", true);
            req.getRequestDispatcher("/views/admin/user-form.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=notfound");
        }
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String fullname = req.getParameter("fullname");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        boolean admin = "true".equalsIgnoreCase(req.getParameter("admin")) || "on".equalsIgnoreCase(req.getParameter("admin"));
        boolean active = "true".equalsIgnoreCase(req.getParameter("active")) || "on".equalsIgnoreCase(req.getParameter("active"));
        String images = req.getParameter("images");
        if (images == null || images.trim().isEmpty()) {
            images = "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150";
        }

        if (userService.checkExistUsername(username)) {
            req.setAttribute("error", "Username '" + username + "' đã tồn tại!");
            req.getRequestDispatcher("/views/admin/user-form.jsp").forward(req, resp);
            return;
        }

        User_24133007 newUser = new User_24133007(username, password, phone, fullname, email, admin, active, images);
        boolean success = userService.insert(newUser);
        if (success) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?success=added");
        } else {
            req.setAttribute("error", "Thêm người dùng thất bại!");
            req.getRequestDispatcher("/views/admin/user-form.jsp").forward(req, resp);
        }
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String fullname = req.getParameter("fullname");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        boolean admin = "true".equalsIgnoreCase(req.getParameter("admin")) || "on".equalsIgnoreCase(req.getParameter("admin"));
        boolean active = "true".equalsIgnoreCase(req.getParameter("active")) || "on".equalsIgnoreCase(req.getParameter("active"));
        String images = req.getParameter("images");

        User_24133007 user = new User_24133007(username, password, phone, fullname, email, admin, active, images);
        boolean success = userService.update(user);
        if (success) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?success=updated");
        } else {
            req.setAttribute("error", "Cập nhật thất bại!");
            req.setAttribute("user", user);
            req.setAttribute("isEdit", true);
            req.getRequestDispatcher("/views/admin/user-form.jsp").forward(req, resp);
        }
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username = req.getParameter("username");
        if (username != null && !username.isEmpty()) {
            userService.delete(username);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users?success=deleted");
    }
}
