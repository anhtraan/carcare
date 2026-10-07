<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../includes/admin-navbar.jsp">
    <jsp:param name="title" value="Quản Lý Lịch Hẹn Khách Hàng - CareCar" />
</jsp:include>
<jsp:include page="../includes/admin-sidebar.jsp" />

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
    <div>
        <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--light-text);">Quản Lý Lịch Hẹn Sửa Chữa</h1>
        <p style="color: var(--light-muted); font-size: 0.9rem;">Duyệt lịch hẹn online và chuyển đổi trực tiếp thành Lệnh sửa chữa (Work Order)</p>
    </div>
</div>

<c:if test="${param.msg == 'status_updated'}">
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Đã cập nhật trạng thái lịch hẹn!</div>
</c:if>

<!-- Status Filters -->
<div style="display: flex; gap: 0.5rem; margin-bottom: 1.5rem; flex-wrap: wrap;">
    <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-sm ${empty filterStatus || filterStatus == 'ALL' ? 'btn-primary' : 'btn-secondary'}">
        Tất cả
    </a>
    <a href="${pageContext.request.contextPath}/admin/appointments?status=PENDING" class="btn btn-sm ${filterStatus == 'PENDING' ? 'btn-primary' : 'btn-secondary'}">
        Chờ xác nhận
    </a>
    <a href="${pageContext.request.contextPath}/admin/appointments?status=CONFIRMED" class="btn btn-sm ${filterStatus == 'CONFIRMED' ? 'btn-primary' : 'btn-secondary'}">
        Đã xác nhận
    </a>
    <a href="${pageContext.request.contextPath}/admin/appointments?status=COMPLETED" class="btn btn-sm ${filterStatus == 'COMPLETED' ? 'btn-primary' : 'btn-secondary'}">
        Đã hoàn thành
    </a>
    <a href="${pageContext.request.contextPath}/admin/appointments?status=CANCELLED" class="btn btn-sm ${filterStatus == 'CANCELLED' ? 'btn-primary' : 'btn-secondary'}">
        Đã hủy
    </a>
</div>

<div class="card">
    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th>Khách Hàng</th>
                    <th>Biển Số &amp; Dòng Xe</th>
                    <th>Ngày Hẹn</th>
                    <th>Khung Giờ</th>
                    <th>Dịch Vụ Yêu Cầu</th>
                    <th>Ghi Chú</th>
                    <th>Trạng Thái</th>
                    <th style="text-align: center;">Thao Tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${appointments}" var="app">
                    <tr>
                        <td>
                            <strong>${app.customerName}</strong><br>
                            <small style="color: var(--light-muted);"><i class="fa-solid fa-phone"></i> ${app.phone}</small>
                        </td>
                        <td>
                            <span style="font-weight: 700; background: #e2e8f0; padding: 0.15rem 0.4rem; border-radius: 4px;">${app.licensePlate}</span><br>
                            <small style="color: var(--light-muted);">${app.carBrandModel}</small>
                        </td>
                        <td><strong><fmt:formatDate value="${app.appointmentDate}" pattern="dd/MM/yyyy" /></strong></td>
                        <td><span class="badge badge-info">${app.timeSlot}</span></td>
                        <td>${app.requestedService}</td>
                        <td><small style="color: var(--light-muted);">${app.notes != null ? app.notes : '—'}</small></td>
                        <td>
                            <span class="badge ${app.status == 'CONFIRMED' ? 'badge-info' : (app.status == 'COMPLETED' ? 'badge-success' : (app.status == 'CANCELLED' ? 'badge-danger' : 'badge-warning'))}">
                                ${app.status}
                            </span>
                        </td>
                        <td style="text-align: center;">
                            <div style="display: inline-flex; gap: 0.35rem;">
                                <c:if test="${app.status == 'PENDING' or app.status == 'CONFIRMED'}">
                                    <form action="${pageContext.request.contextPath}/admin/appointments" method="POST" style="display: inline;">
                                        <input type="hidden" name="action" value="convertToOrder">
                                        <input type="hidden" name="appointmentId" value="${app.appointmentId}">
                                        <button type="submit" class="btn btn-sm btn-accent" title="Tạo Lệnh Sửa Chữa (Tiếp nhận xe)">
                                            <i class="fa-solid fa-file-invoice"></i> Tiếp nhận xe
                                        </button>
                                    </form>
                                </c:if>
                                <c:if test="${app.status == 'PENDING'}">
                                    <form action="${pageContext.request.contextPath}/admin/appointments" method="POST" style="display: inline;">
                                        <input type="hidden" name="action" value="updateStatus">
                                        <input type="hidden" name="newStatus" value="CANCELLED">
                                        <input type="hidden" name="appointmentId" value="${app.appointmentId}">
                                        <button type="submit" class="btn btn-sm btn-danger" title="Hủy lịch" onclick="return confirm('Bạn có chắc muốn hủy lịch hẹn này?');">
                                            <i class="fa-solid fa-xmark"></i>
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty appointments}">
                    <tr>
                        <td colspan="8" style="text-align: center; color: var(--light-muted); padding: 2rem;">Không có lịch hẹn nào.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

</main>
</div>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
