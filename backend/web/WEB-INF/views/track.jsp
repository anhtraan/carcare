<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="cc" uri="/WEB-INF/tlds/carecar.tld" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="title" value="Tra Cứu Tiến Độ Sửa Chữa Ô Tô Trực Tuyến - CareCar" />
</jsp:include>

<div style="background: #0f172a; color: #fff; padding: 3.5rem 1.5rem 4rem; border-bottom: 1px solid rgba(255,255,255,0.1);">
    <div class="container" style="max-width: 800px; padding: 0; text-align: center;">
        <span class="badge badge-warning" style="margin-bottom: 0.75rem;">THEO DÕI THỜI GIAN THỰC</span>
        <h1 style="font-size: 2.25rem; font-weight: 800; margin-bottom: 0.5rem;">Tra Cứu Tiến Độ Xe Tại Xưởng</h1>
        <p style="color: #94a3b8; margin-bottom: 2rem;">
            Theo dõi chi tiết từng bước kiểm tra, chẩn đoán, phụ tùng thay thế và thời gian hoàn thành xe của bạn.
        </p>

        <form action="${pageContext.request.contextPath}/track" method="GET">
            <div class="quick-track-box" style="padding: 0.5rem; gap: 0.5rem; flex-wrap: wrap;">
                <input type="text" name="q" value="<c:out value='${query}' />" placeholder="Biển số xe (30H-888.99) hoặc Mã (CC-2026-0001)..." style="flex: 2; min-width: 240px;" required>
                <input type="text" name="phoneLast4" value="<c:out value='${phoneLast4}' />" maxlength="4" pattern="\d{4}" placeholder="4 số cuối SĐT chủ xe (vd: 8200)..." style="flex: 1; min-width: 180px; border-left: 1px solid #e2e8f0;" required>
                <button type="submit" class="btn btn-primary btn-lg" style="white-space: nowrap;">
                    <i class="fa-solid fa-magnifying-glass"></i> Kiểm tra ngay
                </button>
            </div>
            <div style="font-size: 0.825rem; color: #94a3b8; margin-top: 0.6rem; text-align: left;">
                <i class="fa-solid fa-shield-halved" style="color: #38bdf8;"></i> Bảo mật thông tin: Yêu cầu 4 số cuối số điện thoại đăng ký của chủ xe để ngăn chặn quét dữ liệu trái phép.
            </div>
        </form>
    </div>
</div>

