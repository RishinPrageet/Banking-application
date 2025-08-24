package com.bank.security;
import javax.security.auth.callback.*;

public class WebCallbackHandler implements CallbackHandler {
    private final String username;
    private final char[] password;

    public WebCallbackHandler(String username, String password) {
        this.username = username;
        this.password = password != null ? password.toCharArray() : new char[0];
    }

    @Override
    public void handle(Callback[] callbacks) 
            throws UnsupportedCallbackException {
        for (Callback cb : callbacks) {
            if (cb instanceof NameCallback) {
                ((NameCallback) cb).setName(username);
            } else if (cb instanceof PasswordCallback) {
                ((PasswordCallback) cb).setPassword(password);
            } else {
                throw new UnsupportedCallbackException(cb);
            }
        }
    }
}
