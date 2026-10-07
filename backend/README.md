# CareCar - Backend API & Management System (Java Web / Jakarta EE 10)

Thư mục này chứa toàn bộ mã nguồn **Backend** phục vụ quản lý xưởng dịch vụ ô tô CareCar (Servlet, JSP, JSTL, Ant Build, Jakarta EE 10, Apache Tomcat 10).

---

## 🏗️ Cấu Trúc Thư Mục Backend

```text
backend/
├── src/java/com/carecar/   # Mã nguồn Java (Controller, DAO, Model, Filter, Utils)
│   ├── controller/         # Các Servlet điều hướng (Admin, Auth, Client, VNPay...)
│   ├── dao/                # Truy vấn dữ liệu SQL Server (JDBC PreparedStatements)
│   ├── model/              # Các Entity (User, Appointment, RepairOrder, Invoice...)
│   ├── filter/             # Bộ lọc Encoding (UTF-8) và AuthFilter
│   └── util/               # DBContext, VNPayConfig, PasswordHash, DateTag...
├── web/                    # Tài nguyên Web của Tomcat
│   ├── WEB-INF/
│   │   ├── web.xml         # Cấu hình Servlet & Session Timeout
│   │   ├── lib/            # Các thư viện Jakarta EE, JDBC, Gson, JSTL 3.0
│   │   └── tlds/           # Custom Tag Library descriptor
│   ├── admin/              # Giao diện quản trị xưởng (Dashboard, Thợ, Kho, Lệnh SC, Hóa đơn)
│   └── client/             # Các JSP render phía server
├── nbproject/              # Cấu hình dự án NetBeans 17 (Java with Ant)
├── build.xml               # Ant build script
└── README.md
```

---

## 💻 Mở & Chạy Bằng Apache NetBeans 17

1. Mở **Apache NetBeans 17**.
2. Chọn menu **File** $\rightarrow$ **Open Project...**
3. Điều hướng và chọn thư mục:
   ```text
   /Users/tqa/Documents/carcare/backend
   ```
   *(NetBeans sẽ nhận diện biểu tượng dự án Web Java Ant có hình quả địa cầu và tách cà phê).*
4. Chuột phải vào tên dự án `CareCar` $\rightarrow$ chọn **Clean and Build**.
5. Nhấn **Run** (F6) hoặc chuột phải chọn **Deploy** lên **Apache Tomcat 10.1.x**.

---

## 🗄️ Cấu Hình Cơ Sở Dữ Liệu SQL Server

Backend kết nối tới database **CareCarDB** thông qua Docker container:
- **Host**: `localhost`
- **Port**: `14333` (được ánh xạ từ 1433 của Docker)
- **User**: `sa`
- **Password**: `Bboytqa1@`

Khởi động database bằng lệnh (ở thư mục gốc):
```bash
docker compose up -d sqlserver
```

File cấu hình kết nối nằm tại:
`backend/src/java/com/carecar/util/DBContext.java`

---

## 📦 Đóng Gói (Build WAR) & Deploy Lên VPS / Cloud

### 1. Build File `.war` bằng Apache Ant
Mở terminal và chạy lệnh:
```bash
ant -f backend/build.xml dist
```
File đóng gói sẽ được tạo ra tại:
```text
backend/dist/CareCar.war
```

### 2. Deploy Lên Máy Chủ Apache Tomcat 10
1. Cài đặt **Apache Tomcat 10.1.x** (Hỗ trợ **Jakarta EE 10**) trên server Linux / VPS.
2. Sao chép file `CareCar.war` vào thư mục `webapps/` của Tomcat:
   ```bash
   cp backend/dist/CareCar.war /opt/tomcat/webapps/ROOT.war
   ```
3. Khởi động Tomcat:
   ```bash
   /opt/tomcat/bin/startup.sh
   ```
4. Truy cập hệ thống tại: `http://your-server-ip:8080/`.

---

## 🛡️ Lưu Ý Kỹ Thuật (Jakarta EE 10 Compatibility)
- Toàn bộ controller và filter sử dụng gói `jakarta.servlet.*` (thay vì `javax.servlet.*` cũ).
- Thư viện JSTL đã được chuyển đổi sang chuẩn `jakarta.servlet.jsp.jstl-3.0.1.jar`.
- Không thêm thư viện JSTL 1.2 cũ vào classpath của NetBeans để tránh xung đột `NoClassDefFoundError`.
