package com.bank.dao;

import com.bank.model.User;
import com.bank.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class UserDao {

    public Optional<User> getUserByUsername(String username) throws SQLException {
        String sql = "SELECT id, username, password, role, email, created_at FROM users WHERE username = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    User user = new User(
                            rs.getInt("id"),
                            rs.getString("username"),
                            rs.getString("password"),
                            rs.getString("role"),
                            rs.getTimestamp("created_at")
                    );
                    user.setEmail(rs.getString("email")); // Set email
                    user.setAccountIds(getUserAccounts(user.getId()));
                    return Optional.of(user);
                }
            }
        }
        return Optional.empty();
    }
    public Optional<User> getUserById(int userId) throws SQLException {
        String sql = "SELECT id, username, password, role, email, created_at FROM users WHERE id = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    User user = new User(
                            rs.getInt("id"),
                            rs.getString("username"),
                            rs.getString("password"),
                            rs.getString("role"),
                            rs.getTimestamp("created_at")
                    );
                    user.setEmail(rs.getString("email")); // Set email
                    user.setAccountIds(getUserAccounts(user.getId()));
                    return Optional.of(user);
                }
            }catch(Exception e){
                e.printStackTrace();
            }

        }
        return Optional.empty();
    }

    public List<Integer> getUserAccounts(int userId) throws SQLException {
        String sql = "SELECT account_id FROM user_accounts WHERE user_id = ?";
        List<Integer> accountIds = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    accountIds.add(rs.getInt("account_id"));
                }
            }
        }
        return accountIds;
    }

    public boolean createUser(String username, String password, String role) throws SQLException {
        String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            statement.setString(2, password);
            statement.setString(3, role);
            return statement.executeUpdate() > 0;
        }
    }

    public boolean linkUserToAccount(int userId, int accountId) throws SQLException {
        String sql = "INSERT INTO user_accounts (user_id, account_id) VALUES (?, ?)";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.setInt(2, accountId);
            return statement.executeUpdate() > 0;
        }
    }

    public List<User> getAllUsers() throws SQLException {
        String sql = "SELECT id, username, password, role, created_at FROM users";
        List<User> users = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                User user = new User(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("role"),
                        rs.getTimestamp("created_at")
                );
                user.setAccountIds(getUserAccounts(user.getId()));
                users.add(user);
            }
        }
        return users;
    }

    public Optional<String> getEmailByUsername(String username) throws SQLException {
        String sql = "SELECT email FROM users WHERE username = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return Optional.ofNullable(rs.getString("email"));
                }
            }
        }
        return Optional.empty();
    }
}
