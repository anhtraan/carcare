<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="title" value="CareCar - Hệ Thống Dịch Vụ &amp; Sửa Chữa Ô Tô Toàn Diện" />
</jsp:include>

<!-- Hero Section -->
<section class="hero-section">
    <div class="hero-container">
        <div>
            <div class="hero-tag">
                <i class="fa-solid fa-certificate"></i> XƯỞNG DỊCH VỤ Ô TÔ TIÊU CHUẨN 5 SAO
            </div>
            <h1 class="hero-title">
                Chăm Sóc &amp; Sửa Chữa Ô Tô <span class="gradient-text">Chuyên Nghiệp</span>
            </h1>
            <p class="hero-desc">
                Trang thiết bị chẩn đoán hiện đại chuẩn quốc tế, phụ tùng chính hãng 100%, quy trình bảo dưỡng minh bạch với báo cáo ảnh và theo dõi tiến độ trực tuyến theo thời gian thực.
            </p>
            <div class="hero-btns">
                <a href="${pageContext.request.contextPath}/booking" class="btn btn-lg btn-accent">
                    <i class="fa-regular fa-calendar-check"></i> Đặt Lịch Bảo Dưỡng Ngay
                </a>
                <a href="${pageContext.request.contextPath}/services" class="btn btn-lg btn-outline-light">
                    <i class="fa-solid fa-list-check"></i> Xem Bảng Giá
                </a>
            </div>
        </div>

        <div>
            <div class="hero-card">
                <div style="display: flex; align-items: center; gap: 0.75rem; margin-bottom: 1.25rem;">
                    <div style="background: var(--accent); color: #000; width: 36px; height: 36px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 1.1rem; font-weight: bold;">
                        <i class="fa-solid fa-car-tunnel"></i>
                    </div>
                    <div>
                        <h3 style="margin-bottom: 0; font-size: 1.15rem;">Tra Cứu Tiến Độ Sửa Chữa</h3>
                        <p style="font-size: 0.8rem; color: #94a3b8;">Nhập biển số xe hoặc mã lệnh để kiểm tra</p>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/track" method="GET">
                    <div class="quick-track-box">
                        <input type="text" name="q" placeholder="Ví dụ: 30H-888.99 hoặc CC-2026-0001" required>
                        <button type="submit" class="btn btn-primary">
                            <i class="fa-solid fa-magnifying-glass"></i> Tra cứu
                        </button>
                    </div>
                </form>

                <div style="margin-top: 1.5rem; display: flex; gap: 1rem; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 1.25rem;">
                    <div style="display: flex; align-items: center; gap: 0.5rem; font-size: 0.825rem; color: #cbd5e1;">
                        <i class="fa-solid fa-shield-halved" style="color: var(--success);"></i> Bảo hành phụ tùng 12T
                    </div>
                    <div style="display: flex; align-items: center; gap: 0.5rem; font-size: 0.825rem; color: #cbd5e1;">
                        <i class="fa-solid fa-camera" style="color: var(--info);"></i> Báo cáo ảnh thực tế
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Highlights & Advantages -->
<section class="container" style="padding-top: 4rem;">
    <div style="text-align: center; max-width: 700px; margin: 0 auto 3rem;">
        <h2 style="font-size: 2.25rem; font-weight: 800; letter-spacing: -0.5px; margin-bottom: 0.75rem;">
            Tại Sao Chủ Xe Chọn CareCar?
        </h2>
        <p style="color: var(--light-muted); font-size: 1.05rem;">
            Được trang bị hệ thống cân chỉnh 3D Hunter Mỹ, máy quét lỗi Autel MaxiSys và đội ngũ kỹ thuật viên hơn 10 năm kinh nghiệm.
        </p>
    </div>

    <div class="grid-4">
        <div class="card" style="text-align: center;">
            <div style="width: 60px; height: 60px; border-radius: 50%; background: #eff6ff; color: var(--primary); display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin: 0 auto 1.25rem;">
                <i class="fa-solid fa-microchip"></i>
            </div>
            <h3 class="card-title" style="font-size: 1.1rem;">Chẩn Đoán Chuẩn Hãng</h3>
            <p style="font-size: 0.875rem; color: var(--light-muted);">
                Máy quét chuyên sâu đọc chính xác mọi mã lỗi ECU, ABS, ESP, túi khí của mọi hãng xe.
            </p>
        </div>

        <div class="card" style="text-align: center;">
            <div style="width: 60px; height: 60px; border-radius: 50%; background: #fef3c7; color: var(--accent); display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin: 0 auto 1.25rem;">
                <i class="fa-solid fa-box-open"></i>
            </div>
            <h3 class="card-title" style="font-size: 1.1rem;">Phụ Tùng Chính Hãng</h3>
            <p style="font-size: 0.875rem; color: var(--light-muted);">
                100% linh kiện có nguồn gốc Bosch, Denso, Mobil1 rõ ràng kèm tem bảo hành điện tử.
            </p>
        </div>

        <div class="card" style="text-align: center;">
            <div style="width: 60px; height: 60px; border-radius: 50%; background: #dcfce7; color: var(--success); display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin: 0 auto 1.25rem;">
                <i class="fa-solid fa-hand-holding-dollar"></i>
            </div>
            <h3 class="card-title" style="font-size: 1.1rem;">Báo Giá Minh Bạch</h3>
            <p style="font-size: 0.875rem; color: var(--light-muted);">
                Khách hàng duyệt giá dịch vụ và phụ tùng trước khi kỹ thuật viên tiến hành thi công.
            </p>
        </div>

        <div class="card" style="text-align: center;">
            <div style="width: 60px; height: 60px; border-radius: 50%; background: #f3e8ff; color: #9333ea; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin: 0 auto 1.25rem;">
                <i class="fa-solid fa-truck-pickup"></i>
            </div>
            <h3 class="card-title" style="font-size: 1.1rem;">Cứu Hộ Giao Nhận Xe</h3>
            <p style="font-size: 0.875rem; color: var(--light-muted);">
                Hỗ trợ kéo xe tận nơi 24/7 và giao nhận xe tại nhà miễn phí trong bán kính 10km.
            </p>
        </div>
    </div>
