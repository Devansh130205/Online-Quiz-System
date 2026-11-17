package com.linkstatic.quiz.dao;

import com.linkstatic.quiz.model.Question;
import com.linkstatic.quiz.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * QuestionDAO — Data Access Object for question operations.
 */
public class QuestionDAO {

    // ── Retrieve ─────────────────────────────────────────────────────────────

    public List<Question> getQuestionsByQuizId(int quizId) {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM questions WHERE quiz_id = ? ORDER BY id";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, quizId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("[QuestionDAO] getQuestionsByQuizId error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    public Question getQuestionById(int id) {
        String sql = "SELECT * FROM questions WHERE id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("[QuestionDAO] getQuestionById error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return null;
    }

    public List<Question> getAllQuestions() {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT q.*, qz.title AS quiz_title FROM questions q JOIN quizzes qz ON q.quiz_id = qz.id ORDER BY q.quiz_id, q.id";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("[QuestionDAO] getAllQuestions error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // ── Create ───────────────────────────────────────────────────────────────

    public boolean addQuestion(Question q) {
        String sql = "INSERT INTO questions (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_answer, marks) VALUES (?,?,?,?,?,?,?,?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, q.getQuizId());
            ps.setString(2, q.getQuestionText());
            ps.setString(3, q.getOptionA());
            ps.setString(4, q.getOptionB());
            ps.setString(5, q.getOptionC());
            ps.setString(6, q.getOptionD());
            ps.setString(7, q.getCorrectAnswer());
            ps.setInt(8, q.getMarks());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[QuestionDAO] addQuestion error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ── Update ───────────────────────────────────────────────────────────────

    public boolean updateQuestion(Question q) {
        String sql = "UPDATE questions SET question_text=?, option_a=?, option_b=?, option_c=?, option_d=?, correct_answer=?, marks=? WHERE id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, q.getQuestionText());
            ps.setString(2, q.getOptionA());
            ps.setString(3, q.getOptionB());
            ps.setString(4, q.getOptionC());
            ps.setString(5, q.getOptionD());
            ps.setString(6, q.getCorrectAnswer());
            ps.setInt(7, q.getMarks());
            ps.setInt(8, q.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[QuestionDAO] updateQuestion error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ── Delete ───────────────────────────────────────────────────────────────

    public boolean deleteQuestion(int id) {
        String sql = "DELETE FROM questions WHERE id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[QuestionDAO] deleteQuestion error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ── Helper ───────────────────────────────────────────────────────────────

    private Question mapRow(ResultSet rs) throws SQLException {
        Question q = new Question();
        q.setId(rs.getInt("id"));
        q.setQuizId(rs.getInt("quiz_id"));
        q.setQuestionText(rs.getString("question_text"));
        q.setOptionA(rs.getString("option_a"));
        q.setOptionB(rs.getString("option_b"));
        q.setOptionC(rs.getString("option_c"));
        q.setOptionD(rs.getString("option_d"));
        q.setCorrectAnswer(rs.getString("correct_answer"));
        q.setMarks(rs.getInt("marks"));
        return q;
    }
}
