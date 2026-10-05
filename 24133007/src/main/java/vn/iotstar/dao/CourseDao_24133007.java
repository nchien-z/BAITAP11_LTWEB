package vn.iotstar.dao;

import java.sql.*;
import java.util.*;
import vn.iotstar.connection.DBConnection_24133007;

public class CourseDao_24133007 {
    private Connection connection() throws SQLException {
        Connection c = DBConnection_24133007.getConnection();
        if (c == null) throw new SQLException("Database unavailable");
        return c;
    }
    public boolean hasAccess(String username, int courseId) throws SQLException {
        try (Connection c = connection(); PreparedStatement ps = c.prepareStatement(
                "SELECT TOP 1 a.Code FROM ActivationCodes a JOIN Orders o ON o.OrderId=a.OrderId WHERE a.ActivatedBy=? AND a.ProductId=? AND o.Status NOT IN ('CANCELLED','RETURNED')")) {
            ps.setString(1, username); ps.setInt(2, courseId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        }
    }
    public void activate(String username, String code) throws SQLException {
        try (Connection c = connection()) {
            c.setAutoCommit(false);
            try {
                try (PreparedStatement ps = c.prepareStatement(
                        "SELECT a.ActivatedBy,o.Status FROM ActivationCodes a WITH (UPDLOCK,HOLDLOCK) JOIN Orders o WITH (UPDLOCK,HOLDLOCK) ON o.OrderId=a.OrderId WHERE a.Code=?")) {
                    ps.setString(1, code);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) throw new IllegalArgumentException("Mã kích hoạt không hợp lệ.");
                        if (rs.getString("ActivatedBy") != null) throw new IllegalArgumentException("Mã kích hoạt đã được sử dụng.");
                        if (!"DELIVERED".equals(rs.getString("Status")))
                            throw new IllegalArgumentException("Mã chỉ kích hoạt được sau khi đơn COD đã giao và thu tiền.");
                    }
                }
                try (PreparedStatement ps = c.prepareStatement("UPDATE ActivationCodes SET ActivatedBy=?,ActivatedAt=SYSDATETIME() WHERE Code=? AND ActivatedBy IS NULL")) {
                    ps.setString(1, username); ps.setString(2, code);
                    if (ps.executeUpdate() != 1) throw new IllegalArgumentException("Mã kích hoạt đã được sử dụng.");
                }
                c.commit();
            } catch (SQLException | RuntimeException e) { c.rollback(); throw e; }
        }
    }
    public Map<Integer,List<Lesson>> lessons() throws SQLException {
        Map<Integer,List<Lesson>> lessons = new LinkedHashMap<>();
        try (Connection c = connection(); PreparedStatement ps = c.prepareStatement("SELECT VideoId,Title,CourseId,IsPrivate FROM Videos WHERE Active=1 AND CourseId IS NOT NULL ORDER BY VideoId"); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lessons.computeIfAbsent(rs.getInt("CourseId"), id -> new ArrayList<>())
                .add(new Lesson(rs.getString("VideoId"),rs.getString("Title"),rs.getBoolean("IsPrivate")));
        }
        return lessons;
    }
    public List<Course> myCourses(String username) throws SQLException {
        List<Course> courses = new ArrayList<>();
        Map<Integer,List<Lesson>> lessons = lessons();
        try (Connection c = connection(); PreparedStatement ps = c.prepareStatement(
                "SELECT DISTINCT p.ProductId,p.Name FROM Products p JOIN ActivationCodes a ON a.ProductId=p.ProductId JOIN Orders o ON o.OrderId=a.OrderId WHERE a.ActivatedBy=? AND o.Status NOT IN ('CANCELLED','RETURNED') ORDER BY p.ProductId")) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) courses.add(new Course(rs.getInt(1),rs.getString(2),lessons.getOrDefault(rs.getInt(1),List.of())));
            }
        }
        return courses;
    }
    public List<Shipment> shipments() throws SQLException {
        List<Shipment> result = new ArrayList<>();
        try (Connection c = connection(); PreparedStatement ps = c.prepareStatement(
                "SELECT a.Code,a.OrderId,i.ProductName,o.Recipient,o.Phone,o.Address,o.Status,a.ActivatedBy FROM ActivationCodes a JOIN Orders o ON o.OrderId=a.OrderId JOIN OrderItems i ON i.OrderId=a.OrderId AND i.ProductId=a.ProductId ORDER BY a.OrderId DESC,a.ProductId,a.CodeIndex"); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) result.add(new Shipment(rs.getString(1),rs.getLong(2),rs.getString(3),rs.getString(4),rs.getString(5),rs.getString(6),rs.getString(7),rs.getString(8)));
        }
        return result;
    }
    // JavaBean getters hỗ trợ cả JSP/EL trên Tomcat 10 và accessor record trên Tomcat 11.
    public record Lesson(String id, String title, boolean privateVideo) {
        public String getId() { return id; }
        public String getTitle() { return title; }
        public boolean isPrivateVideo() { return privateVideo; }
    }
    public record Course(int id, String name, List<Lesson> lessons) {
        public int getId() { return id; }
        public String getName() { return name; }
        public List<Lesson> getLessons() { return lessons; }
    }
    public record Shipment(String code,long orderId,String course,String recipient,String phone,String address,String status,String activatedBy) {
        public String getCode() { return code; }
        public long getOrderId() { return orderId; }
        public String getCourse() { return course; }
        public String getRecipient() { return recipient; }
        public String getPhone() { return phone; }
        public String getAddress() { return address; }
        public String getStatus() { return status; }
        public String getActivatedBy() { return activatedBy; }
    }
}
