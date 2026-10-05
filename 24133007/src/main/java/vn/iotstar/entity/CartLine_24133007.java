package vn.iotstar.entity;

import java.math.BigDecimal;

public record CartLine_24133007(Product_24133007 product, int quantity) {
    public Product_24133007 getProduct() { return product; }
    public int getQuantity() { return quantity; }
    public int getLimit() { return Math.min(Cart_24133007.MAX_QUANTITY, product.stock()); }
    public boolean isAvailable() { return product.active() && quantity >= 1 && quantity <= getLimit(); }
    public BigDecimal getSubtotal() { return product.price().multiply(BigDecimal.valueOf(quantity)); }
    // Jakarta EL 6 dùng accessor của record, kể cả thuộc tính tính toán.
    public int limit() { return getLimit(); }
    public boolean available() { return isAvailable(); }
    public BigDecimal subtotal() { return getSubtotal(); }
}
