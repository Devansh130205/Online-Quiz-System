<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.linkstatic.quiz.model.Question, com.linkstatic.quiz.model.Quiz, java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Questions – Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
<div class="admin-layout">
  <aside class="admin-sidebar">
    <div class="admin-brand"><div class="ab-row"><div class="ab-icon">🛡️</div><div><h2>Admin Panel</h2><span>QuizMaster Pro</span></div></div></div>
    <nav class="sidebar-nav">
      <div class="nav-label">Management</div>
      <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link"><span class="nav-icon">📊</span> Dashboard</a>
      <a href="${pageContext.request.contextPath}/admin/manage-quiz" class="nav-link"><span class="nav-icon">📋</span> Manage Quizzes</a>
      <a href="${pageContext.request.contextPath}/admin/manage-question" class="nav-link active"><span class="nav-icon">❓</span> Manage Questions</a>
      <a href="${pageContext.request.contextPath}/admin/manage-users" class="nav-link"><span class="nav-icon">👥</span> Users & Results</a>
      <div class="nav-label" style="margin-top:24px;">System</div>
      <a href="#" onclick="if(confirm('Logout?'))window.location='${pageContext.request.contextPath}/admin/logout'" class="nav-link danger"><span class="nav-icon">🚪</span> Logout</a>
    </nav>
  </aside>

  <main class="admin-main">
    <div class="admin-topbar">
      <h1>❓ Manage Questions</h1>
    </div>
    <div class="admin-page">

      <% String msg = (String) session.getAttribute("adminMsg");
         if (msg != null) { session.removeAttribute("adminMsg"); %>
        <div class="alert alert-success">✅ <%= msg %></div>
      <% } %>

      <!-- Add / Edit Form -->
      <div class="admin-card" style="margin-bottom:28px;">
        <div class="admin-card-header">
          <h3>${action == 'edit' ? '✏️ Edit Question' : '➕ Add New Question'}</h3>
        </div>
        <div class="admin-card-body">
          <form class="admin-form"
                action="${pageContext.request.contextPath}/admin/manage-question" method="post">
            <input type="hidden" name="action" value="${action == 'edit' ? 'edit' : 'add'}">
            <c:if test="${not empty question}">
              <input type="hidden" name="id" value="${question.id}">
            </c:if>

            <div class="form-row">
              <div class="form-group">
                <label for="quizId">Select Quiz *</label>
                <select id="quizId" name="quizId" class="form-control" required>
                  <option value="">— Choose Quiz —</option>
                  <c:forEach var="qz" items="${quizzes}">
                    <option value="${qz.id}" ${question != null && question.quizId == qz.id ? 'selected' : ''}>${qz.title}</option>
                  </c:forEach>
                </select>
              </div>
              <div class="form-group">
                <label for="marks">Marks *</label>
                <input type="number" id="marks" name="marks" class="form-control"
                       value="${question != null ? question.marks : '1'}" min="1" required>
              </div>
            </div>

            <div class="form-group">
              <label for="questionText">Question Text *</label>
              <textarea id="questionText" name="questionText" class="form-control" rows="3"
                        placeholder="Enter the question..." required>${question != null ? question.questionText : ''}</textarea>
            </div>

            <div class="form-row">
              <div class="form-group">
                <label for="optionA">Option A *</label>
                <input type="text" id="optionA" name="optionA" class="form-control"
                       value="${question != null ? question.optionA : ''}" required>
              </div>
              <div class="form-group">
                <label for="optionB">Option B *</label>
                <input type="text" id="optionB" name="optionB" class="form-control"
                       value="${question != null ? question.optionB : ''}" required>
              </div>
            </div>

            <div class="form-row">
              <div class="form-group">
                <label for="optionC">Option C *</label>
                <input type="text" id="optionC" name="optionC" class="form-control"
                       value="${question != null ? question.optionC : ''}" required>
              </div>
              <div class="form-group">
                <label for="optionD">Option D *</label>
                <input type="text" id="optionD" name="optionD" class="form-control"
                       value="${question != null ? question.optionD : ''}" required>
              </div>
            </div>

            <div class="form-group">
              <label for="correctAnswer">Correct Answer *</label>
              <select id="correctAnswer" name="correctAnswer" class="form-control" required>
                <option value="">— Select Correct Option —</option>
                <c:forEach var="opt" items="${['A','B','C','D']}">
                  <option value="${opt}" ${question != null && question.correctAnswer == opt ? 'selected' : ''}>${opt}</option>
                </c:forEach>
              </select>
            </div>

            <div style="display:flex;gap:12px;">
              <button type="submit" class="btn btn-primary">${action == 'edit' ? '💾 Update' : '➕ Add Question'}</button>
              <a href="${pageContext.request.contextPath}/admin/manage-question" class="btn btn-secondary">Cancel</a>
            </div>
          </form>
        </div>
      </div>

      <!-- Questions List -->
      <div class="admin-card">
        <div class="admin-card-header">
          <h3>All Questions (${questions.size()})</h3>
        </div>
        <c:choose>
          <c:when test="${empty questions}">
            <div class="empty-state"><div class="icon">❓</div><h3>No Questions Yet</h3><p>Add your first question above.</p></div>
          </c:when>
          <c:otherwise>
            <table class="admin-table">
              <thead>
                <tr><th>#</th><th>Question</th><th>Quiz ID</th><th>Correct</th><th>Marks</th><th>Actions</th></tr>
              </thead>
              <tbody>
                <c:forEach var="q" items="${questions}" varStatus="s">
                  <tr>
                    <td>${s.count}</td>
                    <td style="max-width:300px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"
                        title="${q.questionText}">${q.questionText}</td>
                    <td>${q.quizId}</td>
                    <td><span class="badge badge-success">${q.correctAnswer}</span></td>
                    <td>${q.marks}</td>
                    <td>
                      <div class="action-btns">
                        <a href="${pageContext.request.contextPath}/admin/manage-question?action=edit&id=${q.id}" class="btn-edit">✏️ Edit</a>
                        <a href="${pageContext.request.contextPath}/admin/manage-question?action=delete&id=${q.id}"
                           onclick="return confirm('Delete this question?');"
                           class="btn-delete">🗑 Delete</a>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </main>
</div>
<script src="${pageContext.request.contextPath}/js/validation.js"></script>
</body>
</html>
