package com.bank.servlet;

import com.bank.model.User;
import com.bank.security.WebCallbackHandler;

//import com.bank.util.EmailUtil;

import javax.security.auth.Subject;
import javax.security.auth.login.LoginContext;
import javax.security.auth.login.LoginException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

//import java.util.Random;

@WebServlet("/auth/*")
public class AuthServlet extends HttpServlet {

    private LoginContext loginContext;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                try {
                    if (loginContext != null) {
                        loginContext.logout();
                    }
                } catch (LoginException e) {
                    e.printStackTrace();
                }
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            try {
                WebCallbackHandler callbackHandler = new WebCallbackHandler(username, password);
                loginContext = new LoginContext("CustomLogin", callbackHandler);
                loginContext.login();

                Subject subject = loginContext.getSubject();
                User user = subject.getPrincipals(User.class).stream().findFirst().orElse(null);

                if (user != null) {
                    int otp = 123456;
                    HttpSession session = request.getSession(true);
                    session.setAttribute("otp", otp);
                    session.setAttribute("user", user);

                    try {
                        otp = 123456;
                        //EmailUtil.sendEmail(user.getEmail(), "Your OTP for Banking System", "Your OTP is: " + otp);
                        session.setAttribute("otpSent", true);
                        response.sendRedirect(request.getContextPath() + "/verify-otp.jsp");
                    } catch (Exception e) {
                        e.printStackTrace();
                        session.setAttribute("otpSent", false);
                        request.setAttribute("errorMessage", "Failed to send OTP. Please try again.");
                        request.getRequestDispatcher("/login.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("errorMessage", "Authentication failed. User not found.");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                }

            } catch (LoginException e) {
                request.setAttribute("errorMessage", "Invalid username or password");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }

        } else if ("verifyOtp".equals(action)) {
            String enteredOtp = request.getParameter("otp");
            HttpSession session = request.getSession(false);

            if (session != null && enteredOtp != null) {
                Boolean otpSent = (Boolean) session.getAttribute("otpSent");
                if (otpSent == null || !otpSent) {
                    request.setAttribute("errorMessage", "OTP was not sent successfully. Please log in again.");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                    return;
                }

                int generatedOtp = (int) session.getAttribute("otp");
                if (Integer.parseInt(enteredOtp) == generatedOtp) {
                    session.removeAttribute("otp"); // Clear OTP after successful verification
                    session.removeAttribute("otpSent"); // Clear OTP sent flag

                    User user = (User) session.getAttribute("user");
                    session.setAttribute("username", user.getUsername());
                    session.setAttribute("role", user.getRole());
                    session.setAttribute("userId", user.getId());

                    // Redirect based on role
                    if ("ADMIN".equals(user.getRole())) {
                        response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/user-dashboard.jsp");
                    }
                } else {
                    request.setAttribute("errorMessage", "Invalid OTP. Please try again.");
                    request.getRequestDispatcher("/verify-otp.jsp").forward(request, response);
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
        } else if ("register".equals(action)) {
            // Registration logic would go here
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
}
