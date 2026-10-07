<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="cc" uri="/WEB-INF/tlds/carecar.tld" %>

<jsp:include page="../includes/admin-navbar.jsp">
    <jsp:param name="title" value="Chi Tiết Lệnh Sửa Chữa ${order.orderCode} - CareCar" />
</jsp:include>
<jsp:include page="../includes/admin-sidebar.jsp" />

<!-- Header Actions -->
<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem;">
    <div style="display: flex; align-items: center; gap: 1rem;">
        <a href="${pageContext.request.contextPath}/admin/repair-orders" class="btn btn-sm btn-secondary">
            <i class="fa-solid fa-arrow-left"></i> Quay lại
        </a>
        <h1 style="font-size: 1.75rem; font-weight: 800; color: var(--light-text); margin-bottom: 0;">
            Phiếu Sửa Chữa: <span style="color: var(--primary);">${order.orderCode}</span>
        </h1>
        <span class="badge ${order.orderStatus == 'PAID_DELIVERED' ? 'badge-delivered' : (order.orderStatus == 'COMPLETED_WAITING_PAYMENT' ? 'badge-success' : (order.orderStatus == 'IN_PROGRESS' ? 'badge-primary' : 'badge-warning'))}" style="font-size: 0.85rem;">
            ${order.orderStatus}
        </span>
    </div>

    <div style="display: flex; gap: 0.75rem;">
        <c:if test="${empty invoice}">
            <!-- Checkout / Pay Button -->
            <button type="button" class="btn btn-success" onclick="document.getElementById('checkoutModal').style.display='flex';">
                <i class="fa-solid fa-cash-register"></i> Quyết Toán &amp; Xuất Hóa Đơn
            </button>
        </c:if>
        <c:if test="${not empty invoice}">
            <a href="${pageContext.request.contextPath}/admin/invoice-detail?id=${invoice.invoiceId}" class="btn btn-primary">
                <i class="fa-solid fa-receipt"></i> Xem Hóa Đơn (${invoice.invoiceCode})
            </a>
        </c:if>
    </div>
</div>

<c:if test="${param.msg == 'service_added'}">
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Đã thêm dịch vụ vào phiếu sửa chữa!</div>
</c:if>
<c:if test="${param.msg == 'service_removed'}">
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Đã xóa dịch vụ khỏi phiếu!</div>
</c:if>
<c:if test="${param.msg == 'part_added'}">
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Đã xuất phụ tùng từ kho và thêm vào phiếu!</div>
</c:if>
<c:if test="${param.msg == 'part_removed'}">
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Đã hoàn trả phụ tùng về kho!</div>
</c:if>
<c:if test="${param.msg == 'status_updated'}">
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Cập nhật trạng thái lệnh thành công!</div>
</c:if>
<c:if test="${param.msg == 'diagnosis_updated'}">
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Đã lưu kết luận kiểm tra &amp; phân công thợ!</div>
</c:if>
<c:if test="${param.msg == 'finance_updated'}">
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Đã cập nhật chiết khấu và thuế VAT!</div>
</c:if>

