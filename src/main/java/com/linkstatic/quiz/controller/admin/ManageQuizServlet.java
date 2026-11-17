package com.linkstatic.quiz.controller.admin;

import com.linkstatic.quiz.dao.QuizDAO;
import com.linkstatic.quiz.model.Admin;
import com.linkstatic.quiz.model.Quiz;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * ManageQuizServlet — Admin CRUD for quizzes.
 * GET ?action=list|add|edit&id=  POST action=add|edit|delete
 */
@WebServlet("/admin/manage-quiz")
public class ManageQuizServlet extends HttpServlet {

    private final QuizDAO quizDAO = new QuizDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedAdmin") == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/login");
            return;
        }

        String action = req.getParameter("action");
        if ("edit".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            req.setAttribute("quiz", quizDAO.getQuizById(id));
            req.setAttribute("action", "edit");
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            quizDAO.deleteQuiz(id);
            req.getSession().setAttribute("adminMsg", "Quiz deleted successfully.");
            resp.sendRedirect(req.getContextPath() + "/admin/manage-quiz");
            return;
        } else {
            req.setAttribute("action", "list");
        }

        req.setAttribute("quizzes", quizDAO.getAllQuizzes());
        req.getRequestDispatcher("/WEB-INF/jsp/admin/manage-quizzes.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedAdmin") == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/login");
            return;
        }

        String action = req.getParameter("action");

        Quiz quiz = new Quiz();
        quiz.setTitle(req.getParameter("title"));
        quiz.setDescription(req.getParameter("description"));
        quiz.setCategory(req.getParameter("category"));
        quiz.setTimeLimit(Integer.parseInt(req.getParameter("timeLimit")));
        quiz.setActive("1".equals(req.getParameter("isActive")));
        quiz.setTotalQuestions(0); // updated via question add

        if ("add".equals(action)) {
            quizDAO.addQuiz(quiz);
            req.getSession().setAttribute("adminMsg", "Quiz added successfully.");
        } else if ("edit".equals(action)) {
            quiz.setId(Integer.parseInt(req.getParameter("id")));
            quizDAO.updateQuiz(quiz);
            req.getSession().setAttribute("adminMsg", "Quiz updated successfully.");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/manage-quiz");
    }
}
