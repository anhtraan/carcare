<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>${param.title != null ? param.title : 'CareCar - Trung Tâm Chăm Sóc & Sửa Chữa Ô Tô Cao Cấp'}
                </title>
                <!-- Google Fonts -->
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap"
                    rel="stylesheet">
                <!-- Bootstrap 5 -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
                <!-- Font Awesome -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <!-- Favicon / Tab Icon -->
                <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png">
                <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
                <!-- Main Style -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                <script>
                    window.CARECAR_CONTEXT_PATH = '${pageContext.request.contextPath}';
                </script>
            </head>

            <body>

                <!-- Header / Navigation Bar -->
                <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm" id="mainNavbar">
                    <div class="container">
                        <!-- Logo -->
                        <a class="navbar-brand d-flex align-items-center gap-2 fw-bold text-nowrap"
                            href="${pageContext.request.contextPath}/home">
                            <div class="logo-icon bg-white rounded-2 d-flex align-items-center justify-content-center shadow-sm"
                                style="width: 38px; height: 38px; padding: 3px;">
                                <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="CareCar Logo"
                                    style="width: 100%; height: 100%; object-fit: contain;">
                            </div>
                            <span class="fs-4 tracking-wider">CARE<span class="text-warning">CAR</span></span>
                        </a>

                        <!-- Mobile Toggler -->
                        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse"
                            data-bs-target="#carecarNavbar" aria-controls="carecarNavbar" aria-expanded="false"
                            aria-label="Toggle navigation">
                            <span class="navbar-toggler-icon"></span>
                        </button>

                        <!-- Navbar Links -->
                        <div class="collapse navbar-collapse" id="carecarNavbar">
                            <ul class="navbar-nav mx-auto mb-2 mb-lg-0 align-items-lg-center">
                                <li class="nav-item">
                                    <a class="nav-link ${pageContext.request.servletPath == '/home' || pageContext.request.servletPath == '' ? 'active' : ''}"
                                        href="${pageContext.request.contextPath}/home">
                                        <i class="fa-solid fa-house me-1"></i> Trang chủ
                                    </a>
                                </li>

                                <!-- Dịch vụ Dropdown (Xổ xuống các dịch vụ) -->
                                <li class="nav-item dropdown">
                                    <a class="nav-link dropdown-toggle ${pageContext.request.servletPath == '/services' ? 'active' : ''}"
                                        href="${pageContext.request.contextPath}/services" id="servicesDropdown"
                                        role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="fa-solid fa-list-check me-1"></i> Dịch vụ
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-dark shadow-lg border-0"
                                        aria-labelledby="servicesDropdown">
                                        <li>
                                            <a class="dropdown-item py-2 d-flex align-items-center gap-2 fw-semibold text-warning"
                                                href="${pageContext.request.contextPath}/services">
                                                <i class="fa-solid fa-layer-group text-warning"></i> Xem Tất Cả Dịch Vụ
                                                &amp; Bảng Giá
                                            </a>
                                        </li>
                                        <li>
                                            <hr class="dropdown-divider border-secondary my-1">
                                        </li>
                                        <li>
                                            <a class="dropdown-item py-2 d-flex align-items-center gap-2"
                                                href="${pageContext.request.contextPath}/services">
                                                <i class="fa-solid fa-oil-can text-primary"></i> Bảo dưỡng định kỳ đa
                                                cấp độ
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item py-2 d-flex align-items-center gap-2"
                                                href="${pageContext.request.contextPath}/services">
                                                <i class="fa-solid fa-arrows-to-dot text-info"></i> Cân chỉnh thước lái
                                                3D Hunter
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item py-2 d-flex align-items-center gap-2"
                                                href="${pageContext.request.contextPath}/services">
                                                <i class="fa-solid fa-snowflake text-info"></i> Điện &amp; Vệ sinh điều
                                                hòa nội soi
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item py-2 d-flex align-items-center gap-2"
                                                href="${pageContext.request.contextPath}/services">
                                                <i class="fa-solid fa-gears text-warning"></i> Đại tu Động cơ &amp; Hộp
                                                số
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item py-2 d-flex align-items-center gap-2"
                                                href="${pageContext.request.contextPath}/services">
                                                <i class="fa-solid fa-spray-can-sparkles text-success"></i> Đồng sơn
                                                phòng sấy &amp; Spa
                                            </a>
                                        </li>
                                    </ul>
                                </li>

                                <li class="nav-item">
                                    <a class="nav-link ${pageContext.request.servletPath == '/track' ? 'active' : ''}"
                                        href="${pageContext.request.contextPath}/track">
                                        <i class="fa-solid fa-magnifying-glass-location me-1"></i> Tra cứu xe
                                    </a>
                                </li>

                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/home#testimonials">
                                        <i class="fa-regular fa-star me-1"></i> Đánh giá
                                    </a>
                                </li>
                            </ul>

                            <!-- Right Actions: Hotline & Đăng nhập (Đã bỏ nút Đặt Lịch Hẹn) -->
                            <div class="d-flex align-items-center gap-3">


                                <c:choose>
                                    <c:when test="${not empty sessionScope.currentUser}">
                                        <c:if
                                            test="${sessionScope.currentUser.admin or sessionScope.currentUser.mechanic or sessionScope.currentUser.receptionist}">
                                            <a href="${pageContext.request.contextPath}/admin/dashboard"
                                                class="btn btn-sm btn-outline-light text-nowrap">
                                                <i class="fa-solid fa-gauge-high me-1"></i> Quản trị
                                            </a>
                                        </c:if>
                                        <c:if test="${sessionScope.currentUser.customer}">
                                            <a href="${pageContext.request.contextPath}/customer/dashboard"
                                                class="btn btn-sm btn-secondary text-nowrap">
                                                <i class="fa-regular fa-user me-1"></i>
                                                ${sessionScope.currentUser.fullName}
                                            </a>
                                        </c:if>
                                        <a href="${pageContext.request.contextPath}/logout"
                                            class="btn btn-sm btn-outline-danger" title="Đăng xuất">
                                            <i class="fa-solid fa-arrow-right-from-bracket"></i>
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/login"
                                            class="btn btn-outline-light btn-sm px-3 fw-semibold text-nowrap">
                                            <i class="fa-solid fa-right-to-bracket me-1"></i> Đăng nhập
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </nav>
                <main class="main-content">