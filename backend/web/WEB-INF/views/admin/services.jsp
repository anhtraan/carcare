<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../includes/admin-navbar.jsp">
    <jsp:param name="title" value="Bảng Giá Dịch Vụ - CareCar" />
</jsp:include>
<jsp:include page="../includes/admin-sidebar.jsp" />

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem;">
    <div>
        <div style="display: flex; align-items: center; gap: 0.75rem; margin-bottom: 0.25rem;">
            <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--light-text); margin: 0;">Danh Mục Dịch Vụ &amp; Bảng Giá Tiền Công</h1>
            <span class="badge badge-info" style="font-size: 0.8rem; padding: 0.35rem 0.65rem;">
                <i class="fa-solid fa-user-shield"></i> Thợ máy &amp; Quản trị viên
            </span>
        </div>
        <p style="color: var(--light-muted); font-size: 0.9rem;">Thợ máy và Admin có quyền thêm mới, chỉnh sửa đơn giá hoặc cập nhật thời gian thi công ước tính.</p>
    </div>
    <div style="display: flex; gap: 0.75rem;">
        <button type="button" class="btn btn-primary" onclick="document.getElementById('addServiceModal').style.display='flex';">
            <i class="fa-solid fa-plus"></i> Thêm Dịch Vụ Mới
        </button>
    </div>
</div>

<c:if test="${param.msg == 'service_added'}">
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Đã thêm dịch vụ mới vào hệ thống thành công! Thợ máy có thể áp dụng ngay vào Lệnh sửa chữa.</div>
</c:if>
<c:if test="${param.msg == 'service_updated'}">
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Đã cập nhật thông tin và tiền công dịch vụ thành công!</div>
</c:if>
<c:if test="${param.msg == 'status_updated'}">
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Đã thay đổi trạng thái hoạt động của dịch vụ!</div>
</c:if>

<div class="card">
    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th style="width: 160px;">Nhóm Dịch Vụ</th>
                    <th>Tên Dịch Vụ</th>
                    <th>Mô Tả Quy Trình Kỹ Thuật</th>
                    <th style="text-align: center; width: 120px;">Thời Gian</th>
                    <th style="text-align: right; width: 150px;">Tiền Công Niêm Yết</th>
                    <th style="text-align: center; width: 110px;">Trạng Thái</th>
                    <th style="text-align: center; width: 130px;">Thao Tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${services}" var="s">
                    <tr>
                        <td><span class="badge badge-info">${s.category}</span></td>
                        <td>
                            <strong style="color: var(--light-text); font-size: 0.95rem;">${s.serviceName}</strong>
                            <div style="font-size: 0.75rem; color: var(--light-muted);">Mã DV: #SRV-${s.serviceId}</div>
                        </td>
                        <td><small style="color: var(--light-muted);">${s.description}</small></td>
                        <td style="text-align: center; font-weight: 600;">${s.estimatedDuration} phút</td>
                        <td style="text-align: right; font-weight: 800; color: #ff5a1f; font-size: 1.05rem;">
                            <fmt:formatNumber value="${s.laborCost}" pattern="#,###" /> ₫
                        </td>
                        <td style="text-align: center;">
                            <span class="badge ${s.status == 'ACTIVE' ? 'badge-success' : 'badge-secondary'}">
                                ${s.status == 'ACTIVE' ? 'Hoạt động' : 'Tạm ẩn'}
                            </span>
                        </td>
                        <td style="text-align: center;">
                            <div style="display: inline-flex; gap: 0.35rem;">
                                <button type="button" class="btn btn-sm btn-secondary" title="Chỉnh sửa dịch vụ" 
                                        onclick="openEditModal(${s.serviceId}, '${s.category}', '${s.serviceName}', '${s.laborCost}', ${s.estimatedDuration}, '${s.status}', `${s.description}`)">
                                    <i class="fa-solid fa-pen-to-square"></i>
                                </button>
                                <form action="${pageContext.request.contextPath}/admin/services" method="POST" style="display: inline;">
                                    <input type="hidden" name="action" value="toggleStatus">
                                    <input type="hidden" name="serviceId" value="${s.serviceId}">
                                    <input type="hidden" name="status" value="${s.status == 'ACTIVE' ? 'INACTIVE' : 'ACTIVE'}">
                                    <button type="submit" class="btn btn-sm ${s.status == 'ACTIVE' ? 'btn-outline-danger' : 'btn-outline-success'}" title="${s.status == 'ACTIVE' ? 'Tạm ngưng dịch vụ' : 'Kích hoạt lại'}">
                                        <i class="fa-solid ${s.status == 'ACTIVE' ? 'fa-eye-slash' : 'fa-eye'}"></i>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<!-- Modal 1: Add Service -->
