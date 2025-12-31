package com.communication.dao;

import com.communication.model.Message;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {
    private DatabaseConnection dbConnection;

    public MessageDAO() {
        this.dbConnection = DatabaseConnection.getInstance();
    }

    public boolean createMessage(int senderId, String subject, String content) {
        String sql = "INSERT INTO messages (sender_id, subject, content) VALUES (?, ?, ?)";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, senderId);
            stmt.setString(2, subject);
            stmt.setString(3, content);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Message> getAllMessages() {
        List<Message> messages = new ArrayList<>();
        String sql = "SELECT m.id, m.sender_id, m.subject, m.content, m.created_at, m.is_read, " +
                     "u.username as sender_username " +
                     "FROM messages m " +
                     "JOIN users u ON m.sender_id = u.id " +
                     "ORDER BY m.created_at DESC";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Message message = new Message();
                message.setId(rs.getInt("id"));
                message.setSenderId(rs.getInt("sender_id"));
                message.setSenderUsername(rs.getString("sender_username"));
                message.setSubject(rs.getString("subject"));
                message.setContent(rs.getString("content"));
                message.setCreatedAt(rs.getTimestamp("created_at"));
                message.setRead(rs.getBoolean("is_read"));
                messages.add(message);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return messages;
    }

    public List<Message> getMessagesForOfficer(int officerId) {
        List<Message> messages = new ArrayList<>();
        String sql = "SELECT m.id, m.sender_id, m.subject, m.content, m.created_at, m.is_read, " +
                     "u.username as sender_username " +
                     "FROM messages m " +
                     "JOIN users u ON m.sender_id = u.id " +
                     "WHERE m.sender_id != ? " +
                     "ORDER BY m.created_at DESC";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, officerId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Message message = new Message();
                    message.setId(rs.getInt("id"));
                    message.setSenderId(rs.getInt("sender_id"));
                    message.setSenderUsername(rs.getString("sender_username"));
                    message.setSubject(rs.getString("subject"));
                    message.setContent(rs.getString("content"));
                    message.setCreatedAt(rs.getTimestamp("created_at"));
                    message.setRead(rs.getBoolean("is_read"));
                    messages.add(message);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return messages;
    }

    public Message getMessageById(int messageId) {
        String sql = "SELECT m.id, m.sender_id, m.subject, m.content, m.created_at, m.is_read, " +
                     "u.username as sender_username " +
                     "FROM messages m " +
                     "JOIN users u ON m.sender_id = u.id " +
                     "WHERE m.id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, messageId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Message message = new Message();
                    message.setId(rs.getInt("id"));
                    message.setSenderId(rs.getInt("sender_id"));
                    message.setSenderUsername(rs.getString("sender_username"));
                    message.setSubject(rs.getString("subject"));
                    message.setContent(rs.getString("content"));
                    message.setCreatedAt(rs.getTimestamp("created_at"));
                    message.setRead(rs.getBoolean("is_read"));
                    return message;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean markAsRead(int messageId) {
        String sql = "UPDATE messages SET is_read = TRUE WHERE id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, messageId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}

