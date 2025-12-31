<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.communication.model.User" %>
<%@ page import="com.communication.model.Message" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isOfficer()) {
        response.sendRedirect("login");
        return;
    }
    
    List<Message> messages = (List<Message>) request.getAttribute("messages");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Officer Dashboard - Communication System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <header class="dashboard-header">
            <h1>Officer Dashboard</h1>
            <div class="user-info">
                <span>Welcome, <%= user.getUsername() %></span>
                <a href="logout" class="btn btn-secondary">Logout</a>
            </div>
        </header>

        <div class="dashboard-content">
            <div class="dashboard-section">
                <h2>Messages</h2>
                <div class="message-list">
                    <% if (messages != null && !messages.isEmpty()) { %>
                        <% for (Message msg : messages) { %>
                            <div class="message-item <%= !msg.isRead() ? "unread" : "" %>">
                                <div class="message-header">
                                    <strong>
                                        <a href="message?id=<%= msg.getId() %>"><%= msg.getSubject() %></a>
                                    </strong>
                                    <% if (!msg.isRead()) { %>
                                        <span class="badge badge-unread">NEW</span>
                                    <% } %>
                                    <span class="message-date"><%= msg.getCreatedAt() %></span>
                                </div>
                                <div class="message-meta">
                                    <span>From: <%= msg.getSenderUsername() %></span>
                                </div>
                                <div class="message-preview">
                                    <%= msg.getContent().length() > 150 ? 
                                        msg.getContent().substring(0, 150) + "..." : 
                                        msg.getContent() %>
                                </div>
                            </div>
                        <% } %>
                    <% } else { %>
                        <p>No messages received.</p>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

