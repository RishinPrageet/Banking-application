package com.bank.util;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URI;
import java.util.Scanner;

public class OpenAIUtil {
    private static final String API_URL = "https://openrouter.ai/api/v1/chat/completions";
    private static final String API_KEY  = "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";

    public static String getAccountInsights(String prompt) throws Exception {
        URL url = URI.create(API_URL).toURL();
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("POST");
        connection.setRequestProperty("Authorization", "Bearer " + API_KEY);
        connection.setRequestProperty("Content-Type", "application/json");
        connection.setRequestProperty("HTTP-Referer", "https://yourdomain.com"); 
        connection.setRequestProperty("X-Title", "BankingApp");                  
        connection.setDoOutput(true);

        // Build chat message array
        JSONArray messages = new JSONArray();
        JSONObject userMessage = new JSONObject();
        userMessage.put("role", "user");
        userMessage.put("content", prompt);
        messages.put(userMessage);

        // Build request body
        JSONObject requestBody = new JSONObject();
        requestBody.put("model", "deepseek/deepseek-chat:free");
        requestBody.put("messages", messages);
        requestBody.put("max_tokens", 150);
        requestBody.put("temperature", 0.7);

        // Send request
        try (OutputStream os = connection.getOutputStream()) {
            os.write(requestBody.toString().getBytes());
            os.flush();
        }

        // Read response
        try (Scanner scanner = new Scanner(connection.getInputStream())) {
            StringBuilder response = new StringBuilder();
            while (scanner.hasNext()) {
                response.append(scanner.nextLine());
            }
            JSONObject jsonResponse = new JSONObject(response.toString());
            return jsonResponse.getJSONArray("choices")
                               .getJSONObject(0)
                               .getJSONObject("message")
                               .getString("content")
                               .trim();
        }
    }

    public static String getAccountInsights(String accountType, double balance, String creationDate) throws Exception {
        String prompt = String.format(
            "The user has an account with the following details:\n" +
            "- Account Type: %s\n" +
            "- Balance: $%.2f\n" +
            "- Account Creation Date: %s\n\n" +
            "Interest rates for different account types are:\n" +
            "- Savings Account: 4.50%% per annum (compounded quarterly)\n" +
            "- Current Account: 0.50%% per annum (no compounding)\n" +
            "- Fixed Deposit (FD): 7.25%% per annum (compounded quarterly)\n\n" +
            "Provide a detailed profitability analysis comparing the user's current account type with a Fixed Deposit (FD). Include:\n" +
            "1. Interest earned in the current account type over 1 year.\n" +
            "2. Interest earned in an FD over 1 year.\n" +
            "3. A recommendation on whether switching to an FD would be more profitable."+" give 5 point short answer dont add additional stuff and make it so that there isnt any escape characters" ,
            accountType, balance, creationDate
        );

        return getAccountInsights(prompt);
    }
}
