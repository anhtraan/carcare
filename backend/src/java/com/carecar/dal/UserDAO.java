package com.carecar.dal;

import com.carecar.model.Customer;
import com.carecar.model.User;
import com.carecar.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public User login(String usernameOrPhone, String rawPassword) {
        String sql = "SELECT * FROM [Users] WHERE (username = ? OR phone = ?) AND status = 'ACTIVE'";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return null;

            ps = conn.prepareStatement(sql);
            ps.setString(1, usernameOrPhone);
            ps.setString(2, usernameOrPhone);
            rs = ps.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password_hash");
                if (PasswordUtil.checkPassword(rawPassword, storedHash)) {
                    return mapUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public User getUserById(int userId) {
        String sql = "SELECT * FROM [Users] WHERE user_id = ?";
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
                return mapUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public User getUserByUsername(String username) {
        String sql = "SELECT * FROM [Users] WHERE username = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return null;

            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public User getUserByPhone(String phone) {
        String sql = "SELECT * FROM [Users] WHERE phone = ?";
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
                return mapUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public boolean registerCustomer(User user, Customer customer) {
        Connection conn = null;
        PreparedStatement psUser = null;
        PreparedStatement psCheckCust = null;
        PreparedStatement psCust = null;
        ResultSet rs = null;
        ResultSet rsCheck = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return false;
            conn.setAutoCommit(false);

            String sqlUser = "INSERT INTO [Users] (username, password_hash, full_name, email, phone, role, status) VALUES (?, ?, ?, ?, ?, 'CUSTOMER', 'ACTIVE')";
            psUser = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
            psUser.setString(1, user.getUsername());
            psUser.setString(2, PasswordUtil.hashPassword(user.getPasswordHash()));
            psUser.setString(3, user.getFullName());
            psUser.setString(4, user.getEmail());
            psUser.setString(5, user.getPhone());
            psUser.executeUpdate();

            rs = psUser.getGeneratedKeys();
            int newUserId = 0;
            if (rs.next()) {
                newUserId = rs.getInt(1);
            }

            // Kiểm tra xem số điện thoại này đã có hồ sơ trong bảng Customers chưa (ví dụ khách từng đến xưởng)
            String checkCustSql = "SELECT customer_id FROM [Customers] WHERE phone = ?";
            psCheckCust = conn.prepareStatement(checkCustSql);
            psCheckCust.setString(1, customer.getPhone());
            rsCheck = psCheckCust.executeQuery();

            if (rsCheck.next()) {
                int existingCustId = rsCheck.getInt("customer_id");
                String updateCustSql = "UPDATE [Customers] SET user_id = ?, full_name = ?, email = COALESCE(?, email), address = COALESCE(?, address) WHERE customer_id = ?";
                psCust = conn.prepareStatement(updateCustSql);
                psCust.setInt(1, newUserId);
                psCust.setString(2, customer.getFullName());
                psCust.setString(3, customer.getEmail());
                psCust.setString(4, customer.getAddress());
                psCust.setInt(5, existingCustId);
                psCust.executeUpdate();
            } else {
                String sqlCust = "INSERT INTO [Customers] (user_id, full_name, phone, email, address) VALUES (?, ?, ?, ?, ?)";
                psCust = conn.prepareStatement(sqlCust);
                psCust.setInt(1, newUserId);
                psCust.setString(2, customer.getFullName());
                psCust.setString(3, customer.getPhone());
                psCust.setString(4, customer.getEmail());
                psCust.setString(5, customer.getAddress());
                psCust.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ignored) {
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            DBContext.close(null, psCheckCust, rsCheck);
            DBContext.close(null, psCust, null);
            DBContext.close(conn, psUser, rs);
        }
    }

    public List<User> getMechanics() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM [Users] WHERE role = 'MECHANIC' AND status = 'ACTIVE' ORDER BY full_name ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return list;

            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public List<User> getAllStaff() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM [Users] WHERE role IN ('ADMIN', 'MECHANIC', 'RECEPTIONIST') ORDER BY role ASC, full_name ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return list;

            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public boolean createStaff(User user, String rawPassword) {
        String sql = "INSERT INTO [Users] (username, password_hash, full_name, email, phone, role, status) VALUES (?, ?, ?, ?, ?, ?, 'ACTIVE')";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return false;

            ps = conn.prepareStatement(sql);
            ps.setString(1, user.getUsername());
            ps.setString(2, PasswordUtil.hashPassword(rawPassword));
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getRole());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBContext.close(conn, ps, null);
        }
    }

    public boolean updateStatus(int userId, String status) {
        String sql = "UPDATE [Users] SET status = ? WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return false;

            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBContext.close(conn, ps, null);
        }
    }

    public boolean updatePassword(int userId, String hashedPassword) {
        String sql = "UPDATE [Users] SET password_hash = ? WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return false;

            ps = conn.prepareStatement(sql);
            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBContext.close(conn, ps, null);
        }
    }

    private User mapUser(ResultSet rs) throws SQLException {
        return new User(
                rs.getInt("user_id"),
                rs.getString("username"),
                rs.getString("password_hash"),
                rs.getString("full_name"),
                rs.getString("email"),
                rs.getString("phone"),
                rs.getString("role"),
                rs.getString("avatar"),
                rs.getString("status"),
                rs.getTimestamp("created_at")
        );
    }
}
