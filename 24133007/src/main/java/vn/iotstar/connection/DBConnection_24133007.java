package vn.iotstar.connection;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection_24133007 {
    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=WebVideo_24133007;encrypt=false;trustServerCertificate=true";
    private static final String USER = "sa";
    private static final String PASS = "Nchien@2809";

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }

    public static void main(String[] args) {
        Connection conn = getConnection();
        if (conn != null) {
            System.out.println("Kết nối CSDL WebVideo_24133007 thành công!");
        } else {
            System.out.println("Kết nối CSDL thất bại!");
        }
    }
}
