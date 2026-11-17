package com.linkstatic.quiz.dao;

import com.linkstatic.quiz.model.QuizAnswer;
import com.linkstatic.quiz.model.Result;
import com.linkstatic.quiz.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ResultDAO — Data Access Object for quiz results and answers.
 */
public class ResultDAO {

    // ── Save Result ──────────────────────────────────────────────────────────

    /**
     * Saves a quiz result and returns the generated result ID.
     * Returns -1 on failure.
     */
    public int saveResult(Result result) {
        String sql = "INSERT INTO quiz_results (user_id, quiz_id, score, total_marks, percentage, time_taken) VALUES (?,?,?,?,?,?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, result.getUserId());
            ps.setInt(2, result.getQuizId());
            ps.setInt(3, result.getScore());
            ps.setInt(4, result.getTotalMarks());
            ps.setDouble(5, result.getPercentage());
            ps.setInt(6, result.getTimeTaken());
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
        } catch (SQLException e) {
            System.err.println("[ResultDAO] saveResult error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return -1;
    }

    // ── Save Answers ─────────────────────────────────────────────────────────

    public void saveAnswers(List<QuizAnswer> answers) {
        String sql = "INSERT INTO quiz_answers (result_id, question_id, selected_answer, is_correct) VALUES (?,?,?,?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            PreparedStatement ps = conn.prepareStatement(sql);
            for (QuizAnswer ans : answers) {
                ps.setInt(1, ans.getResultId());
                ps.setInt(2, ans.getQuestionId());
                ps.setString(3, ans.getSelectedAnswer());
                ps.setBoolean(4, ans.isCorrect());
                ps.addBatch();
            }
            ps.executeBatch();
            conn.commit();
        } catch (SQLException e) {
            System.err.println("[ResultDAO] saveAnswers error: " + e.getMessage());
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { /* ignore */ }
            }
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ── Retrieve ─────────────────────────────────────────────────────────────

    public Result getResultById(int resultId) {
        String sql = "SELECT r.*, u.username, qz.title AS quiz_title " +
                     "FROM quiz_results r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "JOIN quizzes qz ON r.quiz_id = qz.id " +
                     "WHERE r.id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, resultId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("[ResultDAO] getResultById error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return null;
    }

    public List<Result> getResultsByUserId(int userId) {
        List<Result> list = new ArrayList<>();
        String sql = "SELECT r.*, u.username, qz.title AS quiz_title " +
                     "FROM quiz_results r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "JOIN quizzes qz ON r.quiz_id = qz.id " +
                     "WHERE r.user_id = ? ORDER BY r.attempt_date DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("[ResultDAO] getResultsByUserId error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    public List<Result> getAllResults() {
        List<Result> list = new ArrayList<>();
        String sql = "SELECT r.*, u.username, qz.title AS quiz_title " +
                     "FROM quiz_results r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "JOIN quizzes qz ON r.quiz_id = qz.id " +
                     "ORDER BY r.attempt_date DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("[ResultDAO] getAllResults error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    /**
     * Counts how many times a user has attempted a specific quiz in the current session day.
     * Used to prevent double-submission.
     */
    public boolean hasAttemptedQuiz(int userId, int quizId) {
        String sql = "SELECT COUNT(*) FROM quiz_results WHERE user_id = ? AND quiz_id = ? AND DATE(attempt_date) = CURDATE()";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, quizId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            System.err.println("[ResultDAO] hasAttemptedQuiz error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return false;
    }

    public List<QuizAnswer> getAnswersByResultId(int resultId) {
        List<QuizAnswer> list = new ArrayList<>();
        String sql = "SELECT * FROM quiz_answers WHERE result_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, resultId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                QuizAnswer a = new QuizAnswer();
                a.setId(rs.getInt("id"));
                a.setResultId(rs.getInt("result_id"));
                a.setQuestionId(rs.getInt("question_id"));
                a.setSelectedAnswer(rs.getString("selected_answer"));
                a.setCorrect(rs.getBoolean("is_correct"));
                list.add(a);
            }
        } catch (SQLException e) {
            System.err.println("[ResultDAO] getAnswersByResultId error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // ── Helper ───────────────────────────────────────────────────────────────

    private Result mapRow(ResultSet rs) throws SQLException {
        Result r = new Result();
        r.setId(rs.getInt("id"));
        r.setUserId(rs.getInt("user_id"));
        r.setQuizId(rs.getInt("quiz_id"));
        r.setScore(rs.getInt("score"));
        r.setTotalMarks(rs.getInt("total_marks"));
        r.setPercentage(rs.getDouble("percentage"));
        r.setTimeTaken(rs.getInt("time_taken"));
        r.setAttemptDate(rs.getTimestamp("attempt_date"));
        // Joined columns (may be null if not selected)
        try { r.setUsername(rs.getString("username")); } catch (Exception ignored) {}
        try { r.setQuizTitle(rs.getString("quiz_title")); } catch (Exception ignored) {}
        return r;
    }
}
