package com.communication.servlet;

import com.communication.dao.MessageDAO;
import com.communication.dao.UserDAO;
import com.communication.model.Message;
import com.communication.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin-dashboard")
public class DashboardServlet extends HttpServlet {
    private MessageDAO messageDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        messageDAO = new MessageDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        List<Message> messages = messageDAO.getAllMessages();
        List<User> officers = userDAO.getAllOfficers();

        request.setAttribute("messages", messages);
        request.setAttribute("officers", officers);
        request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
    }
}

