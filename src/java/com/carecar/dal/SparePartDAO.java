package com.carecar.dal;

import com.carecar.model.SparePart;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class SparePartDAO {

    public List<SparePart> getAllParts() {
        List<SparePart> list = new ArrayList<>();
        String sql = "SELECT * FROM [SpareParts] ORDER BY category ASC, part_name ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return list;

            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapPart(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public List<SparePart> getLowStockParts() {
        List<SparePart> list = new ArrayList<>();
        String sql = "SELECT * FROM [SpareParts] WHERE quantity_in_stock <= min_stock_alert AND status = 'ACTIVE' ORDER BY quantity_in_stock ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return list;

            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapPart(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public SparePart getPartById(int partId) {
        String sql = "SELECT * FROM [SpareParts] WHERE part_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return null;

            ps = conn.prepareStatement(sql);
            ps.setInt(1, partId);
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapPart(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public int insertPart(SparePart part) {
        String sql = "INSERT INTO [SpareParts] (part_code, part_name, category, unit, unit_price, cost_price, quantity_in_stock, min_stock_alert, location, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return 0;

            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, part.getPartCode().toUpperCase().trim());
            ps.setString(2, part.getPartName());
            ps.setString(3, part.getCategory());
            ps.setString(4, part.getUnit());
            ps.setBigDecimal(5, part.getUnitPrice());
            ps.setBigDecimal(6, part.getCostPrice());
            ps.setInt(7, part.getQuantityInStock());
            ps.setInt(8, part.getMinStockAlert());
            ps.setString(9, part.getLocation());
            ps.setString(10, part.getStatus() != null ? part.getStatus() : "ACTIVE");
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

    public boolean updatePart(SparePart part) {
        String sql = "UPDATE [SpareParts] SET part_code = ?, part_name = ?, category = ?, unit = ?, unit_price = ?, cost_price = ?, quantity_in_stock = ?, min_stock_alert = ?, location = ?, status = ? " +
                     "WHERE part_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return false;

            ps = conn.prepareStatement(sql);
            ps.setString(1, part.getPartCode().toUpperCase().trim());
            ps.setString(2, part.getPartName());
            ps.setString(3, part.getCategory());
            ps.setString(4, part.getUnit());
            ps.setBigDecimal(5, part.getUnitPrice());
            ps.setBigDecimal(6, part.getCostPrice());
            ps.setInt(7, part.getQuantityInStock());
            ps.setInt(8, part.getMinStockAlert());
            ps.setString(9, part.getLocation());
            ps.setString(10, part.getStatus());
            ps.setInt(11, part.getPartId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBContext.close(conn, ps, null);
        }
    }

    public boolean updateStock(int partId, int quantityDiff) {
        String sql = "UPDATE [SpareParts] SET quantity_in_stock = quantity_in_stock + ? WHERE part_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return false;

            ps = conn.prepareStatement(sql);
            ps.setInt(1, quantityDiff);
            ps.setInt(2, partId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBContext.close(conn, ps, null);
        }
    }

    private SparePart mapPart(ResultSet rs) throws SQLException {
        return new SparePart(
                rs.getInt("part_id"),
                rs.getString("part_code"),
                rs.getString("part_name"),
                rs.getString("category"),
                rs.getString("unit"),
                rs.getBigDecimal("unit_price"),
                rs.getBigDecimal("cost_price"),
                rs.getInt("quantity_in_stock"),
                rs.getInt("min_stock_alert"),
                rs.getString("location"),
                rs.getString("status")
        );
    }
}
