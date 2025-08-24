<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transfer Money - Banking System</title>
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
                        <h3 class="mb-0">Transfer Money</h3>
                    </div>
                    <div class="card-body">
                        <form id="transferForm">
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="fromAccountId" class="form-label">From Account</label>
                                    <select class="form-select" id="fromAccountId" name="fromAccountId" required>
                                        <option value="">Select your account</option>
                                        <!-- Will be populated with user's accounts -->
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="toAccountId" class="form-label">To Account ID</label>
                                    <input type="number" class="form-control" id="toAccountId" name="toAccountId" required>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="transferAmount" class="form-label">Amount to Transfer</label>
                                <div class="input-group">
                                    <span class="input-group-text">$</span>
                                    <input type="number" class="form-control" id="transferAmount" name="amount" required>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary">Transfer Money</button>
                        </form>
                        <div id="transferResult" class="mt-4"></div>
                    </div>
                </div>
                
                <div class="card mt-4 shadow">
                    <div class="card-header bg-primary text-white">
                        <h3 class="mb-0">Transfer Guidelines</h3>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-info">
                            <h5>Before making a transfer:</h5>
                            <ul class="mb-0">
                                <li>Ensure both accounts exist</li>
                                <li>The source account must have sufficient funds</li>
                                <li>Transfer amount must be greater than zero</li>
                                <li>Source and destination accounts must be different</li>
                            </ul>
                        </div>
                        
                        <div class="d-grid gap-2 mt-3">
                            <a href="account-management.jsp" class="btn btn-outline-primary">View Your Accounts</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="includes/footer.jsp" />
    
    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        // Fetch user's accounts for the dropdown
        fetch('account?action=getUserAccounts')
            .then(response => response.text())
            .then(data => {
                const accounts = data.split("\n");
                const fromAccountSelect = document.getElementById('fromAccountId');
                
                // Clear any existing options
                fromAccountSelect.innerHTML = '<option value="">Select your account</option>';
                
                // Add user's accounts to the dropdown
                for (let i = 1; i < accounts.length; i++) {
                    const account = accounts[i].trim();
                    if (account) {
                        const parts = account.split(",");
                        const idPart = parts[0].trim();
                        const balancePart = parts[1] ? parts[1].trim() : "";
                        const typePart = parts[2] ? parts[2].trim() : "";

                        const id = idPart.split("=")[1].trim();
                        const balance = balancePart.split("=")[1].trim();
                        const type = typePart.split("=")[1].trim();
                        
                        const option = document.createElement('option');
                        option.value = id;
                        option.textContent = 'Account #' + id + ' (' + type + ') - $' + balance;
                        fromAccountSelect.appendChild(option);
                    }
                }
            })
            .catch(error => {
                console.error('Error fetching user accounts:', error);
                document.getElementById('fromAccountId').innerHTML = 
                    '<option value="">Error loading accounts</option>';
            });
    });

    document.getElementById('transferForm').addEventListener('submit', function(e) {
        e.preventDefault();
        const fromAccountId = document.getElementById('fromAccountId').value;
        const toAccountId = document.getElementById('toAccountId').value;
        const amount = document.getElementById('transferAmount').value;
        
        // Validate input
        if (fromAccountId === toAccountId) {
            document.getElementById('transferResult').innerHTML = 
                `<div class="alert alert-danger">Source and destination accounts cannot be the same</div>`;
            return;
        }
        
        if (parseInt(amount) <= 0) {
            document.getElementById('transferResult').innerHTML = 
                `<div class="alert alert-danger">Transfer amount must be greater than zero</div>`;
            return;
        }
        
        fetch('account?action=transfer&fromAccountId=' + fromAccountId + '&toAccountId=' + toAccountId + '&amount=' + amount, {
            method: 'POST'
        })
            .then(response => response.text())
            .then(data => {
                const resultDiv = document.getElementById('transferResult');
                if (data.includes('Transferred')) {
                    resultDiv.innerHTML = `
                        <div class="alert alert-success">
                            <h5>Transfer Successful!</h5>
                            <p>${data}</p>
                            <div class="mt-3">
                                <a href="account-management.jsp" class="btn btn-primary btn-sm">View Accounts</a>
                            </div>
                        </div>
                    `;
                } else {
                    resultDiv.innerHTML = `<div class="alert alert-danger">${data}</div>`;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                const resultDiv = document.getElementById('transferResult');
                resultDiv.innerHTML = `<div class="alert alert-danger">Error processing transfer</div>`;
            });
    });
</script>
</body>
</html>
