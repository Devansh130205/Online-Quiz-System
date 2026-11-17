<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.linkstatic.quiz.model.Quiz, java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Quizzes – Admin</title>
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
      <a href="${pageContext.request.contextPath}/admin/manage-quiz" class="nav-link active"><span class="nav-icon">📋</span> Manage Quizzes</a>
      <a href="${pageContext.request.contextPath}/admin/manage-question" class="nav-link"><span class="nav-icon">❓</span> Manage Questions</a>
      <a href="${pageContext.request.contextPath}/admin/manage-users" class="nav-link"><span class="nav-icon">👥</span> Users & Results</a>
      <div class="nav-label" style="margin-top:24px;">System</div>
      <a href="#" onclick="if(confirm('Logout?'))window.location='${pageContext.request.contextPath}/admin/logout'" class="nav-link danger"><span class="nav-icon">🚪</span> Logout</a>
    </nav>
  </aside>

  <main class="admin-main">
    <div class="admin-topbar">
      <h1>📋 Manage Quizzes</h1>
      <a href="${pageContext.request.contextPath}/admin/manage-quiz?action=add" class="btn btn-primary btn-sm">➕ Add New Quiz</a>
    </div>
    <div class="admin-page">

      <!-- Success/Error messages -->
      <% String msg = (String) session.getAttribute("adminMsg");
         if (msg != null) { session.removeAttribute("adminMsg"); %>
        <div class="alert alert-success">✅ <%= msg %></div>
      <% } %>

      <!-- Add / Edit Form -->
      <c:if test="${action == 'edit' || action == 'add'}">
      <div class="admin-card" style="margin-bottom:28px;">
        <div class="admin-card-header">
          <h3>${action == 'edit' ? '✏️ Edit Quiz' : '➕ Add New Quiz'}</h3>
        </div>
        <div class="admin-card-body">
          <form id="adminQuizForm" class="admin-form"
                action="${pageContext.request.contextPath}/admin/manage-quiz" method="post">
            <input type="hidden" name="action" value="${action}">
            <c:if test="${not empty quiz}">
              <input type="hidden" name="id" value="${quiz.id}">
            </c:if>

            <div class="form-row">
              <div class="form-group">
                <label for="title">Quiz Title *</label>
                <input type="text" id="title" name="title" class="form-control"
                       value="${quiz != null ? quiz.title : ''}" placeholder="e.g. Java Fundamentals" required>
              </div>
              <div class="form-group">
                <label for="category">Category *</label>
                <input type="text" id="category" name="category" class="form-control"
                       value="${quiz != null ? quiz.category : ''}" placeholder="e.g. Programming" required>
              </div>
            </div>

            <div class="form-group">
              <label for="description">Description</label>
              <textarea id="description" name="description" class="form-control"
                        placeholder="Brief description of the quiz...">${quiz != null ? quiz.description : ''}</textarea>
            </div>

            <div class="form-row">
              <div class="form-group">
                <label for="timeLimit">Time Limit (minutes) *</label>
                <input type="number" id="timeLimit" name="timeLimit" class="form-control"
                       value="${quiz != null ? quiz.timeLimit : '10'}" min="1" max="120" required>
              </div>
              <div class="form-group">
                <label for="isActive">Status</label>
                <select id="isActive" name="isActive" class="form-control">
                  <option value="1" ${quiz == null || quiz.active ? 'selected' : ''}>Active</option>
                  <option value="0" ${quiz != null && !quiz.active ? 'selected' : ''}>Inactive</option>
                </select>
              </div>
            </div>

            <div style="display:flex;gap:12px;">
              <button type="submit" class="btn btn-primary">${action == 'edit' ? '💾 Update Quiz' : '➕ Add Quiz'}</button>
              <a href="${pageContext.request.contextPath}/admin/manage-quiz" class="btn btn-secondary">Cancel</a>
            </div>
          </form>
        </div>
      </div>
      </c:if>

      <!-- Quiz List -->
      <div class="admin-card">
        <div class="admin-card-header">
          <h3>All Quizzes (${quizzes.size()})</h3>
        </div>
        <c:choose>
          <c:when test="${empty quizzes}">
            <div class="empty-state"><div class="icon">📭</div><h3>No Quizzes Yet</h3><p>Add your first quiz above.</p></div>
          </c:when>
          <c:otherwise>
            <table class="admin-table">
              <thead>
                <tr><th>#</th><th>Title</th><th>Category</th><th>Questions</th><th>Time (min)</th><th>Status</th><th>Created</th><th>Actions</th></tr>
              </thead>
              <tbody>
                <c:forEach var="q" items="${quizzes}" varStatus="s">
                  <tr>
                    <td>${s.count}</td>
                    <td><strong>${q.title}</strong></td>
                    <td><span class="badge badge-primary">${q.category}</span></td>
                    <td>${q.totalQuestions}</td>
                    <td>${q.timeLimit}</td>
                    <td>
                      <c:choose>
                        <c:when test="${q.active}"><span class="badge badge-success">Active</span></c:when>
                        <c:otherwise><span class="badge badge-danger">Inactive</span></c:otherwise>
                      </c:choose>
                    </td>
                    <td><fmt:formatDate value="${q.createdAt}" pattern="dd MMM yyyy"/></td>
                    <td>
                      <div class="action-btns">
                        <a href="${pageContext.request.contextPath}/admin/manage-quiz?action=edit&id=${q.id}" class="btn-edit">✏️ Edit</a>
                        <a href="${pageContext.request.contextPath}/admin/manage-quiz?action=delete&id=${q.id}"
                           onclick="return confirm('Delete quiz \'${q.title}\'? This will also delete all questions and results!');"
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
