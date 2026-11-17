<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.linkstatic.quiz.model.User, com.linkstatic.quiz.model.Quiz, com.linkstatic.quiz.model.Result, java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard – Online Quiz System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>
<div class="app-layout">

  <!-- ── Sidebar ── -->
  <aside class="sidebar">
    <div class="sidebar-logo">
      <div class="brand">
        <div class="brand-icon">🎯</div>
        <div class="brand-text">
          <h2>QuizMaster Pro</h2>
          <span>Linkstatic Techno</span>
        </div>
      </div>
    </div>

    <div class="sidebar-user">
      <div class="user-avatar">${user.fullName.substring(0,1).toUpperCase()}</div>
      <div class="user-info">
        <div class="name">${user.fullName}</div>
        <div class="role">@${user.username}</div>
      </div>
    </div>

    <nav class="sidebar-nav">
      <div class="nav-label">Main Menu</div>
      <a href="${pageContext.request.contextPath}/dashboard" class="nav-link active">
        <span class="nav-icon">🏠</span> Dashboard
      </a>
      <a href="#availableSection" class="nav-link">
        <span class="nav-icon">📋</span> Available Quizzes
      </a>
      <a href="#historySection" class="nav-link">
        <span class="nav-icon">📊</span> My Results
      </a>
      <div class="nav-label" style="margin-top:24px;">Account</div>
      <a href="${pageContext.request.contextPath}/logout" class="nav-link danger">
        <span class="nav-icon">🚪</span> Logout
      </a>
    </nav>

    <div class="sidebar-footer" style="font-size:0.72rem; color:#666680; padding:16px 24px; text-align:center;">
      Online Quiz System v1.0<br>© 2024 Linkstatic Techno
    </div>
  </aside>

  <!-- ── Main Content ── -->
  <main class="main-content">
    <div class="top-bar">
      <div>
        <h1>Dashboard</h1>
        <div class="breadcrumb">Home / Dashboard</div>
      </div>
      <div style="font-size:0.85rem; color:#9898B3;">
        👋 Hello, <strong style="color:#EAEAF0;">${user.fullName}</strong>!
      </div>
    </div>

    <div class="page-body">

      <!-- Session alerts -->
      <% String qErr = (String) session.getAttribute("quizError");
         if (qErr != null) { session.removeAttribute("quizError"); %>
        <div class="alert alert-warning session-alert">⚠️ <%= qErr %></div>
      <% } %>

      <!-- ── Stats ── -->
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-icon purple">📋</div>
          <div class="stat-info">
            <div class="value">${availableQuizzes.size()}</div>
            <div class="label">Available Quizzes</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon green">✅</div>
          <div class="stat-info">
            <div class="value">${pastResults.size()}</div>
            <div class="label">Quizzes Attempted</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon pink">🏆</div>
          <div class="stat-info">
            <div class="value">
              <c:choose>
                <c:when test="${not empty pastResults}">
                  <c:set var="best" value="0"/>
                  <c:forEach var="r" items="${pastResults}">
                    <c:if test="${r.percentage > best}"><c:set var="best" value="${r.percentage}"/></c:if>
                  </c:forEach>
                  <fmt:formatNumber value="${best}" maxFractionDigits="0"/>%
                </c:when>
                <c:otherwise>–</c:otherwise>
              </c:choose>
            </div>
            <div class="label">Best Score</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon blue">📅</div>
          <div class="stat-info">
            <div class="value">
              <jsp:useBean id="now" class="java.util.Date"/>
              <fmt:formatDate value="${now}" pattern="dd MMM"/>
            </div>
            <div class="label">Today's Date</div>
          </div>
        </div>
      </div>

      <!-- ── Available Quizzes ── -->
      <div id="availableSection">
        <div class="section-header">
          <h2>📋 Available Quizzes</h2>
          <span class="badge badge-primary">${availableQuizzes.size()} quizzes</span>
        </div>

        <c:choose>
          <c:when test="${empty availableQuizzes}">
            <div class="empty-state">
              <div class="icon">📭</div>
              <h3>No Quizzes Available</h3>
              <p>Check back later for new quizzes.</p>
            </div>
          </c:when>
          <c:otherwise>
            <div class="quiz-grid">
              <c:forEach var="quiz" items="${availableQuizzes}">
                <div class="quiz-card">
                  <div class="quiz-card-header">
                    <div class="quiz-card-icon">📝</div>
                    <span class="badge badge-primary">${quiz.category}</span>
                  </div>
                  <h3>${quiz.title}</h3>
                  <p>${quiz.description}</p>
                  <div class="quiz-meta">
                    <span>❓ ${quiz.totalQuestions} Questions</span>
                    <span>⏱ ${quiz.timeLimit} mins</span>
                  </div>
                  <a href="${pageContext.request.contextPath}/quiz?id=${quiz.id}"
                     class="btn btn-primary btn-sm" style="text-align:center;">
                    Start Quiz →
                  </a>
                </div>
              </c:forEach>
            </div>
          </c:otherwise>
        </c:choose>
      </div>

      <!-- ── Past Results ── -->
      <div id="historySection">
        <div class="section-header">
          <h2>📊 My Quiz History</h2>
        </div>

        <div class="table-card">
          <div class="table-card-header">
            <h3>Recent Attempts</h3>
            <span class="text-muted" style="font-size:0.8rem;">${pastResults.size()} total</span>
          </div>

          <c:choose>
            <c:when test="${empty pastResults}">
              <div class="empty-state">
                <div class="icon">🗒️</div>
                <h3>No Attempts Yet</h3>
                <p>Take your first quiz to see results here!</p>
              </div>
            </c:when>
            <c:otherwise>
              <table class="results-table">
                <thead>
                  <tr>
                    <th>#</th>
                    <th>Quiz</th>
                    <th>Score</th>
                    <th>Percentage</th>
                    <th>Grade</th>
                    <th>Date</th>
                    <th>Details</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="r" items="${pastResults}" varStatus="s">
                    <tr>
                      <td><span class="text-muted">${s.count}</span></td>
                      <td><strong>${r.quizTitle}</strong></td>
                      <td>${r.score} / ${r.totalMarks}</td>
                      <td>
                        <c:choose>
                          <c:when test="${r.percentage >= 80}">
                            <span class="score-pill excellent"><fmt:formatNumber value="${r.percentage}" maxFractionDigits="1"/>%</span>
                          </c:when>
                          <c:when test="${r.percentage >= 60}">
                            <span class="score-pill good"><fmt:formatNumber value="${r.percentage}" maxFractionDigits="1"/>%</span>
                          </c:when>
                          <c:when test="${r.percentage >= 40}">
                            <span class="score-pill average"><fmt:formatNumber value="${r.percentage}" maxFractionDigits="1"/>%</span>
                          </c:when>
                          <c:otherwise>
                            <span class="score-pill poor"><fmt:formatNumber value="${r.percentage}" maxFractionDigits="1"/>%</span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td><strong>${r.grade}</strong></td>
                      <td><fmt:formatDate value="${r.attemptDate}" pattern="dd MMM yyyy, HH:mm"/></td>
                      <td>
                        <a href="${pageContext.request.contextPath}/result?id=${r.id}"
                           class="btn btn-secondary btn-sm">View</a>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

    </div><!-- /page-body -->
  </main>

</div>
<script src="${pageContext.request.contextPath}/js/validation.js"></script>
</body>
</html>
