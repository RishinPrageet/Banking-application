package com.bank.security;

import com.bank.service.UserService;
import com.bank.model.User;

import javax.security.auth.spi.LoginModule;
import javax.security.auth.callback.*;
import javax.security.auth.login.LoginException;
import javax.security.auth.Subject;
import java.util.Map;

public class CustomLoginModule implements LoginModule {
    private CallbackHandler callbackHandler;
    private Subject subject;
    private transient UserService userService = new UserService();
    private User authenticatedUser;

    @Override
    public void initialize(Subject subject, CallbackHandler callbackHandler, Map<String, ?> sharedState, Map<String, ?> options) {
        this.subject = subject;
        this.callbackHandler = callbackHandler;
    }

    @Override
    public boolean login() throws LoginException {
        if (callbackHandler == null) {
            throw new LoginException("No CallbackHandler available");
        }

        try {
            NameCallback nameCallback = new NameCallback("Username: ");
            PasswordCallback passwordCallback = new PasswordCallback("Password: ", false);
            
            callbackHandler.handle(new Callback[]{nameCallback, passwordCallback});

            String username = nameCallback.getName();
            char[] passwordChars = passwordCallback.getPassword();
            if (passwordChars == null) {
                throw new LoginException("No password provided");
            }
            String password = new String(passwordChars);

            // Clear password char array
            passwordCallback.clearPassword();

            // Authenticate using UserService
            User user = userService.getUserByUsername(username).orElse(null);
            if (user != null && user.getPassword().equals(password)) {
                authenticatedUser = user;
                return true;
            } else {
                throw new LoginException("Invalid username or password");
            }
        } catch (Exception e) {
            throw new LoginException("Error during authentication: " + e.getMessage());
        }
    }

    @Override
    public boolean commit() throws LoginException {
        if (authenticatedUser != null) {
            subject.getPrincipals().add(authenticatedUser); // User implements Principal
            return true;
        }
        return false;
    }

    @Override
    public boolean abort() throws LoginException {
        authenticatedUser = null;
        return true;
    }

    @Override
    public boolean logout() throws LoginException {
        subject.getPrincipals().clear();
        authenticatedUser = null;
        return true;
    }
}
