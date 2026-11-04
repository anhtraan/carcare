<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="title" value="403 - Truy Cập Bị Từ Chối | CareCar" />
</jsp:include>

<div class="container" style="max-width: 600px; padding: 6rem 1.5rem; text-align: center;">
    <div class="card" style="padding: 3rem 2rem;">
        <div style="font-size: 4rem; font-weight: 900; color: var(--danger); line-height: 1; margin-bottom: 1rem;">
            <i class="fa-solid fa-shield-halved"></i> 403
        </div>
        <h2 style="font-size: 1.5rem; font-weight: 800; margin-bottom: 0.75rem;">Yêu Cầu Bị Từ Chối (Forbidden)</h2>
        <p style="color: var(--light-muted); margin-bottom: 2rem;">
            Phiên làm việc hoặc CSRF Token không hợp lệ / đã hết hạn. Vui lòng tải lại trang và thử lại thao tác.
        </p>
        <div style="display: flex; gap: 1rem; justify-content: center;">
            <a href="javascript:history.back()" class="btn btn-secondary">
                <i class="fa-solid fa-arrow-left"></i> Quay Lại
            </a>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
                <i class="fa-solid fa-house"></i> Về Trang Chủ
            </a>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />

