package com.bank.dao;

import com.bank.model.Account;
import com.bank.model.Transaction;
import com.bank.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.HashMap;
import java.util.Map;

public class AccountDao {
    public Optional<Account> getAccount(int id) throws SQLException {
        String sql = "SELECT id, balance, account_type, creation_date FROM accounts WHERE id = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(new Account(
                        rs.getInt("id"),
                        rs.getInt("balance"),
                        rs.getString("account_type"),
                        rs.getDate("creation_date").toLocalDate()
                    ));
                }
            }
        }
        return Optional.empty();
    }

    public boolean updateAccount(int id, int amount) throws SQLException {
        String sql = "UPDATE accounts SET balance = ? WHERE id = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, amount);
            statement.setInt(2, id);
            return statement.executeUpdate() > 0;
        }
    }

    public List<Account> getAllAccounts() throws SQLException {
        String sql = "SELECT id, balance, account_type, creation_date FROM accounts";
        List<Account> accounts = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                accounts.add(new Account(
                    rs.getInt("id"),
                    rs.getInt("balance"),
                    rs.getString("account_type"),
                    rs.getDate("creation_date").toLocalDate()
                ));
            }
        }
        return accounts;
    }

    public boolean createAccount(int id, int amount) throws SQLException {
        String sql = "INSERT INTO accounts (id,balance) VALUES (?,?)";
        try(Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)){
                statement.setInt(1, id);
                statement.setInt(2, amount);
                return statement.executeUpdate() > 0;
             }
    }

    public boolean createAccount(int id, int amount, String accountType) throws SQLException {
        String sql = "INSERT INTO accounts (id, balance, account_type) VALUES (?, ?, ?)";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            statement.setInt(2, amount);
            statement.setString(3, accountType);
            return statement.executeUpdate() > 0;
        }
    }

    public boolean transfer(int fromAccountId, int toAccountId, double amount, Transaction transaction) throws SQLException {
        String withdrawSql = "UPDATE accounts SET balance = balance - ? WHERE id = ? AND balance >= ?";
        String depositSql = "UPDATE accounts SET balance = balance + ? WHERE id = ?";
        String transactionSql = "INSERT INTO transactions (user_id, from_account_id, to_account_id, amount, type, description, timestamp) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBUtil.getConnection()) {
            connection.setAutoCommit(false);
            try (PreparedStatement withdrawStmt = connection.prepareStatement(withdrawSql);
                 PreparedStatement depositStmt = connection.prepareStatement(depositSql);
                 PreparedStatement transactionStmt = connection.prepareStatement(transactionSql)) {

                // Withdraw from sender's account
                withdrawStmt.setDouble(1, amount);
                withdrawStmt.setInt(2, fromAccountId);
                withdrawStmt.setDouble(3, amount);
                int rowsUpdated = withdrawStmt.executeUpdate();
                if (rowsUpdated == 0) {
                    connection.rollback();
                    return false;
                }

                // Deposit into receiver's account
                depositStmt.setDouble(1, amount);
                depositStmt.setInt(2, toAccountId);
                depositStmt.executeUpdate();

                // Record the transaction
                transactionStmt.setInt(1, transaction.getUserId());
                transactionStmt.setInt(2, transaction.getFromAccountId());
                transactionStmt.setInt(3, transaction.getToAccountId());
                transactionStmt.setDouble(4, transaction.getAmount());
                transactionStmt.setString(5, transaction.getType());
                transactionStmt.setString(6, transaction.getDescription());
                transactionStmt.setTimestamp(7, transaction.getTimestamp());
                transactionStmt.executeUpdate();

                connection.commit();
                return true;
            } catch (SQLException e) {
                connection.rollback();
                throw e;
            } finally {
                connection.setAutoCommit(true);
            }
        }
    }

    public List<Transaction> getAccountTransactions(int accountId) throws SQLException {
        String sql = "SELECT * FROM transactions WHERE from_account_id = ? OR to_account_id = ? ORDER BY timestamp DESC";
        List<Transaction> transactions = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, accountId);
            statement.setInt(2, accountId);
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

    public Map<String, Integer> getAccountBalanceDistribution() throws SQLException {
        String sql = "SELECT CASE " +
                     "WHEN balance < 1000 THEN 'Below $1000' " +
                     "WHEN balance BETWEEN 1000 AND 5000 THEN '$1000-$5000' " +
                     "WHEN balance BETWEEN 5000 AND 10000 THEN '$5000-$10000' " +
                     "ELSE 'Above $10000' END AS range, COUNT(*) AS count " +
                     "FROM accounts GROUP BY range";
        Map<String, Integer> distribution = new HashMap<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                distribution.put(rs.getString("range"), rs.getInt("count"));
            }
        }
        return distribution;
    }

    public int getTotalAccounts() throws SQLException {
        String sql = "SELECT COUNT(*) AS total FROM accounts";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }

    public int getTotalBalance() throws SQLException {
        String sql = "SELECT SUM(balance) AS total_balance FROM accounts";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total_balance");
            }
        }
        return 0;
    }

    public List<Transaction> getRecentTransactions(int limit) throws SQLException {
        String sql = "SELECT id, from_account_id, to_account_id, amount, timestamp, type " +
                     "FROM transactions ORDER BY timestamp DESC LIMIT ?";
        List<Transaction> transactions = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, limit);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    transactions.add(new Transaction(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getInt("from_account_id"),
                        rs.getInt("to_account_id"),
                        rs.getInt("amount"),
                        rs.getString("type"),
                        rs.getString("description"),
                        rs.getTimestamp("timestamp")

                    ));
                }
            }
        }
        return transactions;
    }

    public Map<String, Integer> getTransactionVolumeByDay() throws SQLException {
        String sql = "SELECT DATE(timestamp) AS day, SUM(amount) AS total_volume " +
                     "FROM transactions GROUP BY DATE(timestamp) ORDER BY day";
        Map<String, Integer> volumeByDay = new HashMap<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                volumeByDay.put(rs.getDate("day").toString(), rs.getInt("total_volume"));
            }
        }
        return volumeByDay;
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

    public boolean checkUserExists(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) AS count FROM users WHERE id = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count") > 0;
                }
            }
        }
        return false;
    }

    public int createUser(String username, String password, String email) throws SQLException {
        String sql = "INSERT INTO users (username, password, email, role) VALUES (?, ?, ?, 'USER') RETURNING id";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            statement.setString(2, password);
            statement.setString(3, email);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        }
        return -1;
    }

    public Optional<Integer> getUserIdByUsername(String username) throws SQLException {
        String sql = "SELECT id FROM users WHERE username = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(rs.getInt("id"));
                }
            }
        }
        return Optional.empty();
    }

    public int createAccountWithAutoId(int amount, String accountType) throws SQLException {
        String sql = "INSERT INTO accounts (balance, account_type) VALUES (?, ?) RETURNING id";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, amount);
            statement.setString(2, accountType);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        }
        return -1;
    }

    // Add this method to get interest rate for an account type
    public double getInterestRate(String accountType) throws SQLException {
        String sql = "SELECT rate FROM interest_rates WHERE account_type = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, accountType);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("rate");
                }
            }
        }
        // Default rates if not found
        if ("SAVINGS".equals(accountType)) return 4.50;
        if ("CURRENT".equals(accountType)) return 0.50;
        if ("FIXED".equals(accountType)) return 7.25;
        return 0.0;
    }

    // Add this method to get all interest rates
    public Map<String, Double> getAllInterestRates() throws SQLException {
        String sql = "SELECT account_type, rate FROM interest_rates";
        Map<String, Double> rates = new HashMap<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                rates.put(rs.getString("account_type"), rs.getDouble("rate"));
            }
        }
        return rates;
    }

    // Add this method to update interest rate
    public boolean updateInterestRate(String accountType, double rate) throws SQLException {
        String sql = "UPDATE interest_rates SET rate = ?, last_updated = NOW() WHERE account_type = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setDouble(1, rate);
            statement.setString(2, accountType);
            return statement.executeUpdate() > 0;
        }
    }

    // Add this method to get accounts owned by a specific user
    public List<Account> getUserAccounts(int userId) throws SQLException {
        String sql = "SELECT a.id, a.balance, a.account_type, a.creation_date FROM accounts a " +
                 "JOIN user_accounts ua ON a.id = ua.account_id " +
                 "WHERE ua.user_id = ?";
        List<Account> accounts = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("id");
                    int balance = rs.getInt("balance");
                    String accountType = rs.getString("account_type");
                    double interestRate = getInterestRate(accountType);
                    accounts.add(new Account(id, balance, accountType, interestRate));
                }
            }
        }
        return accounts;
    }

    // Add this method to check if a user owns an account
    public boolean isAccountOwnedByUser(int userId, int accountId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM user_accounts WHERE user_id = ? AND account_id = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.setInt(2, accountId);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public String getAccountCreationDate(int accountId) throws SQLException {
        String sql = "SELECT creation_date FROM accounts WHERE id = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, accountId);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return rs.getDate("creation_date").toString();
                }
            }
        }
        return "Unknown";
    }
}
