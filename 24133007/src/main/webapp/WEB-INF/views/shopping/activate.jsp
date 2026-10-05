<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi"><head><title>Kích hoạt khóa học - VideoHub</title></head><body>
<div class="container" style="max-width:760px"><h1>Kích hoạt khóa học</h1>
<p>Nhập mã trên phiếu được giao đến địa chỉ trong đơn COD. Mỗi mã dùng một lần cho tài khoản đang đăng nhập, sau khi đơn đã giao và thu tiền.</p>
<c:if test="${not empty error}"><div class="alert alert-danger" role="alert"><c:out value="${error}"/></div></c:if>
<form method="post" action="${pageContext.request.contextPath}/activate">
    <input type="hidden" name="csrf" value="${sessionScope.shoppingCsrf}">
    <label class="form-label" for="code">Mã kích hoạt</label><input class="form-control mb-3 font-monospace" id="code" name="code" maxlength="36" placeholder="XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX" required autocomplete="off">
    <button class="btn btn-primary">Kích hoạt</button><a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/my-courses">Khóa học của tôi</a>
</form></div></body></html>
