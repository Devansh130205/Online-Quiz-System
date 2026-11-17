<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login – Online Quiz System | Linkstatic Techno</title>
  <meta name="description" content="Login to Online Quiz System by Linkstatic Techno">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="auth-wrapper">
  <div class="auth-card">

    <!-- Logo -->
    <div class="auth-logo">
      <div class="logo-icon">🎯</div>
      <h1>QuizMaster Pro</h1>
      <p>Linkstatic Techno · Java Industrial Training</p>
    </div>

    <h2 class="auth-title">Welcome Back!</h2>
    <p class="auth-subtitle">Sign in to your account to continue</p>

    <!-- Alert Messages -->
    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-danger">⚠️ ${error}</div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
      <div class="alert alert-success">✅ ${success}</div>
    <% } %>

    <!-- Login Form -->
    <form id="loginForm" action="${pageContext.request.contextPath}/login" method="post" novalidate>
      <div class="form-group">
        <label for="username">Username</label>
        <div class="input-wrap">
          <input type="text" id="username" name="username" class="form-control"
                 placeholder="Enter your username"
                 value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>"
                 autocomplete="username" required>
          <span class="icon">👤</span>
        </div>
      </div>

      <div class="form-group">
        <label for="password">Password</label>
        <div class="input-wrap">
          <input type="password" id="password" name="password" class="form-control"
                 placeholder="Enter your password"
                 autocomplete="current-password" required>
          <span class="icon">🔒</span>
        </div>
      </div>

      <button type="submit" class="btn btn-primary btn-block btn-lg" style="margin-top:8px;">
        Sign In →
      </button>
    </form>

    <div class="divider">or</div>

    <div class="auth-links">
      Don't have an account?
      <a href="${pageContext.request.contextPath}/register">Create one now</a>
    </div>

    <div class="auth-links" style="margin-top:12px;">
      Are you an Admin?
      <a href="${pageContext.request.contextPath}/admin/login">Admin Login</a>
    </div>

    <!-- Demo credentials hint -->
    <div style="margin-top:24px; padding:12px 16px; background:rgba(108,99,255,0.08); border:1px solid rgba(108,99,255,0.2); border-radius:10px; font-size:0.78rem; color:#9898B3;">
      <strong style="color:#8B85FF;">Demo:</strong> username: <code style="color:#43E97B;">john_doe</code> &nbsp;|&nbsp; password: <code style="color:#43E97B;">pass123</code>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/validation.js"></script>
</body>
</html>
