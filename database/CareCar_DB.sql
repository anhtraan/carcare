-- ==========================================================
-- HỆ THỐNG QUẢN LÝ GARA & DỊCH VỤ SỬA CHỮA Ô TÔ (CARECAR)
-- Database Script for Microsoft SQL Server 2019 / 2022
-- ==========================================================

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'CareCarDB')
BEGIN
    ALTER DATABASE CareCarDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE CareCarDB;
END
GO

CREATE DATABASE CareCarDB;
GO

USE CareCarDB;
GO

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- 1. BẢNG USERS (Tài khoản người dùng: Admin, Kỹ thuật viên, Lễ tân, Khách hàng)
CREATE TABLE [Users] (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL, -- Hashing SHA-256
    full_name NVARCHAR(100) NOT NULL,
    email VARCHAR(100) NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    role VARCHAR(20) NOT NULL CHECK (role IN ('ADMIN', 'MECHANIC', 'RECEPTIONIST', 'CUSTOMER')),
    avatar NVARCHAR(255) NULL DEFAULT 'assets/images/default-avatar.png',
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE', 'LOCKED')),
    created_at DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- 2. BẢNG CUSTOMERS (Hồ sơ khách hàng)
CREATE TABLE [Customers] (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NULL FOREIGN KEY REFERENCES [Users](user_id) ON DELETE SET NULL,
    full_name NVARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) NULL,
    address NVARCHAR(255) NULL,
    id_card VARCHAR(20) NULL, -- CCCD / CMND
    notes NVARCHAR(500) NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE()
);
GO
CREATE UNIQUE NONCLUSTERED INDEX UQ_Customers_user_id ON [Customers](user_id) WHERE user_id IS NOT NULL;
GO

-- 3. BẢNG CARS (Hồ sơ phương tiện ô tô)
CREATE TABLE [Cars] (
    car_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL FOREIGN KEY REFERENCES [Customers](customer_id) ON DELETE CASCADE,
    license_plate VARCHAR(20) NOT NULL UNIQUE, -- Biển số xe (vd: 30A-999.88)
    brand NVARCHAR(50) NOT NULL,              -- Hãng xe (Toyota, Mazda, Mercedes, Honda, Hyundai, VinFast...)
    model NVARCHAR(50) NOT NULL,              -- Dòng xe (Camry, CX-5, C300, CR-V, SantaFe, VF8...)
    year_manufactured INT NULL,               -- Năm sản xuất
    color NVARCHAR(30) NULL,                  -- Màu sơn
    vin_number VARCHAR(50) NULL,              -- Số khung (VIN)
    current_mileage INT NULL DEFAULT 0,       -- Số Km hiện tại (ODO)
    notes NVARCHAR(500) NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- 4. BẢNG SERVICES (Danh mục dịch vụ & Tiền công bảo dưỡng/sửa chữa)
CREATE TABLE [Services] (
    service_id INT IDENTITY(1,1) PRIMARY KEY,
    category NVARCHAR(100) NOT NULL,          -- Nhóm dịch vụ (Bảo dưỡng định kỳ, Động cơ & Hộp số, Khung gầm & Phanh, Điện - Điện lạnh, Đồng sơn & Chăm sóc)
    service_name NVARCHAR(150) NOT NULL,      -- Tên dịch vụ (vd: Thay dầu động cơ, Cân chỉnh góc đặt bánh xe, Bảo dưỡng phanh 4 bánh...)
    description NVARCHAR(500) NULL,           -- Mô tả chi tiết quy trình
    labor_cost DECIMAL(18,2) NOT NULL DEFAULT 0, -- Giá tiền công dịch vụ (VND)
    estimated_duration INT NOT NULL DEFAULT 60,  -- Thời gian ước tính hoàn thành (phút)
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE'))
);
GO

-- 5. BẢNG SPARE_PARTS (Kho phụ tùng & Linh kiện ô tô)
CREATE TABLE [SpareParts] (
    part_id INT IDENTITY(1,1) PRIMARY KEY,
    part_code VARCHAR(50) NOT NULL UNIQUE,    -- Mã phụ tùng (vd: OIL-MOBIL1-5W30, BRK-PAD-BOSCH-01)
    part_name NVARCHAR(150) NOT NULL,         -- Tên linh kiện/phụ tùng
    category NVARCHAR(100) NOT NULL,          -- Loại (Dầu nhớt/Hóa chất, Hệ thống phanh, Lọc gió/Lọc dầu, Bugi/Đánh lửa, Hệ thống treo, Đèn/Điện...)
    unit NVARCHAR(20) NOT NULL DEFAULT N'Cái',-- Đơn vị tính (Cái, Lít, Bình, Bộ, Cặp...)
    unit_price DECIMAL(18,2) NOT NULL,        -- Đơn giá bán lẻ tới khách hàng
    cost_price DECIMAL(18,2) NOT NULL,        -- Giá vốn nhập kho
    quantity_in_stock INT NOT NULL DEFAULT 0, -- Số lượng tồn kho hiện tại
    min_stock_alert INT NOT NULL DEFAULT 5,   -- Ngưỡng cảnh báo tồn kho thấp
    location NVARCHAR(50) NULL,               -- Vị trí trong kho (vd: Kệ A1-03)
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE'))
);
GO

-- 6. BẢNG APPOINTMENTS (Lịch hẹn sửa chữa / bảo dưỡng từ khách hàng)
CREATE TABLE [Appointments] (
    appointment_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NULL FOREIGN KEY REFERENCES [Customers](customer_id),
    car_id INT NULL FOREIGN KEY REFERENCES [Cars](car_id),
    customer_name NVARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    license_plate VARCHAR(20) NOT NULL,
    car_brand_model NVARCHAR(100) NULL,
    appointment_date DATE NOT NULL,
    time_slot VARCHAR(20) NOT NULL,           -- Khung giờ: '08:00 - 09:30', '09:30 - 11:00', '13:30 - 15:00', '15:00 - 16:30'
    requested_service NVARCHAR(255) NOT NULL,
    notes NVARCHAR(500) NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'CONFIRMED', 'COMPLETED', 'CANCELLED')),
    created_at DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- 7. BẢNG REPAIR_ORDERS (Phiếu tiếp nhận & Lệnh sửa chữa - Work Order)
