<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Banking System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <div class="container my-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="text-primary">Admin Dashboard</h1>
            <div>
                <span class="badge bg-primary me-2">Admin</span>
                <span class="text-muted">Welcome, <%= session.getAttribute("username") %></span>
            </div>
        </div>
        
        <!-- Quick Stats -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="card shadow h-100">
                    <div class="card-body text-center">
                        <h5 class="card-title">Total Accounts</h5>
                        <div class="display-4 fw-bold text-primary mb-3" id="totalAccounts">-</div>
                        <a href="account-management.jsp" class="btn btn-sm btn-outline-primary">Manage Accounts</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card shadow h-100">
                    <div class="card-body text-center">
                        <h5 class="card-title">Total Balance</h5>
                        <div class="display-4 fw-bold text-primary mb-3">$<span id="totalBalance">-</span></div>
                        <a href="statistics.jsp" class="btn btn-sm btn-outline-primary">View Statistics</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card shadow h-100">
                    <div class="card-body text-center">
                        <h5 class="card-title">Recent Transactions</h5>
                        <div class="display-4 fw-bold text-primary mb-3" id="recentTransactionsCount">-</div>
                        <a href="statistics.jsp" class="btn btn-sm btn-outline-primary">View All</a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Admin Actions -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Quick Actions</h5>
                    </div>
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <a href="account-management.jsp" class="btn btn-outline-primary w-100 py-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-person-vcard d-block mx-auto mb-2" viewBox="0 0 16 16">
                                        <path d="M5 8a2 2 0 1 0 0-4 2 2 0 0 0 0 4Zm4-2.5a.5.5 0 0 1 .5-.5h4a.5.5 0 0 1 0 1h-4a.5.5 0 0 1-.5-.5ZM9 8a.5.5 0 0 1 .5-.5h4a.5.5 0 0 1 0 1h-4A.5.5 0 0 1 9 8Zm1 2.5a.5.5 0 0 1 .5-.5h3a.5.5 0 0 1 0 1h-3a.5.5 0 0 1-.5-.5Z"/>
                                        <path d="M2 2a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V4a2 2 0 0 0-2-2H2ZM1 4a1 1 0 0 1 1-1h12a1 1 0 0 1 1 1v8a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1V4Z"/>
                                    </svg>
                                    Manage Accounts
                                </a>
                            </div>
                            <div class="col-md-3">
                                <a href="create-account.jsp" class="btn btn-outline-primary w-100 py-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-plus-circle d-block mx-auto mb-2" viewBox="0 0 16 16">
                                        <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                                        <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z"/>
                                    </svg>
                                    Create Account
                                </a>
                            </div>
                            <div class="col-md-3">
                                <a href="transfer.jsp" class="btn btn-outline-primary w-100 py-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-arrow-left-right d-block mx-auto mb-2" viewBox="0 0 16 16">
                                        <path fill-rule="evenodd" d="M1 11.5a.5.5 0 0 0 .5.5h11.793l-3.147 3.146a.5.5 0 0 0 .708.708l4-4a.5.5 0 0 0 0-.708l-4-4a.5.5 0 0 0-.708.708L13.293 11H1.5a.5.5 0 0 0-.5.5zm14-7a.5.5 0 0 1-.5.5H2.707l3.147 3.146a.5.5 0 1 1-.708.708l-4-4a.5.5 0 0 1 0-.708l4-4a.5.5 0 1 1 .708.708L2.707 4H14.5a.5.5 0 0 1 .5.5z"/>
                                    </svg>
                                    Transfer Money
                                </a>
                            </div>
                            <div class="col-md-3">
                                <a href="statistics.jsp" class="btn btn-outline-primary w-100 py-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-bar-chart d-block mx-auto mb-2" viewBox="0 0 16 16">
                                        <path d="M4 11H2v3h2v-3zm5-4H7v7h2V7zm5-5v12h-2V2h2zm-2-1a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1h-2zM6 7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7a1 1 0 0 1-1 1H7a1 1 0 0 1-1-1V7zm-5 4a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1v-3z"/>
                                    </svg>
                                    View Statistics
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Add interest rate management to admin dashboard -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Interest Rate Management</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive mb-3">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Account Type</th>
                                        <th>Current Rate (%)</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="interestRatesBody">
                                    <tr>
                                        <td colspan="3" class="text-center">Loading interest rates...</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        
                        <form id="updateRateForm" class="row g-3">
                            <div class="col-md-4">
                                <label for="accountTypeSelect" class="form-label">Account Type</label>
                                <select class="form-select" id="accountTypeSelect" name="accountType" required>
                                    <option value="SAVINGS">SAVINGS</option>
                                    <option value="CURRENT">CURRENT</option>
                                    <option value="FIXED">FIXED</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label for="newRate" class="form-label">New Rate (%)</label>
                                <input type="number" class="form-control" id="newRate" name="rate" step="0.01" min="0" max="20" required>
                            </div>
                            <div class="col-md-4 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary w-100">Update Rate</button>
                            </div>
                        </form>
                        <div id="updateRateResult" class="mt-3"></div>
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
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>From Account</th>
                                <th>To Account</th>
                                <th>Amount</th>
                                <th>Type</th>
                                <th>Timestamp</th>
                            </tr>
                        </thead>
                        <tbody id="recentTransactionsBody">
                            <tr>
                                <td colspan="6" class="text-center">Loading transactions...</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="includes/footer.jsp" />
    
    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Fetch total accounts
        fetch('statistics?action=totalAccounts')
            .then(response => response.json())
            .then(data => {
                document.getElementById('totalAccounts').textContent = data.totalAccounts;
            })
            .catch(error => {
                console.error('Error fetching total accounts:', error);
                document.getElementById('totalAccounts').textContent = 'Error';
            });
        
        // Fetch total balance
        fetch('statistics?action=totalBalance')
            .then(response => response.json())
            .then(data => {
                document.getElementById('totalBalance').textContent = data.totalBalance;
            })
            .catch(error => {
                console.error('Error fetching total balance:', error);
                document.getElementById('totalBalance').textContent = 'Error';
            });
        
        // Fetch recent transactions
        fetch('statistics?action=recentTransactions&limit=5')
            .then(response => response.json())
            .then(data => {
                document.getElementById('recentTransactionsCount').textContent = data.length;
                
                const tableBody = document.getElementById('recentTransactionsBody');
                
                if (data.length === 0) {
                    tableBody.innerHTML = '<tr><td colspan="6" class="text-center">No transactions found</td></tr>';
                    return;
                }
                
                let tableContent = '';
                data.forEach(transaction => {
                    const timestamp = new Date(transaction.timestamp).toLocaleString();
                    tableContent += '<tr>';
                    tableContent += '<td>' + transaction.id + '</td>';
                    tableContent += '<td>' + transaction.fromAccountId + '</td>';
                    tableContent += '<td>' + transaction.toAccountId + '</td>';
                    tableContent += '<td>$' + transaction.amount + '</td>';
                    tableContent += '<td>' + transaction.type + '</td>';
                    tableContent += '<td>' + timestamp + '</td>';
                    tableContent += '</tr>';
                });
                
                tableBody.innerHTML = tableContent;
            })
            .catch(error => {
                console.error('Error fetching recent transactions:', error);
                document.getElementById('recentTransactionsBody').innerHTML = 
                    '<tr><td colspan="6" class="text-center text-danger">Error loading transactions</td></tr>';
                document.getElementById('recentTransactionsCount').textContent = 'Error';
            });
        
        // Fetch interest rates
        fetch('account?action=getInterestRates')
            .then(response => response.json())
            .then(data => {
                const tableBody = document.getElementById('interestRatesBody');
                
                if (Object.keys(data).length === 0) {
                    tableBody.innerHTML = '<tr><td colspan="3" class="text-center">No interest rates found</td></tr>';
                    return;
                }
                
                let tableContent = '';
                for (const [accountType, rate] of Object.entries(data)) {
                    tableContent += '<tr>';
                    tableContent += '<td>' + accountType + '</td>';
                    tableContent += '<td>' + rate + '%</td>';
                    tableContent += '<td><button class="btn btn-sm btn-outline-primary" onclick="prepareRateUpdate(\'' + accountType + '\', ' + rate + ')">Edit</button></td>';
                    tableContent += '</tr>';
                }
                
                tableBody.innerHTML = tableContent;
            })
            .catch(error => {
                console.error('Error fetching interest rates:', error);
                document.getElementById('interestRatesBody').innerHTML = 
                    '<tr><td colspan="3" class="text-center text-danger">Error loading interest rates</td></tr>';
            });
        
        // Function to prepare rate update form
        function prepareRateUpdate(accountType, rate) {
            document.getElementById('accountTypeSelect').value = accountType;
            document.getElementById('newRate').value = rate;
            document.getElementById('newRate').focus();
        }
        
        // Handle interest rate update form submission
        document.getElementById('updateRateForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const accountType = document.getElementById('accountTypeSelect').value;
            const rate = document.getElementById('newRate').value;
            
            fetch('account?action=updateInterestRate&accountType=' + accountType + '&rate=' + rate, {
                method: 'POST'
            })
                .then(response => response.text())
                .then(data => {
                    const resultDiv = document.getElementById('updateRateResult');
                    if (data.includes('updated')) {
                        resultDiv.innerHTML = '<div class="alert alert-success">' + data + '</div>';
                        // Refresh the interest rates table
                        fetch('account?action=getInterestRates')
                            .then(response => response.json())
                            .then(data => {
                                const tableBody = document.getElementById('interestRatesBody');
                                let tableContent = '';
                                for (const [accountType, rate] of Object.entries(data)) {
                                    tableContent += '<tr>';
                                    tableContent += '<td>' + accountType + '</td>';
                                    tableContent += '<td>' + rate + '%</td>';
                                    tableContent += '<td><button class="btn btn-sm btn-outline-primary" onclick="prepareRateUpdate(\'' + accountType + '\', ' + rate + ')">Edit</button></td>';
                                    tableContent += '</tr>';
                                }
                                tableBody.innerHTML = tableContent;
                            });
                    } else {
                        resultDiv.innerHTML = '<div class="alert alert-danger">' + data + '</div>';
                    }
                })
                .catch(error => {
                    console.error('Error updating interest rate:', error);
                    const resultDiv = document.getElementById('updateRateResult');
                    resultDiv.innerHTML = '<div class="alert alert-danger">Error updating interest rate</div>';
                });
        });
    </script>
</body>
</html>
