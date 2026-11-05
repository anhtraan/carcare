<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../includes/admin-navbar.jsp">
    <jsp:param name="title" value="Quản Lý Kho Phụ Tùng &amp; Linh Kiện - CareCar" />
</jsp:include>
<jsp:include page="../includes/admin-sidebar.jsp" />

<!-- Header -->
<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem;">
    <div>
        <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--light-text); margin-bottom: 0.25rem;">
            <i class="fa-solid fa-boxes-stacked" style="color: var(--primary);"></i> Quản Lý Kho Phụ Tùng &amp; Linh Kiện Ô Tô
        </h1>
        <p style="color: var(--light-muted); font-size: 0.9rem; margin: 0;">
            Kiểm soát số lượng tồn kho, vị trí kệ, cảnh báo hết hàng và nhập bổ sung linh kiện
        </p>
    </div>

    <div style="display: flex; gap: 0.75rem; align-items: center;">
        <c:choose>
            <c:when test="${sessionScope.currentUser.admin}">
                <button type="button" class="btn btn-primary" onclick="openAddPartModal();">
                    <i class="fa-solid fa-plus-circle"></i> Thêm Phụ Tùng Mới
                </button>
            </c:when>
            <c:when test="${sessionScope.currentUser.mechanic}">
                <span class="badge badge-info" style="font-size: 0.875rem; padding: 0.5rem 0.85rem; display: inline-flex; align-items: center; gap: 0.4rem;">
                    <i class="fa-solid fa-screwdriver-wrench"></i> Quyền Thợ Máy: Tra cứu tồn kho &amp; vị trí kệ
                </span>
            </c:when>
        </c:choose>
    </div>
</div>

<!-- Role Notice for Mechanics -->
<c:if test="${sessionScope.currentUser.mechanic}">
    <div class="alert alert-info" style="display: flex; align-items: center; gap: 0.75rem; border-left: 4px solid #3b82f6; margin-bottom: 1.5rem; background: #eff6ff;">
        <i class="fa-solid fa-circle-info" style="font-size: 1.25rem; color: #2563eb;"></i>
        <div style="font-size: 0.9rem;">
            <strong>Chế độ Tra Cứu Kỹ Thuật Viên:</strong> Bạn có quyền kiểm tra số lượng linh kiện có sẵn trong kho và vị trí kệ để thay thế cho xe. Quyền nhập kho và điều chỉnh số lượng thuộc Quản Trị Viên (Admin).
        </div>
    </div>
</c:if>

<!-- Notification Alerts -->
<c:if test="${param.msg == 'part_added'}">
    <div class="alert alert-success" style="display: flex; align-items: center; gap: 0.5rem; border-left: 4px solid #10b981; margin-bottom: 1.5rem;">
        <i class="fa-solid fa-circle-check" style="font-size: 1.2rem;"></i>
        <div><strong>Thành công!</strong> Đã thêm mã phụ tùng mới vào danh mục kho.</div>
    </div>
</c:if>
<c:if test="${param.msg == 'stock_updated'}">
    <div class="alert alert-success" style="display: flex; align-items: center; gap: 0.5rem; border-left: 4px solid #10b981; margin-bottom: 1.5rem;">
        <i class="fa-solid fa-circle-check" style="font-size: 1.2rem;"></i>
        <div><strong>Thành công!</strong> Đã cập nhật số lượng nhập kho cho phụ tùng.</div>
    </div>
</c:if>
<c:if test="${param.msg == 'part_updated'}">
    <div class="alert alert-success" style="display: flex; align-items: center; gap: 0.5rem; border-left: 4px solid #10b981; margin-bottom: 1.5rem;">
        <i class="fa-solid fa-circle-check" style="font-size: 1.2rem;"></i>
        <div><strong>Thành công!</strong> Đã cập nhật thông tin phụ tùng.</div>
    </div>
