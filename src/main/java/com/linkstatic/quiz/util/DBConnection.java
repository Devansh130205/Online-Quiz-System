package com.linkstatic.quiz.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection - Singleton database connection utility.
 * Provides a JDBC connection to the online_quiz_system MySQL database.
 *
 * CONFIGURATION: Update DB_URL, DB_USER, DB_PASSWORD before running.
 */
public class DBConnection {

    // ── Database Configuration ────────────────────────────────────────────────
    private static final String DB_URL      = "jdbc:mysql://localhost:3306/online_quiz_system?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String DB_USER     = "root";
    private static final String DB_PASSWORD = "root";   // <-- Change to your MySQL password
    private static final String DB_DRIVER   = "com.mysql.cj.jdbc.Driver";

    // Private constructor — utility class
    private DBConnection() {}

    /**
     * Returns a new JDBC connection. Caller is responsible for closing it.
     */
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName(DB_DRIVER);
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found. Add mysql-connector-j to classpath.", e);
        }
    }

    /**
     * Safely closes a connection (null-safe).
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("[DBConnection] Error closing connection: " + e.getMessage());
            }
        }
    }

    /**
     * Tests the database connection. Used during startup verification.
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            System.err.println("[DBConnection] Connection test FAILED: " + e.getMessage());
            return false;
        }
    }
}
