<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Management - Banking System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <div class="container my-5">
        <h1 class="mb-4 text-primary">Account Management</h1>
        
        <div class="row">
            <!-- Find Account -->
            <div class="col-md-6 mb-4">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white"><h5 class="mb-0">Find Account</h5></div>
                    <div class="card-body">
                        <form id="findAccountForm">
                            <div class="mb-3">
                                <label for="accountId" class="form-label">Account ID</label>
                                <input type="number" class="form-control" id="accountId" name="id" required>
                            </div>
                            <button type="submit" class="btn btn-primary">Find Account</button>
                        </form>
                        <div id="accountResult" class="mt-3"></div>
                    </div>
                </div>
            </div>

            <!-- Update Account -->
            <div class="col-md-6 mb-4">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white"><h5 class="mb-0">Update Account Balance</h5></div>
                    <div class="card-body">
                        <form id="updateAccountForm">
                            <div class="mb-3">
                                <label for="updateAccountId" class="form-label">Account ID</label>
                                <input type="number" class="form-control" id="updateAccountId" name="id" required>
                            </div>
                            <div class="mb-3">
                                <label for="newBalance" class="form-label">New Balance</label>
                                <input type="number" class="form-control" id="newBalance" name="amount" required>
                            </div>
                            <div class="mb-3">
                                <label for="accountType" class="form-label">Account Type</label>
                                <select class="form-select" id="accountType" name="accountType" required>
                                    <option value="SAVINGS" selected>SAVINGS</option>
                                    <option value="CURRENT">CURRENT</option>
                                    <option value="FIXED">FIXED</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary">Update Balance</button>
                        </form>
                        <div id="updateResult" class="mt-3"></div>
                    </div>
                </div>
            </div>

            <!-- Insights -->
            <div class="col-md-6 mb-4">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white"><h5 class="mb-0">Account Insights</h5></div>
                    <div class="card-body">
                        <form id="getInsightsForm">
                            <div class="mb-3">
                                <label for="insightsAccountId" class="form-label">Account ID</label>
                                <input type="number" class="form-control" id="insightsAccountId" name="id" required>
                            </div>
                            <button type="submit" class="btn btn-primary">Get Insights</button>
                        </form>
                        <div id="insightsResult" class="mt-3"></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Load All Accounts -->
        <div class="card shadow mt-4">
            <div class="card-header bg-primary text-white"><h5 class="mb-0">All Accounts</h5></div>
            <div class="card-body">
                <button id="loadAllAccounts" class="btn btn-primary mb-3">Load All Accounts</button>
                <div id="allAccountsResult" class="mt-3"></div>
            </div>
        </div>
    </div>

    <jsp:include page="includes/footer.jsp" />

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- JavaScript Logic -->
    <script>
        function escapeHtml(str) {
            return str
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/"/g, "&quot;")
                .replace(/'/g, "&#39;");
        }

        document.getElementById('findAccountForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const accountId = document.getElementById('accountId').value;
            fetch('account?action=get&id=' + accountId)
                .then(response => response.text())
                .then(data => {
                    document.getElementById('accountResult').innerHTML = '<div class="alert alert-info">' + data + '</div>';
                })
                .catch(() => {
                    document.getElementById('accountResult').innerHTML = '<div class="alert alert-danger">Error retrieving account information</div>';
                });
        });

        document.getElementById('updateAccountForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const accountId = document.getElementById('updateAccountId').value;
            const newBalance = document.getElementById('newBalance').value;
            const accountType = document.getElementById('accountType').value;

            fetch('account?action=update&id=' + accountId + '&amount=' + newBalance + '&accountType=' + accountType, {
                method: 'POST'
            })
                .then(response => response.text())
                .then(data => {
                    document.getElementById('updateResult').innerHTML = '<div class="alert alert-success">' + data + '</div>';
                })
                .catch(() => {
                    document.getElementById('updateResult').innerHTML = '<div class="alert alert-danger">Error updating account</div>';
                });
        });

        document.getElementById('loadAllAccounts').addEventListener('click', function() {
            fetch('account?action=getAll')
                .then(response => response.text())
                .then(data => {
                    const accounts = data.split('\n');
                    let tableHtml = `
                        <table class="table table-striped table-hover">
                            <thead><tr><th>Account ID</th><th>Balance</th><th>Account Type</th></tr></thead>
                            <tbody>`;
                    for (let i = 1; i < accounts.length; i++) {
                        const parts = accounts[i].trim().split(',');
                        if (parts.length >= 3) {
                            const id = parts[0].split('=')[1].trim();
                            const balance = parts[1].split('=')[1].trim();
                            const type = parts[2].split('=')[1].trim();
                            tableHtml += `<tr><td>${id}</td><td>${balance}</td><td>${type}</td></tr>`;
                        }
                    }
                    tableHtml += '</tbody></table>';
                    document.getElementById('allAccountsResult').innerHTML = tableHtml;
                })
                .catch(() => {
                    document.getElementById('allAccountsResult').innerHTML = '<div class="alert alert-danger">Error retrieving accounts</div>';
                });
        });

        document.getElementById('getInsightsForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            const accountId = document.getElementById('insightsAccountId').value;

            try {
                console.log("debug")
                const response = await fetch('account?action=getInsights&id=' + accountId);
                const data = await response.json();
                
                console.log("Full API JSON Response:", data);

                const aiText = data.choices?.[0]?.message?.content || data.text || JSON.stringify(data, null, 2);
                const cleaned = aiText
                    .replace(/�/g, "'")
                    .replace(/\u2018|\u2019/g, "'")
                    .replace(/\u201c|\u201d/g, '"');

                document.getElementById('insightsResult').innerHTML = `
                    <div class="alert alert-info">
                        <pre style="white-space: pre-wrap;">${escapeHtml(cleaned)}</pre>
                    </div>`;
            } catch (error) {
                console.error('Error fetching insights:', error);
                document.getElementById('insightsResult').innerHTML = '<div class="alert alert-danger">Error retrieving insights</div>';
            }
        });
    </script>
</body>
</html>
