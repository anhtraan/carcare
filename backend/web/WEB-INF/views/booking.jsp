<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="title" value="Đặt Hẹn Sửa Chữa &amp; Bảo Dưỡng Ô Tô - CareCar" />
</jsp:include>

<div class="container" style="max-width: 900px; padding-top: 3rem; padding-bottom: 4rem;">
    <div style="text-align: center; margin-bottom: 2.5rem;">
        <span class="badge badge-accent" style="margin-bottom: 0.5rem;">TIẾP NHẬN NHANH CHÓNG</span>
        <h1 style="font-size: 2.25rem; font-weight: 800; margin-bottom: 0.5rem;">Đặt Lịch Sửa Chữa / Bảo Dưỡng Trực Tuyến</h1>
        <p style="color: var(--light-muted);">
            Vui lòng điền thông tin để đội ngũ cố vấn dịch vụ chuẩn bị sẵn sàng cầu nâng &amp; kỹ thuật viên đón tiếp bạn.
        </p>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">
            <i class="fa-solid fa-circle-exclamation"></i>
            <div>${errorMessage}</div>
        </div>
    </c:if>

    <div class="card" style="padding: 2.5rem; border-radius: var(--radius-lg);">
        <form action="${pageContext.request.contextPath}/booking" method="POST">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
            <h3 style="font-size: 1.15rem; border-bottom: 2px solid var(--light-border); padding-bottom: 0.75rem; margin-bottom: 1.5rem; color: var(--primary);">
                <i class="fa-regular fa-user"></i> 1. Thông Tin Khách Hàng
            </h3>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.25rem;">
                <div class="form-group">
                    <label class="form-label">Họ và tên khách hàng (*)</label>
                    <input type="text" name="customerName" class="form-control" placeholder="Nguyễn Văn A" value="${userCustomer != null ? userCustomer.fullName : ''}" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Số điện thoại liên hệ (*)</label>
                    <input type="tel" name="phone" class="form-control" placeholder="0901234567" value="${userCustomer != null ? userCustomer.phone : ''}" required>
                </div>
            </div>

            <h3 style="font-size: 1.15rem; border-bottom: 2px solid var(--light-border); padding-bottom: 0.75rem; margin: 2rem 0 1.5rem; color: var(--primary);">
                <i class="fa-solid fa-car-side"></i> 2. Thông Tin Xe Ô Tô
            </h3>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.25rem;">
                <div class="form-group">
                    <label class="form-label">Biển số xe (*)</label>
                    <input type="text" name="licensePlate" class="form-control" placeholder="30A-999.88" style="text-transform: uppercase; font-weight: 700; letter-spacing: 1px;" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Hãng &amp; Dòng xe</label>
                    <input type="text" name="carBrandModel" class="form-control" placeholder="Toyota Camry, Mazda CX-5, VinFast VF8...">
                </div>
            </div>

            <h3 style="font-size: 1.15rem; border-bottom: 2px solid var(--light-border); padding-bottom: 0.75rem; margin: 2rem 0 1.5rem; color: var(--primary);">
                <i class="fa-regular fa-clock"></i> 3. Thời Gian &amp; Dịch Vụ Yêu Cầu
            </h3>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.25rem;">
                <div class="form-group">
                    <label class="form-label">Ngày hẹn đến xưởng (*)</label>
                    <input type="date" name="appointmentDate" class="form-control" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Khung giờ tiếp nhận (*)</label>
                    <select name="timeSlot" class="form-select" required>
                        <option value="08:00 - 09:30">08:00 - 09:30 (Sáng sớm)</option>
                        <option value="09:30 - 11:00">09:30 - 11:00 (Buổi sáng)</option>
                        <option value="11:00 - 12:30">11:00 - 12:30 (Trưa)</option>
                        <option value="13:30 - 15:00" selected>13:30 - 15:00 (Đầu giờ chiều)</option>
                        <option value="15:00 - 16:30">15:00 - 16:30 (Chiều)</option>
                        <option value="16:30 - 18:00">16:30 - 18:00 (Cuối ngày)</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Dịch vụ yêu cầu (*)</label>
                <select name="requestedService" class="form-select" required>
                    <option value="Bảo dưỡng định kỳ theo số Km">Bảo dưỡng định kỳ theo số Km</option>
                    <option value="Kiểm tra hệ thống phanh &amp; Thay má phanh">Kiểm tra hệ thống phanh &amp; Thay má phanh</option>
                    <option value="Cân chỉnh góc đặt bánh xe 3D &amp; Cân bằng động lốp">Cân chỉnh góc đặt bánh xe 3D &amp; Cân bằng động lốp</option>
                    <option value="Kiểm tra sửa chữa động cơ &amp; Hộp số">Kiểm tra sửa chữa động cơ &amp; Hộp số</option>
                    <option value="Bảo dưỡng &amp; Nội soi vệ sinh điều hòa ô tô">Bảo dưỡng &amp; Nội soi vệ sinh điều hòa ô tô</option>
                    <option value="Sơn đồng gò hàn &amp; Phủ bóng thân vỏ">Sơn đồng gò hàn &amp; Phủ bóng thân vỏ</option>
                    <option value="Kiểm tra tổng quát toàn bộ xe">Kiểm tra tổng quát toàn bộ xe</option>
                    <option value="Khác (Ghi chú chi tiết bên dưới)">Khác (Ghi chú chi tiết bên dưới)</option>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">Mô tả hiện tượng xe / Yêu cầu thêm</label>
                <textarea name="notes" class="form-control" placeholder="Ví dụ: Xe có tiếng kêu lạ dưới gầm khi qua gờ giảm tốc, muốn thay dầu Mobil1..."></textarea>
            </div>

            <div style="text-align: center; margin-top: 2rem;">
                <button type="submit" class="btn btn-lg btn-accent" style="width: 100%; max-width: 400px;">
                    <i class="fa-regular fa-paper-plane"></i> Gửi Yêu Cầu Đặt Lịch Hẹn
                </button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
