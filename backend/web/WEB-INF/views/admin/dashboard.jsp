<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../includes/admin-navbar.jsp">
    <jsp:param name="title" value="Bảng Điều Khiển Gara - CareCar" />
</jsp:include>
<jsp:include page="../includes/admin-sidebar.jsp" />

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
    <div>
        <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--light-text);">Bảng Tổng Quan Hoạt Động Xưởng</h1>
        <p style="color: var(--light-muted); font-size: 0.9rem;">Thống kê theo thời gian thực - Hôm nay: <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()) %></p>
    </div>
    <div style="display: flex; gap: 0.75rem;">
        <a href="${pageContext.request.contextPath}/admin/repair-order-create" class="btn btn-accent">
            <i class="fa-solid fa-plus"></i> Tiếp Nhận Xe Mới
        </a>
    </div>
</div>

<!-- 4 Top KPI Stat Cards -->
<div class="grid-4" style="margin-bottom: 2rem;">
    <div class="stat-widget">
        <div class="stat-icon primary"><i class="fa-solid fa-money-bill-wave"></i></div>
        <div class="stat-info">
            <h4>Doanh Thu Tháng Này</h4>
            <div class="stat-value" style="color: var(--primary);">
                <fmt:formatNumber value="${stats.monthlyRevenue}" pattern="#,###" /> ₫
            </div>
        </div>
    </div>

    <div class="stat-widget">
        <div class="stat-icon warning"><i class="fa-solid fa-calendar-check"></i></div>
        <div class="stat-info">
            <h4>Lịch Hẹn Hôm Nay</h4>
            <div class="stat-value" style="color: var(--accent);">
                ${stats.todayAppointments} xe
            </div>
        </div>
    </div>

    <div class="stat-widget">
        <div class="stat-icon success"><i class="fa-solid fa-car-tunnel"></i></div>
        <div class="stat-info">
            <h4>Xe Đang Sửa Tại Xưởng</h4>
            <div class="stat-value" style="color: var(--success);">
                ${stats.activeRepairOrders} xe
            </div>
        </div>
    </div>

    <div class="stat-widget">
        <div class="stat-icon danger"><i class="fa-solid fa-triangle-exclamation"></i></div>
        <div class="stat-info">
            <h4>Phụ Tùng Sắp Hết</h4>
            <div class="stat-value" style="color: var(--danger);">
                ${stats.lowStockCount} loại
            </div>
        </div>
    </div>
</div>

<div style="display: grid; grid-template-columns: 2fr 1.2fr; gap: 2rem; margin-bottom: 2rem;">
    <!-- Recent Repair Orders Table -->
    <div class="card">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.25rem;">
            <h3 style="font-size: 1.15rem; font-weight: 700;"><i class="fa-solid fa-wrench" style="color: var(--primary);"></i> Lệnh Sửa Chữa Gần Nhất</h3>
            <a href="${pageContext.request.contextPath}/admin/repair-orders" class="btn btn-sm btn-secondary">Xem tất cả</a>
        </div>

        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Mã Lệnh</th>
                        <th>Biển Số Xe</th>
                        <th>Khách Hàng</th>
                        <th>Tổng Tiền</th>
                        <th>Trạng Thái</th>
                        <th style="text-align: center;">Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${stats.recentOrders}" var="ord">
                        <tr>
                            <td><strong>${ord.orderCode}</strong></td>
                            <td><span style="font-weight: 700; background: #e2e8f0; padding: 0.15rem 0.4rem; border-radius: 4px;">${ord.carLicensePlate}</span></td>
                            <td>${ord.customerName}</td>
                            <td style="font-weight: 700; color: var(--primary);">
                                <fmt:formatNumber value="${ord.grandTotal}" pattern="#,###" /> ₫
                            </td>
                            <td>
                                <span class="badge ${ord.orderStatus == 'PAID_DELIVERED' ? 'badge-delivered' : (ord.orderStatus == 'COMPLETED_WAITING_PAYMENT' ? 'badge-success' : (ord.orderStatus == 'IN_PROGRESS' ? 'badge-primary' : 'badge-warning'))}">
                                    ${ord.orderStatus}
                                </span>
                            </td>
                            <td style="text-align: center;">
                                <a href="${pageContext.request.contextPath}/admin/repair-order-detail?id=${ord.orderId}" class="btn btn-sm btn-secondary" title="Chi tiết lệnh">
                                    <i class="fa-solid fa-arrow-right"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty stats.recentOrders}">
                        <tr>
                            <td colspan="6" style="text-align: center; color: var(--light-muted); padding: 2rem;">Chưa có dữ liệu lệnh sửa chữa.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Right Column: Today Appointments & Low Stock Alert -->
    <div style="display: flex; flex-direction: column; gap: 1.5rem;">
        <!-- Today Appointments Widget -->
        <div class="card">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                <h3 style="font-size: 1.1rem; font-weight: 700;"><i class="fa-regular fa-calendar-check" style="color: var(--accent);"></i> Lịch Hẹn Hôm Nay</h3>
                <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-sm btn-secondary">Xem lịch</a>
            </div>

            <c:forEach items="${stats.todayAppointmentsList}" var="app">
                <div style="background: #f8fafc; border-left: 3px solid var(--accent); padding: 0.75rem 1rem; border-radius: 4px; margin-bottom: 0.75rem;">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <strong style="font-size: 0.925rem;">${app.customerName} - ${app.licensePlate}</strong>
                        <span class="badge badge-warning" style="font-size: 0.7rem;">${app.timeSlot}</span>
                    </div>
                    <p style="font-size: 0.825rem; color: var(--light-muted); margin-top: 0.25rem;">
                        ${app.requestedService}
                    </p>
                </div>
            </c:forEach>
            <c:if test="${empty stats.todayAppointmentsList}">
                <p style="font-size: 0.85rem; color: var(--light-muted); text-align: center; padding: 1rem 0;">Không có lịch hẹn nào hôm nay.</p>
            </c:if>
        </div>

        <!-- Low Stock Alert Widget -->
        <div class="card">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                <h3 style="font-size: 1.1rem; font-weight: 700; color: var(--danger);"><i class="fa-solid fa-triangle-exclamation"></i> Cảnh Báo Hết Phụ Tùng</h3>
                <a href="${pageContext.request.contextPath}/admin/spare-parts?filter=low_stock" class="btn btn-sm btn-secondary">Kho</a>
            </div>

            <c:forEach items="${stats.lowStockParts}" var="part">
                <div style="display: flex; justify-content: space-between; align-items: center; padding: 0.6rem 0; border-bottom: 1px solid var(--light-border);">
                    <div>
                        <div style="font-weight: 600; font-size: 0.875rem;">${part.partName}</div>
                        <small style="color: var(--light-muted);">Mã: ${part.partCode}</small>
                    </div>
                    <span class="badge badge-danger">Tồn: ${part.quantityInStock} ${part.unit}</span>
                </div>
            </c:forEach>
            <c:if test="${empty stats.lowStockParts}">
                <p style="font-size: 0.85rem; color: var(--success); text-align: center; padding: 1rem 0;"><i class="fa-solid fa-circle-check"></i> Kho phụ tùng đang đảm bảo an toàn.</p>
            </c:if>
        </div>
    </div>
</div>

</main>
</div>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
