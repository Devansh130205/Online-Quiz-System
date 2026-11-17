package com.linkstatic.quiz.model;

/**
 * QuizAnswer model — maps to the 'quiz_answers' table.
 */
public class QuizAnswer {

    private int    id;
    private int    resultId;
    private int    questionId;
    private String selectedAnswer;  // "A", "B", "C", "D", or null if skipped
    private boolean isCorrect;

    public QuizAnswer() {}

    public QuizAnswer(int resultId, int questionId, String selectedAnswer, boolean isCorrect) {
        this.resultId       = resultId;
        this.questionId     = questionId;
        this.selectedAnswer = selectedAnswer;
        this.isCorrect      = isCorrect;
    }

    // ── Getters & Setters ────────────────────────────────────────────────────

    public int getId()                              { return id; }
    public void setId(int id)                      { this.id = id; }

    public int getResultId()                        { return resultId; }
    public void setResultId(int resultId)          { this.resultId = resultId; }

    public int getQuestionId()                      { return questionId; }
    public void setQuestionId(int questionId)      { this.questionId = questionId; }

    public String getSelectedAnswer()               { return selectedAnswer; }
    public void setSelectedAnswer(String selected)  { this.selectedAnswer = selected; }

    public boolean isCorrect()                      { return isCorrect; }
    public void setCorrect(boolean correct)         { this.isCorrect = correct; }

    @Override
    public String toString() {
        return "QuizAnswer{questionId=" + questionId + ", selected=" + selectedAnswer + ", correct=" + isCorrect + "}";
    }
}
