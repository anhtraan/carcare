<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="title" value="CareCar - Hệ Thống Dịch Vụ &amp; Sửa Chữa Ô Tô Tiêu Chuẩn 5 Sao" />
</jsp:include>

<!-- ==========================================
     HERO SECTION (HyperAuto Care Framer Style)
     ========================================== -->
<section class="hyper-hero-section" id="hero">
    <!-- Background Gradient & Ambient Glows -->
    <div class="hyper-hero-glow glow-1"></div>
    <div class="hyper-hero-glow glow-2"></div>

    <div class="container-xl py-4 py-lg-5 position-relative z-2">
        <div class="row align-items-center g-4 g-lg-5 mb-4 mb-lg-5">
            <!-- Left Headline & CTA Column -->
            <div class="col-lg-7">
                <!-- Trust Badge (HyperAuto Style) -->
                <div class="hyper-trust-badge mb-3">
                    <div class="trust-stars">
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                    </div>
                    <span class="trust-score">4.9/5</span>
                    <span class="trust-separator">&bull;</span>
                    <span class="trust-reviews">1,550+ Đánh Giá Chủ Xe Thực Tế</span>
                </div>

                <!-- Display Title (Barlow Condensed Automotive Style) -->
                <h1 class="hyper-hero-title mb-3">
                    CHĂM SÓC &amp; SỬA CHỮA Ô&nbsp;TÔ <br>
                    <span class="text-orange-gradient">MINH BẠCH SỐ HÓA &bull; TIÊU&nbsp;CHUẨN&nbsp;5&nbsp;SAO</span>
                </h1>

                <!-- Subtitle -->
                <p class="hyper-hero-desc mb-4">
                    Hệ thống quản lý dịch vụ ô tô số hóa toàn diện: Báo cáo ảnh &amp; video phụ tùng trực tiếp qua hệ thống, kiểm tra 35 điểm an toàn, 100% phụ tùng chính hãng có QR truy xuất và bảo hành điện tử lên đến 24 tháng.
                </p>

                <!-- Dual Action Buttons -->
                <div class="d-flex flex-wrap gap-3">
                    <a href="${pageContext.request.contextPath}/booking" class="btn btn-hyper-orange btn-lg">
                        <span>ĐẶT LỊCH HẸN NGAY</span>
                        <i class="fa-solid fa-arrow-right ms-2"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/services" class="btn btn-hyper-outline btn-lg">
                        <i class="fa-solid fa-list-check me-2 text-orange"></i>
                        <span>KHÁM PHÁ BẢNG GIÁ</span>
                    </a>
                </div>
            </div>

            <!-- Right Interactive Quick Action Widget (PRJ Live Tracking Card) -->
            <div class="col-lg-5">
                <div class="hyper-card hyper-widget p-4 p-md-5">
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <div class="hyper-widget-icon">
                            <i class="fa-solid fa-car-tunnel"></i>
                        </div>
                        <div>
                            <h4 class="hyper-widget-title mb-0">Kiểm Tra Tiến Độ Trực Tuyến</h4>
                            <p class="hyper-widget-subtitle mb-0">Xem ảnh chụp thực tế từng công đoạn sửa xe</p>
                        </div>
                    </div>

                    <form action="${pageContext.request.contextPath}/track" method="GET">
                        <div class="mb-3">
                            <label for="quickTrackInput" class="form-label hyper-label">Biển số xe hoặc Mã biên nhận</label>
                            <div class="input-group input-group-lg hyper-input-group">
                                <span class="input-group-text"><i class="fa-solid fa-hashtag text-orange"></i></span>
                                <input type="text" id="quickTrackInput" name="q" class="form-control" placeholder="Ví dụ: 30H-888.99 hoặc CC-2026-0001" required>
                            </div>
                            <div class="form-text hyper-form-hint">Nhập biển số để xem tình trạng sửa chữa tức thì</div>
                        </div>
                        <button type="submit" class="btn btn-hyper-orange w-100 btn-lg">
                            <i class="fa-solid fa-magnifying-glass me-2"></i> TRA CỨU TIẾN ĐỘ NGAY
                        </button>
                    </form>

                    <div class="mt-4 pt-3 hyper-widget-footer d-flex justify-content-between align-items-center">
                        <span><i class="fa-solid fa-shield-halved text-success me-1"></i> Bảo hành phụ tùng 12-24T</span>
                        <span><i class="fa-solid fa-camera text-info me-1"></i> Báo cáo ảnh 100%</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Trust Highlights Grid (HyperAuto 4 Value Highlights) -->
        <div class="row g-3 g-lg-4 pt-2">
            <div class="col-6 col-lg-3">
                <div class="hyper-stat-box h-100">
                    <div class="hyper-stat-number text-orange">15+ NĂM</div>
                    <div class="hyper-stat-label">Kỹ Thuật Viên Lành Nghề</div>
                    <div class="hyper-stat-sub">Thợ cả giàu kinh nghiệm thực tế</div>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="hyper-stat-box h-100">
                    <div class="hyper-stat-number text-white">HUNTER 3D</div>
                    <div class="hyper-stat-label">Thiết Bị Cân Chỉnh Mỹ</div>
                    <div class="hyper-stat-sub">Đo góc đặt bánh xe chuẩn xác</div>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="hyper-stat-box h-100">
                    <div class="hyper-stat-number text-orange">100%</div>
                    <div class="hyper-stat-label">Phụ Tùng Chính Hãng</div>
                    <div class="hyper-stat-sub">Mã QR truy xuất &amp; bảo hành điện tử</div>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="hyper-stat-box h-100">
                    <div class="hyper-stat-number text-white">25K+</div>
                    <div class="hyper-stat-label">Lượt Xe Phục Vụ</div>
                    <div class="hyper-stat-sub">99.6% hài lòng đánh giá 5 sao</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ==========================================
     BRAND MARQUEE TICKER (DÒNG XE CHUYÊN SÂU)
     ========================================== -->
