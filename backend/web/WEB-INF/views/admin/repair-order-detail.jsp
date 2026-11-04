<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="cc" uri="/WEB-INF/tlds/carecar.tld" %>

<jsp:include page="../includes/admin-navbar.jsp">
    <jsp:param name="title" value="Chi Tiết Lệnh Sửa Chữa - CareCar" />
</jsp:include>
<jsp:include page="../includes/admin-sidebar.jsp" />

<!-- Header Actions -->
<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem;">
    <div style="display: flex; align-items: center; gap: 1rem; flex-wrap: wrap;">
        <a href="${pageContext.request.contextPath}/admin/repair-orders" class="btn btn-sm btn-secondary">
            <i class="fa-solid fa-arrow-left"></i> Quay lại
        </a>
        <h1 style="font-size: 1.75rem; font-weight: 800; color: var(--light-text); margin-bottom: 0;">
            Lệnh Sửa Chữa: <span style="color: var(--primary);"><c:out value="${order.orderCode}" /></span>
        </h1>
        <span class="badge ${order.orderStatus == 'PAID_DELIVERED' ? 'badge-delivered' : (order.orderStatus == 'COMPLETED_WAITING_PAYMENT' ? 'badge-success' : (order.orderStatus == 'IN_PROGRESS' ? 'badge-primary' : 'badge-warning'))}" style="font-size: 0.85rem;">
            ${order.orderStatus}
        </span>
    </div>

    <div style="display: flex; gap: 0.75rem;">
        <c:if test="${sessionScope.currentUser.admin || sessionScope.currentUser.receptionist}">
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
        </c:if>
    </div>
</div>

<c:if test="${param.msg == 'service_added'}">
    <div class="alert alert-success" style="display: flex; align-items: center; gap: 0.5rem; border-left: 4px solid #10b981;">
        <i class="fa-solid fa-circle-check" style="font-size: 1.2rem;"></i>
        <div>
            <strong>Thêm dịch vụ thành công!</strong> Hệ thống đã tự động tính toán lại chi phí sửa chữa xe: 
            <strong><fmt:formatNumber value="${order.grandTotal}" pattern="#,###" /> ₫</strong>
        </div>
    </div>
</c:if>
<c:if test="${param.msg == 'service_removed'}">
    <div class="alert alert-success" style="display: flex; align-items: center; gap: 0.5rem; border-left: 4px solid #10b981;">
        <i class="fa-solid fa-circle-check"></i>
        <div>Đã xóa dịch vụ khỏi phiếu! Hệ thống đã tự động tính lại tổng chi phí sửa chữa.</div>
    </div>
</c:if>
<c:if test="${param.msg == 'service_add_error'}">
    <div class="alert alert-danger" style="display: flex; align-items: center; gap: 0.5rem;">
        <i class="fa-solid fa-triangle-exclamation"></i>
        <div>Không thể thêm dịch vụ. Vui lòng kiểm tra lại thông tin và đơn giá!</div>
    </div>
