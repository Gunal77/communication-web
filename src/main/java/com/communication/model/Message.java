package com.communication.model;

import java.sql.Timestamp;

public class Message {
    private int id;
    private int senderId;
    private String senderUsername;
    private String subject;
    private String content;
    private Timestamp createdAt;
    private boolean isRead;

    public Message() {
    }

    public Message(int id, int senderId, String subject, String content, Timestamp createdAt, boolean isRead) {
        this.id = id;
        this.senderId = senderId;
        this.subject = subject;
        this.content = content;
        this.createdAt = createdAt;
        this.isRead = isRead;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSenderId() {
        return senderId;
    }

    public void setSenderId(int senderId) {
        this.senderId = senderId;
    }

    public String getSenderUsername() {
        return senderUsername;
    }

    public void setSenderUsername(String senderUsername) {
        this.senderUsername = senderUsername;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }
}

