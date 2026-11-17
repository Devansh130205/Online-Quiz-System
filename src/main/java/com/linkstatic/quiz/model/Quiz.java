package com.linkstatic.quiz.model;

import java.sql.Timestamp;

/**
 * Quiz model — maps to the 'quizzes' table.
 */
public class Quiz {

    private int       id;
    private String    title;
    private String    description;
    private String    category;
    private int       timeLimit;        // minutes
    private int       totalQuestions;
    private boolean   isActive;
    private Timestamp createdAt;

    public Quiz() {}

    public Quiz(int id, String title, String description, String category,
                int timeLimit, int totalQuestions, boolean isActive, Timestamp createdAt) {
        this.id             = id;
        this.title          = title;
        this.description    = description;
        this.category       = category;
        this.timeLimit      = timeLimit;
        this.totalQuestions = totalQuestions;
        this.isActive       = isActive;
        this.createdAt      = createdAt;
    }

    // ── Getters & Setters ────────────────────────────────────────────────────

    public int getId()                           { return id; }
    public void setId(int id)                   { this.id = id; }

    public String getTitle()                     { return title; }
    public void setTitle(String title)           { this.title = title; }

    public String getDescription()               { return description; }
    public void setDescription(String desc)      { this.description = desc; }

    public String getCategory()                  { return category; }
    public void setCategory(String category)     { this.category = category; }

    public int getTimeLimit()                    { return timeLimit; }
    public void setTimeLimit(int timeLimit)      { this.timeLimit = timeLimit; }

    public int getTotalQuestions()               { return totalQuestions; }
    public void setTotalQuestions(int total)     { this.totalQuestions = total; }

    public boolean isActive()                    { return isActive; }
    public void setActive(boolean active)        { this.isActive = active; }

    public Timestamp getCreatedAt()              { return createdAt; }
    public void setCreatedAt(Timestamp createdAt){ this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "Quiz{id=" + id + ", title='" + title + "', category='" + category + "'}";
    }
}
