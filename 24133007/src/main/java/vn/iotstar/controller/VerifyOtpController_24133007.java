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

@WebServlet(urlPatterns = {"/verify-otp", "/kich-hoat-otp"})
public class VerifyOtpController_24133007 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final IUserService_24133007 userService = new UserService_24133007();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String inputOtp = req.getParameter("otp");
        HttpSession session = req.getSession();
        String sessionOtp = (String) session.getAttribute(Constant_24133007.SESSION_OTP);
        User_24133007 tempUser = (User_24133007) session.getAttribute(Constant_24133007.SESSION_REGISTER_USER);

        if (sessionOtp == null || tempUser == null) {
            req.setAttribute("error", "Phiên xác thực đã hết hạn hoặc không hợp lệ. Vui lòng đăng ký lại!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        if (inputOtp != null && inputOtp.trim().equals(sessionOtp.trim())) {
            // OTP chính xác -> lưu vào CSDL và kích hoạt
            tempUser.setActive(true);
            boolean created = userService.register(tempUser);
            if (created) {
                userService.activateUser(tempUser.getUsername());
                // Xóa OTP khỏi session
                session.removeAttribute(Constant_24133007.SESSION_OTP);
                session.removeAttribute(Constant_24133007.SESSION_REGISTER_USER);

                req.setAttribute("successMessage", "Kích hoạt tài khoản thành công! Vui lòng đăng nhập.");
                req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
                return;
            } else {
                req.setAttribute("error", "Đã xảy ra lỗi khi tạo tài khoản vào CSDL!");
                req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
                return;
            }
        } else {
            req.setAttribute("error", "Mã OTP không chính xác. Vui lòng kiểm tra lại!");
            req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
        }
    }
}
