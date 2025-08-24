package com.bank.dao;

import com.bank.model.Loan;
import com.bank.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LoanDao {

    public boolean createLoan(String loanType, double interestRate, double maxAmount, int durationMonths, String eligibilityCriteria) throws SQLException {
        String sql = "INSERT INTO loans (loan_type, interest_rate, max_amount, duration_months, eligibility_criteria) VALUES (?, ?, ?, ?, ?)";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, loanType);
            statement.setDouble(2, interestRate);
            statement.setDouble(3, maxAmount);
            statement.setInt(4, durationMonths);
            statement.setString(5, eligibilityCriteria);
            return statement.executeUpdate() > 0;
        }
    }

    public List<Loan> getAllLoans() throws SQLException {
        String sql = "SELECT * FROM loans";
        List<Loan> loans = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                loans.add(new Loan(
                    rs.getInt("id"),
                    rs.getString("loan_type"),
                    rs.getDouble("interest_rate"),
                    rs.getDouble("max_amount"),
                    rs.getInt("duration_months"),
                    rs.getString("eligibility_criteria")
                ));
            }
        }
        return loans;
    }

    public Loan getLoanById(int loanId) throws SQLException {
        String sql = "SELECT * FROM loans WHERE id = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, loanId);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return new Loan(
                        rs.getInt("id"),
                        rs.getString("loan_type"),
                        rs.getDouble("interest_rate"),
                        rs.getDouble("max_amount"),
                        rs.getInt("duration_months"),
                        rs.getString("eligibility_criteria")
                    );
                }
            }
        }
        return null;
    }

    public boolean updateLoan(int id, String loanType, double interestRate, double maxAmount, int durationMonths, String eligibilityCriteria) throws SQLException {
        String sql = "UPDATE loans SET loan_type = ?, interest_rate = ?, max_amount = ?, duration_months = ?, eligibility_criteria = ? WHERE id = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, loanType);
            statement.setDouble(2, interestRate);
            statement.setDouble(3, maxAmount);
            statement.setInt(4, durationMonths);
            statement.setString(5, eligibilityCriteria);
            statement.setInt(6, id);
            return statement.executeUpdate() > 0;
        }
    }

    public boolean deleteLoan(int id) throws SQLException {
        String sql = "DELETE FROM loans WHERE id = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            return statement.executeUpdate() > 0;
        }
    }
}
