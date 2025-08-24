package com.bank.service;

import com.bank.dao.UserDao;
import com.bank.model.User;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class UserService {
    private final UserDao userDao;

    public UserService() {
        this.userDao = new UserDao();
    }

    public Optional<User> getUserByUsername(String username) {
        try {
            return userDao.getUserByUsername(username);
        } catch (SQLException e) {
            e.printStackTrace();
            return Optional.empty();
        }
    }
    public Optional<User> getUserById(int userId) {
        try {
            System.out.println(userId);
            return userDao.getUserById(userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return Optional.empty();
        }
    }

    public boolean createUser(String username, String password, String role) {
        try {
            return userDao.createUser(username, password, role);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean linkUserToAccount(int userId, int accountId) {
        try {
            return userDao.linkUserToAccount(userId, accountId);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<User> getAllUsers() {
        try {
            return userDao.getAllUsers();
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }

    public Optional<String> getEmailByUsername(String username) {
        try {
            return userDao.getEmailByUsername(username);
        } catch (SQLException e) {
            e.printStackTrace();
            return Optional.empty();
        }
    }
}
