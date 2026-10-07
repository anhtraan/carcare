<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="cc" uri="/WEB-INF/tlds/carecar.tld" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="title" value="Cổng Thông Tin Chủ Xe - CareCar" />
</jsp:include>

<div style="background: #0f172a; color: #fff; padding: 2.5rem 1.5rem; border-bottom: 1px solid rgba(255,255,255,0.1);">
    <div class="container" style="padding: 0; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
        <div>
            <span class="badge badge-accent" style="margin-bottom: 0.5rem;">CỔNG THÔNG TIN KHÁCH HÀNG</span>
            <h1 style="font-size: 2rem; font-weight: 800;">Xin chào, ${sessionScope.currentUser.fullName}!</h1>
            <p style="color: #94a3b8; font-size: 0.9rem;">
                <i class="fa-solid fa-phone"></i> ${sessionScope.currentUser.phone} &bull; <i class="fa-solid fa-envelope"></i> ${sessionScope.currentUser.email}
            </p>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/booking" class="btn btn-accent">
                <i class="fa-solid fa-plus"></i> Đặt Lịch Hẹn Mới
            </a>
        </div>
    </div>
</div>

<div class="container" style="padding-top: 2.5rem; padding-bottom: 4rem;">
    <!-- My Cars Section -->
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.25rem;">
        <h2 style="font-size: 1.4rem; font-weight: 700;"><i class="fa-solid fa-car"></i> Danh Sách Xe Của Tôi</h2>
    </div>

    <div class="grid-3" style="margin-bottom: 3rem;">
        <c:forEach items="${cars}" var="car">
            <div class="card" style="border-left: 4px solid var(--primary);">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 0.5rem;">
                    <span style="font-size: 1.15rem; font-weight: 800; background: #e2e8f0; padding: 0.2rem 0.6rem; border-radius: 6px; letter-spacing: 1px;">
                        ${car.licensePlate}
                    </span>
                    <span class="badge badge-info">${car.brand}</span>
                </div>
                <h3 style="font-size: 1.1rem; margin-top: 0.5rem;">${car.model}</h3>
                <div style="font-size: 0.875rem; color: var(--light-muted); margin-top: 0.5rem; line-height: 1.6;">
                    <div><strong>Năm SX:</strong> ${car.yearManufactured != null ? car.yearManufactured : '—'} &bull; <strong>Màu:</strong> ${car.color}</div>
                    <div><strong>Số KM hiện tại (ODO):</strong> <fmt:formatNumber value="${car.currentMileage}" pattern="#,###" /> km</div>
                </div>
                <div style="margin-top: 1rem; border-top: 1px solid var(--light-border); padding-top: 0.75rem;">
                    <a href="${pageContext.request.contextPath}/track?q=${car.licensePlate}" class="btn btn-sm btn-primary" style="width: 100%;">
                        <i class="fa-solid fa-magnifying-glass-location"></i> Xem Tiến Độ Sửa Xe Này
                    </a>
                </div>
            </div>
        </c:forEach>

        <!-- Add Car Card -->
        <div class="card" style="border: 2px dashed var(--light-border); display: flex; flex-direction: column; justify-content: center; align-items: center; text-align: center; background: #f8fafc; cursor: pointer;" onclick="document.getElementById('addCarForm').style.display = document.getElementById('addCarForm').style.display === 'none' ? 'block' : 'none';">
            <div style="width: 48px; height: 48px; border-radius: 50%; background: #eff6ff; color: var(--primary); display: flex; align-items: center; justify-content: center; font-size: 1.25rem; margin-bottom: 0.75rem;">
                <i class="fa-solid fa-plus"></i>
            </div>
            <h4 style="font-size: 1rem; font-weight: 700;">Thêm Xe Ô Tô Khác</h4>
            <p style="font-size: 0.8rem; color: var(--light-muted);">Bấm để đăng ký thêm xe vào tài khoản</p>
        </div>
    </div>

    <!-- Hidden Add Car Form -->
    <div id="addCarForm" class="card" style="display: none; margin-bottom: 3rem; background: #fff; border: 1px solid var(--primary);">
        <h3 style="font-size: 1.15rem; margin-bottom: 1.25rem; color: var(--primary);"><i class="fa-solid fa-plus-circle"></i> Đăng Ký Thông Tin Xe Mới</h3>
        <form action="${pageContext.request.contextPath}/customer/add-car" method="POST">
            <input type="hidden" name="action" value="addCar">
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem;">
                <div class="form-group">
                    <label class="form-label">Biển số xe (*)</label>
                    <input type="text" name="licensePlate" class="form-control" placeholder="30A-123.45" required style="text-transform: uppercase;">
                </div>
                <div class="form-group">
                    <label class="form-label">Hãng xe (*)</label>
                    <input type="text" name="brand" class="form-control" placeholder="Toyota, Mazda, Mercedes..." required>
                </div>
                <div class="form-group">
                    <label class="form-label">Dòng xe (Model)</label>
                    <input type="text" name="model" class="form-control" placeholder="Camry, CX-5, VF8...">
                </div>
                <div class="form-group">
                    <label class="form-label">Màu sơn</label>
                    <input type="text" name="color" class="form-control" placeholder="Trắng, Đen, Đỏ...">
                </div>
                <div class="form-group">
                    <label class="form-label">Số Km hiện tại (ODO)</label>
                    <input type="number" name="currentMileage" class="form-control" placeholder="25000">
                </div>
            </div>
            <div style="text-align: right; margin-top: 1rem;">
                <button type="button" class="btn btn-secondary" onclick="document.getElementById('addCarForm').style.display='none';">Hủy</button>
                <button type="submit" class="btn btn-primary"><i class="fa-solid fa-save"></i> Lưu Thông Tin Xe</button>
            </div>
        </form>
    </div>

    <!-- Repair Orders History -->
    <div style="margin-bottom: 3rem;">
        <h2 style="font-size: 1.4rem; font-weight: 700; margin-bottom: 1.25rem;"><i class="fa-solid fa-clock-rotate-left"></i> Lịch Sử Sửa Chữa &amp; Bảo Dưỡng</h2>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Mã Lệnh</th>
                        <th>Biển Số Xe</th>
                        <th>Ngày Vào</th>
                        <th>Tình Trạng / Dịch Vụ</th>
                        <th style="text-align: right;">Tổng Tiền</th>
                        <th>Trạng Thái</th>
                        <th style="text-align: center;">Chi Tiết</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${orders}" var="ord">
                        <tr>
                            <td><strong>${ord.orderCode}</strong></td>
                            <td><span style="font-weight: 700; background: #f1f5f9; padding: 0.15rem 0.4rem; border-radius: 4px;">${ord.carLicensePlate}</span></td>
                            <td><fmt:formatDate value="${ord.entryDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                            <td>${ord.initialDiagnosis}</td>
                            <td style="text-align: right; font-weight: 700; color: var(--primary);">
                                <cc:formatCurrency value="${ord.grandTotal}" />
                            </td>
                            <td>
                                <cc:statusBadge status="${ord.orderStatus}" type="order" />
                            </td>
                            <td style="text-align: center; white-space: nowrap;">
                                <a href="${pageContext.request.contextPath}/track?q=${ord.orderCode}" class="btn btn-sm btn-secondary me-1">
                                    <i class="fa-solid fa-eye"></i> Xem
                                </a>
                                <c:if test="${ord.orderStatus != 'PAID_DELIVERED' && ord.orderStatus != 'CANCELLED'}">
                                    <a href="${pageContext.request.contextPath}/payment/vnpay-create?orderId=${ord.orderId}" 
                                       class="btn btn-sm btn-warning" title="Thanh toán VNPay Sandbox" style="background: #ea580c; border-color: #ea580c; color: #fff;">
                                        <i class="fa-solid fa-credit-card"></i> Trả tiền
                                    </a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty orders}">
                        <tr>
                            <td colspan="7" style="text-align: center; color: var(--light-muted); padding: 2rem;">Chưa có lịch sử sửa chữa nào.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />
