package com.bank.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization logic if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String uri = httpRequest.getRequestURI();
        HttpSession session = httpRequest.getSession(false);

        // Allow access to login, registration, and static resources
        if (uri.endsWith("login.jsp") || uri.endsWith("auth") || uri.contains("static") || uri.endsWith("register.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        // Restrict access to authenticated users only
        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
            return;
        }

        // Role-based access control
        String role = (String) session.getAttribute("role");
        if (uri.contains("/admin-") && !"ADMIN".equals(role)) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/access-denied.jsp");
            return;
        } else if (uri.contains("/user-") && !"USER".equals(role)) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/access-denied.jsp");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup logic if needed
    }
}
