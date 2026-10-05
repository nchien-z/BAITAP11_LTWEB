package vn.iotstar;

import java.math.BigDecimal;
import java.util.List;
import junit.framework.TestCase;
import vn.iotstar.entity.*;
import vn.iotstar.service.ShoppingService_24133007;

public class ShoppingTest extends TestCase {
    private void rejects(Runnable operation) {
        try { operation.run(); fail("Expected validation failure"); }
        catch (IllegalArgumentException expected) { }
    }
    public void testAddMergesAndHonorsStock() {
        Cart_24133007 cart = new Cart_24133007();
        cart.add(1, 2, 5); cart.add(1, 3, 5);
        assertEquals(Integer.valueOf(5), cart.snapshot().get(1));
        rejects(() -> cart.add(1, 1, 5));
        rejects(() -> cart.add(2, 1, 0));
        rejects(() -> cart.add(2, 0, 10));
        rejects(() -> cart.add(2, -1, 10));
        rejects(() -> cart.add(1, Integer.MAX_VALUE, Integer.MAX_VALUE));
        assertEquals(Integer.valueOf(5), cart.snapshot().get(1));
    }
    public void testQuantityLimitAndUpdate() {
        Cart_24133007 cart = new Cart_24133007();
        cart.add(1, 99, 1000);
        rejects(() -> cart.add(1, 1, 1000));
        rejects(() -> cart.update(1, 100, 1000));
        rejects(() -> cart.update(1, 0, 1000));
        rejects(() -> cart.update(1, -1, 1000));
        rejects(() -> cart.update(1, 5, 4));
        rejects(() -> cart.update(2, 1, 10));
        cart.update(1, 4, 4);
        assertEquals(Integer.valueOf(4), cart.snapshot().get(1));
    }
    public void testRemoveClearAndSnapshotIsolation() {
        Cart_24133007 cart = new Cart_24133007();
        cart.add(1, 2, 5); cart.add(2, 1, 5);
        cart.snapshot().clear(); assertEquals(2, cart.snapshot().size());
        cart.remove(1); assertFalse(cart.snapshot().containsKey(1));
        cart.remove(99); cart.clear(); assertTrue(cart.snapshot().isEmpty());
    }
    public void testMoneyAndAvailability() {
        Product_24133007 product = new Product_24133007(1, "Sample", "", new BigDecimal("35000.25"), 5, true);
        CartLine_24133007 line = new CartLine_24133007(product, 3);
        assertEquals(new BigDecimal("105000.75"), line.getSubtotal());
        assertEquals(new BigDecimal("140001.00"), ShoppingService_24133007.total(List.of(line, new CartLine_24133007(product, 1))));
        assertTrue(line.isAvailable());
        assertFalse(new CartLine_24133007(product, 6).isAvailable());
        assertFalse(new CartLine_24133007(product, 0).isAvailable());
        assertFalse(new CartLine_24133007(new Product_24133007(1, "", "", BigDecimal.ONE, 5, false), 1).isAvailable());
    }
    public void testDeliveryValidation() {
        ShoppingService_24133007.validateDelivery("Nguyễn Văn A", "0912345678", "1 Võ Văn Ngân", "");
        rejects(() -> ShoppingService_24133007.validateDelivery(" ", "0912345678", "Address", ""));
        rejects(() -> ShoppingService_24133007.validateDelivery("A".repeat(101), "0912345678", "Address", ""));
        rejects(() -> ShoppingService_24133007.validateDelivery("A", "123", "Address", ""));
        rejects(() -> ShoppingService_24133007.validateDelivery("A", "091234567a", "Address", ""));
        rejects(() -> ShoppingService_24133007.validateDelivery("A", "0912345678", " ", ""));
        rejects(() -> ShoppingService_24133007.validateDelivery("A", "0912345678", "A".repeat(501), ""));
        rejects(() -> ShoppingService_24133007.validateDelivery("A", "0912345678", "Address", "A".repeat(501)));
    }
    public void testAllEightStatusesHaveLabels() {
        assertEquals(8, OrderStatus_24133007.values().length);
        for (OrderStatus_24133007 status : OrderStatus_24133007.values()) {
            assertFalse(status.getLabel().isBlank());
            assertEquals(status, OrderStatus_24133007.valueOf(status.getCode()));
        }
    }
}
