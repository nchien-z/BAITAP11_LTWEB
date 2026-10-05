package vn.iotstar;

import java.sql.*;
import java.util.*;
import java.util.concurrent.*;
import junit.framework.TestCase;
import vn.iotstar.connection.DBConnection_24133007;
import vn.iotstar.dao.ShoppingDao_24133007;
import vn.iotstar.entity.*;

/** Run explicitly with mvn -Dtest=ShoppingDatabaseIT test after the migration. */
public class ShoppingDatabaseIT extends TestCase {
    private String username;
    private int productId;
    private final ShoppingDao_24133007 dao = new ShoppingDao_24133007();
    @Override protected void setUp() throws Exception {
        username = "shopping_test_" + UUID.randomUUID().toString().substring(0, 20);
        try (Connection c = DBConnection_24133007.getConnection()) {
            assertNotNull("SQL Server connection required", c);
            try (PreparedStatement ps = c.prepareStatement("INSERT INTO Users(Username,Password,Active) VALUES(?, 'test-only', 1)")) {
                ps.setString(1, username); ps.executeUpdate();
            }
            try (PreparedStatement ps = c.prepareStatement("INSERT INTO Products(Name,Price,Stock,Active) VALUES(N'Test fixture',12.50,2,1)", Statement.RETURN_GENERATED_KEYS)) {
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) { assertTrue(rs.next()); productId = rs.getInt(1); }
            }
        }
    }
    @Override protected void tearDown() throws Exception {
        try (Connection c = DBConnection_24133007.getConnection()) {
            c.setAutoCommit(false);
            try (PreparedStatement ps = c.prepareStatement("DELETE FROM ActivationCodes WHERE OrderId IN (SELECT OrderId FROM Orders WHERE Username=?)")) { ps.setString(1, username); ps.executeUpdate(); }
            try (PreparedStatement ps = c.prepareStatement("DELETE FROM OrderItems WHERE OrderId IN (SELECT OrderId FROM Orders WHERE Username=?)")) { ps.setString(1, username); ps.executeUpdate(); }
            try (PreparedStatement ps = c.prepareStatement("DELETE FROM Orders WHERE Username=?")) { ps.setString(1, username); ps.executeUpdate(); }
            try (PreparedStatement ps = c.prepareStatement("DELETE FROM Products WHERE ProductId=?")) { ps.setInt(1, productId); ps.executeUpdate(); }
            try (PreparedStatement ps = c.prepareStatement("DELETE FROM Users WHERE Username=?")) { ps.setString(1, username); ps.executeUpdate(); }
            c.commit();
        }
    }
    private long checkout(String token, int quantity) throws SQLException {
        return dao.checkout(username, token, Map.of(productId, quantity), "Test", "0912345678", "Test address", "");
    }
    public void testCodSnapshotIdempotencyAndAllStatusFilters() throws Exception {
        String token = UUID.randomUUID().toString();
        long id = checkout(token, 1);
        assertEquals(id, checkout(token, 1));
        assertEquals(1, dao.find(productId).stock());
        assertEquals(1, dao.history(username, null).size());
        Order_24133007 order = dao.history(username, OrderStatus_24133007.NEW).get(0);
        assertEquals("25.00", dao.find(productId).price().multiply(java.math.BigDecimal.valueOf(2)).toPlainString());
        assertEquals("12.50", order.total().toPlainString());
        assertEquals(1, order.items().get(0).quantity());
        assertTrue(dao.history("other_" + username, null).isEmpty());
        try (Connection c = DBConnection_24133007.getConnection(); PreparedStatement ps = c.prepareStatement("UPDATE Orders SET Status=? WHERE OrderId=?")) {
            for (OrderStatus_24133007 status : OrderStatus_24133007.values()) {
                ps.setString(1, status.name()); ps.setLong(2, id); ps.executeUpdate();
                assertEquals(status, dao.history(username, status).get(0).status());
                assertEquals(1, dao.history(username, null).size());
                for (OrderStatus_24133007 other : OrderStatus_24133007.values()) {
                    if (other != status) assertTrue(dao.history(username, other).isEmpty());
                }
            }
        }
    }
    public void testRejectedCheckoutLeavesNoOrderAndStockUnchanged() throws Exception {
        try { checkout(UUID.randomUUID().toString(), 3); fail("Must reject insufficient stock"); }
        catch (IllegalArgumentException expected) { }
        assertEquals(2, dao.find(productId).stock()); assertTrue(dao.history(username, null).isEmpty());
        try { dao.checkout(username, UUID.randomUUID().toString(), Map.of(productId, 1, -1, 1), "Test", "0912345678", "Test", ""); fail("Must reject missing product"); }
        catch (IllegalArgumentException expected) { }
        assertEquals(2, dao.find(productId).stock()); assertTrue(dao.history(username, null).isEmpty());
        // Lỗi SQL sau INSERT Orders phải rollback cả đơn và tồn kho.
        try { dao.checkout(username, UUID.randomUUID().toString(), Map.of(productId, 1), "A".repeat(101), "0912345678", "Test", ""); fail("Must reject oversized column"); }
        catch (SQLException expected) { }
        assertEquals(2, dao.find(productId).stock()); assertTrue(dao.history(username, null).isEmpty());
    }
    public void testConcurrentCheckoutCannotOversell() throws Exception {
        ExecutorService executor = Executors.newFixedThreadPool(2);
        CountDownLatch start = new CountDownLatch(1);
        Callable<Boolean> attempt = () -> {
            start.await();
            try { checkout(UUID.randomUUID().toString(), 2); return true; }
            catch (IllegalArgumentException expected) { return false; }
        };
        try {
            Future<Boolean> first = executor.submit(attempt), second = executor.submit(attempt);
            start.countDown();
            int successes = (first.get(20, TimeUnit.SECONDS) ? 1 : 0) + (second.get(20, TimeUnit.SECONDS) ? 1 : 0);
            assertEquals(1, successes); assertEquals(0, dao.find(productId).stock());
            assertEquals(1, dao.history(username, null).size());
        } finally { executor.shutdownNow(); }
    }
    public void testActivationRequiresDeliveryAndCannotBeReused() throws Exception {
        long id=checkout(UUID.randomUUID().toString(),2);
        vn.iotstar.dao.CourseDao_24133007 courses=new vn.iotstar.dao.CourseDao_24133007();
        String code;
        try(Connection c=DBConnection_24133007.getConnection();PreparedStatement ps=c.prepareStatement("SELECT Code FROM ActivationCodes WHERE OrderId=?")) {
            ps.setLong(1,id);
            try(ResultSet rs=ps.executeQuery()) {assertTrue(rs.next());code=rs.getString(1);assertTrue(rs.next());assertFalse(rs.next());}
        }
        assertFalse(courses.hasAccess(username,productId));
        try {courses.activate(username,code);fail("Undelivered code must be rejected");} catch(IllegalArgumentException expected) { }
        try(Connection c=DBConnection_24133007.getConnection();PreparedStatement ps=c.prepareStatement("UPDATE Orders SET Status=? WHERE OrderId=?")) {
            ps.setString(1,"DELIVERED");ps.setLong(2,id);ps.executeUpdate();
            courses.activate(username,code);
            assertTrue(courses.hasAccess(username,productId));assertFalse(courses.hasAccess("other",productId));assertFalse(courses.hasAccess(username,-1));
            try {courses.activate("other",code);fail("Code cannot be reused");} catch(IllegalArgumentException expected) { }
            ps.setString(1,"RETURNED");ps.executeUpdate();assertFalse(courses.hasAccess(username,productId));
        }
    }
    public void testConcurrentActivationConsumesCodeOnce() throws Exception {
        long id=checkout(UUID.randomUUID().toString(),1);
        String code;
        try(Connection c=DBConnection_24133007.getConnection();PreparedStatement update=c.prepareStatement("UPDATE Orders SET Status='DELIVERED' WHERE OrderId=?");PreparedStatement select=c.prepareStatement("SELECT Code FROM ActivationCodes WHERE OrderId=?")) {
            update.setLong(1,id);update.executeUpdate();select.setLong(1,id);
            try(ResultSet rs=select.executeQuery()){assertTrue(rs.next());code=rs.getString(1);}
        }
        ExecutorService executor=Executors.newFixedThreadPool(2);CountDownLatch start=new CountDownLatch(1);
        Callable<Boolean> attempt=()->{start.await();try{new vn.iotstar.dao.CourseDao_24133007().activate(username,code);return true;}catch(IllegalArgumentException expected){return false;}};
        try {
            Future<Boolean> first=executor.submit(attempt),second=executor.submit(attempt);start.countDown();
            assertEquals(1,(first.get(20,TimeUnit.SECONDS)?1:0)+(second.get(20,TimeUnit.SECONDS)?1:0));
        } finally {executor.shutdownNow();}
    }
}
