package com.linkstatic.quiz.controller;

import com.linkstatic.quiz.dao.ResultDAO;
import com.linkstatic.quiz.model.Result;
import com.linkstatic.quiz.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * ResultServlet — displays quiz result for a given result ID.
 */
@WebServlet("/result")
public class ResultServlet extends HttpServlet {

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

        String idStr = req.getParameter("id");
        Result result = null;

        if (idStr != null && !idStr.isEmpty()) {
            try {
                int resultId = Integer.parseInt(idStr);
                result = resultDAO.getResultById(resultId);
                // Security: users can only see their own results
                if (result != null && result.getUserId() != user.getId()) {
                    result = null;
                }
            } catch (NumberFormatException e) {
                // fall through to null handling
            }
        }

        // Fallback: try session-cached result
        if (result == null) {
            result = (Result) session.getAttribute("lastResult");
            session.removeAttribute("lastResult");
        }

        if (result == null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        req.setAttribute("result", result);
        req.setAttribute("user", user);
        req.getRequestDispatcher("/WEB-INF/jsp/user/result.jsp").forward(req, resp);
    }
}