<section class="brand-ticker-section">
    <div class="container-fluid px-0">
        <div class="brand-ticker-track">
            <!-- Brand Items Set 1 -->
            <div class="brand-ticker-item"><img src="${pageContext.request.contextPath}/assets/images/brands/mercedes.svg" alt="Mercedes-Benz" class="brand-icon-img" /> <span>MERCEDES-BENZ</span></div>
            <div class="brand-ticker-item"><img src="${pageContext.request.contextPath}/assets/images/brands/bmw.svg" alt="BMW" class="brand-icon-img" /> <span>BMW</span></div>
            <div class="brand-ticker-item"><img src="${pageContext.request.contextPath}/assets/images/brands/porsche.svg" alt="Porsche" class="brand-icon-img" /> <span>PORSCHE</span></div>
            <div class="brand-ticker-item"><img src="${pageContext.request.contextPath}/assets/images/brands/audi.svg" alt="Audi" class="brand-icon-img" /> <span>AUDI</span></div>
            <div class="brand-ticker-item"><img src="${pageContext.request.contextPath}/assets/images/brands/lexus.svg" alt="Lexus" class="brand-icon-img" /> <span>LEXUS</span></div>
            <div class="brand-ticker-item"><img src="${pageContext.request.contextPath}/assets/images/brands/toyota.svg" alt="Toyota" class="brand-icon-img" /> <span>TOYOTA</span></div>
            <div class="brand-ticker-item"><img src="${pageContext.request.contextPath}/assets/images/brands/honda.svg" alt="Honda" class="brand-icon-img" /> <span>HONDA</span></div>
            <div class="brand-ticker-item"><img src="${pageContext.request.contextPath}/assets/images/brands/mazda.svg" alt="Mazda" class="brand-icon-img" /> <span>MAZDA</span></div>
            <div class="brand-ticker-item"><img src="${pageContext.request.contextPath}/assets/images/brands/hyundai.svg" alt="Hyundai" class="brand-icon-img" /> <span>HYUNDAI</span></div>
            <div class="brand-ticker-item"><img src="${pageContext.request.contextPath}/assets/images/brands/kia.svg" alt="Kia" class="brand-icon-img" /> <span>KIA</span></div>
            <div class="brand-ticker-item"><img src="${pageContext.request.contextPath}/assets/images/brands/ford.svg" alt="Ford" class="brand-icon-img" /> <span>FORD</span></div>
            <div class="brand-ticker-item"><img src="${pageContext.request.contextPath}/assets/images/brands/vinfast.svg" alt="VinFast" class="brand-icon-img" /> <span>VINFAST</span></div>
            <!-- Duplicate for Seamless Scroll Loop -->
            <div class="brand-ticker-item"><img src="${pageContext.request.contextPath}/assets/images/brands/mercedes.svg" alt="Mercedes-Benz" class="brand-icon-img" /> <span>MERCEDES-BENZ</span></div>
            <div class="brand-ticker-item"><img src="${pageContext.request.contextPath}/assets/images/brands/bmw.svg" alt="BMW" class="brand-icon-img" /> <span>BMW</span></div>
            <div class="brand-ticker-item"><img src="${pageContext.request.contextPath}/assets/images/brands/porsche.svg" alt="Porsche" class="brand-icon-img" /> <span>PORSCHE</span></div>
            <div class="brand-ticker-item"><img src="${pageContext.request.contextPath}/assets/images/brands/audi.svg" alt="Audi" class="brand-icon-img" /> <span>AUDI</span></div>
            <div class="brand-ticker-item"><img src="${pageContext.request.contextPath}/assets/images/brands/lexus.svg" alt="Lexus" class="brand-icon-img" /> <span>LEXUS</span></div>
            <div class="brand-ticker-item"><img src="${pageContext.request.contextPath}/assets/images/brands/toyota.svg" alt="Toyota" class="brand-icon-img" /> <span>TOYOTA</span></div>
            <div class="brand-ticker-item"><img src="${pageContext.request.contextPath}/assets/images/brands/honda.svg" alt="Honda" class="brand-icon-img" /> <span>HONDA</span></div>
            <div class="brand-ticker-item"><img src="${pageContext.request.contextPath}/assets/images/brands/mazda.svg" alt="Mazda" class="brand-icon-img" /> <span>MAZDA</span></div>
            <div class="brand-ticker-item"><img src="${pageContext.request.contextPath}/assets/images/brands/hyundai.svg" alt="Hyundai" class="brand-icon-img" /> <span>HYUNDAI</span></div>
            <div class="brand-ticker-item"><img src="${pageContext.request.contextPath}/assets/images/brands/kia.svg" alt="Kia" class="brand-icon-img" /> <span>KIA</span></div>
            <div class="brand-ticker-item"><img src="${pageContext.request.contextPath}/assets/images/brands/ford.svg" alt="Ford" class="brand-icon-img" /> <span>FORD</span></div>
            <div class="brand-ticker-item"><img src="${pageContext.request.contextPath}/assets/images/brands/vinfast.svg" alt="VinFast" class="brand-icon-img" /> <span>VINFAST</span></div>
        </div>
    </div>
</section>

<!-- ==========================================
     SERVICES GRID (HyperAuto Care Services)
     ========================================== -->