</section>

<!-- Featured Services -->
<section style="background: #ffffff; padding: 4.5rem 1.5rem; border-top: 1px solid var(--light-border); border-bottom: 1px solid var(--light-border); margin-top: 3rem;">
    <div class="container" style="padding: 0;">
        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 2.5rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <span class="badge badge-primary" style="margin-bottom: 0.5rem;">DANH MỤC DỊCH VỤ TIÊU BIỂU</span>
                <h2 style="font-size: 2.25rem; font-weight: 800; letter-spacing: -0.5px;">Bảo Dưỡng &amp; Sửa Chữa Chuyên Sâu</h2>
            </div>
            <a href="${pageContext.request.contextPath}/services" class="btn btn-secondary">
                Xem toàn bộ dịch vụ <i class="fa-solid fa-arrow-right"></i>
            </a>
        </div>

        <div class="grid-3">
            <c:forEach items="${popularServices}" var="svc">
                <div class="card" style="display: flex; flex-direction: column; justify-content: space-between;">
                    <div>
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.75rem;">
                            <span class="badge badge-info">${svc.category}</span>
                            <span style="font-size: 0.8rem; color: var(--light-muted);"><i class="fa-regular fa-clock"></i> ~${svc.estimatedDuration} phút</span>
                        </div>
                        <h3 class="card-title" style="font-size: 1.15rem; margin-bottom: 0.5rem;">${svc.serviceName}</h3>
                        <p style="font-size: 0.875rem; color: var(--light-muted); margin-bottom: 1.25rem; line-height: 1.5;">
                            ${svc.description}
                        </p>
                    </div>

                    <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid var(--light-border); padding-top: 1rem; margin-top: 1rem;">
                        <div>
                            <span style="font-size: 0.75rem; color: var(--light-muted); display: block;">Tiền công:</span>
                            <span style="font-size: 1.2rem; font-weight: 800; color: var(--primary);">
                                <fmt:formatNumber value="${svc.laborCost}" pattern="#,###" /> ₫
                            </span>
                        </div>
                        <a href="${pageContext.request.contextPath}/booking?serviceId=${svc.serviceId}" class="btn btn-sm btn-primary">
                            Đặt hẹn
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<!-- Call To Action -->
<section class="container" style="padding: 4rem 1.5rem;">
    <div style="background: linear-gradient(135deg, #0f172a, #1e293b); border-radius: var(--radius-lg); padding: 3.5rem 2.5rem; color: #fff; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 2rem; border: 1px solid rgba(255,255,255,0.1);">
        <div style="max-width: 650px;">
            <h2 style="font-size: 2.2rem; font-weight: 900; margin-bottom: 0.75rem;">Xe Của Bạn Cần Được Kiểm Tra &amp; Chăm Sóc?</h2>
            <p style="font-size: 1.05rem; color: #cbd5e1; line-height: 1.6;">
                Đặt hẹn trước để được tiếp nhận ngay không cần chờ đợi, nhận ngay ưu đãi <strong>giảm 10% tiền công</strong> và kiểm tra miễn phí 20 hạng mục an toàn.
            </p>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/booking" class="btn btn-lg btn-accent" style="font-size: 1.1rem; padding: 1rem 2rem;">
                <i class="fa-solid fa-calendar-check"></i> Đặt Lịch Bảo Dưỡng Ngay
            </a>
        </div>
    </div>
</section>

<jsp:include page="includes/footer.jsp" />