<div style="display: grid; grid-template-columns: 2fr 1fr; gap: 1.75rem;">
    <!-- LEFT COLUMN: Car Info, Diagnosis, Services, Spare Parts -->
    <div>
        <!-- Car & Customer Info Card -->
        <div class="card" style="margin-bottom: 1.5rem; background: #fff;">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
                <div>
                    <h4 style="font-size: 0.95rem; color: var(--primary); margin-bottom: 0.5rem;"><i class="fa-solid fa-car"></i> Thông Tin Phương Tiện</h4>
                    <div style="line-height: 1.6; font-size: 0.925rem;">
                        <div><strong>Biển số:</strong> <span style="font-weight: 800; background: #f1f5f9; padding: 0.1rem 0.5rem; border-radius: 4px;">${order.carLicensePlate}</span></div>
                        <div><strong>Xe:</strong> ${order.carBrand} ${order.carModel} (${order.carColor})</div>
                        <div><strong>ODO Tiếp nhận:</strong> <fmt:formatNumber value="${order.entryMileage}" pattern="#,###" /> km</div>
                        <div><strong>Giờ vào:</strong> <fmt:formatDate value="${order.entryDate}" pattern="dd/MM/yyyy HH:mm" /></div>
                    </div>
                </div>

                <div>
                    <h4 style="font-size: 0.95rem; color: var(--primary); margin-bottom: 0.5rem;"><i class="fa-solid fa-user"></i> Khách Hàng</h4>
                    <div style="line-height: 1.6; font-size: 0.925rem;">
                        <div><strong>Họ tên:</strong> ${order.customerName}</div>
                        <div><strong>Điện thoại:</strong> ${order.customerPhone}</div>
                        <div><strong>Địa chỉ:</strong> ${order.customerAddress != null ? order.customerAddress : '—'}</div>
                        <div><strong>Tiếp nhận:</strong> ${order.receptionistName != null ? order.receptionistName : '—'}</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Diagnosis & Technician Card -->
        <div class="card" style="margin-bottom: 1.5rem;">
            <h3 style="font-size: 1.15rem; font-weight: 700; margin-bottom: 1rem; color: var(--light-text);">
                <i class="fa-solid fa-stethoscope" style="color: var(--accent);"></i> Chẩn Đoán Kỹ Thuật &amp; Phân Công
            </h3>

            <form action="${pageContext.request.contextPath}/admin/repair-order-detail" method="POST">
                <input type="hidden" name="action" value="updateDiagnosis">
                <input type="hidden" name="orderId" value="${order.orderId}">

                <div class="form-group">
                    <label class="form-label">Tình trạng tiếp nhận / Yêu cầu của khách</label>
                    <textarea name="initialDiagnosis" class="form-control" rows="2">${order.initialDiagnosis}</textarea>
                </div>

                <div class="form-group">
                    <label class="form-label">Kết luận chẩn đoán của Kỹ thuật viên</label>
                    <textarea name="technicianNotes" class="form-control" rows="2" placeholder="Ghi chú chi tiết hỏng hóc, đề xuất sửa chữa hoặc thay thế...">${order.technicianNotes}</textarea>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label class="form-label">Kỹ thuật viên phụ trách chính</label>
                        <select name="mechanicId" class="form-select">
                            <option value="">-- Chọn thợ máy --</option>
                            <c:forEach items="${mechanics}" var="m">
                                <option value="${m.userId}" ${order.mechanicId == m.userId ? 'selected' : ''}>
                                    ${m.fullName} (${m.phone})
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Dự kiến hoàn thành</label>
                        <input type="datetime-local" name="expectedFinishDate" class="form-control" value="${order.expectedFinishDate != null ? order.expectedFinishDate.toString().substring(0,16) : ''}">
                    </div>
                </div>

                <div style="text-align: right;">
                    <button type="submit" class="btn btn-sm btn-primary"><i class="fa-solid fa-save"></i> Lưu Chẩn Đoán &amp; Phân Công</button>
                </div>
            </form>
        </div>

        <!-- Services Management Table -->
        <div class="card" style="margin-bottom: 1.5rem;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                <h3 style="font-size: 1.15rem; font-weight: 700; color: var(--light-text);">
                    <i class="fa-solid fa-list-check" style="color: var(--primary);"></i> Tiền Công &amp; Dịch Vụ
                </h3>
                <button type="button" class="btn btn-sm btn-outline-light btn-dark" onclick="document.getElementById('addServiceModal').style.display='flex';">
                    <i class="fa-solid fa-plus"></i> Thêm dịch vụ
                </button>
            </div>

            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Tên Dịch Vụ</th>
                            <th>SL</th>
                            <th style="text-align: right;">Đơn Giá</th>
                            <th style="text-align: right;">Thành Tiền</th>
                            <th style="text-align: center; width: 60px;">Xóa</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${order.services}" var="svc">
                            <tr>
                                <td>
                                    <strong>${svc.serviceName}</strong>
                                    <c:if test="${not empty svc.notes}"><br><small style="color: var(--light-muted);">${svc.notes}</small></c:if>
                                </td>
                                <td>${svc.quantity}</td>
                                <td style="text-align: right;"><fmt:formatNumber value="${svc.price}" pattern="#,###" /> ₫</td>
                                <td style="text-align: right; font-weight: 700;"><fmt:formatNumber value="${svc.subtotal}" pattern="#,###" /> ₫</td>
                                <td style="text-align: center;">
                                    <form action="${pageContext.request.contextPath}/admin/repair-order-detail" method="POST" onsubmit="return confirm('Bạn có chắc muốn xóa dịch vụ này?');">
                                        <input type="hidden" name="action" value="removeService">
                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                        <input type="hidden" name="orderServiceId" value="${svc.orderServiceId}">
                                        <button type="submit" class="btn btn-sm btn-danger" style="padding: 0.2rem 0.5rem;"><i class="fa-solid fa-trash"></i></button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty order.services}">
                            <tr><td colspan="5" style="text-align: center; color: var(--light-muted);">Chưa có dịch vụ nào được thêm.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Spare Parts Management Table -->
        <div class="card">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                <h3 style="font-size: 1.15rem; font-weight: 700; color: var(--light-text);">
                    <i class="fa-solid fa-boxes-stacked" style="color: var(--accent);"></i> Phụ Tùng Thay Thế (Xuất Kho)
                </h3>
                <button type="button" class="btn btn-sm btn-outline-light btn-dark" onclick="document.getElementById('addPartModal').style.display='flex';">
                    <i class="fa-solid fa-plus"></i> Xuất phụ tùng từ kho
                </button>
            </div>

            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Mã &amp; Tên Phụ Tùng</th>
                            <th>SL</th>
                            <th style="text-align: right;">Đơn Giá</th>
                            <th style="text-align: right;">Thành Tiền</th>
                            <th style="text-align: center; width: 60px;">Xóa</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${order.parts}" var="pt">
                            <tr>
                                <td>
                                    <strong>${pt.partName}</strong> <span style="font-size: 0.75rem; color: var(--light-muted);">[${pt.partCode}]</span>
                                    <c:if test="${not empty pt.notes}"><br><small style="color: var(--light-muted);">${pt.notes}</small></c:if>
                                </td>
                                <td>${pt.quantity}</td>
                                <td style="text-align: right;"><fmt:formatNumber value="${pt.unitPrice}" pattern="#,###" /> ₫</td>
                                <td style="text-align: right; font-weight: 700;"><fmt:formatNumber value="${pt.subtotal}" pattern="#,###" /> ₫</td>
                                <td style="text-align: center;">
                                    <form action="${pageContext.request.contextPath}/admin/repair-order-detail" method="POST" onsubmit="return confirm('Bạn có chắc muốn xóa phụ tùng này? Số lượng sẽ được hoàn lại kho.');">
                                        <input type="hidden" name="action" value="removePart">
                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                        <input type="hidden" name="orderPartId" value="${pt.orderPartId}">
                                        <input type="hidden" name="partId" value="${pt.partId}">
                                        <input type="hidden" name="quantity" value="${pt.quantity}">
                                        <button type="submit" class="btn btn-sm btn-danger" style="padding: 0.2rem 0.5rem;"><i class="fa-solid fa-trash"></i></button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty order.parts}">
                            <tr><td colspan="5" style="text-align: center; color: var(--light-muted);">Chưa có phụ tùng nào được xuất.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- RIGHT COLUMN: Order Status Management & Financial Summary -->
    <div>
        <!-- Order Status Transition Card -->
        <div class="card" style="margin-bottom: 1.5rem;">
            <h3 style="font-size: 1.15rem; font-weight: 700; margin-bottom: 1rem;"><i class="fa-solid fa-shuffle"></i> Tiến Độ Lệnh Sửa Chữa</h3>
            <form action="${pageContext.request.contextPath}/admin/repair-order-detail" method="POST">
                <input type="hidden" name="action" value="updateStatus">
                <input type="hidden" name="orderId" value="${order.orderId}">

                <div class="form-group">
                    <label class="form-label">Cập nhật trạng thái mới</label>
                    <select name="newStatus" class="form-select" style="font-weight: 600;">
                        <option value="PENDING_INSPECTION" ${order.orderStatus == 'PENDING_INSPECTION' ? 'selected' : ''}>1. Chờ tiếp nhận &amp; Kiểm tra</option>
                        <option value="DIAGNOSED_QUOTED" ${order.orderStatus == 'DIAGNOSED_QUOTED' ? 'selected' : ''}>2. Đã chẩn đoán &amp; Chờ duyệt giá</option>
                        <option value="IN_PROGRESS" ${order.orderStatus == 'IN_PROGRESS' ? 'selected' : ''}>3. Đang tiến hành sửa chữa</option>
                        <option value="COMPLETED_WAITING_PAYMENT" ${order.orderStatus == 'COMPLETED_WAITING_PAYMENT' ? 'selected' : ''}>4. Sửa xong (Chờ thanh toán)</option>
                        <option value="PAID_DELIVERED" ${order.orderStatus == 'PAID_DELIVERED' ? 'selected' : ''}>5. Đã thanh toán &amp; Bàn giao xe</option>
                        <option value="CANCELLED" ${order.orderStatus == 'CANCELLED' ? 'selected' : ''}>Hủy lệnh sửa chữa</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%;">
                    <i class="fa-solid fa-arrow-rotate-right"></i> Cập Nhật Trạng Thái
                </button>
            </form>
        </div>

        <!-- Financial Summary Card -->
        <div class="card" style="background: #ffffff; border: 2px solid var(--primary-light);">
            <h3 style="font-size: 1.15rem; font-weight: 700; margin-bottom: 1rem; color: var(--primary);">
                <i class="fa-solid fa-calculator"></i> Tổng Hợp Chi Phí
            </h3>

            <div style="font-size: 0.95rem; line-height: 2;">
                <div style="display: flex; justify-content: space-between;">
                    <span>Tổng tiền dịch vụ:</span>
                    <strong><fmt:formatNumber value="${order.totalServiceCost}" pattern="#,###" /> ₫</strong>
                </div>
                <div style="display: flex; justify-content: space-between;">
                    <span>Tổng tiền phụ tùng:</span>
                    <strong><fmt:formatNumber value="${order.totalPartCost}" pattern="#,###" /> ₫</strong>
                </div>

                <form action="${pageContext.request.contextPath}/admin/repair-order-detail" method="POST" style="margin: 0.75rem 0; border-top: 1px dashed var(--light-border); border-bottom: 1px dashed var(--light-border); padding: 0.75rem 0;">
                    <input type="hidden" name="action" value="updateFinance">
                    <input type="hidden" name="orderId" value="${order.orderId}">

                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                        <label style="font-size: 0.85rem; color: var(--danger);">Giảm giá (₫):</label>
                        <input type="number" name="discountAmount" value="${order.discountAmount}" class="form-control form-control-sm" style="width: 120px; text-align: right;">
                    </div>

                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                        <label style="font-size: 0.85rem;">Thuế VAT (₫):</label>
                        <input type="number" name="taxVat" value="${order.taxVat}" class="form-control form-control-sm" style="width: 120px; text-align: right;">
                    </div>

                    <div style="text-align: right;">
                        <button type="submit" class="btn btn-sm btn-secondary" style="font-size: 0.75rem;">Áp dụng chiết khấu</button>
                    </div>
                </form>

                <div style="display: flex; justify-content: space-between; font-size: 1.25rem; font-weight: 900; color: var(--accent); margin-top: 0.5rem;">
                    <span>TỔNG THANH TOÁN:</span>
                    <span><fmt:formatNumber value="${order.grandTotal}" pattern="#,###" /> ₫</span>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal 1: Add Service -->
