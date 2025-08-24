<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - Banking System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h3 class="mb-0">Create New Account</h3>
                    </div>
                    <div class="card-body">
                        <form id="createAccountForm">
                            <div class="mb-3">
                                <label for="username" class="form-label">Name</label>
                                <input type="text" class="form-control" id="username" name="username" required>
                                <div class="form-text">Enter the user's full name.</div>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                                <div class="form-text">Enter a secure password for the user.</div>
                            </div>
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                                <div class="form-text">Enter the user's email address.</div>
                            </div>
                            <div class="mb-3">
                                <label for="initialBalance" class="form-label">Initial Balance</label>
                                <div class="input-group">
                                    <span class="input-group-text">$</span>
                                    <input type="number" class="form-control" id="initialBalance" name="amount" required>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="accountType" class="form-label">Account Type</label>
                                <select class="form-select" id="accountType" name="accountType" required>
                                    <option value="SAVINGS" selected>SAVINGS</option>
                                    <option value="CURRENT">CURRENT</option>
                                    <option value="FIXED">FIXED</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary">Create User and Account</button>
                        </form>
                        <div id="createResult" class="mt-4"></div>
                    </div>
                </div>
                
                <div class="card mt-4 shadow">
                    <div class="card-header bg-primary text-white">
                        <h3 class="mb-0">Account Creation Guidelines</h3>
                    </div>
                    <div class="card-body">
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check-circle-fill text-success me-2" viewBox="0 0 16 16">
                                    <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
                                </svg>
                                Account ID must be a unique positive integer
                            </li>
                            <li class="list-group-item">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check-circle-fill text-success me-2" viewBox="0 0 16 16">
                                    <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
                                </svg>
                                Initial balance must be a non-negative amount
                            </li>
                            <li class="list-group-item">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check-circle-fill text-success me-2" viewBox="0 0 16 16">
                                    <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
                                </svg>
                                Once created, you can manage your account from the Accounts page
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="includes/footer.jsp" />
    
    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        document.getElementById('createAccountForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            const email = document.getElementById('email').value;
            const initialBalance = document.getElementById('initialBalance').value;
            const accountType = document.getElementById('accountType').value;

            console.log('Creating user and account with details:'); // Debugging
            console.log('Username:', username); // Debugging
            console.log('Password:', password); // Debugging
            console.log('Email:', email); // Debugging
            console.log('Initial Balance:', initialBalance); // Debugging
            console.log('Account Type:', accountType); // Debugging

            const url = "account?action=createUserAccount&username=" + username + 
                        "&password=" + password + 
                        "&email=" + email + 
                        "&amount=" + initialBalance + 
                        "&accountType=" + accountType;

            console.log('Request URL:', url); // Debugging

            fetch(url, {
                method: 'POST'
            })
            .then(response => response.text())
            .then(data => {
                console.log('Response from server:', data); // Debugging
                const resultDiv = document.getElementById('createResult');
                if (data.includes("successfully")) {
                    resultDiv.innerHTML = 
                        '<div class="alert alert-success">' +
                            '<h5>User and Account Created Successfully!</h5>' +
                            '<p>' + data + '</p>' +
                        '</div>';
                } else {
                    resultDiv.innerHTML = '<div class="alert alert-danger">' + data + '</div>';
                }
            })
            .catch(error => {
                console.error('Error in creating user and account:', error); // Debugging
                const resultDiv = document.getElementById('createResult');
                resultDiv.innerHTML = '<div class="alert alert-danger">Error creating user and account</div>';
            });
        });
    </script>
</body>
</html>
