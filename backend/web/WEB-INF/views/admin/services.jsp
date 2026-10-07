<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../includes/admin-navbar.jsp">
    <jsp:param name="title" value="Quản Lý Danh Mục Dịch Vụ - CareCar" />
</jsp:include>
<jsp:include page="../includes/admin-sidebar.jsp" />

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
    <div>
        <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--light-text);">Bảng Giá &amp; Danh Mục Dịch Vụ Sửa Chữa</h1>
        <p style="color: var(--light-muted); font-size: 0.9rem;">Cấu hình các hạng mục tiền công và thời gian thi công ước tính</p>
    </div>
    <div>
        <button type="button" class="btn btn-primary" onclick="document.getElementById('addServiceModal').style.display='flex';">
            <i class="fa-solid fa-plus"></i> Thêm Dịch Vụ Mới
        </button>
    </div>
</div>

<c:if test="${param.msg == 'service_added'}">
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Đã thêm dịch vụ mới vào hệ thống!</div>
</c:if>
<c:if test="${param.msg == 'status_updated'}">
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Đã cập nhật trạng thái hoạt động của dịch vụ!</div>
</c:if>

<div class="card">
    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th>Nhóm Dịch Vụ</th>
                    <th>Tên Dịch Vụ</th>
                    <th>Mô Tả Quy Trình</th>
                    <th style="text-align: center;">Thời Gian (~phút)</th>
                    <th style="text-align: right;">Tiền Công Niêm Yết</th>
                    <th>Trạng Thái</th>
                    <th style="text-align: center;">Thao Tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${services}" var="s">
                    <tr>
                        <td><span class="badge badge-info">${s.category}</span></td>
                        <td><strong>${s.serviceName}</strong></td>
                        <td><small style="color: var(--light-muted);">${s.description}</small></td>
                        <td style="text-align: center;">${s.estimatedDuration} phút</td>
                        <td style="text-align: right; font-weight: 800; color: var(--primary);">
                            <fmt:formatNumber value="${s.laborCost}" pattern="#,###" /> ₫
                        </td>
                        <td>
                            <span class="badge ${s.status == 'ACTIVE' ? 'badge-success' : 'badge-secondary'}">
                                ${s.status}
                            </span>
                        </td>
                        <td style="text-align: center;">
                            <form action="${pageContext.request.contextPath}/admin/services" method="POST" style="display: inline;">
                                <input type="hidden" name="action" value="toggleStatus">
                                <input type="hidden" name="serviceId" value="${s.serviceId}">
                                <input type="hidden" name="status" value="${s.status == 'ACTIVE' ? 'INACTIVE' : 'ACTIVE'}">
                                <button type="submit" class="btn btn-sm btn-secondary" title="Đổi trạng thái">
                                    <i class="fa-solid fa-toggle-on"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<!-- Modal: Add Service -->
<div id="addServiceModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 9999; align-items: center; justify-content: center;">
    <div class="card" style="width: 550px; max-width: 90%; background: #fff;">
        <h3 style="font-size: 1.25rem; margin-bottom: 1rem;"><i class="fa-solid fa-plus-circle"></i> Thêm Dịch Vụ Mới</h3>
        <form action="${pageContext.request.contextPath}/admin/services" method="POST">
            <input type="hidden" name="action" value="addService">

            <div class="form-group">
                <label class="form-label">Nhóm dịch vụ</label>
                <input type="text" name="category" class="form-control" list="categoryOptions" placeholder="Bảo dưỡng định kỳ, Động cơ, Điện lạnh..." required>
                <datalist id="categoryOptions">
                    <option value="Bảo dưỡng định kỳ">
                    <option value="Động cơ & Hộp số">
                    <option value="Khung gầm & Phanh">
                    <option value="Điện & Điện lạnh">
                    <option value="Đồng sơn & Chăm sóc">
                </datalist>
            </div>

            <div class="form-group">
                <label class="form-label">Tên dịch vụ (*)</label>
                <input type="text" name="serviceName" class="form-control" placeholder="Ví dụ: Thay dầu động cơ..." required>
            </div>

            <div class="form-group">
                <label class="form-label">Mô tả quy trình</label>
                <textarea name="description" class="form-control" placeholder="Mô tả các bước thực hiện..."></textarea>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                <div class="form-group">
                    <label class="form-label">Giá tiền công (₫) (*)</label>
                    <input type="text" name="laborCost" class="form-control" placeholder="350000" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Thời gian ước tính (phút)</label>
                    <input type="number" name="estimatedDuration" value="60" min="10" class="form-control" required>
                </div>
            </div>

            <div style="text-align: right; margin-top: 1.5rem;">
                <button type="button" class="btn btn-secondary" onclick="document.getElementById('addServiceModal').style.display='none';">Hủy</button>
                <button type="submit" class="btn btn-primary"><i class="fa-solid fa-save"></i> Lưu Dịch Vụ</button>
            </div>
        </form>
    </div>
</div>

</main>
</div>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
