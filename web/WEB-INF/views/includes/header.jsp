<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.title != null ? param.title : 'CareCar - Trung Tâm Chăm Sóc & Sửa Chữa Ô Tô Cao Cấp'}</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Main Style -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

<header class="navbar">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/home" class="brand-logo">
            <div class="logo-icon"><i class="fa-solid fa-screwdriver-wrench"></i></div>
            <span>CARE<span class="highlight">CAR</span></span>
        </a>

        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/home" class="${pageContext.request.servletPath == '/home' || pageContext.request.servletPath == '' ? 'active' : ''}"><i class="fa-solid fa-house"></i> Trang chủ</a></li>
            <li><a href="${pageContext.request.contextPath}/services" class="${pageContext.request.servletPath == '/services' ? 'active' : ''}"><i class="fa-solid fa-list-check"></i> Bảng giá dịch vụ</a></li>
            <li><a href="${pageContext.request.contextPath}/booking" class="${pageContext.request.servletPath == '/booking' ? 'active' : ''}"><i class="fa-regular fa-calendar-check"></i> Đặt lịch online</a></li>
            <li><a href="${pageContext.request.contextPath}/track" class="${pageContext.request.servletPath == '/track' ? 'active' : ''}"><i class="fa-solid fa-magnifying-glass-location"></i> Tra cứu tiến độ</a></li>
        </ul>

        <div class="nav-actions">
            <c:choose>
                <c:when test="${not empty sessionScope.currentUser}">
                    <c:if test="${sessionScope.currentUser.admin or sessionScope.currentUser.mechanic or sessionScope.currentUser.receptionist}">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-sm btn-dark">
                            <i class="fa-solid fa-gauge-high"></i> Quản trị
                        </a>
                    </c:if>
                    <c:if test="${sessionScope.currentUser.customer}">
                        <a href="${pageContext.request.contextPath}/customer/dashboard" class="btn btn-sm btn-secondary">
                            <i class="fa-regular fa-user"></i> ${sessionScope.currentUser.fullName}
                        </a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-outline-light" title="Đăng xuất">
                        <i class="fa-solid fa-arrow-right-from-bracket"></i>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-sm btn-outline-light">
                        <i class="fa-solid fa-right-to-bracket"></i> Đăng nhập
                    </a>
                    <a href="${pageContext.request.contextPath}/booking" class="btn btn-sm btn-accent">
                        <i class="fa-solid fa-bolt"></i> Đặt lịch ngay
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>
<main class="main-content">
