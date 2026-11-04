<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../includes/admin-navbar.jsp">
    <jsp:param name="title" value="Quản Lý Nhân Sự Xưởng - CareCar" />
</jsp:include>
<jsp:include page="../includes/admin-sidebar.jsp" />

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
    <div>
        <div style="display: flex; align-items: center; gap: 0.75rem;">
            <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--light-text); margin: 0;">Quản Lý Nhân Viên &amp; Kỹ Thuật Viên</h1>
            <span class="badge badge-danger" style="font-size: 0.75rem;"><i class="fa-solid fa-lock"></i> Chỉ Quản Trị Viên (ADMIN)</span>
        </div>
        <p style="color: var(--light-muted); font-size: 0.9rem; margin-top: 0.25rem;">Quản lý phân quyền tài khoản Admin, Thợ máy (Mechanic) và Lễ tân (Receptionist) theo danh mục whitelist.</p>
    </div>
    <div>
        <button type="button" class="btn btn-primary" onclick="document.getElementById('addStaffModal').style.display='flex';">
            <i class="fa-solid fa-user-plus"></i> Thêm Nhân Viên Mới
        </button>
    </div>
</div>

<c:if test="${param.msg == 'staff_added'}">
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Đã thêm tài khoản nhân viên mới thành công!</div>
</c:if>
<c:if test="${param.msg == 'status_updated'}">
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Đã cập nhật trạng thái hoạt động của nhân viên!</div>
</c:if>
<c:if test="${param.error == 'cannot_lock_self'}">
    <div class="alert alert-danger"><i class="fa-solid fa-triangle-exclamation"></i> Không thể khóa tài khoản của chính mình hoặc tài khoản Quản trị viên gốc!</div>
</c:if>
<c:if test="${param.error == 'invalid_role'}">
    <div class="alert alert-danger"><i class="fa-solid fa-triangle-exclamation"></i> Vai trò được chọn không hợp lệ (Chỉ chấp nhận whitelist: ADMIN, MECHANIC, RECEPTIONIST)!</div>
</c:if>
<c:if test="${param.error == 'username_exists'}">
    <div class="alert alert-danger"><i class="fa-solid fa-triangle-exclamation"></i> Tên đăng nhập này đã tồn tại trong hệ thống! Vui lòng chọn tên khác.</div>
</c:if>
<c:if test="${param.error == 'missing_fields'}">
    <div class="alert alert-danger"><i class="fa-solid fa-triangle-exclamation"></i> Vui lòng điền đầy đủ các trường thông tin bắt buộc!</div>
</c:if>
<c:if test="${param.error == 'invalid_status'}">
    <div class="alert alert-danger"><i class="fa-solid fa-triangle-exclamation"></i> Trạng thái không hợp lệ!</div>
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
                        <td><strong><c:out value="${st.fullName}" /></strong></td>
                        <td><code><c:out value="${st.username}" /></code></td>
                        <td>
                            <c:choose>
                                <c:when test="${st.admin}"><span class="badge badge-danger">ADMIN QUẢN TRỊ</span></c:when>
                                <c:when test="${st.mechanic}"><span class="badge badge-warning">KỸ THUẬT VIÊN (THỢ MÁY)</span></c:when>
                                <c:otherwise><span class="badge badge-info">CỐ VẤN DỊCH VỤ / LỄ TÂN</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td><c:out value="${st.phone}" /></td>
                        <td><c:out value="${st.email != null && not empty st.email ? st.email : '—'}" /></td>
                        <td>
                            <span class="badge ${st.status == 'ACTIVE' ? 'badge-success' : 'badge-secondary'}">
                                <c:out value="${st.status}" />
                            </span>
                        </td>
                        <td style="text-align: center;">
                            <c:choose>
                                <c:when test="${st.userId == sessionScope.currentUser.userId || st.userId == 1}">
                                    <span class="badge badge-secondary" title="Không thể tự khóa tài khoản của chính mình hoặc Root Admin">
                                        <i class="fa-solid fa-shield"></i> Cố định
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <form action="${pageContext.request.contextPath}/admin/staff" method="POST" style="display: inline;">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
                                        <input type="hidden" name="action" value="toggleStatus">
                                        <input type="hidden" name="userId" value="${st.userId}">
                                        <input type="hidden" name="status" value="${st.status == 'ACTIVE' ? 'LOCKED' : 'ACTIVE'}">
                                        <button type="submit" class="btn btn-sm ${st.status == 'ACTIVE' ? 'btn-danger' : 'btn-success'}" title="${st.status == 'ACTIVE' ? 'Khóa tài khoản' : 'Mở khóa tài khoản'}">
                                            <i class="fa-solid ${st.status == 'ACTIVE' ? 'fa-lock' : 'fa-unlock'}"></i>
                                        </button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<!-- Modal: Add Staff -->
