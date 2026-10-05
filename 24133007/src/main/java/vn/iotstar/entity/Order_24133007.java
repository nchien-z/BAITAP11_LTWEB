package vn.iotstar.entity;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

public record Order_24133007(long id, Timestamp createdAt, OrderStatus_24133007 status,
        String recipient, String phone, String address, String note, BigDecimal total, List<Item> items) {
    public long getId() { return id; }
    public Timestamp getCreatedAt() { return createdAt; }
    public OrderStatus_24133007 getStatus() { return status; }
    public String getRecipient() { return recipient; }
    public String getPhone() { return phone; }
    public String getAddress() { return address; }
    public String getNote() { return note; }
    public BigDecimal getTotal() { return total; }
    public List<Item> getItems() { return items; }

    public record Item(String name, BigDecimal price, int quantity) {
        public String getName() { return name; }
        public BigDecimal getPrice() { return price; }
        public int getQuantity() { return quantity; }
        public BigDecimal getSubtotal() { return price.multiply(BigDecimal.valueOf(quantity)); }
        public BigDecimal subtotal() { return getSubtotal(); }
    }
}
