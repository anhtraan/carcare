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
    <div>
        <button type="button" class="btn btn-primary" onclick="openCreateInvoiceModal();">
            <i class="fa-solid fa-receipt"></i> Tạo Phiếu Thu Mới
        </button>
    </div>
</div>

<c:if test="${param.msg == 'paid_success'}">
    <div class="alert alert-success" style="display: flex; align-items: center; gap: 0.5rem; border-left: 4px solid #10b981; margin-bottom: 1.5rem;">
        <i class="fa-solid fa-circle-check" style="font-size: 1.2rem;"></i>
        <div><strong>Thành công!</strong> Đã tạo phiếu thu và quyết toán lệnh sửa chữa.</div>
    </div>
</c:if>
<c:if test="${param.msg == 'already_paid'}">
    <div class="alert alert-warning" style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 1.5rem;">
        <i class="fa-solid fa-triangle-exclamation" style="font-size: 1.2rem;"></i>
        <div>Lệnh sửa chữa này đã được xuất phiếu thu thanh toán từ trước!</div>
    </div>
</c:if>
<c:if test="${param.error == 'invalid_order'}">
    <div class="alert alert-danger" style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 1.5rem;">
        <i class="fa-solid fa-circle-xmark" style="font-size: 1.2rem;"></i>
        <div>Vui lòng chọn lệnh sửa chữa hợp lệ để lập phiếu thu!</div>
    </div>
</c:if>
<c:if test="${param.error == 'order_not_found'}">
    <div class="alert alert-danger" style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 1.5rem;">
        <i class="fa-solid fa-circle-xmark" style="font-size: 1.2rem;"></i>
        <div>Không tìm thấy thông tin lệnh sửa chữa cần quyết toán!</div>
    </div>
</c:if>
<c:if test="${param.error == 'create_failed'}">
    <div class="alert alert-danger" style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 1.5rem;">
        <i class="fa-solid fa-circle-xmark" style="font-size: 1.2rem;"></i>
        <div>Không thể tạo phiếu thu. Vui lòng kiểm tra lại thông tin lệnh sửa chữa!</div>
    </div>
</c:if>

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
                        <td><strong><c:out value="${inv.invoiceCode}" /></strong></td>
                        <td><a href="${pageContext.request.contextPath}/admin/repair-order-detail?id=${inv.orderId}"><strong><c:out value="${inv.orderCode}" /></strong></a></td>
                        <td><c:out value="${inv.customerName}" /></td>
                        <td><span style="font-weight: 700; background: #e2e8f0; padding: 0.15rem 0.4rem; border-radius: 4px;"><c:out value="${inv.licensePlate}" /></span></td>
                        <td><span class="badge badge-info"><c:out value="${inv.paymentMethod}" /></span></td>
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