<div id="addServiceModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 9999; align-items: center; justify-content: center;">
    <div class="card" style="width: 500px; max-width: 90%; background: #fff;">
        <h3 style="font-size: 1.2rem; margin-bottom: 1rem;"><i class="fa-solid fa-plus"></i> Thêm Dịch Vụ Vào Phiếu</h3>
        <form action="${pageContext.request.contextPath}/admin/repair-order-detail" method="POST">
            <input type="hidden" name="action" value="addService">
            <input type="hidden" name="orderId" value="${order.orderId}">

            <div class="form-group">
                <label class="form-label">Chọn dịch vụ</label>
                <select name="serviceId" class="form-select" required>
                    <c:forEach items="${allServices}" var="s">
                        <option value="${s.serviceId}">${s.serviceName} (<fmt:formatNumber value="${s.laborCost}" pattern="#,###" /> ₫)</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">Số lượng</label>
                <input type="number" name="quantity" value="1" min="1" class="form-control" required>
            </div>

            <div class="form-group">
                <label class="form-label">Ghi chú riêng</label>
                <input type="text" name="notes" class="form-control" placeholder="Tùy chọn...">
            </div>

            <div style="text-align: right; margin-top: 1.5rem;">
                <button type="button" class="btn btn-secondary" onclick="document.getElementById('addServiceModal').style.display='none';">Hủy</button>
                <button type="submit" class="btn btn-primary">Thêm Dịch Vụ</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal 2: Add Spare Part -->
