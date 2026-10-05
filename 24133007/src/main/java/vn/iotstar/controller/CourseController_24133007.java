package vn.iotstar.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.dao.CourseDao_24133007;
import vn.iotstar.entity.User_24133007;
import vn.iotstar.service.CourseService_24133007;
import vn.iotstar.util.Constant_24133007;

@WebServlet(urlPatterns={"/activate","/my-courses","/admin/course-codes"})
public class CourseController_24133007 extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final CourseDao_24133007 dao = new CourseDao_24133007();
    private final CourseService_24133007 service = new CourseService_24133007();
    private User_24133007 authorized(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        User_24133007 user = (User_24133007) session.getAttribute(Constant_24133007.SESSION_USER);
        if (user == null) {
            if (!req.getServletPath().startsWith("/admin/")) session.setAttribute("shoppingReturnPath",req.getServletPath());
            resp.sendRedirect(req.getContextPath()+"/login"); return null;
        }
        if (req.getServletPath().startsWith("/admin/") && !user.isAdmin()) { resp.sendError(403); return null; }
        if (session.getAttribute("shoppingCsrf") == null) session.setAttribute("shoppingCsrf",UUID.randomUUID().toString());
        return user;
    }
    private void view(HttpServletRequest req,HttpServletResponse resp,String name) throws ServletException,IOException {
        req.getRequestDispatcher("/WEB-INF/views/shopping/"+name+".jsp").forward(req,resp);
    }
    @Override protected void doGet(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        resp.setHeader("Cache-Control","no-store");
        User_24133007 user = authorized(req,resp); if(user==null) return;
        try {
            req.setAttribute("message",req.getSession().getAttribute("courseMessage"));
            req.getSession().removeAttribute("courseMessage");
            switch(req.getServletPath()) {
                case "/activate" -> view(req,resp,"activate");
                case "/my-courses" -> { req.setAttribute("courses",dao.myCourses(user.getUsername())); view(req,resp,"my-courses"); }
                case "/admin/course-codes" -> { req.setAttribute("shipments",dao.shipments()); view(req,resp,"course-codes"); }
                default -> resp.sendError(404);
            }
        } catch(SQLException e) { failure(req,resp,e); }
    }
    @Override protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        req.setCharacterEncoding("UTF-8"); resp.setHeader("Cache-Control","no-store");
        User_24133007 user=authorized(req,resp); if(user==null) return;
        if(!"/activate".equals(req.getServletPath())) {resp.sendError(405);return;}
        if(!req.getSession().getAttribute("shoppingCsrf").equals(req.getParameter("csrf"))) {resp.sendError(403);return;}
        try {
            service.activate(user,req.getParameter("code"));
            req.getSession().setAttribute("courseMessage","Kích hoạt thành công. Bạn có thể xem các video private của khóa học.");
            resp.sendRedirect(req.getContextPath()+"/my-courses");
        } catch(IllegalArgumentException e) {req.setAttribute("error",e.getMessage());view(req,resp,"activate");}
        catch(SQLException e) {failure(req,resp,e);}
    }
    private void failure(HttpServletRequest req,HttpServletResponse resp,SQLException e) throws ServletException,IOException {
        getServletContext().log("Course database failure",e);resp.setStatus(503);
        req.setAttribute("error","Không xử lý được khóa học. Kiểm tra kết nối và chạy database-courses.sql.");view(req,resp,"error");
    }
}
