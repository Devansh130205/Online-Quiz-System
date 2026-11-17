<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.linkstatic.quiz.model.User, com.linkstatic.quiz.model.Result, java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Users & Results – Admin</title>
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
      <a href="${pageContext.request.contextPath}/admin/manage-question" class="nav-link"><span class="nav-icon">❓</span> Manage Questions</a>
      <a href="${pageContext.request.contextPath}/admin/manage-users" class="nav-link active"><span class="nav-icon">👥</span> Users & Results</a>
      <div class="nav-label" style="margin-top:24px;">System</div>
      <a href="#" onclick="if(confirm('Logout?'))window.location='${pageContext.request.contextPath}/admin/logout'" class="nav-link danger"><span class="nav-icon">🚪</span> Logout</a>
    </nav>
  </aside>

  <main class="admin-main">
    <div class="admin-topbar">
      <h1>👥 Users &amp; Results</h1>
    </div>
    <div class="admin-page">

      <% String msg = (String) session.getAttribute("adminMsg");
         if (msg != null) { session.removeAttribute("adminMsg"); %>
        <div class="alert alert-success">✅ <%= msg %></div>
      <% } %>

      <!-- Users Table -->
      <div class="admin-card" style="margin-bottom:28px;">
        <div class="admin-card-header">
          <h3>Registered Users (${users.size()})</h3>
        </div>
        <c:choose>
          <c:when test="${empty users}">
            <div class="empty-state"><div class="icon">👤</div><h3>No Users Yet</h3></div>
          </c:when>
          <c:otherwise>
            <table class="admin-table">
              <thead>
                <tr><th>#</th><th>Full Name</th><th>Username</th><th>Email</th><th>Joined</th><th>Actions</th></tr>
              </thead>
              <tbody>
                <c:forEach var="u" items="${users}" varStatus="s">
                  <tr>
                    <td>${s.count}</td>
                    <td><strong>${u.fullName}</strong></td>
                    <td>@${u.username}</td>
                    <td>${u.email}</td>
                    <td><fmt:formatDate value="${u.createdAt}" pattern="dd MMM yyyy"/></td>
                    <td>
                      <a href="${pageContext.request.contextPath}/admin/manage-users?action=delete&id=${u.id}"
                         onclick="return confirm('Delete user \'${u.username}\'? All their results will also be deleted.');"
                         class="btn-delete">🗑 Delete</a>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </c:otherwise>
        </c:choose>
      </div>

      <!-- Results Table -->
      <div class="admin-card">
        <div class="admin-card-header">
          <h3>All Quiz Results (${results.size()})</h3>
        </div>
        <c:choose>
          <c:when test="${empty results}">
            <div class="empty-state"><div class="icon">📊</div><h3>No Results Yet</h3></div>
          </c:when>
          <c:otherwise>
            <table class="admin-table">
              <thead>
                <tr><th>#</th><th>User</th><th>Quiz</th><th>Score</th><th>%</th><th>Grade</th><th>Time</th><th>Date</th></tr>
              </thead>
              <tbody>
                <c:forEach var="r" items="${results}" varStatus="s">
                  <tr>
                    <td>${s.count}</td>
                    <td>${r.username}</td>
                    <td>${r.quizTitle}</td>
                    <td>${r.score}/${r.totalMarks}</td>
                    <td>
                      <c:choose>
                        <c:when test="${r.percentage >= 80}"><span class="badge badge-success"><fmt:formatNumber value="${r.percentage}" maxFractionDigits="1"/>%</span></c:when>
                        <c:when test="${r.percentage >= 60}"><span class="badge badge-info"><fmt:formatNumber value="${r.percentage}" maxFractionDigits="1"/>%</span></c:when>
                        <c:when test="${r.percentage >= 40}"><span class="badge badge-warning"><fmt:formatNumber value="${r.percentage}" maxFractionDigits="1"/>%</span></c:when>
                        <c:otherwise><span class="badge badge-danger"><fmt:formatNumber value="${r.percentage}" maxFractionDigits="1"/>%</span></c:otherwise>
                      </c:choose>
                    </td>
                    <td><strong>${r.grade}</strong></td>
                    <td>${r.formattedTime}</td>
                    <td><fmt:formatDate value="${r.attemptDate}" pattern="dd MMM yyyy"/></td>
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
