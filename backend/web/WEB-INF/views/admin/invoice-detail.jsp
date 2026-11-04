<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../includes/admin-navbar.jsp">
    <jsp:param name="title" value="Hóa Đơn Thu Tiền ${invoice.invoiceCode} - CareCar" />
</jsp:include>
<jsp:include page="../includes/admin-sidebar.jsp" />

<div class="no-print" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
    <div style="display: flex; gap: 0.75rem;">
        <a href="${pageContext.request.contextPath}/admin/invoices" class="btn btn-sm btn-secondary">
            <i class="fa-solid fa-arrow-left"></i> Danh sách hóa đơn
        </a>
        <a href="${pageContext.request.contextPath}/admin/repair-order-detail?id=${order.orderId}" class="btn btn-sm btn-secondary">
            <i class="fa-solid fa-file-invoice"></i> Về phiếu sửa chữa (${order.orderCode})
        </a>
    </div>
    <button id="printInvoiceBtn" class="btn btn-primary">
        <i class="fa-solid fa-print"></i> In Hóa Đơn (Print)
    </button>
</div>

<!-- INVOICE SHEET -->
<div class="card" style="max-width: 850px; margin: 0 auto; padding: 3rem; background: #ffffff; color: #000; box-shadow: var(--shadow-md);">
    
    <!-- Invoice Header -->
    <div style="display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 2px solid #0f172a; padding-bottom: 1.5rem; margin-bottom: 1.5rem;">
        <div>
            <div style="display: flex; align-items: center; gap: 0.5rem; font-size: 1.5rem; font-weight: 900;">
                <i class="fa-solid fa-screwdriver-wrench" style="color: var(--accent);"></i> CARE<span style="color: var(--accent);">CAR</span> AUTO
            </div>
            <p style="font-size: 0.85rem; color: #475569; margin-top: 0.25rem; line-height: 1.5;">
                Địa chỉ: Số 168 Phạm Hùng, Cầu Giấy, Hà Nội<br>
                Hotline: 0364 968 200 &bull; Zalo: 0364 968 200 &bull; Website: carecar.vn<br>
                Mã số thuế: 0109988776
            </p>
        </div>

        <div style="text-align: right;">
            <h2 style="font-size: 1.4rem; font-weight: 800; text-transform: uppercase; color: #0f172a;">HÓA ĐƠN DỊCH VỤ</h2>
            <div style="font-size: 0.95rem; font-weight: 700; color: var(--primary); margin-top: 0.25rem;">${invoice.invoiceCode}</div>
            <div style="font-size: 0.85rem; color: #64748b;">
                Ngày lập: <fmt:formatDate value="${invoice.paymentDate}" pattern="dd/MM/yyyy HH:mm" /><br>
                Lệnh số: <strong>${order.orderCode}</strong>
            </div>
        </div>
    </div>

    <!-- Customer & Car Info -->
    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin-bottom: 2rem; background: #f8fafc; padding: 1.25rem; border-radius: 8px;">
        <div style="font-size: 0.9rem; line-height: 1.6;">
            <div style="font-weight: 700; text-transform: uppercase; color: #0f172a; margin-bottom: 0.25rem;">Khách Hàng:</div>
            <div><strong>Họ tên:</strong> ${order.customerName}</div>
            <div><strong>Điện thoại:</strong> ${order.customerPhone}</div>
            <div><strong>Địa chỉ:</strong> ${order.customerAddress != null ? order.customerAddress : '—'}</div>
        </div>

        <div style="font-size: 0.9rem; line-height: 1.6;">
            <div style="font-weight: 700; text-transform: uppercase; color: #0f172a; margin-bottom: 0.25rem;">Phương Tiện:</div>
            <div><strong>Biển số xe:</strong> <span style="font-weight: 800;">${order.carLicensePlate}</span></div>
            <div><strong>Xe:</strong> ${order.carBrand} ${order.carModel} (${order.carColor})</div>
            <div><strong>Số Km (ODO):</strong> <fmt:formatNumber value="${order.entryMileage}" pattern="#,###" /> km</div>
        </div>
    </div>

    <!-- Items Table -->
    <table class="table" style="margin-bottom: 1.5rem; font-size: 0.9rem;">
        <thead>
            <tr style="border-bottom: 2px solid #cbd5e1;">
                <th style="width: 40px;">STT</th>
                <th>Nội Dung Hạng Mục / Linh Kiện</th>
                <th style="text-align: center; width: 60px;">ĐVT</th>
                <th style="text-align: center; width: 60px;">SL</th>
                <th style="text-align: right; width: 130px;">Đơn Giá</th>
                <th style="text-align: right; width: 140px;">Thành Tiền</th>
            </tr>
        </thead>
        <tbody>
            <c:set var="num" value="1" />
            <c:forEach items="${order.services}" var="s">
                <tr>
                    <td>${num}</td>
                    <td><strong>${s.serviceName}</strong> (Tiền công)</td>
                    <td style="text-align: center;">Lần</td>
                    <td style="text-align: center;">${s.quantity}</td>
                    <td style="text-align: right;"><fmt:formatNumber value="${s.price}" pattern="#,###" /> ₫</td>
                    <td style="text-align: right; font-weight: 600;"><fmt:formatNumber value="${s.subtotal}" pattern="#,###" /> ₫</td>
                </tr>
                <c:set var="num" value="${num + 1}" />
            </c:forEach>
            <c:forEach items="${order.parts}" var="p">
                <tr>
                    <td>${num}</td>
                    <td><strong>${p.partName}</strong> [${p.partCode}]</td>
                    <td style="text-align: center;">Cái</td>
                    <td style="text-align: center;">${p.quantity}</td>
                    <td style="text-align: right;"><fmt:formatNumber value="${p.unitPrice}" pattern="#,###" /> ₫</td>
                    <td style="text-align: right; font-weight: 600;"><fmt:formatNumber value="${p.subtotal}" pattern="#,###" /> ₫</td>
                </tr>
                <c:set var="num" value="${num + 1}" />
            </c:forEach>
        </tbody>
    </table>

    <!-- Totals & Payment Method -->
    <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 3rem;">
        <div style="font-size: 0.85rem; color: #475569; max-width: 320px;">
            <div><strong>Hình thức thanh toán:</strong> ${invoice.paymentMethod}</div>
            <div><strong>Trạng thái:</strong> <span style="color: var(--success); font-weight: bold;">ĐÃ THANH TOÁN ĐỦ</span></div>
            <div style="margin-top: 0.5rem; font-style: italic;">
                * Cảm ơn Quý khách đã tin tưởng CareCar. Xe được bảo hành phụ tùng 12 tháng hoặc 20.000km tùy điều kiện nào đến trước.
            </div>
        </div>

        <div style="min-width: 280px; font-size: 0.95rem; line-height: 1.8;">
            <div style="display: flex; justify-content: space-between;">
                <span>Tiền công dịch vụ:</span>
                <span><fmt:formatNumber value="${order.totalServiceCost}" pattern="#,###" /> ₫</span>
            </div>
            <div style="display: flex; justify-content: space-between;">
                <span>Tiền phụ tùng:</span>
                <span><fmt:formatNumber value="${order.totalPartCost}" pattern="#,###" /> ₫</span>
            </div>
            <c:if test="${order.discountAmount > 0}">
                <div style="display: flex; justify-content: space-between; color: var(--danger);">
                    <span>Chiết khấu ưu đãi:</span>
                    <span>-<fmt:formatNumber value="${order.discountAmount}" pattern="#,###" /> ₫</span>
                </div>
            </c:if>
            <c:if test="${order.taxVat > 0}">
                <div style="display: flex; justify-content: space-between;">
                    <span>Thuế VAT:</span>
                    <span>+<fmt:formatNumber value="${order.taxVat}" pattern="#,###" /> ₫</span>
                </div>
            </c:if>
            <div style="display: flex; justify-content: space-between; font-size: 1.25rem; font-weight: 900; border-top: 2px solid #0f172a; padding-top: 0.5rem; margin-top: 0.5rem;">
                <span>TỔNG CỘNG:</span>
                <span style="color: var(--primary);"><fmt:formatNumber value="${invoice.amountPaid}" pattern="#,###" /> ₫</span>
            </div>
        </div>
    </div>

    <!-- Signatures -->
    <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; text-align: center; font-size: 0.9rem; margin-top: 2rem;">
        <div>
            <strong>KHÁCH HÀNG</strong><br>
            <small style="color: #64748b;">(Ký và ghi rõ họ tên)</small>
            <div style="height: 70px;"></div>
            <div>${order.customerName}</div>
        </div>
        <div>
            <strong>KỸ THUẬT VIÊN</strong><br>
            <small style="color: #64748b;">(Ký và ghi rõ họ tên)</small>
            <div style="height: 70px;"></div>
            <div>${order.mechanicName != null ? order.mechanicName : 'KTV Xưởng'}</div>
        </div>
        <div>
            <strong>NGƯỜI THU TIỀN</strong><br>
            <small style="color: #64748b;">(Ký và ghi rõ họ tên)</small>
            <div style="height: 70px;"></div>
            <div>${invoice.creatorName != null ? invoice.creatorName : 'Kế toán / Thu ngân'}</div>
        </div>
    </div>

</div>

</main>
</div>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
