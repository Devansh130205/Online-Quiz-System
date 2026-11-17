<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.linkstatic.quiz.model.Quiz, com.linkstatic.quiz.model.Question, java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    Quiz quiz = (Quiz) request.getAttribute("quiz");
    @SuppressWarnings("unchecked")
    List<Question> questions = (List<Question>) request.getAttribute("questions");
    if (quiz == null || questions == null || questions.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }
    int totalQuestions = questions.size();
    int timeLimitMinutes = quiz.getTimeLimit();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%= quiz.getTitle() %> – Online Quiz System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/quiz.css">
</head>
<body>
<div class="quiz-wrapper">

  <!-- ── Header ── -->
  <header class="quiz-header">
    <div class="quiz-brand">
      <div class="icon">🎯</div>
      <div>
        <h1><%= quiz.getTitle() %></h1>
        <div class="quiz-category"><%= quiz.getCategory() %></div>
      </div>
    </div>

    <div class="timer-box" id="timerBox">
      <span class="timer-icon">⏱</span>
      <span class="timer-display" id="timerDisplay"><%
          int mins = timeLimitMinutes;
      %><%=String.format("%02d:00", mins)%></span>
    </div>

    <a href="${pageContext.request.contextPath}/dashboard"
       onclick="return confirm('Exit quiz? Your progress will be lost.');"
       class="btn btn-secondary btn-sm">✕ Exit</a>
  </header>

  <!-- ── Progress Bar ── -->
  <div class="quiz-progress">
    <div class="progress-info">
      <span id="progressInfo">0 of <%= totalQuestions %> answered</span>
      <span>Question <span id="currentQNum">1</span> of <%= totalQuestions %></span>
    </div>
    <div class="progress-track">
      <div class="progress-fill" id="progressFill" style="width:0%"></div>
    </div>
  </div>

  <!-- ── Time-up Banner (hidden by default) ── -->
  <div id="timeupBanner" style="display:none; position:fixed; top:0;left:0;right:0; padding:16px; background:rgba(255,101,132,0.9); color:#fff; text-align:center; font-weight:700; z-index:999; align-items:center; justify-content:center; gap:12px;">
    ⏰ Time's up! Submitting your quiz...
  </div>

  <!-- ── Quiz Form ── -->
  <div class="quiz-body">
    <div class="question-panel">
      <form id="quizForm" action="${pageContext.request.contextPath}/submit-quiz" method="post">

        <% for (int i = 0; i < questions.size(); i++) {
              Question q = questions.get(i);
        %>
        <div class="question-slide" id="slide_<%= i %>">
          <div class="question-number">
            Question <%= i + 1 %> of <%= totalQuestions %>
          </div>

          <div class="question-text"><%= q.getQuestionText() %></div>

          <ul class="options-list">
            <li class="option-item">
              <input type="radio" id="q<%= q.getId() %>_A"
                     name="answer_<%= q.getId() %>"
                     value="A" data-qindex="<%= i %>">
              <label for="q<%= q.getId() %>_A">
                <span class="option-letter">A</span>
                <span class="option-text"><%= q.getOptionA() %></span>
              </label>
            </li>
            <li class="option-item">
              <input type="radio" id="q<%= q.getId() %>_B"
                     name="answer_<%= q.getId() %>"
                     value="B" data-qindex="<%= i %>">
              <label for="q<%= q.getId() %>_B">
                <span class="option-letter">B</span>
                <span class="option-text"><%= q.getOptionB() %></span>
              </label>
            </li>
            <li class="option-item">
              <input type="radio" id="q<%= q.getId() %>_C"
                     name="answer_<%= q.getId() %>"
                     value="C" data-qindex="<%= i %>">
              <label for="q<%= q.getId() %>_C">
                <span class="option-letter">C</span>
                <span class="option-text"><%= q.getOptionC() %></span>
              </label>
            </li>
            <li class="option-item">
              <input type="radio" id="q<%= q.getId() %>_D"
                     name="answer_<%= q.getId() %>"
                     value="D" data-qindex="<%= i %>">
              <label for="q<%= q.getId() %>_D">
                <span class="option-letter">D</span>
                <span class="option-text"><%= q.getOptionD() %></span>
              </label>
            </li>
          </ul>
        </div>
        <% } %>

        <!-- Navigation -->
        <div class="quiz-navigation">
          <button type="button" id="btnPrev" class="btn btn-secondary"
                  onclick="QuizNav.prev()" disabled>← Previous</button>

          <div class="question-dots">
            <% for (int i = 0; i < totalQuestions; i++) { %>
              <button type="button" class="q-dot" id="dot_<%= i %>"
                      onclick="QuizNav.goto(<%= i %>)" title="Question <%= i+1 %>"></button>
            <% } %>
          </div>

          <div style="display:flex; gap:12px;">
            <button type="button" id="btnNext" class="btn btn-primary"
                    onclick="QuizNav.next()">Next →</button>
            <button type="submit" id="btnSubmit" class="btn-submit"
                    onclick="return QuizNav.confirmSubmit()">
              🏁 Submit Quiz
            </button>
          </div>
        </div>

      </form>
    </div>
  </div>

</div>

<script src="${pageContext.request.contextPath}/js/quiz.js"></script>
<script src="${pageContext.request.contextPath}/js/quiz-timer.js"></script>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    QuizNav.init();
    QuizTimer.init(<%= timeLimitMinutes %>, 'quizForm');

    // Update current question number in header
    var origGoto = QuizNav.goto;
    // Patch to update question counter
    var slides = document.querySelectorAll('.question-slide');
    var observer = new MutationObserver(function() {
      for (var i = 0; i < slides.length; i++) {
        if (slides[i].classList.contains('active')) {
          document.getElementById('currentQNum').textContent = i + 1;
          break;
        }
      }
    });
    slides.forEach(function(s) { observer.observe(s, { attributes: true }); });
  });
</script>
</body>
</html>
