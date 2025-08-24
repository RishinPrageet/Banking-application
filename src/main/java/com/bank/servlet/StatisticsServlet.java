package com.bank.servlet;

import com.bank.service.AccountService;
import com.bank.model.Transaction;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
import org.json.JSONObject;
import org.json.JSONArray;

@WebServlet("/statistics/*")
public class StatisticsServlet extends HttpServlet {

    private final AccountService accountService = new AccountService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        switch (action) {
            case "balanceDistribution":
                Map<String, Integer> balanceDistribution = accountService.getAccountBalanceDistribution();
                JSONObject balanceJson = new JSONObject(balanceDistribution);
                out.print(balanceJson.toString());
                break;

            case "totalAccounts":
                int totalAccounts = accountService.getTotalAccounts();
                JSONObject totalAccountsJson = new JSONObject();
                totalAccountsJson.put("totalAccounts", totalAccounts);
                out.print(totalAccountsJson.toString());
                break;

            case "totalBalance":
                int totalBalance = accountService.getTotalBalance();
                JSONObject totalBalanceJson = new JSONObject();
                totalBalanceJson.put("totalBalance", totalBalance);
                out.print(totalBalanceJson.toString());
                break;

            case "recentTransactions":
                int limit = Integer.parseInt(request.getParameter("limit"));
                List<Transaction> transactions = accountService.getRecentTransactions(limit);
                JSONArray transactionsJson = new JSONArray();
                for (Transaction transaction : transactions) {
                    JSONObject transactionJson = new JSONObject();
                    transactionJson.put("id", transaction.getId());
                    transactionJson.put("fromAccountId", transaction.getFromAccountId());
                    transactionJson.put("toAccountId", transaction.getToAccountId());
                    transactionJson.put("amount", transaction.getAmount());
                    transactionJson.put("timestamp", transaction.getTimestamp().toString());
                    transactionJson.put("type", transaction.getType());
                    transactionsJson.put(transactionJson);
                }
                out.print(transactionsJson.toString());
                break;

            case "transactionVolumeByDay":
                Map<String, Integer> volumeByDay = accountService.getTransactionVolumeByDay();
                JSONObject volumeJson = new JSONObject(volumeByDay);
                out.print(volumeJson.toString());
                break;

            default:
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                JSONObject errorJson = new JSONObject();
                errorJson.put("error", "Invalid action");
                out.print(errorJson.toString());
        }
    }
}
