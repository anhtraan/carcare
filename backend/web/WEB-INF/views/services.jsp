<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="title" value="Bảng Giá Dịch Vụ Sửa Chữa &amp; Bảo Dưỡng Ô Tô - CareCar" />
</jsp:include>

<div style="background: #0f172a; color: #fff; padding: 3rem 1.5rem; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.1);">
    <div class="container" style="padding: 0;">
        <span class="badge badge-warning" style="margin-bottom: 0.75rem;">BẢNG GIÁ NIÊM YẾT MINH BẠCH</span>
        <h1 style="font-size: 2.5rem; font-weight: 900; margin-bottom: 0.5rem;">Dịch Vụ &amp; Báo Giá Tiền Công</h1>
        <p style="color: #94a3b8; max-width: 600px; margin: 0 auto;">
            Cam kết không phát sinh chi phí ngoài báo giá đã thỏa thuận với chủ xe.
        </p>
    </div>
</div>

<div class="container">
    <!-- Category Filter Tabs -->
    <div style="display: flex; gap: 0.5rem; overflow-x: auto; padding-bottom: 1.5rem; margin-bottom: 1rem; border-bottom: 1px solid var(--light-border);">
        <a href="${pageContext.request.contextPath}/services" class="btn btn-sm ${empty selectedCategory || selectedCategory == 'ALL' ? 'btn-primary' : 'btn-secondary'}">
            Tất cả danh mục
        </a>
        <c:forEach items="${categories}" var="cat">
            <a href="${pageContext.request.contextPath}/services?category=${cat}" class="btn btn-sm ${selectedCategory == cat ? 'btn-primary' : 'btn-secondary'}">
                ${cat}
            </a>
        </c:forEach>
    </div>

    <!-- Service Grid -->
    <div class="grid-3" style="margin-top: 1.5rem;">
        <c:forEach items="${services}" var="s">
            <div class="card" style="display: flex; flex-direction: column; justify-content: space-between;">
                <div>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.75rem;">
                        <span class="badge badge-info">${s.category}</span>
                        <span style="font-size: 0.8rem; color: var(--light-muted);"><i class="fa-regular fa-clock"></i> ~${s.estimatedDuration} phút</span>
                    </div>
                    <h3 class="card-title" style="font-size: 1.2rem; margin-bottom: 0.5rem;">${s.serviceName}</h3>
                    <p style="font-size: 0.875rem; color: var(--light-muted); line-height: 1.5;">
                        ${s.description}
                    </p>
                </div>

                <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid var(--light-border); padding-top: 1rem; margin-top: 1.25rem;">
                    <div>
                        <span style="font-size: 0.75rem; color: var(--light-muted); display: block;">Tiền công tham khảo:</span>
                        <span style="font-size: 1.25rem; font-weight: 800; color: var(--primary);">
                            <fmt:formatNumber value="${s.laborCost}" pattern="#,###" /> ₫
                        </span>
                    </div>
                    <a href="${pageContext.request.contextPath}/booking?serviceId=${s.serviceId}" class="btn btn-primary">
                        <i class="fa-regular fa-calendar-plus"></i> Đặt lịch
                    </a>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
