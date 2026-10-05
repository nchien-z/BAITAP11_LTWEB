<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi"><head><title>Khóa học - VideoHub</title></head><body>
<fmt:setLocale value="vi_VN"/>
<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4"><h1>Khóa học</h1><a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/cart">Giỏ hàng</a></div>
    <p>Mỗi suất khóa học có một mã kích hoạt. Phiếu mã được giao theo địa chỉ trong đơn COD; nhận phiếu rồi <a href="${pageContext.request.contextPath}/activate">nhập mã</a> để mở video private. Video public xem miễn phí.</p>
    <c:if test="${not empty message}"><div class="alert alert-info"><c:out value="${message}"/></div></c:if>
    <div class="row g-4">
        <c:forEach var="product" items="${products}">
            <div class="col-md-6 col-lg-4"><div class="card h-100 shadow-sm"><div class="card-body">
                <h2 class="h5"><c:out value="${product.name}"/></h2>
                <p><c:out value="${product.description}"/></p>
                <p class="fw-bold text-primary"><fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0"/> ₫</p>
                <p>Còn ${product.stock} suất • Tối đa 99 suất/đơn</p>
                <c:forEach var="lesson" items="${courseVideos[product.id]}"><p class="small"><a href="${pageContext.request.contextPath}/video/detail?id=${lesson.id}"><c:out value="${lesson.title}"/></a> <span class="badge ${lesson.privateVideo ? 'bg-warning text-dark' : 'bg-success'}">${lesson.privateVideo ? 'Private' : 'Public'}</span></p></c:forEach>
                <c:choose><c:when test="${product.stock > 0}">
                    <form method="post" action="${pageContext.request.contextPath}/cart" class="d-flex gap-2">
                        <input type="hidden" name="csrf" value="${sessionScope.shoppingCsrf}">
                        <input type="hidden" name="action" value="add"><input type="hidden" name="productId" value="${product.id}">
                        <input aria-label="Số lượng" class="form-control" style="max-width:90px" type="number" name="quantity" min="1" max="${product.stock < 99 ? product.stock : 99}" value="1" required>
                        <button class="btn btn-primary" type="submit">Thêm vào giỏ</button>
                    </form>
                </c:when><c:otherwise><span class="badge bg-secondary">Hết hàng</span></c:otherwise></c:choose>
            </div></div></div>
        </c:forEach>
    </div>
    <c:if test="${empty products}"><p>Chưa có sản phẩm đang bán.</p></c:if>
</div></body></html>
