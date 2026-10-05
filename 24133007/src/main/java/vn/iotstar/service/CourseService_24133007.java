package vn.iotstar.service;

import java.sql.SQLException;
import java.util.Locale;
import vn.iotstar.dao.CourseDao_24133007;
import vn.iotstar.entity.*;

public class CourseService_24133007 {
    private final CourseDao_24133007 dao = new CourseDao_24133007();
    public boolean canWatch(Video_24133007 video, User_24133007 user) throws SQLException {
        if (!video.isActive()) return user != null && user.isAdmin();
        if (!video.isPrivateVideo()) return true;
        return user != null && (user.isAdmin() || (video.getCourseId() != null && dao.hasAccess(user.getUsername(), video.getCourseId())));
    }
    public void activate(User_24133007 user, String input) throws SQLException {
        if (user == null) throw new IllegalArgumentException("Vui lòng đăng nhập để kích hoạt.");
        String code = input == null ? "" : input.strip().toUpperCase(Locale.ROOT);
        if (!code.matches("[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}"))
            throw new IllegalArgumentException("Vui lòng nhập đúng mã kích hoạt trên phiếu được giao.");
        dao.activate(user.getUsername(), code);
    }
}
