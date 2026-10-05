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
    // Thay đổi thông tin bên dưới nếu bạn dùng port hoặc mật khẩu khác
    private static final String SERVER_NAME = "localhost";
    private static final String PORT_NUMBER = "14333";
    private static final String DATABASE_NAME = "CareCarDB";
    private static final String USERNAME = "sa";
    private static final String PASSWORD = "Bboytqa1@"; // Mật khẩu sa SQL Server (Docker)

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
            LOGGER.log(Level.SEVERE, "Không tìm thấy Microsoft SQL Server JDBC Driver! Hãy đảm bảo mssql-jdbc jar có trong WEB-INF/lib", e);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi kết nối SQL Server! Hãy kiểm tra SQL Server Service đang chạy và user/pass (sa)", e);
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
            System.err.println("❌ KẾT NỐI THẤT BẠI! Vui lòng kiểm tra lại cấu hình tài khoản sa / mật khẩu và script SQL.");
        }
    }
}
