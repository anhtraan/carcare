package com.carecar.dal;

import com.carecar.model.ServiceItem;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {

    public List<ServiceItem> getAllServices() {
        List<ServiceItem> list = new ArrayList<>();
        String sql = "SELECT * FROM [Services] ORDER BY category ASC, labor_cost ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return list;

            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapService(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public List<ServiceItem> getActiveServices() {
        List<ServiceItem> list = new ArrayList<>();
        String sql = "SELECT * FROM [Services] WHERE status = 'ACTIVE' ORDER BY category ASC, labor_cost ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return list;

            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapService(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public ServiceItem getServiceById(int serviceId) {
        String sql = "SELECT * FROM [Services] WHERE service_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return null;

            ps = conn.prepareStatement(sql);
            ps.setInt(1, serviceId);
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapService(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public List<String> getCategories() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM [Services] WHERE status = 'ACTIVE' ORDER BY category ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return list;

            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("category"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public int insertService(ServiceItem item) {
        String sql = "INSERT INTO [Services] (category, service_name, description, labor_cost, estimated_duration, status) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return 0;

            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, item.getCategory());
            ps.setString(2, item.getServiceName());
            ps.setString(3, item.getDescription());
            ps.setBigDecimal(4, item.getLaborCost());
            ps.setInt(5, item.getEstimatedDuration());
            ps.setString(6, item.getStatus() != null ? item.getStatus() : "ACTIVE");
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

    public boolean updateService(ServiceItem item) {
        String sql = "UPDATE [Services] SET category = ?, service_name = ?, description = ?, labor_cost = ?, estimated_duration = ?, status = ? WHERE service_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return false;

            ps = conn.prepareStatement(sql);
            ps.setString(1, item.getCategory());
            ps.setString(2, item.getServiceName());
            ps.setString(3, item.getDescription());
            ps.setBigDecimal(4, item.getLaborCost());
            ps.setInt(5, item.getEstimatedDuration());
            ps.setString(6, item.getStatus());
            ps.setInt(7, item.getServiceId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBContext.close(conn, ps, null);
        }
    }

    public boolean toggleStatus(int serviceId, String status) {
        String sql = "UPDATE [Services] SET status = ? WHERE service_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return false;

            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, serviceId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBContext.close(conn, ps, null);
        }
    }

    private ServiceItem mapService(ResultSet rs) throws SQLException {
        return new ServiceItem(
                rs.getInt("service_id"),
                rs.getString("category"),
                rs.getString("service_name"),
                rs.getString("description"),
                rs.getBigDecimal("labor_cost"),
                rs.getInt("estimated_duration"),
                rs.getString("status")
        );
    }
}
