# CareCar - Frontend Website & Client Portal

Thư mục này chứa toàn bộ mã nguồn giao diện khách hàng (**Frontend**) độc lập của hệ thống CareCar Auto Service Center.

---

## 🚀 Cấu Trúc Thư Mục Frontend

```text
frontend/
├── index.html          # Trang chủ chính (Hero, Ưu điểm 5 sao, Quy trình, Hotline 24/7)
├── services.html       # Bảng giá dịch vụ ô tô (Lọc danh mục, tìm kiếm thời gian thực)
├── booking.html        # Đặt lịch hẹn dịch vụ trực tuyến (Form chuẩn, validation)
├── track.html          # Tra cứu tiến độ sửa chữa xe (Timeline thời gian thực)
├── login.html          # Cổng đăng nhập thành viên / quản trị
├── register.html       # Đăng ký tài khoản chủ xe
├── assets/
│   ├── css/
│   │   └── style.css   # Style giao diện CareCar
│   ├── js/
│   │   └── main.js     # Logic xử lý tương tác giao diện client-side
│   └── images/         # Hình ảnh, banner, logo gara
└── README.md
```

---

## 🌐 Hướng Dẫn Deploy Frontend Độc Lập

Frontend được xây dựng bằng **HTML5, CSS3, JavaScript ES6 và Bootstrap 5 (CDN)**, hoàn toàn tĩnh (Static Web), tải siêu tốc và có thể deploy miễn phí lên bất kỳ nền tảng nào chỉ trong 1 phút:

### 1. Deploy lên Vercel
1. Cài đặt Vercel CLI (nếu có) hoặc liên kết GitHub với [vercel.com](https://vercel.com):
2. Khi thêm Project trên Vercel:
   - **Root Directory**: Chọn `frontend`
   - **Build Command**: Để trống (No build command)
   - **Output Directory**: Để trống (hoặc `.`)
3. Nhấn **Deploy** $\rightarrow$ Bạn sẽ nhận ngay URL dạng `https://carecar-frontend.vercel.app`.

### 2. Deploy lên Netlify
1. Truy cập [netlify.com](https://app.netlify.com/drop).
2. **Kéo và thả trực tiếp thư mục `frontend/`** vào ô upload của Netlify.
3. Hoặc liên kết Git repository:
   - **Base directory**: `frontend`
   - **Publish directory**: `frontend`
4. Nhấn **Deploy Site**.

### 3. Deploy lên GitHub Pages
1. Vào GitHub Repo $\rightarrow$ **Settings** $\rightarrow$ **Pages**.
2. Tại mục **Build and deployment**:
   - Chọn Branch `main` (hoặc `master`).
   - Nếu repo chỉ chứa frontend, chọn `/ (root)`.
   - Nếu dùng chung monorepo, có thể dùng GitHub Action để deploy thư mục `frontend`.

### 4. Deploy lên Nginx / Web Server riêng
Copy toàn bộ thư mục `frontend/` vào thư mục web root của Nginx (ví dụ `/var/www/carecar`):
```nginx
server {
    listen 80;
    server_name carecar.vn www.carecar.vn;
    root /var/www/carecar;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

---

## 🛠️ Chạy Thử Trên Máy Cá Nhân (Local Development)

Bạn có thể chạy thử trực tiếp mà không cần cài đặt môi trường phức tạp:
- **Cách 1: VS Code Live Server**: Mở folder `frontend` bằng VS Code, click chuột phải vào `index.html` $\rightarrow$ chọn **Open with Live Server**.
- **Cách 2: Python HTTP Server**:
  ```bash
  cd frontend
  python3 -m http.server 3000
  ```
  Sau đó mở trình duyệt truy cập: `http://localhost:3000`.
- **Cách 3: Node.js `serve` / `http-server`**:
  ```bash
  npx serve frontend
  ```
