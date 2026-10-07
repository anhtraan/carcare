<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="cc" uri="/WEB-INF/tlds/carecar.tld" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="title" value="Kết Quả Thanh Toán Trực Tuyến - CareCar" />
</jsp:include>

<main class="main-content py-5">
    <div class="container" style="max-width: 680px;">
        <div class="card shadow-lg border-0 rounded-4 overflow-hidden">
            <div class="card-header text-center py-4 ${paymentSuccess ? 'bg-success text-white' : 'bg-danger text-white'}">
                <c:choose>
                    <c:when test="${paymentSuccess}">
                        <div class="mb-2">
                            <i class="fa-solid fa-circle-check fa-4x animate__animated animate__bounceIn"></i>
                        </div>
                        <h3 class="fw-bold mb-1">Thanh Toán Thành Công!</h3>
                        <p class="mb-0 opacity-75">Cổng thanh toán điện tử VNPay Sandbox</p>
                    </c:when>
                    <c:otherwise>
                        <div class="mb-2">
                            <i class="fa-solid fa-circle-xmark fa-4x animate__animated animate__shakeX"></i>
                        </div>
                        <h3 class="fw-bold mb-1">Thanh Toán Không Thành Công</h3>
                        <p class="mb-0 opacity-75">${message}</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="card-body p-4 p-md-5">
                <div class="table-responsive">
                    <table class="table table-borderless mb-4">
                        <tbody>
                            <tr>
                                <th class="text-muted fw-normal" style="width: 45%;">Mã đơn hàng / Lệnh:</th>
                                <td class="fw-bold text-dark text-end">
                                    <span class="badge bg-primary fs-6 px-3 py-2">${orderCode}</span>
                                </td>
                            </tr>
                            <tr>
                                <th class="text-muted fw-normal">Số tiền thanh toán:</th>
                                <td class="fw-bold text-success text-end fs-5">
                                    <cc:formatCurrency value="${amount}" />
                                </td>
                            </tr>
                            <c:if test="${not empty bankCode}">
                                <tr>
                                    <th class="text-muted fw-normal">Ngân hàng / Kênh:</th>
                                    <td class="fw-semibold text-end">${bankCode}</td>
                                </tr>
                            </c:if>
                            <c:if test="${not empty transactionNo}">
                                <tr>
                                    <th class="text-muted fw-normal">Mã GD VNPay:</th>
                                    <td class="text-end font-monospace">${transactionNo}</td>
                                </tr>
                            </c:if>
                            <c:if test="${not empty payDate}">
                                <tr>
                                    <th class="text-muted fw-normal">Thời gian giao dịch:</th>
                                    <td class="text-end">${payDate}</td>
                                </tr>
                            </c:if>
                            <tr>
                                <th class="text-muted fw-normal">Trạng thái xử lý:</th>
                                <td class="text-end">
                                    <c:choose>
                                        <c:when test="${paymentSuccess}">
                                            <cc:statusBadge status="PAID_DELIVERED" type="order" />
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger">Giao dịch thất bại (Mã: ${responseCode})</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="d-flex flex-column flex-sm-row gap-3 justify-content-center mt-4 pt-3 border-top">
                    <c:if test="${not empty orderCode}">
                        <a href="${pageContext.request.contextPath}/track?query=${orderCode}" class="btn btn-primary px-4 py-2 rounded-pill">
                            <i class="fa-solid fa-magnifying-glass-location me-2"></i> Xem tiến độ xe
                        </a>
                    </c:if>
                    <c:choose>
                        <c:when test="${sessionScope.currentUser != null && (sessionScope.currentUser.admin || sessionScope.currentUser.receptionist)}">
                            <a href="${pageContext.request.contextPath}/admin/repair-orders" class="btn btn-outline-dark px-4 py-2 rounded-pill">
                                <i class="fa-solid fa-screwdriver-wrench me-2"></i> Danh sách lệnh sửa chữa
                            </a>
                        </c:when>
                        <c:when test="${sessionScope.currentUser != null && sessionScope.currentUser.customer}">
                            <a href="${pageContext.request.contextPath}/customer/dashboard" class="btn btn-outline-dark px-4 py-2 rounded-pill">
                                <i class="fa-solid fa-car me-2"></i> Hồ sơ cá nhân
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary px-4 py-2 rounded-pill">
                                <i class="fa-solid fa-house me-2"></i> Về trang chủ
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="includes/footer.jsp" />
