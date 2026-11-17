package com.linkstatic.quiz.dao;

import com.linkstatic.quiz.model.Quiz;
import com.linkstatic.quiz.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * QuizDAO — Data Access Object for quiz operations.
 */
public class QuizDAO {

    // ── Retrieve ─────────────────────────────────────────────────────────────

    public List<Quiz> getAllActiveQuizzes() {
        List<Quiz> quizzes = new ArrayList<>();
        String sql = "SELECT * FROM quizzes WHERE is_active = 1 ORDER BY created_at DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) quizzes.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("[QuizDAO] getAllActiveQuizzes error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return quizzes;
    }

    public List<Quiz> getAllQuizzes() {
        List<Quiz> quizzes = new ArrayList<>();
        String sql = "SELECT * FROM quizzes ORDER BY created_at DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) quizzes.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("[QuizDAO] getAllQuizzes error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return quizzes;
    }

    public Quiz getQuizById(int id) {
        String sql = "SELECT * FROM quizzes WHERE id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("[QuizDAO] getQuizById error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return null;
    }

    // ── Create ───────────────────────────────────────────────────────────────

    public boolean addQuiz(Quiz quiz) {
        String sql = "INSERT INTO quizzes (title, description, category, time_limit, total_questions, is_active) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, quiz.getTitle());
            ps.setString(2, quiz.getDescription());
            ps.setString(3, quiz.getCategory());
            ps.setInt(4, quiz.getTimeLimit());
            ps.setInt(5, quiz.getTotalQuestions());
            ps.setBoolean(6, quiz.isActive());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[QuizDAO] addQuiz error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ── Update ───────────────────────────────────────────────────────────────

    public boolean updateQuiz(Quiz quiz) {
        String sql = "UPDATE quizzes SET title=?, description=?, category=?, time_limit=?, total_questions=?, is_active=? WHERE id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, quiz.getTitle());
            ps.setString(2, quiz.getDescription());
            ps.setString(3, quiz.getCategory());
            ps.setInt(4, quiz.getTimeLimit());
            ps.setInt(5, quiz.getTotalQuestions());
            ps.setBoolean(6, quiz.isActive());
            ps.setInt(7, quiz.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[QuizDAO] updateQuiz error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ── Delete ───────────────────────────────────────────────────────────────

    public boolean deleteQuiz(int id) {
        String sql = "DELETE FROM quizzes WHERE id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[QuizDAO] deleteQuiz error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    /** Updates total_questions count for a quiz */
    public void updateQuestionCount(int quizId) {
        String sql = "UPDATE quizzes SET total_questions = (SELECT COUNT(*) FROM questions WHERE quiz_id = ?) WHERE id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, quizId);
            ps.setInt(2, quizId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("[QuizDAO] updateQuestionCount error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ── Helper ───────────────────────────────────────────────────────────────

    private Quiz mapRow(ResultSet rs) throws SQLException {
        Quiz q = new Quiz();
        q.setId(rs.getInt("id"));
        q.setTitle(rs.getString("title"));
        q.setDescription(rs.getString("description"));
        q.setCategory(rs.getString("category"));
        q.setTimeLimit(rs.getInt("time_limit"));
        q.setTotalQuestions(rs.getInt("total_questions"));
        q.setActive(rs.getBoolean("is_active"));
        q.setCreatedAt(rs.getTimestamp("created_at"));
        return q;
    }
}
