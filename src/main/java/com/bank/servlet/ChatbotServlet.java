package com.bank.servlet;

import com.bank.model.User;
import com.bank.service.UserService;
import com.bank.model.Account;
import com.bank.service.AccountService;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;



import com.fasterxml.jackson.databind.ObjectMapper;

@WebServlet("/chatbot")
public class ChatbotServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String API_URL = "http://localhost:8000/chat";
    private static final UserService userService = new UserService();
    private static final AccountService accountService = new AccountService();

    private static final HttpClient httpClient = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(30))
            .build();
    private static final ObjectMapper objectMapper = new ObjectMapper();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String message = request.getParameter("message");
        System.out.println("[ChatbotServlet] Received user message: " + message);  // Log input message
        
        HttpSession session = request.getSession();
        
        // Get or create session ID for the chat
        String sessionId = (String) session.getAttribute("chatSessionId");
        if (sessionId == null) {
            sessionId = UUID.randomUUID().toString();
            session.setAttribute("chatSessionId", sessionId);
        }
        
        // Get or create chat history
        @SuppressWarnings("unchecked")
        List<Map<String, String>> history = (List<Map<String, String>>) session.getAttribute("chatHistory");
        if (history == null) {
            history = new ArrayList<>();
            session.setAttribute("chatHistory", history);
            int userID = session.getAttribute("userId") != null ? (int) session.getAttribute("userId") : 0;
            System.out.println("[ChatbotServlet] User ID: " + userID);
            User user = userService.getUserById(userID).orElse(null);
            try{
            System.out.println("[ChatbotServlet] Logged in user: " + user.getUsername() + " (ID: " + user.getId() + ")");
            }catch (Exception e){
                e.printStackTrace();
            }
            if (user != null) {
                System.out.println("[ChatbotServlet] Logging user details: " + user.toString());
            } else {
                System.out.println("[ChatbotServlet] No user is logged in.");
            }
            List<Account> accounts = accountService.getAccountsByUserId(userID);
            if (accounts != null && !accounts.isEmpty()) {
                System.out.println("[ChatbotServlet] User accounts:");
                for (Account account : accounts) {
                    System.out.println("[ChatbotServlet] Account ID: " + account.getId() + ", Balance: " + account.getAmount() + ", Type: " + account.getAccountType());
                }
            } else {
                System.out.println("[ChatbotServlet] No accounts found for the user.");
            }
             // Update user details in the backend
            try{
            HttpRequest updateUserRequest = HttpRequest.newBuilder()
            .uri(URI.create(API_URL.replace("/chat", "/update_user")))
            .header("Content-Type", "application/json")
            .POST(HttpRequest.BodyPublishers.ofString(objectMapper.writeValueAsString(Map.of(
                    "session_id", sessionId,
                    "user_details", user,
                    "account_details", accounts != null ? accounts : new ArrayList<>()
            ))))
            .build();
        
            // Log the HTTP body
            String requestBody = objectMapper.writeValueAsString(Map.of(
                    "session_id", sessionId,
                    "user_details", user,
                    "account_details", accounts != null ? accounts : new ArrayList<>()
            ));
            System.out.println("[ChatbotServlet] Update User Request Body: " + requestBody);
            
            httpClient.send(updateUserRequest, HttpResponse.BodyHandlers.ofString());
            }
            catch (Exception e){
                e.printStackTrace();
            }


            
        }
        
        // Add user message to history
        Map<String, String> userMessage = new HashMap<>();
        userMessage.put("role", "user");
        userMessage.put("content", message);
        history.add(userMessage);
        
        // Retrieve user details from session or set defaults
        System.out.println("[ChatbotServlet] Session ID: " + session.getId());
        session.getAttributeNames().asIterator().forEachRemaining(attr -> 
            System.out.println("[ChatbotServlet] Session Attribute - " + attr + ": " + session.getAttribute(attr))
        );


        // Retrieve username from session if available
        
        try {
           
            
            // Prepare request body for chat
            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("message", message);
            requestBody.put("session_id", sessionId);
            requestBody.put("history", history);
            
            String requestBodyJson = objectMapper.writeValueAsString(requestBody);
            
            // Create HTTP request
            HttpRequest httpRequest = HttpRequest.newBuilder()
                    .uri(URI.create(API_URL))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(requestBodyJson))
                    .build();
            
            // Send request and get response
            HttpResponse<String> httpResponse = httpClient.send(
                    httpRequest, HttpResponse.BodyHandlers.ofString());
            
            // Parse response
            Map<String, Object> responseMap = objectMapper.readValue(
                    httpResponse.body(), new com.fasterxml.jackson.core.type.TypeReference<Map<String, Object>>() {});
            
            String botResponse = (String) responseMap.get("response");
            System.out.println("[ChatbotServlet] Received bot response: " + botResponse);  // Log output message
            
            List<Map<String, Object>> sources = objectMapper.convertValue(
                    responseMap.get("sources"), new com.fasterxml.jackson.core.type.TypeReference<List<Map<String, Object>>>() {});
            
            // Add bot response to history
            Map<String, String> botMessage = new HashMap<>();
            botMessage.put("role", "assistant");
            botMessage.put("content", botResponse);
            history.add(botMessage);
            
            // Update session
            session.setAttribute("chatHistory", history);
            
            // Prepare response
            Map<String, Object> jsonResponse = new HashMap<>();
            jsonResponse.put("response", botResponse);
            jsonResponse.put("sources", sources);
            
            // Send response
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print(objectMapper.writeValueAsString(jsonResponse));
            out.flush();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("error", "Failed to get response from chatbot: " + e.getMessage());
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print(objectMapper.writeValueAsString(errorResponse));
            out.flush();
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("clear".equals(action)) {
            // Clear chat history
            HttpSession session = request.getSession();
            session.removeAttribute("chatHistory");
            
            // Send success response
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"status\":\"success\",\"message\":\"Chat history cleared\"}");
            out.flush();
        } else {
            // Forward to the chatbot page
            request.getRequestDispatcher("/loan-chatbot.jsp").forward(request, response);
        }
    }
}
