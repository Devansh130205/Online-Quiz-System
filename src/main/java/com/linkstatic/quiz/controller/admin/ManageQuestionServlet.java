package com.linkstatic.quiz.controller.admin;

import com.linkstatic.quiz.dao.QuestionDAO;
import com.linkstatic.quiz.dao.QuizDAO;
import com.linkstatic.quiz.model.Question;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * ManageQuestionServlet — Admin CRUD for questions.
 */
@WebServlet("/admin/manage-question")
public class ManageQuestionServlet extends HttpServlet {

    private final QuestionDAO questionDAO = new QuestionDAO();
    private final QuizDAO     quizDAO     = new QuizDAO();

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
            req.setAttribute("question", questionDAO.getQuestionById(id));
            req.setAttribute("action", "edit");
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            Question q = questionDAO.getQuestionById(id);
            if (q != null) {
                questionDAO.deleteQuestion(id);
                quizDAO.updateQuestionCount(q.getQuizId());
            }
            req.getSession().setAttribute("adminMsg", "Question deleted successfully.");
            resp.sendRedirect(req.getContextPath() + "/admin/manage-question");
            return;
        } else {
            req.setAttribute("action", "list");
        }

        req.setAttribute("questions", questionDAO.getAllQuestions());
        req.setAttribute("quizzes",   quizDAO.getAllQuizzes());
        req.getRequestDispatcher("/WEB-INF/jsp/admin/manage-questions.jsp").forward(req, resp);
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

        Question q = new Question();
        q.setQuizId(Integer.parseInt(req.getParameter("quizId")));
        q.setQuestionText(req.getParameter("questionText"));
        q.setOptionA(req.getParameter("optionA"));
        q.setOptionB(req.getParameter("optionB"));
        q.setOptionC(req.getParameter("optionC"));
        q.setOptionD(req.getParameter("optionD"));
        q.setCorrectAnswer(req.getParameter("correctAnswer"));
        q.setMarks(Integer.parseInt(req.getParameter("marks")));

        if ("add".equals(action)) {
            questionDAO.addQuestion(q);
            quizDAO.updateQuestionCount(q.getQuizId());
            req.getSession().setAttribute("adminMsg", "Question added successfully.");
        } else if ("edit".equals(action)) {
            q.setId(Integer.parseInt(req.getParameter("id")));
            questionDAO.updateQuestion(q);
            req.getSession().setAttribute("adminMsg", "Question updated successfully.");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/manage-question");
    }
}
