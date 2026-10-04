<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="title" value="Đặt Lịch Thành Công - CareCar" />
</jsp:include>

<div class="container" style="max-width: 700px; padding: 5rem 1.5rem; text-align: center;">
    <div class="card" style="padding: 3rem 2rem;">
        <div style="width: 80px; height: 80px; border-radius: 50%; background: #dcfce7; color: var(--success); display: flex; align-items: center; justify-content: center; font-size: 2.5rem; margin: 0 auto 1.5rem;">
            <i class="fa-solid fa-circle-check"></i>
        </div>

        <h1 style="font-size: 2rem; font-weight: 800; margin-bottom: 0.75rem;">Đặt Lịch Hẹn Thành Công!</h1>
        <p style="color: var(--light-muted); font-size: 1.05rem; line-height: 1.6; margin-bottom: 2rem;">
            Cảm ơn bạn đã tin tưởng dịch vụ của CareCar. Cố vấn dịch vụ của chúng tôi sẽ liên hệ qua số điện thoại để xác nhận thông tin chi tiết trong vòng 15 phút.
        </p>

        <div style="display: flex; justify-content: center; gap: 1rem; flex-wrap: wrap;">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">
                <i class="fa-solid fa-house"></i> Về Trang Chủ
            </a>
            <a href="${pageContext.request.contextPath}/track" class="btn btn-primary">
                <i class="fa-solid fa-magnifying-glass-location"></i> Tra Cứu Tiến Độ
            </a>
        </div>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
