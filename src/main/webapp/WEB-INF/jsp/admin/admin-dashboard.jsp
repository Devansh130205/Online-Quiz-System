<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.linkstatic.quiz.model.Admin, com.linkstatic.quiz.model.Result, java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard – Online Quiz System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
<div class="admin-layout">

  <!-- ── Admin Sidebar ── -->
  <aside class="admin-sidebar">
    <div class="admin-brand">
      <div class="ab-row">
        <div class="ab-icon">🛡️</div>
        <div>
          <h2>Admin Panel</h2>
          <span>QuizMaster Pro</span>
        </div>
      </div>
    </div>

    <div class="sidebar-user" style="border-bottom:1px solid rgba(255,255,255,0.06); padding:20px 24px;">
      <div class="user-avatar" style="background:linear-gradient(135deg,#FF6584,#E84393);">A</div>
      <div class="user-info">
        <div class="name">${admin.fullName}</div>
        <div class="role">System Administrator</div>
      </div>
    </div>

    <nav class="sidebar-nav">
      <div class="nav-label">Management</div>
      <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link active">
        <span class="nav-icon">📊</span> Dashboard
      </a>
      <a href="${pageContext.request.contextPath}/admin/manage-quiz" class="nav-link">
        <span class="nav-icon">📋</span> Manage Quizzes
      </a>
      <a href="${pageContext.request.contextPath}/admin/manage-question" class="nav-link">
        <span class="nav-icon">❓</span> Manage Questions
      </a>
      <a href="${pageContext.request.contextPath}/admin/manage-users" class="nav-link">
        <span class="nav-icon">👥</span> Users & Results
      </a>
      <div class="nav-label" style="margin-top:24px;">System</div>
      <a href="${pageContext.request.contextPath}/admin/login?action=logout"
         onclick="this.href='${pageContext.request.contextPath}/admin/logout'; event.preventDefault(); 
                  if(confirm('Logout?')){ window.location='${pageContext.request.contextPath}/admin/logout'; }"
         class="nav-link danger">
        <span class="nav-icon">🚪</span> Logout
      </a>
    </nav>
  </aside>

  <!-- ── Admin Main ── -->
  <main class="admin-main">
    <div class="admin-topbar">
      <h1>📊 Admin Dashboard</h1>
      <span style="font-size:0.85rem;color:#9898B3;">Welcome, <strong style="color:#EAEAF0;">${admin.fullName}</strong></span>
    </div>

    <div class="admin-page">

      <!-- Stats -->
      <div class="admin-stats">
        <div class="astat-card">
          <div class="astat-icon purple">📋</div>
          <div class="astat-info">
            <div class="num">${totalQuizzes}</div>
            <div class="lbl">Total Quizzes</div>
          </div>
        </div>
        <div class="astat-card">
          <div class="astat-icon blue">👥</div>
          <div class="astat-info">
            <div class="num">${totalUsers}</div>
            <div class="lbl">Registered Users</div>
          </div>
        </div>
        <div class="astat-card">
          <div class="astat-icon green">✅</div>
          <div class="astat-info">
            <div class="num">${totalResults}</div>
            <div class="lbl">Quiz Attempts</div>
          </div>
        </div>
      </div>

      <!-- Recent Results -->
      <div class="admin-card">
        <div class="admin-card-header">
          <h3>Recent Quiz Attempts</h3>
          <a href="${pageContext.request.contextPath}/admin/manage-users" class="btn btn-secondary btn-sm">View All</a>
        </div>
        <c:choose>
          <c:when test="${empty recentResults}">
            <div class="empty-state"><div class="icon">📭</div><p>No results yet.</p></div>
          </c:when>
          <c:otherwise>
            <table class="admin-table">
              <thead><tr><th>User</th><th>Quiz</th><th>Score</th><th>%</th><th>Date</th></tr></thead>
              <tbody>
                <c:forEach var="r" items="${recentResults}">
                  <tr>
                    <td>${r.username}</td>
                    <td>${r.quizTitle}</td>
                    <td>${r.score}/${r.totalMarks}</td>
                    <td><fmt:formatNumber value="${r.percentage}" maxFractionDigits="1"/>%</td>
                    <td><fmt:formatDate value="${r.attemptDate}" pattern="dd MMM yyyy"/></td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </c:otherwise>
        </c:choose>
      </div>

      <!-- Quick Links -->
      <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:16px;">
        <a href="${pageContext.request.contextPath}/admin/manage-quiz?action=add" class="btn btn-primary" style="justify-content:flex-start;gap:12px;">
          ➕ Add New Quiz
        </a>
        <a href="${pageContext.request.contextPath}/admin/manage-question" class="btn btn-secondary" style="justify-content:flex-start;gap:12px;">
          ❓ Manage Questions
        </a>
        <a href="${pageContext.request.contextPath}/admin/manage-users" class="btn btn-secondary" style="justify-content:flex-start;gap:12px;">
          👥 View All Users
        </a>
      </div>
    </div>
  </main>
</div>
<script src="${pageContext.request.contextPath}/js/validation.js"></script>
<script>
  // Admin logout
  document.addEventListener('DOMContentLoaded', function() {
    var logoutLink = document.querySelector('.nav-link.danger');
    if (logoutLink) {
      logoutLink.addEventListener('click', function(e) {
        e.preventDefault();
        if (confirm('Are you sure you want to logout?')) {
          window.location = '${pageContext.request.contextPath}/admin/logout';
        }
      });
    }
  });
</script>
</body>
</html>
