package vn.iotstar.entity;

import java.io.Serializable;
import java.util.LinkedHashMap;
import java.util.Map;

public class Cart_24133007 implements Serializable {
    private static final long serialVersionUID = 1L;
    public static final int MAX_QUANTITY = 99;
    private final Map<Integer, Integer> quantities = new LinkedHashMap<>();

    public synchronized Map<Integer, Integer> snapshot() { return new LinkedHashMap<>(quantities); }
    public synchronized void add(int id, int quantity, int stock) {
        long total = (long) quantities.getOrDefault(id, 0) + quantity;
        if (quantity < 1 || total > Math.min(MAX_QUANTITY, stock)) {
            throw new IllegalArgumentException("Số lượng phải từ 1 đến " + Math.min(MAX_QUANTITY, stock) + " và không vượt tồn kho.");
        }
        quantities.put(id, (int) total);
    }
    public synchronized void update(int id, int quantity, int stock) {
        if (!quantities.containsKey(id)) throw new IllegalArgumentException("Sản phẩm không có trong giỏ hàng.");
        if (quantity < 1 || quantity > Math.min(MAX_QUANTITY, stock)) {
            throw new IllegalArgumentException("Số lượng phải từ 1 đến " + Math.min(MAX_QUANTITY, stock) + " và không vượt tồn kho.");
        }
        quantities.put(id, quantity);
    }
    public synchronized void remove(int id) { quantities.remove(id); }
    public synchronized void clear() { quantities.clear(); }
}
