<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi"><head><title>Giỏ hàng - VideoHub</title></head><body>
<fmt:setLocale value="vi_VN"/>
<div class="container"><h1 class="mb-4">Giỏ hàng</h1>
    <c:if test="${not empty message}"><div role="status" class="alert alert-info"><c:out value="${message}"/></div></c:if>
    <c:choose><c:when test="${empty lines}"><div class="alert alert-light">Giỏ hàng đang trống.</div></c:when><c:otherwise>
        <div class="table-responsive"><table class="table align-middle">
            <thead><tr><th>Sản phẩm</th><th>Đơn giá</th><th>Số lượng</th><th>Thành tiền</th><th></th></tr></thead>
            <tbody><c:forEach var="line" items="${lines}"><tr>
                <td><c:out value="${line.product.name}"/><div class="small text-muted">Tồn kho: ${line.product.stock}; giới hạn: ${line.limit}</div>
                    <c:if test="${!line.available}"><div class="text-danger">Sản phẩm ngừng bán hoặc số lượng vượt tồn kho. Hãy sửa hoặc xóa.</div></c:if>
                </td>
                <td><fmt:formatNumber value="${line.product.price}" maxFractionDigits="0"/> ₫</td>
                <td><c:if test="${line.product.active && line.limit > 0}"><form method="post" action="${pageContext.request.contextPath}/cart" class="d-flex gap-2">
                    <input type="hidden" name="csrf" value="${sessionScope.shoppingCsrf}"><input type="hidden" name="action" value="update"><input type="hidden" name="productId" value="${line.product.id}">
                    <input aria-label="Số lượng sản phẩm" class="form-control" style="width:85px" type="number" name="quantity" min="1" max="${line.limit}" value="${line.quantity}" required>
                    <button class="btn btn-outline-primary" type="submit">Cập nhật</button>
                </form></c:if></td>
                <td><fmt:formatNumber value="${line.subtotal}" maxFractionDigits="0"/> ₫</td>
                <td><form method="post" action="${pageContext.request.contextPath}/cart">
                    <input type="hidden" name="csrf" value="${sessionScope.shoppingCsrf}"><input type="hidden" name="action" value="remove"><input type="hidden" name="productId" value="${line.product.id}">
                    <button class="btn btn-outline-danger" type="submit">Xóa</button>
                </form></td>
            </tr></c:forEach></tbody>
        </table></div>
        <p class="fs-4 fw-bold">Tổng cộng: <fmt:formatNumber value="${total}" maxFractionDigits="0"/> ₫</p>
        <div class="d-flex gap-3 mb-3">
            <form method="post" action="${pageContext.request.contextPath}/cart"><input type="hidden" name="csrf" value="${sessionScope.shoppingCsrf}"><input type="hidden" name="action" value="clear"><button class="btn btn-outline-danger">Xóa toàn bộ giỏ</button></form>
            <c:if test="${canCheckout}"><a class="btn btn-success" href="${pageContext.request.contextPath}/checkout">Thanh toán COD</a></c:if>
        </div>
    </c:otherwise></c:choose>
    <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/products">Tiếp tục mua hàng</a>
</div></body></html>