<!-- Modal: Tạo Phiếu Thu Mới -->
<div id="createInvoiceModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 9999; align-items: center; justify-content: center; backdrop-filter: blur(2px);">
    <div class="card" style="width: 550px; max-width: 95%; background: #fff; border-radius: 12px; box-shadow: 0 20px 40px rgba(0,0,0,0.3); max-height: 90vh; overflow-y: auto;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.25rem;">
            <h3 style="font-size: 1.25rem; font-weight: 800; color: var(--success); margin: 0;">
                <i class="fa-solid fa-file-invoice-dollar"></i> Lập Phiếu Thu Mới
            </h3>
            <button type="button" onclick="closeCreateInvoiceModal();" style="border: none; background: transparent; font-size: 1.25rem; cursor: pointer; color: #94a3b8;">&times;</button>
        </div>

        <c:choose>
            <c:when test="${not empty unpaidOrders}">
                <form action="${pageContext.request.contextPath}/admin/checkout" method="POST">
                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                    <input type="hidden" name="action" value="checkout">

                    <div class="form-group" style="margin-bottom: 1rem;">
                        <label class="form-label" style="font-weight: 700;">Chọn Lệnh Sửa Chữa Cần Quyết Toán (*)</label>
                        <select id="invoiceOrderSelect" name="orderId" class="form-select" required onchange="onInvoiceOrderChange();">
                            <option value="">-- Chọn lệnh sửa chữa --</option>
                            <c:forEach items="${unpaidOrders}" var="o">
                                <option value="${o.orderId}" data-total="${o.grandTotal != null ? o.grandTotal : 0}" data-code="${o.orderCode}" data-plate="${o.carLicensePlate}" data-cust="${o.customerName}">
                                    [<c:out value="${o.orderCode}" />] <c:out value="${o.carLicensePlate}" /> - <c:out value="${o.customerName}" /> (<fmt:formatNumber value="${o.grandTotal}" pattern="#,###" /> ₫)
                                </option>
                            </c:forEach>
                        </select>
                        <small style="color: var(--light-muted); display: block; margin-top: 0.25rem;">Chỉ hiển thị các lệnh sửa chữa chưa xuất hóa đơn quyết toán.</small>
                    </div>

                    <div id="orderTotalPreviewBox" style="display: none; background: #f8fafc; padding: 1.25rem; border-radius: var(--radius-md); margin-bottom: 1rem; text-align: center; border: 1.5px solid #e2e8f0;">
                        <div style="font-size: 0.9rem; color: #64748b; margin-bottom: 0.25rem;">Số tiền cần thanh toán cho xe <strong id="previewPlate"></strong>:</div>
                        <strong id="previewTotalAmount" style="color: #ff5a1f; font-size: 1.6rem;">0 ₫</strong>
                    </div>

                    <div class="form-group" style="margin-bottom: 1rem;">
                        <label class="form-label" style="font-weight: 700;">Hình thức thanh toán (*)</label>
                        <select name="paymentMethod" class="form-select" required>
                            <option value="CASH">Tiền mặt</option>
                            <option value="BANK_TRANSFER" selected>Chuyển khoản Ngân hàng (QR Code)</option>
                            <option value="CREDIT_CARD">Thẻ tín dụng / Quẹt thẻ POS</option>
                            <option value="VNPAY">Ví điện tử VNPAY</option>
                        </select>
                    </div>

                    <div class="form-group" style="margin-bottom: 1.25rem;">
                        <label class="form-label" style="font-weight: 700;">Ghi chú thu tiền</label>
                        <input type="text" name="notes" class="form-control" placeholder="Đã nhận đủ tiền từ khách...">
                    </div>

                    <div style="text-align: right; border-top: 1px solid #f1f5f9; padding-top: 1rem; display: flex; justify-content: flex-end; gap: 0.75rem;">
                        <button type="button" class="btn btn-secondary" onclick="closeCreateInvoiceModal();">Hủy bỏ</button>
                        <button type="submit" class="btn btn-success"><i class="fa-solid fa-check"></i> Xác Nhận Tạo Phiếu Thu</button>
                    </div>
                </form>
            </c:when>
            <c:otherwise>
                <div style="text-align: center; padding: 2rem 1rem; color: #64748b;">
                    <i class="fa-solid fa-circle-check" style="font-size: 2.5rem; color: #10b981; margin-bottom: 1rem;"></i>
                    <p style="font-size: 1rem; font-weight: 600; margin-bottom: 0.5rem;">Tất cả lệnh sửa chữa hiện tại đều đã được quyết toán!</p>
                    <p style="font-size: 0.875rem; color: #94a3b8;">Không có lệnh sửa chữa nào đang chờ thanh toán.</p>
                    <div style="margin-top: 1.5rem;">
                        <button type="button" class="btn btn-secondary" onclick="closeCreateInvoiceModal();">Đóng</button>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

</main>
</div>
<script>
function openCreateInvoiceModal() {
    const modal = document.getElementById('createInvoiceModal');
    if (modal) {
        modal.style.display = 'flex';
        onInvoiceOrderChange();
    }
}

function closeCreateInvoiceModal() {
    const modal = document.getElementById('createInvoiceModal');
    if (modal) {
        modal.style.display = 'none';
    }
}

function onInvoiceOrderChange() {
    const sel = document.getElementById('invoiceOrderSelect');
    const previewBox = document.getElementById('orderTotalPreviewBox');
    const previewPlate = document.getElementById('previewPlate');
    const previewTotal = document.getElementById('previewTotalAmount');

    if (!sel || !previewBox) return;

    const opt = sel.selectedOptions && sel.selectedOptions[0];
    if (opt && opt.value) {
        const total = Number(opt.getAttribute('data-total')) || 0;
        const plate = opt.getAttribute('data-plate') || '';
        if (previewPlate) previewPlate.textContent = plate;
        if (previewTotal) {
            previewTotal.textContent = new Intl.NumberFormat('vi-VN').format(Math.max(0, Math.round(total))) + ' ₫';
        }
        previewBox.style.display = 'block';
    } else {
        previewBox.style.display = 'none';
    }
}
</script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
