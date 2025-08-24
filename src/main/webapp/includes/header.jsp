<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<header>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.jsp">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-bank me-2" viewBox="0 0 16 16">
                    <path d="m8 0 6.61 3h.89a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-.5.5H15v7a.5.5 0 0 1 .485.38l.5 2a.498.498 0 0 1-.485.62H.5a.498.498 0 0 1-.485-.62l.5-2A.501.501 0 0 1 1 13V6H.5a.5.5 0 0 1-.5-.5v-2A.5.5 0 0 1 .5 3h.89L8 0ZM3.777 3h8.447L8 1 3.777 3ZM2 6v7h1V6H2Zm2 0v7h2.5V6H4Zm3.5 0v7h1V6h-1Zm2 0v7H12V6H9.5ZM13 6v7h1V6h-1Zm2-1V4H1v1h14Zm-.39 9H1.39l-.25 1h13.72l-.25-1Z"/>
                </svg>
                Banking System
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <% if (session.getAttribute("user") != null) { %>
                        <% if ("ADMIN".equals(session.getAttribute("role"))) { %>
                            <li class="nav-item">
                                <a class="nav-link" href="admin-dashboard.jsp">Dashboard</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="account-management.jsp">Accounts</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="transfer.jsp">Transfer</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="create-account.jsp">Create Account</a>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="loansDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    Loans
                                </a>
                                <ul class="dropdown-menu" aria-labelledby="loansDropdown">
                                    <li><a class="dropdown-item" href="admin/manage-loans.jsp">Manage Loans</a></li>
                                    <li><a class="dropdown-item" href="loan-eligibility.jsp">Eligibility Check</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="loan-chatbot.jsp">
                                        <i class="fas fa-robot me-2"></i>Loan Assistant
                                        <span class="badge bg-success ms-2">AI</span>
                                    </a></li>
                                </ul>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="statistics.jsp">Statistics</a>
                            </li>
                        <% } else { %>
                            <li class="nav-item">
                                <a class="nav-link" href="user-dashboard.jsp">Dashboard</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="transfer.jsp">Transfer</a>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="loansDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    Loans
                                </a>
                                <ul class="dropdown-menu" aria-labelledby="loansDropdown">
                                    <li><a class="dropdown-item" href="loan-eligibility.jsp">Check Eligibility</a></li>
                                    <li><a class="dropdown-item" href="my-loans.jsp">My Loans</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="loan-chatbot.jsp">
                                        <i class="fas fa-robot me-2"></i>Loan Assistant
                                        <span class="badge bg-success ms-2">AI</span>
                                    </a></li>
                                </ul>
                            </li>
                        <% } %>
                    <% } %>
                </ul>
                
                <ul class="navbar-nav">
                    <% if (session.getAttribute("user") != null) { %>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <%= session.getAttribute("username") %>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                                <li><a class="dropdown-item" href="#">Profile</a></li>
                                <li><a class="dropdown-item" href="#">Settings</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="auth?action=logout">Logout</a></li>
                            </ul>
                        </li>
                    <% } else { %>
                        <li class="nav-item">
                            <a class="nav-link" href="login.jsp">Login</a>
                        </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </nav>
</header>
