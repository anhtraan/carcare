# CareCar - Hệ Thống Quản Lý Dịch Vụ Ô Tô & Cổng Thông Tin Khách Hàng

CareCar là giải pháp phần mềm toàn diện cho trung tâm dịch vụ ô tô, bao gồm cổng thông tin khách hàng đặt lịch & tra cứu tiến độ trực tuyến, cùng hệ thống điều hành xưởng sửa chữa (tiếp nhận xe, phân công kỹ thuật viên, quản lý kho phụ tùng, xuất hóa đơn và thanh toán VNPay).

Dự án đã được phân tách thành hai phần độc lập: **Frontend** và **Backend** để thuận tiện phát triển và triển khai (deploy).

---

## 🏛️ Kiến Trúc Hệ Thống

```text
carcare/
├── frontend/               # Giao diện khách hàng (Client Website & Tra cứu)
│   ├── index.html          # Trang chủ giới thiệu gara & hotline
│   ├── services.html       # Bảng giá dịch vụ công khai & tìm kiếm
│   ├── booking.html        # Đặt lịch hẹn sửa chữa online
│   ├── track.html          # Tra cứu tiến độ xe đang sửa chữa
│   ├── login.html          # Đăng nhập thành viên / quản lý
│   ├── register.html       # Đăng ký tài khoản chủ xe
│   ├── assets/             # CSS, JS, hình ảnh
│   └── README.md           # Hướng dẫn deploy Frontend lên Vercel/Netlify
│
├── backend/                # Hệ thống điều hành & API (Java Web / Jakarta EE 10)
│   ├── src/java/           # Controller, DAO, Model, Filter, Utilities
│   ├── web/                # JSP Views (Admin Dashboard, Thợ, Kho, Lệnh SC)
│   ├── nbproject/          # Cấu hình dự án Apache NetBeans 17
│   ├── build.xml           # Ant Build Script
│   └── README.md           # Hướng dẫn build WAR & deploy Tomcat 10
│
├── docker-compose.yml      # Dịch vụ cơ sở dữ liệu SQL Server (Port 14333)
└── README.md               # Tài liệu tổng quan dự án
```

---

## 🚀 Hướng Dẫn Deploy Riêng Biệt

### 1. Triển Khai Frontend (Deploy to Vercel / Netlify / GitHub Pages)
Frontend là ứng dụng web tĩnh tốc độ cao, không phụ thuộc server nặng:
- **Nền tảng khuyến nghị**: [Vercel](https://vercel.com) hoặc [Netlify](https://netlify.com)
- **Cách deploy**:
  - Chọn thư mục gốc (Root Directory): `frontend`
  - Build command: *Để trống*
  - Output directory: `.`
  - Hoặc kéo thả trực tiếp thư mục `frontend/` vào Netlify Drop.
- Chi tiết xem tại [frontend/README.md](frontend/README.md).

### 2. Triển Khai Backend (Deploy to Tomcat 10 Server / VPS)
Backend là ứng dụng Jakarta EE 10 chạy trên Apache Tomcat 10.1.x kết nối SQL Server:
- **Build file WAR**:
  ```bash
  ant -f backend/build.xml dist
  ```
  File `.war` được sinh ra tại: `backend/dist/CareCar.war`.
- **Deploy**: Copy `CareCar.war` vào thư mục `webapps/` của Apache Tomcat 10 trên server.
- Chi tiết xem tại [backend/README.md](backend/README.md).

---

## 💻 Hướng Dẫn Chạy Môi Trường Phát Triển (Local)

### Bước 1: Khởi động SQL Server qua Docker
```bash
docker compose up -d sqlserver
```

### Bước 2: Chạy Backend trên NetBeans 17
1. Mở NetBeans 17 $\rightarrow$ **File** $\rightarrow$ **Open Project...**
2. Chọn thư mục `backend/`
3. Chuột phải vào project `CareCar` $\rightarrow$ chọn **Run** (chạy trên Tomcat 10.1.17).

### Bước 3: Xem Frontend
Mở bất kỳ file nào trong thư mục `frontend/` (ví dụ `frontend/index.html`) trực tiếp trên trình duyệt hoặc chạy bằng Live Server / Python server:
```bash
cd frontend && python3 -m http.server 3000
```

---

## 👥 Đóng Góp & Phát Triển
- **Công nghệ Frontend**: HTML5, CSS3, JavaScript ES6, Bootstrap 5.3, Font Awesome 6.
- **Công nghệ Backend**: Java 17+, Jakarta EE 10, Apache Tomcat 10.1.17, Apache Ant, JDBC, SQL Server 2022.
