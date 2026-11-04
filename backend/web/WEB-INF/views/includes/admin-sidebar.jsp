<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="admin-sidebar no-print">
    <div style="font-size: 0.75rem; font-weight: 700; color: #64748b; text-transform: uppercase; margin-bottom: 0.75rem; padding-left: 0.75rem; letter-spacing: 0.5px;">
        Vận Hành Xưởng
    </div>
    <ul class="sidebar-menu">
        <li>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="${pageContext.request.servletPath == '/admin/dashboard' ? 'active' : ''}">
                <i class="fa-solid fa-chart-pie"></i> Bảng điều khiển
            </a>
        </li>
        
        <!-- Lịch hẹn & Tiếp nhận xe mới: Dành cho Admin và Cố vấn dịch vụ/Lễ tân -->
        <c:if test="${sessionScope.currentUser.admin || sessionScope.currentUser.receptionist}">
            <li>
                <a href="${pageContext.request.contextPath}/admin/appointments" class="${pageContext.request.servletPath == '/admin/appointments' ? 'active' : ''}">
                    <i class="fa-regular fa-calendar-check"></i> Lịch hẹn khách hàng
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/repair-order-create" class="${pageContext.request.servletPath == '/admin/repair-order-create' ? 'active' : ''}">
                    <i class="fa-solid fa-plus-circle" style="color: var(--accent);"></i> Tiếp nhận xe mới
                </a>
            </li>
        </c:if>

        <!-- Lệnh sửa chữa: Cả Thợ máy, Lễ tân và Admin đều thao tác -->
        <li>
            <a href="${pageContext.request.contextPath}/admin/repair-orders" class="${pageContext.request.servletPath == '/admin/repair-orders' || pageContext.request.servletPath == '/admin/repair-order-detail' ? 'active' : ''}">
                <i class="fa-solid fa-file-invoice"></i> Lệnh sửa chữa (Work Order)
            </a>
        </li>
    </ul>

    <div style="font-size: 0.75rem; font-weight: 700; color: #64748b; text-transform: uppercase; margin: 1.5rem 0 0.75rem; padding-left: 0.75rem; letter-spacing: 0.5px;">
        Thanh Toán &amp; Kho
    </div>
    <ul class="sidebar-menu">
        <!-- Hóa đơn & Quyết toán: CHỈ Admin và Lễ tân (Thợ máy không có quyền xem/quyết toán) -->
        <c:if test="${sessionScope.currentUser.admin || sessionScope.currentUser.receptionist}">
            <li>
                <a href="${pageContext.request.contextPath}/admin/invoices" class="${pageContext.request.servletPath == '/admin/invoices' || pageContext.request.servletPath == '/admin/invoice-detail' ? 'active' : ''}">
                    <i class="fa-solid fa-receipt"></i> Hóa đơn &amp; Doanh thu
                </a>
            </li>
        </c:if>
        
        <!-- Kho phụ tùng & Danh mục dịch vụ: Thợ máy có quyền xem để xuất kho & kê khai -->
        <li>
            <a href="${pageContext.request.contextPath}/admin/spare-parts" class="${pageContext.request.servletPath == '/admin/spare-parts' ? 'active' : ''}">
                <i class="fa-solid fa-boxes-stacked"></i> Kho phụ tùng ô tô
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/services" class="${pageContext.request.servletPath == '/admin/services' ? 'active' : ''}">
                <i class="fa-solid fa-list-check"></i> Danh mục dịch vụ
            </a>
        </li>
    </ul>

    <div style="font-size: 0.75rem; font-weight: 700; color: #64748b; text-transform: uppercase; margin: 1.5rem 0 0.75rem; padding-left: 0.75rem; letter-spacing: 0.5px;">
        Quản Trị Hệ Thống
    </div>
    <ul class="sidebar-menu">
        <!-- Danh bạ khách hàng: CHỈ Admin và Lễ tân (Thợ máy không xem danh bạ khách hàng) -->
        <c:if test="${sessionScope.currentUser.admin || sessionScope.currentUser.receptionist}">
            <li>
                <a href="${pageContext.request.contextPath}/admin/customers" class="${pageContext.request.servletPath == '/admin/customers' ? 'active' : ''}">
                    <i class="fa-solid fa-users"></i> Khách hàng &amp; Xe
                </a>
            </li>
        </c:if>
        <!-- Quản lý nhân sự: CHỈ ADMIN -->
        <c:if test="${sessionScope.currentUser.admin}">
            <li>
                <a href="${pageContext.request.contextPath}/admin/staff" class="${pageContext.request.servletPath == '/admin/staff' ? 'active' : ''}">
                    <i class="fa-solid fa-id-card-clip"></i> Quản lý nhân sự
                </a>
            </li>
        </c:if>
    </ul>
</aside>

<main class="admin-body">
