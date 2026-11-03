/**
 * ==============================================================================
 * CARECAR - FILE CẤU HÌNH DANH SÁCH ẢNH NỀN HERO (SLIDER TỰ ĐỘNG)
 * ==============================================================================
 * Bạn có thể tự do thêm, bớt hoặc thay đổi các ảnh ô tô / sửa xe chạy đằng sau.
 * 
 * CÁCH THÊM ẢNH:
 * - Cách 1 (Ảnh nội bộ): Chép file ảnh của bạn vào thư mục 'assets/images/hero-slider/'
 *   rồi thêm đường dẫn vào mảng bên dưới, ví dụ: 'assets/images/hero-slider/anh-moi.jpg'
 * - Cách 2 (Link online): Dán trực tiếp link ảnh trên mạng (https://...) vào mảng bên dưới.
 * ==============================================================================
 */
window.HERO_SLIDER_CONFIG = {
    // Thời gian hiển thị mỗi ảnh (tính bằng mili-giây, ví dụ 4500 = 4.5 giây)
    slideInterval: 4500,

    // Tốc độ hiệu ứng chuyển đổi mờ dần (mili-giây)
    transitionDuration: 1200,

    // DANH SÁCH ẢNH NỀN XE Ô TÔ & SỬA XE:
    images: [
        // Ảnh 1: Kỹ thuật viên bảo dưỡng & sửa chữa khoang máy động cơ
        'assets/images/hero-slider/slide-1.jpg',

        // Ảnh 2: Không gian xưởng garage hiện đại tiêu chuẩn cao
        'assets/images/hero-slider/slide-2.jpg',

        // Ảnh 3: Kỹ thuật viên kiểm tra hệ thống phanh và gầm xe
        'assets/images/hero-slider/slide-3.jpg',

        // Ảnh 4: Chẩn đoán & đo đạc thiết bị điện tử ô tô
        'assets/images/hero-slider/slide-4.jpg'
    ]
};

