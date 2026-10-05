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
import vn.iotstar.util.EmailUtil_24133007;

@WebServlet(urlPatterns = {"/register", "/dang-ky"})
public class RegisterController_24133007 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final IUserService_24133007 userService = new UserService_24133007();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String phone = req.getParameter("phone");
        String fullname = req.getParameter("fullname");
        String email = req.getParameter("email");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        if (userService.checkExistUsername(username)) {
            req.setAttribute("error", "Tên đăng nhập đã tồn tại trong hệ thống!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        if (email != null && userService.checkExistEmail(email)) {
            req.setAttribute("error", "Email đã được sử dụng!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        // Tạo đối tượng User tạm thời (chưa active)
        User_24133007 tempUser = new User_24133007();
        tempUser.setUsername(username);
        tempUser.setPassword(password);
        tempUser.setPhone(phone);
        tempUser.setFullname(fullname);
        tempUser.setEmail(email);
        tempUser.setAdmin(false);
        tempUser.setActive(false);
        tempUser.setImages("https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150");

        // Sinh mã OTP 6 số ngẫu nhiên
        String otp = EmailUtil_24133007.generateOtp(6);
        EmailUtil_24133007.sendOtpEmail(email != null && !email.isEmpty() ? email : "user@example.com", otp);

        // Lưu vào Session để xác minh ở bước tiếp theo
        HttpSession session = req.getSession();
        session.setAttribute(Constant_24133007.SESSION_OTP, otp);
        session.setAttribute(Constant_24133007.SESSION_REGISTER_USER, tempUser);

        req.setAttribute("message", "Mã OTP đã được gửi đến email " + email + ". Vui lòng nhập mã để kích hoạt!");
        req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
    }
}
