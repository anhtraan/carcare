package com.carecar.dal;

import com.carecar.model.Invoice;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class InvoiceDAO {

    public List<Invoice> getAllInvoices() {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT inv.*, ro.order_code, cust.full_name AS customer_name, cust.phone AS customer_phone, " +
                     "       c.license_plate, u.full_name AS creator_name " +
                     "FROM [Invoices] inv " +
                     "JOIN [RepairOrders] ro ON inv.order_id = ro.order_id " +
                     "JOIN [Customers] cust ON ro.customer_id = cust.customer_id " +
                     "JOIN [Cars] c ON ro.car_id = c.car_id " +
                     "LEFT JOIN [Users] u ON inv.created_by = u.user_id " +
                     "ORDER BY inv.payment_date DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return list;

            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapInvoice(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public Invoice getInvoiceById(int invoiceId) {
        String sql = "SELECT inv.*, ro.order_code, cust.full_name AS customer_name, cust.phone AS customer_phone, " +
                     "       c.license_plate, u.full_name AS creator_name " +
                     "FROM [Invoices] inv " +
                     "JOIN [RepairOrders] ro ON inv.order_id = ro.order_id " +
                     "JOIN [Customers] cust ON ro.customer_id = cust.customer_id " +
                     "JOIN [Cars] c ON ro.car_id = c.car_id " +
                     "LEFT JOIN [Users] u ON inv.created_by = u.user_id " +
                     "WHERE inv.invoice_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return null;

            ps = conn.prepareStatement(sql);
            ps.setInt(1, invoiceId);
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapInvoice(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public Invoice getInvoiceByOrderId(int orderId) {
        String sql = "SELECT inv.*, ro.order_code, cust.full_name AS customer_name, cust.phone AS customer_phone, " +
                     "       c.license_plate, u.full_name AS creator_name " +
                     "FROM [Invoices] inv " +
                     "JOIN [RepairOrders] ro ON inv.order_id = ro.order_id " +
                     "JOIN [Customers] cust ON ro.customer_id = cust.customer_id " +
                     "JOIN [Cars] c ON ro.car_id = c.car_id " +
                     "LEFT JOIN [Users] u ON inv.created_by = u.user_id " +
                     "WHERE inv.order_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return null;

            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapInvoice(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public int createInvoice(Invoice inv) {
        // Kiểm tra xem lệnh này đã xuất hóa đơn trước đó chưa
        Invoice existing = getInvoiceByOrderId(inv.getOrderId());
        if (existing != null) {
            return existing.getInvoiceId();
        }

        String sql = "INSERT INTO [Invoices] (order_id, invoice_code, amount_paid, payment_method, payment_status, payment_date, created_by, notes) " +
                     "VALUES (?, ?, ?, ?, ?, GETDATE(), ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return 0;

            String code = generateInvoiceCode(conn);
            inv.setInvoiceCode(code);

            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, inv.getOrderId());
            ps.setString(2, code);
            ps.setBigDecimal(3, inv.getAmountPaid() != null ? inv.getAmountPaid() : java.math.BigDecimal.ZERO);
            ps.setString(4, inv.getPaymentMethod() != null ? inv.getPaymentMethod() : "CASH");
            ps.setString(5, inv.getPaymentStatus() != null ? inv.getPaymentStatus() : "PAID");
            if (inv.getCreatedBy() != null) {
                ps.setInt(6, inv.getCreatedBy());
            } else {
                ps.setNull(6, Types.INTEGER);
            }
            ps.setString(7, inv.getNotes());
            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                int invoiceId = rs.getInt(1);
                // Also update order status to PAID_DELIVERED
                RepairOrderDAO roDAO = new RepairOrderDAO();
                roDAO.updateOrderStatus(inv.getOrderId(), "PAID_DELIVERED");
                return invoiceId;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return 0;
    }

    private String generateInvoiceCode(Connection conn) throws SQLException {
        int nextNum = 1;
        String sql = "SELECT ISNULL(MAX(invoice_id), 0) + 1 FROM [Invoices]";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                nextNum = rs.getInt(1);
            }
        }
        String year = String.valueOf(java.time.Year.now().getValue());
        String code = String.format("INV-%s-%04d", year, nextNum);

        // Đảm bảo không trùng mã hóa đơn (Unique constraint)
        String checkSql = "SELECT COUNT(*) FROM [Invoices] WHERE invoice_code = ?";
        try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
            while (true) {
                ps.setString(1, code);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        nextNum++;
                        code = String.format("INV-%s-%04d", year, nextNum);
                    } else {
                        break;
                    }
                }
            }
        }
        return code;
    }

    private Invoice mapInvoice(ResultSet rs) throws SQLException {
        Integer createdBy = rs.getObject("created_by") != null ? rs.getInt("created_by") : null;
        Invoice inv = new Invoice(
                rs.getInt("invoice_id"),
                rs.getInt("order_id"),
                rs.getString("invoice_code"),
                rs.getBigDecimal("amount_paid"),
                rs.getString("payment_method"),
                rs.getString("payment_status"),
                rs.getTimestamp("payment_date"),
                createdBy,
                rs.getString("notes")
        );
        try {
            inv.setOrderCode(rs.getString("order_code"));
            inv.setCustomerName(rs.getString("customer_name"));
            inv.setCustomerPhone(rs.getString("customer_phone"));
            inv.setLicensePlate(rs.getString("license_plate"));
            inv.setCreatorName(rs.getString("creator_name"));
        } catch (SQLException ignored) {
        }
        return inv;
    }
}
