<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../includes/admin-navbar.jsp">
    <jsp:param name="title" value="Tiếp Nhận Xe &amp; Tạo Phiếu Sửa Chữa Mới - CareCar" />
</jsp:include>
<jsp:include page="../includes/admin-sidebar.jsp" />

<div style="margin-bottom: 1.5rem;">
    <a href="${pageContext.request.contextPath}/admin/repair-orders" class="btn btn-sm btn-secondary">
        <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
    </a>
    <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--light-text); margin-top: 0.5rem;">
        Tiếp Nhận Xe &amp; Tạo Lệnh Sửa Chữa (Work Order)
    </h1>
    <p style="color: var(--light-muted); font-size: 0.9rem;">Thợ máy và Admin có thể kê khai dịch vụ ban đầu, hệ thống sẽ tự động tính toán tổng chi phí sửa chữa ngay khi tạo phiếu.</p>
</div>

<c:if test="${not empty errorMessage}">
    <div class="alert alert-danger"><i class="fa-solid fa-circle-exclamation"></i> ${errorMessage}</div>
</c:if>

<div class="card" style="max-width: 950px; padding: 2rem;">
    <form action="${pageContext.request.contextPath}/admin/repair-order-create" method="POST">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
        
        <!-- Selection: Existing or New Customer -->
        <div style="background: #f8fafc; padding: 1rem 1.25rem; border-radius: var(--radius-md); margin-bottom: 1.5rem; display: flex; gap: 2rem; border: 1.5px solid #e2e8f0;">
            <label style="font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 0.5rem; color: #0f172a;">
                <input type="radio" name="customerType" value="existing" checked onclick="toggleCustomerMode('existing')">
                <span>Khách hàng &amp; Xe ĐÃ CÓ trong hệ thống</span>
            </label>
            <label style="font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 0.5rem; color: #0f172a;">
                <input type="radio" name="customerType" value="new" onclick="toggleCustomerMode('new')">
                <span>Khách hàng &amp; Xe MỚI (Lần đầu đến xưởng)</span>
            </label>
        </div>

        <!-- Section 1A: Existing Customer / Car -->
        <div id="existingCustomerSection">
            <h3 style="font-size: 1.1rem; font-weight: 700; color: var(--primary); margin-bottom: 1rem;">
                <i class="fa-solid fa-users"></i> 1. Chọn Khách Hàng &amp; Phương Tiện
            </h3>
            
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.25rem; margin-bottom: 1.5rem;">
                <div class="form-group">
                    <label class="form-label" style="font-weight: 700;">Chọn khách hàng (*)</label>
                    <select name="customerId" class="form-select">
                        <c:forEach items="${customers}" var="c">
                            <option value="${c.customerId}">${c.fullName} - ${c.phone} (${c.address})</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" style="font-weight: 700;">Chọn xe của khách (*)</label>
                    <select name="carId" class="form-select">
                        <c:forEach items="${cars}" var="car">
                            <option value="${car.carId}">${car.licensePlate} (${car.brand} ${car.model} - ${car.customerName})</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
        </div>

        <!-- Section 1B: New Customer / Car (Hidden by default) -->
        <div id="newCustomerSection" style="display: none; border-top: 1px dashed var(--light-border); padding-top: 1rem; margin-bottom: 1.5rem;">
            <h3 style="font-size: 1.1rem; font-weight: 700; color: var(--primary); margin-bottom: 1rem;">
                <i class="fa-solid fa-user-plus"></i> 1. Thông Tin Khách &amp; Xe Mới
            </h3>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
                <div class="form-group">
                    <label class="form-label" style="font-weight: 700;">Họ tên khách hàng (*)</label>
                    <input type="text" name="newCustomerName" class="form-control" placeholder="Nguyễn Văn A">
                </div>
                <div class="form-group">
                    <label class="form-label" style="font-weight: 700;">Số điện thoại (*)</label>
                    <input type="tel" name="newCustomerPhone" class="form-control" placeholder="0901234567">
                </div>
                <div class="form-group">
                    <label class="form-label" style="font-weight: 700;">Email</label>
                    <input type="email" name="newCustomerEmail" class="form-control" placeholder="email@gmail.com">
                </div>
                <div class="form-group">
                    <label class="form-label" style="font-weight: 700;">Địa chỉ</label>
                    <input type="text" name="newCustomerAddress" class="form-control" placeholder="Địa chỉ...">
                </div>
            </div>

            <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 1rem;">
                <div class="form-group">
                    <label class="form-label" style="font-weight: 700;">Biển số xe (*)</label>
                    <input type="text" name="newLicensePlate" class="form-control" placeholder="30A-999.88" style="text-transform: uppercase;">
                </div>
                <div class="form-group">
                    <label class="form-label" style="font-weight: 700;">Hãng xe (*)</label>
                    <input type="text" name="newCarBrand" class="form-control" placeholder="Toyota, Mazda, BMW...">
                </div>
                <div class="form-group">
                    <label class="form-label" style="font-weight: 700;">Dòng xe</label>
                    <input type="text" name="newCarModel" class="form-control" placeholder="Camry, CX-5, 320i...">
                </div>
                <div class="form-group">
                    <label class="form-label" style="font-weight: 700;">Màu sơn</label>
                    <input type="text" name="newCarColor" class="form-control" placeholder="Trắng, Đen, Đỏ...">
                </div>
            </div>
        </div>

        <!-- Section 2: Reception Details -->
        <h3 style="font-size: 1.1rem; font-weight: 700; color: var(--primary); margin: 1.5rem 0 1rem; border-top: 1px solid var(--light-border); padding-top: 1.5rem;">
            <i class="fa-solid fa-clipboard-check"></i> 2. Thông Tin Tiếp Nhận Tại Xưởng
        </h3>

        <div style="display: grid; grid-template-columns: 1fr 1fr 1.2fr; gap: 1.25rem; margin-bottom: 1rem;">
            <div class="form-group">
                <label class="form-label" style="font-weight: 700;">Số Km lúc tiếp nhận (ODO)</label>
                <input type="number" name="entryMileage" class="form-control" placeholder="Ví dụ: 45000">
            </div>

            <div class="form-group">
                <label class="form-label" style="font-weight: 700;">Dự kiến hoàn thành</label>
                <input type="datetime-local" name="expectedFinishDate" class="form-control">
            </div>

            <div class="form-group">
                <label class="form-label" style="font-weight: 700;">Phân công kỹ thuật viên</label>
                <select name="mechanicId" class="form-select">
                    <option value="">-- Phân công sau khi kiểm tra --</option>
                    <c:forEach items="${mechanics}" var="m">
                        <option value="${m.userId}" ${m.busy ? 'disabled style="color: #dc2626; background: #fef2f2;"' : ''}>
                            ${m.fullName} - ${m.phone}
                            <c:choose>
                                <c:when test="${m.busy}">
                                    [ĐÃ CÓ LỊCH: ${m.scheduleNote}]
                                </c:when>
                                <c:otherwise>
                                    [Trống lịch / Sẵn sàng]
                                </c:otherwise>
                            </c:choose>
                        </option>
                    </c:forEach>
                </select>
                <small style="color: var(--light-muted); display: block; margin-top: 0.25rem;">
                    <i class="fa-solid fa-shield-halved text-success"></i> Tự động khóa thợ đang có lịch
                </small>
            </div>
        </div>

        <div class="form-group" style="margin-bottom: 1.5rem;">
            <label class="form-label" style="font-weight: 700;">Hiện tượng hư hỏng / Yêu cầu của khách hàng (*)</label>
            <textarea name="initialDiagnosis" class="form-control" rows="3" placeholder="Mô tả chi tiết triệu chứng, yêu cầu sửa chữa hoặc bảo dưỡng..." required></textarea>
        </div>

        <!-- Section 3: Optional Initial Services -->
        <h3 style="font-size: 1.1rem; font-weight: 700; color: var(--primary); margin: 1.5rem 0 0.5rem; border-top: 1px solid var(--light-border); padding-top: 1.5rem; display: flex; justify-content: space-between; align-items: center;">
            <span><i class="fa-solid fa-list-check"></i> 3. Chọn Dịch Vụ Tiếp Nhận Ban Đầu (Tùy chọn)</span>
            <small style="font-size: 0.8rem; color: #10b981; font-weight: 600;"><i class="fa-solid fa-bolt"></i> Tự động tính chi phí</small>
        </h3>
        <p style="color: var(--light-muted); font-size: 0.85rem; margin-bottom: 1rem;">Thợ máy và Admin có thể tích chọn nhanh các dịch vụ bảo dưỡng/sửa chữa ban đầu. Chi phí xe sẽ tự động được tính toán.</p>

        <div style="background: #f8fafc; border: 1.5px solid #e2e8f0; border-radius: 10px; padding: 1.25rem; max-height: 280px; overflow-y: auto;">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.75rem;">
                <c:forEach items="${allServices}" var="s">
                    <label style="display: flex; align-items: flex-start; gap: 0.65rem; background: #fff; padding: 0.65rem 0.85rem; border-radius: 8px; border: 1px solid #e2e8f0; cursor: pointer;">
                        <input type="checkbox" name="selectedServices" value="${s.serviceId}" data-price="${s.laborCost}" onchange="recalculateCreateEstimate();" style="margin-top: 0.25rem;">
                        <div style="font-size: 0.875rem;">
                            <div style="font-weight: 700; color: #0f172a;">${s.serviceName}</div>
                            <div style="color: #64748b; font-size: 0.8rem;">
                                <span class="badge badge-info" style="font-size: 0.7rem; padding: 0.15rem 0.4rem;">${s.category}</span>
                                <strong style="color: #ff5a1f; margin-left: 0.35rem;"><fmt:formatNumber value="${s.laborCost}" pattern="#,###" /> ₫</strong>
                            </div>
                        </div>
                    </label>
                </c:forEach>
            </div>
        </div>

        <!-- Initial Cost Preview Box -->
        <div style="margin-top: 1rem; background: #eff6ff; border: 1.5px solid #bfdbfe; border-radius: 10px; padding: 1rem 1.25rem; display: flex; justify-content: space-between; align-items: center;">
            <div>
                <span style="font-size: 0.9rem; color: #1e40af; font-weight: 700;">TỔNG TIỀN DỊCH VỤ DỰ KIẾN BAN ĐẦU:</span>
                <div style="font-size: 0.8rem; color: #3b82f6;">(Chi phí sửa chữa xe sẽ tự động khởi tạo theo số tiền này)</div>
            </div>
            <strong id="initialTotalCostText" style="font-size: 1.4rem; color: #ff5a1f; font-weight: 900;">0 ₫</strong>
        </div>

        <div style="text-align: right; margin-top: 2rem;">
            <button type="submit" class="btn btn-lg btn-accent" style="padding: 0.85rem 2rem; font-weight: 800;">
                <i class="fa-solid fa-file-circle-plus"></i> Tạo Phiếu Tiếp Nhận &amp; Tự Động Tính Phí
            </button>
        </div>
    </form>
</div>

<script>
function toggleCustomerMode(mode) {
    if (mode === 'new') {
        document.getElementById('existingCustomerSection').style.display = 'none';
        document.getElementById('newCustomerSection').style.display = 'block';
    } else {
        document.getElementById('existingCustomerSection').style.display = 'block';
        document.getElementById('newCustomerSection').style.display = 'none';
    }
}

function recalculateCreateEstimate() {
    const checkboxes = document.querySelectorAll('input[name="selectedServices"]:checked');
    let total = 0;
    checkboxes.forEach(cb => {
        total += Number(cb.getAttribute('data-price')) || 0;
    });
    const el = document.getElementById('initialTotalCostText');
    if (el) {
        el.textContent = new Intl.NumberFormat('vi-VN').format(total) + ' ₫';
    }
}
</script>

</main>
</div>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
