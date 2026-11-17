package com.linkstatic.quiz.controller;

import com.linkstatic.quiz.dao.QuizDAO;
import com.linkstatic.quiz.dao.ResultDAO;
import com.linkstatic.quiz.model.Quiz;
import com.linkstatic.quiz.model.Result;
import com.linkstatic.quiz.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * DashboardServlet — loads the user dashboard with available quizzes and past results.
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final QuizDAO   quizDAO   = new QuizDAO();
    private final ResultDAO resultDAO = new ResultDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<Quiz>   availableQuizzes = quizDAO.getAllActiveQuizzes();
        List<Result> pastResults      = resultDAO.getResultsByUserId(user.getId());

        req.setAttribute("availableQuizzes", availableQuizzes);
        req.setAttribute("pastResults", pastResults);
        req.setAttribute("user", user);

        req.getRequestDispatcher("/WEB-INF/jsp/user/dashboard.jsp").forward(req, resp);
    }
}
