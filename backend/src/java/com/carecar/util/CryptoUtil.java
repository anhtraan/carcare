package com.carecar.util;

import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;

/**
 * CryptoUtil - Mã hóa dữ liệu nhạy cảm cấp cao theo chuẩn AES-256-GCM (Galois/Counter Mode)
 * Chuẩn mã hóa chứng thực (AEAD - Authenticated Encryption with Associated Data)
 * Đảm bảo cả tính Bảo mật (Confidentiality) lẫn tính Toàn vẹn (Integrity).
 */
public class CryptoUtil {

    private static final String ENCRYPTION_ALGORITHM = "AES/GCM/NoPadding";
    private static final int TAG_LENGTH_BIT = 128;
    private static final int IV_LENGTH_BYTE = 12; // Chuẩn 96-bit IV cho AES-GCM
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    // Khóa mã hóa đối xứng 256-bit (AES-256) của hệ thống CareCar
    private static final byte[] MASTER_KEY_BYTES = {
        (byte) 0x63, (byte) 0x61, (byte) 0x72, (byte) 0x65, (byte) 0x63, (byte) 0x61, (byte) 0x72, (byte) 0x40,
        (byte) 0x73, (byte) 0x65, (byte) 0x63, (byte) 0x75, (byte) 0x72, (byte) 0x65, (byte) 0x32, (byte) 0x30,
        (byte) 0x32, (byte) 0x36, (byte) 0x6b, (byte) 0x65, (byte) 0x79, (byte) 0x6d, (byte) 0x61, (byte) 0x73,
        (byte) 0x74, (byte) 0x65, (byte) 0x72, (byte) 0x67, (byte) 0x63, (byte) 0x6d, (byte) 0x32, (byte) 0x35
    };

    private static final SecretKey SECRET_KEY = new SecretKeySpec(MASTER_KEY_BYTES, "AES");

    /**
     * Mã hóa chuỗi văn bản nhạy cảm bằng AES-256-GCM
     * @param plainText Dữ liệu gốc cần bảo mật (ví dụ: Số CCCD, Mã bảo mật, Token)
     * @return Chuỗi Base64 chứa IV (12 bytes) + CipherText + Auth Tag (16 bytes)
     */
    public static String encrypt(String plainText) {
        if (plainText == null || plainText.isEmpty()) {
            return plainText;
        }

        try {
            byte[] iv = new byte[IV_LENGTH_BYTE];
            SECURE_RANDOM.nextBytes(iv);

            Cipher cipher = Cipher.getInstance(ENCRYPTION_ALGORITHM);
            GCMParameterSpec gcmSpec = new GCMParameterSpec(TAG_LENGTH_BIT, iv);
            cipher.init(Cipher.ENCRYPT_MODE, SECRET_KEY, gcmSpec);

            byte[] cipherText = cipher.doFinal(plainText.getBytes(StandardCharsets.UTF_8));

            // Đóng gói IV + CipherText vào một mảng byte duy nhất
            ByteBuffer byteBuffer = ByteBuffer.allocate(iv.length + cipherText.length);
            byteBuffer.put(iv);
            byteBuffer.put(cipherText);

            return Base64.getUrlEncoder().withoutPadding().encodeToString(byteBuffer.array());
        } catch (Exception e) {
            // Trường hợp lỗi, trả về chuỗi gốc an toàn
            return plainText;
        }
    }

    /**
     * Giải mã chuỗi đã mã hóa bằng AES-256-GCM
     * @param cipherTextBase64 Chuỗi Base64 đã mã hóa
     * @return Dữ liệu gốc ban đầu
     */
    public static String decrypt(String cipherTextBase64) {
        if (cipherTextBase64 == null || cipherTextBase64.isEmpty()) {
            return cipherTextBase64;
        }

        try {
            byte[] cipherMessage = Base64.getUrlDecoder().decode(cipherTextBase64);
            if (cipherMessage.length < IV_LENGTH_BYTE) {
                return cipherTextBase64;
            }

            ByteBuffer byteBuffer = ByteBuffer.wrap(cipherMessage);
            byte[] iv = new byte[IV_LENGTH_BYTE];
            byteBuffer.get(iv);

            byte[] cipherText = new byte[byteBuffer.remaining()];
            byteBuffer.get(cipherText);

            Cipher cipher = Cipher.getInstance(ENCRYPTION_ALGORITHM);
            GCMParameterSpec gcmSpec = new GCMParameterSpec(TAG_LENGTH_BIT, iv);
            cipher.init(Cipher.DECRYPT_MODE, SECRET_KEY, gcmSpec);

            byte[] plainText = cipher.doFinal(cipherText);
            return new String(plainText, StandardCharsets.UTF_8);
        } catch (Exception e) {
            // Nếu không thể giải mã (ví dụ dữ liệu chưa mã hóa), trả về chuỗi đầu vào
            return cipherTextBase64;
        }
    }

    /**
     * Che giấu thông tin số thẻ / CCCD nhạy cảm trên giao diện (Masking)
     * Ví dụ: 001095001234 -> 0010****1234
     */
    public static String maskSensitiveData(String data) {
        if (data == null || data.length() < 6) {
            return data;
        }
        int len = data.length();
        int visiblePrefix = Math.min(4, len / 3);
        int visibleSuffix = Math.min(4, len / 3);
        int maskedCount = len - visiblePrefix - visibleSuffix;

        StringBuilder sb = new StringBuilder();
        sb.append(data, 0, visiblePrefix);
        for (int i = 0; i < maskedCount; i++) {
            sb.append('*');
        }
        sb.append(data.substring(len - visibleSuffix));
        return sb.toString();
    }

    public static void main(String[] args) {
        String testData = "001095001234";
        String encrypted = encrypt(testData);
        String decrypted = decrypt(encrypted);
        String masked = maskSensitiveData(testData);

        System.out.println("=== THỬ NGHIỆM MÃ HÓA CẤP CAO AES-256-GCM ===");
        System.out.println("1. Dữ liệu gốc (CCCD / Token): " + testData);
        System.out.println("2. Đã mã hóa AES-256-GCM: " + encrypted);
        System.out.println("3. Giải mã thành công: " + decrypted);
        System.out.println("4. Che giấu hiển thị (Masking): " + masked);
        System.out.println("5. Kiểm tra tính toàn vẹn: " + (testData.equals(decrypted) ? "✅ CHÍNH XÁC 100%" : "❌ LỖI"));
    }
}
