<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Login – Online Quiz System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
<div class="auth-wrapper">
  <div class="auth-card admin-auth-card">

    <div class="auth-logo">
      <div class="logo-icon" style="background:linear-gradient(135deg,#FF6584,#E84393);">🛡️</div>
      <h1>Admin Portal</h1>
      <p>Online Quiz System · Linkstatic Techno</p>
    </div>

    <h2 class="auth-title">Admin Sign In</h2>
    <p class="auth-subtitle">Restricted access — authorized personnel only</p>

    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-danger">🔒 ${error}</div>
    <% } %>

    <form id="adminLoginForm" action="${pageContext.request.contextPath}/admin/login" method="post">
      <div class="form-group">
        <label for="username">Admin Username</label>
        <div class="input-wrap">
          <input type="text" id="username" name="username" class="form-control"
                 placeholder="admin" autocomplete="username" required>
          <span class="icon">🛡️</span>
        </div>
      </div>

      <div class="form-group">
        <label for="password">Admin Password</label>
        <div class="input-wrap">
          <input type="password" id="password" name="password" class="form-control"
                 placeholder="••••••••" autocomplete="current-password" required>
          <span class="icon">🔐</span>
        </div>
      </div>

      <button type="submit" class="btn btn-block btn-lg" style="background:linear-gradient(135deg,#FF6584,#E84393);color:#fff;box-shadow:0 4px 20px rgba(255,101,132,0.4);margin-top:8px;">
        Admin Sign In →
      </button>
    </form>

    <div class="auth-links" style="margin-top:20px;">
      <a href="${pageContext.request.contextPath}/login">← Back to User Login</a>
    </div>

    <div style="margin-top:20px; padding:12px 16px; background:rgba(255,101,132,0.08); border:1px solid rgba(255,101,132,0.2); border-radius:10px; font-size:0.78rem; color:#9898B3;">
      <strong style="color:#FF8FA3;">Demo:</strong> username: <code style="color:#43E97B;">admin</code> &nbsp;|&nbsp; password: <code style="color:#43E97B;">admin123</code>
    </div>
  </div>
</div>
</body>
</html>
