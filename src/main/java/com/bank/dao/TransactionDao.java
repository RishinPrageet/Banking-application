package com.bank.dao;

import com.bank.model.Transaction;
import com.bank.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TransactionDao {

    public boolean recordTransaction(int userId, int fromAccountId, int toAccountId, double amount, String type, String description) throws SQLException {
        String sql = "INSERT INTO transactions (user_id, from_account_id, to_account_id, amount, type, description) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.setInt(2, fromAccountId);
            statement.setInt(3, toAccountId);
            statement.setDouble(4, amount);
            statement.setString(5, type);
            statement.setString(6, description);
            return statement.executeUpdate() > 0;
        }
    }

    public List<Transaction> getUserTransactions(int userId) throws SQLException {
        String sql = "SELECT * FROM transactions WHERE user_id = ? ORDER BY timestamp DESC";
        List<Transaction> transactions = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    transactions.add(new Transaction(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getInt("from_account_id"),
                        rs.getInt("to_account_id"),
                        rs.getDouble("amount"),
                        rs.getString("type"),
                        rs.getString("description"),
                        rs.getTimestamp("timestamp")
                    ));
                }
            }
        }
        return transactions;
    }
}
