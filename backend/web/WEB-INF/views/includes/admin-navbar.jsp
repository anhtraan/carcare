<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.title != null ? param.title : 'CareCar Quản Trị Xưởng'}</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body style="background: #f1f5f9;">

<header class="navbar no-print" style="background: #0f172a; border-bottom: 1px solid #1e293b;">
    <div class="nav-container" style="max-width: 100%;">
        <div style="display: flex; align-items: center; gap: 1.5rem;">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="brand-logo">
                <div class="logo-icon"><i class="fa-solid fa-wrench"></i></div>
                <span>CARE<span class="highlight">CAR</span> <span style="font-size: 0.75rem; font-weight: 600; color: #94a3b8; background: #1e293b; padding: 0.2rem 0.5rem; border-radius: 4px; margin-left: 0.5rem;">PORTAL</span></span>
            </a>
            <a href="${pageContext.request.contextPath}/home" target="_blank" class="btn btn-sm btn-dark" style="font-size: 0.8rem;">
                <i class="fa-solid fa-arrow-up-right-from-square"></i> Xem Web Khách Hàng
            </a>
        </div>

        <div class="nav-actions">
            <div style="display: flex; align-items: center; gap: 0.75rem; background: #1e293b; padding: 0.35rem 0.85rem; border-radius: 8px;">
                <i class="fa-solid fa-circle-user" style="font-size: 1.25rem; color: var(--accent);"></i>
                <div style="line-height: 1.2;">
                    <div style="font-size: 0.875rem; font-weight: 700; color: #fff;">${sessionScope.currentUser.fullName}</div>
                    <div style="font-size: 0.75rem; color: #94a3b8;">${sessionScope.currentUser.role}</div>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-outline-light" title="Đăng xuất">
                <i class="fa-solid fa-arrow-right-from-bracket"></i> Thoát
            </a>
        </div>
    </div>
</header>

<div class="admin-layout">
