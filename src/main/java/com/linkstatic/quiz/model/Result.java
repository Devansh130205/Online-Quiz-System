package com.linkstatic.quiz.model;

import java.sql.Timestamp;

/**
 * Result model — maps to the 'quiz_results' table.
 */
public class Result {

    private int       id;
    private int       userId;
    private int       quizId;
    private String    quizTitle;     // joined from quizzes table (not a DB column)
    private String    username;      // joined from users table (not a DB column)
    private int       score;
    private int       totalMarks;
    private double    percentage;
    private int       timeTaken;     // seconds
    private Timestamp attemptDate;

    // Additional computed fields for display
    private int       correctAnswers;
    private int       incorrectAnswers;
    private int       unanswered;

    public Result() {}

    // ── Getters & Setters ────────────────────────────────────────────────────

    public int getId()                           { return id; }
    public void setId(int id)                   { this.id = id; }

    public int getUserId()                       { return userId; }
    public void setUserId(int userId)           { this.userId = userId; }

    public int getQuizId()                       { return quizId; }
    public void setQuizId(int quizId)           { this.quizId = quizId; }

    public String getQuizTitle()                 { return quizTitle; }
    public void setQuizTitle(String quizTitle)  { this.quizTitle = quizTitle; }

    public String getUsername()                  { return username; }
    public void setUsername(String username)     { this.username = username; }

    public int getScore()                        { return score; }
    public void setScore(int score)             { this.score = score; }

    public int getTotalMarks()                   { return totalMarks; }
    public void setTotalMarks(int totalMarks)   { this.totalMarks = totalMarks; }

    public double getPercentage()                { return percentage; }
    public void setPercentage(double percentage) { this.percentage = percentage; }

    public int getTimeTaken()                    { return timeTaken; }
    public void setTimeTaken(int timeTaken)     { this.timeTaken = timeTaken; }

    public Timestamp getAttemptDate()                    { return attemptDate; }
    public void setAttemptDate(Timestamp attemptDate)    { this.attemptDate = attemptDate; }

    public int getCorrectAnswers()               { return correctAnswers; }
    public void setCorrectAnswers(int correct)   { this.correctAnswers = correct; }

    public int getIncorrectAnswers()             { return incorrectAnswers; }
    public void setIncorrectAnswers(int wrong)   { this.incorrectAnswers = wrong; }

    public int getUnanswered()                   { return unanswered; }
    public void setUnanswered(int unanswered)    { this.unanswered = unanswered; }

    /** Convenience: formats timeTaken in mm:ss */
    public String getFormattedTime() {
        int minutes = timeTaken / 60;
        int seconds = timeTaken % 60;
        return String.format("%02d:%02d", minutes, seconds);
    }

    /** Returns grade letter based on percentage */
    public String getGrade() {
        if (percentage >= 90) return "A+";
        if (percentage >= 80) return "A";
        if (percentage >= 70) return "B";
        if (percentage >= 60) return "C";
        if (percentage >= 50) return "D";
        return "F";
    }

    @Override
    public String toString() {
        return "Result{id=" + id + ", userId=" + userId + ", quizId=" + quizId + ", score=" + score + "}";
    }
}
