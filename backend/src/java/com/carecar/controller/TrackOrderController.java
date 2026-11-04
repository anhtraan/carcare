package com.carecar.controller;

import com.carecar.dal.RepairOrderDAO;
import com.carecar.model.RepairOrder;
import com.carecar.model.User;
import com.carecar.util.RateLimiter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

@WebServlet(name = "TrackOrderController", urlPatterns = {"/track"})
public class TrackOrderController extends HttpServlet {

    private final RepairOrderDAO repairOrderDAO = new RepairOrderDAO();

    // Giới hạn tần suất tra cứu: tối đa 10 lượt request mỗi 1 phút trên mỗi IP
    // Ngăn chặn rà quét mã lệnh tuần tự CC-2026-NNNN hoặc quét biển số hàng loạt
    private static final RateLimiter RATE_LIMITER = new RateLimiter(10, 1, TimeUnit.MINUTES);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String query = request.getParameter("q");
        String phoneLast4 = request.getParameter("phoneLast4");
        if (phoneLast4 != null) {
            phoneLast4 = phoneLast4.trim();
        }

        // Nếu người dùng chưa nhập gì (vừa vào trang tra cứu)
        if (query == null || query.trim().isEmpty()) {
            request.getRequestDispatcher("/WEB-INF/views/track.jsp").forward(request, response);
            return;
        }

        query = query.trim();
        request.setAttribute("query", query);
        request.setAttribute("phoneLast4", phoneLast4);

        // 1. Kiểm tra Rate Limiting theo Client IP
        String clientIp = getClientIp(request);
        if (!RATE_LIMITER.allowRequest(clientIp)) {
            response.setStatus(429); // Too Many Requests
            request.setAttribute("rateLimitError", "Bạn đã thực hiện quá nhiều lượt tra cứu trong thời gian ngắn. Vui lòng đợi 1 phút trước khi thử lại.");
            request.getRequestDispatcher("/WEB-INF/views/track.jsp").forward(request, response);
            return;
        }

        // 2. Kiểm tra vai trò của người dùng hiện tại
        User currentUser = (User) request.getSession().getAttribute("user");
        boolean isStaff = currentUser != null && (currentUser.isAdmin() || currentUser.isMechanic() || currentUser.isReceptionist());

        // Nếu là khách thông thường / chưa đăng nhập: Bắt buộc cung cấp 4 số cuối SĐT chủ xe
        if (!isStaff) {
            // Hỗ trợ khách hàng đã đăng nhập tài khoản có SĐT khớp
            if ((phoneLast4 == null || phoneLast4.isEmpty()) && currentUser != null && currentUser.isCustomer() && currentUser.getPhone() != null) {
                String uDigits = currentUser.getPhone().replaceAll("\\D+", "");
                if (uDigits.length() >= 4) {
                    phoneLast4 = uDigits.substring(uDigits.length() - 4);
                    request.setAttribute("phoneLast4", phoneLast4);
                }
            }

            if (phoneLast4 == null || phoneLast4.length() != 4 || !phoneLast4.matches("\\d{4}")) {
                request.setAttribute("authPhoneError", "Vì lý do bảo mật thông tin chủ xe, vui lòng cung cấp chính xác 4 số cuối số điện thoại đăng ký.");
                request.getRequestDispatcher("/WEB-INF/views/track.jsp").forward(request, response);
                return;
            }
        }

        // 3. Truy vấn đơn hàng từ CSDL
        List<RepairOrder> rawResults = new ArrayList<>();
        if (query.toUpperCase().startsWith("CC-")) {
            RepairOrder singleOrder = repairOrderDAO.getOrderByCode(query);
            if (singleOrder != null) {
                rawResults.add(singleOrder);
            }
        } else {
            rawResults = repairOrderDAO.getOrdersByLicensePlate(query);
        }

        // 4. Nếu không phải nhân viên nội bộ, lọc nghiêm ngặt theo 4 số cuối SĐT
        List<RepairOrder> results = new ArrayList<>();
        if (!isStaff) {
            for (RepairOrder ro : rawResults) {
                String phone = ro.getCustomerPhone();
                if (phone != null) {
                    String digits = phone.replaceAll("\\D+", "");
                    if (digits.endsWith(phoneLast4)) {
                        results.add(ro);
                    }
                }
            }
        } else {
            results = rawResults;
        }

        request.setAttribute("searched", true);
        request.setAttribute("orders", results);
        if (results.size() == 1) {
            request.setAttribute("selectedOrder", results.get(0));
        }

        request.getRequestDispatcher("/WEB-INF/views/track.jsp").forward(request, response);
    }

    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        } else if (ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return (ip != null && !ip.isEmpty()) ? ip : "127.0.0.1";
    }
}
