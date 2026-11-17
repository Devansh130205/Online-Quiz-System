package com.linkstatic.quiz.controller.admin;

import com.linkstatic.quiz.dao.QuizDAO;
import com.linkstatic.quiz.dao.ResultDAO;
import com.linkstatic.quiz.dao.UserDAO;
import com.linkstatic.quiz.model.Admin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * AdminDashboardServlet — shows admin overview with statistics.
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final QuizDAO   quizDAO   = new QuizDAO();
    private final UserDAO   userDAO   = new UserDAO();
    private final ResultDAO resultDAO = new ResultDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Admin admin = (session != null) ? (Admin) session.getAttribute("loggedAdmin") : null;
        if (admin == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/login");
            return;
        }

        req.setAttribute("totalQuizzes",   quizDAO.getAllQuizzes().size());
        req.setAttribute("totalUsers",     userDAO.getAllUsers().size());
        req.setAttribute("totalResults",   resultDAO.getAllResults().size());
        req.setAttribute("recentResults",  resultDAO.getAllResults().stream().limit(5).collect(java.util.stream.Collectors.toList()));
        req.setAttribute("admin",          admin);

        req.getRequestDispatcher("/WEB-INF/jsp/admin/admin-dashboard.jsp").forward(req, resp);
    }
}
