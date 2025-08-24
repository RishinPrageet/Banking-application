package com.bank.service;

import com.bank.dao.UserLoanDao;
import com.bank.model.UserLoan;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

public class UserLoanService {
    private final UserLoanDao userLoanDao = new UserLoanDao();

    public boolean applyForLoan(int userId, int loanId, double loanAmount, Timestamp startDate, Timestamp endDate) {
        try {
            return userLoanDao.createUserLoan(userId, loanId, loanAmount, startDate, endDate);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<UserLoan> getUserLoans(int userId) {
        try {
            return userLoanDao.getUserLoansByUserId(userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean updateLoanStatus(int userLoanId, String status) {
        try {
            return userLoanDao.updateUserLoanStatus(userLoanId, status);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
