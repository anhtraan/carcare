<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../includes/admin-navbar.jsp">
    <jsp:param name="title" value="Quản Lý Kho Phụ Tùng &amp; Linh Kiện - CareCar" />
</jsp:include>
<jsp:include page="../includes/admin-sidebar.jsp" />

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
    <div>
        <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--light-text);">Quản Lý Kho Phụ Tùng &amp; Linh Kiện Ô Tô</h1>
        <p style="color: var(--light-muted); font-size: 0.9rem;">Kiểm soát số lượng tồn kho, giá nhập, giá bán và định mức cảnh báo hết hàng</p>
    </div>
    <div>
        <button type="button" class="btn btn-primary" onclick="document.getElementById('addPartModal').style.display='flex';">
            <i class="fa-solid fa-plus"></i> Nhập Phụ Tùng Mới
        </button>
    </div>
</div>

<c:if test="${param.msg == 'part_added'}">
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Đã thêm phụ tùng mới vào danh mục kho!</div>
</c:if>
<c:if test="${param.msg == 'stock_updated'}">
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Đã cập nhật số lượng tồn kho thành công!</div>
</c:if>

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem;">
    <div style="display: flex; gap: 0.5rem;">
        <a href="${pageContext.request.contextPath}/admin/spare-parts" class="btn btn-sm ${empty filter ? 'btn-primary' : 'btn-secondary'}">
            Tất cả phụ tùng
        </a>
        <a href="${pageContext.request.contextPath}/admin/spare-parts?filter=low_stock" class="btn btn-sm ${filter == 'low_stock' ? 'btn-primary' : 'btn-secondary'}">
            <i class="fa-solid fa-triangle-exclamation" style="color: var(--danger);"></i> Cảnh báo sắp hết hàng
        </a>
    </div>

    <div style="max-width: 280px; width: 100%;">
        <input type="text" id="tableSearchInput" class="form-control" placeholder="Tìm tên, mã phụ tùng...">
    </div>
</div>

<div class="card">
    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th>Mã Phụ Tùng</th>
                    <th>Tên Linh Kiện</th>
                    <th>Nhóm</th>
                    <th>ĐVT</th>
                    <th style="text-align: right;">Giá Nhập (Vốn)</th>
                    <th style="text-align: right;">Giá Bán Lẻ</th>
                    <th style="text-align: center;">Tồn Kho</th>
                    <th>Vị Trí Kệ</th>
                    <th style="text-align: center;">Cập Nhật Kho</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${parts}" var="p">
                    <tr>
                        <td><strong style="background: #f1f5f9; padding: 0.15rem 0.4rem; border-radius: 4px;">${p.partCode}</strong></td>
                        <td><strong>${p.partName}</strong></td>
                        <td><span class="badge badge-info">${p.category}</span></td>
                        <td>${p.unit}</td>
                        <td style="text-align: right; color: #64748b;"><fmt:formatNumber value="${p.costPrice}" pattern="#,###" /> ₫</td>
                        <td style="text-align: right; font-weight: 700; color: var(--primary);"><fmt:formatNumber value="${p.unitPrice}" pattern="#,###" /> ₫</td>
                        <td style="text-align: center;">
                            <c:choose>
                                <c:when test="${p.lowStock}">
                                    <span class="badge badge-danger">Cảnh báo: ${p.quantityInStock} ${p.unit}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-success">${p.quantityInStock} ${p.unit}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><small style="color: var(--light-muted);">${p.location != null ? p.location : '—'}</small></td>
                        <td style="text-align: center;">
                            <form action="${pageContext.request.contextPath}/admin/spare-parts" method="POST" style="display: inline-flex; align-items: center; gap: 0.35rem;">
                                <input type="hidden" name="action" value="updateStock">
                                <input type="hidden" name="partId" value="${p.partId}">
                                <input type="number" name="quantityChange" value="5" style="width: 55px; padding: 0.25rem; font-size: 0.85rem; border: 1px solid var(--light-border); border-radius: 4px; text-align: center;">
                                <button type="submit" class="btn btn-sm btn-secondary" title="Nhập thêm hàng vào kho">
                                    <i class="fa-solid fa-plus"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty parts}">
                    <tr>
                        <td colspan="9" style="text-align: center; color: var(--light-muted); padding: 2rem;">Không có phụ tùng nào.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<!-- Modal: Add New Spare Part -->
<div id="addPartModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 9999; align-items: center; justify-content: center;">
    <div class="card" style="width: 600px; max-width: 90%; background: #fff;">
        <h3 style="font-size: 1.25rem; margin-bottom: 1rem;"><i class="fa-solid fa-plus-circle"></i> Thêm Mới Phụ Tùng Vào Kho</h3>
        <form action="${pageContext.request.contextPath}/admin/spare-parts" method="POST">
            <input type="hidden" name="action" value="addPart">

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                <div class="form-group">
                    <label class="form-label">Mã phụ tùng (*)</label>
                    <input type="text" name="partCode" class="form-control" placeholder="OIL-CASTROL-5W30" required style="text-transform: uppercase;">
                </div>
                <div class="form-group">
                    <label class="form-label">Tên phụ tùng / Linh kiện (*)</label>
                    <input type="text" name="partName" class="form-control" placeholder="Dầu nhớt Castrol 5W30 (4L)" required>
                </div>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                <div class="form-group">
                    <label class="form-label">Nhóm loại</label>
                    <select name="category" class="form-select">
                        <option value="Dầu nhớt/Hóa chất">Dầu nhớt / Hóa chất</option>
                        <option value="Lọc gió/Lọc dầu">Lọc gió / Lọc dầu</option>
                        <option value="Hệ thống phanh">Hệ thống phanh</option>
                        <option value="Bugi/Đánh lửa">Bugi / Đánh lửa</option>
                        <option value="Đèn/Điện/Ắc quy">Đèn / Điện / Ắc quy</option>
                        <option value="Gầm/Lốp/Giảm xóc">Gầm / Lốp / Giảm xóc</option>
                        <option value="Khác">Khác</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Đơn vị tính</label>
                    <input type="text" name="unit" class="form-control" value="Cái" placeholder="Cái, Lít, Bình, Bộ...">
                </div>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                <div class="form-group">
                    <label class="form-label">Giá vốn nhập (₫)</label>
                    <input type="text" name="costPrice" class="form-control" placeholder="500000" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Giá bán lẻ niêm yết (₫)</label>
                    <input type="text" name="unitPrice" class="form-control" placeholder="750000" required>
                </div>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 1rem;">
                <div class="form-group">
                    <label class="form-label">Số lượng nhập ban đầu</label>
                    <input type="number" name="quantityInStock" value="10" min="0" class="form-control" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Ngưỡng báo hết hàng</label>
                    <input type="number" name="minStockAlert" value="5" min="1" class="form-control" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Vị trí kệ kho</label>
                    <input type="text" name="location" class="form-control" placeholder="Kệ A1-02">
                </div>
            </div>

            <div style="text-align: right; margin-top: 1.5rem;">
                <button type="button" class="btn btn-secondary" onclick="document.getElementById('addPartModal').style.display='none';">Hủy</button>
                <button type="submit" class="btn btn-primary"><i class="fa-solid fa-save"></i> Lưu Phụ Tùng</button>
            </div>
        </form>
    </div>
</div>

</main>
</div>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
