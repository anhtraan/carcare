<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../includes/admin-navbar.jsp">
    <jsp:param name="title" value="Danh Sách Lệnh Sửa Chữa (Work Orders) - CareCar" />
</jsp:include>
<jsp:include page="../includes/admin-sidebar.jsp" />

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
    <div>
        <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--light-text);">Quản Lý Lệnh Sửa Chữa (Work Orders)</h1>
        <p style="color: var(--light-muted); font-size: 0.9rem;">Theo dõi quy trình tiếp nhận, chẩn đoán lỗi, điều phối kỹ thuật viên và tính toán chi phí</p>
    </div>
    <div>
        <a href="${pageContext.request.contextPath}/admin/repair-order-create" class="btn btn-accent">
            <i class="fa-solid fa-plus"></i> Tiếp Nhận Xe &amp; Tạo Phiếu Mới
        </a>
    </div>
</div>

<!-- Search & Status Filters -->
<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem;">
    <div style="display: flex; gap: 0.5rem; flex-wrap: wrap;">
        <a href="${pageContext.request.contextPath}/admin/repair-orders" class="btn btn-sm ${empty selectedStatus || selectedStatus == 'ALL' ? 'btn-primary' : 'btn-secondary'}">
            Tất cả
        </a>
        <a href="${pageContext.request.contextPath}/admin/repair-orders?status=PENDING_INSPECTION" class="btn btn-sm ${selectedStatus == 'PENDING_INSPECTION' ? 'btn-primary' : 'btn-secondary'}">
            Chờ kiểm tra
        </a>
        <a href="${pageContext.request.contextPath}/admin/repair-orders?status=DIAGNOSED_QUOTED" class="btn btn-sm ${selectedStatus == 'DIAGNOSED_QUOTED' ? 'btn-primary' : 'btn-secondary'}">
            Đã báo giá
        </a>
        <a href="${pageContext.request.contextPath}/admin/repair-orders?status=IN_PROGRESS" class="btn btn-sm ${selectedStatus == 'IN_PROGRESS' ? 'btn-primary' : 'btn-secondary'}">
            Đang sửa chữa
        </a>
        <a href="${pageContext.request.contextPath}/admin/repair-orders?status=COMPLETED_WAITING_PAYMENT" class="btn btn-sm ${selectedStatus == 'COMPLETED_WAITING_PAYMENT' ? 'btn-primary' : 'btn-secondary'}">
            Chờ thanh toán
        </a>
        <a href="${pageContext.request.contextPath}/admin/repair-orders?status=PAID_DELIVERED" class="btn btn-sm ${selectedStatus == 'PAID_DELIVERED' ? 'btn-primary' : 'btn-secondary'}">
            Đã giao xe
        </a>
    </div>

    <div style="max-width: 280px; width: 100%;">
        <input type="text" id="tableSearchInput" class="form-control" placeholder="Tìm biển số, tên, mã lệnh...">
    </div>
</div>

<div class="card">
    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th>Mã Lệnh</th>
                    <th>Biển Số &amp; Xe</th>
                    <th>Khách Hàng</th>
                    <th>Kỹ Thuật Viên</th>
                    <th>Thời Gian Vào</th>
                    <th style="text-align: right;">Tổng Chi Phí</th>
                    <th>Trạng Thái</th>
                    <th style="text-align: center;">Thao Tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${orders}" var="ord">
                    <tr>
                        <td><strong><c:out value="${ord.orderCode}" /></strong></td>
                        <td>
                            <span style="font-weight: 700; background: #e2e8f0; padding: 0.15rem 0.4rem; border-radius: 4px;"><c:out value="${ord.carLicensePlate}" /></span><br>
                            <small style="color: var(--light-muted);"><c:out value="${ord.carBrand}" /> <c:out value="${ord.carModel}" /></small>
                        </td>
                        <td>
                            <strong><c:out value="${ord.customerName}" /></strong><br>
                            <small style="color: var(--light-muted);"><i class="fa-solid fa-phone"></i> <c:out value="${ord.customerPhone}" /></small>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty ord.mechanicName}">
                                    <i class="fa-solid fa-wrench" style="color: var(--primary);"></i> <c:out value="${ord.mechanicName}" />
                                </c:when>
                                <c:otherwise>
                                    <span style="color: var(--light-muted); font-style: italic;">Chưa phân công</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><fmt:formatDate value="${ord.entryDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                        <td style="text-align: right; font-weight: 800; color: var(--primary);">
                            <fmt:formatNumber value="${ord.grandTotal}" pattern="#,###" /> ₫
                        </td>
                        <td>
                            <span class="badge ${ord.orderStatus == 'PAID_DELIVERED' ? 'badge-delivered' : (ord.orderStatus == 'COMPLETED_WAITING_PAYMENT' ? 'badge-success' : (ord.orderStatus == 'IN_PROGRESS' ? 'badge-primary' : 'badge-warning'))}">
                                ${ord.orderStatus}
                            </span>
                        </td>
                        <td style="text-align: center;">
                            <a href="${pageContext.request.contextPath}/admin/repair-order-detail?id=${ord.orderId}" class="btn btn-sm btn-primary">
                                <i class="fa-solid fa-pen-to-square"></i> Xử lý lệnh
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty orders}">
                    <tr>
                        <td colspan="8" style="text-align: center; color: var(--light-muted); padding: 2rem;">Không có lệnh sửa chữa nào phù hợp.</td>
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
