package com.linkstatic.quiz.controller.admin;

import com.linkstatic.quiz.dao.AdminDAO;
import com.linkstatic.quiz.model.Admin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * AdminLoginServlet — handles admin login/logout.
 */
@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("loggedAdmin") != null) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/jsp/admin/admin-login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Username and password are required.");
            req.getRequestDispatcher("/WEB-INF/jsp/admin/admin-login.jsp").forward(req, resp);
            return;
        }

        Admin admin = adminDAO.validateAdminLogin(username.trim(), password.trim());
        if (admin != null) {
            HttpSession session = req.getSession(true);
            session.setAttribute("loggedAdmin", admin);
            session.setAttribute("adminId", admin.getId());
            session.setAttribute("adminUsername", admin.getUsername());
            session.setMaxInactiveInterval(60 * 60); // 1 hour
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else {
            req.setAttribute("error", "Invalid admin credentials.");
            req.getRequestDispatcher("/WEB-INF/jsp/admin/admin-login.jsp").forward(req, resp);
        }
    }
}
