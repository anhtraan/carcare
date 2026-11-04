package com.carecar.dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DBContext - Quản lý kết nối cơ sở dữ liệu Microsoft SQL Server 2019 / 2022
 */
public class DBContext {

    private static final Logger LOGGER = Logger.getLogger(DBContext.class.getName());

    // CẤU HÌNH KẾT NỐI DATABASE SQL SERVER
    // Mặc định port 1433 (SQL Server local) hoặc 14333 (Docker)
    private static final String SERVER_NAME = System.getProperty("DB_HOST",
            System.getenv().getOrDefault("DB_HOST", "localhost"));
    private static final String PORT_NUMBER = System.getProperty("DB_PORT",
            System.getenv().getOrDefault("DB_PORT", "1433"));
    private static final String DATABASE_NAME = System.getProperty("DB_NAME",
            System.getenv().getOrDefault("DB_NAME", "CareCarDB"));
    private static final String USERNAME = System.getProperty("DB_USER", System.getenv().getOrDefault("DB_USER", "sa"));
    private static final String PASSWORD = System.getProperty("DB_PASSWORD",
            System.getenv().getOrDefault("DB_PASSWORD", "Bboytqa1@"));

    /**
     * Mở kết nối tới SQL Server
     */
    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://" + SERVER_NAME + ":" + PORT_NUMBER
                    + ";databaseName=" + DATABASE_NAME
                    + ";encrypt=true;trustServerCertificate=true";
            conn = DriverManager.getConnection(url, USERNAME, PASSWORD);
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE,
                    "Không tìm thấy Microsoft SQL Server JDBC Driver! Hãy đảm bảo mssql-jdbc jar có trong WEB-INF/lib",
                    e);
        } catch (SQLException e) {
            // Tự động thử fallback port (1433 <-> 14333) nếu chạy trên localhost
            if ("localhost".equalsIgnoreCase(SERVER_NAME) || "127.0.0.1".equals(SERVER_NAME)) {
                String fallbackPort = "1433".equals(PORT_NUMBER) ? "14333" : "1433";
                try {
                    String fallbackUrl = "jdbc:sqlserver://" + SERVER_NAME + ":" + fallbackPort
                            + ";databaseName=" + DATABASE_NAME
                            + ";encrypt=true;trustServerCertificate=true";
                    conn = DriverManager.getConnection(fallbackUrl, USERNAME, PASSWORD);
                    return conn;
                } catch (SQLException ignored) {
                }
            }
            LOGGER.log(Level.SEVERE,
                    "Lỗi kết nối SQL Server! Hãy kiểm tra SQL Server Service đang chạy và user/pass (sa)", e);
        }
        return conn;
    }

    /**
     * Đóng tài nguyên an toàn
     */
    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null && !rs.isClosed()) {
                rs.close();
            }
        } catch (SQLException ignored) {
        }
        try {
            if (stmt != null && !stmt.isClosed()) {
                stmt.close();
            }
        } catch (SQLException ignored) {
        }
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        } catch (SQLException ignored) {
        }
    }

    /**
     * Hàm main test nhanh kết nối từ NetBeans (Click chuột phải -> Run File)
     */
    public static void main(String[] args) {
        Connection conn = getConnection();
        if (conn != null) {
            System.out.println(" KẾT NỐI THÀNH CÔNG TỚI DATABASE CARECAR (SQL SERVER)!");
            close(conn, null, null);
        } else {
            System.err.println(
                    "❌ KẾT NỐI THẤT BẠI! Vui lòng kiểm tra lại cấu hình tài khoản sa / mật khẩu và script SQL.");
        }
    }
}
