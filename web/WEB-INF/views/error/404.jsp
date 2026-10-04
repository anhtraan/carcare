<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="title" value="404 - Không Tìm Thấy Trang | CareCar" />
</jsp:include>

<div class="container" style="max-width: 600px; padding: 6rem 1.5rem; text-align: center;">
    <div class="card" style="padding: 3rem 2rem;">
        <div style="font-size: 4rem; font-weight: 900; color: var(--accent); line-height: 1; margin-bottom: 1rem;">404</div>
        <h2 style="font-size: 1.5rem; font-weight: 800; margin-bottom: 0.75rem;">Không Tìm Thấy Trang Yêu Cầu</h2>
        <p style="color: var(--light-muted); margin-bottom: 2rem;">
            Đường dẫn bạn truy cập không tồn tại hoặc đã được di chuyển.
        </p>
        <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
            <i class="fa-solid fa-house"></i> Về Trang Chủ CareCar
        </a>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />
