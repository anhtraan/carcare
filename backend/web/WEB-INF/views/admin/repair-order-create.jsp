<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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
</div>

<c:if test="${not empty errorMessage}">
    <div class="alert alert-danger"><i class="fa-solid fa-circle-exclamation"></i> ${errorMessage}</div>
</c:if>

<div class="card" style="max-width: 900px; padding: 2rem;">
    <form action="${pageContext.request.contextPath}/admin/repair-order-create" method="POST">
        
        <!-- Selection: Existing or New Customer -->
        <div style="background: #f8fafc; padding: 1rem 1.25rem; border-radius: var(--radius-md); margin-bottom: 1.5rem; display: flex; gap: 2rem;">
            <label style="font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 0.5rem;">
                <input type="radio" name="customerType" value="existing" checked onclick="toggleCustomerMode('existing')">
                <span>Khách hàng &amp; Xe ĐÃ CÓ trong hệ thống</span>
            </label>
            <label style="font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 0.5rem;">
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
                    <label class="form-label">Chọn khách hàng</label>
                    <select name="customerId" class="form-select">
                        <c:forEach items="${customers}" var="c">
                            <option value="${c.customerId}">${c.fullName} - ${c.phone} (${c.address})</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">Chọn xe của khách</label>
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
                    <label class="form-label">Họ tên khách hàng (*)</label>
                    <input type="text" name="newCustomerName" class="form-control" placeholder="Nguyễn Văn A">
                </div>
                <div class="form-group">
                    <label class="form-label">Số điện thoại (*)</label>
                    <input type="tel" name="newCustomerPhone" class="form-control" placeholder="0901234567">
                </div>
                <div class="form-group">
                    <label class="form-label">Email</label>
                    <input type="email" name="newCustomerEmail" class="form-control" placeholder="email@gmail.com">
                </div>
                <div class="form-group">
                    <label class="form-label">Địa chỉ</label>
                    <input type="text" name="newCustomerAddress" class="form-control" placeholder="Địa chỉ...">
                </div>
            </div>

            <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 1rem;">
                <div class="form-group">
                    <label class="form-label">Biển số xe (*)</label>
                    <input type="text" name="newLicensePlate" class="form-control" placeholder="30A-999.88" style="text-transform: uppercase;">
                </div>
                <div class="form-group">
                    <label class="form-label">Hãng xe (*)</label>
                    <input type="text" name="newCarBrand" class="form-control" placeholder="Toyota, Mazda, BMW...">
                </div>
                <div class="form-group">
                    <label class="form-label">Dòng xe</label>
                    <input type="text" name="newCarModel" class="form-control" placeholder="Camry, CX-5, 320i...">
                </div>
                <div class="form-group">
                    <label class="form-label">Màu sơn</label>
                    <input type="text" name="newCarColor" class="form-control" placeholder="Trắng, Đen, Đỏ...">
                </div>
            </div>
        </div>

        <!-- Section 2: Reception Details -->
        <h3 style="font-size: 1.1rem; font-weight: 700; color: var(--primary); margin: 1.5rem 0 1rem; border-top: 1px solid var(--light-border); padding-top: 1.5rem;">
            <i class="fa-solid fa-clipboard-check"></i> 2. Thông Tin Tiếp Nhận Tại Xưởng
        </h3>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.25rem;">
            <div class="form-group">
                <label class="form-label">Số Km lúc tiếp nhận (ODO)</label>
                <input type="number" name="entryMileage" class="form-control" placeholder="Ví dụ: 45000">
            </div>

            <div class="form-group">
                <label class="form-label">Phân công kỹ thuật viên</label>
                <select name="mechanicId" class="form-select">
                    <option value="">-- Phân công sau khi kiểm tra --</option>
                    <c:forEach items="${mechanics}" var="m">
                        <option value="${m.userId}">${m.fullName} - ${m.phone}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="form-group">
            <label class="form-label">Hiện tượng hư hỏng / Yêu cầu của khách hàng (*)</label>
            <textarea name="initialDiagnosis" class="form-control" rows="3" placeholder="Mô tả chi tiết triệu chứng, yêu cầu sửa chữa hoặc bảo dưỡng..." required></textarea>
        </div>

        <div style="text-align: right; margin-top: 2rem;">
            <button type="submit" class="btn btn-lg btn-accent">
                <i class="fa-solid fa-file-circle-plus"></i> Tạo Phiếu Tiếp Nhận Xe (Work Order)
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
</script>

</main>
</div>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
