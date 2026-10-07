package com.carecar.dal;

import com.carecar.model.Customer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    public List<Customer> getAllCustomers() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(ro.order_id) AS total_orders " +
                     "FROM [Customers] c " +
                     "LEFT JOIN [RepairOrders] ro ON c.customer_id = ro.customer_id " +
                     "GROUP BY c.customer_id, c.user_id, c.full_name, c.phone, c.email, c.address, c.id_card, c.notes, c.created_at " +
                     "ORDER BY c.created_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return list;

            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Customer c = mapCustomer(rs);
                c.setTotalOrders(rs.getInt("total_orders"));
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public Customer getCustomerById(int customerId) {
        String sql = "SELECT * FROM [Customers] WHERE customer_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return null;

            ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapCustomer(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public Customer getCustomerByUserId(int userId) {
        String sql = "SELECT * FROM [Customers] WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return null;

            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapCustomer(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public Customer getCustomerByPhone(String phone) {
        String sql = "SELECT * FROM [Customers] WHERE phone = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return null;

            ps = conn.prepareStatement(sql);
            ps.setString(1, phone);
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapCustomer(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public int insertCustomer(Customer c) {
        String sql = "INSERT INTO [Customers] (user_id, full_name, phone, email, address, id_card, notes) VALUES (?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return 0;

            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            if (c.getUserId() != null) {
                ps.setInt(1, c.getUserId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, c.getFullName());
            ps.setString(3, c.getPhone());
            ps.setString(4, c.getEmail());
            ps.setString(5, c.getAddress());
            ps.setString(6, c.getIdCard());
            ps.setString(7, c.getNotes());
            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return 0;
    }

    public boolean updateCustomer(Customer c) {
        String sql = "UPDATE [Customers] SET full_name = ?, phone = ?, email = ?, address = ?, id_card = ?, notes = ? WHERE customer_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return false;

            ps = conn.prepareStatement(sql);
            ps.setString(1, c.getFullName());
            ps.setString(2, c.getPhone());
            ps.setString(3, c.getEmail());
            ps.setString(4, c.getAddress());
            ps.setString(5, c.getIdCard());
            ps.setString(6, c.getNotes());
            ps.setInt(7, c.getCustomerId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBContext.close(conn, ps, null);
        }
    }

    public List<Customer> searchCustomers(String keyword) {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM [Customers] WHERE full_name LIKE ? OR phone LIKE ? OR email LIKE ? ORDER BY full_name ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return list;

            ps = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapCustomer(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    private Customer mapCustomer(ResultSet rs) throws SQLException {
        Integer userId = rs.getObject("user_id") != null ? rs.getInt("user_id") : null;
        return new Customer(
                rs.getInt("customer_id"),
                userId,
                rs.getString("full_name"),
                rs.getString("phone"),
                rs.getString("email"),
                rs.getString("address"),
                rs.getString("id_card"),
                rs.getString("notes"),
                rs.getTimestamp("created_at")
        );
    }
}
