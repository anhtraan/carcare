package com.carecar.dal;

import com.carecar.model.Appointment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AppointmentDAO {

    private static final Logger LOGGER = Logger.getLogger(AppointmentDAO.class.getName());
    private static final String SELECT_COLUMNS = "SELECT appointment_id, customer_id, car_id, customer_name, phone, license_plate, car_brand_model, appointment_date, time_slot, requested_service, notes, status, created_at FROM [Appointments] ";

    public List<Appointment> getAllAppointments() {
        List<Appointment> list = new ArrayList<>();
        String sql = SELECT_COLUMNS + "ORDER BY appointment_date DESC, created_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return list;

            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapAppointment(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi lấy tất cả cuộc hẹn", e);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public List<Appointment> getTodayAppointments() {
        List<Appointment> list = new ArrayList<>();
        String sql = SELECT_COLUMNS + "WHERE appointment_date = CAST(GETDATE() AS DATE) ORDER BY time_slot ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return list;

            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapAppointment(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi lấy cuộc hẹn hôm nay", e);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public List<Appointment> getCustomerAppointments(int customerId) {
        List<Appointment> list = new ArrayList<>();
        String sql = SELECT_COLUMNS + "WHERE customer_id = ? ORDER BY appointment_date DESC";
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
                list.add(mapAppointment(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, e, () -> "Lỗi lấy cuộc hẹn của khách hàng: " + customerId);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public Appointment getAppointmentById(int appointmentId) {
        String sql = SELECT_COLUMNS + "WHERE appointment_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return null;

            ps = conn.prepareStatement(sql);
            ps.setInt(1, appointmentId);
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapAppointment(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, e, () -> "Lỗi lấy cuộc hẹn theo ID: " + appointmentId);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public int insertAppointment(Appointment a) {
        String sql = "INSERT INTO [Appointments] (customer_id, car_id, customer_name, phone, license_plate, car_brand_model, appointment_date, time_slot, requested_service, notes, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return 0;

            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            if (a.getCustomerId() != null) {
                ps.setInt(1, a.getCustomerId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            if (a.getCarId() != null) {
                ps.setInt(2, a.getCarId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setString(3, a.getCustomerName());
            ps.setString(4, a.getPhone());
            ps.setString(5, a.getLicensePlate().toUpperCase().trim());
            ps.setString(6, a.getCarBrandModel());
            ps.setDate(7, a.getAppointmentDate());
            ps.setString(8, a.getTimeSlot());
            ps.setString(9, a.getRequestedService());
            ps.setString(10, a.getNotes());
            ps.setString(11, a.getStatus() != null ? a.getStatus() : "PENDING");
            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi thêm cuộc hẹn mới", e);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return 0;
    }

    public boolean updateStatus(int appointmentId, String status) {
        String sql = "UPDATE [Appointments] SET status = ? WHERE appointment_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return false;

            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, appointmentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, e, () -> "Lỗi cập nhật trạng thái cuộc hẹn: " + appointmentId);
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    private Appointment mapAppointment(ResultSet rs) throws SQLException {
        Integer custId = rs.getObject("customer_id") != null ? rs.getInt("customer_id") : null;
        Integer carId = rs.getObject("car_id") != null ? rs.getInt("car_id") : null;
        return new Appointment(
                rs.getInt("appointment_id"),
                custId,
                carId,
                rs.getString("customer_name"),
                rs.getString("phone"),
                rs.getString("license_plate"),
                rs.getString("car_brand_model"),
                rs.getDate("appointment_date"),
                rs.getString("time_slot"),
                rs.getString("requested_service"),
                rs.getString("notes"),
                rs.getString("status"),
                rs.getTimestamp("created_at")
        );
    }
}