</c:if>
<c:if test="${param.error == 'permission_denied'}">
    <div class="alert alert-danger" style="display: flex; align-items: center; gap: 0.5rem; border-left: 4px solid #ef4444; margin-bottom: 1.5rem;">
        <i class="fa-solid fa-ban" style="font-size: 1.2rem;"></i>
        <div><strong>Từ chối quyền hạn:</strong> Chỉ Quản Trị Viên (Admin) mới có quyền nhập kho và thay đổi số lượng phụ tùng! Thợ sửa chỉ có quyền xem tồn kho.</div>
    </div>
</c:if>
<c:if test="${param.error == 'duplicate_code'}">
    <div class="alert alert-danger" style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 1.5rem;">
        <i class="fa-solid fa-triangle-exclamation" style="font-size: 1.2rem;"></i>
        <div>Mã phụ tùng đã tồn tại trong hệ thống kho! Vui lòng chọn một mã khác.</div>
    </div>
</c:if>
<c:if test="${param.error == 'missing_info'}">
    <div class="alert alert-danger" style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 1.5rem;">
        <i class="fa-solid fa-circle-xmark" style="font-size: 1.2rem;"></i>
        <div>Vui lòng điền đầy đủ mã phụ tùng và tên linh kiện!</div>
    </div>
</c:if>
<c:if test="${param.error == 'invalid_quantity'}">
    <div class="alert alert-danger" style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 1.5rem;">
        <i class="fa-solid fa-circle-xmark" style="font-size: 1.2rem;"></i>
        <div>Số lượng nhập thêm không hợp lệ!</div>
    </div>
</c:if>
<c:if test="${param.error == 'save_failed'}">
    <div class="alert alert-danger" style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 1.5rem;">
        <i class="fa-solid fa-circle-xmark" style="font-size: 1.2rem;"></i>
        <div>Không thể lưu phụ tùng mới. Vui lòng kiểm tra lại thông tin và thử lại!</div>
    </div>
</c:if>

<!-- Warehouse Metrics Cards -->
<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 1rem; margin-bottom: 1.5rem;">
    <!-- Metric 1: Total Items -->
    <div class="card" style="padding: 1.25rem; display: flex; align-items: center; gap: 1rem; border-left: 4px solid var(--primary);">
        <div style="width: 46px; height: 46px; border-radius: 10px; background: #eff6ff; color: var(--primary); display: flex; align-items: center; justify-content: center; font-size: 1.3rem;">
            <i class="fa-solid fa-boxes-stacked"></i>
        </div>
        <div>
            <div style="font-size: 0.8rem; color: var(--light-muted); font-weight: 600; text-transform: uppercase;">Tổng số mặt hàng</div>
            <div style="font-size: 1.35rem; font-weight: 800; color: #0f172a;">${totalItems} <span style="font-size: 0.85rem; font-weight: 500; color: #64748b;">loại (${totalStockQuantity} món)</span></div>
        </div>
    </div>

    <!-- Metric 2: Low Stock Warning -->
    <a href="${pageContext.request.contextPath}/admin/spare-parts?filter=low_stock" style="text-decoration: none; color: inherit;">
        <div class="card" style="padding: 1.25rem; display: flex; align-items: center; gap: 1rem; border-left: 4px solid #f59e0b; cursor: pointer; transition: transform 0.2s;">
            <div style="width: 46px; height: 46px; border-radius: 10px; background: #fffbeb; color: #f59e0b; display: flex; align-items: center; justify-content: center; font-size: 1.3rem;">
                <i class="fa-solid fa-triangle-exclamation"></i>
            </div>
            <div>
                <div style="font-size: 0.8rem; color: var(--light-muted); font-weight: 600; text-transform: uppercase;">Sắp hết hàng</div>
                <div style="font-size: 1.35rem; font-weight: 800; color: #d97706;">${lowStockCount} <span style="font-size: 0.85rem; font-weight: 500; color: #b45309;">mặt hàng</span></div>
            </div>
        </div>
    </a>

    <!-- Metric 3: Out of Stock -->
    <a href="${pageContext.request.contextPath}/admin/spare-parts?filter=out_of_stock" style="text-decoration: none; color: inherit;">
        <div class="card" style="padding: 1.25rem; display: flex; align-items: center; gap: 1rem; border-left: 4px solid #ef4444; cursor: pointer; transition: transform 0.2s;">
            <div style="width: 46px; height: 46px; border-radius: 10px; background: #fef2f2; color: #ef4444; display: flex; align-items: center; justify-content: center; font-size: 1.3rem;">
                <i class="fa-solid fa-box-open"></i>
            </div>
            <div>
                <div style="font-size: 0.8rem; color: var(--light-muted); font-weight: 600; text-transform: uppercase;">Hết hàng trong kho</div>
                <div style="font-size: 1.35rem; font-weight: 800; color: #dc2626;">${outOfStockCount} <span style="font-size: 0.85rem; font-weight: 500; color: #991b1b;">mặt hàng</span></div>
            </div>
        </div>
    </a>

    <!-- Metric 4: Total Inventory Capital (Admin only) -->
    <c:if test="${sessionScope.currentUser.admin}">
        <div class="card" style="padding: 1.25rem; display: flex; align-items: center; gap: 1rem; border-left: 4px solid #10b981;">
            <div style="width: 46px; height: 46px; border-radius: 10px; background: #ecfdf5; color: #10b981; display: flex; align-items: center; justify-content: center; font-size: 1.3rem;">
                <i class="fa-solid fa-coins"></i>
            </div>
            <div>
                <div style="font-size: 0.8rem; color: var(--light-muted); font-weight: 600; text-transform: uppercase;">Giá trị vốn tồn kho</div>
                <div style="font-size: 1.35rem; font-weight: 800; color: #047857;">
                    <fmt:formatNumber value="${totalInventoryValue}" pattern="#,###" /> ₫
                </div>
            </div>
        </div>
    </c:if>
