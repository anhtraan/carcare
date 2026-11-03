<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
</main>

<!-- Urgent Rescue Section -->
<section class="py-4 bg-warning">
    <div class="container">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div class="d-flex align-items-center gap-3 text-dark">
                <div class="fs-1"><i class="fa-solid fa-truck-pickup"></i></div>
                <div>
                    <h4 class="mb-0 fw-bold">CẦN CỨU HỘ KHẨN CẤP HOẶC TƯ VẤN KỸ THUẬT?</h4>
                    <p class="mb-0">Đội cứu hộ lưu động CareCar sẵn sàng phục vụ 24/7 kể cả ngày lễ tết, có mặt sau 15-30 phút.</p>
                </div>
            </div>
            <a href="tel:19006868" class="btn btn-dark btn-lg fw-bold px-4 shadow">
                <i class="fa-solid fa-phone-volume me-2"></i> HOTLINE: 1900 6868
            </a>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="bg-dark text-white pt-5 pb-3">
    <div class="container">
        <div class="row g-4 mb-4">
            <div class="col-lg-4">
                <a class="d-flex align-items-center gap-2 fw-bold text-white text-decoration-none mb-3" href="${pageContext.request.contextPath}/home">
                    <div class="logo-icon bg-white rounded-2 d-flex align-items-center justify-content-center shadow-sm" style="width: 36px; height: 36px; padding: 3px;">
                        <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="CareCar Logo" style="width: 100%; height: 100%; object-fit: contain;">
                    </div>
                    <span class="fs-4">CARE<span class="text-warning">CAR</span></span>
                </a>
                <p class="text-secondary small">
                    Hệ thống xưởng dịch vụ sửa chữa, bảo dưỡng &amp; phụ tùng ô tô chính hãng công nghệ cao. Tận tâm - Minh bạch - Chuyên nghiệp tiêu chuẩn 5 sao.
                </p>
                <p class="text-secondary small mb-1">
                    <i class="fa-solid fa-location-dot text-warning me-2"></i> <strong>Chi nhánh 1:</strong> Số 168 Đường Phạm Hùng, Cầu Giấy, Hà Nội
                </p>
                <p class="text-secondary small mb-1">
                    <i class="fa-solid fa-location-dot text-warning me-2"></i> <strong>Chi nhánh 2:</strong> Số 88 Đường Lê Đức Thọ, Nam Từ Liêm, Hà Nội
                </p>
                <p class="text-secondary small">
                    <i class="fa-solid fa-phone text-warning me-2"></i> Tổng đài đặt lịch: <strong>1900 6868</strong>
                </p>
            </div>
            <div class="col-6 col-lg-2">
                <h6 class="fw-bold text-light mb-3">Dịch Vụ Chính</h6>
                <ul class="list-unstyled small text-secondary">
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/services" class="text-secondary text-decoration-none hover-light">Bảo dưỡng định kỳ</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/services" class="text-secondary text-decoration-none hover-light">Cân chỉnh 3D Hunter</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/services" class="text-secondary text-decoration-none hover-light">Đại tu động cơ &amp; số</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/services" class="text-secondary text-decoration-none hover-light">Điện &amp; Điều hòa</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/services" class="text-secondary text-decoration-none hover-light">Sơn sấy cao cấp</a></li>
                </ul>
            </div>
            <div class="col-6 col-lg-2">
                <h6 class="fw-bold text-light mb-3">Chủ Xe</h6>
                <ul class="list-unstyled small text-secondary">
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/booking" class="text-secondary text-decoration-none hover-light">Đặt hẹn trực tuyến</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/track" class="text-secondary text-decoration-none hover-light">Tra cứu tiến độ xe</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/login" class="text-secondary text-decoration-none hover-light">Cổng chủ xe</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/register" class="text-secondary text-decoration-none hover-light">Đăng ký thành viên</a></li>
                </ul>
            </div>
            <div class="col-lg-4">
                <h6 class="fw-bold text-light mb-3">Giờ Hoạt Động &amp; Hệ Thống</h6>
                <p class="text-secondary small mb-1"><i class="fa-regular fa-clock text-warning me-2"></i> Thứ 2 - Thứ 7: <strong>07:30 - 18:00</strong></p>
                <p class="text-secondary small mb-3"><i class="fa-regular fa-clock text-warning me-2"></i> Chủ Nhật: <strong>08:00 - 16:30</strong></p>
                <div class="p-3 rounded-3 bg-secondary bg-opacity-25 border border-secondary text-light small">
                    <strong class="text-warning d-block mb-1"><i class="fa-solid fa-server me-1"></i> HỆ THỐNG ĐIỀU HÀNH:</strong>
                    Tomcat 10.1 (Jakarta EE) | SQL Server 2019 | Cổng 14333
                </div>
            </div>
        </div>
    </div>
</footer>

<!-- Floating Action Center -->
<div class="floating-actions">
    <!-- Back to top button -->
    <button class="float-btn float-btn-scroll" id="btnScrollTop" title="Cuộn lên đầu trang">
        <i class="fa-solid fa-arrow-up"></i>
    </button>
    <!-- Hotline urgent button -->
    <a href="tel:19006868" class="float-btn float-btn-hotline" title="Gọi cứu hộ khẩn cấp 1900 6868">
        <i class="fa-solid fa-phone"></i>
    </a>
</div>

<!-- Bootstrap 5 Bundle JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
<!-- Background Hero Slider Scripts -->
<script src="${pageContext.request.contextPath}/assets/js/hero-slider-config.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/hero-slider.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
