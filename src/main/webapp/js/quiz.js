/**
 * quiz.js — Quiz navigation & progress tracking
 */
(function () {
  'use strict';

  var currentIndex = 0;
  var totalQuestions = 0;
  var answered = [];

  function init() {
    var slides = document.querySelectorAll('.question-slide');
    totalQuestions = slides.length;
    answered = new Array(totalQuestions).fill(false);

    // Show first question
    showQuestion(0);

    // Listen for radio changes
    document.querySelectorAll('input[type="radio"]').forEach(function (radio) {
      radio.addEventListener('change', function () {
        var idx = parseInt(this.dataset.qindex, 10);
        answered[idx] = true;
        updateDots();
        updateProgress();
        // Auto-advance after a short delay
        setTimeout(function () {
          if (idx < totalQuestions - 1) {
            showQuestion(idx + 1);
          } else {
            checkSubmit();
          }
        }, 400);
      });
    });

    // Keyboard navigation
    document.addEventListener('keydown', function (e) {
      if (e.key === 'ArrowRight' || e.key === 'Enter' && e.ctrlKey) nextQuestion();
      if (e.key === 'ArrowLeft') prevQuestion();
    });
  }

  function showQuestion(idx) {
    if (idx < 0 || idx >= totalQuestions) return;
    var slides = document.querySelectorAll('.question-slide');
    slides.forEach(function (s, i) {
      s.classList.toggle('active', i === idx);
    });
    currentIndex = idx;
    updateDots();
    updateProgress();
    updateNavButtons();
  }

  function nextQuestion() {
    if (currentIndex < totalQuestions - 1) showQuestion(currentIndex + 1);
  }

  function prevQuestion() {
    if (currentIndex > 0) showQuestion(currentIndex - 1);
  }

  function updateDots() {
    var dots = document.querySelectorAll('.q-dot');
    dots.forEach(function (dot, i) {
      dot.className = 'q-dot';
      if (answered[i]) dot.classList.add('answered');
      if (i === currentIndex) dot.classList.add('current');
    });
  }

  function updateProgress() {
    var count = answered.filter(Boolean).length;
    var pct = totalQuestions > 0 ? (count / totalQuestions) * 100 : 0;
    var fill = document.getElementById('progressFill');
    var info  = document.getElementById('progressInfo');
    if (fill) fill.style.width = pct + '%';
    if (info) info.textContent = count + ' of ' + totalQuestions + ' answered';
  }

  function updateNavButtons() {
    var btnPrev = document.getElementById('btnPrev');
    var btnNext = document.getElementById('btnNext');
    var btnSubmit = document.getElementById('btnSubmit');

    if (btnPrev) btnPrev.disabled = currentIndex === 0;
    if (btnNext) btnNext.style.display = currentIndex < totalQuestions - 1 ? 'inline-flex' : 'none';
    checkSubmit();
  }

  function checkSubmit() {
    var btnSubmit = document.getElementById('btnSubmit');
    if (!btnSubmit) return;
    if (currentIndex === totalQuestions - 1) {
      btnSubmit.style.display = 'inline-flex';
    } else {
      btnSubmit.style.display = 'none';
    }
  }

  function confirmSubmit() {
    var unanswered = answered.filter(function (a) { return !a; }).length;
    if (unanswered > 0) {
      return confirm(unanswered + ' question(s) are unanswered. Submit anyway?');
    }
    return confirm('Are you sure you want to submit the quiz?');
  }

  // Public API
  window.QuizNav = {
    init: init,
    next: nextQuestion,
    prev: prevQuestion,
    goto: showQuestion,
    confirmSubmit: confirmSubmit
  };
})();
