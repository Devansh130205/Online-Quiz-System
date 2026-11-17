package com.linkstatic.quiz.controller;

import com.linkstatic.quiz.dao.ResultDAO;
import com.linkstatic.quiz.model.Question;
import com.linkstatic.quiz.model.Quiz;
import com.linkstatic.quiz.model.QuizAnswer;
import com.linkstatic.quiz.model.Result;
import com.linkstatic.quiz.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * SubmitQuizServlet — processes submitted quiz answers, calculates score,
 * saves result to DB, and redirects to result page.
 */
@WebServlet("/submit-quiz")
public class SubmitQuizServlet extends HttpServlet {

    private final ResultDAO resultDAO = new ResultDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        @SuppressWarnings("unchecked")
        List<Question> questions = (List<Question>) session.getAttribute("quizQuestions");
        Quiz quiz = (Quiz) session.getAttribute("currentQuiz");
        Long startTime = (Long) session.getAttribute("quizStartTime");

        if (questions == null || quiz == null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        // Calculate time taken
        int timeTaken = 0;
        if (startTime != null) {
            timeTaken = (int) ((System.currentTimeMillis() - startTime) / 1000);
        }

        // Evaluate answers
        int score = 0;
        int totalMarks = 0;
        int correctCount = 0;
        int incorrectCount = 0;
        int unansweredCount = 0;
        List<QuizAnswer> answerList = new ArrayList<>();

        for (Question q : questions) {
            String paramName = "answer_" + q.getId();
            String selected  = req.getParameter(paramName);
            totalMarks += q.getMarks();

            boolean isCorrect = false;
            if (selected != null && !selected.isEmpty()) {
                isCorrect = selected.equalsIgnoreCase(q.getCorrectAnswer());
                if (isCorrect) {
                    score += q.getMarks();
                    correctCount++;
                } else {
                    incorrectCount++;
                }
            } else {
                unansweredCount++;
            }

            QuizAnswer qa = new QuizAnswer();
            qa.setQuestionId(q.getId());
            qa.setSelectedAnswer(selected);
            qa.setCorrect(isCorrect);
            answerList.add(qa);
        }

        double percentage = (totalMarks > 0) ? ((double) score / totalMarks) * 100.0 : 0.0;

        // Build Result object
        Result result = new Result();
        result.setUserId(user.getId());
        result.setQuizId(quiz.getId());
        result.setScore(score);
        result.setTotalMarks(totalMarks);
        result.setPercentage(Math.round(percentage * 100.0) / 100.0);
        result.setTimeTaken(timeTaken);
        result.setCorrectAnswers(correctCount);
        result.setIncorrectAnswers(incorrectCount);
        result.setUnanswered(unansweredCount);

        // Save to database
        int resultId = resultDAO.saveResult(result);
        if (resultId > 0) {
            // Set result_id on each answer and save batch
            for (QuizAnswer qa : answerList) {
                qa.setResultId(resultId);
            }
            resultDAO.saveAnswers(answerList);
        }

        // Clear quiz state from session
        session.removeAttribute("currentQuiz");
        session.removeAttribute("quizQuestions");
        session.removeAttribute("quizStartTime");

        // Store result details in session for result page
        result.setId(resultId);
        result.setQuizTitle(quiz.getTitle());
        session.setAttribute("lastResult", result);

        resp.sendRedirect(req.getContextPath() + "/result?id=" + resultId);
    }
}
