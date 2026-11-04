package com.carecar.dal;

import com.carecar.model.RepairOrder;
import com.carecar.model.RepairOrderPart;
import com.carecar.model.RepairOrderService;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class RepairOrderDAO {

    public List<RepairOrder> getAllOrders() {
        List<RepairOrder> list = new ArrayList<>();
        String sql = "SELECT ro.*, " +
                     "       cust.full_name AS customer_name, cust.phone AS customer_phone, cust.address AS customer_address, " +
                     "       c.license_plate, c.brand AS car_brand, c.model AS car_model, c.color AS car_color, " +
                     "       u_rec.full_name AS receptionist_name, u_mech.full_name AS mechanic_name " +
                     "FROM [RepairOrders] ro " +
                     "JOIN [Customers] cust ON ro.customer_id = cust.customer_id " +
                     "JOIN [Cars] c ON ro.car_id = c.car_id " +
                     "LEFT JOIN [Users] u_rec ON ro.receptionist_id = u_rec.user_id " +
                     "LEFT JOIN [Users] u_mech ON ro.mechanic_id = u_mech.user_id " +
                     "ORDER BY ro.entry_date DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return list;

            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public List<RepairOrder> getOrdersByStatus(String status) {
        List<RepairOrder> list = new ArrayList<>();
        String sql = "SELECT ro.*, " +
                     "       cust.full_name AS customer_name, cust.phone AS customer_phone, cust.address AS customer_address, " +
                     "       c.license_plate, c.brand AS car_brand, c.model AS car_model, c.color AS car_color, " +
                     "       u_rec.full_name AS receptionist_name, u_mech.full_name AS mechanic_name " +
                     "FROM [RepairOrders] ro " +
                     "JOIN [Customers] cust ON ro.customer_id = cust.customer_id " +
                     "JOIN [Cars] c ON ro.car_id = c.car_id " +
                     "LEFT JOIN [Users] u_rec ON ro.receptionist_id = u_rec.user_id " +
                     "LEFT JOIN [Users] u_mech ON ro.mechanic_id = u_mech.user_id " +
                     "WHERE ro.order_status = ? " +
                     "ORDER BY ro.entry_date DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return list;

            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public RepairOrder getOrderById(int orderId) {
        String sql = "SELECT ro.*, " +
                     "       cust.full_name AS customer_name, cust.phone AS customer_phone, cust.address AS customer_address, " +
                     "       c.license_plate, c.brand AS car_brand, c.model AS car_model, c.color AS car_color, " +
                     "       u_rec.full_name AS receptionist_name, u_mech.full_name AS mechanic_name " +
                     "FROM [RepairOrders] ro " +
                     "JOIN [Customers] cust ON ro.customer_id = cust.customer_id " +
                     "JOIN [Cars] c ON ro.car_id = c.car_id " +
                     "LEFT JOIN [Users] u_rec ON ro.receptionist_id = u_rec.user_id " +
                     "LEFT JOIN [Users] u_mech ON ro.mechanic_id = u_mech.user_id " +
                     "WHERE ro.order_id = ?";
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
                RepairOrder order = mapOrder(rs);
                order.setServices(getServicesByOrderId(orderId));
                order.setParts(getPartsByOrderId(orderId));
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public RepairOrder getOrderByCode(String orderCode) {
        String sql = "SELECT ro.*, " +
                     "       cust.full_name AS customer_name, cust.phone AS customer_phone, cust.address AS customer_address, " +
                     "       c.license_plate, c.brand AS car_brand, c.model AS car_model, c.color AS car_color, " +
                     "       u_rec.full_name AS receptionist_name, u_mech.full_name AS mechanic_name " +
                     "FROM [RepairOrders] ro " +
                     "JOIN [Customers] cust ON ro.customer_id = cust.customer_id " +
                     "JOIN [Cars] c ON ro.car_id = c.car_id " +
                     "LEFT JOIN [Users] u_rec ON ro.receptionist_id = u_rec.user_id " +
                     "LEFT JOIN [Users] u_mech ON ro.mechanic_id = u_mech.user_id " +
                     "WHERE UPPER(ro.order_code) = UPPER(?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return null;

            ps = conn.prepareStatement(sql);
            ps.setString(1, orderCode.trim());
            rs = ps.executeQuery();

            if (rs.next()) {
                RepairOrder order = mapOrder(rs);
                order.setServices(getServicesByOrderId(order.getOrderId()));
                order.setParts(getPartsByOrderId(order.getOrderId()));
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public List<RepairOrder> getOrdersByLicensePlate(String licensePlate) {
        List<RepairOrder> list = new ArrayList<>();
        String sql = "SELECT ro.*, " +
                     "       cust.full_name AS customer_name, cust.phone AS customer_phone, cust.address AS customer_address, " +
                     "       c.license_plate, c.brand AS car_brand, c.model AS car_model, c.color AS car_color, " +
                     "       u_rec.full_name AS receptionist_name, u_mech.full_name AS mechanic_name " +
                     "FROM [RepairOrders] ro " +
                     "JOIN [Customers] cust ON ro.customer_id = cust.customer_id " +
                     "JOIN [Cars] c ON ro.car_id = c.car_id " +
                     "LEFT JOIN [Users] u_rec ON ro.receptionist_id = u_rec.user_id " +
                     "LEFT JOIN [Users] u_mech ON ro.mechanic_id = u_mech.user_id " +
                     "WHERE UPPER(REPLACE(c.license_plate, '-', '')) = UPPER(REPLACE(?, '-', '')) " +
                     "   OR UPPER(c.license_plate) = UPPER(?) " +
                     "ORDER BY ro.entry_date DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return list;

            ps = conn.prepareStatement(sql);
            ps.setString(1, licensePlate.trim());
            ps.setString(2, licensePlate.trim());
            rs = ps.executeQuery();

            while (rs.next()) {
                RepairOrder order = mapOrder(rs);
                order.setServices(getServicesByOrderId(order.getOrderId()));
                order.setParts(getPartsByOrderId(order.getOrderId()));
                list.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public List<RepairOrder> getOrdersByCustomerId(int customerId) {
        List<RepairOrder> list = new ArrayList<>();
        String sql = "SELECT ro.*, " +
                     "       cust.full_name AS customer_name, cust.phone AS customer_phone, cust.address AS customer_address, " +
                     "       c.license_plate, c.brand AS car_brand, c.model AS car_model, c.color AS car_color, " +
                     "       u_rec.full_name AS receptionist_name, u_mech.full_name AS mechanic_name " +
                     "FROM [RepairOrders] ro " +
                     "JOIN [Customers] cust ON ro.customer_id = cust.customer_id " +
                     "JOIN [Cars] c ON ro.car_id = c.car_id " +
                     "LEFT JOIN [Users] u_rec ON ro.receptionist_id = u_rec.user_id " +
                     "LEFT JOIN [Users] u_mech ON ro.mechanic_id = u_mech.user_id " +
                     "WHERE ro.customer_id = ? " +
                     "ORDER BY ro.entry_date DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return list;

            ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public int createRepairOrder(RepairOrder ro) {
        String sql = "INSERT INTO [RepairOrders] (order_code, customer_id, car_id, receptionist_id, mechanic_id, entry_date, expected_finish_date, entry_mileage, initial_diagnosis, technician_notes, total_service_cost, total_part_cost, discount_amount, tax_vat, grand_total, order_status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return 0;

            String code = generateOrderCode(conn);
            ro.setOrderCode(code);

            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, code);
            ps.setInt(2, ro.getCustomerId());
            ps.setInt(3, ro.getCarId());
            if (ro.getReceptionistId() != null) {
                ps.setInt(4, ro.getReceptionistId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            if (ro.getMechanicId() != null) {
                ps.setInt(5, ro.getMechanicId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.setTimestamp(6, ro.getEntryDate() != null ? ro.getEntryDate() : new Timestamp(System.currentTimeMillis()));
            ps.setTimestamp(7, ro.getExpectedFinishDate());
            if (ro.getEntryMileage() != null) {
                ps.setInt(8, ro.getEntryMileage());
            } else {
                ps.setNull(8, Types.INTEGER);
            }
            ps.setString(9, ro.getInitialDiagnosis());
            ps.setString(10, ro.getTechnicianNotes());
            ps.setBigDecimal(11, ro.getTotalServiceCost());
            ps.setBigDecimal(12, ro.getTotalPartCost());
            ps.setBigDecimal(13, ro.getDiscountAmount());
            ps.setBigDecimal(14, ro.getTaxVat());
            ps.setBigDecimal(15, ro.getGrandTotal());
            ps.setString(16, ro.getOrderStatus() != null ? ro.getOrderStatus() : "PENDING_INSPECTION");
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

    public boolean updateOrderDiagnosis(int orderId, String initialDiagnosis, String technicianNotes, Integer mechanicId, Timestamp expectedFinish) {
        String sql = "UPDATE [RepairOrders] SET initial_diagnosis = ?, technician_notes = ?, mechanic_id = ?, expected_finish_date = ? WHERE order_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return false;

            ps = conn.prepareStatement(sql);
            ps.setString(1, initialDiagnosis);
            ps.setString(2, technicianNotes);
            if (mechanicId != null) {
                ps.setInt(3, mechanicId);
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setTimestamp(4, expectedFinish);
            ps.setInt(5, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBContext.close(conn, ps, null);
        }
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE [RepairOrders] SET order_status = ?, actual_finish_date = CASE WHEN ? IN ('COMPLETED_WAITING_PAYMENT', 'PAID_DELIVERED') AND actual_finish_date IS NULL THEN GETDATE() ELSE actual_finish_date END WHERE order_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return false;

            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, status);
            ps.setInt(3, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBContext.close(conn, ps, null);
        }
    }

    public boolean addServiceToOrder(int orderId, int serviceId, String serviceName, BigDecimal price, int quantity, String notes) {
        String sql = "INSERT INTO [RepairOrderServices] (order_id, service_id, service_name, price, quantity, notes) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return false;

            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            ps.setInt(2, serviceId);
            ps.setString(3, serviceName);
            ps.setBigDecimal(4, price);
            ps.setInt(5, quantity);
            ps.setString(6, notes);
            int res = ps.executeUpdate();
            if (res > 0) {
                recalculateOrderTotals(orderId);
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    public boolean removeServiceFromOrder(int orderServiceId, int orderId) {
        String sql = "DELETE FROM [RepairOrderServices] WHERE order_service_id = ? AND order_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return false;

            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderServiceId);
            ps.setInt(2, orderId);
            int res = ps.executeUpdate();
            if (res > 0) {
                recalculateOrderTotals(orderId);
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    public boolean addPartToOrder(int orderId, int partId, String partCode, String partName, BigDecimal unitPrice, int quantity, String notes) {
        String sqlPart = "INSERT INTO [RepairOrderParts] (order_id, part_id, part_code, part_name, unit_price, quantity, notes) VALUES (?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return false;

            ps = conn.prepareStatement(sqlPart);
            ps.setInt(1, orderId);
            ps.setInt(2, partId);
            ps.setString(3, partCode);
            ps.setString(4, partName);
            ps.setBigDecimal(5, unitPrice);
            ps.setInt(6, quantity);
            ps.setString(7, notes);
            int res = ps.executeUpdate();

            if (res > 0) {
                // Deduct stock in warehouse
                SparePartDAO partDAO = new SparePartDAO();
                partDAO.updateStock(partId, -quantity);
                recalculateOrderTotals(orderId);
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    public boolean removePartFromOrder(int orderPartId, int orderId, int partId, int quantity) {
        String sql = "DELETE FROM [RepairOrderParts] WHERE order_part_id = ? AND order_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return false;

            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderPartId);
            ps.setInt(2, orderId);
            int res = ps.executeUpdate();
            if (res > 0) {
                // Refund stock in warehouse
                SparePartDAO partDAO = new SparePartDAO();
                partDAO.updateStock(partId, quantity);
                recalculateOrderTotals(orderId);
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    public void recalculateOrderTotals(int orderId) {
        String sqlServiceSum = "SELECT ISNULL(SUM(price * quantity), 0) AS total_service FROM [RepairOrderServices] WHERE order_id = ?";
        String sqlPartSum = "SELECT ISNULL(SUM(unit_price * quantity), 0) AS total_part FROM [RepairOrderParts] WHERE order_id = ?";
        String sqlUpdate = "UPDATE [RepairOrders] SET total_service_cost = ?, total_part_cost = ?, " +
                           "       grand_total = (? + ? - ISNULL(discount_amount, 0) + ISNULL(tax_vat, 0)) " +
                           "WHERE order_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return;

            BigDecimal totalService = BigDecimal.ZERO;
            ps = conn.prepareStatement(sqlServiceSum);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();
            if (rs.next()) {
                totalService = rs.getBigDecimal("total_service");
            }
            DBContext.close(null, ps, rs);

            BigDecimal totalPart = BigDecimal.ZERO;
            ps = conn.prepareStatement(sqlPartSum);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();
            if (rs.next()) {
                totalPart = rs.getBigDecimal("total_part");
            }
            DBContext.close(null, ps, rs);

            ps = conn.prepareStatement(sqlUpdate);
            ps.setBigDecimal(1, totalService);
            ps.setBigDecimal(2, totalPart);
            ps.setBigDecimal(3, totalService);
            ps.setBigDecimal(4, totalPart);
            ps.setInt(5, orderId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
    }

    public boolean updateDiscountAndTax(int orderId, BigDecimal discount, BigDecimal tax) {
        String sql = "UPDATE [RepairOrders] SET discount_amount = ?, tax_vat = ?, " +
                     "       grand_total = (ISNULL(total_service_cost, 0) + ISNULL(total_part_cost, 0) - ? + ?) " +
                     "WHERE order_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return false;

            ps = conn.prepareStatement(sql);
            ps.setBigDecimal(1, discount);
            ps.setBigDecimal(2, tax);
            ps.setBigDecimal(3, discount);
            ps.setBigDecimal(4, tax);
            ps.setInt(5, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBContext.close(conn, ps, null);
        }
    }

    public List<RepairOrderService> getServicesByOrderId(int orderId) {
        List<RepairOrderService> list = new ArrayList<>();
        String sql = "SELECT * FROM [RepairOrderServices] WHERE order_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return list;

            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new RepairOrderService(
                        rs.getInt("order_service_id"),
                        rs.getInt("order_id"),
                        rs.getInt("service_id"),
                        rs.getString("service_name"),
                        rs.getBigDecimal("price"),
                        rs.getInt("quantity"),
                        rs.getBigDecimal("subtotal"),
                        rs.getString("notes")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public List<RepairOrderPart> getPartsByOrderId(int orderId) {
        List<RepairOrderPart> list = new ArrayList<>();
        String sql = "SELECT * FROM [RepairOrderParts] WHERE order_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return list;

            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new RepairOrderPart(
                        rs.getInt("order_part_id"),
                        rs.getInt("order_id"),
                        rs.getInt("part_id"),
                        rs.getString("part_code"),
                        rs.getString("part_name"),
                        rs.getBigDecimal("unit_price"),
                        rs.getInt("quantity"),
                        rs.getBigDecimal("subtotal"),
                        rs.getString("notes")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    private String generateOrderCode(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM [RepairOrders]";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            int count = 1;
            if (rs.next()) {
                count = rs.getInt(1) + 1;
            }
            return String.format("CC-2026-%04d", count);
        }
    }

    private RepairOrder mapOrder(ResultSet rs) throws SQLException {
        RepairOrder ro = new RepairOrder();
        ro.setOrderId(rs.getInt("order_id"));
        ro.setOrderCode(rs.getString("order_code"));
        ro.setCustomerId(rs.getInt("customer_id"));
        ro.setCarId(rs.getInt("car_id"));
        ro.setReceptionistId(rs.getObject("receptionist_id") != null ? rs.getInt("receptionist_id") : null);
        ro.setMechanicId(rs.getObject("mechanic_id") != null ? rs.getInt("mechanic_id") : null);
        ro.setEntryDate(rs.getTimestamp("entry_date"));
        ro.setExpectedFinishDate(rs.getTimestamp("expected_finish_date"));
        ro.setActualFinishDate(rs.getTimestamp("actual_finish_date"));
        ro.setEntryMileage(rs.getObject("entry_mileage") != null ? rs.getInt("entry_mileage") : null);
        ro.setInitialDiagnosis(rs.getString("initial_diagnosis"));
        ro.setTechnicianNotes(rs.getString("technician_notes"));
        ro.setTotalServiceCost(rs.getBigDecimal("total_service_cost"));
        ro.setTotalPartCost(rs.getBigDecimal("total_part_cost"));
        ro.setDiscountAmount(rs.getBigDecimal("discount_amount"));
        ro.setTaxVat(rs.getBigDecimal("tax_vat"));
        ro.setGrandTotal(rs.getBigDecimal("grand_total"));
        ro.setOrderStatus(rs.getString("order_status"));
        ro.setCreatedAt(rs.getTimestamp("created_at"));

        try {
            ro.setCustomerName(rs.getString("customer_name"));
            ro.setCustomerPhone(rs.getString("customer_phone"));
            ro.setCustomerAddress(rs.getString("customer_address"));
            ro.setCarLicensePlate(rs.getString("license_plate"));
            ro.setCarBrand(rs.getString("car_brand"));
            ro.setCarModel(rs.getString("car_model"));
            ro.setColor(rs.getString("car_color"));
            ro.setReceptionistName(rs.getString("receptionist_name"));
            ro.setMechanicName(rs.getString("mechanic_name"));
        } catch (SQLException ignored) {
        }
        return ro;
    }
}