<section class="hyper-section py-5" id="services">
    <div class="container-xl py-lg-4">
        <!-- Section Header -->
        <div class="d-flex flex-wrap justify-content-between align-items-end mb-4 mb-lg-5 gap-3">
            <div>
                <div class="hyper-section-badge mb-2">DỊCH VỤ CARECAR CHUYÊN NGHIỆP</div>
                <h2 class="hyper-section-title mb-2">Dịch Vụ Sửa Chữa &amp; Chăm Sóc Hàng Đầu</h2>
                <p class="hyper-section-subtitle mb-0">Từ bảo dưỡng định kỳ đến cân chỉnh góc đặt bánh xe, đại tu động cơ và detailing cao cấp.</p>
            </div>
            <a href="${pageContext.request.contextPath}/services" class="btn btn-hyper-outline">
                <span>Xem toàn bộ bảng giá</span>
                <i class="fa-solid fa-arrow-right ms-2 text-orange"></i>
            </a>
        </div>

        <!-- Service Cards Grid -->
        <div class="row g-4">
            <c:choose>
                <c:when test="${not empty popularServices}">
                    <c:forEach items="${popularServices}" var="svc">
                        <div class="col-md-6 col-lg-4">
                            <div class="hyper-card hyper-service-card h-100 d-flex flex-column justify-content-between">
                                <div>
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <span class="hyper-pill-tag">${svc.category}</span>
                                        <span class="hyper-duration-tag"><i class="fa-regular fa-clock me-1 text-orange"></i> ~${svc.estimatedDuration} phút</span>
                                    </div>
                                    <h4 class="hyper-service-name">${svc.serviceName}</h4>
                                    <p class="hyper-service-desc">${svc.description}</p>
                                </div>
                                <div class="hyper-service-footer pt-3 mt-3 d-flex justify-content-between align-items-center">
                                    <div>
                                        <span class="hyper-price-label">Tiền công từ</span>
                                        <div class="hyper-price-value text-orange">
                                            <fmt:formatNumber value="${svc.laborCost}" pattern="#,###" /> ₫
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/services" class="btn btn-sm btn-hyper-orange-subtle">
                                        <span>Chi tiết</span> <i class="fa-solid fa-chevron-right ms-1"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <!-- Fallback 6 Services -->
                    <div class="col-md-6 col-lg-4">
                        <div class="hyper-card hyper-service-card h-100 d-flex flex-column justify-content-between">
                            <div>
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <span class="hyper-pill-tag">BẢO DƯỠNG</span>
                                    <span class="hyper-duration-tag"><i class="fa-regular fa-clock me-1 text-orange"></i> ~60 phút</span>
                                </div>
                                <h4 class="hyper-service-name">Bảo Dưỡng Định Kỳ Đa Cấp Độ</h4>
                                <p class="hyper-service-desc">Thay dầu động cơ chính hãng, lọc nhớt, vệ sinh phanh 4 bánh, kiểm tra 35 điểm an toàn và reset đèn nhắc bảo dưỡng trên taplo.</p>
                            </div>
                            <div class="hyper-service-footer pt-3 mt-3 d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="hyper-price-label">Công thợ từ</span>
                                    <div class="hyper-price-value text-orange">250.000 ₫</div>
                                </div>
                                <a href="${pageContext.request.contextPath}/services" class="btn btn-sm btn-hyper-orange-subtle">
                                    <span>Chi tiết</span> <i class="fa-solid fa-chevron-right ms-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 col-lg-4">
                        <div class="hyper-card hyper-service-card h-100 d-flex flex-column justify-content-between">
                            <div>
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <span class="hyper-pill-tag">GẦM &amp; LÁI</span>
                                    <span class="hyper-duration-tag"><i class="fa-regular fa-clock me-1 text-orange"></i> ~45 phút</span>
                                </div>
                                <h4 class="hyper-service-name">Cân Chỉnh Thước Lái 3D Hunter</h4>
                                <p class="hyper-service-desc">Cân chỉnh góc đặt bánh xe chuẩn xác tuyệt đối bằng máy cân 3D Hunter nhập khẩu Hoa Kỳ, chống mòn lốp lệch và giúp vô lăng thẳng tắp.</p>
                            </div>
                            <div class="hyper-service-footer pt-3 mt-3 d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="hyper-price-label">Trọn gói chỉ</span>
                                    <div class="hyper-price-value text-orange">500.000 ₫</div>
                                </div>
                                <a href="${pageContext.request.contextPath}/services" class="btn btn-sm btn-hyper-orange-subtle">
                                    <span>Chi tiết</span> <i class="fa-solid fa-chevron-right ms-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 col-lg-4">
                        <div class="hyper-card hyper-service-card h-100 d-flex flex-column justify-content-between">
                            <div>
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <span class="hyper-pill-tag">ĐIỆN - ĐIỀU HÒA</span>
                                    <span class="hyper-duration-tag"><i class="fa-regular fa-clock me-1 text-orange"></i> ~90 phút</span>
                                </div>
                                <h4 class="hyper-service-name">Vệ Sinh Dàn Lạnh Nội Soi</h4>
                                <p class="hyper-service-desc">Làm sạch dàn lạnh bằng camera nội soi công nghệ cao không cần tháo taplo, khử sạch 100% vi khuẩn, nấm mốc và mùi hôi ẩm.</p>
                            </div>
                            <div class="hyper-service-footer pt-3 mt-3 d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="hyper-price-label">Trọn gói chỉ</span>
                                    <div class="hyper-price-value text-orange">600.000 ₫</div>
                                </div>
                                <a href="${pageContext.request.contextPath}/services" class="btn btn-sm btn-hyper-orange-subtle">
                                    <span>Chi tiết</span> <i class="fa-solid fa-chevron-right ms-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 col-lg-4">
                        <div class="hyper-card hyper-service-card h-100 d-flex flex-column justify-content-between">
                            <div>
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <span class="hyper-pill-tag">AN TOÀN</span>
                                    <span class="hyper-duration-tag"><i class="fa-regular fa-clock me-1 text-orange"></i> ~60 phút</span>
                                </div>
                                <h4 class="hyper-service-name">Bảo Dưỡng Phanh &amp; Láng Đĩa 3D</h4>
                                <p class="hyper-service-desc">Láng đĩa phanh trực tiếp trên xe khắc phục hiện tượng rung lắc chân phanh khi đạp ở tốc độ cao, thay má phanh chính hãng.</p>
                            </div>
                            <div class="hyper-service-footer pt-3 mt-3 d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="hyper-price-label">Giá từ</span>
                                    <div class="hyper-price-value text-orange">400.000 ₫</div>
                                </div>
                                <a href="${pageContext.request.contextPath}/services" class="btn btn-sm btn-hyper-orange-subtle">
                                    <span>Chi tiết</span> <i class="fa-solid fa-chevron-right ms-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 col-lg-4">
                        <div class="hyper-card hyper-service-card h-100 d-flex flex-column justify-content-between">
                            <div>
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <span class="hyper-pill-tag">SPA - DETAILING</span>
                                    <span class="hyper-duration-tag"><i class="fa-regular fa-clock me-1 text-orange"></i> ~180 phút</span>
                                </div>
                                <h4 class="hyper-service-name">Rửa Khoang Máy Hơi Nước Nóng</h4>
                                <p class="hyper-service-desc">Vệ sinh khoang động cơ bằng hơi nước nóng áp lực cao kết hợp dung dịch bóc tách dầu mỡ nhập khẩu Đức và phủ dưỡng nano chống chuột.</p>
                            </div>
                            <div class="hyper-service-footer pt-3 mt-3 d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="hyper-price-label">Trọn gói từ</span>
                                    <div class="hyper-price-value text-orange">700.000 ₫</div>
                                </div>
                                <a href="${pageContext.request.contextPath}/services" class="btn btn-sm btn-hyper-orange-subtle">
                                    <span>Chi tiết</span> <i class="fa-solid fa-chevron-right ms-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 col-lg-4">
                        <div class="hyper-card hyper-service-card h-100 d-flex flex-column justify-content-between">
                            <div>
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <span class="hyper-pill-tag">SƠN - GÒ</span>
                                    <span class="hyper-duration-tag"><i class="fa-regular fa-clock me-1 text-orange"></i> Trong ngày</span>
                                </div>
                                <h4 class="hyper-service-name">Sơn Sấy Phòng Kín Tiêu Chuẩn</h4>
                                <p class="hyper-service-desc">Pha sơn vi tính điện tử trùng mã màu gốc 100%, sấy nhiệt hồng ngoại trong phòng kín chống bụi bám, bảo hành bề mặt sơn 2 năm.</p>
                            </div>
                            <div class="hyper-service-footer pt-3 mt-3 d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="hyper-price-label">Giá từ</span>
                                    <div class="hyper-price-value text-orange">600.000 ₫</div>
                                </div>
                                <a href="${pageContext.request.contextPath}/services" class="btn btn-sm btn-hyper-orange-subtle">
                                    <span>Chi tiết</span> <i class="fa-solid fa-chevron-right ms-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>

<!-- ==========================================
     HOW OUR SERVICE WORKS (HyperAuto Process)
     ========================================== -->
