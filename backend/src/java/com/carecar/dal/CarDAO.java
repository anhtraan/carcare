package com.carecar.dal;

import com.carecar.model.Car;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class CarDAO {

    public List<Car> getAllCars() {
        List<Car> list = new ArrayList<>();
        String sql = "SELECT c.*, cust.full_name AS customer_name, cust.phone AS customer_phone " +
                     "FROM [Cars] c " +
                     "JOIN [Customers] cust ON c.customer_id = cust.customer_id " +
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
                list.add(mapCar(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public Car getCarById(int carId) {
        String sql = "SELECT c.*, cust.full_name AS customer_name, cust.phone AS customer_phone " +
                     "FROM [Cars] c " +
                     "JOIN [Customers] cust ON c.customer_id = cust.customer_id " +
                     "WHERE c.car_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return null;

            ps = conn.prepareStatement(sql);
            ps.setInt(1, carId);
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapCar(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public Car getCarByLicensePlate(String licensePlate) {
        String sql = "SELECT c.*, cust.full_name AS customer_name, cust.phone AS customer_phone " +
                     "FROM [Cars] c " +
                     "JOIN [Customers] cust ON c.customer_id = cust.customer_id " +
                     "WHERE UPPER(REPLACE(c.license_plate, '-', '')) = UPPER(REPLACE(?, '-', '')) " +
                     "   OR UPPER(c.license_plate) = UPPER(?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return null;

            ps = conn.prepareStatement(sql);
            ps.setString(1, licensePlate.trim());
            ps.setString(2, licensePlate.trim());
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapCar(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public List<Car> getCarsByCustomerId(int customerId) {
        List<Car> list = new ArrayList<>();
        String sql = "SELECT c.*, cust.full_name AS customer_name, cust.phone AS customer_phone " +
                     "FROM [Cars] c " +
                     "JOIN [Customers] cust ON c.customer_id = cust.customer_id " +
                     "WHERE c.customer_id = ? " +
                     "ORDER BY c.created_at DESC";
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
                list.add(mapCar(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public int insertCar(Car car) {
        String sql = "INSERT INTO [Cars] (customer_id, license_plate, brand, model, year_manufactured, color, vin_number, current_mileage, notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return 0;

            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, car.getCustomerId());
            ps.setString(2, car.getLicensePlate().toUpperCase().trim());
            ps.setString(3, car.getBrand());
            ps.setString(4, car.getModel());
            if (car.getYearManufactured() != null) {
                ps.setInt(5, car.getYearManufactured());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.setString(6, car.getColor());
            ps.setString(7, car.getVinNumber());
            ps.setInt(8, car.getCurrentMileage());
            ps.setString(9, car.getNotes());
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

    public boolean updateCar(Car car) {
        String sql = "UPDATE [Cars] SET license_plate = ?, brand = ?, model = ?, year_manufactured = ?, color = ?, vin_number = ?, current_mileage = ?, notes = ? " +
                     "WHERE car_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return false;

            ps = conn.prepareStatement(sql);
            ps.setString(1, car.getLicensePlate().toUpperCase().trim());
            ps.setString(2, car.getBrand());
            ps.setString(3, car.getModel());
            if (car.getYearManufactured() != null) {
                ps.setInt(4, car.getYearManufactured());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setString(5, car.getColor());
            ps.setString(6, car.getVinNumber());
            ps.setInt(7, car.getCurrentMileage());
            ps.setString(8, car.getNotes());
            ps.setInt(9, car.getCarId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBContext.close(conn, ps, null);
        }
    }

    public boolean updateMileage(int carId, int mileage) {
        String sql = "UPDATE [Cars] SET current_mileage = ? WHERE car_id = ? AND current_mileage < ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return false;

            ps = conn.prepareStatement(sql);
            ps.setInt(1, mileage);
            ps.setInt(2, carId);
            ps.setInt(3, mileage);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBContext.close(conn, ps, null);
        }
    }

    private Car mapCar(ResultSet rs) throws SQLException {
        Integer year = rs.getObject("year_manufactured") != null ? rs.getInt("year_manufactured") : null;
        Car car = new Car(
                rs.getInt("car_id"),
                rs.getInt("customer_id"),
                rs.getString("license_plate"),
                rs.getString("brand"),
                rs.getString("model"),
                year,
                rs.getString("color"),
                rs.getString("vin_number"),
                rs.getInt("current_mileage"),
                rs.getString("notes"),
                rs.getTimestamp("created_at")
        );
        try {
            car.setCustomerName(rs.getString("customer_name"));
            car.setCustomerPhone(rs.getString("customer_phone"));
        } catch (SQLException ignored) {
        }
        return car;
    }
}
