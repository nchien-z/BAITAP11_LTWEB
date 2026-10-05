package vn.iotstar.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.entity.*;
import vn.iotstar.service.ShoppingService_24133007;
import vn.iotstar.util.Constant_24133007;

@WebServlet(urlPatterns = {"/products", "/cart", "/checkout", "/orders"})
public class ShoppingController_24133007 extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ShoppingService_24133007 service = new ShoppingService_24133007();

    private Cart_24133007 cart(HttpSession session) {
        Cart_24133007 cart = (Cart_24133007) session.getAttribute("shoppingCart");
        if (cart == null) {
            cart = new Cart_24133007(); session.setAttribute("shoppingCart", cart);
        }
        if (session.getAttribute("shoppingCsrf") == null)
            session.setAttribute("shoppingCsrf", UUID.randomUUID().toString());
        return cart;
    }
    private User_24133007 user(HttpSession session) {
        return (User_24133007) session.getAttribute(Constant_24133007.SESSION_USER);
    }
    private boolean requiresLogin(String path) { return "/checkout".equals(path) || "/orders".equals(path); }
    private void view(HttpServletRequest req, HttpServletResponse resp, String name) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/shopping/" + name + ".jsp").forward(req, resp);
    }
    private void populateCart(HttpServletRequest req, Cart_24133007 cart) throws SQLException {
        List<CartLine_24133007> lines = service.lines(cart);
        req.setAttribute("lines", lines);
        req.setAttribute("total", ShoppingService_24133007.total(lines));
        req.setAttribute("canCheckout", !lines.isEmpty() && lines.stream().allMatch(CartLine_24133007::isAvailable));
    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Cache-Control", "no-store");
        HttpSession session = req.getSession();
        synchronized (session) {
            Cart_24133007 cart = cart(session);
            String path = req.getServletPath();
            if (requiresLogin(path) && user(session) == null) {
                session.setAttribute("shoppingReturnPath", path);
                resp.sendRedirect(req.getContextPath() + "/login"); return;
            }
            req.setAttribute("message", session.getAttribute("shoppingMessage"));
            session.removeAttribute("shoppingMessage");
            try {
                switch (path) {
                    case "/products" -> {
                        req.setAttribute("products", service.products());
                        req.setAttribute("courseVideos", new vn.iotstar.dao.CourseDao_24133007().lessons());
                        view(req, resp, "products");
                    }
                    case "/cart" -> { populateCart(req, cart); view(req, resp, "cart"); }
                    case "/checkout" -> {
                        populateCart(req, cart);
                        if (cart.snapshot().isEmpty()) { resp.sendRedirect(req.getContextPath() + "/cart"); return; }
                        if (session.getAttribute("checkoutToken") == null)
                            session.setAttribute("checkoutToken", UUID.randomUUID().toString());
                        view(req, resp, "checkout");
                    }
                    case "/orders" -> {
                        String code = req.getParameter("status");
                        OrderStatus_24133007 status = code == null || code.isBlank() ? null : OrderStatus_24133007.valueOf(code);
                        req.setAttribute("statuses", OrderStatus_24133007.values());
                        req.setAttribute("selectedStatus", status == null ? "" : status.name());
                        req.setAttribute("orders", service.history(user(session), status));
                        view(req, resp, "orders");
                    }
                    default -> resp.sendError(404);
                }
            } catch (IllegalArgumentException e) {
                resp.sendError(400, "Trạng thái không hợp lệ.");
            } catch (SQLException e) { databaseError(req, resp, e); }
        }
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8"); resp.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        synchronized (session) {
            Cart_24133007 cart = cart(session);
            String path = req.getServletPath();
            if (!"/cart".equals(path) && !"/checkout".equals(path)) { resp.sendError(405); return; }
            if (!session.getAttribute("shoppingCsrf").equals(req.getParameter("csrf"))) {
                resp.sendError(403, "Phiên thao tác không hợp lệ. Vui lòng tải lại trang."); return;
            }
            if ("/checkout".equals(path) && user(session) == null) {
                session.setAttribute("shoppingReturnPath", path);
                resp.sendRedirect(req.getContextPath() + "/login"); return;
            }
            try {
                if ("/cart".equals(path)) {
                    String action = req.getParameter("action");
                    if ("clear".equals(action)) cart.clear();
                    else {
                        int id = Integer.parseInt(req.getParameter("productId"));
                        int quantity = "remove".equals(action) ? 0 : Integer.parseInt(req.getParameter("quantity"));
                        service.change(cart, action, id, quantity);
                    }
                    session.removeAttribute("checkoutToken");
                    session.setAttribute("shoppingMessage", "Đã cập nhật giỏ hàng.");
                    resp.sendRedirect(req.getContextPath() + "/cart");
                } else {
                    Object token = session.getAttribute("checkoutToken");
                    if (token == null || !token.equals(req.getParameter("checkoutToken")))
                        throw new IllegalArgumentException("Phiên thanh toán đã kết thúc hoặc giỏ hàng đã thay đổi. Vui lòng mở lại thanh toán.");
                    if (!"COD".equals(req.getParameter("paymentMethod")))
                        throw new IllegalArgumentException("Chỉ hỗ trợ thanh toán COD.");
                    long id = service.checkout(user(session), token.toString(), cart,
                            trimmed(req, "recipient"), trimmed(req, "phone"), trimmed(req, "address"), trimmed(req, "note"));
                    session.removeAttribute("checkoutToken");
                    session.setAttribute("shoppingMessage", "Đặt đơn #" + id + " thành công. Thanh toán khi nhận hàng (COD).");
                    resp.sendRedirect(req.getContextPath() + "/orders");
                }
            } catch (IllegalArgumentException e) {
                String message = e instanceof NumberFormatException ? "Mã sản phẩm và số lượng phải là số nguyên hợp lệ." : e.getMessage();
                if ("/checkout".equals(path)) {
                    req.setAttribute("error", message);
                    try { populateCart(req, cart); view(req, resp, "checkout"); }
                    catch (SQLException db) { databaseError(req, resp, db); }
                } else {
                    session.setAttribute("shoppingMessage", message);
                    resp.sendRedirect(req.getContextPath() + "/cart");
                }
            } catch (SQLException e) { databaseError(req, resp, e); }
        }
    }
    private String trimmed(HttpServletRequest req, String name) {
        String value = req.getParameter(name); return value == null ? "" : value.strip();
    }
    private void databaseError(HttpServletRequest req, HttpServletResponse resp, SQLException e) throws ServletException, IOException {
        getServletContext().log("Shopping database failure", e);
        resp.setStatus(503);
        req.setAttribute("error", "Không thể xử lý dữ liệu lúc này. Vui lòng kiểm tra kết nối database và chạy database-shopping.sql nếu chưa khởi tạo.");
        view(req, resp, "error");
    }
}
