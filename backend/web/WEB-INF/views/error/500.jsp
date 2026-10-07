<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="title" value="500 - Lỗi Máy Chủ | CareCar" />
</jsp:include>

<div class="container" style="max-width: 600px; padding: 6rem 1.5rem; text-align: center;">
    <div class="card" style="padding: 3rem 2rem;">
        <div style="font-size: 4rem; font-weight: 900; color: var(--danger); line-height: 1; margin-bottom: 1rem;">500</div>
        <h2 style="font-size: 1.5rem; font-weight: 800; margin-bottom: 0.75rem;">Hệ Thống Đang Xử Lý</h2>
        <p style="color: var(--light-muted); margin-bottom: 1.5rem;">
            Đã xảy ra lỗi nội bộ trong quá trình xử lý yêu cầu hoặc chưa kết nối được cơ sở dữ liệu SQL Server.
        </p>
        <div style="font-size: 0.85rem; color: #64748b; background: #f8fafc; padding: 0.75rem; border-radius: 6px; margin-bottom: 1.5rem; word-break: break-all;">
            <%= exception != null ? exception.getMessage() : "Vui lòng kiểm tra file DBContext.java và đảm bảo SQL Server 2019 đang hoạt động." %>
        </div>
        <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
            <i class="fa-solid fa-rotate-right"></i> Thử Lại Trang Chủ
        </a>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />
