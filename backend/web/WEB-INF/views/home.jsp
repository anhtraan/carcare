<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="title" value="CareCar - Hệ Thống Dịch Vụ &amp; Sửa Chữa Ô Tô Tiêu Chuẩn 5 Sao" />
</jsp:include>

<!-- Hero Section with Background Slider -->
<section class="landing-hero" id="hero">
    <!-- Slider Background Container (Tự động nạp từ hero-slider-config.js) -->
    <div class="hero-slider-bg"></div>
    <div class="hero-slider-overlay"></div>

    <div class="container py-4">
        <div class="row align-items-center g-5">
            <!-- Left Headline & CTA Column -->
            <div class="col-lg-7">
                <div class="d-inline-flex align-items-center gap-2 bg-dark bg-opacity-75 border border-primary border-opacity-50 text-light px-3 py-1 rounded-pill mb-3 shadow-sm">
                    <span class="pulse-dot"></span>
                    <span class="small fw-semibold"><span class="text-warning fw-bold">GARAGE 4.0</span> &bull; THIẾT BỊ HUNTER 3D HOA KỲ &bull; TIÊU CHUẨN 5 SAO</span>
                </div>
                
                <h1 class="display-4 fw-bolder mb-3 lh-sm">
                    Chăm Sóc &amp; Sửa Chữa Ô Tô <br>
                    <span class="text-gradient-primary">Minh Bạch Tuyệt Đối</span>
                </h1>
                
                <p class="lead text-light text-opacity-90 mb-4" style="max-width: 620px;">
                    Hệ thống quản lý dịch vụ ô tô số hóa toàn diện: Báo cáo ảnh &amp; video phụ tùng trực tiếp qua hệ thống, kiểm tra 35 điểm an toàn, 100% phụ tùng chính hãng có QR truy xuất và bảo hành điện tử 12 tháng.
                </p>

                <!-- Action Buttons -->
                <div class="d-flex flex-wrap gap-3 mb-5">
                    <a href="${pageContext.request.contextPath}/services" class="btn btn-warning btn-lg fw-bold text-dark px-4 py-3 shadow-lg d-inline-flex align-items-center gap-2 rounded-3 hover-lift">
                        <i class="fa-solid fa-list-check fs-5"></i>
                        <span>Khám Phá Dịch Vụ &amp; Bảng Giá</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/track" class="btn btn-outline-light btn-lg px-4 py-3 rounded-3 d-inline-flex align-items-center gap-2">
                        <i class="fa-solid fa-magnifying-glass-location text-warning"></i>
                        <span>Tra Cứu Xe Đang Sửa</span>
                    </a>
                </div>

                <!-- Stats Ticker -->
                <div class="row g-3">
                    <div class="col-6 col-sm-3">
                        <div class="stat-box">
                            <div class="stat-number">15+</div>
                            <div class="small text-light text-opacity-75">Năm Kinh Nghiệm</div>
                        </div>
                    </div>
                    <div class="col-6 col-sm-3">
                        <div class="stat-box">
                            <div class="stat-number">25K+</div>
                            <div class="small text-light text-opacity-75">Lượt Xe Phục Vụ</div>
                        </div>
                    </div>
                    <div class="col-6 col-sm-3">
                        <div class="stat-box">
                            <div class="stat-number">99.6%</div>
                            <div class="small text-light text-opacity-75">Hài Lòng 5 Sao</div>
                        </div>
                    </div>
                    <div class="col-6 col-sm-3">
                        <div class="stat-box">
                            <div class="stat-number">12T</div>
                            <div class="small text-light text-opacity-75">Bảo Hành Phụ Tùng</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Interactive Quick Action Widget (Tập trung tra cứu tiến độ xe trực tuyến) -->
            <div class="col-lg-5">
                <div class="glass-hero-widget p-4 p-md-5 text-white">
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <div class="bg-primary text-white rounded-3 d-flex align-items-center justify-content-center" style="width: 44px; height: 44px; font-size: 1.25rem;">
                            <i class="fa-solid fa-car-tunnel"></i>
                        </div>
                        <div>
                            <h5 class="fw-bold mb-0">Kiểm Tra Tiến Độ Trực Tuyến</h5>
                            <p class="small text-light text-opacity-75 mb-0">Xem ảnh chụp thực tế từng công đoạn sửa xe</p>
                        </div>
                    </div>

                    <form action="${pageContext.request.contextPath}/track" method="GET">
                        <div class="mb-3">
                            <label for="quickTrackInput" class="form-label text-light small fw-semibold">Biển số xe hoặc Mã biên nhận</label>
                            <div class="input-group input-group-lg">
                                <span class="input-group-text bg-dark border-secondary text-warning"><i class="fa-solid fa-hashtag"></i></span>
                                <input type="text" id="quickTrackInput" name="q" class="form-control bg-dark border-secondary text-white" placeholder="Ví dụ: 30H-888.99 hoặc CC-2026-0001" required>
                            </div>
                            <div class="form-text text-light text-opacity-50 small">Nhập biển số để xem tình trạng sửa chữa tức thì</div>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 btn-lg fw-bold shadow">
                            <i class="fa-solid fa-magnifying-glass me-2"></i> Tra Cứu Tiến Độ Ngay
                        </button>
                    </form>

                    <div class="mt-4 pt-3 border-top border-secondary d-flex justify-content-between align-items-center small text-light text-opacity-75">
                        <span><i class="fa-solid fa-shield-halved text-success me-1"></i> Bảo hành phụ tùng 12T</span>
                        <span><i class="fa-solid fa-camera text-info me-1"></i> Báo cáo ảnh 100%</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Background Slider Navigation Dots -->
    <div class="hero-slider-dots"></div>
</section>

<!-- Brand Marquee Ticker -->
<section class="brand-ticker-section">
    <div class="container-fluid px-0">
        <div class="brand-ticker-track">
            <!-- Brand Items Set 1 -->
            <div class="brand-ticker-item"><i class="fa-solid fa-car-side text-warning"></i> MERCEDES-BENZ</div>
            <div class="brand-ticker-item"><i class="fa-solid fa-car-side text-warning"></i> BMW</div>
            <div class="brand-ticker-item"><i class="fa-solid fa-car-side text-warning"></i> PORSCHE</div>
            <div class="brand-ticker-item"><i class="fa-solid fa-car-side text-warning"></i> AUDI</div>
            <div class="brand-ticker-item"><i class="fa-solid fa-car-side text-warning"></i> LEXUS</div>
            <div class="brand-ticker-item"><i class="fa-solid fa-car-side text-warning"></i> TOYOTA</div>
            <div class="brand-ticker-item"><i class="fa-solid fa-car-side text-warning"></i> HONDA</div>
            <div class="brand-ticker-item"><i class="fa-solid fa-car-side text-warning"></i> MAZDA</div>
            <div class="brand-ticker-item"><i class="fa-solid fa-car-side text-warning"></i> HYUNDAI</div>
            <div class="brand-ticker-item"><i class="fa-solid fa-car-side text-warning"></i> KIA</div>
            <div class="brand-ticker-item"><i class="fa-solid fa-car-side text-warning"></i> FORD</div>
            <div class="brand-ticker-item"><i class="fa-solid fa-car-side text-warning"></i> VINFAST</div>
            <!-- Duplicate for Seamless Scroll Loop -->
            <div class="brand-ticker-item"><i class="fa-solid fa-car-side text-warning"></i> MERCEDES-BENZ</div>
            <div class="brand-ticker-item"><i class="fa-solid fa-car-side text-warning"></i> BMW</div>
            <div class="brand-ticker-item"><i class="fa-solid fa-car-side text-warning"></i> PORSCHE</div>
            <div class="brand-ticker-item"><i class="fa-solid fa-car-side text-warning"></i> AUDI</div>
            <div class="brand-ticker-item"><i class="fa-solid fa-car-side text-warning"></i> LEXUS</div>
            <div class="brand-ticker-item"><i class="fa-solid fa-car-side text-warning"></i> TOYOTA</div>
            <div class="brand-ticker-item"><i class="fa-solid fa-car-side text-warning"></i> HONDA</div>
            <div class="brand-ticker-item"><i class="fa-solid fa-car-side text-warning"></i> MAZDA</div>
            <div class="brand-ticker-item"><i class="fa-solid fa-car-side text-warning"></i> HYUNDAI</div>
            <div class="brand-ticker-item"><i class="fa-solid fa-car-side text-warning"></i> KIA</div>
            <div class="brand-ticker-item"><i class="fa-solid fa-car-side text-warning"></i> FORD</div>
            <div class="brand-ticker-item"><i class="fa-solid fa-car-side text-warning"></i> VINFAST</div>
        </div>
    </div>
</section>

<!-- Popular Services Grid (DANH MỤC DỊCH VỤ) -->
<section class="py-5 bg-light" id="services">
    <div class="container py-lg-4">
        <div class="d-flex flex-wrap justify-content-between align-items-end mb-4">
            <div>
                <span class="badge bg-primary-subtle text-primary fw-bold px-3 py-2 rounded-pill uppercase">DANH MỤC DỊCH VỤ</span>
                <h2 class="display-6 fw-bold mt-2">Dịch Vụ Sửa Chữa &amp; Chăm Sóc Hàng Đầu</h2>
            </div>
            <a href="${pageContext.request.contextPath}/services" class="btn btn-outline-primary fw-semibold">Xem toàn bộ bảng giá &rarr;</a>
        </div>

        <div class="row g-4">
            <c:choose>
                <c:when test="${not empty popularServices}">
                    <c:forEach items="${popularServices}" var="svc">
                        <div class="col-md-6 col-lg-4">
                            <div class="card h-100 border-0 shadow-sm rounded-4 overflow-hidden hover-lift">
                                <div class="card-body p-4 d-flex flex-column justify-content-between">
                                    <div>
                                        <div class="d-flex justify-content-between align-items-start mb-3">
                                            <span class="badge bg-primary-subtle text-primary fw-bold">${svc.category}</span>
                                            <span class="text-muted small"><i class="fa-regular fa-clock me-1"></i> ~${svc.estimatedDuration} phút</span>
                                        </div>
                                        <h5 class="fw-bold card-title">${svc.serviceName}</h5>
                                        <p class="text-muted small card-text">${svc.description}</p>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center pt-3 border-top mt-3">
                                        <div>
                                            <span class="text-muted small d-block">Tiền công từ:</span>
                                            <span class="fs-5 fw-bold text-primary">
                                                <fmt:formatNumber value="${svc.laborCost}" pattern="#,###" /> ₫
                                            </span>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/services" class="btn btn-sm btn-outline-primary fw-semibold">Chi tiết dịch vụ</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <!-- Fallback 6 Services -->
                    <div class="col-md-6 col-lg-4">
                        <div class="card h-100 border-0 shadow-sm rounded-4 overflow-hidden hover-lift">
                            <div class="card-body p-4 d-flex flex-column justify-content-between">
                                <div>
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <span class="badge bg-primary-subtle text-primary fw-bold">BẢO DƯỠNG</span>
                                        <span class="text-muted small"><i class="fa-regular fa-clock me-1"></i> 60 phút</span>
                                    </div>
                                    <h5 class="fw-bold card-title">Bảo Dưỡng Định Kỳ Đa Cấp Độ</h5>
                                    <p class="text-muted small card-text">Thay dầu động cơ, lọc nhớt, vệ sinh phanh, chẩn đoán 35 điểm an toàn và reset đèn nhắc bảo dưỡng trên taplo.</p>
                                </div>
                                <div class="d-flex justify-content-between align-items-center pt-3 border-top mt-3">
                                    <div>
                                        <span class="text-muted small d-block">Công thợ từ:</span>
                                        <span class="fs-5 fw-bold text-primary">250.000 ₫</span>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/services" class="btn btn-sm btn-outline-primary fw-semibold">Chi tiết dịch vụ</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 col-lg-4">
                        <div class="card h-100 border-0 shadow-sm rounded-4 overflow-hidden hover-lift">
                            <div class="card-body p-4 d-flex flex-column justify-content-between">
                                <div>
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <span class="badge bg-warning-subtle text-warning-emphasis fw-bold">GẦM &amp; LÁI</span>
                                        <span class="text-muted small"><i class="fa-regular fa-clock me-1"></i> 45 phút</span>
                                    </div>
                                    <h5 class="fw-bold card-title">Cân Chỉnh Thước Lái 3D Hunter</h5>
                                    <p class="text-muted small card-text">Cân chỉnh góc đặt bánh xe chuẩn xác tuyệt đối bằng máy cân 3D nhập khẩu Mỹ, chống mòn lốp lệch và giúp vô lăng thẳng tắp.</p>
                                </div>
                                <div class="d-flex justify-content-between align-items-center pt-3 border-top mt-3">
                                    <div>
                                        <span class="text-muted small d-block">Trọn gói chỉ:</span>
                                        <span class="fs-5 fw-bold text-primary">500.000 ₫</span>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/services" class="btn btn-sm btn-outline-primary fw-semibold">Chi tiết dịch vụ</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 col-lg-4">
                        <div class="card h-100 border-0 shadow-sm rounded-4 overflow-hidden hover-lift">
                            <div class="card-body p-4 d-flex flex-column justify-content-between">
                                <div>
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <span class="badge bg-info-subtle text-info-emphasis fw-bold">ĐIỆN - ĐIỀU HÒA</span>
                                        <span class="text-muted small"><i class="fa-regular fa-clock me-1"></i> 90 phút</span>
                                    </div>
                                    <h5 class="fw-bold card-title">Vệ Sinh Dàn Lạnh Nội Soi</h5>
                                    <p class="text-muted small card-text">Làm sạch dàn lạnh bằng camera nội soi công nghệ cao không cần tháo taplo, khử sạch 100% nấm mốc và mùi hôi ẩm.</p>
                                </div>
                                <div class="d-flex justify-content-between align-items-center pt-3 border-top mt-3">
                                    <div>
                                        <span class="text-muted small d-block">Trọn gói chỉ:</span>
                                        <span class="fs-5 fw-bold text-primary">600.000 ₫</span>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/services" class="btn btn-sm btn-outline-primary fw-semibold">Chi tiết dịch vụ</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 col-lg-4">
                        <div class="card h-100 border-0 shadow-sm rounded-4 overflow-hidden hover-lift">
                            <div class="card-body p-4 d-flex flex-column justify-content-between">
                                <div>
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <span class="badge bg-danger-subtle text-danger fw-bold">AN TOÀN</span>
                                        <span class="text-muted small"><i class="fa-regular fa-clock me-1"></i> 60 phút</span>
                                    </div>
                                    <h5 class="fw-bold card-title">Bảo Dưỡng Phanh &amp; Láng Đĩa 3D</h5>
                                    <p class="text-muted small card-text">Láng đĩa phanh trực tiếp trên xe khắc phục hiện tượng rung lắc chân phanh khi đạp tốc độ cao, thay má phanh chính hãng.</p>
                                </div>
                                <div class="d-flex justify-content-between align-items-center pt-3 border-top mt-3">
                                    <div>
                                        <span class="text-muted small d-block">Giá từ:</span>
                                        <span class="fs-5 fw-bold text-primary">400.000 ₫</span>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/services" class="btn btn-sm btn-outline-primary fw-semibold">Chi tiết dịch vụ</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 col-lg-4">
                        <div class="card h-100 border-0 shadow-sm rounded-4 overflow-hidden hover-lift">
                            <div class="card-body p-4 d-flex flex-column justify-content-between">
                                <div>
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <span class="badge bg-success-subtle text-success fw-bold">SPA - DETAILING</span>
                                        <span class="text-muted small"><i class="fa-regular fa-clock me-1"></i> 180 phút</span>
                                    </div>
                                    <h5 class="fw-bold card-title">Rửa Khoang Máy Hơi Nước Nóng</h5>
                                    <p class="text-muted small card-text">Vệ sinh khoang động cơ bằng hơi nước nóng áp lực cao kết hợp dung dịch bóc tách dầu mỡ nhập khẩu Đức và phủ dưỡng nano.</p>
                                </div>
                                <div class="d-flex justify-content-between align-items-center pt-3 border-top mt-3">
                                    <div>
                                        <span class="text-muted small d-block">Trọn gói từ:</span>
                                        <span class="fs-5 fw-bold text-primary">700.000 ₫</span>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/services" class="btn btn-sm btn-outline-primary fw-semibold">Chi tiết dịch vụ</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 col-lg-4">
                        <div class="card h-100 border-0 shadow-sm rounded-4 overflow-hidden hover-lift">
                            <div class="card-body p-4 d-flex flex-column justify-content-between">
                                <div>
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <span class="badge bg-secondary-subtle text-secondary-emphasis fw-bold">SƠN - GÒ</span>
                                        <span class="text-muted small"><i class="fa-regular fa-clock me-1"></i> Trong ngày</span>
                                    </div>
                                    <h5 class="fw-bold card-title">Sơn Sấy Phòng Kín Tiêu Chuẩn</h5>
                                    <p class="text-muted small card-text">Pha sơn vi tính điện tử trùng mã màu gốc 100%, sấy nhiệt hồng ngoại trong phòng kín chống bụi bám, bảo hành sơn 2 năm.</p>
                                </div>
                                <div class="d-flex justify-content-between align-items-center pt-3 border-top mt-3">
                                    <div>
                                        <span class="text-muted small d-block">Giá từ:</span>
                                        <span class="fs-5 fw-bold text-primary">600.000 ₫</span>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/services" class="btn btn-sm btn-outline-primary fw-semibold">Chi tiết dịch vụ</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>

<!-- Before & After Quality Showcase -->
<section class="py-5 bg-white">
    <div class="container py-lg-4">
        <div class="text-center max-w-700 mx-auto mb-5">
            <span class="badge bg-success-subtle text-success fw-bold px-3 py-2 rounded-pill uppercase">TRỰC QUAN HÓA CHẤT LƯỢNG</span>
            <h2 class="display-6 fw-bold mt-2">Trước &amp; Sau Khi Chăm Sóc Tại CareCar</h2>
            <p class="text-muted">Chúng tôi phục hồi chiếc xe của bạn trở về trạng thái vận hành mượt mà và diện mạo nguyên bản xuất xưởng.</p>
        </div>

        <div class="row g-4 align-items-stretch">
            <!-- Inspection Item 1: Engine Bay -->
            <div class="col-md-6">
                <div class="before-after-box p-4 h-100">
                    <div class="d-flex align-items-center gap-2 mb-3">
                        <span class="badge bg-primary px-3 py-1">KHOANG ĐỘNG CƠ</span>
                        <h5 class="fw-bold mb-0">Vệ Sinh Khoang Máy Bằng Hơi Nước Nóng</h5>
                    </div>
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="before-after-card">
                                <span class="badge bg-danger mb-2">TRƯỚC BẢO DƯỠNG</span>
                                <ul class="list-unstyled small text-muted mb-0">
                                    <li>&bull; Bám bùn đất dày đặc</li>
                                    <li>&bull; Rò rỉ dầu mỡ cặn lâu năm</li>
                                    <li>&bull; Cao su và ống nhựa bị oxy hóa</li>
                                    <li>&bull; Nguy cơ chập cháy điện</li>
                                </ul>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="before-after-card after">
                                <span class="badge bg-success mb-2">SAU BẢO DƯỠNG</span>
                                <ul class="list-unstyled small text-dark mb-0">
                                    <li><i class="fa-solid fa-check text-success me-1"></i> Sạch tinh như xe mới</li>
                                    <li><i class="fa-solid fa-check text-success me-1"></i> Bóc sạch 100% dầu cặn</li>
                                    <li><i class="fa-solid fa-check text-success me-1"></i> Phủ nano bảo vệ cao su</li>
                                    <li><i class="fa-solid fa-check text-success me-1"></i> Tản nhiệt động cơ tốt hơn</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Inspection Item 2: Wheel Alignment & Brake -->
            <div class="col-md-6">
                <div class="before-after-box p-4 h-100">
                    <div class="d-flex align-items-center gap-2 mb-3">
                        <span class="badge bg-warning text-dark px-3 py-1">HỆ THỐNG GẦM LÁI</span>
                        <h5 class="fw-bold mb-0">Cân Chỉnh Thước Lái &amp; Bảo Dưỡng Phanh</h5>
                    </div>
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="before-after-card">
                                <span class="badge bg-danger mb-2">TRƯỚC BẢO DƯỠNG</span>
                                <ul class="list-unstyled small text-muted mb-0">
                                    <li>&bull; Xe nhao sang phải khi buông lái</li>
                                    <li>&bull; Lốp mòn vẹt má trong</li>
                                    <li>&bull; Rung giật vô lăng khi phanh</li>
                                    <li>&bull; Đĩa phanh có gờ sâu, rỉ sét</li>
                                </ul>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="before-after-card after">
                                <span class="badge bg-success mb-2">SAU BẢO DƯỠNG</span>
                                <ul class="list-unstyled small text-dark mb-0">
                                    <li><i class="fa-solid fa-check text-success me-1"></i> Xe chạy thẳng tắp 100km/h</li>
                                    <li><i class="fa-solid fa-check text-success me-1"></i> Mòn đều mặt tiếp xúc lốp</li>
                                    <li><i class="fa-solid fa-check text-success me-1"></i> Phanh êm ái, quãng đường ngắn</li>
                                    <li><i class="fa-solid fa-check text-success me-1"></i> Đĩa phanh phẳng mịn như mới</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Customer Testimonials -->
