<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.communication.model.User" %>
<%@ page import="com.communication.model.Message" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isAdmin()) {
        response.sendRedirect("login");
        return;
    }
    
    List<Message> messages = (List<Message>) request.getAttribute("messages");
    List<User> officers = (List<User>) request.getAttribute("officers");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Communication System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <header class="dashboard-header">
            <h1>Admin Dashboard</h1>
            <div class="user-info">
                <span>Welcome, <%= user.getUsername() %></span>
                <a href="logout" class="btn btn-secondary">Logout</a>
            </div>
        </header>

        <% if (request.getParameter("success") != null) { %>
            <div class="success-message">
                <%= request.getParameter("success") %>
            </div>
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <div class="dashboard-content">
            <div class="dashboard-section">
                <h2>Send Message to All Officers</h2>
                <form action="message" method="post" class="message-form">
                    <div class="form-group">
                        <label for="subject">Subject:</label>
                        <input type="text" id="subject" name="subject" required maxlength="200">
                    </div>
                    
                    <div class="form-group">
                        <label for="content">Message:</label>
                        <textarea id="content" name="content" rows="5" required></textarea>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">Send Message</button>
                </form>
            </div>

            <div class="dashboard-section">
                <h2>Officers (<%= officers != null ? officers.size() : 0 %>)</h2>
                <div class="officer-list">
                    <% if (officers != null && !officers.isEmpty()) { %>
                        <% for (User officer : officers) { %>
                            <div class="officer-item">
                                <span class="badge badge-officer">OFFICER</span>
                                <span><%= officer.getUsername() %></span>
                            </div>
                        <% } %>
                    <% } else { %>
                        <p>No officers found.</p>
                    <% } %>
                </div>
            </div>

            <div class="dashboard-section">
                <h2>Sent Messages</h2>
                <div class="message-list">
                    <% if (messages != null && !messages.isEmpty()) { %>
                        <% for (Message msg : messages) { %>
                            <div class="message-item">
                                <div class="message-header">
                                    <strong><%= msg.getSubject() %></strong>
                                    <span class="message-date"><%= msg.getCreatedAt() %></span>
                                </div>
                                <div class="message-preview">
                                    <%= msg.getContent().length() > 100 ? 
                                        msg.getContent().substring(0, 100) + "..." : 
                                        msg.getContent() %>
                                </div>
                            </div>
                        <% } %>
                    <% } else { %>
                        <p>No messages sent yet.</p>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