</c:if>
<c:if test="${param.msg == 'part_added'}">
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Đã xuất phụ tùng từ kho và tự động cộng vào tổng chi phí!</div>
</c:if>
<c:if test="${param.msg == 'part_removed'}">
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Đã hoàn trả phụ tùng về kho và tự động trừ khỏi tổng chi phí!</div>
</c:if>
<c:if test="${param.msg == 'status_updated'}">
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Cập nhật trạng thái lệnh thành công!</div>
</c:if>
<c:if test="${param.msg == 'diagnosis_updated'}">
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Đã lưu kết luận kiểm tra &amp; phân công thợ máy!</div>
</c:if>
<c:if test="${param.msg == 'finance_updated'}">
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Đã cập nhật chiết khấu và thuế VAT! Tổng chi phí đã được tính lại.</div>
</c:if>
<c:if test="${param.msg == 'finance_permission_denied'}">
    <div class="alert alert-danger" style="display: flex; align-items: center; gap: 0.5rem; border-left: 4px solid #ef4444;">
        <i class="fa-solid fa-ban" style="font-size: 1.2rem;"></i>
        <div><strong>Từ chối thao tác tài chính:</strong> Thợ máy không có quyền thay đổi giảm giá hoặc thuế VAT! Chỉ Admin hoặc Lễ tân được thực hiện.</div>
    </div>
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
                        <div><strong>Biển số:</strong> <span style="font-weight: 800; background: #f1f5f9; padding: 0.1rem 0.5rem; border-radius: 4px;"><c:out value="${order.carLicensePlate}" /></span></div>
                        <div><strong>Xe:</strong> <c:out value="${order.carBrand}" /> <c:out value="${order.carModel}" /> (<c:out value="${order.carColor}" />)</div>
                        <div><strong>ODO Tiếp nhận:</strong> <fmt:formatNumber value="${order.entryMileage}" pattern="#,###" /> km</div>
                        <div><strong>Giờ vào:</strong> <fmt:formatDate value="${order.entryDate}" pattern="dd/MM/yyyy HH:mm" /></div>
                    </div>
                </div>

                <div>
                    <h4 style="font-size: 0.95rem; color: var(--primary); margin-bottom: 0.5rem;"><i class="fa-solid fa-user"></i> Khách Hàng</h4>
                    <div style="line-height: 1.6; font-size: 0.925rem;">
                        <div><strong>Họ tên:</strong> <c:out value="${order.customerName}" /></div>
                        <div><strong>Điện thoại:</strong> <c:out value="${order.customerPhone}" /></div>
                        <div><strong>Địa chỉ:</strong> <c:out value="${order.customerAddress != null ? order.customerAddress : '—'}" /></div>
                        <div><strong>Tiếp nhận:</strong> <c:out value="${order.receptionistName != null ? order.receptionistName : '—'}" /></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Diagnosis & Technician Card -->
        <div class="card" style="margin-bottom: 1.5rem;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                <h3 style="font-size: 1.15rem; font-weight: 700; color: var(--light-text); margin: 0;">
                    <i class="fa-solid fa-stethoscope" style="color: var(--accent);"></i> Chẩn Đoán Kỹ Thuật &amp; Phân Công
                </h3>
                <span class="badge badge-info" style="font-size: 0.75rem;">
                    <i class="fa-solid fa-user-gear"></i> Quyền Thợ máy &amp; Admin
                </span>
            </div>

            <form action="${pageContext.request.contextPath}/admin/repair-order-detail" method="POST">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
                <input type="hidden" name="action" value="updateDiagnosis">
                <input type="hidden" name="orderId" value="${order.orderId}">

                <div class="form-group">
                    <label class="form-label">Tình trạng tiếp nhận / Yêu cầu của khách</label>
                    <textarea name="initialDiagnosis" class="form-control" rows="2"><c:out value="${order.initialDiagnosis}" /></textarea>
                </div>

                <div class="form-group">
                    <label class="form-label">Kết luận chẩn đoán của Kỹ thuật viên</label>
                    <textarea name="technicianNotes" class="form-control" rows="2" placeholder="Ghi chú chi tiết hỏng hóc, đề xuất sửa chữa hoặc thay thế..."><c:out value="${order.technicianNotes}" /></textarea>
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
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; flex-wrap: wrap; gap: 0.5rem;">
                <div>
                    <h3 style="font-size: 1.15rem; font-weight: 700; color: var(--light-text); margin: 0;">
                        <i class="fa-solid fa-list-check" style="color: var(--primary);"></i> Tiền Công &amp; Dịch Vụ Sửa Chữa
                    </h3>
                    <small style="color: var(--light-muted);">Thợ máy và Admin có thể thêm dịch vụ từ danh mục hoặc dịch vụ phát sinh</small>
                </div>
                <button type="button" class="btn btn-sm btn-primary" onclick="openAddServiceModal();">
                    <i class="fa-solid fa-plus-circle"></i> Thêm Dịch Vụ
                </button>
            </div>

            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Tên Dịch Vụ / Hạng Mục</th>
                            <th style="text-align: center; width: 60px;">SL</th>
                            <th style="text-align: right; width: 140px;">Đơn Giá</th>
                            <th style="text-align: right; width: 150px;">Thành Tiền</th>
                            <th style="text-align: center; width: 60px;">Xóa</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${order.services}" var="svc">
                            <tr>
                                <td>
                                    <strong><c:out value="${svc.serviceName}" /></strong>
                                    <c:if test="${not empty svc.notes}"><br><small style="color: var(--light-muted);"><i class="fa-solid fa-info-circle"></i> <c:out value="${svc.notes}" /></small></c:if>
                                </td>
                                <td style="text-align: center; font-weight: 600;">${svc.quantity}</td>
                                <td style="text-align: right;"><fmt:formatNumber value="${svc.price}" pattern="#,###" /> ₫</td>
                                <td style="text-align: right; font-weight: 700; color: #ff5a1f;"><fmt:formatNumber value="${svc.subtotal}" pattern="#,###" /> ₫</td>
                                <td style="text-align: center;">
                                    <form action="${pageContext.request.contextPath}/admin/repair-order-detail" method="POST" onsubmit="return confirm('Bạn có chắc muốn xóa dịch vụ này? Chi phí xe sẽ được tự động tính lại.');">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
                                        <input type="hidden" name="action" value="removeService">
                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                        <input type="hidden" name="orderServiceId" value="${svc.orderServiceId}">
                                        <button type="submit" class="btn btn-sm btn-danger" style="padding: 0.2rem 0.5rem;" title="Xóa dịch vụ"><i class="fa-solid fa-trash"></i></button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty order.services}">
                            <tr><td colspan="5" style="text-align: center; color: var(--light-muted); padding: 1.5rem 0;">Chưa có dịch vụ nào được thêm. Thợ máy vui lòng nhấn <strong>"Thêm Dịch Vụ"</strong> để kê khai chi phí.</td></tr>
                        </c:if>
                    </tbody>
                    <c:if test="${not empty order.services}">
                        <tfoot>
                            <tr style="background: #f8fafc; font-weight: 700;">
                                <td colspan="3" style="text-align: right;">Tổng Tiền Công Dịch Vụ:</td>
                                <td style="text-align: right; color: #ff5a1f; font-size: 1.05rem;">
                                    <fmt:formatNumber value="${order.totalServiceCost}" pattern="#,###" /> ₫
                                </td>
                                <td></td>
                            </tr>
                        </tfoot>
                    </c:if>
                </table>
            </div>
        </div>

        <!-- Spare Parts Management Table -->
        <div class="card">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; flex-wrap: wrap; gap: 0.5rem;">
                <h3 style="font-size: 1.15rem; font-weight: 700; color: var(--light-text); margin: 0;">
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
                            <th style="text-align: center; width: 60px;">SL</th>
                            <th style="text-align: right; width: 140px;">Đơn Giá</th>
                            <th style="text-align: right; width: 150px;">Thành Tiền</th>
                            <th style="text-align: center; width: 60px;">Xóa</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${order.parts}" var="pt">
                            <tr>
                                <td>
                                    <strong><c:out value="${pt.partName}" /></strong> <span style="font-size: 0.75rem; color: var(--light-muted);">[<c:out value="${pt.partCode}" />]</span>
                                    <c:if test="${not empty pt.notes}"><br><small style="color: var(--light-muted);"><c:out value="${pt.notes}" /></small></c:if>
                                </td>
                                <td style="text-align: center; font-weight: 600;">${pt.quantity}</td>
                                <td style="text-align: right;"><fmt:formatNumber value="${pt.unitPrice}" pattern="#,###" /> ₫</td>
                                <td style="text-align: right; font-weight: 700;"><fmt:formatNumber value="${pt.subtotal}" pattern="#,###" /> ₫</td>
                                <td style="text-align: center;">
                                    <form action="${pageContext.request.contextPath}/admin/repair-order-detail" method="POST" onsubmit="return confirm('Bạn có chắc muốn xóa phụ tùng này? Số lượng sẽ được hoàn lại kho.');">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
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
                            <tr><td colspan="5" style="text-align: center; color: var(--light-muted);">Chưa có phụ tùng nào được xuất kho.</td></tr>
                        </c:if>
                    </tbody>
                    <c:if test="${not empty order.parts}">
                        <tfoot>
                            <tr style="background: #f8fafc; font-weight: 700;">
                                <td colspan="3" style="text-align: right;">Tổng Tiền Phụ Tùng:</td>
                                <td style="text-align: right; color: var(--light-text); font-size: 1.05rem;">
                                    <fmt:formatNumber value="${order.totalPartCost}" pattern="#,###" /> ₫
                                </td>
                                <td></td>
                            </tr>
                        </tfoot>
                    </c:if>
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
            <input type="hidden" name="csrfToken" value="${csrfToken}">
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

        <!-- Financial Summary Card (Auto-calculated) -->
        <div class="card" style="background: #ffffff; border: 2px solid var(--primary-light); box-shadow: 0 4px 12px rgba(0,0,0,0.05);">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                <h3 style="font-size: 1.15rem; font-weight: 700; color: var(--primary); margin: 0;">
                    <i class="fa-solid fa-calculator"></i> Tổng Hợp Chi Phí Tự Động
                </h3>
                <span class="badge badge-success" style="font-size: 0.75rem;"><i class="fa-solid fa-bolt"></i> Tự động tính</span>
            </div>

            <div style="font-size: 0.95rem; line-height: 2;">
                <div style="display: flex; justify-content: space-between;">
                    <span style="color: var(--light-muted);">1. Tiền công dịch vụ:</span>
                    <strong style="color: #ff5a1f;"><fmt:formatNumber value="${order.totalServiceCost}" pattern="#,###" /> ₫</strong>
                </div>
                <div style="display: flex; justify-content: space-between;">
                    <span style="color: var(--light-muted);">2. Phụ tùng thay thế:</span>
                    <strong><fmt:formatNumber value="${order.totalPartCost}" pattern="#,###" /> ₫</strong>
                </div>

                <c:choose>
                    <c:when test="${sessionScope.currentUser.admin || sessionScope.currentUser.receptionist}">
                        <form action="${pageContext.request.contextPath}/admin/repair-order-detail" method="POST" style="margin: 0.75rem 0; border-top: 1px dashed var(--light-border); border-bottom: 1px dashed var(--light-border); padding: 0.75rem 0;">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
                            <input type="hidden" name="action" value="updateFinance">
                            <input type="hidden" name="orderId" value="${order.orderId}">

                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                                <label style="font-size: 0.85rem; color: var(--danger); margin: 0;">Giảm giá (₫):</label>
                                <input type="number" name="discountAmount" value="${order.discountAmount}" min="0" class="form-control form-control-sm" style="width: 120px; text-align: right;">
                            </div>

                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                                <label style="font-size: 0.85rem; margin: 0;">Thuế VAT (₫):</label>
                                <input type="number" name="taxVat" value="${order.taxVat}" min="0" class="form-control form-control-sm" style="width: 120px; text-align: right;">
                            </div>

                            <div style="text-align: right; margin-top: 0.25rem;">
                                <button type="submit" class="btn btn-sm btn-secondary" style="font-size: 0.75rem;">
                                    <i class="fa-solid fa-tag"></i> Cập nhật chiết khấu
                                </button>
                            </div>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div style="margin: 0.75rem 0; border-top: 1px dashed var(--light-border); border-bottom: 1px dashed var(--light-border); padding: 0.75rem 0;">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                                <span style="font-size: 0.85rem; color: var(--danger);"><i class="fa-solid fa-tag"></i> Giảm giá:</span>
                                <span style="color: var(--danger); font-weight: 700;">- <fmt:formatNumber value="${order.discountAmount}" pattern="#,###" /> ₫</span>
                            </div>
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <span style="font-size: 0.85rem; color: var(--light-muted);"><i class="fa-solid fa-percent"></i> Thuế VAT:</span>
                                <span style="font-weight: 700;">+ <fmt:formatNumber value="${order.taxVat}" pattern="#,###" /> ₫</span>
                            </div>
                            <small style="display: block; font-size: 0.75rem; color: #94a3b8; margin-top: 0.4rem; text-align: right;">(Thợ máy chỉ xem chiết khấu/thuế do Lễ tân/Admin thiết lập)</small>
                        </div>
                    </c:otherwise>
                </c:choose>

                <div style="display: flex; justify-content: space-between; align-items: baseline; font-size: 1.25rem; font-weight: 900; color: #ff5a1f; margin-top: 0.5rem; border-top: 2px solid #e2e8f0; padding-top: 0.75rem;">
                    <span>TỔNG CHI PHÍ:</span>
                    <span style="font-size: 1.4rem;"><fmt:formatNumber value="${order.grandTotal}" pattern="#,###" /> ₫</span>
                </div>
                <div style="font-size: 0.75rem; color: var(--light-muted); text-align: right;">
                    = (Tiền dịch vụ + Tiền phụ tùng - Giảm giá + Thuế VAT)
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal 1: Add Service (Upgraded with Tabs, Custom Service and Realtime Auto-calculation preview) -->
<div id="addServiceModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 9999; align-items: center; justify-content: center; backdrop-filter: blur(2px);">
    <div class="card" style="width: 580px; max-width: 92%; background: #ffffff; border-radius: 12px; box-shadow: 0 20px 40px rgba(0,0,0,0.3); overflow: hidden; padding: 0;">
        <!-- Modal Header -->
        <div style="padding: 1.25rem 1.5rem; background: #0f172a; color: #fff; display: flex; justify-content: space-between; align-items: center;">
            <div style="display: flex; align-items: center; gap: 0.75rem;">
                <div style="width: 36px; height: 36px; border-radius: 8px; background: rgba(255, 90, 31, 0.2); display: flex; align-items: center; justify-content: center; color: #ff5a1f;">
                    <i class="fa-solid fa-wrench"></i>
                </div>
                <div>
                    <h3 style="font-size: 1.2rem; font-weight: 800; color: #fff; margin: 0;">Thêm Dịch Vụ Sửa Chữa Xe</h3>
                    <small style="color: #94a3b8;">Thợ máy &amp; Admin có quyền kê khai dịch vụ &amp; tự động tính tiền</small>
                </div>
            </div>
            <button type="button" onclick="closeAddServiceModal();" style="background: none; border: none; font-size: 1.4rem; cursor: pointer; color: #94a3b8;">&times;</button>
        </div>

        <!-- Navigation Tabs -->
        <div style="display: flex; background: #f8fafc; border-bottom: 1px solid #e2e8f0; padding: 0.5rem 1.5rem 0; gap: 0.5rem;">
            <button type="button" id="tabCatalogBtn" onclick="switchServiceTab('catalog');" 
                    style="padding: 0.6rem 1rem; border: none; background: #fff; border-top-left-radius: 8px; border-top-right-radius: 8px; font-weight: 700; color: #ff5a1f; cursor: pointer; border-bottom: 2px solid #ff5a1f;">
                <i class="fa-solid fa-book-open"></i> 1. Danh Mục Garage
            </button>
            <button type="button" id="tabCustomBtn" onclick="switchServiceTab('custom');" 
                    style="padding: 0.6rem 1rem; border: none; background: transparent; border-top-left-radius: 8px; border-top-right-radius: 8px; font-weight: 600; color: #64748b; cursor: pointer;">
                <i class="fa-solid fa-sparkles"></i> 2. Thợ Máy Tạo Dịch Vụ Mới / Phát Sinh
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/repair-order-detail" method="POST" style="padding: 1.5rem;">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
            <input type="hidden" name="action" value="addService">
            <input type="hidden" name="orderId" value="${order.orderId}">
            <input type="hidden" name="serviceSource" id="serviceSource" value="catalog">

            <!-- TAB 1: CATALOG SERVICE -->
            <div id="catalogTabContent">
                <div class="form-group" style="margin-bottom: 1rem;">
                    <label class="form-label" style="font-weight: 700;">Chọn dịch vụ từ bảng giá (*)</label>
                    <select name="serviceId" id="catalogServiceSelect" class="form-select" onchange="onCatalogServiceChange();">
                        <c:forEach items="${allServices}" var="s">
                            <option value="${s.serviceId}" data-price="${s.laborCost}" data-duration="${s.estimatedDuration}" data-category="${s.category}" data-name="${s.serviceName}">
                                [${s.category}] ${s.serviceName} - <fmt:formatNumber value="${s.laborCost}" pattern="#,###" /> ₫ (~${s.estimatedDuration}p)
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
                    <div class="form-group">
                        <label class="form-label" style="font-weight: 700;">Đơn giá tiền công (₫)</label>
                        <input type="number" name="customPrice" id="catalogPriceInput" class="form-control" oninput="calculatePreview();" placeholder="Đơn giá...">
                        <small style="color: var(--light-muted);">Thợ máy có thể điều chỉnh đơn giá nếu có thỏa thuận</small>
                    </div>

                    <div class="form-group">
                        <label class="form-label" style="font-weight: 700;">Số lượng (*)</label>
                        <input type="number" name="quantity" id="catalogQuantityInput" value="1" min="1" class="form-control" oninput="calculatePreview();" required>
                    </div>
                </div>

                <div class="form-group" style="margin-bottom: 1rem;">
                    <label class="form-label" style="font-weight: 700;">Ghi chú kỹ thuật viên / Tình trạng phát hiện</label>
                    <input type="text" name="notes" id="catalogNotesInput" class="form-control" placeholder="Ví dụ: Kiểm tra phát hiện mòn côn, khách đồng ý xử lý...">
                </div>
            </div>

            <!-- TAB 2: CUSTOM / EMERGENT SERVICE -->
            <div id="customTabContent" style="display: none;">
                <div class="form-group" style="margin-bottom: 1rem;">
                    <label class="form-label" style="font-weight: 700;">Nhóm dịch vụ (*)</label>
                    <input type="text" name="customCategory" id="customCategoryInput" class="form-control" list="catDatalist" value="Sửa chữa phát sinh" placeholder="Chọn hoặc nhập nhóm...">
                    <datalist id="catDatalist">
                        <option value="Sửa chữa phát sinh">
                        <option value="Bảo dưỡng định kỳ">
                        <option value="Động cơ & Hộp số">
                        <option value="Khung gầm & Phanh">
                        <option value="Điện & Điện lạnh">
                        <option value="Đồng sơn & Chăm sóc">
                    </datalist>
                </div>

                <div class="form-group" style="margin-bottom: 1rem;">
                    <label class="form-label" style="font-weight: 700;">Tên dịch vụ / Công việc phát sinh (*)</label>
                    <input type="text" name="customServiceName" id="customServiceNameInput" class="form-control" placeholder="Ví dụ: Hàn phục hồi tai gương chiếu hậu..." oninput="calculatePreview();">
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 0.75rem; margin-bottom: 1rem;">
                    <div class="form-group">
                        <label class="form-label" style="font-weight: 700;">Tiền công (₫) (*)</label>
                        <input type="number" name="customLaborCost" id="customCostInput" class="form-control" placeholder="250000" oninput="calculatePreview();">
                    </div>
                    <div class="form-group">
                        <label class="form-label" style="font-weight: 700;">Thời gian (~phút)</label>
                        <input type="number" name="customDuration" id="customDurationInput" value="30" min="5" step="5" class="form-control">
                    </div>
                    <div class="form-group">
                        <label class="form-label" style="font-weight: 700;">Số lượng (*)</label>
                        <input type="number" id="customQuantityInput" value="1" min="1" class="form-control" oninput="calculatePreview();">
                    </div>
                </div>

                <div class="form-group" style="margin-bottom: 1rem;">
                    <label class="form-label" style="font-weight: 700;">Ghi chú chi tiết</label>
                    <input type="text" id="customNotesInput" class="form-control" placeholder="Ví dụ: Phát hiện nứt vỡ khi nâng cầu kiểm tra gầm...">
                </div>
            </div>

            <!-- REAL-TIME CALCULATION PREVIEW BOX -->
            <div style="background: #f8fafc; border: 1.5px solid #e2e8f0; border-radius: 10px; padding: 1rem; margin: 1rem 0;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem; font-size: 0.85rem; color: #64748b;">
                    <span><i class="fa-solid fa-calculator"></i> TỰ ĐỘNG TÍNH TOÁN CHI PHÍ:</span>
                    <span id="previewFormulaText" style="font-weight: 600; color: #1e293b;">0 ₫ &times; 1</span>
                </div>

                <div style="display: flex; justify-content: space-between; align-items: center; font-size: 0.95rem; margin-bottom: 0.35rem;">
                    <span>+ Tiền dịch vụ thêm vào:</span>
                    <strong id="previewAdditionCost" style="color: #ff5a1f; font-size: 1.05rem;">+ 0 ₫</strong>
                </div>

                <div style="display: flex; justify-content: space-between; align-items: center; font-size: 0.9rem; color: #64748b; margin-bottom: 0.5rem;">
                    <span>Tổng chi phí xe hiện tại:</span>
                    <span><fmt:formatNumber value="${order.grandTotal}" pattern="#,###" /> ₫</span>
                </div>

                <div style="display: flex; justify-content: space-between; align-items: baseline; border-top: 1px dashed #cbd5e1; padding-top: 0.5rem;">
                    <span style="font-weight: 800; color: #0f172a;">TỔNG CHI PHÍ XE SAU KHI THÊM:</span>
                    <strong id="previewNewGrandTotal" style="color: #10b981; font-size: 1.35rem; font-weight: 900;">
                        <fmt:formatNumber value="${order.grandTotal}" pattern="#,###" /> ₫
                    </strong>
                </div>
            </div>

            <div style="text-align: right; display: flex; justify-content: flex-end; gap: 0.75rem; align-items: center;">
                <button type="button" class="btn btn-secondary" onclick="closeAddServiceModal();">Hủy</button>
                <button type="submit" class="btn btn-primary" style="background: #ff5a1f; border-color: #ff5a1f; font-weight: 700;">
                    <i class="fa-solid fa-plus-circle"></i> Thêm Dịch Vụ &amp; Tính Tiền Tự Động
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Modal 2: Add Spare Part -->
<div id="addPartModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 9999; align-items: center; justify-content: center; backdrop-filter: blur(2px);">
    <div class="card" style="width: 540px; max-width: 90%; background: #fff; border-radius: 12px; box-shadow: 0 20px 40px rgba(0,0,0,0.3);">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; border-bottom: 1px solid #f1f5f9; padding-bottom: 0.75rem;">
            <h3 style="font-size: 1.2rem; font-weight: 800; color: #0f172a; margin: 0;">
                <i class="fa-solid fa-boxes-stacked" style="color: #ff5a1f;"></i> Xuất Phụ Tùng Từ Kho
            </h3>
            <button type="button" onclick="document.getElementById('addPartModal').style.display='none';" style="background: none; border: none; font-size: 1.25rem; cursor: pointer; color: #64748b;">&times;</button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/repair-order-detail" method="POST">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
            <input type="hidden" name="action" value="addPart">
            <input type="hidden" name="orderId" value="${order.orderId}">

            <div class="form-group" style="margin-bottom: 1rem;">
                <label class="form-label" style="font-weight: 700;">Chọn phụ tùng trong kho (*)</label>
                <select name="partId" class="form-select" required>
                    <c:forEach items="${allParts}" var="p">
                        <option value="${p.partId}">${p.partName} [${p.partCode}] - Giá: <fmt:formatNumber value="${p.unitPrice}" pattern="#,###" /> ₫ (Còn: ${p.quantityInStock} ${p.unit})</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group" style="margin-bottom: 1rem;">
                <label class="form-label" style="font-weight: 700;">Số lượng xuất (*)</label>
                <input type="number" name="quantity" value="1" min="1" class="form-control" required>
            </div>

            <div class="form-group" style="margin-bottom: 1.25rem;">
                <label class="form-label" style="font-weight: 700;">Ghi chú vị trí lắp đặt / lý do</label>
                <input type="text" name="notes" class="form-control" placeholder="Ví dụ: Thay bên phụ...">
            </div>

            <div style="text-align: right; border-top: 1px solid #f1f5f9; padding-top: 1rem;">
                <button type="button" class="btn btn-secondary" onclick="document.getElementById('addPartModal').style.display='none';">Hủy</button>
                <button type="submit" class="btn btn-accent"><i class="fa-solid fa-check"></i> Xuất Kho &amp; Tự Động Tính Tiền</button>
            </div>
        </form>
    </div>
