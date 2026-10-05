package vn.iotstar.dao;

import java.math.BigDecimal;
import java.sql.*;
import java.util.*;
import vn.iotstar.connection.DBConnection_24133007;
import vn.iotstar.entity.*;

public class ShoppingDao_24133007 {
    private Connection connection() throws SQLException {
        Connection connection = DBConnection_24133007.getConnection();
        if (connection == null) throw new SQLException("Không kết nối được database.");
        return connection;
    }
    private Product_24133007 product(ResultSet rs) throws SQLException {
        return new Product_24133007(rs.getInt("ProductId"), rs.getString("Name"),
                rs.getString("Description"), rs.getBigDecimal("Price"), rs.getInt("Stock"), rs.getBoolean("Active"));
    }
    public List<Product_24133007> products() throws SQLException {
        List<Product_24133007> products = new ArrayList<>();
        try (Connection c = connection(); PreparedStatement ps = c.prepareStatement("SELECT * FROM Products WHERE Active=1 ORDER BY ProductId");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) products.add(product(rs));
        }
        return products;
    }
    public Product_24133007 find(int id) throws SQLException {
        try (Connection c = connection(); PreparedStatement ps = c.prepareStatement("SELECT * FROM Products WHERE ProductId=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? product(rs) : null; }
        }
    }
    public List<CartLine_24133007> lines(Map<Integer, Integer> quantities) throws SQLException {
        List<CartLine_24133007> lines = new ArrayList<>();
        try (Connection c = connection(); PreparedStatement ps = c.prepareStatement("SELECT * FROM Products WHERE ProductId=?")) {
            for (var entry : quantities.entrySet()) {
                ps.setInt(1, entry.getKey());
                try (ResultSet rs = ps.executeQuery()) {
                    Product_24133007 p = rs.next() ? product(rs) :
                            new Product_24133007(entry.getKey(), "Sản phẩm đã bị xóa", "", BigDecimal.ZERO, 0, false);
                    lines.add(new CartLine_24133007(p, entry.getValue()));
                }
            }
        }
        return lines;
    }
    public long checkout(String username, String token, Map<Integer, Integer> quantities,
            String recipient, String phone, String address, String note) throws SQLException {
        if (quantities.isEmpty()) throw new IllegalArgumentException("Giỏ hàng đang trống.");
        try (Connection c = connection()) {
            c.setAutoCommit(false);
            try {
                // Khóa token đến cuối transaction để hai lần gửi cùng token chỉ tạo một đơn.
                try (PreparedStatement ps = c.prepareStatement(
                        "SELECT OrderId FROM Orders WITH (UPDLOCK,HOLDLOCK) WHERE CheckoutToken=? AND Username=?")) {
                    ps.setString(1, token); ps.setString(2, username);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) { long id = rs.getLong(1); c.commit(); return id; }
                    }
                }
                List<CartLine_24133007> lines = new ArrayList<>();
                BigDecimal total = BigDecimal.ZERO;
                // Khóa sản phẩm theo thứ tự cố định; giá và tồn kho lấy tại lúc đặt hàng.
                for (var entry : new TreeMap<>(quantities).entrySet()) {
                    try (PreparedStatement ps = c.prepareStatement("SELECT * FROM Products WITH (UPDLOCK,HOLDLOCK) WHERE ProductId=?")) {
                        ps.setInt(1, entry.getKey());
                        try (ResultSet rs = ps.executeQuery()) {
                            if (!rs.next()) throw new IllegalArgumentException("Sản phẩm không còn tồn tại.");
                            CartLine_24133007 line = new CartLine_24133007(product(rs), entry.getValue());
                            if (!line.isAvailable()) throw new IllegalArgumentException("Sản phẩm " + line.product().name() + " không đủ tồn kho hoặc đã ngừng bán. Hãy sửa giỏ hàng.");
                            lines.add(line); total = total.add(line.getSubtotal());
                        }
                    }
                }
                long orderId;
                try (PreparedStatement ps = c.prepareStatement(
                        "INSERT INTO Orders(Username,CheckoutToken,Recipient,Phone,Address,Note,Total) VALUES(?,?,?,?,?,?,?)",
                        Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, username); ps.setString(2, token); ps.setNString(3, recipient);
                    ps.setString(4, phone); ps.setNString(5, address); ps.setNString(6, note); ps.setBigDecimal(7, total);
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (!rs.next()) throw new SQLException("Không lấy được mã đơn hàng.");
                        orderId = rs.getLong(1);
                    }
                }
                try (PreparedStatement item = c.prepareStatement("INSERT INTO OrderItems(OrderId,ProductId,ProductName,UnitPrice,Quantity) VALUES(?,?,?,?,?)");
                     PreparedStatement stock = c.prepareStatement("UPDATE Products SET Stock=Stock-? WHERE ProductId=? AND Active=1 AND Stock>=?");
                     PreparedStatement code = c.prepareStatement("INSERT INTO ActivationCodes(Code,OrderId,ProductId,CodeIndex) VALUES(?,?,?,?)")) {
                    for (CartLine_24133007 line : lines) {
                        item.setLong(1, orderId); item.setInt(2, line.product().id()); item.setNString(3, line.product().name());
                        item.setBigDecimal(4, line.product().price()); item.setInt(5, line.quantity()); item.executeUpdate();
                        stock.setInt(1, line.quantity()); stock.setInt(2, line.product().id()); stock.setInt(3, line.quantity());
                        if (stock.executeUpdate() != 1) throw new SQLException("Không cập nhật được tồn kho.");
                        for (int index = 1; index <= line.quantity(); index++) {
                            code.setString(1, UUID.randomUUID().toString().toUpperCase(Locale.ROOT));
                            code.setLong(2, orderId); code.setInt(3, line.product().id()); code.setInt(4, index);
                            code.executeUpdate();
                        }
                    }
                }
                c.commit();
                return orderId;
            } catch (SQLException | RuntimeException e) {
                c.rollback();
                throw e;
            }
        }
    }
    public List<Order_24133007> history(String username, OrderStatus_24133007 status) throws SQLException {
        List<Order_24133007> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE Username=?" + (status == null ? "" : " AND Status=?") + " ORDER BY CreatedAt DESC,OrderId DESC";
        try (Connection c = connection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            if (status != null) ps.setString(2, status.name());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(new Order_24133007(rs.getLong("OrderId"), rs.getTimestamp("CreatedAt"),
                            OrderStatus_24133007.valueOf(rs.getString("Status")), rs.getString("Recipient"),
                            rs.getString("Phone"), rs.getString("Address"), rs.getString("Note"), rs.getBigDecimal("Total"), new ArrayList<>()));
                }
            }
            try (PreparedStatement items = c.prepareStatement("SELECT ProductName,UnitPrice,Quantity FROM OrderItems WHERE OrderId=? ORDER BY ProductId")) {
                for (Order_24133007 order : orders) {
                    items.setLong(1, order.id());
                    try (ResultSet rs = items.executeQuery()) {
                        while (rs.next()) order.items().add(new Order_24133007.Item(rs.getString(1), rs.getBigDecimal(2), rs.getInt(3)));
                    }
                }
            }
        }
        return orders;
    }
}
