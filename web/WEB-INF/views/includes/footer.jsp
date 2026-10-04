<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
</main>
<footer class="footer">
    <div class="footer-container">
        <div>
            <div class="brand-logo" style="margin-bottom: 1rem;">
                <div class="logo-icon"><i class="fa-solid fa-screwdriver-wrench"></i></div>
                <span>CARE<span class="highlight">CAR</span></span>
            </div>
            <p style="font-size: 0.9rem; line-height: 1.6; margin-bottom: 1rem; color: #94a3b8;">
                Hệ thống xưởng dịch vụ sửa chữa, bảo dưỡng &amp; phụ tùng ô tô chính hãng công nghệ cao. Tận tâm - Minh bạch - Chuyên nghiệp.
            </p>
            <p style="font-size: 0.85rem; color: #64748b;">
                <i class="fa-solid fa-location-dot" style="color: var(--accent);"></i> Số 168 Đường Phạm Hùng, Cầu Giấy, Hà Nội<br>
                <i class="fa-solid fa-phone" style="color: var(--accent);"></i> Hotline cứu hộ &amp; Đặt lịch: <strong>1900 6868</strong>
            </p>
        </div>

        <div>
            <h4>Dịch Vụ Chính</h4>
            <ul class="footer-links">
                <li><a href="${pageContext.request.contextPath}/services">Bảo dưỡng định kỳ</a></li>
                <li><a href="${pageContext.request.contextPath}/services">Đại tu động cơ - Hộp số</a></li>
                <li><a href="${pageContext.request.contextPath}/services">Cân chỉnh thước lái 3D</a></li>
                <li><a href="${pageContext.request.contextPath}/services">Điện - Điều hòa ô tô</a></li>
                <li><a href="${pageContext.request.contextPath}/services">Đồng sơn &amp; Phủ bóng Ceramic</a></li>
            </ul>
        </div>

        <div>
            <h4>Khách Hàng</h4>
            <ul class="footer-links">
                <li><a href="${pageContext.request.contextPath}/booking">Đặt hẹn trực tuyến</a></li>
                <li><a href="${pageContext.request.contextPath}/track">Tra cứu tiến độ sửa chữa</a></li>
                <li><a href="${pageContext.request.contextPath}/login">Cổng thông tin chủ xe</a></li>
                <li><a href="${pageContext.request.contextPath}/register">Đăng ký thành viên</a></li>
            </ul>
        </div>

        <div>
            <h4>Giờ Làm Việc</h4>
            <p style="font-size: 0.9rem; margin-bottom: 0.5rem; color: #e2e8f0;">
                <i class="fa-regular fa-clock" style="color: var(--accent);"></i> Thứ 2 - Thứ 7: 07:30 - 18:00
            </p>
            <p style="font-size: 0.9rem; margin-bottom: 1rem; color: #e2e8f0;">
                <i class="fa-regular fa-clock" style="color: var(--accent);"></i> Chủ Nhật: 08:00 - 16:30
            </p>
            <div style="background: rgba(255,255,255,0.05); padding: 0.75rem; border-radius: 8px; border: 1px solid rgba(255,255,255,0.1);">
                <span style="font-size: 0.8rem; color: var(--accent); font-weight: 600;">CỨU HỘ 24/7 TOÀN QUỐC</span>
                <p style="font-size: 1.1rem; font-weight: 800; color: #fff; margin-top: 0.2rem;">0909.888.999</p>
            </div>
        </div>
    </div>

    <div class="footer-bottom">
        <p>&copy; 2026 CareCar Garage Auto Service. Xây dựng trên nền tảng Java Jakarta EE &amp; SQL Server 2019.</p>
    </div>
</footer>

<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
