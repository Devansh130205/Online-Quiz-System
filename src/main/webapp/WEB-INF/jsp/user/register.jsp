<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register – Online Quiz System | Linkstatic Techno</title>
  <meta name="description" content="Create a new account on Online Quiz System">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="auth-wrapper">
  <div class="auth-card" style="max-width:520px;">

    <div class="auth-logo">
      <div class="logo-icon">🎓</div>
      <h1>QuizMaster Pro</h1>
      <p>Linkstatic Techno · Java Industrial Training</p>
    </div>

    <h2 class="auth-title">Create Account</h2>
    <p class="auth-subtitle">Join thousands of learners today</p>

    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-danger">⚠️ ${error}</div>
    <% } %>

    <form id="registerForm" action="${pageContext.request.contextPath}/register" method="post" novalidate>

      <div class="form-group">
        <label for="fullName">Full Name</label>
        <div class="input-wrap">
          <input type="text" id="fullName" name="fullName" class="form-control"
                 placeholder="Your full name"
                 value="${fullName != null ? fullName : ''}" required>
          <span class="icon">✍️</span>
        </div>
      </div>

      <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px;">
        <div class="form-group">
          <label for="username">Username</label>
          <div class="input-wrap">
            <input type="text" id="username" name="username" class="form-control"
                   placeholder="min 4 chars"
                   value="${username != null ? username : ''}" required>
            <span class="icon">👤</span>
          </div>
        </div>
        <div class="form-group">
          <label for="email">Email</label>
          <div class="input-wrap">
            <input type="email" id="email" name="email" class="form-control"
                   placeholder="you@example.com"
                   value="${email != null ? email : ''}" required>
            <span class="icon">📧</span>
          </div>
        </div>
      </div>

      <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px;">
        <div class="form-group">
          <label for="password">Password</label>
          <div class="input-wrap">
            <input type="password" id="password" name="password" class="form-control"
                   placeholder="min 6 chars" required>
            <span class="icon">🔒</span>
          </div>
        </div>
        <div class="form-group">
          <label for="confirmPassword">Confirm Password</label>
          <div class="input-wrap">
            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                   placeholder="repeat password" required>
            <span class="icon">🔑</span>
          </div>
        </div>
      </div>

      <button type="submit" class="btn btn-primary btn-block btn-lg" style="margin-top:4px;">
        Create Account →
      </button>
    </form>

    <div class="auth-links" style="margin-top:20px;">
      Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/validation.js"></script>
</body>
</html>
