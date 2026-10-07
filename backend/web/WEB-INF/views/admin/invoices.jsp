<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../includes/admin-navbar.jsp">
    <jsp:param name="title" value="Quản Lý Hóa Đơn &amp; Doanh Thu - CareCar" />
</jsp:include>
<jsp:include page="../includes/admin-sidebar.jsp" />

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
    <div>
        <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--light-text);">Hóa Đơn &amp; Lịch Sử Thu Tiền</h1>
        <p style="color: var(--light-muted); font-size: 0.9rem;">Danh sách hóa đơn đã xuất cho các lệnh sửa chữa hoàn tất</p>
    </div>
</div>

<div class="card">
    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th>Mã Hóa Đơn</th>
                    <th>Lệnh Sửa Chữa</th>
                    <th>Khách Hàng</th>
                    <th>Biển Số Xe</th>
                    <th>Phương Thức</th>
                    <th>Ngày Thanh Toán</th>
                    <th style="text-align: right;">Số Tiền Thu</th>
                    <th style="text-align: center;">In Hóa Đơn</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${invoices}" var="inv">
                    <tr>
                        <td><strong>${inv.invoiceCode}</strong></td>
                        <td><a href="${pageContext.request.contextPath}/admin/repair-order-detail?id=${inv.orderId}"><strong>${inv.orderCode}</strong></a></td>
                        <td>${inv.customerName}</td>
                        <td><span style="font-weight: 700; background: #e2e8f0; padding: 0.15rem 0.4rem; border-radius: 4px;">${inv.licensePlate}</span></td>
                        <td><span class="badge badge-info">${inv.paymentMethod}</span></td>
                        <td><fmt:formatDate value="${inv.paymentDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                        <td style="text-align: right; font-weight: 800; color: var(--success); font-size: 1.05rem;">
                            <fmt:formatNumber value="${inv.amountPaid}" pattern="#,###" /> ₫
                        </td>
                        <td style="text-align: center;">
                            <a href="${pageContext.request.contextPath}/admin/invoice-detail?id=${inv.invoiceId}" class="btn btn-sm btn-secondary" title="Xem &amp; In hóa đơn">
                                <i class="fa-solid fa-print"></i> In Phiếu Thu
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty invoices}">
                    <tr>
                        <td colspan="8" style="text-align: center; color: var(--light-muted); padding: 2rem;">Chưa có hóa đơn nào được xuất.</td>
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