<section class="hyper-section py-5 hyper-process-bg" id="process">
    <div class="container-xl py-lg-4">
        <div class="text-center max-w-700 mx-auto mb-5">
            <div class="hyper-section-badge mb-2">QUY TRÌNH 4 BƯỚC CHUYÊN NGHIỆP</div>
            <h2 class="hyper-section-title mb-2">Quy Trình Tiếp Nhận &amp; Phục Vụ Số Hóa</h2>
            <p class="hyper-section-subtitle">Chủ xe hoàn toàn chủ động, kiểm soát chi phí và thời gian từ lúc đặt hẹn đến khi nhận lại xế cưng.</p>
        </div>

        <div class="row g-4">
            <!-- Step 1 -->
            <div class="col-md-6 col-lg-3">
                <div class="hyper-process-card h-100">
                    <div class="hyper-step-number text-orange">01</div>
                    <h4 class="hyper-step-title">Chọn Dịch Vụ &amp; Đặt Hẹn</h4>
                    <p class="hyper-step-desc">Khám phá các gói dịch vụ qua website hoặc đặt lịch hẹn online chỉ trong 30 giây để được ưu tiên cầu nâng không chờ đợi.</p>
                    <div class="hyper-step-badge"><i class="fa-solid fa-laptop text-orange me-1"></i> Đặt lịch online 24/7</div>
                </div>
            </div>

            <!-- Step 2 -->
            <div class="col-md-6 col-lg-3">
                <div class="hyper-process-card h-100">
                    <div class="hyper-step-number text-white">02</div>
                    <h4 class="hyper-step-title">Tiếp Nhận &amp; Khám 35 Điểm</h4>
                    <p class="hyper-step-desc">Đưa xe đến xưởng hoặc yêu cầu cứu hộ. Cố vấn dịch vụ chẩn đoán kỹ thuật bằng máy chuyên dụng, đo góc lái Hunter 3D.</p>
                    <div class="hyper-step-badge"><i class="fa-solid fa-clipboard-check text-success me-1"></i> Kiểm tra 35 điểm an toàn</div>
                </div>
            </div>

            <!-- Step 3 -->
            <div class="col-md-6 col-lg-3">
                <div class="hyper-process-card h-100">
                    <div class="hyper-step-number text-orange">03</div>
                    <h4 class="hyper-step-title">Báo Giá &amp; Cập Nhật Ảnh</h4>
                    <p class="hyper-step-desc">Duyệt bảng báo giá minh bạch trước khi làm. Theo dõi tiến độ sửa chữa và xem ảnh phụ tùng thực tế qua hệ thống web.</p>
                    <div class="hyper-step-badge"><i class="fa-solid fa-camera text-info me-1"></i> Báo cáo ảnh trực tuyến</div>
                </div>
            </div>

            <!-- Step 4 -->
            <div class="col-md-6 col-lg-3">
                <div class="hyper-process-card h-100">
                    <div class="hyper-step-number text-white">04</div>
                    <h4 class="hyper-step-title">Nghiệm Thu &amp; Nhận Xe</h4>
                    <p class="hyper-step-desc">Nhận thông báo khi xe hoàn tất. Kiểm tra nghiệm thu xe, thanh toán linh hoạt bằng quét mã VNPay/VietQR và nhận bảo hành điện tử.</p>
                    <div class="hyper-step-badge"><i class="fa-solid fa-shield-halved text-warning me-1"></i> Bảo hành điện tử 12-24T</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ==========================================
     SERVICE PACKAGES & PRICING (HyperAuto Pricing)
     ========================================== -->
<section class="hyper-section py-5" id="pricing">
    <div class="container-xl py-lg-4">
        <div class="text-center max-w-700 mx-auto mb-5">
            <div class="hyper-section-badge mb-2">GÓI DỊCH VỤ &amp; BẢNG GIÁ</div>
            <h2 class="hyper-section-title mb-2">Bảng Giá Dịch Vụ Công Khai &amp; Minh Bạch</h2>
            <p class="hyper-section-subtitle">Mọi chi phí đều được niêm yết rõ ràng theo phân khúc xe, cam kết không phát sinh bất kỳ khoản phí ngoài thỏa thuận.</p>
        </div>

        <div class="row g-4 align-items-stretch">
            <!-- Tier 1: Standard Care -->
            <div class="col-lg-4">
                <div class="hyper-card hyper-pricing-card h-100 d-flex flex-column justify-content-between">
                    <div>
                        <div class="hyper-tier-badge">GÓI CƠ BẢN</div>
                        <h3 class="hyper-tier-title">Chăm Sóc Tiêu Chuẩn</h3>
                        <p class="hyper-tier-desc">Dành cho xe bảo dưỡng định kỳ hàng tháng, rửa xe chi tiết &amp; kiểm tra tổng quát.</p>
                        <div class="hyper-tier-price">
                            <span class="currency">Từ</span>
                            <span class="amount text-orange">250.000</span>
                            <span class="unit">₫</span>
                        </div>
                        <ul class="hyper-checklist list-unstyled mt-4">
                            <li><i class="fa-solid fa-check text-orange me-2"></i> Rửa xe bọt tuyết &amp; hút bụi khoang lái</li>
                            <li><i class="fa-solid fa-check text-orange me-2"></i> Kiểm tra 35 điểm an toàn tổng quát</li>
                            <li><i class="fa-solid fa-check text-orange me-2"></i> Đo áp suất lốp &amp; châm nước làm mát</li>
                            <li><i class="fa-solid fa-check text-orange me-2"></i> Vệ sinh lọc gió động cơ &amp; điều hòa</li>
                            <li class="disabled"><i class="fa-solid fa-xmark text-muted me-2"></i> Thay dầu máy &amp; lọc nhớt</li>
                            <li class="disabled"><i class="fa-solid fa-xmark text-muted me-2"></i> Cân chỉnh góc đặt bánh xe Hunter 3D</li>
                        </ul>
                    </div>
                    <a href="${pageContext.request.contextPath}/booking" class="btn btn-hyper-outline w-100 mt-4">
                        Chọn Gói Tiêu Chuẩn
                    </a>
                </div>
            </div>

            <!-- Tier 2: Comprehensive Maintenance (POPULAR HIGHLIGHT) -->
            <div class="col-lg-4">
                <div class="hyper-card hyper-pricing-card popular h-100 d-flex flex-column justify-content-between">
                    <div>
                        <div class="hyper-popular-ribbon">ĐƯỢC CHỌN NHIỀU NHẤT</div>
                        <div class="hyper-tier-badge text-orange">GÓI TOÀN DIỆN</div>
                        <h3 class="hyper-tier-title">Bảo Dưỡng Toàn Diện</h3>
                        <p class="hyper-tier-desc">Giải pháp tối ưu cho xe chạy 10.000 - 20.000 KM, phục hồi công suất &amp; vận hành êm ái.</p>
                        <div class="hyper-tier-price">
                            <span class="currency">Từ</span>
                            <span class="amount text-orange">850.000</span>
                            <span class="unit">₫</span>
                        </div>
                        <ul class="hyper-checklist list-unstyled mt-4">
                            <li><i class="fa-solid fa-check text-orange me-2"></i> <strong>Bao gồm toàn bộ Gói Tiêu Chuẩn</strong></li>
                            <li><i class="fa-solid fa-check text-orange me-2"></i> Thay dầu động cơ Castrol/Mobil chính hãng</li>
                            <li><i class="fa-solid fa-check text-orange me-2"></i> Thay mới lọc nhớt chuẩn OEM</li>
                            <li><i class="fa-solid fa-check text-orange me-2"></i> Bảo dưỡng, vệ sinh &amp; tra mỡ cụm phanh 4 bánh</li>
                            <li><i class="fa-solid fa-check text-orange me-2"></i> Đọc xóa lỗi chẩn đoán hộp đen ECU vi tính</li>
                            <li><i class="fa-solid fa-check text-orange me-2"></i> Báo cáo ảnh &amp; kích hoạt bảo hành điện tử 12T</li>
                        </ul>
                    </div>
                    <a href="${pageContext.request.contextPath}/booking" class="btn btn-hyper-orange w-100 mt-4">
                        ĐẶT GÓI TOÀN DIỆN NGAY
                    </a>
                </div>
            </div>

            <!-- Tier 3: Hyper Detailing & Ceramic VIP -->
            <div class="col-lg-4">
                <div class="hyper-card hyper-pricing-card h-100 d-flex flex-column justify-content-between">
                    <div>
                        <div class="hyper-tier-badge">GÓI VIP CAO CẤP</div>
                        <h3 class="hyper-tier-title">Spa Detailing &amp; Ceramic</h3>
                        <p class="hyper-tier-desc">Chăm sóc xế hộp đẳng cấp với công nghệ hiệu chỉnh sơn đa bước &amp; phủ Ceramic 9H.</p>
                        <div class="hyper-tier-price">
                            <span class="currency">Từ</span>
                            <span class="amount text-orange">2.500.000</span>
                            <span class="unit">₫</span>
                        </div>
                        <ul class="hyper-checklist list-unstyled mt-4">
                            <li><i class="fa-solid fa-check text-orange me-2"></i> Rửa khoang máy hơi nước nóng &amp; phủ nano</li>
                            <li><i class="fa-solid fa-check text-orange me-2"></i> Hiệu chỉnh xóa xước quầng sơn 3 bước chuyên sâu</li>
                            <li><i class="fa-solid fa-check text-orange me-2"></i> Phủ bóng Ceramic 9H bảo vệ lớp sơn bóng gương</li>
                            <li><i class="fa-solid fa-check text-orange me-2"></i> Nội soi khử mùi dàn lạnh &amp; dưỡng da nội thất</li>
                            <li><i class="fa-solid fa-check text-orange me-2"></i> Cân chỉnh thước lái góc đặt bánh xe 3D Hunter</li>
                            <li><i class="fa-solid fa-check text-orange me-2"></i> Bảo hành điện tử tráng gương 24 tháng</li>
                        </ul>
                    </div>
                    <a href="${pageContext.request.contextPath}/booking" class="btn btn-hyper-outline w-100 mt-4">
                        Chọn Gói Detailing VIP
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ==========================================
     BEFORE & AFTER SHOWCASE (HyperAuto See The Difference)
     ========================================== -->
