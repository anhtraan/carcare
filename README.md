# CareCar - Hệ Thống Quản Lý Dịch Vụ Ô Tô & Cổng Thông Tin Khách Hàng

CareCar là giải pháp phần mềm toàn diện cho trung tâm dịch vụ ô tô, bao gồm cổng thông tin khách hàng đặt lịch & tra cứu tiến độ trực tuyến, cùng hệ thống điều hành xưởng sửa chữa (tiếp nhận xe, phân công kỹ thuật viên, quản lý kho phụ tùng, xuất hóa đơn và thanh toán VNPay).

Toàn bộ ứng dụng được xây dựng tập trung trên nền tảng **Java Web (Jakarta EE 10 / JSP & Servlets)** trong thư mục `backend/`, kết nối trực tiếp cơ sở dữ liệu **Microsoft SQL Server 2019**.

---

## 🏛️ Cấu Trúc Dự Án

```text
carcare/
├── backend/                # Toàn bộ ứng dụng web (Jakarta EE 10 / Tomcat 10)
│   ├── src/java/           # Controller (Servlets), DAO, Model, Filter, Utilities
│   ├── web/                # Giao diện JSP (Trang chủ, Dịch vụ, Tra cứu, Admin, Thợ, Kho)
│   │   ├── WEB-INF/views/  # JSP Views được bảo vệ và module hóa (header, footer, v.v.)
│   │   └── assets/         # CSS3, Vanilla JS, Hình ảnh, Slider, Favicon
│   ├── nbproject/          # Cấu hình dự án Apache NetBeans 17
│   ├── build.xml           # Ant Build Script
│   └── README.md           # Hướng dẫn build WAR & deploy Tomcat 10
│
├── database/               # Script khởi tạo CSDL & dữ liệu mẫu SQL Server
├── docker-compose.yml      # Dịch vụ cơ sở dữ liệu SQL Server 2019 (Port 14333)
└── README.md               # Tài liệu tổng quan dự án
```

---

## 🚀 Hướng Dẫn Chạy Dự Án (Local Development)

### Bước 1: Khởi động SQL Server 2019 qua Docker
```bash
docker compose up -d sqlserver
```
- Host: `localhost,14333`
- Database: `CareCarDB`
- User: `sa` | Password: `CareCarPassword123!`

### Bước 2: Chạy Backend trên Tomcat 10
- **Cách 1: Chạy bằng Apache NetBeans 17**
  1. Mở NetBeans 17 $\rightarrow$ **File** $\rightarrow$ **Open Project...**
  2. Chọn thư mục `backend/`
  3. Chuột phải vào project `CareCar` $\rightarrow$ chọn **Run** (chạy trên Tomcat 10.1.17).

- **Cách 2: Build file WAR bằng Ant**
  ```bash
  ant -f backend/build.xml dist
  ```
  File `.war` được sinh ra tại: `backend/dist/CareCar.war`. Triển khai bằng cách copy vào thư mục `webapps/` của Apache Tomcat 10.

### Bước 3: Truy Cập Ứng Dụng
- **Trang chủ Khách hàng**: `http://localhost:8080/CareCar/home`
- **Bảng giá Dịch vụ**: `http://localhost:8080/CareCar/services`
- **Tra cứu Tiến độ sửa xe**: `http://localhost:8080/CareCar/track`
- **Cổng Quản trị / Nhân viên**: `http://localhost:8080/CareCar/login`
  - Quản trị viên: `admin` / `123456`
  - Cố vấn dịch vụ: `advisor` / `123456`
  - Kỹ thuật viên: `mechanic` / `123456`
  - Thủ kho: `inventory` / `123456`

---

## 👥 Ngăn Xếp Công Nghệ (Tech Stack)
- **Frontend / View**: HTML5, CSS3, Vanilla JavaScript, Bootstrap 5.3, Font Awesome 6.
- **Backend**: Java 17+, Jakarta EE 10 (Servlets, JSP, JSTL), Apache Tomcat 10.1.17, Apache Ant, JDBC.
- **Cơ sở dữ liệu**: Microsoft SQL Server 2019 (chạy qua Docker).