</div>

<!-- Controls: Filter Pills & Instant Live Search -->
<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem;">
    <div style="display: flex; gap: 0.5rem; flex-wrap: wrap;">
        <a href="${pageContext.request.contextPath}/admin/spare-parts" class="btn btn-sm ${empty filter ? 'btn-primary' : 'btn-secondary'}">
            Tất cả phụ tùng (${totalItems})
        </a>
        <a href="${pageContext.request.contextPath}/admin/spare-parts?filter=low_stock" class="btn btn-sm ${filter == 'low_stock' ? 'btn-primary' : 'btn-secondary'}">
            <i class="fa-solid fa-triangle-exclamation" style="color: #f59e0b;"></i> Sắp hết (${lowStockCount})
        </a>
        <a href="${pageContext.request.contextPath}/admin/spare-parts?filter=out_of_stock" class="btn btn-sm ${filter == 'out_of_stock' ? 'btn-primary' : 'btn-secondary'}">
            <i class="fa-solid fa-box-open" style="color: #ef4444;"></i> Hết hàng (${outOfStockCount})
        </a>
    </div>

    <div style="max-width: 320px; width: 100%; position: relative;">
        <input type="text" id="partSearchInput" class="form-control" placeholder="Tìm tên, mã, vị trí kệ..." onkeyup="filterPartTable();">
        <i class="fa-solid fa-search" style="position: absolute; right: 12px; top: 50%; transform: translateY(-50%); color: #94a3b8;"></i>
    </div>
</div>

