<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard - Banking System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <div class="container my-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="text-primary">My Dashboard</h1>
            <div>
                <span class="badge bg-success me-2">User</span>
                <span class="text-muted">Welcome, <%= session.getAttribute("username") %></span>
            </div>
        </div>
        
        <!-- User's Accounts -->
        <div class="card shadow mb-4">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">My Accounts</h5>
            </div>
            <div class="card-body">
                <div id="userAccountsContainer">
                    <p class="text-center">Loading your accounts...</p>
                </div>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Quick Actions</h5>
                    </div>
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <a href="transfer.jsp" class="btn btn-outline-primary w-100 py-3">
                                    <!-- SVG icon omitted for brevity -->
                                    Transfer Money
                                </a>
                            </div>
                            <div class="col-md-6">
                                <a href="#" class="btn btn-outline-primary w-100 py-3" id="viewTransactionsBtn">
                                    <!-- SVG icon omitted for brevity -->
                                    View Transaction History
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Account Insights -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Account Insights</h5>
                    </div>
                    <div class="card-body">
                        <form id="getInsightsForm">
                            <div class="row g-3 align-items-end">
                                <div class="col-md-8">
                                    <label for="insightsAccountId" class="form-label">Select Account</label>
                                    <select class="form-select" id="insightsAccountId" name="id" required>
                                        <option value="">Select an account</option>
                                        <!-- Populated dynamically -->
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <button type="submit" class="btn btn-primary w-100">Get AI Insights</button>
                                </div>
                            </div>
                        </form>
                        <div id="insightsResult" class="mt-3"></div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Recent Transactions -->
        <div class="card shadow">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">Recent Transactions</h5>
            </div>
            <div class="card-body">
                <div id="userTransactionsContainer">
                    <p class="text-center">Loading your recent transactions...</p>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="includes/footer.jsp" />
    
    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
    // Fetch user's accounts
   fetch('account?action=getUserAccounts')
    .then(function(response) {
        console.log('Raw fetch response:', response);
        return response.json();
    })
    .then(function(data) {
        console.log('Parsed JSON data:', data);

        if (!data || data.length === 0) {
            document.getElementById('userAccountsContainer').innerHTML =
                '<div class="alert alert-info">You don\'t have any accounts yet.</div>';
            return;
        }

        var accountsHtml = '<div class="row">';
        var insightsSelect = document.getElementById('insightsAccountId');

        data.forEach(function(account) {
            var id = account.id;
            var amount = account.amount;
            var accountType = account.accountType;
            var interestRate = account.interestRate;

            // Build account cards with string concatenation
            accountsHtml +=
                '<div class="col-md-4 mb-3">' +
                    '<div class="card h-100 border-primary">' +
                        '<div class="card-body">' +
                            '<h5 class="card-title">Account #' + id + '</h5>' +
                            '<h6 class="card-subtitle mb-2 text-muted">' + accountType + ' Account</h6>' +
                            '<p class="card-text display-6 fw-bold text-primary">₹' + 
                                amount.toLocaleString() + 
                            '</p>' +
                            '<p class="card-text"><small class="text-muted">Interest Rate: ' +
                                interestRate + 
                            '%</small></p>' +
                        '</div>' +
                        '<div class="card-footer bg-transparent border-top">' +
                            '<div class="d-flex justify-content-between">' +
                                '<button class="btn btn-sm btn-outline-primary" onclick="viewTransactions(' + 
                                    id + 
                                ')">Transactions</button>' +
                                '<a href="transfer.jsp" class="btn btn-sm btn-primary">Transfer</a>' +
                            '</div>' +
                        '</div>' +
                    '</div>' +
                '</div>';

            // Populate insights dropdown
            var option = document.createElement('option');
            option.value = id;
            option.textContent = 
                'Account #' + id + ' (' + accountType + ') - ₹' + amount.toLocaleString();
            insightsSelect.appendChild(option);
        });

        accountsHtml += '</div>';
        document.getElementById('userAccountsContainer').innerHTML = accountsHtml;
    })
    .catch(function(error) {
        console.error('Error fetching accounts:', error);
        document.getElementById('userAccountsContainer').innerHTML =
            '<div class="alert alert-danger">Error loading your accounts.</div>';
    });


    // Handle insights form submission
    document.getElementById('getInsightsForm').addEventListener('submit', function(e) {
        e.preventDefault();
        var accountId = document.getElementById('insightsAccountId').value;
        
        if (!accountId) {
            alert('Please select an account.');
            return;
        }
        
        document.getElementById('insightsResult').innerHTML =
            '<div class="text-center">' +
                '<div class="spinner-border text-primary" role="status">' +
                    '<span class="visually-hidden">Loading...</span>' +
                '</div>' +
                '<p class="mt-2">Generating AI insights...</p>' +
            '</div>';

        fetch('account?action=getInsights&id=' + accountId)
            .then(function(response) { return response.text(); })
            .then(function(data) {
                var withBreaks = data.replace(/\\n/g, '<br>');
                document.getElementById('insightsResult').innerHTML =
                    '<div class="alert alert-info mt-3">' + withBreaks + '</div>';
            })
            .catch(function(error) {
                console.error('Error getting insights:', error);
                document.getElementById('insightsResult').innerHTML =
                    '<div class="alert alert-danger mt-3">Error retrieving insights</div>';
            });
    });

    // Render placeholder transactions with string concatenation
    document.getElementById('userTransactionsContainer').innerHTML =
        '<div class="table-responsive">' +
            '<table class="table table-striped table-hover">' +
                '<thead>' +
                    '<tr>' +
                        '<th>Date</th>' +
                        '<th>Description</th>' +
                        '<th>Amount</th>' +
                        '<th>Status</th>' +
                    '</tr>' +
                '</thead>' +
                '<tbody>' +
                    '<tr>' +
                        '<td>Today</td>' +
                        '<td>Transfer to Account #102</td>' +
                        '<td class="text-danger">-₹500.00</td>' +
                        '<td><span class="badge bg-success">Completed</span></td>' +
                    '</tr>' +
                    '<tr>' +
                        '<td>Yesterday</td>' +
                        '<td>Deposit</td>' +
                        '<td class="text-success">+₹1,200.00</td>' +
                        '<td><span class="badge bg-success">Completed</span></td>' +
                    '</tr>' +
                    '<tr>' +
                        '<td>05/12/2025</td>' +
                        '<td>Transfer from Account #105</td>' +
                        '<td class="text-success">+₹350.00</td>' +
                        '<td><span class="badge bg-success">Completed</span></td>' +
                    '</tr>' +
                '</tbody>' +
            '</table>' +
        '</div>';

    function viewTransactions(accountId) {
        alert("Viewing transactions for account #" + accountId + 
              "\nThis would show a detailed transaction history for this specific account.");
    }

    document.getElementById('viewTransactionsBtn').addEventListener('click', function(e) {
        e.preventDefault();
        alert("This would show a complete transaction history for all your accounts.");
    });
    </script>
</body>
</html>
