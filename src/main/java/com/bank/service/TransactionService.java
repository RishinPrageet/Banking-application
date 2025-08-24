package com.bank.service;

import com.bank.dao.TransactionDao;
import com.bank.model.Transaction;

import java.sql.SQLException;
import java.util.List;

public class TransactionService {
    private final TransactionDao transactionDao;

    public TransactionService() {
        this.transactionDao = new TransactionDao();
    }

    public boolean recordTransaction(int userId, int fromAccountId, int toAccountId, double amount, String type, String description) {
        try {
            return transactionDao.recordTransaction(userId, fromAccountId, toAccountId, amount, type, description);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Transaction> getUserTransactions(int userId) {
        try {
            return transactionDao.getUserTransactions(userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