<div id="addStaffModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 9999; align-items: center; justify-content: center; backdrop-filter: blur(2px);">
    <div class="card" style="width: 540px; max-width: 92%; background: #fff; border-radius: 12px; box-shadow: 0 20px 40px rgba(0,0,0,0.3);">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; border-bottom: 1px solid #f1f5f9; padding-bottom: 0.75rem;">
            <h3 style="font-size: 1.25rem; font-weight: 800; color: #0f172a; margin: 0;">
                <i class="fa-solid fa-user-shield" style="color: #ff5a1f;"></i> Thêm Nhân Viên Mới
            </h3>
            <button type="button" onclick="document.getElementById('addStaffModal').style.display='none';" style="background: none; border: none; font-size: 1.25rem; cursor: pointer; color: #64748b;">&times;</button>
        </div>
        
        <form action="${pageContext.request.contextPath}/admin/staff" method="POST">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
            <input type="hidden" name="action" value="addStaff">

            <div class="form-group" style="margin-bottom: 1rem;">
                <label class="form-label" style="font-weight: 700;">Họ và tên (*)</label>
                <input type="text" name="fullName" class="form-control" placeholder="Trần Văn B" required>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
                <div class="form-group">
                    <label class="form-label" style="font-weight: 700;">Tên đăng nhập (*)</label>
                    <input type="text" name="username" class="form-control" placeholder="mech_b" required>
                </div>
                <div class="form-group">
                    <label class="form-label" style="font-weight: 700;">Mật khẩu khởi tạo (*)</label>
                    <input type="password" name="password" class="form-control" placeholder="123456" required>
                </div>
            </div>

            <div class="form-group" style="margin-bottom: 1rem;">
                <label class="form-label" style="font-weight: 700;">Vai trò phân quyền (* - Whitelist)</label>
                <select name="role" class="form-select" required>
                    <option value="MECHANIC">Kỹ thuật viên / Thợ máy (MECHANIC)</option>
                    <option value="RECEPTIONIST">Cố vấn dịch vụ / Lễ tân (RECEPTIONIST)</option>
                    <option value="ADMIN">Quản trị viên xưởng (ADMIN)</option>
                </select>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1.25rem;">
                <div class="form-group">
                    <label class="form-label" style="font-weight: 700;">Số điện thoại (*)</label>
                    <input type="tel" name="phone" class="form-control" placeholder="0912345678" required>
                </div>
                <div class="form-group">
                    <label class="form-label" style="font-weight: 700;">Email</label>
                    <input type="email" name="email" class="form-control" placeholder="nv@carecar.vn">
                </div>
            </div>

            <div style="text-align: right; border-top: 1px solid #f1f5f9; padding-top: 1rem;">
                <button type="button" class="btn btn-secondary" onclick="document.getElementById('addStaffModal').style.display='none';">Hủy</button>
                <button type="submit" class="btn btn-primary" style="background: #ff5a1f; border-color: #ff5a1f;">
                    <i class="fa-solid fa-save"></i> Tạo Tài Khoản
                </button>
            </div>
        </form>
    </div>
</div>

</main>
</div>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