<section class="py-5 bg-light" id="testimonials">
    <div class="container py-lg-4">
        <div class="text-center max-w-700 mx-auto mb-5">
            <span class="badge bg-warning text-dark fw-bold px-3 py-2 rounded-pill uppercase">ĐÁNH GIÁ KHÁCH HÀNG</span>
            <h2 class="display-6 fw-bold mt-2">Hơn 25.000 Chủ Xe Tin Tưởng Đồng Hành</h2>
            <p class="text-muted">Lắng nghe chia sẻ thực tế từ các chủ xe đã trải nghiệm dịch vụ chăm sóc &amp; bảo dưỡng tại hệ thống CareCar.</p>
        </div>

        <div class="row g-4">
            <!-- Review 1 -->
            <div class="col-md-4">
                <div class="testimonial-card d-flex flex-column justify-content-between">
                    <div>
                        <div class="text-warning mb-3">
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                        </div>
                        <p class="text-muted mb-4 fst-italic">
                            "Rất ấn tượng với tính năng tra cứu xe online. Mình ngồi văn phòng làm việc vẫn xem được thợ chụp ảnh lọc nhớt cũ và mới, không lo bị kê khống phụ tùng như mấy gara trước đây."
                        </p>
                    </div>
                    <div class="d-flex align-items-center gap-3 pt-3 border-top">
                        <div class="avatar-circle">TM</div>
                        <div>
                            <h6 class="fw-bold mb-0">Anh Trần Tuấn Minh</h6>
                            <small class="text-muted">Chủ xe Mercedes-Benz C300 AMG &bull; Hà Nội</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Review 2 -->
            <div class="col-md-4">
                <div class="testimonial-card d-flex flex-column justify-content-between">
                    <div>
                        <div class="text-warning mb-3">
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                        </div>
                        <p class="text-muted mb-4 fst-italic">
                            "Máy cân chỉnh Hunter 3D ở CareCar cực kỳ chuẩn. Xe mình đi cao tốc bị lệch vô lăng qua gara xử lý tầm 35 phút là xong, tay lái êm và đầm chắc hẳn. Giá lại rất hợp lý."
                        </p>
                    </div>
                    <div class="d-flex align-items-center gap-3 pt-3 border-top">
                        <div class="avatar-circle" style="background: linear-gradient(135deg, #10b981, #06b6d4);">NH</div>
                        <div>
                            <h6 class="fw-bold mb-0">Chị Nguyễn Thanh Hà</h6>
                            <small class="text-muted">Chủ xe Mazda CX-5 2.5 &bull; Cầu Giấy</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Review 3 -->
            <div class="col-md-4">
                <div class="testimonial-card d-flex flex-column justify-content-between">
                    <div>
                        <div class="text-warning mb-3">
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                        </div>
                        <p class="text-muted mb-4 fst-italic">
                            "Tra cứu mã biên nhận trên web thấy ngay xe đang làm gì, thời gian dự kiến xong rất chuẩn. Phòng chờ máy lạnh nước uống miễn phí rất chuyên nghiệp chuẩn 5 sao."
                        </p>
                    </div>
                    <div class="d-flex align-items-center gap-3 pt-3 border-top">
                        <div class="avatar-circle" style="background: linear-gradient(135deg, #f59e0b, #ef4444);">LĐ</div>
                        <div>
                            <h6 class="fw-bold mb-0">Anh Lê Hoàng Đức</h6>
                            <small class="text-muted">Chủ xe Ford Ranger Wildtrak &bull; Nam Từ Liêm</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- FAQ Accordion Section -->
