<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${param.title != null ? param.title : 'CareCar - Hệ Thống Dịch Vụ & Sửa Chữa Ô Tô Tiêu Chuẩn 5 Sao'}" escapeXml="true" /></title>
    <!-- Google Fonts: Barlow Condensed & Inter for HyperAuto Style -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:ital,wght@0,500;0,600;0,700;0,800;0,900;1,700&family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
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
<body class="hyper-theme">

    <!-- Header / Navigation Bar in HyperAuto Style -->
    <nav class="navbar navbar-expand-xl navbar-dark sticky-top hyper-navbar" id="mainNavbar">
        <div class="container-xl">
            <!-- Brand Logo -->
            <a class="navbar-brand d-flex align-items-center gap-2 text-nowrap" href="${pageContext.request.contextPath}/home">
                <div class="logo-box rounded-2 d-flex align-items-center justify-content-center shadow-sm">
                    <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="CareCar Logo" class="brand-logo-img">
                </div>
                <span class="brand-display-name">CARE<span class="text-orange">CAR</span></span>
            </a>

            <!-- Mobile Toggler -->
            <button class="navbar-toggler border-0 shadow-none px-2" type="button" data-bs-toggle="collapse"
                data-bs-target="#carecarNavbar" aria-controls="carecarNavbar" aria-expanded="false"
                aria-label="Toggle navigation">
                <i class="fa-solid fa-bars fs-4 text-light"></i>
            </button>

            <!-- Navbar Links -->
            <div class="collapse navbar-collapse" id="carecarNavbar">
                <ul class="navbar-nav mx-auto mb-2 mb-xl-0 align-items-xl-center gap-xl-1">
                    <li class="nav-item">
                        <a class="nav-link hyper-nav-link ${pageContext.request.servletPath == '/home' || pageContext.request.servletPath == '' ? 'active' : ''}"
                            href="${pageContext.request.contextPath}/home">
                            Trang chủ
                        </a>
                    </li>

                    <!-- Dịch vụ Dropdown -->
                    <li class="nav-item dropdown">
                        <a class="nav-link hyper-nav-link dropdown-toggle ${pageContext.request.servletPath == '/services' ? 'active' : ''}"
                            href="${pageContext.request.contextPath}/services" id="servicesDropdown"
                            role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            Dịch vụ
                        </a>
                        <ul class="dropdown-menu dropdown-menu-dark hyper-dropdown shadow-lg" aria-labelledby="servicesDropdown">
                            <li>
                                <a class="dropdown-item py-2 d-flex align-items-center gap-2 fw-bold text-orange"
                                    href="${pageContext.request.contextPath}/services">
                                    <i class="fa-solid fa-layer-group text-orange"></i> Xem Tất Cả Dịch Vụ &amp; Bảng Giá
                                </a>
                            </li>
                            <li><hr class="dropdown-divider hyper-divider my-1"></li>
                            <li>
                                <a class="dropdown-item py-2 d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/services">
                                    <i class="fa-solid fa-oil-can text-primary"></i> Bảo dưỡng định kỳ đa cấp độ
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item py-2 d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/services">
                                    <i class="fa-solid fa-arrows-to-dot text-info"></i> Cân chỉnh thước lái 3D Hunter
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item py-2 d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/services">
                                    <i class="fa-solid fa-snowflake text-info"></i> Điện &amp; Vệ sinh điều hòa nội soi
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item py-2 d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/services">
                                    <i class="fa-solid fa-gears text-warning"></i> Đại tu Động cơ &amp; Hộp số
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item py-2 d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/services">
                                    <i class="fa-solid fa-spray-can-sparkles text-success"></i> Đồng sơn phòng sấy &amp; Spa
                                </a>
                            </li>
                        </ul>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link hyper-nav-link" href="${pageContext.request.contextPath}/home#process">
                            Quy trình
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link hyper-nav-link" href="${pageContext.request.contextPath}/home#pricing">
                            Bảng giá
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link hyper-nav-link ${pageContext.request.servletPath == '/track' ? 'active' : ''}"
                            href="${pageContext.request.contextPath}/track">
                            Tra cứu xe
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link hyper-nav-link" href="${pageContext.request.contextPath}/home#testimonials">
                            Đánh giá
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link hyper-nav-link" href="${pageContext.request.contextPath}/home#faq">
                            Hỏi đáp
                        </a>
                    </li>
                </ul>

                <!-- Right Actions: Đặt lịch & Đăng nhập -->
                <div class="d-flex align-items-center gap-2 pt-2 pt-xl-0">
                    <!-- Nút Đặt lịch phong cách HyperAuto (Cam nổi bật) -->
                    <a href="${pageContext.request.contextPath}/booking" class="btn btn-hyper-orange text-nowrap d-inline-flex align-items-center gap-2">
                        <i class="fa-regular fa-calendar-check"></i>
                        <span>Đặt Lịch Hẹn</span>
                    </a>

                    <c:choose>
                        <c:when test="${not empty sessionScope.currentUser}">
                            <c:if test="${sessionScope.currentUser.admin or sessionScope.currentUser.mechanic or sessionScope.currentUser.receptionist}">
                                <a href="${pageContext.request.contextPath}/admin/dashboard"
                                    class="btn btn-hyper-ghost text-nowrap d-inline-flex align-items-center gap-1.5" title="Bảng quản trị">
                                    <i class="fa-solid fa-gauge-high text-orange"></i>
                                    <span>Quản trị</span>
                                </a>
                            </c:if>
                            <c:if test="${sessionScope.currentUser.customer}">
                                <a href="${pageContext.request.contextPath}/customer/dashboard"
                                    class="btn btn-hyper-ghost text-nowrap d-inline-flex align-items-center gap-1.5">
                                    <i class="fa-regular fa-user text-orange"></i>
                                    <span><c:out value="${sessionScope.currentUser.fullName}" /></span>
                                </a>
                            </c:if>
                            <form action="${pageContext.request.contextPath}/logout" method="POST" style="margin: 0; display: inline;">
                                <input type="hidden" name="csrfToken" value="${csrfToken}">
                                <button type="submit" class="btn btn-hyper-ghost text-danger px-2.5" title="Đăng xuất" style="background: none; border: none; cursor: pointer;">
                                    <i class="fa-solid fa-arrow-right-from-bracket"></i>
                                </button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login"
                                class="btn btn-hyper-ghost text-nowrap d-inline-flex align-items-center gap-1.5">
                                <i class="fa-solid fa-right-to-bracket text-light"></i>
                                <span>Đăng nhập</span>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>
    <main class="main-content">
