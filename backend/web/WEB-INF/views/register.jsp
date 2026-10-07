<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="title" value="Đăng Ký Tài Khoản Khách Hàng - CareCar" />
</jsp:include>

<div class="container" style="max-width: 580px; padding-top: 3.5rem; padding-bottom: 5rem;">
    <div class="card" style="padding: 2.5rem; border-radius: var(--radius-lg); box-shadow: var(--shadow-lg);">
        <div style="text-align: center; margin-bottom: 2rem;">
            <h1 style="font-size: 1.75rem; font-weight: 800;">Tạo Tài Khoản Chủ Xe</h1>
            <p style="font-size: 0.875rem; color: var(--light-muted); margin-top: 0.25rem;">
                Quản lý lịch sử bảo dưỡng, lưu thông tin xe và nhận ưu đãi tích điểm
            </p>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                <i class="fa-solid fa-circle-exclamation"></i>
                <div>${errorMessage}</div>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="POST">
            <div class="form-group">
                <label class="form-label">Họ và tên (*)</label>
                <input type="text" name="fullName" class="form-control" placeholder="Nguyễn Văn A" required>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                <div class="form-group">
                    <label class="form-label">Số điện thoại (*)</label>
                    <input type="tel" name="phone" class="form-control" placeholder="0901234567" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Email (Tùy chọn)</label>
                    <input type="email" name="email" class="form-control" placeholder="email@gmail.com">
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Tên đăng nhập (*)</label>
                <input type="text" name="username" class="form-control" placeholder="Chữ cái viết liền không dấu..." required>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                <div class="form-group">
                    <label class="form-label">Mật khẩu (*)</label>
                    <input type="password" name="password" class="form-control" placeholder="Tối thiểu 6 ký tự" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Xác nhận mật khẩu (*)</label>
                    <input type="password" name="confirmPassword" class="form-control" placeholder="Nhập lại mật khẩu" required>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Địa chỉ</label>
                <input type="text" name="address" class="form-control" placeholder="Quận/Huyện, Tỉnh/Thành phố">
            </div>

            <div style="margin-top: 1.75rem;">
                <button type="submit" class="btn btn-primary btn-lg" style="width: 100%;">
                    <i class="fa-solid fa-user-plus"></i> Hoàn Tất Đăng Ký
                </button>
            </div>
        </form>

        <div style="text-align: center; margin-top: 1.5rem; font-size: 0.9rem;">
            Đã có tài khoản? <a href="${pageContext.request.contextPath}/login" style="font-weight: 600;">Đăng nhập ngay</a>
        </div>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
