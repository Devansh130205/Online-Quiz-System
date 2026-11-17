package com.linkstatic.quiz.controller;

import com.linkstatic.quiz.dao.UserDAO;
import com.linkstatic.quiz.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * RegisterServlet — handles new user registration.
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/jsp/user/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String fullName  = req.getParameter("fullName");
        String username  = req.getParameter("username");
        String email     = req.getParameter("email");
        String password  = req.getParameter("password");
        String confirmPw = req.getParameter("confirmPassword");

        // Validation
        String error = null;
        if (fullName == null || fullName.trim().isEmpty()) {
            error = "Full name is required.";
        } else if (username == null || username.trim().length() < 4) {
            error = "Username must be at least 4 characters.";
        } else if (email == null || !email.contains("@")) {
            error = "Please enter a valid email address.";
        } else if (password == null || password.length() < 6) {
            error = "Password must be at least 6 characters.";
        } else if (!password.equals(confirmPw)) {
            error = "Passwords do not match.";
        } else if (userDAO.usernameExists(username.trim())) {
            error = "Username '" + username + "' is already taken.";
        } else if (userDAO.emailExists(email.trim())) {
            error = "An account with this email already exists.";
        }

        if (error != null) {
            req.setAttribute("error", error);
            req.setAttribute("fullName", fullName);
            req.setAttribute("username", username);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/jsp/user/register.jsp").forward(req, resp);
            return;
        }

        // Create user
        User newUser = new User();
        newUser.setFullName(fullName.trim());
        newUser.setUsername(username.trim());
        newUser.setEmail(email.trim());
        newUser.setPassword(password);

        boolean success = userDAO.registerUser(newUser);
        if (success) {
            req.setAttribute("success", "Registration successful! You can now log in.");
            req.getRequestDispatcher("/WEB-INF/jsp/user/login.jsp").forward(req, resp);
        } else {
            req.setAttribute("error", "Registration failed. Please try again.");
            req.getRequestDispatcher("/WEB-INF/jsp/user/register.jsp").forward(req, resp);
        }
    }
}
