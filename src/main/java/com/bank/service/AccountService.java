package com.bank.service;
import com.bank.dao.AccountDao;
import com.bank.model.Account;
import com.bank.model.Transaction;
import com.bank.util.EmailUtil;
import com.bank.util.OpenAIUtil;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Optional;


public class AccountService {
    private final AccountDao accountDao;

    public AccountService() {
        this.accountDao = new AccountDao();
    }

    public Optional<Account> getAccount(int id) {
        try {
            return accountDao.getAccount(id);
        } catch (SQLException e) {
            e.printStackTrace();
            return Optional.empty();
        }
    }

    public boolean updateAccount(int id, int amount) {
        try {
            return accountDao.updateAccount(id, amount);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Account> getAllAccounts() {
        try {
            return accountDao.getAllAccounts();
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }

    public boolean createAccount(int userId, int accountId, int amount, String accountType) {
        try {
            if (!accountDao.checkUserExists(userId)) {
                return false;
            }

            boolean accountCreated = accountDao.createAccount(accountId, amount, accountType);
            if (accountCreated) {
                return accountDao.linkUserToAccount(userId, accountId);
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean transfer(int userId, int fromAccountId, int toAccountId, double amount, String description) {
        try {
            if (!accountDao.isAccountOwnedByUser(userId, fromAccountId)) {
                return false;
            }

            Transaction transaction = new Transaction(
                0, userId, fromAccountId, toAccountId, amount, "TRANSFER", description, new java.sql.Timestamp(System.currentTimeMillis())
            );

            return accountDao.transfer(fromAccountId, toAccountId, amount, transaction);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Map<String, Integer> getAccountBalanceDistribution() {
        try {
            return accountDao.getAccountBalanceDistribution();
        } catch (SQLException e) {
            e.printStackTrace();
            return Map.of();
        }
    }

    public int getTotalAccounts() {
        try {
            return accountDao.getTotalAccounts();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int getTotalBalance() {
        try {
            return accountDao.getTotalBalance();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public List<Transaction> getRecentTransactions(int limit) {
        try {
            return accountDao.getRecentTransactions(limit);
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }

    public Map<String, Integer> getTransactionVolumeByDay() {
        try {
            return accountDao.getTransactionVolumeByDay();
        } catch (SQLException e) {
            e.printStackTrace();
            return Map.of();
        }
    }

    public boolean createUserAndAccount(String username, String password, String email, int amount, String accountType) {
        try {
            Optional<Integer> existingUserId = accountDao.getUserIdByUsername(username);
            int userId;

            if (existingUserId.isPresent()) {
                userId = existingUserId.get();
            } else {
                userId = accountDao.createUser(username, password, email);
                if (userId <= 0) {
                    return false;
                }
            }

            int accountId = accountDao.createAccountWithAutoId(amount, accountType);
            if (accountId > 0) {
                boolean userAccountLinked = accountDao.linkUserToAccount(userId, accountId);
                if (userAccountLinked && !existingUserId.isPresent()) {
                    new Thread(() -> {
                        try {
                            EmailUtil.sendEmail(email, "Account Created",
                                "Dear " + username + ",\n\nYour account has been created successfully.\n" +
                                "Username: " + username + "\nAccount ID: " + accountId + "\nPassword: " + password +
                                "\nAccount Type: " + accountType + "\n\nThank you!");
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }).start();
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Account> getUserAccounts(int userId) {
        try {
            return accountDao.getUserAccounts(userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }

    public boolean updateInterestRate(String accountType, double rate) {
        try {
            return accountDao.updateInterestRate(accountType, rate);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Map<String, Double> getAllInterestRates() {
        try {
            return accountDao.getAllInterestRates();
        } catch (SQLException e) {
            e.printStackTrace();
            return Map.of();
        }
    }

    public String getAccountInsights(int accountId) {
        try {
            Optional<Account> accountOpt = accountDao.getAccount(accountId);
            if (accountOpt.isEmpty()) {
                return "Account not found with ID = " + accountId;
            }

            Account account = accountOpt.get();
            String creationDate = accountDao.getAccountCreationDate(accountId); // Fetch creation date from DB
            return OpenAIUtil.getAccountInsights(account.getAccountType(), account.getAmount(), creationDate);
        } catch (Exception e) {
            e.printStackTrace();
            return "Error generating account insights.";
        }
    }
    public List<Account > getAccountsByUserId(int userId) {
        try {
            return accountDao.getUserAccounts(userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
