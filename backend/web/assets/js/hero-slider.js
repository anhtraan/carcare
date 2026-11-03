/**
 * CareCar - Hero Background Slider Engine
 * Tự động đọc danh sách ảnh từ hero-slider-config.js và trình chiếu ảnh nền ô tô
 */
(function () {
    function initHeroSlider() {
        const heroSection = document.querySelector('.hero-section, .landing-hero');
        if (!heroSection) return;

        // Lấy danh sách ảnh từ file cấu hình hero-slider-config.js
        const config = window.HERO_SLIDER_CONFIG || {
            slideInterval: 4500,
            transitionDuration: 1200,
            images: [
                'assets/images/hero-slider/slide-1.jpg',
                'assets/images/hero-slider/slide-2.jpg',
                'assets/images/hero-slider/slide-3.jpg',
                'assets/images/hero-slider/slide-4.jpg'
            ]
        };

        const images = config.images || [];
        if (!images.length) return;

        // Tự động phân giải đường dẫn ảnh (hỗ trợ cả contextPath /CareCar/ và root)
        function resolveImageUrl(url) {
            if (!url) return '';
            if (url.startsWith('http://') || url.startsWith('https://') || url.startsWith('//')) {
                return url;
            }
            let basePath = '';
            const script = document.querySelector('script[src*="hero-slider.js"]');
            if (script) {
                const src = script.getAttribute('src');
                const match = src.match(/^(.*?)assets\//);
                if (match) {
                    basePath = match[1];
                }
            }
            const cleanUrl = url.replace(/^\/+/, '');
            return basePath + cleanUrl;
        }

        // Tạo container nền nếu chưa có
        let bgContainer = heroSection.querySelector('.hero-slider-bg');
        if (!bgContainer) {
            bgContainer = document.createElement('div');
            bgContainer.className = 'hero-slider-bg';
            heroSection.prepend(bgContainer);
        } else {
            bgContainer.innerHTML = '';
        }

        // Tạo lớp phủ overlay làm tối để chữ và thẻ tra cứu nổi bật
        let overlay = heroSection.querySelector('.hero-slider-overlay');
        if (!overlay) {
            overlay = document.createElement('div');
            overlay.className = 'hero-slider-overlay';
            bgContainer.after(overlay);
        }

        // Tạo container các chấm tròn điều hướng (dots)
        let dotsContainer = heroSection.querySelector('.hero-slider-dots');
        if (!dotsContainer) {
            dotsContainer = document.createElement('div');
            dotsContainer.className = 'hero-slider-dots';
            heroSection.appendChild(dotsContainer);
        } else {
            dotsContainer.innerHTML = '';
        }

        // Khởi tạo các phần tử slide ảnh
        const slides = [];
        const dots = [];

        images.forEach((imgUrl, index) => {
            const resolvedUrl = resolveImageUrl(imgUrl);

            // Tạo slide
            const slide = document.createElement('div');
            slide.className = 'hero-slide' + (index === 0 ? ' active' : '');
            slide.style.backgroundImage = `url('${resolvedUrl}')`;
            bgContainer.appendChild(slide);
            slides.push(slide);

            // Tạo dot
            const dot = document.createElement('button');
            dot.type = 'button';
            dot.className = 'hero-dot' + (index === 0 ? ' active' : '');
            dot.setAttribute('aria-label', `Xem ảnh ${index + 1}`);
            dot.addEventListener('click', () => {
                goToSlide(index);
                restartTimer();
            });
            dotsContainer.appendChild(dot);
            dots.push(dot);

            // Preload ảnh
            const preloadImg = new Image();
            preloadImg.src = resolvedUrl;
        });

        let currentIndex = 0;
        let timer = null;

        function goToSlide(newIndex) {
            if (newIndex === currentIndex) return;

            slides[currentIndex].classList.remove('active');
            dots[currentIndex].classList.remove('active');

            currentIndex = (newIndex + slides.length) % slides.length;

            slides[currentIndex].classList.add('active');
            dots[currentIndex].classList.add('active');
        }

        function nextSlide() {
            goToSlide(currentIndex + 1);
        }

        function startTimer() {
            stopTimer();
            timer = setInterval(nextSlide, config.slideInterval || 4500);
        }

        function stopTimer() {
            if (timer) {
                clearInterval(timer);
                timer = null;
            }
        }

        function restartTimer() {
            stopTimer();
            startTimer();
        }

        // Bắt đầu chạy slider tự động
        startTimer();

        // Tạm dừng khi chuyển tab trình duyệt để tiết kiệm tài nguyên
        document.addEventListener('visibilitychange', () => {
            if (document.hidden) {
                stopTimer();
            } else {
                startTimer();
            }
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initHeroSlider);
    } else {
        initHeroSlider();
    }
})();

