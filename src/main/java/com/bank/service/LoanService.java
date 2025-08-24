package com.bank.service;

import com.bank.dao.LoanDao;
import com.bank.dao.UserLoanDao;
import com.bank.model.Loan;
import com.bank.model.LoanEligibilityRequest;
import com.bank.model.UserLoan;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class LoanService {
    private final LoanDao loanDao;
    private final UserLoanDao userLoanDao;

    public LoanService() {
        this.loanDao = new LoanDao();
        this.userLoanDao = new UserLoanDao();
    }

    public List<Loan> getAllLoans() {
        try {
            return loanDao.getAllLoans();
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public Loan getLoanById(int loanId) {
        try {
            return loanDao.getLoanById(loanId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean createLoan(String loanType, double interestRate, double maxAmount, int durationMonths, String eligibilityCriteria) {
        try {
            return loanDao.createLoan(loanType, interestRate, maxAmount, durationMonths, eligibilityCriteria);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateLoan(int id, String loanType, double interestRate, double maxAmount, int durationMonths, String eligibilityCriteria) {
        try {
            return loanDao.updateLoan(id, loanType, interestRate, maxAmount, durationMonths, eligibilityCriteria);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteLoan(int id) {
        try {
            return loanDao.deleteLoan(id);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean applyForLoan(int userId, int loanId, double loanAmount, int durationMonths) {
        try {
            // Set start date to current date
            Timestamp startDate = new Timestamp(System.currentTimeMillis());
            
            // Calculate end date based on duration in months
            Calendar calendar = Calendar.getInstance();
            calendar.setTimeInMillis(startDate.getTime());
            calendar.add(Calendar.MONTH, durationMonths);
            Timestamp endDate = new Timestamp(calendar.getTimeInMillis());
            
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
            return new ArrayList<>();
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

    public List<Loan> checkEligibility(LoanEligibilityRequest request) {
        try {
            List<Loan> allLoans = loanDao.getAllLoans();
            List<Loan> eligibleLoans = new ArrayList<>();
            
            for (Loan loan : allLoans) {
                if (isEligible(loan, request)) {
                    eligibleLoans.add(loan);
                }
            }
            
            return eligibleLoans;
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    private boolean isEligible(Loan loan, LoanEligibilityRequest request) {
        // Home Loan
        if (loan.getLoanType().equalsIgnoreCase("Home Loan")) {
            return request.getIncome() >= 50000 && 
                   request.getAge() >= 21 && request.getAge() <= 60 && 
                   (request.getEmployment().equalsIgnoreCase("Salaried") || 
                    request.getEmployment().equalsIgnoreCase("Self-employed"));
        }
        
        // Personal Loan
        if (loan.getLoanType().equalsIgnoreCase("Personal Loan")) {
            return request.getIncome() >= 25000 && 
                   request.getAge() >= 21 && request.getAge() <= 58 && 
                   request.getEmployment().equalsIgnoreCase("Salaried");
        }
        
        // Car Loan
        if (loan.getLoanType().equalsIgnoreCase("Car Loan")) {
            return request.getIncome() >= 20000 && 
                   request.getAge() >= 21 && request.getAge() <= 60 && 
                   (request.getEmployment().equalsIgnoreCase("Salaried") || 
                    request.getEmployment().equalsIgnoreCase("Self-employed"));
        }
        
        // Education Loan
        if (loan.getLoanType().equalsIgnoreCase("Education Loan")) {
            return request.getEmployment().equalsIgnoreCase("Student") && 
                   request.isHasAdmission();
        }
        
        // Gold Loan
        if (loan.getLoanType().equalsIgnoreCase("Gold Loan")) {
            return request.isHasGold() && 
                   request.getAge() >= 18 && request.getAge() <= 65;
        }
        
        // Business Loan
        if (loan.getLoanType().equalsIgnoreCase("Business Loan")) {
            return request.getEmployment().equalsIgnoreCase("Self-employed") && 
                   request.getBusinessVintage() >= 3 && 
                   request.getTurnover() >= 1000000;
        }
        
        // Two Wheeler Loan
        if (loan.getLoanType().equalsIgnoreCase("Two Wheeler Loan")) {
            return request.getIncome() >= 10000 && 
                   request.getAge() >= 18 && request.getAge() <= 60;
        }
        
        // Loan Against Property
        if (loan.getLoanType().equalsIgnoreCase("Loan Against Property")) {
            return request.isHasProperty() && 
                   request.getAge() >= 25 && request.getAge() <= 65;
        }
        
        // Agriculture Loan
        if (loan.getLoanType().equalsIgnoreCase("Agriculture Loan")) {
            return request.getEmployment().equalsIgnoreCase("Farmer");
        }
        
        // Travel Loan
        if (loan.getLoanType().equalsIgnoreCase("Travel Loan")) {
            return request.getIncome() >= 20000 && 
                   request.getAge() >= 21 && request.getAge() <= 55;
        }
        
        return false;
    }

    public List<UserLoan> getUserLoansByStatus(int userId, String status) {
        try {
            return userLoanDao.getUserLoansByStatus(userId, status);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public boolean makePayment(int loanId, int amount, Integer fromAccountId) {
        try {
            return userLoanDao.processPayment(loanId, amount, fromAccountId);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