<!-- Spare Parts Table -->
<div class="card">
    <div class="table-responsive">
        <table class="table" id="partsTable">
            <thead>
                <tr>
                    <th>Mã Phụ Tùng</th>
                    <th>Tên Linh Kiện</th>
                    <th>Nhóm</th>
                    <th>ĐVT</th>
                    <c:if test="${sessionScope.currentUser.admin}">
                        <th style="text-align: right;">Giá Nhập (Vốn)</th>
                    </c:if>
                    <th style="text-align: right;">Giá Bán Lẻ</th>
                    <th style="text-align: center;">Số Lượng Tồn</th>
                    <th>Vị Trí Kệ</th>
                    <th style="text-align: center;">
                        <c:choose>
                            <c:when test="${sessionScope.currentUser.admin}">
                                Nhập Thêm Số Lượng
                            </c:when>
                            <c:otherwise>
                                Trạng Thái Sẵn Sàng
                            </c:otherwise>
                        </c:choose>
                    </th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${parts}" var="p">
                    <tr class="part-row" data-code="${p.partCode}" data-name="${p.partName}" data-category="${p.category}" data-location="${p.location}">
                        <td>
                            <strong style="background: #f1f5f9; padding: 0.2rem 0.5rem; border-radius: 4px; font-family: monospace; font-size: 0.9rem;">
                                <c:out value="${p.partCode}" />
                            </strong>
                        </td>
                        <td>
                            <strong><c:out value="${p.partName}" /></strong>
                        </td>
                        <td>
                            <span class="badge badge-info"><c:out value="${p.category}" /></span>
                        </td>
                        <td><c:out value="${p.unit}" /></td>
                        <c:if test="${sessionScope.currentUser.admin}">
                            <td style="text-align: right; color: #64748b; font-size: 0.925rem;">
                                <fmt:formatNumber value="${p.costPrice}" pattern="#,###" /> ₫
                            </td>
                        </c:if>
                        <td style="text-align: right; font-weight: 700; color: var(--primary);">
                            <fmt:formatNumber value="${p.unitPrice}" pattern="#,###" /> ₫
                        </td>
                        <td style="text-align: center;">
                            <c:choose>
                                <c:when test="${p.quantityInStock <= 0}">
                                    <span class="badge badge-danger" style="font-size: 0.85rem; padding: 0.3rem 0.6rem;">
                                        <i class="fa-solid fa-circle-xmark"></i> Hết hàng (0 ${p.unit})
                                    </span>
                                </c:when>
                                <c:when test="${p.lowStock}">
                                    <span class="badge badge-warning" style="font-size: 0.85rem; padding: 0.3rem 0.6rem;">
                                        <i class="fa-solid fa-triangle-exclamation"></i> Sắp hết (${p.quantityInStock} ${p.unit})
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-success" style="font-size: 0.85rem; padding: 0.3rem 0.6rem;">
                                        <i class="fa-solid fa-boxes-stacked"></i> ${p.quantityInStock} ${p.unit}
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty p.location}">
                                    <span style="font-size: 0.85rem; background: #f8fafc; border: 1px solid #e2e8f0; padding: 0.15rem 0.4rem; border-radius: 4px;">
                                        <i class="fa-solid fa-location-dot" style="color: #64748b;"></i> <c:out value="${p.location}" />
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <small style="color: var(--light-muted);">—</small>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <!-- Action Column: Role Dependent -->
                        <td style="text-align: center;">
                            <c:choose>
                                <c:when test="${sessionScope.currentUser.admin}">
                                    <!-- Admin can add stock directly or click to open modal -->
                                    <button type="button" class="btn btn-sm btn-success" 
                                            onclick="openAddStockModal(${p.partId}, '${p.partCode}', '${p.partName}', ${p.quantityInStock}, '${p.unit}');" 
                                            title="Nhập thêm số lượng phụ tùng này vào kho">
                                        <i class="fa-solid fa-plus"></i> Nhập Thêm
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <!-- Mechanic: View-only status indicator -->
                                    <c:choose>
                                        <c:when test="${p.quantityInStock > 0}">
                                            <span style="color: #059669; font-weight: 700; font-size: 0.875rem;">
                                                <i class="fa-solid fa-circle-check"></i> Sẵn sàng thay
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #dc2626; font-weight: 700; font-size: 0.875rem;">
                                                <i class="fa-solid fa-ban"></i> Đang chờ nhập
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty parts}">
                    <tr>
                        <td colspan="${sessionScope.currentUser.admin ? 9 : 8}" style="text-align: center; color: var(--light-muted); padding: 3rem 1rem;">
                            <i class="fa-solid fa-box-open" style="font-size: 2.5rem; margin-bottom: 0.5rem; color: #cbd5e1;"></i>
                            <div>Không tìm thấy phụ tùng nào phù hợp.</div>
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<c:if test="${sessionScope.currentUser.admin}">
    <!-- Modal 1: Nhập Thêm Số Lượng Phụ Tùng (Admin Only) -->
    <div id="addStockModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 9999; align-items: center; justify-content: center; backdrop-filter: blur(2px);">
        <div class="card" style="width: 480px; max-width: 95%; background: #fff; border-radius: 12px; box-shadow: 0 20px 40px rgba(0,0,0,0.3);">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.25rem;">
                <h3 style="font-size: 1.25rem; font-weight: 800; color: var(--success); margin: 0;">
                    <i class="fa-solid fa-boxes-packing"></i> Nhập Thêm Phụ Tùng Vào Kho
                </h3>
                <button type="button" onclick="closeAddStockModal();" style="border: none; background: transparent; font-size: 1.25rem; cursor: pointer; color: #94a3b8;">&times;</button>
            </div>

            <form action="${pageContext.request.contextPath}/admin/spare-parts" method="POST">
                <input type="hidden" name="csrfToken" value="${csrfToken}">
                <input type="hidden" name="action" value="addStock">
                <input type="hidden" id="stockModalPartId" name="partId" value="">

                <div style="background: #f8fafc; padding: 1rem; border-radius: var(--radius-md); margin-bottom: 1.25rem; border: 1.5px solid #e2e8f0;">
                    <div style="font-size: 0.85rem; color: #64748b;">Mã phụ tùng: <strong id="stockModalPartCode" style="color: #0f172a; font-family: monospace;"></strong></div>
                    <div style="font-size: 1.05rem; font-weight: 700; color: var(--primary); margin-top: 0.25rem;" id="stockModalPartName"></div>
                    <div style="font-size: 0.875rem; color: #64748b; margin-top: 0.35rem;">
                        Tồn kho hiện tại: <strong id="stockModalCurrentQty" style="color: #059669; font-size: 1.1rem;"></strong> <span id="stockModalUnit"></span>
                    </div>
                </div>

                <div class="form-group" style="margin-bottom: 1rem;">
                    <label class="form-label" style="font-weight: 700;">Số lượng nhập thêm vào kho (*)</label>
                    <input type="number" id="quantityToAddInput" name="quantityToAdd" value="10" min="1" class="form-control" style="font-size: 1.2rem; font-weight: 700; text-align: center;" required>
                </div>

                <!-- Quick click add buttons -->
                <div style="display: flex; gap: 0.5rem; justify-content: center; margin-bottom: 1.5rem;">
                    <button type="button" class="btn btn-sm btn-secondary" onclick="setQuickQty(5);">+5</button>
                    <button type="button" class="btn btn-sm btn-secondary" onclick="setQuickQty(10);">+10</button>
                    <button type="button" class="btn btn-sm btn-secondary" onclick="setQuickQty(20);">+20</button>
                    <button type="button" class="btn btn-sm btn-secondary" onclick="setQuickQty(50);">+50</button>
                    <button type="button" class="btn btn-sm btn-secondary" onclick="setQuickQty(100);">+100</button>
                </div>

                <div style="text-align: right; border-top: 1px solid #f1f5f9; padding-top: 1rem; display: flex; justify-content: flex-end; gap: 0.75rem;">
                    <button type="button" class="btn btn-secondary" onclick="closeAddStockModal();">Hủy bỏ</button>
                    <button type="submit" class="btn btn-success"><i class="fa-solid fa-check"></i> Xác Nhận Nhập Kho</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal 2: Thêm Phụ Tùng Mới (Admin Only) -->
    <div id="addPartModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 9999; align-items: center; justify-content: center; backdrop-filter: blur(2px);">
        <div class="card" style="width: 650px; max-width: 95%; background: #fff; border-radius: 12px; box-shadow: 0 20px 40px rgba(0,0,0,0.3); max-height: 90vh; overflow-y: auto;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.25rem;">
                <h3 style="font-size: 1.25rem; font-weight: 800; color: var(--primary); margin: 0;">
                    <i class="fa-solid fa-plus-circle"></i> Thêm Mới Phụ Tùng Vào Kho
                </h3>
                <button type="button" onclick="closeAddPartModal();" style="border: none; background: transparent; font-size: 1.25rem; cursor: pointer; color: #94a3b8;">&times;</button>
            </div>

            <form action="${pageContext.request.contextPath}/admin/spare-parts" method="POST">
                <input type="hidden" name="csrfToken" value="${csrfToken}">
                <input type="hidden" name="action" value="addPart">

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
                    <div class="form-group">
                        <label class="form-label" style="font-weight: 700;">Mã phụ tùng (*)</label>
                        <input type="text" name="partCode" class="form-control" placeholder="OIL-CASTROL-5W30" required style="text-transform: uppercase;">
                        <small style="color: var(--light-muted);">Mã duy nhất, không trùng lặp</small>
                    </div>
                    <div class="form-group">
                        <label class="form-label" style="font-weight: 700;">Tên phụ tùng / Linh kiện (*)</label>
                        <input type="text" name="partName" class="form-control" placeholder="Dầu nhớt Castrol EDGE 5W30 (4L)" required>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
                    <div class="form-group">
                        <label class="form-label" style="font-weight: 700;">Nhóm phân loại</label>
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
                        <label class="form-label" style="font-weight: 700;">Đơn vị tính</label>
                        <input type="text" name="unit" class="form-control" value="Cái" placeholder="Cái, Lít, Bình, Bộ, Cặp...">
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
                    <div class="form-group">
                        <label class="form-label" style="font-weight: 700;">Giá vốn nhập (₫)</label>
                        <input type="text" name="costPrice" class="form-control" placeholder="500,000" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" style="font-weight: 700;">Giá bán lẻ niêm yết (₫)</label>
                        <input type="text" name="unitPrice" class="form-control" placeholder="750,000" required>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 1rem; margin-bottom: 1.5rem;">
                    <div class="form-group">
                        <label class="form-label" style="font-weight: 700;">Số lượng nhập kho ban đầu</label>
                        <input type="number" name="quantityInStock" value="10" min="0" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" style="font-weight: 700;">Định mức báo hết</label>
                        <input type="number" name="minStockAlert" value="5" min="1" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" style="font-weight: 700;">Vị trí kệ kho</label>
                        <input type="text" name="location" class="form-control" placeholder="Kệ A1-02">
                    </div>
                </div>

                <div style="text-align: right; border-top: 1px solid #f1f5f9; padding-top: 1rem; display: flex; justify-content: flex-end; gap: 0.75rem;">
                    <button type="button" class="btn btn-secondary" onclick="closeAddPartModal();">Hủy bỏ</button>
                    <button type="submit" class="btn btn-primary"><i class="fa-solid fa-save"></i> Lưu Phụ Tùng Vào Kho</button>
                </div>
            </form>
        </div>
    </div>
