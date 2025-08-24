<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Banking Statistics - Banking System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <div class="container my-5">
        <h1 class="mb-4 text-primary">Banking Statistics Dashboard</h1>
        
        <!-- Summary Cards -->
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="card shadow h-100">
                    <div class="card-body text-center">
                        <h5 class="card-title">Total Accounts</h5>
                        <div class="display-4 fw-bold text-primary mb-3" id="totalAccounts">-</div>
                        <p class="card-text text-muted">Total number of accounts in the system</p>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card shadow h-100">
                    <div class="card-body text-center">
                        <h5 class="card-title">Total Balance</h5>
                        <div class="display-4 fw-bold text-primary mb-3">$<span id="totalBalance">-</span></div>
                        <p class="card-text text-muted">Sum of all account balances</p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Charts Row -->
        <div class="row mb-4">
            <div class="col-md-6 mb-4">
                <div class="card shadow h-100">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Account Balance Distribution</h5>
                    </div>
                    <div class="card-body">
                        <canvas id="balanceDistributionChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-md-6 mb-4">
                <div class="card shadow h-100">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Transaction Volume by Day</h5>
                    </div>
                    <div class="card-body">
                        <canvas id="transactionVolumeChart"></canvas>
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
        
        // Fetch balance distribution and create chart
        fetch('statistics?action=balanceDistribution')
            .then(response => response.json())
            .then(data => {
                const ctx = document.getElementById('balanceDistributionChart').getContext('2d');
                new Chart(ctx, {
                    type: 'pie',
                    data: {
                        labels: Object.keys(data),
                        datasets: [{
                            data: Object.values(data),
                            backgroundColor: [
                                'rgba(75, 192, 192, 0.7)',
                                'rgba(54, 162, 235, 0.7)',
                                'rgba(153, 102, 255, 0.7)',
                                'rgba(255, 159, 64, 0.7)'
                            ],
                            borderColor: [
                                'rgba(75, 192, 192, 1)',
                                'rgba(54, 162, 235, 1)',
                                'rgba(153, 102, 255, 1)',
                                'rgba(255, 159, 64, 1)'
                            ],
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: {
                                position: 'bottom'
                            },
                            title: {
                                display: true,
                                text: 'Account Balance Distribution'
                            }
                        }
                    }
                });
            })
            .catch(error => {
                console.error('Error fetching balance distribution:', error);
                document.getElementById('balanceDistributionChart').innerHTML = 'Error loading chart';
            });
        
        // Fetch transaction volume by day and create chart
        fetch('statistics?action=transactionVolumeByDay')
            .then(response => response.json())
            .then(data => {
                const ctx = document.getElementById('transactionVolumeChart').getContext('2d');
                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: Object.keys(data),
                        datasets: [{
                            label: 'Transaction Volume',
                            data: Object.values(data),
                            backgroundColor: 'rgba(54, 162, 235, 0.7)',
                            borderColor: 'rgba(54, 162, 235, 1)',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        scales: {
                            y: {
                                beginAtZero: true,
                                title: {
                                    display: true,
                                    text: 'Amount'
                                }
                            },
                            x: {
                                title: {
                                    display: true,
                                    text: 'Date'
                                }
                            }
                        }
                    }
                });
            })
            .catch(error => {
                console.error('Error fetching transaction volume:', error);
                document.getElementById('transactionVolumeChart').innerHTML = 'Error loading chart';
            });
        
        // Fetch recent transactions
        fetch('statistics?action=recentTransactions&limit=10')
            .then(response => response.json())
            .then(data => {
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
            });
    </script>
</body>
</html>
