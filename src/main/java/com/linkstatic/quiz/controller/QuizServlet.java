package com.linkstatic.quiz.controller;

import com.linkstatic.quiz.dao.QuestionDAO;
import com.linkstatic.quiz.dao.QuizDAO;
import com.linkstatic.quiz.dao.ResultDAO;
import com.linkstatic.quiz.model.Question;
import com.linkstatic.quiz.model.Quiz;
import com.linkstatic.quiz.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * QuizServlet — loads quiz questions and starts the quiz session.
 */
@WebServlet("/quiz")
public class QuizServlet extends HttpServlet {

    private final QuizDAO     quizDAO     = new QuizDAO();
    private final QuestionDAO questionDAO = new QuestionDAO();
    private final ResultDAO   resultDAO   = new ResultDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String quizIdStr = req.getParameter("id");
        if (quizIdStr == null || quizIdStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        int quizId;
        try {
            quizId = Integer.parseInt(quizIdStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        Quiz quiz = quizDAO.getQuizById(quizId);
        if (quiz == null || !quiz.isActive()) {
            req.setAttribute("error", "Quiz not found or not available.");
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        // Check if user already attempted this quiz today
        if (resultDAO.hasAttemptedQuiz(user.getId(), quizId)) {
            req.getSession().setAttribute("quizError",
                "You have already attempted '" + quiz.getTitle() + "' today. Please try another quiz.");
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        List<Question> questions = questionDAO.getQuestionsByQuizId(quizId);
        if (questions.isEmpty()) {
            req.getSession().setAttribute("quizError", "This quiz has no questions yet.");
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        // Store quiz state in session
        session.setAttribute("currentQuiz", quiz);
        session.setAttribute("quizQuestions", questions);
        session.setAttribute("quizStartTime", System.currentTimeMillis());

        req.setAttribute("quiz", quiz);
        req.setAttribute("questions", questions);
        req.getRequestDispatcher("/WEB-INF/jsp/user/quiz.jsp").forward(req, resp);
    }
}