</div>

<c:if test="${sessionScope.currentUser.admin || sessionScope.currentUser.receptionist}">
<!-- Modal 3: Checkout / Settle Payment -->
<div id="checkoutModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 9999; align-items: center; justify-content: center; backdrop-filter: blur(2px);">
    <div class="card" style="width: 500px; max-width: 90%; background: #fff; border-radius: 12px; box-shadow: 0 20px 40px rgba(0,0,0,0.3);">
        <h3 style="font-size: 1.25rem; font-weight: 800; margin-bottom: 1rem; color: var(--success);">
            <i class="fa-solid fa-cash-register"></i> Quyết Toán Hóa Đơn Sửa Chữa
        </h3>
        <form action="${pageContext.request.contextPath}/admin/checkout" method="POST">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
            <input type="hidden" name="action" value="checkout">
            <input type="hidden" name="orderId" value="${order.orderId}">

            <div style="background: #f8fafc; padding: 1.25rem; border-radius: var(--radius-md); margin-bottom: 1rem; text-align: center; border: 1.5px solid #e2e8f0;">
                <div style="font-size: 0.9rem; color: #64748b; margin-bottom: 0.25rem;">Tổng số tiền quyết toán xe <c:out value="${order.carLicensePlate}" />:</div>
                <strong style="color: #ff5a1f; font-size: 1.6rem;"><fmt:formatNumber value="${order.grandTotal}" pattern="#,###" /> ₫</strong>
            </div>

            <div class="form-group" style="margin-bottom: 1rem;">
                <label class="form-label" style="font-weight: 700;">Hình thức thanh toán</label>
                <select name="paymentMethod" class="form-select">
                    <option value="CASH">Tiền mặt</option>
                    <option value="BANK_TRANSFER" selected>Chuyển khoản Ngân hàng (QR Code)</option>
                    <option value="CREDIT_CARD">Thẻ tín dụng (POS)</option>
                    <option value="VNPAY">Ví điện tử VNPAY</option>
                </select>
            </div>

            <div class="form-group" style="margin-bottom: 1.25rem;">
                <label class="form-label" style="font-weight: 700;">Ghi chú thanh toán</label>
                <input type="text" name="notes" class="form-control" placeholder="Đã nhận đủ tiền từ khách...">
            </div>

            <div style="text-align: right; border-top: 1px solid #f1f5f9; padding-top: 1rem;">
                <button type="button" class="btn btn-secondary" onclick="document.getElementById('checkoutModal').style.display='none';">Hủy</button>
                <button type="submit" class="btn btn-success"><i class="fa-solid fa-check"></i> Xác Nhận Quyết Toán</button>
            </div>
        </form>
    </div>
</div>
</c:if>

</main>
</div>

<script>
const currentGrandTotal = ${order.grandTotal != null ? order.grandTotal : 0};
let currentTab = 'catalog';

function formatVND(amount) {
    return new Intl.NumberFormat('vi-VN').format(Math.max(0, Math.round(amount))) + ' ₫';
}

function openAddServiceModal() {
    document.getElementById('addServiceModal').style.display = 'flex';
    onCatalogServiceChange();
}

function closeAddServiceModal() {
    document.getElementById('addServiceModal').style.display = 'none';
}

function switchServiceTab(tab) {
    currentTab = tab;
    document.getElementById('serviceSource').value = tab;
    const catalogTab = document.getElementById('catalogTabContent');
    const customTab = document.getElementById('customTabContent');
    const catalogBtn = document.getElementById('tabCatalogBtn');
    const customBtn = document.getElementById('tabCustomBtn');

    if (tab === 'catalog') {
        catalogTab.style.display = 'block';
        customTab.style.display = 'none';
        catalogBtn.style.background = '#fff';
        catalogBtn.style.color = '#ff5a1f';
        catalogBtn.style.borderBottom = '2px solid #ff5a1f';
        customBtn.style.background = 'transparent';
        customBtn.style.color = '#64748b';
        customBtn.style.borderBottom = 'none';
    } else {
        catalogTab.style.display = 'none';
        customTab.style.display = 'block';
        customBtn.style.background = '#fff';
        customBtn.style.color = '#ff5a1f';
        customBtn.style.borderBottom = '2px solid #ff5a1f';
        catalogBtn.style.background = 'transparent';
        catalogBtn.style.color = '#64748b';
        catalogBtn.style.borderBottom = 'none';
    }
    calculatePreview();
}

