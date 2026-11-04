package com.carecar.filter;

import com.carecar.util.CSRFTokenUtil;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletResponseWrapper;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * CsrfFilter - Kiểm tra CSRF Token cho mọi yêu cầu POST / thay đổi trạng thái
 * Đồng thời tự động thiết lập Content-Security-Policy (CSP), các Security Headers chống XSS
 * và thuộc tính SameSite=Lax cho các cookie phản hồi.
 */
@WebFilter(filterName = "CsrfFilter", urlPatterns = {"/*"})
public class CsrfFilter implements Filter {

    private static final Logger LOGGER = Logger.getLogger(CsrfFilter.class.getName());

    // Các đường dẫn ngoại lệ không bắt buộc CSRF token (ví dụ: webhook IPN bên thứ ba từ cổng thanh toán)
    private static final Set<String> EXCLUDED_EXACT_PATHS = Set.of(
            "/payment/vnpay-return"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // 1. Thiết lập Security Headers chống XSS, Clickjacking, MIME-sniffing
        httpResponse.setHeader("Content-Security-Policy",
                "default-src 'self'; "
                + "script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com; "
                + "style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com https://fonts.googleapis.com; "
                + "font-src 'self' https://cdnjs.cloudflare.com https://fonts.gstatic.com data:; "
                + "img-src 'self' data: https:; "
                + "connect-src 'self'; "
                + "frame-ancestors 'self'; "
                + "base-uri 'self'; "
                + "form-action 'self';");
        httpResponse.setHeader("X-Content-Type-Options", "nosniff");
        httpResponse.setHeader("X-Frame-Options", "SAMEORIGIN");
        httpResponse.setHeader("X-XSS-Protection", "1; mode=block");
        httpResponse.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");

        String uri = httpRequest.getRequestURI();

        // 2. Bỏ qua tài nguyên tĩnh (css, js, ảnh, fonts...)
        if (uri.matches(".*\\.(css|js|png|jpg|jpeg|gif|svg|ico|woff|woff2|ttf|eot)$")) {
            chain.doFilter(request, response);
            return;
        }

        // 3. Luôn đảm bảo CSRF token được sinh và lưu trong Session, đồng thời gán vào request attribute
        HttpSession session = httpRequest.getSession(true);
        String token = CSRFTokenUtil.getToken(session);
        httpRequest.setAttribute(CSRFTokenUtil.CSRF_PARAM_NAME, token);
        httpRequest.setAttribute("csrfToken", token);

        // 4. Thiết lập ResponseWrapper để tự động gán SameSite=Lax cho mọi cookie
        SameSiteResponseWrapper wrappedResponse = new SameSiteResponseWrapper(httpResponse);

        // 5. Kiểm tra CSRF cho mọi phương thức thay đổi trạng thái (POST, PUT, DELETE)
        String method = httpRequest.getMethod().toUpperCase();
        if ("POST".equals(method) || "PUT".equals(method) || "DELETE".equals(method)) {
            String servletPath = httpRequest.getServletPath();
            if (servletPath == null || servletPath.isEmpty()) {
                servletPath = httpRequest.getPathInfo();
            }

            if (servletPath != null && !EXCLUDED_EXACT_PATHS.contains(servletPath)) {
                if (!CSRFTokenUtil.validateToken(httpRequest)) {
                    LOGGER.log(Level.WARNING, "CSRF validation failed for {0} [{1}] from IP {2}",
                            new Object[]{servletPath, method, httpRequest.getRemoteAddr()});

                    // Phản hồi lỗi 403 Forbidden nếu CSRF token không hợp lệ hoặc thiếu
                    httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                            "Yêu cầu bị từ chối: CSRF Token không hợp lệ hoặc đã hết hạn. Vui lòng tải lại trang và thử lại!");
                    return;
                }
            }
        }

        chain.doFilter(request, wrappedResponse);
    }

    @Override
    public void destroy() {
    }

    /**
     * Response wrapper đảm bảo mọi Set-Cookie gửi về Client đều có thuộc tính SameSite=Lax
     */
    public static class SameSiteResponseWrapper extends HttpServletResponseWrapper {

        public SameSiteResponseWrapper(HttpServletResponse response) {
            super(response);
        }

        @Override
        public void addCookie(Cookie cookie) {
            if (cookie != null) {
                try {
                    // Servlet 6.0 hỗ trợ setAttribute("SameSite", "Lax")
                    cookie.setAttribute("SameSite", "Lax");
                } catch (Throwable ignored) {
                }
            }
            super.addCookie(cookie);
        }

        @Override
        public void addHeader(String name, String value) {
            if ("Set-Cookie".equalsIgnoreCase(name) && value != null && !value.toLowerCase().contains("samesite")) {
                value = value + "; SameSite=Lax";
            }
            super.addHeader(name, value);
        }

        @Override
        public void setHeader(String name, String value) {
            if ("Set-Cookie".equalsIgnoreCase(name) && value != null && !value.toLowerCase().contains("samesite")) {
                value = value + "; SameSite=Lax";
            }
            super.setHeader(name, value);
        }
    }
}
