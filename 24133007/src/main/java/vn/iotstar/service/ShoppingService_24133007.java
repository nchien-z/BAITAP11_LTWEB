package vn.iotstar.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import vn.iotstar.dao.ShoppingDao_24133007;
import vn.iotstar.entity.*;

public class ShoppingService_24133007 {
    private final ShoppingDao_24133007 dao = new ShoppingDao_24133007();
    public List<Product_24133007> products() throws SQLException { return dao.products(); }
    public List<CartLine_24133007> lines(Cart_24133007 cart) throws SQLException { return dao.lines(cart.snapshot()); }
    public static BigDecimal total(List<CartLine_24133007> lines) {
        return lines.stream().map(CartLine_24133007::getSubtotal).reduce(BigDecimal.ZERO, BigDecimal::add);
    }
    public void change(Cart_24133007 cart, String action, int id, int quantity) throws SQLException {
        if ("remove".equals(action)) { cart.remove(id); return; }
        if (!"add".equals(action) && !"update".equals(action)) throw new IllegalArgumentException("Thao tác không hợp lệ.");
        Product_24133007 product = dao.find(id);
        if (product == null || !product.active()) throw new IllegalArgumentException("Sản phẩm không còn được bán.");
        if ("add".equals(action)) cart.add(id, quantity, product.stock());
        else cart.update(id, quantity, product.stock());
    }
    public static void validateDelivery(String recipient, String phone, String address, String note) {
        if (recipient == null || recipient.isBlank() || recipient.length() > 100)
            throw new IllegalArgumentException("Tên người nhận bắt buộc và tối đa 100 ký tự.");
        if (phone == null || !phone.matches("[0-9]{10,11}"))
            throw new IllegalArgumentException("Số điện thoại phải gồm 10–11 chữ số.");
        if (address == null || address.isBlank() || address.length() > 500)
            throw new IllegalArgumentException("Địa chỉ bắt buộc và tối đa 500 ký tự.");
        if (note != null && note.length() > 500) throw new IllegalArgumentException("Ghi chú tối đa 500 ký tự.");
    }
    public long checkout(User_24133007 user, String token, Cart_24133007 cart,
            String recipient, String phone, String address, String note) throws SQLException {
        validateDelivery(recipient, phone, address, note);
        long id = dao.checkout(user.getUsername(), token, cart.snapshot(), recipient, phone, address, note);
        cart.clear();
        return id;
    }
    public List<Order_24133007> history(User_24133007 user, OrderStatus_24133007 status) throws SQLException {
        return dao.history(user.getUsername(), status);
    }
}