<div class="container" style="max-width: 1000px; padding-top: 3rem; padding-bottom: 4rem;">
    <c:if test="${not empty rateLimitError}">
        <div class="alert alert-danger" style="background: #fee2e2; border-left: 4px solid #ef4444; color: #991b1b; padding: 1.25rem 1.5rem; border-radius: 8px; margin-bottom: 2rem;">
            <div style="display: flex; align-items: center; gap: 0.75rem;">
                <i class="fa-solid fa-triangle-exclamation" style="font-size: 1.5rem; color: #ef4444;"></i>
                <div>
                    <h4 style="margin: 0; font-size: 1.05rem; font-weight: 700;">Giới Hạn Tần Suất Tra Cứu</h4>
                    <p style="margin: 0.25rem 0 0; font-size: 0.925rem;"><c:out value="${rateLimitError}" /></p>
                </div>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty authPhoneError}">
        <div class="alert alert-warning" style="background: #fef3c7; border-left: 4px solid #f59e0b; color: #92400e; padding: 1.25rem 1.5rem; border-radius: 8px; margin-bottom: 2rem;">
            <div style="display: flex; align-items: center; gap: 0.75rem;">
                <i class="fa-solid fa-shield-cat" style="font-size: 1.5rem; color: #f59e0b;"></i>
                <div>
                    <h4 style="margin: 0; font-size: 1.05rem; font-weight: 700;">Xác Thực Bảo Mật Chủ Xe</h4>
                    <p style="margin: 0.25rem 0 0; font-size: 0.925rem;"><c:out value="${authPhoneError}" /></p>
                </div>
            </div>
        </div>
    </c:if>

    <c:if test="${searched and empty orders and empty rateLimitError and empty authPhoneError}">
        <div class="card" style="text-align: center; padding: 3rem;">
            <div style="font-size: 3rem; color: #94a3b8; margin-bottom: 1rem;"><i class="fa-solid fa-car-tunnel"></i></div>
            <h3 style="font-size: 1.35rem; margin-bottom: 0.5rem;">Không tìm thấy lệnh sửa chữa phù hợp</h3>
            <p style="color: var(--light-muted); max-width: 500px; margin: 0 auto 1.5rem;">
                Không có phiếu sửa chữa nào khớp với từ khóa <strong>"<c:out value="${query}" />"</strong> kết hợp với 4 số cuối điện thoại đã nhập. Vui lòng kiểm tra lại thông tin hoặc liên hệ hotline để được hỗ trợ.
            </p>
            <a href="${pageContext.request.contextPath}/booking" class="btn btn-primary">Đặt Lịch Tiếp Nhận Mới</a>
        </div>
    </c:if>

    <c:if test="${not empty orders}">
        <c:forEach items="${orders}" var="order">
            <div class="card" style="margin-bottom: 2.5rem; padding: 2rem; border-radius: var(--radius-lg); box-shadow: var(--shadow-md);">
                
                <!-- Order Header -->
                <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 1rem; border-bottom: 1px solid var(--light-border); padding-bottom: 1.25rem;">
                    <div>
                        <div style="display: flex; align-items: center; gap: 0.75rem;">
                            <h2 style="font-size: 1.6rem; font-weight: 800; color: var(--light-text);"><c:out value="${order.orderCode}" /></h2>
                            <span class="badge ${order.orderStatus == 'PAID_DELIVERED' ? 'badge-delivered' : (order.orderStatus == 'COMPLETED_WAITING_PAYMENT' ? 'badge-success' : (order.orderStatus == 'IN_PROGRESS' ? 'badge-primary' : 'badge-warning'))}">
                                ${order.orderStatus}
                            </span>
                        </div>
                        <p style="color: var(--light-muted); font-size: 0.9rem; margin-top: 0.35rem;">
                            <i class="fa-regular fa-clock"></i> Tiếp nhận: <fmt:formatDate value="${order.entryDate}" pattern="dd/MM/yyyy HH:mm" />
                            <c:if test="${not empty order.expectedFinishDate}">
                                &bull; Dự kiến xong: <strong style="color: var(--primary);"><fmt:formatDate value="${order.expectedFinishDate}" pattern="dd/MM/yyyy HH:mm" /></strong>
                            </c:if>
                        </p>
                    </div>

                    <div style="text-align: right;">
                        <span style="font-size: 0.85rem; color: var(--light-muted); display: block;">Tổng chi phí ước tính</span>
                        <span style="font-size: 1.6rem; font-weight: 900; color: var(--accent);">
                            <fmt:formatNumber value="${order.grandTotal}" pattern="#,###" /> ₫
                        </span>
                    </div>
                </div>

                <!-- Stepper Progress Bar -->
                <div class="tracking-timeline">
                    <div class="tracking-step completed">
                        <div class="step-bubble"><i class="fa-solid fa-check"></i></div>
                        <div class="step-label">1. Tiếp nhận</div>
                    </div>
                    <div class="tracking-step ${order.orderStatus != 'PENDING_INSPECTION' ? 'completed' : 'active'}">
                        <div class="step-bubble">${order.orderStatus != 'PENDING_INSPECTION' ? '<i class="fa-solid fa-check"></i>' : '2'}</div>
                        <div class="step-label">2. Báo giá</div>
                    </div>
                    <div class="tracking-step ${order.orderStatus == 'IN_PROGRESS' ? 'active' : (order.orderStatus == 'COMPLETED_WAITING_PAYMENT' || order.orderStatus == 'PAID_DELIVERED' ? 'completed' : '')}">
                        <div class="step-bubble">${order.orderStatus == 'COMPLETED_WAITING_PAYMENT' || order.orderStatus == 'PAID_DELIVERED' ? '<i class="fa-solid fa-check"></i>' : '3'}</div>
                        <div class="step-label">3. Đang sửa</div>
                    </div>
                    <div class="tracking-step ${order.orderStatus == 'COMPLETED_WAITING_PAYMENT' ? 'active' : (order.orderStatus == 'PAID_DELIVERED' ? 'completed' : '')}">
                        <div class="step-bubble">${order.orderStatus == 'PAID_DELIVERED' ? '<i class="fa-solid fa-check"></i>' : '4'}</div>
                        <div class="step-label">4. Sửa xong</div>
                    </div>
                    <div class="tracking-step ${order.orderStatus == 'PAID_DELIVERED' ? 'completed active' : ''}">
                        <div class="step-bubble">${order.orderStatus == 'PAID_DELIVERED' ? '<i class="fa-solid fa-flag-checkered"></i>' : '5'}</div>
                        <div class="step-label">5. Giao xe</div>
                    </div>
                </div>

                <!-- Car & Customer Information Info Grid -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; background: #f8fafc; border-radius: var(--radius-md); padding: 1.25rem; margin-bottom: 2rem;">
                    <div>
                        <h4 style="font-size: 0.95rem; color: var(--primary); margin-bottom: 0.5rem;"><i class="fa-solid fa-car"></i> Phương Tiện</h4>
                        <div style="font-size: 0.925rem; line-height: 1.6;">
                            <div><strong>Biển số:</strong> <span style="background: #e2e8f0; padding: 0.1rem 0.4rem; border-radius: 4px; font-weight: bold;"><c:out value="${order.carLicensePlate}" /></span></div>
                            <div><strong>Xe:</strong> <c:out value="${order.carBrand}" /> <c:out value="${order.carModel}" /> (<c:out value="${order.carColor}" />)</div>
                            <div><strong>ODO lúc vào:</strong> <fmt:formatNumber value="${order.entryMileage}" pattern="#,###" /> km</div>
                        </div>
                    </div>

                    <div>
                        <h4 style="font-size: 0.95rem; color: var(--primary); margin-bottom: 0.5rem;"><i class="fa-solid fa-user-gear"></i> Phụ Trách</h4>
                        <div style="font-size: 0.925rem; line-height: 1.6;">
                            <div><strong>Khách hàng:</strong> <c:out value="${order.maskedCustomerName}" /> - <span style="font-family: monospace; font-weight: 600;"><c:out value="${order.maskedCustomerPhone}" /></span></div>
                            <div><strong>Cố vấn dịch vụ:</strong> <c:out value="${order.receptionistName != null ? order.receptionistName : 'Đang cập nhật'}" /></div>
                            <div><strong>Thợ máy chính:</strong> <c:out value="${order.mechanicName != null ? order.mechanicName : 'Đang phân công'}" /></div>
                        </div>
                    </div>
                </div>

                <!-- Diagnostics & Notes -->
                <div style="margin-bottom: 2rem;">
                    <h4 style="font-size: 1rem; font-weight: 700; margin-bottom: 0.5rem;"><i class="fa-solid fa-clipboard-list"></i> Tình Trạng Tiếp Nhận &amp; Kiểm Tra Kỹ Thuật:</h4>
                    <p style="background: #fff; border-left: 4px solid var(--accent); padding: 0.75rem 1rem; border-radius: 4px; font-size: 0.925rem; margin-bottom: 0.5rem; color: #334155;">
                        <strong>Yêu cầu của khách:</strong> <c:out value="${order.initialDiagnosis}" />
                    </p>
                    <c:if test="${not empty order.technicianNotes}">
                        <p style="background: #fff; border-left: 4px solid var(--primary); padding: 0.75rem 1rem; border-radius: 4px; font-size: 0.925rem; color: #334155;">
                            <strong>Kết luận kỹ thuật:</strong> <c:out value="${order.technicianNotes}" />
                        </p>
                    </c:if>
                </div>

                <!-- Work Details Table (Services & Parts) -->
                <h4 style="font-size: 1rem; font-weight: 700; margin-bottom: 0.75rem;"><i class="fa-solid fa-list-check"></i> Chi Tiết Hạng Mục Sửa Chữa &amp; Phụ Tùng:</h4>
                <div class="table-responsive" style="margin-bottom: 1.5rem;">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Hạng Mục / Phụ Tùng</th>
                                <th>Loại</th>
                                <th>Số Lượng</th>
                                <th style="text-align: right;">Đơn Giá</th>
                                <th style="text-align: right;">Thành Tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="stt" value="1" />
                            <c:forEach items="${order.services}" var="s">
                                <tr>
                                    <td>${stt}</td>
                                    <td><strong><c:out value="${s.serviceName}" /></strong><br><small style="color: var(--light-muted);"><c:out value="${s.notes}" /></small></td>
                                    <td><span class="badge badge-info">Dịch vụ</span></td>
                                    <td>${s.quantity}</td>
                                    <td style="text-align: right;"><fmt:formatNumber value="${s.price}" pattern="#,###" /> ₫</td>
                                    <td style="text-align: right; font-weight: 600;"><fmt:formatNumber value="${s.subtotal}" pattern="#,###" /> ₫</td>
                                </tr>
                                <c:set var="stt" value="${stt + 1}" />
                            </c:forEach>
                            <c:forEach items="${order.parts}" var="p">
                                <tr>
                                    <td>${stt}</td>
                                    <td><strong><c:out value="${p.partName}" /></strong> [<c:out value="${p.partCode}" />]<br><small style="color: var(--light-muted);"><c:out value="${p.notes}" /></small></td>
                                    <td><span class="badge badge-warning">Phụ tùng</span></td>
                                    <td>${p.quantity}</td>
                                    <td style="text-align: right;"><fmt:formatNumber value="${p.unitPrice}" pattern="#,###" /> ₫</td>
                                    <td style="text-align: right; font-weight: 600;"><fmt:formatNumber value="${p.subtotal}" pattern="#,###" /> ₫</td>
                                </tr>
                                <c:set var="stt" value="${stt + 1}" />
                            </c:forEach>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="5" style="text-align: right; font-weight: 600;">Tổng tiền dịch vụ:</td>
                                <td style="text-align: right; font-weight: 600;"><fmt:formatNumber value="${order.totalServiceCost}" pattern="#,###" /> ₫</td>
                            </tr>
                            <tr>
                                <td colspan="5" style="text-align: right; font-weight: 600;">Tổng tiền phụ tùng:</td>
                                <td style="text-align: right; font-weight: 600;"><fmt:formatNumber value="${order.totalPartCost}" pattern="#,###" /> ₫</td>
                            </tr>
                            <c:if test="${order.discountAmount > 0}">
                                <tr>
                                    <td colspan="5" style="text-align: right; font-weight: 600; color: var(--danger);">Giảm giá ưu đãi:</td>
                                    <td style="text-align: right; font-weight: 600; color: var(--danger);">-<fmt:formatNumber value="${order.discountAmount}" pattern="#,###" /> ₫</td>
                                </tr>
                            </c:if>
                            <c:if test="${order.taxVat > 0}">
                                <tr>
                                    <td colspan="5" style="text-align: right; font-weight: 600;">Thuế VAT:</td>
                                    <td style="text-align: right; font-weight: 600;">+<fmt:formatNumber value="${order.taxVat}" pattern="#,###" /> ₫</td>
                                </tr>
                            </c:if>
                            <tr style="background: #f8fafc; font-size: 1.15rem;">
                                <td colspan="5" style="text-align: right; font-weight: 800; color: var(--primary);">TỔNG CỘNG THANH TOÁN:</td>
                                <td style="text-align: right; font-weight: 900; color: var(--accent);"><cc:formatCurrency value="${order.grandTotal}" /></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>

                <!-- Online Payment Sandbox & VietQR Section -->
                <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: var(--radius-md); padding: 1.5rem; margin-top: 1.5rem;">
                    <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
                        <div>
                            <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--light-text); margin-bottom: 0.35rem;">
                                <i class="fa-solid fa-credit-card" style="color: var(--primary);"></i> Thanh Toán Trực Tuyến &amp; Quyết Toán
                            </h4>
                            <p style="font-size: 0.875rem; color: var(--light-muted); margin-bottom: 0;">
                                Hỗ trợ cổng thanh toán điện tử VNPay Sandbox và Chuyển khoản nhanh VietQR 24/7.
                            </p>
                        </div>
                        <div style="display: flex; gap: 0.75rem; align-items: center; flex-wrap: wrap;">
                            <c:choose>
                                <c:when test="${order.orderStatus == 'PAID_DELIVERED'}">
                                    <span class="badge badge-success" style="font-size: 0.95rem; padding: 0.6rem 1.2rem;">
                                        <i class="fa-solid fa-circle-check"></i> Đã Thanh Toán Hoàn Tất
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/payment/vnpay-create?orderId=${order.orderId}" 
                                       class="btn btn-warning" style="font-weight: 700; display: inline-flex; align-items: center; gap: 0.5rem; background: #ea580c; border-color: #ea580c; color: #fff;">
                                        <i class="fa-solid fa-wallet"></i> Thanh Toán VNPay Sandbox
                                    </a>
                                    <button type="button" class="btn btn-primary" onclick="document.getElementById('vietqr-modal-${order.orderId}').style.display='flex';">
                                        <i class="fa-solid fa-qrcode"></i> Quét Mã VietQR
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- VietQR Modal -->
                <div id="vietqr-modal-${order.orderId}" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 9999; align-items: center; justify-content: center;">
                    <div class="card" style="width: 440px; max-width: 90%; background: #fff; text-align: center; padding: 2rem; border-radius: var(--radius-lg);">
                        <h3 style="font-size: 1.2rem; font-weight: 800; color: var(--primary); margin-bottom: 0.5rem;">Mã Chuyển Khoản VietQR</h3>
                        <p style="font-size: 0.85rem; color: #64748b; margin-bottom: 1rem;">Mở ứng dụng Mobile Banking bất kỳ quét mã để thanh toán tức thì</p>
                        
                        <div style="background: #fff; padding: 0.5rem; border: 2px dashed #cbd5e1; border-radius: 12px; display: inline-block; margin-bottom: 1rem;">
                            <img src="<cc:vietQR amount='${order.grandTotal}' orderCode='${order.orderCode}' />" 
                                 alt="VietQR Payment" style="max-width: 100%; height: auto; border-radius: 8px;">
                        </div>

                        <div style="font-size: 0.9rem; text-align: left; background: #f8fafc; padding: 0.75rem 1rem; border-radius: 8px; margin-bottom: 1.25rem;">
                            <div><strong>Số tiền:</strong> <span style="color: var(--accent); font-weight: 800;"><cc:formatCurrency value="${order.grandTotal}" /></span></div>
                            <div><strong>Nội dung:</strong> <span style="font-family: monospace; font-weight: 700;">THANH TOAN ${order.orderCode}</span></div>
                            <div><strong>Chủ TK:</strong> GARAGE CARECAR AUTO</div>
                        </div>

                        <div style="display: flex; gap: 0.5rem; justify-content: center;">
                            <button type="button" class="btn btn-secondary" onclick="document.getElementById('vietqr-modal-${order.orderId}').style.display='none';">Đóng</button>
                            <a href="${pageContext.request.contextPath}/payment/vnpay-create?orderId=${order.orderId}" class="btn btn-warning" style="background: #ea580c; border-color: #ea580c; color: #fff;">
                                Thanh toán qua VNPay
                            </a>
                        </div>
                    </div>
                </div>

            </div>
        </c:forEach>
    </c:if>
</div>

<jsp:include page="includes/footer.jsp" />
