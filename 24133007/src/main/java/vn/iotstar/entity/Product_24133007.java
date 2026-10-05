package vn.iotstar.entity;

import java.math.BigDecimal;

public record Product_24133007(int id, String name, String description, BigDecimal price, int stock, boolean active) {
    public int getId() { return id; }
    public String getName() { return name; }
    public String getDescription() { return description; }
    public BigDecimal getPrice() { return price; }
    public int getStock() { return stock; }
    public boolean isActive() { return active; }
}