<div id="addServiceModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 9999; align-items: center; justify-content: center; backdrop-filter: blur(2px);">
    <div class="card" style="width: 560px; max-width: 92%; background: #ffffff; border-radius: 12px; box-shadow: 0 20px 40px rgba(0,0,0,0.25);">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; border-bottom: 1px solid #f1f5f9; padding-bottom: 0.75rem;">
            <h3 style="font-size: 1.25rem; font-weight: 800; color: #0f172a; margin: 0;">
                <i class="fa-solid fa-plus-circle" style="color: #ff5a1f;"></i> Thêm Dịch Vụ Mới
            </h3>
            <button type="button" onclick="document.getElementById('addServiceModal').style.display='none';" style="background: none; border: none; font-size: 1.25rem; cursor: pointer; color: #64748b;">&times;</button>
        </div>
        <form action="${pageContext.request.contextPath}/admin/services" method="POST">
            <input type="hidden" name="action" value="addService">

            <div class="form-group" style="margin-bottom: 1rem;">
                <label class="form-label" style="font-weight: 700; color: #1e293b;">Nhóm dịch vụ (*)</label>
                <input type="text" name="category" class="form-control" list="categoryOptions" placeholder="Bảo dưỡng định kỳ, Động cơ, Khung gầm..." required>
                <datalist id="categoryOptions">
                    <option value="Bảo dưỡng định kỳ">
                    <option value="Động cơ & Hộp số">
                    <option value="Khung gầm & Phanh">
                    <option value="Điện & Điện lạnh">
                    <option value="Đồng sơn & Chăm sóc">
                    <option value="Sửa chữa phát sinh">
                </datalist>
            </div>

            <div class="form-group" style="margin-bottom: 1rem;">
                <label class="form-label" style="font-weight: 700; color: #1e293b;">Tên dịch vụ / Hạng mục thi công (*)</label>
                <input type="text" name="serviceName" class="form-control" placeholder="Ví dụ: Cân chỉnh góc đặt bánh xe 3D..." required>
            </div>

            <div class="form-group" style="margin-bottom: 1rem;">
                <label class="form-label" style="font-weight: 700; color: #1e293b;">Mô tả quy trình kỹ thuật</label>
                <textarea name="description" class="form-control" rows="2" placeholder="Ghi chú các bước thực hiện, tiêu chuẩn kỹ thuật..."></textarea>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1.25rem;">
                <div class="form-group">
                    <label class="form-label" style="font-weight: 700; color: #1e293b;">Tiền công niêm yết (₫) (*)</label>
                    <input type="text" name="laborCost" class="form-control" placeholder="350000" required>
                </div>
                <div class="form-group">
                    <label class="form-label" style="font-weight: 700; color: #1e293b;">Thời gian thi công (~phút)</label>
                    <input type="number" name="estimatedDuration" value="60" min="5" step="5" class="form-control" required>
                </div>
            </div>

            <div style="text-align: right; border-top: 1px solid #f1f5f9; padding-top: 1rem;">
                <button type="button" class="btn btn-secondary" onclick="document.getElementById('addServiceModal').style.display='none';">Hủy</button>
                <button type="submit" class="btn btn-primary" style="background: #ff5a1f; border-color: #ff5a1f;">
                    <i class="fa-solid fa-save"></i> Lưu Dịch Vụ Mới
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Modal 2: Edit Service -->
<div id="editServiceModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 9999; align-items: center; justify-content: center; backdrop-filter: blur(2px);">
    <div class="card" style="width: 560px; max-width: 92%; background: #ffffff; border-radius: 12px; box-shadow: 0 20px 40px rgba(0,0,0,0.25);">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; border-bottom: 1px solid #f1f5f9; padding-bottom: 0.75rem;">
            <h3 style="font-size: 1.25rem; font-weight: 800; color: #0f172a; margin: 0;">
                <i class="fa-solid fa-pen-to-square" style="color: #ff5a1f;"></i> Chỉnh Sửa Dịch Vụ
            </h3>
            <button type="button" onclick="document.getElementById('editServiceModal').style.display='none';" style="background: none; border: none; font-size: 1.25rem; cursor: pointer; color: #64748b;">&times;</button>
        </div>
        <form action="${pageContext.request.contextPath}/admin/services" method="POST">
            <input type="hidden" name="action" value="editService">
            <input type="hidden" name="serviceId" id="editServiceId" value="">

            <div class="form-group" style="margin-bottom: 1rem;">
                <label class="form-label" style="font-weight: 700; color: #1e293b;">Nhóm dịch vụ (*)</label>
                <input type="text" name="category" id="editCategory" class="form-control" list="categoryOptions" required>
            </div>

            <div class="form-group" style="margin-bottom: 1rem;">
                <label class="form-label" style="font-weight: 700; color: #1e293b;">Tên dịch vụ (*)</label>
                <input type="text" name="serviceName" id="editServiceName" class="form-control" required>
            </div>

            <div class="form-group" style="margin-bottom: 1rem;">
                <label class="form-label" style="font-weight: 700; color: #1e293b;">Mô tả quy trình</label>
                <textarea name="description" id="editDescription" class="form-control" rows="2"></textarea>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 0.75rem; margin-bottom: 1.25rem;">
                <div class="form-group">
                    <label class="form-label" style="font-weight: 700; color: #1e293b;">Tiền công (₫) (*)</label>
                    <input type="text" name="laborCost" id="editLaborCost" class="form-control" required>
                </div>
                <div class="form-group">
                    <label class="form-label" style="font-weight: 700; color: #1e293b;">Thời gian (phút)</label>
                    <input type="number" name="estimatedDuration" id="editEstimatedDuration" min="5" step="5" class="form-control" required>
                </div>
                <div class="form-group">
                    <label class="form-label" style="font-weight: 700; color: #1e293b;">Trạng thái</label>
                    <select name="status" id="editStatus" class="form-select">
                        <option value="ACTIVE">Hoạt động</option>
                        <option value="INACTIVE">Tạm ẩn</option>
                    </select>
                </div>
            </div>

            <div style="text-align: right; border-top: 1px solid #f1f5f9; padding-top: 1rem;">
                <button type="button" class="btn btn-secondary" onclick="document.getElementById('editServiceModal').style.display='none';">Hủy</button>
                <button type="submit" class="btn btn-primary" style="background: #ff5a1f; border-color: #ff5a1f;">
                    <i class="fa-solid fa-save"></i> Cập Nhật Dịch Vụ
                </button>
            </div>
        </form>
    </div>
</div>

<script>
function openEditModal(id, cat, name, cost, duration, status, desc) {
    document.getElementById('editServiceId').value = id;
    document.getElementById('editCategory').value = cat || '';
    document.getElementById('editServiceName').value = name || '';
    document.getElementById('editLaborCost').value = Math.round(Number(cost) || 0);
    document.getElementById('editEstimatedDuration').value = duration || 60;
    document.getElementById('editStatus').value = status || 'ACTIVE';
    document.getElementById('editDescription').value = desc || '';
    document.getElementById('editServiceModal').style.display = 'flex';
}
</script>

</main>
</div>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
