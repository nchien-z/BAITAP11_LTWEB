<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi"><head><title>Khóa học của tôi - VideoHub</title></head><body>
<div class="container"><div class="d-flex justify-content-between mb-4"><h1>Khóa học của tôi</h1><a class="btn btn-primary align-self-center" href="${pageContext.request.contextPath}/activate">Nhập mã kích hoạt</a></div>
<c:if test="${not empty message}"><div class="alert alert-success"><c:out value="${message}"/></div></c:if>
<c:if test="${empty courses}"><div class="alert alert-light">Bạn chưa kích hoạt khóa học nào. Video public vẫn có thể xem miễn phí.</div></c:if>
<c:forEach var="course" items="${courses}"><article class="card mb-4"><div class="card-body"><h2 class="h5"><c:out value="${course.name}"/></h2>
<c:forEach var="lesson" items="${course.lessons}"><p><a href="${pageContext.request.contextPath}/video/detail?id=${lesson.id}"><c:out value="${lesson.title}"/></a> <span class="badge ${lesson.privateVideo ? 'bg-warning text-dark' : 'bg-success'}">${lesson.privateVideo ? 'Private • Đã mở khóa' : 'Public'}</span></p></c:forEach>
<c:if test="${empty course.lessons}"><p class="text-muted">Khóa học chưa có bài học được hiển thị.</p></c:if>
</div></article></c:forEach></div></body></html>