<section class="hyper-section py-5 hyper-before-after-bg">
    <div class="container-xl py-lg-4">
        <div class="text-center max-w-700 mx-auto mb-5">
            <div class="hyper-section-badge mb-2">TRỰC QUAN HÓA CHẤT LƯỢNG</div>
            <h2 class="hyper-section-title mb-2">Xem Sự Khác Biệt Trước &amp; Sau Khi Làm Dịch Vụ</h2>
            <p class="hyper-section-subtitle">Chúng tôi phục hồi chiếc xe của bạn trở về trạng thái vận hành mượt mà và diện mạo nguyên bản xuất xưởng.</p>
        </div>

        <div class="row g-4 align-items-stretch">
            <!-- Item 1: Engine Bay -->
            <div class="col-lg-6">
                <div class="hyper-card p-4 h-100">
                    <div class="d-flex align-items-center justify-content-between mb-3">
                        <span class="hyper-pill-tag">KHOANG ĐỘNG CƠ</span>
                        <span class="text-muted small"><i class="fa-solid fa-spray-can text-orange me-1"></i> Hơi nước nóng áp lực</span>
                    </div>
                    <h4 class="hyper-service-name mb-3">Vệ Sinh Khoang Máy Bằng Hơi Nước Nóng</h4>
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="hyper-compare-box before">
                                <span class="hyper-compare-tag before">TRƯỚC BẢO DƯỠNG</span>
                                <ul class="list-unstyled small mb-0 mt-2 text-muted">
                                    <li>&bull; Bám bùn đất dày đặc</li>
                                    <li>&bull; Cặn dầu mỡ két dính lâu năm</li>
                                    <li>&bull; Cao su và ống nhựa bị oxy hóa</li>
                                    <li>&bull; Nguy cơ quá nhiệt &amp; chập điện</li>
                                </ul>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="hyper-compare-box after">
                                <span class="hyper-compare-tag after">SAU BẢO DƯỠNG</span>
                                <ul class="list-unstyled small mb-0 mt-2 text-light">
                                    <li><i class="fa-solid fa-check text-orange me-1"></i> Sạch tinh như xe mới xuất xưởng</li>
                                    <li><i class="fa-solid fa-check text-orange me-1"></i> Bóc sạch 100% dầu mỡ cặn</li>
                                    <li><i class="fa-solid fa-check text-orange me-1"></i> Phủ nano bảo vệ cao su &amp; chống chuột</li>
                                    <li><i class="fa-solid fa-check text-orange me-1"></i> Tản nhiệt động cơ tối ưu</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Item 2: Alignment & Brake -->
            <div class="col-lg-6">
                <div class="hyper-card p-4 h-100">
                    <div class="d-flex align-items-center justify-content-between mb-3">
                        <span class="hyper-pill-tag">GẦM &amp; THƯỚC LÁI</span>
                        <span class="text-muted small"><i class="fa-solid fa-arrows-to-dot text-orange me-1"></i> Hunter 3D Hoa Kỳ</span>
                    </div>
                    <h4 class="hyper-service-name mb-3">Cân Chỉnh Thước Lái &amp; Bảo Dưỡng Phanh</h4>
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="hyper-compare-box before">
                                <span class="hyper-compare-tag before">TRƯỚC BẢO DƯỠNG</span>
                                <ul class="list-unstyled small mb-0 mt-2 text-muted">
                                    <li>&bull; Xe nhao sang phải khi buông tay lái</li>
                                    <li>&bull; Lốp xe mòn vẹt lệch má trong</li>
                                    <li>&bull; Rung giật vô lăng khi đạp phanh cao tốc</li>
                                    <li>&bull; Đĩa phanh có gờ sâu, rỉ sét ố vàng</li>
                                </ul>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="hyper-compare-box after">
                                <span class="hyper-compare-tag after">SAU BẢO DƯỠNG</span>
                                <ul class="list-unstyled small mb-0 mt-2 text-light">
                                    <li><i class="fa-solid fa-check text-orange me-1"></i> Xe chạy thẳng tắp 120km/h trên cao tốc</li>
                                    <li><i class="fa-solid fa-check text-orange me-1"></i> Lốp mòn đều, tăng tuổi thọ 20.000 KM</li>
                                    <li><i class="fa-solid fa-check text-orange me-1"></i> Phanh êm ái, quãng đường dừng ngắn</li>
                                    <li><i class="fa-solid fa-check text-orange me-1"></i> Đĩa phanh phẳng mịn như mới xuất xưởng</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ==========================================
     WHY DRIVERS CHOOSE US (HyperAuto Value Grid)
     ========================================== -->