<div id="addPartModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 9999; align-items: center; justify-content: center;">
    <div class="card" style="width: 540px; max-width: 90%; background: #fff;">
        <h3 style="font-size: 1.2rem; margin-bottom: 1rem;"><i class="fa-solid fa-boxes-stacked"></i> Xuất Phụ Tùng Từ Kho</h3>
        <form action="${pageContext.request.contextPath}/admin/repair-order-detail" method="POST">
            <input type="hidden" name="action" value="addPart">
            <input type="hidden" name="orderId" value="${order.orderId}">

            <div class="form-group">
                <label class="form-label">Chọn phụ tùng trong kho</label>
                <select name="partId" class="form-select" required>
                    <c:forEach items="${allParts}" var="p">
                        <option value="${p.partId}">${p.partName} [${p.partCode}] - Giá: <fmt:formatNumber value="${p.unitPrice}" pattern="#,###" /> ₫ (Còn: ${p.quantityInStock} ${p.unit})</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">Số lượng xuất</label>
                <input type="number" name="quantity" value="1" min="1" class="form-control" required>
            </div>

            <div class="form-group">
                <label class="form-label">Ghi chú vị trí lắp đặt / lý do</label>
                <input type="text" name="notes" class="form-control" placeholder="Ví dụ: Thay bên phụ...">
            </div>

            <div style="text-align: right; margin-top: 1.5rem;">
                <button type="button" class="btn btn-secondary" onclick="document.getElementById('addPartModal').style.display='none';">Hủy</button>
                <button type="submit" class="btn btn-accent">Xuất Kho &amp; Thêm</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal 3: Checkout / Settle Payment -->
<div id="checkoutModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 9999; align-items: center; justify-content: center;">
    <div class="card" style="width: 500px; max-width: 90%; background: #fff;">
        <h3 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--success);"><i class="fa-solid fa-cash-register"></i> Quyết Toán Hóa Đơn</h3>
        <form action="${pageContext.request.contextPath}/admin/checkout" method="POST">
            <input type="hidden" name="action" value="checkout">
            <input type="hidden" name="orderId" value="${order.orderId}">

            <div style="background: #f8fafc; padding: 1rem; border-radius: var(--radius-md); margin-bottom: 1rem; font-size: 1.1rem; text-align: center;">
                Tổng số tiền thanh toán: <strong style="color: var(--accent); font-size: 1.4rem;"><fmt:formatNumber value="${order.grandTotal}" pattern="#,###" /> ₫</strong>
            </div>

            <div class="form-group">
                <label class="form-label">Hình thức thanh toán</label>
                <select name="paymentMethod" class="form-select">
                    <option value="CASH">Tiền mặt</option>
                    <option value="BANK_TRANSFER" selected>Chuyển khoản Ngân hàng (QR Code)</option>
                    <option value="CREDIT_CARD">Thẻ tín dụng (POS)</option>
                    <option value="VNPAY">Ví điện tử VNPAY</option>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">Ghi chú thanh toán</label>
                <input type="text" name="notes" class="form-control" placeholder="Đã nhận đủ tiền từ khách...">
            </div>

            <div style="text-align: right; margin-top: 1.5rem;">
                <button type="button" class="btn btn-secondary" onclick="document.getElementById('checkoutModal').style.display='none';">Hủy</button>
                <button type="submit" class="btn btn-success"><i class="fa-solid fa-check"></i> Xác Nhận Thanh Toán</button>
            </div>
        </form>
    </div>
</div>

</main>
</div>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
