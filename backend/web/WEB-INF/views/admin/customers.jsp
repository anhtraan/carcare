<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../includes/admin-navbar.jsp">
    <jsp:param name="title" value="Quản Lý Khách Hàng &amp; Phương Tiện - CareCar" />
</jsp:include>
<jsp:include page="../includes/admin-sidebar.jsp" />

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
    <div>
        <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--light-text);">Hồ Sơ Khách Hàng &amp; Phương Tiện</h1>
        <p style="color: var(--light-muted); font-size: 0.9rem;">Quản lý danh bạ chủ xe và các phương tiện đang theo dõi tại xưởng</p>
    </div>
    <div>
        <button type="button" class="btn btn-primary" onclick="document.getElementById('addCustomerModal').style.display='flex';">
            <i class="fa-solid fa-user-plus"></i> Thêm Khách Hàng Mới
        </button>
    </div>
</div>

<c:if test="${param.msg == 'customer_added'}">
    <div class="alert alert-success" style="display: flex; align-items: center; gap: 0.5rem; border-left: 4px solid #10b981; margin-bottom: 1.5rem;">
        <i class="fa-solid fa-circle-check" style="font-size: 1.2rem;"></i>
        <div><strong>Thành công!</strong> Đã thêm hồ sơ khách hàng mới vào hệ thống.</div>
    </div>
</c:if>
<c:if test="${param.msg == 'customer_updated'}">
    <div class="alert alert-info" style="display: flex; align-items: center; gap: 0.5rem; border-left: 4px solid #3b82f6; margin-bottom: 1.5rem;">
        <i class="fa-solid fa-circle-info" style="font-size: 1.2rem;"></i>
        <div>Số điện thoại đã tồn tại trong hệ thống. Đã tự động cập nhật thông tin mới nhất cho khách hàng!</div>
    </div>
</c:if>
<c:if test="${param.error == 'missing_info'}">
    <div class="alert alert-danger" style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 1.5rem;">
        <i class="fa-solid fa-circle-xmark" style="font-size: 1.2rem;"></i>
        <div>Vui lòng nhập đầy đủ họ tên và số điện thoại khách hàng!</div>
    </div>
</c:if>
<c:if test="${param.error == 'save_failed'}">
    <div class="alert alert-danger" style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 1.5rem;">
        <i class="fa-solid fa-circle-xmark" style="font-size: 1.2rem;"></i>
        <div>Không thể lưu khách hàng mới. Vui lòng kiểm tra lại dữ liệu và thử lại!</div>
    </div>
</c:if>

<div class="card">
    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th>Họ Tên Khách Hàng</th>
                    <th>Số Điện Thoại</th>
                    <th>Email / Địa Chỉ</th>
                    <th>Danh Sách Xe Sở Hữu</th>
                    <th style="text-align: center;">Tổng Đơn Sửa</th>
                    <th>Ngày Tham Gia</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${customers}" var="c">
                    <tr>
                        <td><strong><c:out value="${c.fullName}" /></strong></td>
                        <td><a href="tel:<c:out value='${c.phone}' />"><strong><c:out value="${c.phone}" /></strong></a></td>
                        <td>
                            <div><small><c:out value="${c.email != null ? c.email : '—'}" /></small></div>
                            <div style="color: var(--light-muted); font-size: 0.8rem;"><c:out value="${c.address != null ? c.address : '—'}" /></div>
                        </td>
                        <td>
                            <c:forEach items="${c.cars}" var="car">
                                <span style="display: inline-block; background: #e2e8f0; padding: 0.2rem 0.5rem; border-radius: 4px; font-size: 0.8rem; font-weight: 700; margin: 0.15rem;">
                                    <c:out value="${car.licensePlate}" /> (<c:out value="${car.brand}" /> <c:out value="${car.model}" />)
                                </span>
                            </c:forEach>
                            <c:if test="${empty c.cars}">
                                <span style="color: var(--light-muted); font-style: italic; font-size: 0.85rem;">Chưa có xe</span>
                            </c:if>
                        </td>
                        <td style="text-align: center;">
                            <span class="badge badge-info">${c.totalOrders} đơn</span>
                        </td>
                        <td><fmt:formatDate value="${c.createdAt}" pattern="dd/MM/yyyy" /></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty customers}">
                    <tr>
                        <td colspan="6" style="text-align: center; color: var(--light-muted); padding: 2rem;">Chưa có khách hàng nào.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<!-- Modal: Add Customer -->
<div id="addCustomerModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 9999; align-items: center; justify-content: center;">
    <div class="card" style="width: 500px; max-width: 90%; background: #fff;">
        <h3 style="font-size: 1.25rem; margin-bottom: 1rem;"><i class="fa-solid fa-user-plus"></i> Thêm Khách Hàng Mới</h3>
        <form action="${pageContext.request.contextPath}/admin/customers" method="POST">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
            <div class="form-group">
                <label class="form-label">Họ và tên (*)</label>
                <input type="text" name="fullName" class="form-control" placeholder="Nguyễn Văn A" required>
            </div>
            <div class="form-group">
                <label class="form-label">Số điện thoại (*)</label>
                <input type="tel" name="phone" class="form-control" placeholder="0901234567" required>
            </div>
            <div class="form-group">
                <label class="form-label">Email</label>
                <input type="email" name="email" class="form-control" placeholder="email@gmail.com">
            </div>
            <div class="form-group">
                <label class="form-label">Địa chỉ</label>
                <input type="text" name="address" class="form-control" placeholder="Địa chỉ...">
            </div>
            <div class="form-group">
                <label class="form-label">Số CCCD / CMND</label>
                <input type="text" name="idCard" class="form-control" placeholder="001095...">
            </div>
            <div class="form-group">
                <label class="form-label">Ghi chú</label>
                <textarea name="notes" class="form-control" placeholder="Ghi chú thêm về khách..."></textarea>
            </div>
            <div style="text-align: right; margin-top: 1.5rem;">
                <button type="button" class="btn btn-secondary" onclick="document.getElementById('addCustomerModal').style.display='none';">Hủy</button>
                <button type="submit" class="btn btn-primary"><i class="fa-solid fa-save"></i> Lưu Khách Hàng</button>
            </div>
        </form>
    </div>
</div>

</main>
</div>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
