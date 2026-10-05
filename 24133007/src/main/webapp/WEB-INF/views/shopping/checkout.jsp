<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi"><head><title>Thanh toán COD - VideoHub</title></head><body>
<fmt:setLocale value="vi_VN"/>
<div class="container"><h1 class="mb-4">Thanh toán đơn hàng</h1>
    <c:if test="${not empty error}"><div class="alert alert-danger" role="alert"><c:out value="${error}"/></div></c:if>
    <div class="row g-4"><div class="col-md-7">
        <form method="post" action="${pageContext.request.contextPath}/checkout">
            <input type="hidden" name="csrf" value="${sessionScope.shoppingCsrf}"><input type="hidden" name="checkoutToken" value="${sessionScope.checkoutToken}">
            <div class="mb-3"><label for="recipient" class="form-label">Tên người nhận</label><input id="recipient" name="recipient" class="form-control" maxlength="100" required value="<c:out value='${param.recipient != null ? param.recipient : sessionScope.account.fullname}'/>"></div>
            <div class="mb-3"><label for="phone" class="form-label">Số điện thoại</label><input id="phone" name="phone" class="form-control" type="tel" inputmode="numeric" pattern="[0-9]{10,11}" maxlength="11" required value="<c:out value='${param.phone != null ? param.phone : sessionScope.account.phone}'/>"></div>
            <div class="mb-3"><label for="address" class="form-label">Địa chỉ nhận hàng</label><textarea id="address" name="address" class="form-control" maxlength="500" rows="3" required><c:out value="${param.address}"/></textarea></div>
            <div class="mb-3"><label for="note" class="form-label">Ghi chú</label><textarea id="note" name="note" class="form-control" maxlength="500" rows="2"><c:out value="${param.note}"/></textarea></div>
            <div class="alert alert-light border"><label><input type="radio" name="paymentMethod" value="COD" checked required> COD — Thanh toán khi nhận phiếu mã kích hoạt</label><p class="mb-0 small mt-2">Phiếu mã khóa học được giao đến địa chỉ trên. Mỗi suất có một mã, dùng một lần sau khi đơn đã giao. Phí giao phiếu: 0 ₫.</p></div>
            <c:choose><c:when test="${canCheckout}"><button class="btn btn-success" type="submit">Đặt hàng COD</button></c:when><c:otherwise><div class="alert alert-warning">Giỏ hàng chưa hợp lệ. Vui lòng cập nhật số lượng hoặc xóa sản phẩm không còn bán.</div></c:otherwise></c:choose>
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/cart">Sửa giỏ hàng</a>
        </form>
    </div><div class="col-md-5"><div class="card"><div class="card-body"><h2 class="h5">Đơn hàng của bạn</h2>
        <c:forEach var="line" items="${lines}"><p><c:out value="${line.product.name}"/> × ${line.quantity}<br><fmt:formatNumber value="${line.subtotal}" maxFractionDigits="0"/> ₫</p></c:forEach>
        <hr><p class="fw-bold">Tổng thanh toán: <fmt:formatNumber value="${total}" maxFractionDigits="0"/> ₫</p>
    </div></div></div></div>
</div></body></html>
