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

    private static final String CSRF_SESSION_ATTR = "CARECAR_CSRF_TOKEN";
    private static final String CSRF_PARAM_NAME = "csrfToken";
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
     * Xác thực CSRF Token gửi lên từ Form POST với Token lưu trong Session
     */
    public static boolean validateToken(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }

        String sessionToken = (String) session.getAttribute(CSRF_SESSION_ATTR);
        String requestToken = request.getParameter(CSRF_PARAM_NAME);

        if (requestToken == null || requestToken.isEmpty()) {
            requestToken = request.getHeader("X-CSRF-Token");
        }

        if (sessionToken == null || requestToken == null) {
            return false;
        }

        // So sánh an toàn hằng số thời gian
        return MessageDigest.isEqual(sessionToken.getBytes(), requestToken.getBytes());
    }
}
