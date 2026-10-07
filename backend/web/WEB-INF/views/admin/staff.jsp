<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../includes/admin-navbar.jsp">
    <jsp:param name="title" value="Quản Lý Nhân Sự Xưởng - CareCar" />
</jsp:include>
<jsp:include page="../includes/admin-sidebar.jsp" />

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
    <div>
        <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--light-text);">Quản Lý Nhân Viên &amp; Kỹ Thuật Viên</h1>
        <p style="color: var(--light-muted); font-size: 0.9rem;">Danh sách tài khoản Admin, Kỹ thuật viên (Thợ máy) và Cố vấn dịch vụ</p>
    </div>
    <div>
        <button type="button" class="btn btn-primary" onclick="document.getElementById('addStaffModal').style.display='flex';">
            <i class="fa-solid fa-user-plus"></i> Thêm Nhân Viên Mới
        </button>
    </div>
</div>

<c:if test="${param.msg == 'staff_added'}">
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Đã thêm tài khoản nhân viên mới!</div>
</c:if>
<c:if test="${param.msg == 'status_updated'}">
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Đã cập nhật trạng thái hoạt động!</div>
</c:if>

<div class="card">
    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th>Họ Tên Nhân Viên</th>
                    <th>Tên Đăng Nhập</th>
                    <th>Vai Trò (Quyền Hạn)</th>
                    <th>Số Điện Thoại</th>
                    <th>Email</th>
                    <th>Trạng Thái</th>
                    <th style="text-align: center;">Khóa / Mở</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${staffList}" var="st">
                    <tr>
                        <td><strong>${st.fullName}</strong></td>
                        <td><code>${st.username}</code></td>
                        <td>
                            <c:choose>
                                <c:when test="${st.admin}"><span class="badge badge-danger">ADMIN QUẢN TRỊ</span></c:when>
                                <c:when test="${st.mechanic}"><span class="badge badge-warning">KỸ THUẬT VIÊN (THỢ MÁY)</span></c:when>
                                <c:otherwise><span class="badge badge-info">CỐ VẤN DỊCH VỤ</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>${st.phone}</td>
                        <td>${st.email != null ? st.email : '—'}</td>
                        <td>
                            <span class="badge ${st.status == 'ACTIVE' ? 'badge-success' : 'badge-secondary'}">
                                ${st.status}
                            </span>
                        </td>
                        <td style="text-align: center;">
                            <form action="${pageContext.request.contextPath}/admin/staff" method="POST" style="display: inline;">
                                <input type="hidden" name="action" value="toggleStatus">
                                <input type="hidden" name="userId" value="${st.userId}">
                                <input type="hidden" name="status" value="${st.status == 'ACTIVE' ? 'LOCKED' : 'ACTIVE'}">
                                <button type="submit" class="btn btn-sm ${st.status == 'ACTIVE' ? 'btn-danger' : 'btn-success'}" title="Đổi trạng thái">
                                    <i class="fa-solid ${st.status == 'ACTIVE' ? 'fa-lock' : 'fa-unlock'}"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<!-- Modal: Add Staff -->
<div id="addStaffModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 9999; align-items: center; justify-content: center;">
    <div class="card" style="width: 520px; max-width: 90%; background: #fff;">
        <h3 style="font-size: 1.25rem; margin-bottom: 1rem;"><i class="fa-solid fa-user-shield"></i> Thêm Nhân Viên Mới</h3>
        <form action="${pageContext.request.contextPath}/admin/staff" method="POST">
            <input type="hidden" name="action" value="addStaff">

            <div class="form-group">
                <label class="form-label">Họ và tên (*)</label>
                <input type="text" name="fullName" class="form-control" placeholder="Trần Văn B" required>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                <div class="form-group">
                    <label class="form-label">Tên đăng nhập (*)</label>
                    <input type="text" name="username" class="form-control" placeholder="mech_b" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Mật khẩu khởi tạo (*)</label>
                    <input type="password" name="password" class="form-control" placeholder="123456" required>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Vai trò (*)</label>
                <select name="role" class="form-select" required>
                    <option value="MECHANIC">Kỹ thuật viên / Thợ máy (MECHANIC)</option>
                    <option value="RECEPTIONIST">Cố vấn dịch vụ / Lễ tân (RECEPTIONIST)</option>
                    <option value="ADMIN">Quản trị viên xưởng (ADMIN)</option>
                </select>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                <div class="form-group">
                    <label class="form-label">Số điện thoại (*)</label>
                    <input type="tel" name="phone" class="form-control" placeholder="0912345678" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-control" placeholder="nv@carecar.vn">
                </div>
            </div>

            <div style="text-align: right; margin-top: 1.5rem;">
                <button type="button" class="btn btn-secondary" onclick="document.getElementById('addStaffModal').style.display='none';">Hủy</button>
                <button type="submit" class="btn btn-primary"><i class="fa-solid fa-save"></i> Tạo Tài Khoản</button>
            </div>
        </form>
    </div>
</div>

</main>
</div>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
