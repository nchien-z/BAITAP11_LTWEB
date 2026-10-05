package vn.iotstar.controller;

import java.io.IOException;
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

@WebServlet(urlPatterns = {"/login", "/dang-nhap"})
public class LoginController_24133007 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final IUserService_24133007 userService = new UserService_24133007();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute(Constant_24133007.SESSION_USER) != null) {
            User_24133007 user = (User_24133007) session.getAttribute(Constant_24133007.SESSION_USER);
            if (user.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin/users");
                return;
            }
        }
        req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!");
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            return;
        }

        User_24133007 user = userService.login(username, password);

        if (user == null) {
            req.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không chính xác!");
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            return;
        }

        if (!user.isActive()) {
            req.setAttribute("error", "Tài khoản chưa được kích hoạt qua mã OTP!");
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            return;
        }

        // Đăng nhập thành công -> Lưu Session
        HttpSession session = req.getSession();
        session.setAttribute(Constant_24133007.SESSION_USER, user);

        String shoppingReturnPath = (String) session.getAttribute("shoppingReturnPath");
        session.removeAttribute("shoppingReturnPath");
        if ("/checkout".equals(shoppingReturnPath) || "/orders".equals(shoppingReturnPath)
                || "/activate".equals(shoppingReturnPath) || "/my-courses".equals(shoppingReturnPath)) {
            req.changeSessionId();
            resp.sendRedirect(req.getContextPath() + shoppingReturnPath);
            return;
        }

        // Theo yêu cầu Câu 2 đề thi:
        // "Đăng nhập với vai trò admin thành công thì vào trang chủ của admin, ngược lại thì quay lại trang đăng nhập."
        if (user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/admin/users");
        } else {
            // Không phải admin -> Quay lại trang đăng nhập kèm thông báo
            req.setAttribute("warningMessage", "Đăng nhập thành công tài khoản Người dùng: " + user.getFullname() + " (" + user.getUsername() + "). Do tài khoản không có quyền Admin, theo yêu cầu đề bài hệ thống chuyển lại trang Đăng nhập.");
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
        }
    }
}