CREATE TABLE [RepairOrders] (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    order_code VARCHAR(30) NOT NULL UNIQUE,   -- Mã phiếu (vd: CC-2026-0001)
    customer_id INT NOT NULL FOREIGN KEY REFERENCES [Customers](customer_id),
    car_id INT NOT NULL FOREIGN KEY REFERENCES [Cars](car_id),
    receptionist_id INT NULL FOREIGN KEY REFERENCES [Users](user_id), -- Cố vấn dịch vụ / Tiếp nhận
    mechanic_id INT NULL FOREIGN KEY REFERENCES [Users](user_id),     -- Kỹ thuật viên trưởng phụ trách
    entry_date DATETIME NOT NULL DEFAULT GETDATE(),                   -- Ngày giờ vào xưởng
    expected_finish_date DATETIME NULL,                               -- Dự kiến hoàn thành
    actual_finish_date DATETIME NULL,                                 -- Thực tế hoàn thành
    entry_mileage INT NULL,                                           -- ODO lúc tiếp nhận
    initial_diagnosis NVARCHAR(1000) NULL,                            -- Tình trạng xe & Yêu cầu của khách
    technician_notes NVARCHAR(1000) NULL,                             -- Kết luận kiểm tra & Đề xuất kỹ thuật
    total_service_cost DECIMAL(18,2) NOT NULL DEFAULT 0,              -- Tổng tiền công dịch vụ
    total_part_cost DECIMAL(18,2) NOT NULL DEFAULT 0,                 -- Tổng tiền phụ tùng thay thế
    discount_amount DECIMAL(18,2) NOT NULL DEFAULT 0,                 -- Giảm giá (VND)
    tax_vat DECIMAL(18,2) NOT NULL DEFAULT 0,                         -- Thuế VAT (VND)
    grand_total DECIMAL(18,2) NOT NULL DEFAULT 0,                     -- Tổng thanh toán = (Dịch vụ + Phụ tùng - Giảm giá + VAT)
    order_status VARCHAR(30) NOT NULL DEFAULT 'PENDING_INSPECTION'
        CHECK (order_status IN (
            'PENDING_INSPECTION',      -- Chờ kiểm tra / chẩn đoán
            'DIAGNOSED_QUOTED',        -- Đã kiểm tra & Đang báo giá
            'IN_PROGRESS',             -- Đang tiến hành sửa chữa
            'COMPLETED_WAITING_PAYMENT',-- Sửa xong, chờ thanh toán
            'PAID_DELIVERED',          -- Đã thanh toán & Đã giao xe
            'CANCELLED'                -- Hủy lệnh
        )),
    created_at DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- 8. BẢNG REPAIR_ORDER_SERVICES (Chi tiết các dịch vụ trong phiếu sửa chữa)
CREATE TABLE [RepairOrderServices] (
    order_service_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL FOREIGN KEY REFERENCES [RepairOrders](order_id) ON DELETE CASCADE,
    service_id INT NOT NULL FOREIGN KEY REFERENCES [Services](service_id),
    service_name NVARCHAR(150) NOT NULL,
    price DECIMAL(18,2) NOT NULL DEFAULT 0,
    quantity INT NOT NULL DEFAULT 1,
    subtotal AS (price * quantity) PERSISTED,
    notes NVARCHAR(255) NULL
);
GO

-- 9. BẢNG REPAIR_ORDER_PARTS (Chi tiết phụ tùng thay thế trong phiếu sửa chữa)
CREATE TABLE [RepairOrderParts] (
    order_part_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL FOREIGN KEY REFERENCES [RepairOrders](order_id) ON DELETE CASCADE,
    part_id INT NOT NULL FOREIGN KEY REFERENCES [SpareParts](part_id),
    part_code VARCHAR(50) NOT NULL,
    part_name NVARCHAR(150) NOT NULL,
    unit_price DECIMAL(18,2) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    subtotal AS (unit_price * quantity) PERSISTED,
    notes NVARCHAR(255) NULL
);
GO

-- 10. BẢNG INVOICES (Hóa đơn thanh toán)
CREATE TABLE [Invoices] (
    invoice_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL UNIQUE FOREIGN KEY REFERENCES [RepairOrders](order_id),
    invoice_code VARCHAR(30) NOT NULL UNIQUE,  -- Mã hóa đơn (vd: INV-2026-0001)
    amount_paid DECIMAL(18,2) NOT NULL,
    payment_method VARCHAR(30) NOT NULL DEFAULT 'CASH' CHECK (payment_method IN ('CASH', 'BANK_TRANSFER', 'VNPAY', 'CREDIT_CARD')),
    payment_status VARCHAR(20) NOT NULL DEFAULT 'PAID' CHECK (payment_status IN ('PAID', 'UNPAID', 'PARTIAL')),
    payment_date DATETIME NOT NULL DEFAULT GETDATE(),
    created_by INT NULL FOREIGN KEY REFERENCES [Users](user_id),
    notes NVARCHAR(500) NULL
);
GO

-- ==========================================================
-- SEED DATA (DỮ LIỆU MẪU ĐỂ CHẠY THỬ NGHIỆM NGAY)
-- Mật khẩu mặc định cho các tài khoản là: 123456
-- Chuỗi mã hóa SHA-256 của '123456' = '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92'
-- ==========================================================

-- 1. Thêm Users
INSERT INTO [Users] (username, password_hash, full_name, email, phone, role, status) VALUES
('admin', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Quản Trị Viên Gara', 'admin@carecar.vn', '0901234567', 'ADMIN', 'ACTIVE'),
('mechanic1', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Trần Văn Sơn (Thợ máy chính)', 'son.tv@carecar.vn', '0912345678', 'MECHANIC', 'ACTIVE'),
('mechanic2', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Lê Hoàng Long (Thợ điện lạnh)', 'long.lh@carecar.vn', '0923456789', 'MECHANIC', 'ACTIVE'),
('receptionist', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Nguyễn Thu Thảo (Cố vấn DV)', 'thao.nt@carecar.vn', '0934567890', 'RECEPTIONIST', 'ACTIVE'),
('customer1', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Phạm Minh Tuấn', 'minhtuan@gmail.com', '0988776655', 'CUSTOMER', 'ACTIVE'),
('customer2', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Vũ Hoàng Anh', 'hoanganh.vu@gmail.com', '0977889900', 'CUSTOMER', 'ACTIVE');
GO

-- 2. Thêm Customers
INSERT INTO [Customers] (user_id, full_name, phone, email, address, id_card) VALUES
(5, N'Phạm Minh Tuấn', '0988776655', 'minhtuan@gmail.com', N'Số 45 Lê Văn Lương, Cầu Giấy, Hà Nội', '001095001234'),
(6, N'Vũ Hoàng Anh', '0977889900', 'hoanganh.vu@gmail.com', N'120 Nguyễn Thị Minh Khai, Q.3, TP.HCM', '079093005678'),
(NULL, N'Đặng Quốc Bảo (Khách vãng lai)', '0911223344', 'bao.dang@outlook.com', N'Số 12 Tràng Thi, Hoàn Kiếm, Hà Nội', '001092003322');
GO

-- 3. Thêm Cars
INSERT INTO [Cars] (customer_id, license_plate, brand, model, year_manufactured, color, vin_number, current_mileage, notes) VALUES
(1, '30H-888.99', 'Mazda', 'CX-5 2.0 Premium', 2021, N'Đỏ Soul Red', 'JM3KF4DY2M0123456', 45000, N'Xe chính chủ, bảo dưỡng định kỳ đúng hạn'),
(1, '30A-567.89', 'Mercedes-Benz', 'C300 AMG', 2022, N'Đen Obsidian', 'WDD2050481F654321', 28000, N'Yêu cầu dùng dầu nhớt động cơ cao cấp'),
(2, '51K-999.68', 'Toyota', 'Camry 2.5Q', 2020, N'Trắng Ngọc Trai', '6T1BF3HK8LU789012', 62000, N'Đã bảo dưỡng cấp 6 vạn'),
(3, '30G-123.45', 'VinFast', 'VF8 Plus', 2023, N'Xanh Deep Ocean', 'VF8A924K9P0112233', 18000, N'Kiểm tra hệ thống gầm và lốp xe');
GO

-- 4. Thêm Services
INSERT INTO [Services] (category, service_name, description, labor_cost, estimated_duration, status) VALUES
(N'Bảo dưỡng định kỳ', N'Bảo dưỡng cấp nhỏ (Thay dầu + Kiểm tra 20 hạng mục)', N'Kiểm tra toàn diện 20 hạng mục an toàn, vệ sinh lọc gió, châm nước rửa kính, siết gầm', 250000, 45, 'ACTIVE'),
(N'Bảo dưỡng định kỳ', N'Bảo dưỡng cấp trung bình (10.000km - 20.000km)', N'Bao gồm thay dầu nhớt, thay lọc dầu, vệ sinh hệ thống phanh 4 bánh, đảo lốp, cân mâm', 450000, 90, 'ACTIVE'),
(N'Bảo dưỡng định kỳ', N'Bảo dưỡng cấp lớn (40.000km - 80.000km)', N'Kiểm tra và vệ sinh hệ thống nhiên liệu, buồng đốt, thay bugi, dầu phanh, dầu trợ lực, nước làm mát', 950000, 180, 'ACTIVE'),
(N'Động cơ & Hộp số', N'Vệ sinh kim phun & Họng hút buồng đốt Hydro', N'Làm sạch muội carbon kim phun xăng, cổ hút giúp xe chạy êm, bốc máy và tiết kiệm xăng', 600000, 60, 'ACTIVE'),
(N'Động cơ & Hộp số', N'Đại tu đại tu & Căn chỉnh xu-páp động cơ', N'Khắc phục máy kêu, hao dầu, yếu máy, đại tu toàn diện động cơ theo tiêu chuẩn hãng', 4500000, 720, 'ACTIVE'),
(N'Khung gầm & Phanh', N'Cân chỉnh góc đặt bánh xe 3D Hunter (Thước lái)', N'Cân chỉnh độ chụm bánh xe bằng máy laser 3D công nghệ Mỹ Hunter, triệt tiêu nhao lái, mòn lốp', 500000, 45, 'ACTIVE'),
(N'Khung gầm & Phanh', N'Bảo dưỡng & Tra mỡ trượt cùm phanh 4 bánh', N'Vệ sinh bụi má phanh, tra mỡ chịu nhiệt piston và ắc suốt phanh, đảm bảo phanh ăn đều', 350000, 60, 'ACTIVE'),
(N'Điện & Điện lạnh', N'Nội soi & Vệ sinh giàn lạnh điều hòa ô tô', N'Vệ sinh bằng dung dịch chuyên dụng qua camera nội soi không cần tháo taplo, khử mùi hôi', 550000, 60, 'ACTIVE'),
(N'Điện & Điện lạnh', N'Bảo dưỡng máy phát & Củ đề khởi động', N'Vệ sinh chổi than, kiểm tra rơle và cuộn phát điện', 400000, 90, 'ACTIVE'),
(N'Đồng sơn & Chăm sóc', N'Đánh bóng toàn thân xe 3 bước cao cấp', N'Khử vết xước xoáy, xước dăm, tạo độ bóng sâu và phủ sáp bảo vệ lớp sơn bóng', 1500000, 240, 'ACTIVE');
GO

-- 5. Thêm Phụ tùng / Linh kiện
INSERT INTO [SpareParts] (part_code, part_name, category, unit, unit_price, cost_price, quantity_in_stock, min_stock_alert, location, status) VALUES
('OIL-MOBIL1-5W30', N'Dầu nhớt động cơ Mobil 1 Advanced 5W-30 (Can 4L)', N'Dầu nhớt/Hóa chất', N'Can', 1150000, 850000, 25, 5, N'Kệ A1-01', 'ACTIVE'),
('OIL-CASTROL-5W40', N'Dầu nhớt Castrol Magnatec Stop-Start 5W-40 (Can 4L)', N'Dầu nhớt/Hóa chất', N'Can', 780000, 560000, 30, 8, N'Kệ A1-02', 'ACTIVE'),
('FLT-OIL-TYT-01', N'Lọc dầu nhớt động cơ chính hãng Toyota/Lexus', N'Lọc gió/Lọc dầu', N'Cái', 180000, 110000, 45, 10, N'Kệ B2-01', 'ACTIVE'),
('FLT-OIL-MAZDA-02', N'Lọc dầu nhớt động cơ Mazda SkyActiv (CX5, Mazda 3/6)', N'Lọc gió/Lọc dầu', N'Cái', 190000, 120000, 35, 8, N'Kệ B2-02', 'ACTIVE'),
('FLT-AIR-DENSO-01', N'Lọc gió động cơ Denso cao cấp', N'Lọc gió/Lọc dầu', N'Cái', 280000, 170000, 20, 5, N'Kệ B2-05', 'ACTIVE'),
('BRK-PAD-BOSCH-F', N'Bộ má phanh trước gốm Ceramic Bosch Germany', N'Hệ thống phanh', N'Bộ', 1250000, 880000, 12, 4, N'Kệ C1-04', 'ACTIVE'),
('BRK-PAD-BOSCH-R', N'Bộ má phanh sau Bosch Germany', N'Hệ thống phanh', N'Bộ', 950000, 680000, 14, 4, N'Kệ C1-05', 'ACTIVE'),
('SPK-NGK-IRIDIUM', N'Bugi Iridium cao cấp NGK Laser Laser (Bộ 4 chiếc)', N'Bugi/Đánh lửa', N'Bộ', 960000, 650000, 18, 5, N'Kệ D1-02', 'ACTIVE'),
('COOLANT-PRESTONE', N'Nước làm mát tản nhiệt Prestone USA (Bình 4L)', N'Dầu nhớt/Hóa chất', N'Bình', 320000, 210000, 22, 6, N'Kệ A2-03', 'ACTIVE'),
('BAT-VARTA-65AH', N'Bình ắc quy ô tô Varta Silver Dynamic AGM 65Ah', N'Đèn/Điện/Ắc quy', N'Bình', 2650000, 2050000, 8, 3, N'Kệ E1-01', 'ACTIVE'),
('WIPER-BOSCH-AERO', N'Cặp gạt mưa thân mềm không xương Bosch Aerotwin', N'Phụ kiện ngoại thất', N'Cặp', 480000, 310000, 16, 5, N'Kệ F1-02', 'ACTIVE');
GO

-- 6. Thêm Lịch hẹn (Appointments)
INSERT INTO [Appointments] (customer_id, car_id, customer_name, phone, license_plate, car_brand_model, appointment_date, time_slot, requested_service, notes, status) VALUES
(1, 1, N'Phạm Minh Tuấn', '0988776655', '30H-888.99', 'Mazda CX-5', CAST(GETDATE() AS DATE), '08:30 - 10:00', N'Bảo dưỡng định kỳ 45.000km + Cân chỉnh thước lái', N'Khách cần lấy xe trước 11h trưa', 'CONFIRMED'),
(2, 3, N'Vũ Hoàng Anh', '0977889900', '51K-999.68', 'Toyota Camry', DATEADD(DAY, 1, CAST(GETDATE() AS DATE)), '14:00 - 15:30', N'Bảo dưỡng phanh và nội soi điều hòa', N'Kiểm tra thêm tiếng kêu lọc cọc bên phụ khi đánh lái', 'PENDING'),
(NULL, NULL, N'Hoàng Trọng Nghĩa', '0933445566', '30F-333.22', 'Honda CR-V', DATEADD(DAY, 2, CAST(GETDATE() AS DATE)), '09:00 - 10:30', N'Thay dầu động cơ & Lọc gió', N'Khách mới lần đầu đến gara', 'PENDING');
GO

-- 7. Thêm Lệnh sửa chữa mẫu (RepairOrders)
INSERT INTO [RepairOrders] (
    order_code, customer_id, car_id, receptionist_id, mechanic_id,
    entry_date, expected_finish_date, actual_finish_date, entry_mileage,
    initial_diagnosis, technician_notes,
    total_service_cost, total_part_cost, discount_amount, tax_vat, grand_total, order_status
) VALUES
(
    'CC-2026-0001', 1, 1, 4, 2,
    DATEADD(HOUR, -4, GETDATE()), DATEADD(HOUR, 2, GETDATE()), NULL, 45200,
    N'Khách báo xe chạy trên 80km/h hơi rung lái, đến kỳ thay dầu định kỳ',
    N'Góc chụm bánh trước hơi lệch 0.8 độ, má phanh còn 60%, dầu máy đen cần thay',
    750000, 1340000, 100000, 199000, 2189000, 'IN_PROGRESS'
),
(
    'CC-2026-0002', 2, 3, 4, 3,
    DATEADD(DAY, -1, GETDATE()), DATEADD(DAY, -1, GETDATE()), DATEADD(DAY, -1, GETDATE()), 62150,
    N'Điều hòa mát kém, có mùi chua ẩm khi mới bật AC, bảo dưỡng phanh',
    N'Giàn lạnh nhiều bụi ẩm mốc, đã nội soi khử khuẩn sạch sẽ. Má phanh sau mòn sát chỉ tiêu, đã thay mới',
    900000, 950000, 0, 185000, 2035000, 'PAID_DELIVERED'
);
GO

-- 8. Chi tiết dịch vụ trong lệnh sửa chữa
INSERT INTO [RepairOrderServices] (order_id, service_id, service_name, price, quantity, notes) VALUES
(1, 1, N'Bảo dưỡng cấp nhỏ (Thay dầu + Kiểm tra 20 hạng mục)', 250000, 1, N'Thực hiện đúng checklist'),
(1, 6, N'Cân chỉnh góc đặt bánh xe 3D Hunter (Thước lái)', 500000, 1, N'Cân chỉnh laser chuẩn thông số hãng Mazda'),
(2, 8, N'Nội soi & Vệ sinh giàn lạnh điều hòa ô tô', 550000, 1, N'Sử dụng dung dịch Sonax diệt khuẩn'),
(2, 7, N'Bảo dưỡng & Tra mỡ trượt cùm phanh 4 bánh', 350000, 1, N'Bôi mỡ chịu nhiệt cao cấp');
GO

-- 9. Chi tiết phụ tùng thay thế trong lệnh sửa chữa
INSERT INTO [RepairOrderParts] (order_id, part_id, part_code, part_name, unit_price, quantity, notes) VALUES
(1, 1, 'OIL-MOBIL1-5W30', N'Dầu nhớt động cơ Mobil 1 Advanced 5W-30 (Can 4L)', 1150000, 1, N'Đổ đủ 4.2L bao gồm lọc dầu'),
(1, 4, 'FLT-OIL-MAZDA-02', N'Lọc dầu nhớt động cơ Mazda SkyActiv', 190000, 1, N'Thay mới cùng dầu máy'),
(2, 7, 'BRK-PAD-BOSCH-R', N'Bộ má phanh sau Bosch Germany', 950000, 1, N'Khách duyệt thay mới');
GO

-- 10. Hóa đơn thanh toán cho lệnh CC-2026-0002
INSERT INTO [Invoices] (order_id, invoice_code, amount_paid, payment_method, payment_status, payment_date, created_by, notes) VALUES
(2, 'INV-2026-0001', 2035000, 'BANK_TRANSFER', 'PAID', DATEADD(DAY, -1, GETDATE()), 4, N'Khách chuyển khoản Vietcombank qua mã QR');
GO

PRINT N'=== KHỞI TẠO CƠ SỞ DỮ LIỆU CARECAR THÀNH CÔNG ===';
