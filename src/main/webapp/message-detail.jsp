<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.communication.model.User" %>
<%@ page import="com.communication.model.Message" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
    
    Message message = (Message) request.getAttribute("message");
    if (message == null) {
        response.sendRedirect(user.isAdmin() ? "admin-dashboard" : "officer-dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Message Detail - Communication System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <header class="dashboard-header">
            <h1>Message Detail</h1>
            <div class="user-info">
                <a href="<%= user.isAdmin() ? "admin-dashboard" : "officer-dashboard" %>" class="btn btn-secondary">Back</a>
                <a href="logout" class="btn btn-secondary">Logout</a>
            </div>
        </header>

        <div class="dashboard-content">
            <div class="message-detail">
                <div class="message-header">
                    <h2><%= message.getSubject() %></h2>
                    <div class="message-meta">
                        <span><strong>From:</strong> <%= message.getSenderUsername() %></span>
                        <span><strong>Date:</strong> <%= message.getCreatedAt() %></span>
                        <% if (user.isOfficer() && message.isRead()) { %>
                            <span class="badge badge-read">READ</span>
                        <% } %>
                    </div>
                </div>
                <div class="message-content">
                    <%= message.getContent() %>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