<section class="py-5 bg-white" id="faq">
    <div class="container py-lg-4">
        <div class="text-center max-w-700 mx-auto mb-5">
            <span class="badge bg-primary-subtle text-primary fw-bold px-3 py-2 rounded-pill uppercase">HỎI &amp; ĐÁP</span>
            <h2 class="display-6 fw-bold mt-2">Câu Hỏi Thường Gặp Của Chủ Xe</h2>
            <p class="text-muted">Giải đáp các thắc mắc phổ biến về chi phí, quy trình tiếp nhận và chính sách bảo hành tại CareCar.</p>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-9">
                <div class="accordion accordion-carecar" id="faqAccordion">
                    <!-- Q1 -->
                    <div class="accordion-item">
                        <h2 class="accordion-header" id="headingOne">
                            <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                <i class="fa-solid fa-circle-question text-primary me-2"></i> Tôi có được báo giá chi tiết trước khi xưởng tiến hành làm không?
                            </button>
                        </h2>
                        <div id="collapseOne" class="accordion-collapse collapse show" aria-labelledby="headingOne" data-bs-parent="#faqAccordion">
                            <div class="accordion-body">
                                <strong>Tuyệt đối có!</strong> Tại CareCar, sau khi tiếp nhận xe và chẩn đoán kỹ thuật, cố vấn dịch vụ sẽ lập bảng kê chi tiết từng hạng mục công thợ và giá phụ tùng thay thế. Khách hàng xem xét và xác nhận duyệt qua ứng dụng hoặc văn bản thì xưởng mới bắt đầu thi công, cam kết không phát sinh bất kỳ phụ phí nào.
                            </div>
                        </div>
                    </div>

                    <!-- Q2 -->
                    <div class="accordion-item">
                        <h2 class="accordion-header" id="headingTwo">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                <i class="fa-solid fa-circle-question text-primary me-2"></i> Làm sao tôi có thể theo dõi tiến độ sửa chữa từ xa?
                            </button>
                        </h2>
                        <div id="collapseTwo" class="accordion-collapse collapse" aria-labelledby="headingTwo" data-bs-parent="#faqAccordion">
                            <div class="accordion-body">
                                Bạn chỉ cần truy cập vào mục <strong><a href="${pageContext.request.contextPath}/track">Tra cứu tiến độ</a></strong> trên trang web và nhập biển số xe (ví dụ: <code>30H-888.99</code>). Hệ thống sẽ hiển thị thời gian thực giai đoạn đang thực hiện, danh mục phụ tùng đang thay thế và ảnh chụp chi tiết từ kỹ thuật viên tại xưởng.
                            </div>
                        </div>
                    </div>

                    <!-- Q3 -->
                    <div class="accordion-item">
                        <h2 class="accordion-header" id="headingThree">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                <i class="fa-solid fa-circle-question text-primary me-2"></i> Phụ tùng tại CareCar có chính hãng và được bảo hành bao lâu?
                            </button>
                        </h2>
                        <div id="collapseThree" class="accordion-collapse collapse" aria-labelledby="headingThree" data-bs-parent="#faqAccordion">
                            <div class="accordion-body">
                                Toàn bộ linh kiện và phụ tùng tại CareCar đều là hàng chính hãng hoặc OEM tiêu chuẩn chất lượng cao từ các nhà cung ứng hàng đầu (Bosch, Denso, Brembo...). Tất cả phụ tùng đều được cấp mã bảo hành điện tử chính hãng từ <strong>12 tháng đến 24 tháng</strong> (hoặc 20.000 KM tùy điều kiện nào đến trước).
                            </div>
                        </div>
                    </div>

                    <!-- Q4 -->
                    <div class="accordion-item">
                        <h2 class="accordion-header" id="headingFour">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseFour" aria-expanded="false" aria-controls="collapseFour">
                                <i class="fa-solid fa-circle-question text-primary me-2"></i> Thời gian bảo dưỡng định kỳ mất khoảng bao lâu?
                            </button>
                        </h2>
                        <div id="collapseFour" class="accordion-collapse collapse" aria-labelledby="headingFour" data-bs-parent="#faqAccordion">
                            <div class="accordion-body">
                                Đối với bảo dưỡng cấp nhỏ (Cấp 1 - 5.000 KM): Mất khoảng 45 - 60 phút. Bảo dưỡng cấp trung bình (Cấp 2 &amp; 3 - 10.000 - 20.000 KM): Khoảng 90 - 120 phút. Đội ngũ kỹ thuật viên CareCar chuẩn bị sẵn cầu nâng và vật tư để bàn giao xe đúng tiến độ cam kết.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="includes/footer.jsp" />
