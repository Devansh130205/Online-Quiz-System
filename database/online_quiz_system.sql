-- ============================================================
--  Online Quiz System - MySQL Database Script
--  Organization : Linkstatic Techno
--  Version      : 1.0
--  Execute this in MySQL Workbench or CLI:
--    mysql -u root -p < online_quiz_system.sql
-- ============================================================

DROP DATABASE IF EXISTS online_quiz_system;
CREATE DATABASE online_quiz_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE online_quiz_system;

-- ============================================================
-- TABLE: admins
-- ============================================================
CREATE TABLE admins (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    email       VARCHAR(100) NOT NULL UNIQUE,
    password    VARCHAR(64)  NOT NULL COMMENT 'MD5 hashed password',
    full_name   VARCHAR(100) NOT NULL,
    created_at  DATETIME     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- TABLE: users
-- ============================================================
CREATE TABLE users (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    email       VARCHAR(100) NOT NULL UNIQUE,
    password    VARCHAR(64)  NOT NULL COMMENT 'MD5 hashed password',
    full_name   VARCHAR(100) NOT NULL,
    created_at  DATETIME     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- TABLE: quizzes
-- ============================================================
CREATE TABLE quizzes (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    title            VARCHAR(150) NOT NULL,
    description      TEXT,
    category         VARCHAR(80)  NOT NULL,
    time_limit       INT          NOT NULL DEFAULT 10 COMMENT 'Time in minutes',
    total_questions  INT          NOT NULL DEFAULT 0,
    is_active        TINYINT(1)   NOT NULL DEFAULT 1,
    created_at       DATETIME     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- TABLE: questions
-- ============================================================
CREATE TABLE questions (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    quiz_id         INT          NOT NULL,
    question_text   TEXT         NOT NULL,
    option_a        VARCHAR(255) NOT NULL,
    option_b        VARCHAR(255) NOT NULL,
    option_c        VARCHAR(255) NOT NULL,
    option_d        VARCHAR(255) NOT NULL,
    correct_answer  CHAR(1)      NOT NULL COMMENT 'A, B, C, or D',
    marks           INT          NOT NULL DEFAULT 1,
    CONSTRAINT fk_question_quiz FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- TABLE: quiz_results
-- ============================================================
CREATE TABLE quiz_results (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    user_id      INT          NOT NULL,
    quiz_id      INT          NOT NULL,
    score        INT          NOT NULL DEFAULT 0,
    total_marks  INT          NOT NULL DEFAULT 0,
    percentage   DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    time_taken   INT          NOT NULL DEFAULT 0 COMMENT 'Seconds taken',
    attempt_date DATETIME     DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_result_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_result_quiz FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- TABLE: quiz_answers
-- ============================================================
CREATE TABLE quiz_answers (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    result_id        INT    NOT NULL,
    question_id      INT    NOT NULL,
    selected_answer  CHAR(1),
    is_correct       TINYINT(1) NOT NULL DEFAULT 0,
    CONSTRAINT fk_answer_result   FOREIGN KEY (result_id)   REFERENCES quiz_results(id) ON DELETE CASCADE,
    CONSTRAINT fk_answer_question FOREIGN KEY (question_id) REFERENCES questions(id)    ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- SAMPLE DATA: Admins
-- Credentials: admin / admin123
-- ============================================================
INSERT INTO admins (username, email, password, full_name) VALUES
('admin', 'admin@linkstatic.com', MD5('admin123'), 'Administrator');

-- ============================================================
-- SAMPLE DATA: Users
-- Credentials: john_doe / pass123   |   jane_doe / pass123
-- ============================================================
INSERT INTO users (username, email, password, full_name) VALUES
('john_doe', 'john@example.com',  MD5('pass123'), 'John Doe'),
('jane_doe', 'jane@example.com',  MD5('pass123'), 'Jane Doe');

-- ============================================================
-- SAMPLE DATA: Quizzes
-- ============================================================
INSERT INTO quizzes (title, description, category, time_limit, total_questions) VALUES
('Java Fundamentals',
 'Test your knowledge of core Java concepts including OOP, data types, and control flow.',
 'Programming', 15, 10),

('Database & SQL Basics',
 'Quiz on SQL queries, database design, normalization, and MySQL features.',
 'Database', 12, 10),

('Web Development Basics',
 'Questions on HTML, CSS, JavaScript, and web technologies.',
 'Web Development', 10, 10);

-- ============================================================
-- SAMPLE DATA: Questions – Quiz 1 (Java Fundamentals)
-- ============================================================
INSERT INTO questions (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_answer, marks) VALUES
(1, 'What is the default value of an int variable in Java?',
 '0', 'null', '-1', 'undefined', 'A', 1),

(1, 'Which keyword is used to inherit a class in Java?',
 'implements', 'inherits', 'extends', 'super', 'C', 1),

(1, 'What does JVM stand for?',
 'Java Virtual Machine', 'Java Variable Method', 'Java Verified Module', 'Java Value Manager', 'A', 1),

(1, 'Which of the following is NOT a primitive data type in Java?',
 'int', 'boolean', 'String', 'char', 'C', 1),

(1, 'What is the correct way to declare a constant in Java?',
 'constant int X = 5', 'final int X = 5', 'static int X = 5', 'readonly int X = 5', 'B', 1),

(1, 'Which method is the entry point of a Java program?',
 'start()', 'run()', 'init()', 'main()', 'D', 1),

(1, 'What is the size of a boolean data type in Java?',
 '1 bit', '1 byte', '2 bytes', 'JVM dependent', 'D', 1),

(1, 'Which access modifier allows access from the same package only?',
 'public', 'private', 'protected', 'default (no modifier)', 'D', 1),

(1, 'What does the "this" keyword refer to in Java?',
 'The parent class', 'The current object', 'A static reference', 'The main method', 'B', 1),

(1, 'Which Java interface is used for comparing objects?',
 'Comparable', 'Serializable', 'Cloneable', 'Iterable', 'A', 1);

-- ============================================================
-- SAMPLE DATA: Questions – Quiz 2 (Database & SQL Basics)
-- ============================================================
INSERT INTO questions (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_answer, marks) VALUES
(2, 'Which SQL command is used to retrieve data from a database?',
 'GET', 'FETCH', 'SELECT', 'RETRIEVE', 'C', 1),

(2, 'Which clause is used to filter rows in a SQL query?',
 'GROUP BY', 'ORDER BY', 'HAVING', 'WHERE', 'D', 1),

(2, 'What does DDL stand for in SQL?',
 'Data Definition Language', 'Data Display Logic', 'Database Definition Layer', 'Dynamic Data Link', 'A', 1),

(2, 'Which SQL statement is used to add new rows to a table?',
 'UPDATE', 'ADD', 'INSERT INTO', 'APPEND', 'C', 1),

(2, 'Which constraint ensures all values in a column are unique?',
 'PRIMARY KEY', 'NOT NULL', 'UNIQUE', 'FOREIGN KEY', 'C', 1),

(2, 'Which JOIN returns only matching rows from both tables?',
 'LEFT JOIN', 'RIGHT JOIN', 'FULL OUTER JOIN', 'INNER JOIN', 'D', 1),

(2, 'What is the purpose of the GROUP BY clause?',
 'Sort rows', 'Filter rows', 'Group rows by column value', 'Join tables', 'C', 1),

(2, 'Which function returns the total count of rows?',
 'SUM()', 'TOTAL()', 'COUNT()', 'NUM()', 'C', 1),

(2, 'What does normalization in a database aim to do?',
 'Increase data redundancy', 'Improve query speed', 'Reduce data redundancy', 'Add more tables', 'C', 1),

(2, 'Which command permanently removes a table from the database?',
 'DELETE TABLE', 'REMOVE TABLE', 'DROP TABLE', 'TRUNCATE TABLE', 'C', 1);

-- ============================================================
-- SAMPLE DATA: Questions – Quiz 3 (Web Development Basics)
-- ============================================================
INSERT INTO questions (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_answer, marks) VALUES
(3, 'What does HTML stand for?',
 'Hyperlinks and Text Markup Language', 'Hyper Text Markup Language', 'Home Tool Markup Language', 'Hyper Text Machine Language', 'B', 1),

(3, 'Which CSS property is used to change the text color?',
 'font-color', 'text-color', 'color', 'foreground-color', 'C', 1),

(3, 'Which HTML tag is used to create a hyperlink?',
 '<link>', '<href>', '<a>', '<url>', 'C', 1),

(3, 'What does CSS stand for?',
 'Creative Style Sheets', 'Computer Style Sheets', 'Cascading Style Sheets', 'Colorful Style Sheets', 'C', 1),

(3, 'Which JavaScript method is used to find an HTML element by ID?',
 'document.getElement()', 'document.findElementById()', 'document.getElementById()', 'document.queryId()', 'C', 1),

(3, 'What is the correct HTML element for the largest heading?',
 '<heading>', '<h6>', '<h1>', '<head>', 'C', 1),

(3, 'Which HTTP method is used to send form data to a server?',
 'GET', 'POST', 'PUT', 'SEND', 'B', 1),

(3, 'What does responsive web design mean?',
 'The site responds slowly', 'Design adapts to screen size', 'The server responds fast', 'Using JavaScript animations', 'B', 1),

(3, 'Which CSS display value makes an element a flex container?',
 'display: grid', 'display: block', 'display: inline', 'display: flex', 'D', 1),

(3, 'Which tag is used to link an external CSS file?',
 '<css>', '<style src="">', '<link rel="stylesheet">', '<script type="css">', 'C', 1);

-- ============================================================
-- SAMPLE DATA: Quiz Results (sample historical data)
-- ============================================================
INSERT INTO quiz_results (user_id, quiz_id, score, total_marks, percentage, time_taken) VALUES
(1, 1, 8, 10, 80.00, 420),
(1, 2, 7, 10, 70.00, 380),
(2, 1, 9, 10, 90.00, 300),
(2, 3, 6, 10, 60.00, 450);

-- ============================================================
-- Verify data
-- ============================================================
SELECT 'Database setup complete!' AS Status;
SELECT COUNT(*) AS TotalQuizzes   FROM quizzes;
SELECT COUNT(*) AS TotalQuestions FROM questions;
SELECT COUNT(*) AS TotalUsers     FROM users;
SELECT COUNT(*) AS TotalAdmins    FROM admins;
