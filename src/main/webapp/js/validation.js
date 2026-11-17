/**
 * validation.js — Client-side form validation for auth and admin forms
 */
(function () {
  'use strict';

  /* ── Helper ───────────────────────── */
  function showError(fieldId, msg) {
    var el = document.getElementById(fieldId);
    if (!el) return;
    el.style.borderColor = '#FF6584';
    var err = document.getElementById(fieldId + '_err');
    if (!err) {
      err = document.createElement('span');
      err.id = fieldId + '_err';
      err.style.cssText = 'color:#FF8FA3;font-size:0.78rem;margin-top:4px;display:block;';
      el.parentNode.appendChild(err);
    }
    err.textContent = msg;
  }

  function clearError(fieldId) {
    var el = document.getElementById(fieldId);
    if (el) el.style.borderColor = '';
    var err = document.getElementById(fieldId + '_err');
    if (err) err.remove();
  }

  function isEmpty(val) { return !val || val.trim() === ''; }
  function isEmail(val) { return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val); }

  /* ── Registration form ────────────── */
  function validateRegister() {
    var ok = true;
    var fields = ['fullName', 'username', 'email', 'password', 'confirmPassword'];
    fields.forEach(function (f) { clearError(f); });

    var fullName = document.getElementById('fullName');
    var username = document.getElementById('username');
    var email    = document.getElementById('email');
    var password = document.getElementById('password');
    var confirm  = document.getElementById('confirmPassword');

    if (fullName && isEmpty(fullName.value)) {
      showError('fullName', 'Full name is required.'); ok = false;
    }
    if (username && (isEmpty(username.value) || username.value.trim().length < 4)) {
      showError('username', 'Username must be at least 4 characters.'); ok = false;
    }
    if (email && (!isEmpty(email.value) ? !isEmail(email.value) : true)) {
      showError('email', 'Enter a valid email address.'); ok = false;
    }
    if (password && password.value.length < 6) {
      showError('password', 'Password must be at least 6 characters.'); ok = false;
    }
    if (confirm && password && confirm.value !== password.value) {
      showError('confirmPassword', 'Passwords do not match.'); ok = false;
    }
    return ok;
  }

  /* ── Login form ───────────────────── */
  function validateLogin() {
    var ok = true;
    ['username', 'password'].forEach(function (f) { clearError(f); });

    var username = document.getElementById('username');
    var password = document.getElementById('password');

    if (username && isEmpty(username.value)) {
      showError('username', 'Username is required.'); ok = false;
    }
    if (password && isEmpty(password.value)) {
      showError('password', 'Password is required.'); ok = false;
    }
    return ok;
  }

  /* ── Admin quiz form ──────────────── */
  function validateQuizForm() {
    var ok = true;
    ['title', 'category', 'timeLimit'].forEach(function (f) { clearError(f); });

    var title    = document.getElementById('title');
    var category = document.getElementById('category');
    var tLimit   = document.getElementById('timeLimit');

    if (title && isEmpty(title.value)) {
      showError('title', 'Quiz title is required.'); ok = false;
    }
    if (category && isEmpty(category.value)) {
      showError('category', 'Category is required.'); ok = false;
    }
    if (tLimit && (isEmpty(tLimit.value) || parseInt(tLimit.value) < 1)) {
      showError('timeLimit', 'Time limit must be at least 1 minute.'); ok = false;
    }
    return ok;
  }

  /* ── Auto-attach ──────────────────── */
  document.addEventListener('DOMContentLoaded', function () {
    var regForm = document.getElementById('registerForm');
    if (regForm) regForm.addEventListener('submit', function (e) {
      if (!validateRegister()) e.preventDefault();
    });

    var loginForm = document.getElementById('loginForm');
    if (loginForm) loginForm.addEventListener('submit', function (e) {
      if (!validateLogin()) e.preventDefault();
    });

    var quizForm = document.getElementById('adminQuizForm');
    if (quizForm) quizForm.addEventListener('submit', function (e) {
      if (!validateQuizForm()) e.preventDefault();
    });

    // Auto-dismiss alerts after 5 seconds
    var alerts = document.querySelectorAll('.alert');
    alerts.forEach(function (a) {
      setTimeout(function () {
        a.style.transition = 'opacity 0.5s';
        a.style.opacity = '0';
        setTimeout(function () { a.remove(); }, 500);
      }, 5000);
    });
  });

  /* ── Score ring animation (result page) ── */
  window.animateScoreRing = function (percentage) {
    var circle = document.getElementById('scoreRingFill');
    if (!circle) return;
    var r = circle.getAttribute('r');
    var circumference = 2 * Math.PI * r;
    circle.style.strokeDasharray = circumference;
    circle.style.strokeDashoffset = circumference;
    setTimeout(function () {
      var offset = circumference - (percentage / 100) * circumference;
      circle.style.strokeDashoffset = offset;
    }, 200);
  };

})();
