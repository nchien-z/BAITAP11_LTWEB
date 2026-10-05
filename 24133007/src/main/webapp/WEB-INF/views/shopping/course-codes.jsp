<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi"><head><title>Giao mã khóa học - Quản trị</title><style>@media print { .admin-sidebar,.admin-header,.admin-footer,.no-print {display:none!important;} }</style></head><body>
<div class="container-fluid"><h1 class="h3">Phiếu giao mã khóa học COD</h1>
<p>In mã và gửi phiếu đến đúng địa chỉ nhận hàng. Sau khi giao phiếu và thu tiền COD, cập nhật đơn thành DELIVERED trong database.</p>
<button class="btn btn-primary no-print mb-3" onclick="window.print()">In phiếu giao mã</button>
<c:forEach var="shipment" items="${shipments}"><article class="card mb-3"><div class="card-body">
<h2 class="h5">Đơn #${shipment.orderId} — <c:out value="${shipment.course}"/></h2>
<p>Người nhận: <c:out value="${shipment.recipient}"/> • <c:out value="${shipment.phone}"/><br>Địa chỉ: <c:out value="${shipment.address}"/></p>
<p>Mã kích hoạt: <strong class="font-monospace"><c:out value="${shipment.code}"/></strong></p>
<p class="mb-0">Trạng thái đơn: <c:out value="${shipment.status}"/> • <c:choose><c:when test="${empty shipment.activatedBy}">Chưa kích hoạt</c:when><c:otherwise>Đã kích hoạt bởi <c:out value="${shipment.activatedBy}"/></c:otherwise></c:choose></p>
</div></article></c:forEach><c:if test="${empty shipments}"><p>Chưa có mã cần giao.</p></c:if>
</div></body></html>