<section class="hyper-section py-5">
    <div class="container-xl py-lg-4">
        <div class="text-center max-w-700 mx-auto mb-5">
            <div class="hyper-section-badge mb-2">GIÁ TRỊ CỐT LÕI</div>
            <h2 class="hyper-section-title mb-2">Tại Sao Chủ Xe Tin Tưởng Chọn CareCar</h2>
            <p class="hyper-section-subtitle">Sự an tâm của khách hàng là thước đo giá trị cao nhất trong từng dịch vụ chúng tôi cung cấp.</p>
        </div>

        <div class="row g-4">
            <!-- 1 -->
            <div class="col-md-6 col-lg-4">
                <div class="hyper-card hyper-value-card h-100">
                    <div class="hyper-value-icon text-orange"><i class="fa-solid fa-user-gear"></i></div>
                    <h4 class="hyper-value-title">Kỹ Thuật Viên Lành Nghề</h4>
                    <p class="hyper-value-desc">Đội ngũ kỹ sư, thợ cả giàu kinh nghiệm trên 15 năm làm việc với các dòng xe Đức (Mercedes, BMW, Porsche), Nhật, Mỹ và xe điện hiện đại.</p>
                </div>
            </div>
            <!-- 2 -->
            <div class="col-md-6 col-lg-4">
                <div class="hyper-card hyper-value-card h-100">
                    <div class="hyper-value-icon text-orange"><i class="fa-solid fa-laptop-medical"></i></div>
                    <h4 class="hyper-value-title">Trang Thiết Bị Hunter 3D Hoa Kỳ</h4>
                    <p class="hyper-value-desc">Hệ thống máy cân chỉnh góc lái Hunter HawkEye Elite, máy ra vào lốp không chạm tự động và phòng sơn sấy hồng ngoại tiêu chuẩn quốc tế.</p>
                </div>
            </div>
            <!-- 3 -->
            <div class="col-md-6 col-lg-4">
                <div class="hyper-card hyper-value-card h-100">
                    <div class="hyper-value-icon text-orange"><i class="fa-solid fa-certificate"></i></div>
                    <h4 class="hyper-value-title">100% Phụ Tùng Chính Hãng</h4>
                    <p class="hyper-value-desc">Cam kết linh kiện nhập khẩu chính hãng hoặc OEM cao cấp từ Bosch, Denso, Brembo có mã QR truy xuất xuất xứ và hóa đơn VAT đầy đủ.</p>
                </div>
            </div>
            <!-- 4 -->
            <div class="col-md-6 col-lg-4">
                <div class="hyper-card hyper-value-card h-100">
                    <div class="hyper-value-icon text-orange"><i class="fa-solid fa-eye"></i></div>
                    <h4 class="hyper-value-title">Minh Bạch &amp; Báo Cáo Ảnh Số Hóa</h4>
                    <p class="hyper-value-desc">Không phát sinh chi phí ngầm. Kỹ thuật viên chụp ảnh và quay video chi tiết phụ tùng cũ/mới gửi trực tiếp lên web để chủ xe duyệt.</p>
                </div>
            </div>
            <!-- 5 -->
            <div class="col-md-6 col-lg-4">
                <div class="hyper-card hyper-value-card h-100">
                    <div class="hyper-value-icon text-orange"><i class="fa-solid fa-award"></i></div>
                    <h4 class="hyper-value-title">Bảo Hành Điện Tử Dài Hạn</h4>
                    <p class="hyper-value-desc">Chính sách bảo hành điện tử chính hãng từ 12 đến 24 tháng (hoặc 20.000 KM). Lưu trữ lịch sử bảo dưỡng trực tuyến trọn đời xe.</p>
                </div>
            </div>
            <!-- 6 -->
            <div class="col-md-6 col-lg-4">
                <div class="hyper-card hyper-value-card h-100">
                    <div class="hyper-value-icon text-orange"><i class="fa-solid fa-truck-medical"></i></div>
                    <h4 class="hyper-value-title">Cứu Hộ &amp; Hỗ Trợ 24/7</h4>
                    <p class="hyper-value-desc">Chủ động đặt lịch hẹn không phải chờ đợi. Đội cứu hộ lưu động CareCar sẵn sàng phục vụ 24/7 trên toàn khu vực Hà Nội qua hotline 0364 968 200.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ==========================================
     CUSTOMER REVIEWS (HyperAuto Reviews)
     ========================================== -->
