<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi"><head><title>Lịch sử đặt hàng - VideoHub</title></head><body>
<fmt:setLocale value="vi_VN"/>
<div class="container"><h1 class="mb-4">Lịch sử đặt hàng</h1>
    <p>Mã kích hoạt được giao trên phiếu đến địa chỉ của đơn COD. Khi đã nhận phiếu, mở <a href="${pageContext.request.contextPath}/activate">Kích hoạt khóa học</a> để nhập mã. Đặt hàng chưa tự mở quyền xem video private.</p>
    <c:if test="${not empty message}"><div class="alert alert-success" role="status"><c:out value="${message}"/></div></c:if>
    <form method="get" action="${pageContext.request.contextPath}/orders" class="d-flex gap-2 mb-4">
        <label class="form-label align-self-center text-nowrap" for="status">Trạng thái</label>
        <select id="status" name="status" class="form-select" style="max-width:300px"><option value="">Tất cả</option>
            <c:forEach var="status" items="${statuses}"><option value="${status.code}" ${selectedStatus == status.code ? 'selected' : ''}><c:out value="${status.label}"/></option></c:forEach>
        </select><button class="btn btn-primary" type="submit">Lọc / Tải lại</button>
    </form>
    <c:if test="${empty orders}"><div class="alert alert-light">Không có đơn hàng ở trạng thái này.</div></c:if>
    <c:forEach var="order" items="${orders}"><article class="card shadow-sm mb-4"><div class="card-body">
        <div class="d-flex justify-content-between flex-wrap gap-2"><h2 class="h5">Đơn #${order.id}</h2><span class="badge bg-primary align-self-start"><c:out value="${order.status.label}"/></span></div>
        <p class="text-muted">Ngày đặt: <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/> • Thanh toán COD khi nhận hàng</p>
        <p>Người nhận: <c:out value="${order.recipient}"/> • <c:out value="${order.phone}"/><br>Địa chỉ: <c:out value="${order.address}"/></p>
        <c:if test="${not empty order.note}"><p>Ghi chú: <c:out value="${order.note}"/></p></c:if>
        <div class="table-responsive"><table class="table"><thead><tr><th>Sản phẩm</th><th>Đơn giá</th><th>Số lượng</th><th>Thành tiền</th></tr></thead><tbody>
            <c:forEach var="item" items="${order.items}"><tr><td><c:out value="${item.name}"/></td><td><fmt:formatNumber value="${item.price}" maxFractionDigits="0"/> ₫</td><td>${item.quantity}</td><td><fmt:formatNumber value="${item.subtotal}" maxFractionDigits="0"/> ₫</td></tr></c:forEach>
        </tbody></table></div>
        <p class="fw-bold mb-0">Tổng cộng: <fmt:formatNumber value="${order.total}" maxFractionDigits="0"/> ₫</p>
    </div></article></c:forEach>
    <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/products">Mua hàng</a>
</div></body></html>