</c:if>

</main>
</div>

<script>
function openAddPartModal() {
    const m = document.getElementById('addPartModal');
    if (m) m.style.display = 'flex';
}

function closeAddPartModal() {
    const m = document.getElementById('addPartModal');
    if (m) m.style.display = 'none';
}

function openAddStockModal(partId, partCode, partName, currentQty, unit) {
    const m = document.getElementById('addStockModal');
    if (!m) return;
    document.getElementById('stockModalPartId').value = partId;
    document.getElementById('stockModalPartCode').textContent = partCode;
    document.getElementById('stockModalPartName').textContent = partName;
    document.getElementById('stockModalCurrentQty').textContent = currentQty;
    document.getElementById('stockModalUnit').textContent = unit;
    document.getElementById('quantityToAddInput').value = 10;
    m.style.display = 'flex';
}

function closeAddStockModal() {
    const m = document.getElementById('addStockModal');
    if (m) m.style.display = 'none';
}

function setQuickQty(qty) {
    const input = document.getElementById('quantityToAddInput');
    if (input) input.value = qty;
}

function filterPartTable() {
    const q = (document.getElementById('partSearchInput').value || '').toLowerCase().trim();
    const rows = document.querySelectorAll('.part-row');

    rows.forEach(row => {
        const code = (row.getAttribute('data-code') || '').toLowerCase();
        const name = (row.getAttribute('data-name') || '').toLowerCase();
        const cat = (row.getAttribute('data-category') || '').toLowerCase();
        const loc = (row.getAttribute('data-location') || '').toLowerCase();

        if (!q || code.includes(q) || name.includes(q) || cat.includes(q) || loc.includes(q)) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}
</script>

<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