<section class="hyper-section py-5 hyper-reviews-bg" id="testimonials">
    <div class="container-xl py-lg-4">
        <div class="text-center max-w-700 mx-auto mb-5">
            <div class="hyper-section-badge mb-2">ĐÁNH GIÁ KHÁCH HÀNG</div>
            <h2 class="hyper-section-title mb-2">Hơn 25.000 Chủ Xe Tin Tưởng Đồng Hành</h2>
            <p class="hyper-section-subtitle">Lắng nghe chia sẻ thực tế từ các chủ xe đã trải nghiệm dịch vụ chăm sóc &amp; sửa chữa tại hệ thống CareCar.</p>
        </div>

        <div class="row g-4">
            <!-- Review 1 -->
            <div class="col-md-4">
                <div class="hyper-card hyper-review-card h-100 d-flex flex-column justify-content-between p-4">
                    <div>
                        <div class="trust-stars mb-3">
                            <i class="fa-solid fa-star text-orange"></i>
                            <i class="fa-solid fa-star text-orange"></i>
                            <i class="fa-solid fa-star text-orange"></i>
                            <i class="fa-solid fa-star text-orange"></i>
                            <i class="fa-solid fa-star text-orange"></i>
                        </div>
                        <p class="hyper-review-text mb-4">
                            "Rất ấn tượng với tính năng tra cứu xe online. Mình ngồi văn phòng làm việc vẫn xem được thợ chụp ảnh lọc nhớt cũ và mới, báo giá minh bạch không lo bị kê khống như các gara trước đây."
                        </p>
                    </div>
                    <div class="d-flex align-items-center gap-3 pt-3 hyper-review-footer">
                        <div class="hyper-avatar-circle">TM</div>
                        <div>
                            <h5 class="hyper-reviewer-name mb-0">Anh Trần Tuấn Minh</h5>
                            <span class="hyper-reviewer-car text-orange">Mercedes-Benz C300 AMG &bull; Hà Nội</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Review 2 -->
            <div class="col-md-4">
                <div class="hyper-card hyper-review-card h-100 d-flex flex-column justify-content-between p-4">
                    <div>
                        <div class="trust-stars mb-3">
                            <i class="fa-solid fa-star text-orange"></i>
                            <i class="fa-solid fa-star text-orange"></i>
                            <i class="fa-solid fa-star text-orange"></i>
                            <i class="fa-solid fa-star text-orange"></i>
                            <i class="fa-solid fa-star text-orange"></i>
                        </div>
                        <p class="hyper-review-text mb-4">
                            "Máy cân chỉnh Hunter 3D ở CareCar cực kỳ chuẩn. Xe mình đi cao tốc bị lệch vô lăng qua gara xử lý tầm 35 phút là xong, tay lái êm và đầm chắc hẳn. Giá lại rất hợp lý."
                        </p>
                    </div>
                    <div class="d-flex align-items-center gap-3 pt-3 hyper-review-footer">
                        <div class="hyper-avatar-circle" style="background: linear-gradient(135deg, #10b981, #06b6d4);">NH</div>
                        <div>
                            <h5 class="hyper-reviewer-name mb-0">Chị Nguyễn Thanh Hà</h5>
                            <span class="hyper-reviewer-car text-orange">Mazda CX-5 2.5 &bull; Cầu Giấy</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Review 3 -->
            <div class="col-md-4">
                <div class="hyper-card hyper-review-card h-100 d-flex flex-column justify-content-between p-4">
                    <div>
                        <div class="trust-stars mb-3">
                            <i class="fa-solid fa-star text-orange"></i>
                            <i class="fa-solid fa-star text-orange"></i>
                            <i class="fa-solid fa-star text-orange"></i>
                            <i class="fa-solid fa-star text-orange"></i>
                            <i class="fa-solid fa-star text-orange"></i>
                        </div>
                        <p class="hyper-review-text mb-4">
                            "Tra cứu mã biên nhận trên web thấy ngay xe đang làm công đoạn nào, thời gian dự kiến xong rất chuẩn. Phòng chờ máy lạnh nước uống miễn phí rất chuyên nghiệp chuẩn 5 sao."
                        </p>
                    </div>
                    <div class="d-flex align-items-center gap-3 pt-3 hyper-review-footer">
                        <div class="hyper-avatar-circle" style="background: linear-gradient(135deg, #ff5a1f, #e11d48);">LĐ</div>
                        <div>
                            <h5 class="hyper-reviewer-name mb-0">Anh Lê Hoàng Đức</h5>
                            <span class="hyper-reviewer-car text-orange">Ford Ranger Wildtrak &bull; Nam Từ Liêm</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ==========================================
     FAQ ACCORDION (HyperAuto FAQ)
     ========================================== -->
<section class="hyper-section py-5" id="faq">
    <div class="container-xl py-lg-4">
        <div class="text-center max-w-700 mx-auto mb-5">
            <div class="hyper-section-badge mb-2">HỎI &amp; ĐÁP</div>
            <h2 class="hyper-section-title mb-2">Câu Hỏi Thường Gặp Của Chủ Xe</h2>
            <p class="hyper-section-subtitle">Giải đáp các thắc mắc phổ biến về chi phí, quy trình tiếp nhận và chính sách bảo hành tại CareCar.</p>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-9">
                <div class="accordion hyper-accordion" id="hyperFaqAccordion">
                    <!-- Q1 -->
                    <div class="accordion-item hyper-accordion-item">
                        <h3 class="accordion-header" id="headingOne">
                            <button class="accordion-button hyper-accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                <i class="fa-solid fa-circle-question text-orange me-3"></i> Tôi có được báo giá chi tiết trước khi xưởng tiến hành làm không?
                            </button>
                        </h3>
                        <div id="collapseOne" class="accordion-collapse collapse show" aria-labelledby="headingOne" data-bs-parent="#hyperFaqAccordion">
                            <div class="accordion-body hyper-accordion-body">
                                <strong>Tuyệt đối có!</strong> Tại CareCar, sau khi tiếp nhận xe và chẩn đoán kỹ thuật, cố vấn dịch vụ sẽ lập bảng kê chi tiết từng hạng mục công thợ và giá phụ tùng thay thế. Khách hàng xem xét và xác nhận duyệt qua ứng dụng hoặc văn bản thì xưởng mới bắt đầu thi công, cam kết không phát sinh bất kỳ phụ phí nào.
                            </div>
                        </div>
                    </div>

                    <!-- Q2 -->
                    <div class="accordion-item hyper-accordion-item">
                        <h3 class="accordion-header" id="headingTwo">
                            <button class="accordion-button hyper-accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                <i class="fa-solid fa-circle-question text-orange me-3"></i> Làm sao tôi có thể theo dõi tiến độ sửa chữa từ xa?
                            </button>
                        </h3>
                        <div id="collapseTwo" class="accordion-collapse collapse" aria-labelledby="headingTwo" data-bs-parent="#hyperFaqAccordion">
                            <div class="accordion-body hyper-accordion-body">
                                Bạn chỉ cần truy cập vào mục <strong><a href="${pageContext.request.contextPath}/track" class="text-orange">Tra cứu tiến độ</a></strong> trên trang web và nhập biển số xe (ví dụ: <code>30H-888.99</code>). Hệ thống sẽ hiển thị thời gian thực giai đoạn đang thực hiện, danh mục phụ tùng đang thay thế và ảnh chụp chi tiết từ kỹ thuật viên tại xưởng.
                            </div>
                        </div>
                    </div>

                    <!-- Q3 -->
                    <div class="accordion-item hyper-accordion-item">
                        <h3 class="accordion-header" id="headingThree">
                            <button class="accordion-button hyper-accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                <i class="fa-solid fa-circle-question text-orange me-3"></i> Phụ tùng tại CareCar có chính hãng và được bảo hành bao lâu?
                            </button>
                        </h3>
                        <div id="collapseThree" class="accordion-collapse collapse" aria-labelledby="headingThree" data-bs-parent="#hyperFaqAccordion">
                            <div class="accordion-body hyper-accordion-body">
                                Toàn bộ linh kiện và phụ tùng tại CareCar đều là hàng chính hãng hoặc OEM tiêu chuẩn chất lượng cao từ các nhà cung ứng hàng đầu (Bosch, Denso, Brembo...). Tất cả phụ tùng đều được cấp mã bảo hành điện tử chính hãng từ <strong>12 tháng đến 24 tháng</strong> (hoặc 20.000 KM tùy điều kiện nào đến trước).
                            </div>
                        </div>
                    </div>

                    <!-- Q4 -->
                    <div class="accordion-item hyper-accordion-item">
                        <h3 class="accordion-header" id="headingFour">
                            <button class="accordion-button hyper-accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseFour" aria-expanded="false" aria-controls="collapseFour">
                                <i class="fa-solid fa-circle-question text-orange me-3"></i> Thời gian bảo dưỡng định kỳ mất khoảng bao lâu?
                            </button>
                        </h3>
                        <div id="collapseFour" class="accordion-collapse collapse" aria-labelledby="headingFour" data-bs-parent="#hyperFaqAccordion">
                            <div class="accordion-body hyper-accordion-body">
                                Đối với bảo dưỡng cấp nhỏ (Cấp 1 - 5.000 KM): Mất khoảng 45 - 60 phút. Bảo dưỡng cấp trung bình (Cấp 2 &amp; 3 - 10.000 - 20.000 KM): Khoảng 90 - 120 phút. Đội ngũ kỹ thuật viên CareCar chuẩn bị sẵn cầu nâng và vật tư để bàn giao xe đúng tiến độ cam kết.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ==========================================
     WORKSHOP LOCATIONS & CONTACT (HyperAuto Location)
     ========================================== -->
