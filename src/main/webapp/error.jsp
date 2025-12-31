<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Communication System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <div class="error-box">
            <h1>Error</h1>
            <div class="error-message">
                <% if (request.getAttribute("error") != null) { %>
                    <%= request.getAttribute("error") %>
                <% } else { %>
                    An error occurred. Please try again.
                <% } %>
            </div>
            <a href="login" class="btn btn-primary">Return to Login</a>
        </div>
    </div>
</body>
</html>

