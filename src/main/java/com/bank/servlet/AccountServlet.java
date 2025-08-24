// 1. Updated AccountServlet.java
package com.bank.servlet;

import com.bank.model.Account;
import com.bank.service.AccountService;
import org.json.JSONArray;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@WebServlet("/account")
public class AccountServlet extends HttpServlet {
private final AccountService accountService = new AccountService();


@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String action = request.getParameter("action");
    if (action == null || action.isEmpty()) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action parameter.");
        return;
    }

    response.setCharacterEncoding("UTF-8");
    try {
        switch (action) {
            case "get": {
                String idParam = request.getParameter("id");
                if (idParam == null) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or invalid account ID.");
                    return;
                }
                int id = Integer.parseInt(idParam);
                Optional<Account> opt = accountService.getAccount(id);
                if (opt.isPresent()) {
                    Account acc = opt.get();
                    JSONObject json = new JSONObject();
                    json.put("id", acc.getId());
                    json.put("amount", acc.getAmount());
                    json.put("accountType", acc.getAccountType());
                    json.put("interestRate", acc.getInterestRate());
                    if (acc.getCreationDate() != null) {
                        json.put("creationDate", acc.getCreationDate().toString());
                    }
                    response.setContentType("application/json");
                    response.getWriter().write(json.toString());
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Account not found.");
                }
                break;
            }

            case "getAll": {
                List<Account> accounts = accountService.getAllAccounts();
                JSONArray array = new JSONArray();
                for (Account acc : accounts) {
                    JSONObject obj = new JSONObject();
                    obj.put("id", acc.getId());
                    obj.put("amount", acc.getAmount());
                    obj.put("accountType", acc.getAccountType());
                    obj.put("interestRate", acc.getInterestRate());
                    array.put(obj);
                }
                response.setContentType("application/json");
                response.getWriter().write(array.toString());
                break;
            }

            case "getUserAccounts": {
                HttpSession session = request.getSession(false);
                if (session == null || session.getAttribute("userId") == null) {
                    response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in.");
                    return;
                }
                int userId = (int) session.getAttribute("userId");
                List<Account> userAccounts = accountService.getUserAccounts(userId);
                JSONArray ua = new JSONArray();
                for (Account acc : userAccounts) {
                    JSONObject obj = new JSONObject();
                    obj.put("id", acc.getId());
                    obj.put("amount", acc.getAmount());
                    obj.put("accountType", acc.getAccountType());
                    obj.put("interestRate", acc.getInterestRate());
                    ua.put(obj);
                }
                response.setContentType("application/json");
                response.getWriter().write(ua.toString());
                break;
            }

            case "getInsights": {
                String idParam = request.getParameter("id");
                if (idParam == null) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or invalid account ID.");
                    return;
                }
                int accountId = Integer.parseInt(idParam);
                String insights = accountService.getAccountInsights(accountId);
                response.setContentType("text/plain");
                response.getWriter().write(insights);
                break;
            }

            case "getInterestRates": {
                Map<String, Double> rates = accountService.getAllInterestRates();
                JSONObject ratesJson = new JSONObject(rates);
                response.setContentType("application/json");
                response.getWriter().write(ratesJson.toString());
                break;
            }

            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action.");
        }
    } catch (NumberFormatException e) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid number format.");
    } catch (Exception e) {
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
    }
}

@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String action = request.getParameter("action");
    if (action == null || action.isEmpty()) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action parameter.");
        return;
    }

    response.setCharacterEncoding("UTF-8");
    try {
        String result;
        switch (action) {
            case "createUserAccount": {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String email = request.getParameter("email");
                int amount = Integer.parseInt(request.getParameter("amount"));
                String accountType = request.getParameter("accountType");
                result = accountService.createUserAndAccount(
                        username, password, email, amount,
                        (accountType == null || accountType.isEmpty()) ? "SAVINGS" : accountType
                ) ? "User account created successfully." : "Failed to create user account.";
                break;
            }
            case "create": {
                int userId = Integer.parseInt(request.getParameter("userId"));
                int accountId = Integer.parseInt(request.getParameter("id"));
                int amount = Integer.parseInt(request.getParameter("amount"));
                String type = request.getParameter("accountType");
                result = accountService.createAccount(
                        userId, accountId, amount,
                        (type == null || type.isEmpty()) ? "SAVINGS" : type
                ) ? "Account created successfully." : "Failed to create account.";
                break;
            }
            case "update": {
                int id = Integer.parseInt(request.getParameter("id"));
                int amt = Integer.parseInt(request.getParameter("amount"));
                result = accountService.updateAccount(id, amt)
                        ? "Account updated successfully." : "Failed to update account.";
                break;
            }
            case "transfer": {
                HttpSession session = request.getSession(false);
                if (session == null || session.getAttribute("userId") == null) {
                    response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in.");
                    return;
                }
                int userId = (int) session.getAttribute("userId");
                int fromId = Integer.parseInt(request.getParameter("fromAccountId"));
                int toId = Integer.parseInt(request.getParameter("toAccountId"));
                double amt = Double.parseDouble(request.getParameter("amount"));
                String desc = request.getParameter("description");
                result = accountService.transfer(userId, fromId, toId, amt, desc)
                        ? "Transfer successful." : "Transfer failed.";
                break;
            }
            case "updateInterestRate": {
                HttpSession sess = request.getSession(false);
                if (sess == null || !"ADMIN".equals(sess.getAttribute("role"))) {
                    response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Only admins can update rates.");
                    return;
                }
                String type = request.getParameter("accountType");
                double rate = Double.parseDouble(request.getParameter("rate"));
                result = accountService.updateInterestRate(type, rate)
                        ? "Interest rate updated successfully." : "Failed to update interest rate.";
                break;
            }
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action.");
                return;
        }
        response.setContentType("text/plain");
        response.getWriter().write(result);
    } catch (NumberFormatException e) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid number format.");
    } catch (Exception e) {
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
    }
}
}




// 2. AccountService.java
// No changes required; JSON conversion handled in servlet.


