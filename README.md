# CareCar - Hệ Thống Quản Lý Gara & Đặt Lịch Sửa Chữa Ô Tô Trực Tuyến

Dự án Java Web hoàn chỉnh được xây dựng trên nền tảng **Jakarta EE (Servlet 5.0/6.0, JSP, JSTL)**, kiến trúc **MVC + DAO**, sử dụng cơ sở dữ liệu **Microsoft SQL Server 2019 / 2022**, xây dựng theo chuẩn **Java with Ant** sẵn sàng mở và chạy ngay trên **NetBeans IDE 17**.

---

## 🚀 Tính Năng Chính Của Hệ Thống

### 1. Phân Hệ Dành Cho Khách Hàng (Public & Customer Portal)
- **Trang chủ & Giới thiệu dịch vụ**: Giới thiệu công nghệ chẩn đoán xe, dịch vụ tiêu biểu, bảng giá tiền công minh bạch.
- **Đặt lịch hẹn online (Online Booking)**: Khách hàng chọn ngày, khung giờ, dịch vụ bảo dưỡng/sửa chữa và nhập thông tin xe.
- **Tra cứu tiến độ sửa chữa xe trực quan (Live Repair Tracking)**: Nhập Biển số xe hoặc Mã lệnh (`CC-2026-xxxx`) để theo dõi thanh tiến trình 5 bước (Tiếp nhận -> Báo giá -> Đang sửa -> Sửa xong -> Giao xe) cùng chi tiết phụ tùng & tiền công.
- **Cổng thông tin chủ xe (Customer Dashboard)**: Quản lý danh sách xe sở hữu, thêm xe mới, xem lịch sử bảo dưỡng và các hóa đơn đã thanh toán.

### 2. Phân Hệ Quản Trị & Vận Hành Xưởng (Admin & Workshop Portal)
- **Bảng điều khiển (Dashboard)**: Thống kê doanh thu ngày/tháng, số lịch hẹn hôm nay, số xe đang sửa, cảnh báo phụ tùng sắp hết trong kho.
- **Quản lý lịch hẹn (Appointments)**: Xem, duyệt, hủy và **chuyển đổi lịch hẹn thành Lệnh sửa chữa (Work Order)** chỉ với 1 click.
- **Quy trình Lệnh sửa chữa (Work Order Management)**:
  - Tiếp nhận xe vào xưởng (chọn xe cũ hoặc đăng ký xe mới tại chỗ).
  - Cập nhật chẩn đoán kỹ thuật, kết luận của thợ máy, phân công kỹ thuật viên.
  - Thêm / bớt hạng mục tiền công dịch vụ.
  - Xuất phụ tùng thay thế từ kho (hệ thống tự động trừ tồn kho và hoàn trả nếu xóa).
  - Tự động tính toán tổng tiền, chiết khấu giảm giá và thuế VAT.
- **Quyết toán & Hóa đơn (Invoices & Billing)**: Quyết toán đơn hàng, thanh toán qua Tiền mặt/Chuyển khoản QR, **in hóa đơn thanh toán chuẩn xưởng (Print-ready)** có đầy đủ chữ ký 3 bên.
- **Quản lý kho phụ tùng (Spare Parts)**: Quản lý giá nhập, giá bán lẻ, vị trí kệ kho, cảnh báo tự động khi tồn kho dưới ngưỡng an toàn, nhập thêm hàng.
- **Bảng giá dịch vụ (Services)**: Quản lý danh mục dịch vụ, thời gian ước tính và tiền công niêm yết.
- **Quản lý khách hàng & Phương tiện (Customers & Cars)**: Danh bạ chủ xe và lịch sử các xe đang sửa.
- **Quản lý nhân viên (Staff)**: Phân quyền Admin, Kỹ thuật viên (Thợ máy), Cố vấn dịch vụ.

---

## 🛠️ Cấu Trúc Thư Mục Dự Án (NetBeans Ant)

