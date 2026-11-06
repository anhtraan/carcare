<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="title" value="Đăng Nhập - CareCar Auto Service" />
</jsp:include>

<div class="container" style="max-width: 480px; padding-top: 4rem; padding-bottom: 5rem;">
    <div class="card" style="padding: 2.5rem; border-radius: var(--radius-lg); box-shadow: var(--shadow-lg);">
        <div style="text-align: center; margin-bottom: 2rem;">
            <div class="logo-icon" style="margin: 0 auto 1rem; width: 48px; height: 48px; font-size: 1.5rem; background: linear-gradient(135deg, var(--accent), #ef4444); color: #fff; border-radius: 12px; display: flex; align-items: center; justify-content: center;">
                <i class="fa-solid fa-lock"></i>
            </div>
            <h1 style="font-size: 1.65rem; font-weight: 800;">Đăng Nhập Tài Khoản</h1>
            <p style="font-size: 0.875rem; color: var(--light-muted); margin-top: 0.25rem;">
                Hệ thống dành cho Khách hàng &amp; Nhân viên Gara
            </p>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                <i class="fa-solid fa-circle-exclamation"></i>
                <div><c:out value="${errorMessage}" escapeXml="true" /></div>
            </div>
        </c:if>

        <c:if test="${param.msg == 'register_success'}">
            <div class="alert alert-success">
                <i class="fa-solid fa-circle-check"></i>
                <div>Đăng ký tài khoản thành công! Vui lòng đăng nhập.</div>
            </div>
        </c:if>

        <c:if test="${param.authReason == 'booking'}">
            <div class="alert alert-warning" style="display: flex; align-items: flex-start; gap: 0.75rem; background: #fffbeb; border-left: 4px solid #f59e0b; padding: 1rem; border-radius: 8px; margin-bottom: 1.25rem;">
                <i class="fa-solid fa-calendar-check" style="font-size: 1.35rem; color: #f59e0b; margin-top: 2px;"></i>
                <div style="font-size: 0.925rem; color: #92400e;">
                    <strong>Yêu cầu đăng nhập để đặt lịch hẹn!</strong><br>
                    Quý khách vui lòng đăng nhập để hệ thống tiếp nhận và xác nhận lịch hẹn chăm sóc xe. Nếu chưa có tài khoản, vui lòng 
                    <a href="${pageContext.request.contextPath}/register?redirect=/booking" style="font-weight: 700; text-decoration: underline; color: #b45309;">Đăng ký tài khoản ngay</a>.
                </div>
            </div>
        </c:if>

        <c:if test="${param.authReason == 'track'}">
            <div class="alert alert-warning" style="display: flex; align-items: flex-start; gap: 0.75rem; background: #fffbeb; border-left: 4px solid #f59e0b; padding: 1rem; border-radius: 8px; margin-bottom: 1.25rem;">
                <i class="fa-solid fa-car-tunnel" style="font-size: 1.35rem; color: #f59e0b; margin-top: 2px;"></i>
                <div style="font-size: 0.925rem; color: #92400e;">
                    <strong>Yêu cầu đăng nhập để tra cứu tiến độ xe!</strong><br>
                    Để bảo mật dữ liệu xe và thông tin cá nhân của chủ xe, quý khách vui lòng đăng nhập trước khi tra cứu. Nếu chưa có tài khoản, vui lòng 
                    <a href="${pageContext.request.contextPath}/register<c:if test='${not empty param.redirect}'>?redirect=<c:out value='${param.redirect}' /></c:if>" style="font-weight: 700; text-decoration: underline; color: #b45309;">Đăng ký tài khoản mới</a>.
                </div>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="POST">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
            <input type="hidden" name="redirect" value="<c:out value='${param.redirect}' />">
            
            <div class="form-group">
                <label class="form-label">Tên đăng nhập hoặc Số điện thoại</label>
                <div style="position: relative;">
                    <input type="text" name="username" class="form-control" value="<c:out value='${enteredUsername}' />" placeholder="admin, mechanic1 hoặc 0988..." required autofocus>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Mật khẩu</label>
                <input type="password" name="password" class="form-control" placeholder="Nhập mật khẩu..." required>
            </div>

            <div style="margin-top: 1.75rem;">
                <button type="submit" class="btn btn-primary btn-lg" style="width: 100%;">
                    <i class="fa-solid fa-right-to-bracket"></i> Đăng Nhập
                </button>
            </div>
        </form>

        <div style="background: #f8fafc; border-radius: var(--radius-md); padding: 1rem; margin-top: 1.5rem; font-size: 0.825rem; color: var(--light-muted); border: 1px dashed var(--light-border);">
            <strong style="color: var(--light-text); display: block; margin-bottom: 0.25rem;"><i class="fa-solid fa-key"></i> Tài khoản chạy thử (Mật khẩu: 123456):</strong>
            <div>&bull; <strong>Admin:</strong> <code>admin</code></div>
            <div>&bull; <strong>Kỹ thuật viên:</strong> <code>mechanic1</code></div>
            <div>&bull; <strong>Khách hàng:</strong> <code>customer1</code> (hoặc <code>0988776655</code>)</div>
        </div>

        <div style="text-align: center; margin-top: 1.5rem; font-size: 0.9rem;">
            Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register<c:if test='${not empty param.redirect}'>?redirect=<c:out value='${param.redirect}' /></c:if>" style="font-weight: 700; color: var(--accent);">Đăng ký tài khoản ngay</a>
        </div>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