function onCatalogServiceChange() {
    const sel = document.getElementById('catalogServiceSelect');
    if (!sel || !sel.selectedOptions || sel.selectedOptions.length === 0) return;
    const opt = sel.selectedOptions[0];
    const price = Number(opt.getAttribute('data-price')) || 0;
    const priceInput = document.getElementById('catalogPriceInput');
    if (priceInput) {
        priceInput.value = Math.round(price);
    }
    calculatePreview();
}

function calculatePreview() {
    let unitPrice = 0;
    let qty = 1;

    if (currentTab === 'catalog') {
        const priceInput = document.getElementById('catalogPriceInput');
        const qtyInput = document.getElementById('catalogQuantityInput');
        unitPrice = Number(priceInput ? priceInput.value : 0) || 0;
        qty = Number(qtyInput ? qtyInput.value : 1) || 1;
    } else {
        const costInput = document.getElementById('customCostInput');
        const qtyInput = document.getElementById('customQuantityInput');
        unitPrice = Number(costInput ? costInput.value : 0) || 0;
        qty = Number(qtyInput ? qtyInput.value : 1) || 1;
        // copy custom quantity & notes to form inputs if needed
        const catQty = document.getElementById('catalogQuantityInput');
        const catNotes = document.getElementById('catalogNotesInput');
        const custNotes = document.getElementById('customNotesInput');
        if (catQty && qtyInput) catQty.value = qty;
        if (catNotes && custNotes) catNotes.value = custNotes.value;
    }

    const additionTotal = unitPrice * qty;
    const newGrandTotal = currentGrandTotal + additionTotal;

    const formulaEl = document.getElementById('previewFormulaText');
    const additionEl = document.getElementById('previewAdditionCost');
    const newTotalEl = document.getElementById('previewNewGrandTotal');

    if (formulaEl) formulaEl.textContent = formatVND(unitPrice) + ' × ' + qty;
    if (additionEl) additionEl.textContent = '+ ' + formatVND(additionTotal);
    if (newTotalEl) newTotalEl.textContent = formatVND(newGrandTotal);
}

// Ensure custom notes sync to catalogNotes on typing
document.getElementById('customNotesInput')?.addEventListener('input', function() {
    const catNotes = document.getElementById('catalogNotesInput');
    if (catNotes) catNotes.value = this.value;
});
document.getElementById('customQuantityInput')?.addEventListener('input', function() {
    const catQty = document.getElementById('catalogQuantityInput');
    if (catQty) catQty.value = this.value;
});
</script>

<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
