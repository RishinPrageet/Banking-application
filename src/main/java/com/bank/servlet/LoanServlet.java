package com.bank.servlet;

import com.bank.model.Loan;
import com.bank.model.LoanEligibilityRequest;
import com.bank.model.UserLoan;
import com.bank.service.LoanService;
import com.google.gson.Gson; // Gson import for JSON processing

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.List;

@WebServlet("/loan/*")
public class LoanServlet extends HttpServlet {
    private final LoanService loanService = new LoanService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Action parameter is required\"}");
            return;
        }

        switch (action) {
            case "viewDetails":
                getLoanDetails(request, response);
                break;
            case "getUserLoans":
                getUserLoans(request, response);
                break;
            default:
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Invalid action\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Action parameter is required\"}");
            return;
        }

        switch (action) {
            case "apply":
                applyForLoan(request, response);
                break;
            case "checkEligibility":
                checkEligibility(request, response);
                break;
            case "makePayment":
                handleMakePayment(request, response);
                break;
            default:
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Invalid action\"}");
        }
    }

    private void getLoanDetails(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String loanIdParam = request.getParameter("id");

        if (loanIdParam == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Loan ID is required\"}");
            return;
        }

        try {
            int loanId = Integer.parseInt(loanIdParam);
            Loan loan = loanService.getLoanById(loanId);

            if (loan == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\": \"Loan not found\"}");
                return;
            }

            String json = new Gson().toJson(loan);
            response.setContentType("application/json");
            response.getWriter().write(json);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid loan ID format\"}");
        }
    }

    private void getUserLoans(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"User not logged in\"}");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String status = request.getParameter("status");

        try {
            List<UserLoan> userLoans = loanService.getUserLoansByStatus(userId, status);
            String json = new Gson().toJson(userLoans);
            response.setContentType("application/json");
            response.getWriter().write(json);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    private void applyForLoan(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"User not logged in\"}");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String loanIdParam = request.getParameter("loanId");
        String loanAmountParam = request.getParameter("loanAmount");
        String durationMonthsParam = request.getParameter("durationMonths");

        if (loanIdParam == null || loanAmountParam == null || durationMonthsParam == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"All loan application parameters are required\"}");
            return;
        }

        try {
            int loanId = Integer.parseInt(loanIdParam);
            double loanAmount = Double.parseDouble(loanAmountParam);
            int durationMonths = Integer.parseInt(durationMonthsParam);

            Loan loan = loanService.getLoanById(loanId);
            if (loan == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\": \"Loan type not found\"}");
                return;
            }

            if (loanAmount > loan.getMaxAmount()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Requested loan amount exceeds maximum allowed amount\"}");
                return;
            }

            boolean success = loanService.applyForLoan(userId, loanId, loanAmount, durationMonths);

            if (success) {
                response.getWriter().write("{\"message\": \"Loan application submitted successfully\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\": \"Failed to submit loan application\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid number format\"}");
        }
    }

    private void checkEligibility(HttpServletRequest request, HttpServletResponse response) throws IOException {
        StringBuilder sb = new StringBuilder();
        String line;

        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }

        try {
            LoanEligibilityRequest eligibilityRequest = new Gson().fromJson(sb.toString(), LoanEligibilityRequest.class);
            List<Loan> eligibleLoans = loanService.checkEligibility(eligibilityRequest);

            String json = new Gson().toJson(eligibleLoans);
            response.setContentType("application/json");
            response.getWriter().write(json);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid request format: " + e.getMessage() + "\"}");
        }
    }

    private void handleMakePayment(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String loanIdParam = request.getParameter("loanId");
        String amountParam = request.getParameter("amount");
        String paymentMethod = request.getParameter("paymentMethod");
        String fromAccountParam = request.getParameter("fromAccount");

        if (loanIdParam == null || amountParam == null || paymentMethod == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"All payment parameters are required\"}");
            return;
        }

        try {
            int loanId = Integer.parseInt(loanIdParam);
            int amount = Integer.parseInt(amountParam);
            Integer fromAccountId = "account".equals(paymentMethod) ? Integer.parseInt(fromAccountParam) : null;

            boolean success = loanService.makePayment(loanId, amount, fromAccountId);

            if (success) {
                response.getWriter().write("{\"message\": \"Payment successful\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Payment failed\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid number format\"}");
        }
    }
}
