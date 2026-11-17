package com.linkstatic.quiz.dao;

import com.linkstatic.quiz.model.Admin;
import com.linkstatic.quiz.util.DBConnection;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.sql.*;

/**
 * AdminDAO — Data Access Object for admin authentication.
 */
public class AdminDAO {

    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] digest = md.digest(password.getBytes("UTF-8"));
            BigInteger no = new BigInteger(1, digest);
            StringBuilder sb = new StringBuilder(no.toString(16));
            while (sb.length() < 32) sb.insert(0, '0');
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }

    /**
     * Validates admin login credentials.
     */
    public Admin validateAdminLogin(String username, String password) {
        String sql = "SELECT * FROM admins WHERE username = ? AND password = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, hashPassword(password));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Admin admin = new Admin();
                admin.setId(rs.getInt("id"));
                admin.setUsername(rs.getString("username"));
                admin.setEmail(rs.getString("email"));
                admin.setPassword(rs.getString("password"));
                admin.setFullName(rs.getString("full_name"));
                admin.setCreatedAt(rs.getTimestamp("created_at"));
                return admin;
            }
        } catch (SQLException e) {
            System.err.println("[AdminDAO] validateAdminLogin error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return null;
    }
}