```text
CareCar/
├── database/
│   └── CareCar_DB.sql                # Script tạo Database & Dữ liệu mẫu SQL Server 2019
├── nbproject/                        # Cấu hình dự án NetBeans Ant (Java 17 + Tomcat 10)
│   ├── project.properties
│   └── project.xml
├── src/java/com/carecar/
│   ├── model/                        # Entity / DTO (User, Customer, Car, RepairOrder, SparePart...)
│   ├── dal/                          # Data Access Layer & DBContext kết nối SQL Server 2019
│   ├── controller/                   # Jakarta Servlets xử lý nghiệp vụ
│   ├── filter/                       # UTF-8 Encoding & Phân quyền truy cập (AuthFilter)
│   └── util/                         # Format tiền VND, ngày tháng, mã hóa mật khẩu SHA-256
├── web/
│   ├── assets/
│   │   ├── css/style.css             # Giao diện sang trọng, responsive, in ấn hóa đơn
│   │   └── js/main.js
│   └── WEB-INF/
│       ├── lib/                      # Các thư viện Jar (mssql-jdbc, jakarta-servlet, jstl)
│       ├── web.xml                   # Cấu hình Servlet 5.0/6.0
│       └── views/                    # Toàn bộ giao diện JSP
│           ├── includes/             # Header, Footer, Admin Sidebar
│           ├── admin/                # Giao diện quản trị xưởng & Work Orders
│           ├── customer/             # Giao diện chủ xe
│           └── error/                # Trang báo lỗi 404, 500
```

---

## 🔑 Tài Khoản Mẫu Chạy Thử (Mật khẩu: `123456`)

| Quyền hạn | Tên đăng nhập | Số điện thoại | Mật khẩu | Chức năng |
| :--- | :--- | :--- | :--- | :--- |
| **Quản trị viên (Admin)** | `admin` | `0901234567` | `123456` | Toàn quyền quản trị Gara, doanh thu, nhân sự |
| **Kỹ thuật viên (Thợ máy)** | `mechanic1` | `0912345678` | `123456` | Nhận xe, chẩn đoán, xuất phụ tùng, sửa chữa |
| **Cố vấn dịch vụ (Lễ tân)** | `receptionist` | `0934567890` | `123456` | Tiếp nhận xe, đặt lịch, xuất hóa đơn |
| **Chủ xe (Khách hàng)** | `customer1` | `0988776655` | `123456` | Xem xe của mình, đặt lịch, theo dõi tiến độ |

---

## 📖 Hướng Dẫn Cài Đặt & Chạy Trên NetBeans IDE 17

### Bước 1: Khởi tạo Cơ Sở Dữ Liệu SQL Server 2019
1. Mở **SQL Server Management Studio (SSMS)** hoặc **Azure Data Studio**.
2. Mở file [database/CareCar_DB.sql](file:///d:/CareCar/database/CareCar_DB.sql).
3. Nhấn **Execute (F5)** để khởi tạo Database `CareCarDB` cùng bảng và toàn bộ dữ liệu mẫu.

### Bước 2: Cấu hình tài khoản kết nối Database trong code
Mở file [DBContext.java](file:///d:/CareCar/src/java/com/carecar/dal/DBContext.java) và kiểm tra thông tin:
```java
private static final String SERVER_NAME = "localhost";
private static final String PORT_NUMBER = "1433";
private static final String DATABASE_NAME = "CareCarDB";
private static final String USERNAME = "sa";
private static final String PASSWORD = "sa"; // <-- Điền mật khẩu sa của bạn
```
*(Bạn có thể click chuột phải vào file `DBContext.java` trong NetBeans -> chọn **Run File** để kiểm tra kết nối có báo thành công hay không).*

### Bước 3: Mở Dự Án Trên NetBeans IDE 17
1. Mở **NetBeans IDE 17**.
2. Chọn **File** -> **Open Project...** -> Trỏ tới thư mục `d:\CareCar`.
3. NetBeans sẽ nhận diện đây là **Java Web Application with Ant**.

### Bước 4: Chạy Ứng Dụng (Run Project)
1. Đảm bảo bạn đã thêm Server **Apache Tomcat 10+** (hoặc TomEE / GlassFish) trong NetBeans (tab *Services* -> *Servers*).
2. Nhấn phím **F6** (hoặc click chuột phải vào project `CareCar` -> chọn **Run**).
3. Trình duyệt sẽ tự động mở trang web tại địa chỉ: `http://localhost:8080/CareCar/` (hoặc `http://localhost:8084/CareCar/`).
