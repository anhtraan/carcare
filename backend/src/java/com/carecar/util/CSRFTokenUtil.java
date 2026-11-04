package com.carecar.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * CSRFTokenUtil - Chống tấn công giả mạo yêu cầu từ trang web khác (Cross-Site Request Forgery)
 * Sinh và xác thực CSRF Token ngẫu nhiên 256-bit trong HTTP Session.
 */
public class CSRFTokenUtil {

    public static final String CSRF_SESSION_ATTR = "CARECAR_CSRF_TOKEN";
    public static final String CSRF_PARAM_NAME = "csrfToken";
    public static final String CSRF_HEADER_NAME = "X-CSRF-Token";
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    /**
     * Lấy hoặc sinh mới CSRF Token lưu trong Session
     */
    public static String getToken(HttpSession session) {
        if (session == null) {
            return "";
        }
        String token = (String) session.getAttribute(CSRF_SESSION_ATTR);
        if (token == null || token.isEmpty()) {
            byte[] randomBytes = new byte[32]; // 256 bits
            SECURE_RANDOM.nextBytes(randomBytes);
            token = Base64.getUrlEncoder().withoutPadding().encodeToString(randomBytes);
            session.setAttribute(CSRF_SESSION_ATTR, token);
        }
        return token;
    }

    /**
     * Lấy token trực tiếp từ request (tự động tạo session nếu chưa có)
     */
    public static String getToken(HttpServletRequest request) {
        if (request == null) {
            return "";
        }
        HttpSession session = request.getSession(true);
        return getToken(session);
    }

    /**
     * Xác thực CSRF Token gửi lên từ Form POST với Token lưu trong Session
     */
    public static boolean validateToken(HttpServletRequest request) {
        if (request == null) {
            return false;
        }

        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }

        String sessionToken = (String) session.getAttribute(CSRF_SESSION_ATTR);
        String requestToken = request.getParameter(CSRF_PARAM_NAME);

        if (requestToken == null || requestToken.isEmpty()) {
            requestToken = request.getHeader(CSRF_HEADER_NAME);
        }

        if (sessionToken == null || sessionToken.isEmpty() || requestToken == null || requestToken.isEmpty()) {
            return false;
        }

        // So sánh an toàn hằng số thời gian
        return MessageDigest.isEqual(sessionToken.getBytes(), requestToken.getBytes());
    }
}