<section class="hyper-section py-5 hyper-location-bg">
    <div class="container-xl py-lg-4">
        <div class="row g-4 align-items-center">
            <div class="col-lg-6">
                <div class="hyper-section-badge mb-2">HỆ THỐNG XƯỞNG DỊCH VỤ</div>
                <h2 class="hyper-section-title mb-3">Ghé Thăm CareCar Auto Workshop</h2>
                <p class="hyper-section-subtitle mb-4">
                    Tọa lạc tại các trục đường giao thông huyết mạch phía Tây Hà Nội với diện tích xưởng hơn 2.000m², trang bị 12 cầu nâng Hunter và phòng sơn sấy khép kín.
                </p>

                <div class="d-flex flex-column gap-3 mb-4">
                    <div class="hyper-contact-row d-flex align-items-start gap-3">
                        <div class="hyper-contact-icon text-orange"><i class="fa-solid fa-location-dot"></i></div>
                        <div>
                            <h5 class="hyper-contact-heading mb-1">Chi nhánh 1 (Cầu Giấy)</h5>
                            <p class="text-muted mb-0 small">Số 168 Đường Phạm Hùng, Phường Mễ Trì, Cầu Giấy, Hà Nội (Cách Keangnam 200m)</p>
                        </div>
                    </div>
                    <div class="hyper-contact-row d-flex align-items-start gap-3">
                        <div class="hyper-contact-icon text-orange"><i class="fa-solid fa-location-dot"></i></div>
                        <div>
                            <h5 class="hyper-contact-heading mb-1">Chi nhánh 2 (Nam Từ Liêm)</h5>
                            <p class="text-muted mb-0 small">Số 88 Đường Lê Đức Thọ, Phường Mỹ Đình 2, Nam Từ Liêm, Hà Nội (Cạnh SVĐ Mỹ Đình)</p>
                        </div>
                    </div>
                    <div class="hyper-contact-row d-flex align-items-start gap-3">
                        <div class="hyper-contact-icon text-orange"><i class="fa-regular fa-clock"></i></div>
                        <div>
                            <h5 class="hyper-contact-heading mb-1">Thời Gian Hoạt Động</h5>
                            <p class="text-muted mb-0 small">Thứ 2 - Thứ 7: <strong>07:30 - 18:00</strong> | Chủ Nhật: <strong>08:00 - 16:30</strong> (Cứu hộ 24/7)</p>
                        </div>
                    </div>
                </div>

                <div class="d-flex flex-wrap gap-2">
                    <a href="tel:0364968200" class="btn btn-hyper-orange">
                        <i class="fa-solid fa-phone me-1"></i> Gọi Hotline: 0364 968 200
                    </a>
                    <a href="https://zalo.me/0364968200" target="_blank" rel="noopener noreferrer" class="btn btn-hyper-zalo">
                        <i class="fa-solid fa-comment-dots me-1"></i> Chat Zalo: 0364 968 200
                    </a>
                </div>
            </div>

            <div class="col-lg-6">
                <div class="hyper-card p-3 p-md-4 text-center">
                    <div class="rounded-3 overflow-hidden position-relative mb-3" style="height: 320px; background: url('${pageContext.request.contextPath}/assets/images/hero_garage.jpg') center/cover no-repeat;">
                        <div class="position-absolute inset-0 bg-dark bg-opacity-50 d-flex flex-column justify-content-center align-items-center p-3 text-white">
                            <span class="badge bg-warning text-dark fw-bold px-3 py-2 rounded-pill mb-2">GARAGE 4.0 TIÊU CHUẨN 5 SAO</span>
                            <h3 class="hyper-card-heading text-white">Hệ Thống Xưởng Hiện Đại Bậc Nhất</h3>
                            <p class="small text-light text-opacity-80 mb-3" style="max-width: 400px;">12 Cầu Nâng &bull; Máy Đo Thước Lái Hunter 3D Hoa Kỳ &bull; Phòng Sơn Sấy Kín</p>
                            <a href="${pageContext.request.contextPath}/booking" class="btn btn-sm btn-hyper-orange">
                                <i class="fa-regular fa-calendar-check me-1"></i> Đặt Lịch Ghé Xưởng
                            </a>
                        </div>
                    </div>
                    <div class="d-flex justify-content-around text-center small text-muted">
                        <div><strong class="text-orange d-block fs-5">2.000m²</strong> Diện Tích Xưởng</div>
                        <div><strong class="text-orange d-block fs-5">12 Cầu</strong> Nâng Hunter Mỹ</div>
                        <div><strong class="text-orange d-block fs-5">24/7</strong> Hỗ Trợ Cứu Hộ</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ==========================================
     FINAL CALL-TO-ACTION (HyperAuto Final CTA)
     ========================================== -->
<section class="hyper-section py-5">
    <div class="container-xl py-lg-4">
        <div class="hyper-final-cta-card text-center p-4 p-md-5 position-relative overflow-hidden">
            <div class="hyper-cta-glow"></div>
            <div class="position-relative z-2 max-w-700 mx-auto">
                <span class="hyper-section-badge mb-2">ĐỒNG HÀNH AN TÂM</span>
                <h2 class="hyper-cta-title mb-3">Trao Gửi Xế Cưng Cho Chuyên Gia CareCar</h2>
                <p class="hyper-cta-desc mb-4">
                    Đặt lịch ngay hôm nay để nhận ưu đãi kiểm tra 35 điểm an toàn và khử mùi diệt khuẩn dàn lạnh hoàn toàn miễn phí.
                </p>
                <div class="d-flex flex-wrap justify-content-center gap-3">
                    <a href="${pageContext.request.contextPath}/booking" class="btn btn-hyper-orange btn-lg px-4">
                        <i class="fa-regular fa-calendar-check me-2"></i> ĐẶT LỊCH HẸN TRỰC TUYẾN
                    </a>
                    <a href="tel:0364968200" class="btn btn-hyper-outline btn-lg px-4">
                        <i class="fa-solid fa-phone-volume text-orange me-2"></i> HOTLINE: 0364 968 200
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="includes/footer.jsp" />
