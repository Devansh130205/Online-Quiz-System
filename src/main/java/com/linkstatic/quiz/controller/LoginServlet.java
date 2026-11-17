package com.linkstatic.quiz.controller;

import com.linkstatic.quiz.dao.UserDAO;
import com.linkstatic.quiz.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * LoginServlet — handles user login (GET shows form, POST processes credentials).
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // If already logged in, redirect to dashboard
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/jsp/user/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // Basic validation
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Username and password are required.");
            req.getRequestDispatcher("/WEB-INF/jsp/user/login.jsp").forward(req, resp);
            return;
        }

        User user = userDAO.validateLogin(username.trim(), password.trim());
        if (user != null) {
            // Create session
            HttpSession session = req.getSession(true);
            session.setAttribute("loggedUser", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } else {
            req.setAttribute("error", "Invalid username or password. Please try again.");
            req.setAttribute("username", username);
            req.getRequestDispatcher("/WEB-INF/jsp/user/login.jsp").forward(req, resp);
        }
    }
}
