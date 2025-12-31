package com.communication.servlet;

import com.communication.dao.MessageDAO;
import com.communication.model.Message;
import com.communication.model.User;
import com.communication.util.SecurityUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/message")
public class MessageServlet extends HttpServlet {
    private MessageDAO messageDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        messageDAO = new MessageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        String messageIdStr = request.getParameter("id");
        if (messageIdStr != null) {
            try {
                int messageId = Integer.parseInt(messageIdStr);
                Message message = messageDAO.getMessageById(messageId);
                
                if (message != null) {
                    User user = (User) session.getAttribute("user");
                    if (user.isOfficer()) {
                        messageDAO.markAsRead(messageId);
                        message.setRead(true);
                    }
                    request.setAttribute("message", message);
                    request.getRequestDispatcher("/message-detail.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Message not found");
                    request.getRequestDispatcher("/error.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid message ID");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Only admins can send messages");
            return;
        }

        String subject = SecurityUtil.sanitizeInput(request.getParameter("subject"));
        String content = SecurityUtil.sanitizeInput(request.getParameter("content"));

        if (!SecurityUtil.isValidInput(subject) || !SecurityUtil.isValidInput(content)) {
            request.setAttribute("error", "Subject and content are required");
            request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
            return;
        }

        // Escape HTML to prevent XSS
        subject = SecurityUtil.escapeHtml(subject);
        content = SecurityUtil.escapeHtml(content);

        boolean success = messageDAO.createMessage(user.getId(), subject, content);

        if (success) {
            response.sendRedirect("admin-dashboard?success=Message sent successfully");
        } else {
            request.setAttribute("error", "Failed to send message");
            request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
        }
    }
}

