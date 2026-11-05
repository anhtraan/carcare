package com.carecar.filter;

import com.carecar.model.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/admin/*", "/customer/*"})
public class AuthFilter implements Filter {

    // Danh sách quyền hạn (RBAC) nghiêm ngặt map theo đường dẫn URL
    private static final Map<String, Set<String>> PATH_ROLE_MAP = new HashMap<>();

    static {
        // 1. Quản lý nhân sự: CHỈ ADMIN
        PATH_ROLE_MAP.put("/admin/staff", Set.of("ADMIN"));

        // 2. Quản lý danh sách khách hàng & xe: ADMIN và LỄ TÂN (Thợ máy không được xem toàn bộ khách hàng)
        PATH_ROLE_MAP.put("/admin/customers", Set.of("ADMIN", "RECEPTIONIST"));

        // 3. Quản lý doanh thu, xem hóa đơn & quyết toán đóng hóa đơn: ADMIN và LỄ TÂN (Thợ máy bị cấm)
        PATH_ROLE_MAP.put("/admin/invoices", Set.of("ADMIN", "RECEPTIONIST"));
        PATH_ROLE_MAP.put("/admin/invoice-detail", Set.of("ADMIN", "RECEPTIONIST"));
        PATH_ROLE_MAP.put("/admin/checkout", Set.of("ADMIN", "RECEPTIONIST"));

        // 4. Lịch hẹn khách hàng & Tiếp nhận xe mới tại xưởng: ADMIN và LỄ TÂN
        PATH_ROLE_MAP.put("/admin/appointments", Set.of("ADMIN", "RECEPTIONIST"));
        PATH_ROLE_MAP.put("/admin/repair-order-create", Set.of("ADMIN", "RECEPTIONIST"));

        // 5. Bảng giá & Danh mục dịch vụ kỹ thuật: ADMIN, THỢ MÁY, LỄ TÂN
        PATH_ROLE_MAP.put("/admin/services", Set.of("ADMIN", "MECHANIC", "RECEPTIONIST"));

        // 6. Kho phụ tùng ô tô: ADMIN, THỢ MÁY, LỄ TÂN
        PATH_ROLE_MAP.put("/admin/spare-parts", Set.of("ADMIN", "MECHANIC", "RECEPTIONIST"));

        // 7. Lệnh sửa chữa (Work Order) & Chi tiết lệnh: ADMIN, THỢ MÁY, LỄ TÂN
        PATH_ROLE_MAP.put("/admin/repair-orders", Set.of("ADMIN", "MECHANIC", "RECEPTIONIST"));
        PATH_ROLE_MAP.put("/admin/repair-order-detail", Set.of("ADMIN", "MECHANIC", "RECEPTIONIST"));

        // 8. Bảng điều khiển trung tâm xưởng: ADMIN, THỢ MÁY, LỄ TÂN
        PATH_ROLE_MAP.put("/admin/dashboard", Set.of("ADMIN", "MECHANIC", "RECEPTIONIST"));
        PATH_ROLE_MAP.put("/admin", Set.of("ADMIN", "MECHANIC", "RECEPTIONIST"));
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String contextPath = httpRequest.getContextPath();
        String servletPath = httpRequest.getServletPath();

        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // Xử lý các đường dẫn dành cho nhân viên xưởng (/admin/*)
        if (servletPath != null && servletPath.startsWith("/admin")) {
            if (currentUser == null) {
                httpResponse.sendRedirect(contextPath + "/login?error=auth_required&redirect=" + servletPath);
                return;
            }

            String userRole = (currentUser.getRole() != null) ? currentUser.getRole().toUpperCase().trim() : "";

            // Kiểm tra phân quyền chi tiết theo từng URL (Path-to-Role Mapping)
            Set<String> allowedRoles = PATH_ROLE_MAP.get(servletPath);
            if (allowedRoles == null) {
                // Fallback an toàn: Với bất kỳ đường dẫn admin nào chưa được định nghĩa rõ, mặc định CHỈ ADMIN được truy cập
                allowedRoles = Collections.singleton("ADMIN");
            }

            if (!allowedRoles.contains(userRole)) {
                // Chặn truy cập và chuyển hướng về dashboard tương ứng kèm cảnh báo
                if ("CUSTOMER".equals(userRole)) {
                    httpResponse.sendRedirect(contextPath + "/customer/dashboard?error=access_denied");
                } else {
                    httpResponse.sendRedirect(contextPath + "/admin/dashboard?error=access_denied");
                }
                return;
            }
        } else if (servletPath != null && servletPath.startsWith("/customer")) {
            if (currentUser == null) {
                httpResponse.sendRedirect(contextPath + "/login?error=auth_required&redirect=" + servletPath);
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
