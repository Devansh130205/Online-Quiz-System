package com.linkstatic.quiz.controller.admin;

import com.linkstatic.quiz.dao.ResultDAO;
import com.linkstatic.quiz.dao.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * ManageUserServlet — Admin view/delete users and view all results.
 */
@WebServlet("/admin/manage-users")
public class ManageUserServlet extends HttpServlet {

    private final UserDAO   userDAO   = new UserDAO();
    private final ResultDAO resultDAO = new ResultDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedAdmin") == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/login");
            return;
        }

        String action = req.getParameter("action");
        if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            userDAO.deleteUser(id);
            req.getSession().setAttribute("adminMsg", "User deleted successfully.");
            resp.sendRedirect(req.getContextPath() + "/admin/manage-users");
            return;
        }

        req.setAttribute("users",   userDAO.getAllUsers());
        req.setAttribute("results", resultDAO.getAllResults());
        req.getRequestDispatcher("/WEB-INF/jsp/admin/manage-users.jsp").forward(req, resp);
    }
}
