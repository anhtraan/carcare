package com.carecar.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.KeySpec;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

/**
 * PasswordUtil - Hệ thống mã hóa mật khẩu cấp cao chuẩn bảo mật OWASP.
 * Áp dụng PBKDF2 (Password-Based Key Derivation Function 2) với HMAC-SHA256,
 * Salt ngẫu nhiên 128-bit và 10,000 vòng lặp.
 * 
 * Hỗ trợ tương thích ngược (Backward Compatibility) với mã băm SHA-256 cũ.
 */
public class PasswordUtil {

    private static final String ALGORITHM = "PBKDF2WithHmacSHA256";
    private static final int ITERATIONS = 10000;
    private static final int KEY_LENGTH = 256; // 256 bits
    private static final int SALT_LENGTH = 16; // 16 bytes = 128 bits
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    /**
     * Mã hóa mật khẩu cấp cao bằng PBKDF2 + SecureRandom Salt
     * Kết quả có định dạng: PBKDF2$10000$<salt_hex>$<hash_hex>
     */
    public static String hashPassword(String rawPassword) {
        if (rawPassword == null || rawPassword.isEmpty()) {
            return null;
        }

        try {
            byte[] salt = new byte[SALT_LENGTH];
            SECURE_RANDOM.nextBytes(salt);

            KeySpec spec = new PBEKeySpec(rawPassword.toCharArray(), salt, ITERATIONS, KEY_LENGTH);
            SecretKeyFactory factory = SecretKeyFactory.getInstance(ALGORITHM);
            byte[] hash = factory.generateSecret(spec).getEncoded();

            return String.format("PBKDF2$%d$%s$%s", ITERATIONS, toHex(salt), toHex(hash));
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            // Fallback an toàn sang SHA-256 nếu hệ điều hành không hỗ trợ PBKDF2
            return legacySha256(rawPassword);
        }
    }

    /**
     * Xác thực mật khẩu người dùng nhập vào.
     * Sử dụng MessageDigest.isEqual để chống tấn công phân tích thời gian thực thi (Timing Attack).
     */
    public static boolean checkPassword(String rawPassword, String storedHash) {
        if (rawPassword == null || storedHash == null || storedHash.isEmpty()) {
            return false;
        }

        // Trường hợp 1: Mật khẩu được mã hóa chuẩn PBKDF2 mới
        if (storedHash.startsWith("PBKDF2$")) {
            String[] parts = storedHash.split("\\$");
            if (parts.length != 4) {
                return false;
            }

            try {
                int iterations = Integer.parseInt(parts[1]);
                byte[] salt = fromHex(parts[2]);
                byte[] expectedHash = fromHex(parts[3]);

                KeySpec spec = new PBEKeySpec(rawPassword.toCharArray(), salt, iterations, expectedHash.length * 8);
                SecretKeyFactory factory = SecretKeyFactory.getInstance(ALGORITHM);
                byte[] actualHash = factory.generateSecret(spec).getEncoded();

                return MessageDigest.isEqual(expectedHash, actualHash);
            } catch (Exception e) {
                return false;
            }
        }

        // Trường hợp 2: Mật khẩu cũ mã hóa dạng SHA-256 (Tương thích dữ liệu mẫu khởi tạo)
        String legacyHash = legacySha256(rawPassword);
        return legacyHash != null && MessageDigest.isEqual(legacyHash.getBytes(StandardCharsets.UTF_8),
                storedHash.toLowerCase().getBytes(StandardCharsets.UTF_8));
    }

    /**
     * Kiểm tra xem mật khẩu có đang dùng thuật toán cũ cần nâng cấp lên PBKDF2 hay không
     */
    public static boolean needsUpgrade(String storedHash) {
        return storedHash != null && !storedHash.startsWith("PBKDF2$");
    }

    private static String legacySha256(String rawPassword) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] encodedhash = digest.digest(rawPassword.getBytes(StandardCharsets.UTF_8));
            return toHex(encodedhash);
        } catch (NoSuchAlgorithmException e) {
            return null;
        }
    }

    private static String toHex(byte[] array) {
        StringBuilder sb = new StringBuilder(array.length * 2);
        for (byte b : array) {
            sb.append(String.format("%02x", b & 0xff));
        }
        return sb.toString();
    }

    private static byte[] fromHex(String hex) {
        int len = hex.length();
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            data[i / 2] = (byte) ((Character.digit(hex.charAt(i), 16) << 4)
                    + Character.digit(hex.charAt(i + 1), 16));
        }
        return data;
    }

    public static void main(String[] args) {
        String rawPass = "123456";
        String pbkdf2Hash = hashPassword(rawPass);
        boolean verifySuccess = checkPassword(rawPass, pbkdf2Hash);
        boolean verifyWrong = checkPassword("wrong_pass", pbkdf2Hash);
        boolean verifyLegacy = checkPassword("123456", "8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92");

        System.out.println("=== THỬ NGHIỆM MÃ HÓA MẬT KHẨU CẤP CAO PBKDF2-HMAC-SHA256 ===");
        System.out.println("1. Mật khẩu gốc: " + rawPass);
        System.out.println("2. Mã băm PBKDF2 (10,000 vòng lặp + 128-bit Salt): " + pbkdf2Hash);
        System.out.println("3. Xác thực đúng mật khẩu: " + (verifySuccess ? "✅ ĐÚNG" : "❌ SAI"));
        System.out.println("4. Xác thực sai mật khẩu: " + (!verifyWrong ? "✅ ĐÃ CHẶN" : "❌ LỖI"));
        System.out.println("5. Tương thích ngược hash cũ (SHA-256): " + (verifyLegacy ? "✅ TƯƠNG THÍCH" : "❌ LỖI"));
    }
}
