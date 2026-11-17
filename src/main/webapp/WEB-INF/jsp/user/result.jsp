<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.linkstatic.quiz.model.Result" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    Result result = (Result) request.getAttribute("result");
    if (result == null) { response.sendRedirect(request.getContextPath() + "/dashboard"); return; }

    double pct = result.getPercentage();
    String emoji = pct >= 90 ? "🏆" : pct >= 70 ? "🎉" : pct >= 50 ? "👍" : "📚";
    String msg   = pct >= 90 ? "Outstanding Performance!" : pct >= 70 ? "Great Job!" : pct >= 50 ? "Good Effort!" : "Keep Practicing!";

    // SVG ring constants
    double r = 60;
    double circumference = 2 * Math.PI * r;
    double offset = circumference - (pct / 100.0) * circumference;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quiz Result – Online Quiz System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/quiz.css">
</head>
<body>
<div class="result-wrapper">
  <div class="result-card">

    <!-- Trophy / Emoji -->
    <span class="result-trophy"><%= emoji %></span>

    <!-- Grade -->
    <div class="result-grade"><%= result.getGrade() %></div>
    <div class="result-title"><%= msg %></div>
    <div class="result-subtitle">
      <%= result.getQuizTitle() != null ? result.getQuizTitle() : "Quiz" %>
      &nbsp;·&nbsp; Completed <fmt:formatDate value="${result.attemptDate}" pattern="dd MMM yyyy, HH:mm"/>
    </div>

    <!-- Score Circle -->
    <div class="score-circle-wrap">
      <svg class="score-ring" width="160" height="160" viewBox="0 0 160 160">
        <defs>
          <linearGradient id="scoreGradient" x1="0%" y1="0%" x2="100%" y2="0%">
            <stop offset="0%"   stop-color="#6C63FF"/>
            <stop offset="100%" stop-color="#38F9D7"/>
          </linearGradient>
        </defs>
        <circle class="ring-bg"   cx="80" cy="80" r="<%= (int)r %>"/>
        <circle class="ring-fill" cx="80" cy="80" r="<%= (int)r %>"
                id="scoreRingFill"
                stroke-dasharray="<%= String.format("%.2f", circumference) %>"
                stroke-dashoffset="<%= String.format("%.2f", circumference) %>"/>
      </svg>
      <div class="score-center">
        <span class="score-pct"><fmt:formatNumber value="${result.percentage}" maxFractionDigits="1"/>%</span>
        <span class="score-label">Score</span>
      </div>
    </div>

    <!-- Stats Breakdown -->
    <div class="result-stats">
      <div class="res-stat">
        <div class="res-num">${result.score}</div>
        <div class="res-lbl">Points Scored</div>
      </div>
      <div class="res-stat correct">
        <div class="res-num">${result.correctAnswers}</div>
        <div class="res-lbl">Correct</div>
      </div>
      <div class="res-stat incorrect">
        <div class="res-num">${result.incorrectAnswers}</div>
        <div class="res-lbl">Incorrect</div>
      </div>
    </div>

    <!-- Extra info row -->
    <div style="display:flex; justify-content:center; gap:28px; margin-bottom:28px; font-size:0.85rem; color:#9898B3;">
      <span>📋 Total: <strong style="color:#EAEAF0;">${result.totalMarks}</strong> marks</span>
      <span>⏱ Time: <strong style="color:#EAEAF0;">${result.formattedTime}</strong></span>
      <span>⏭ Skipped: <strong style="color:#EAEAF0;">${result.unanswered}</strong></span>
    </div>

    <!-- Actions -->
    <div class="result-actions">
      <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
        🏠 Dashboard
      </a>
      <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">
        📋 Try Another Quiz
      </a>
    </div>

  </div>
</div>
<script src="${pageContext.request.contextPath}/js/validation.js"></script>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    animateScoreRing(<%= pct %>);
  });
</script>
</body>
</html>
