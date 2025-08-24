package com.bank.dao;

import com.bank.model.UserLoan;
import com.bank.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserLoanDao {

    public boolean createUserLoan(int userId, int loanId, double loanAmount, Timestamp startDate, Timestamp endDate) throws SQLException {
        String sql = "INSERT INTO user_loans (user_id, loan_id, amount, start_date, end_date, status) VALUES (?, ?, ?, ?, ?, 'PENDING')";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.setInt(2, loanId);
            statement.setDouble(3, loanAmount);
            statement.setTimestamp(4, startDate);
            statement.setTimestamp(5, endDate);
            return statement.executeUpdate() > 0;
        }
    }

    public List<UserLoan> getUserLoansByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM user_loans WHERE user_id = ?";
        List<UserLoan> userLoans = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    userLoans.add(new UserLoan(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getInt("loan_id"),
                        rs.getDouble("amount"),
                        rs.getTimestamp("start_date"),
                        rs.getTimestamp("end_date"),
                        rs.getString("status")
                    ));
                }
            }
        }
        return userLoans;
    }

    public boolean updateUserLoanStatus(int userLoanId, String status) throws SQLException {
        String sql = "UPDATE user_loans SET status = ? WHERE id = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, status);
            statement.setInt(2, userLoanId);
            return statement.executeUpdate() > 0;
        }
    }

    public List<UserLoan> getUserLoansByStatus(int userId, String status) throws SQLException {
        String sql = "SELECT * FROM user_loans WHERE user_id = ? AND status = ?";
        List<UserLoan> userLoans = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.setString(2, status);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    userLoans.add(new UserLoan(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getInt("loan_id"),
                        rs.getDouble("amount"),
                        rs.getTimestamp("start_date"),
                        rs.getTimestamp("end_date"),
                        rs.getString("status")
                    ));
                }
            }
        }
        return userLoans;
    }

    public boolean processPayment(int loanId, int amount, Integer fromAccountId) throws SQLException {
        String sql = "UPDATE user_loans SET amount = amount - ? WHERE id = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, amount);
            statement.setInt(2, loanId);
            int rowsUpdated = statement.executeUpdate();

            if (rowsUpdated > 0 && fromAccountId != null) {
                String accountSql = "UPDATE accounts SET balance = balance - ? WHERE id = ?";
                try (PreparedStatement accountStatement = connection.prepareStatement(accountSql)) {
                    accountStatement.setInt(1, amount);
                    accountStatement.setInt(2, fromAccountId);
                    return accountStatement.executeUpdate() > 0;
                }
            }
            return rowsUpdated > 0;
        }
    }
}
