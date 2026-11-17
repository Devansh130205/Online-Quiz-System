/**
 * quiz-timer.js — Countdown timer for quiz page
 */
(function () {
  'use strict';

  var totalSeconds = 0;
  var remainingSeconds = 0;
  var timerInterval = null;
  var display = null;
  var form = null;
  var autoSubmitted = false;

  function init(timeLimitMinutes, formId) {
    totalSeconds = timeLimitMinutes * 60;
    remainingSeconds = totalSeconds;
    display = document.getElementById('timerDisplay');
    form = document.getElementById(formId || 'quizForm');
    tick();
    timerInterval = setInterval(tick, 1000);
  }

  function tick() {
    updateDisplay();
    if (remainingSeconds <= 0) {
      clearInterval(timerInterval);
      if (!autoSubmitted) {
        autoSubmitted = true;
        autoSubmit();
      }
      return;
    }
    remainingSeconds--;
  }

  function updateDisplay() {
    var mins = Math.floor(remainingSeconds / 60);
    var secs = remainingSeconds % 60;
    var str = pad(mins) + ':' + pad(secs);
    if (display) {
      display.textContent = str;
      display.className = 'timer-display';
      if (remainingSeconds <= 60)  display.className += ' danger';
      else if (remainingSeconds <= 180) display.className += ' warning';
    }
  }

  function pad(n) {
    return n < 10 ? '0' + n : '' + n;
  }

  function autoSubmit() {
    if (form) {
      var banner = document.getElementById('timeupBanner');
      if (banner) {
        banner.style.display = 'flex';
        setTimeout(function () { form.submit(); }, 2000);
      } else {
        form.submit();
      }
    }
  }

  // Public API
  window.QuizTimer = { init: init };
})();
