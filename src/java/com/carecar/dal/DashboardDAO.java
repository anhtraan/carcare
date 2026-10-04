package com.carecar.dal;

import com.carecar.model.DashboardStats;
import com.carecar.model.RepairOrder;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DashboardDAO {

    public DashboardStats getDashboardStats() {
        DashboardStats stats = new DashboardStats();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return stats;

            // 1. Doanh thu hôm nay
            String sqlTodayRevenue = "SELECT ISNULL(SUM(amount_paid), 0) FROM [Invoices] WHERE CAST(payment_date AS DATE) = CAST(GETDATE() AS DATE)";
            ps = conn.prepareStatement(sqlTodayRevenue);
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.setTodayRevenue(rs.getBigDecimal(1));
            }
            DBContext.close(null, ps, rs);

            // 2. Doanh thu tháng này
            String sqlMonthRevenue = "SELECT ISNULL(SUM(amount_paid), 0) FROM [Invoices] WHERE MONTH(payment_date) = MONTH(GETDATE()) AND YEAR(payment_date) = YEAR(GETDATE())";
            ps = conn.prepareStatement(sqlMonthRevenue);
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.setMonthlyRevenue(rs.getBigDecimal(1));
            }
            DBContext.close(null, ps, rs);

            // 3. Số lịch hẹn hôm nay
            String sqlTodayApps = "SELECT COUNT(*) FROM [Appointments] WHERE appointment_date = CAST(GETDATE() AS DATE)";
            ps = conn.prepareStatement(sqlTodayApps);
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.setTodayAppointments(rs.getInt(1));
            }
            DBContext.close(null, ps, rs);

            // 4. Lệnh sửa chữa đang hoạt động (Chờ kiểm tra, đã báo giá, đang sửa)
            String sqlActiveOrders = "SELECT COUNT(*) FROM [RepairOrders] WHERE order_status IN ('PENDING_INSPECTION', 'DIAGNOSED_QUOTED', 'IN_PROGRESS', 'COMPLETED_WAITING_PAYMENT')";
            ps = conn.prepareStatement(sqlActiveOrders);
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.setActiveRepairOrders(rs.getInt(1));
            }
            DBContext.close(null, ps, rs);

            // 5. Đơn hoàn thành tháng này
            String sqlCompletedOrders = "SELECT COUNT(*) FROM [RepairOrders] WHERE order_status = 'PAID_DELIVERED' AND MONTH(entry_date) = MONTH(GETDATE()) AND YEAR(entry_date) = YEAR(GETDATE())";
            ps = conn.prepareStatement(sqlCompletedOrders);
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.setCompletedOrdersThisMonth(rs.getInt(1));
            }
            DBContext.close(null, ps, rs);

            // 6. Số lượng phụ tùng sắp hết
            String sqlLowStock = "SELECT COUNT(*) FROM [SpareParts] WHERE quantity_in_stock <= min_stock_alert AND status = 'ACTIVE'";
            ps = conn.prepareStatement(sqlLowStock);
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.setLowStockCount(rs.getInt(1));
            }
            DBContext.close(null, ps, rs);

            // 7. Tổng số khách hàng
            String sqlCustomers = "SELECT COUNT(*) FROM [Customers]";
            ps = conn.prepareStatement(sqlCustomers);
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.setTotalCustomers(rs.getInt(1));
            }
            DBContext.close(null, ps, rs);

            // 8. Tổng số xe
            String sqlCars = "SELECT COUNT(*) FROM [Cars]";
            ps = conn.prepareStatement(sqlCars);
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.setTotalCars(rs.getInt(1));
            }
            DBContext.close(null, ps, rs);

            // 9. Danh sách lịch hẹn hôm nay & Phụ tùng cảnh báo
            AppointmentDAO appDAO = new AppointmentDAO();
            stats.setTodayAppointmentsList(appDAO.getTodayAppointments());

            SparePartDAO partDAO = new SparePartDAO();
            stats.setLowStockParts(partDAO.getLowStockParts());

            // 10. Các đơn sửa chữa gần nhất
            RepairOrderDAO roDAO = new RepairOrderDAO();
            List<RepairOrder> all = roDAO.getAllOrders();
            if (all.size() > 8) {
                stats.setRecentOrders(all.subList(0, 8));
            } else {
                stats.setRecentOrders(all);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return stats;
    }
}
