<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Loans - Banking System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
        .loan-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .loan-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .status-badge {
            position: absolute;
            top: 10px;
            right: 10px;
        }
        .payment-history {
            max-height: 200px;
            overflow-y: auto;
        }
        .progress-thin {
            height: 6px;
        }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />

    <div class="container my-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="text-primary">My Loans</h1>
            <a href="loan-eligibility.jsp" class="btn btn-success">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-plus-circle me-2" viewBox="0 0 16 16">
                    <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                    <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z"/>
                </svg>
                Apply for New Loan
            </a>
        </div>

        <div class="row mb-4">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <h5 class="card-title">Loan Summary</h5>
                        <div class="row">
                            <div class="col-md-3 mb-3">
                                <div class="card bg-light h-100">
                                    <div class="card-body text-center">
                                        <h6 class="text-muted mb-2">Active Loans</h6>
                                        <h3 class="mb-0 text-primary" id="activeLoanCount">-</h3>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="card bg-light h-100">
                                    <div class="card-body text-center">
                                        <h6 class="text-muted mb-2">Total Outstanding</h6>
                                        <h3 class="mb-0 text-primary" id="totalOutstanding">-</h3>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="card bg-light h-100">
                                    <div class="card-body text-center">
                                        <h6 class="text-muted mb-2">Monthly Payment</h6>
                                        <h3 class="mb-0 text-primary" id="totalMonthlyPayment">-</h3>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="card bg-light h-100">
                                    <div class="card-body text-center">
                                        <h6 class="text-muted mb-2">Next Payment Due</h6>
                                        <h3 class="mb-0 text-primary" id="nextPaymentDate">-</h3>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <ul class="nav nav-tabs mb-4" id="loanTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="active-tab" data-bs-toggle="tab" data-bs-target="#active-loans" type="button" role="tab">Active Loans</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="pending-tab" data-bs-toggle="tab" data-bs-target="#pending-loans" type="button" role="tab">Pending Applications</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="closed-tab" data-bs-toggle="tab" data-bs-target="#closed-loans" type="button" role="tab">Closed Loans</button>
            </li>
        </ul>

        <div class="tab-content" id="loanTabContent">
            <div class="tab-pane fade show active" id="active-loans" role="tabpanel">
                <div id="activeLoansContainer">
                    <div class="text-center py-5">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        <p class="mt-2">Loading your active loans...</p>
                    </div>
                </div>
            </div>
            <div class="tab-pane fade" id="pending-loans" role="tabpanel">
                <div id="pendingLoansContainer">
                    <div class="text-center py-5">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        <p class="mt-2">Loading your pending applications...</p>
                    </div>
                </div>
            </div>
            <div class="tab-pane fade" id="closed-loans" role="tabpanel">
                <div id="closedLoansContainer">
                    <div class="text-center py-5">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        <p class="mt-2">Loading your closed loans...</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Payment Modal -->
    <div class="modal fade" id="paymentModal" tabindex="-1" aria-labelledby="paymentModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="paymentModalLabel">Make Payment</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="paymentForm">
                        <input type="hidden" id="paymentLoanId" name="loanId">
                        
                        <div class="mb-3">
                            <label for="paymentAmount" class="form-label">Payment Amount (₹)</label>
                            <div class="input-group">
                                <span class="input-group-text">₹</span>
                                <input type="number" class="form-control" id="paymentAmount" name="amount" required>
                            </div>
                            <div class="form-text">Monthly payment due: ₹<span id="monthlyDue">0</span></div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="paymentMethod" class="form-label">Payment Method</label>
                            <select class="form-select" id="paymentMethod" name="paymentMethod" required>
                                <option value="account">Bank Account</option>
                                <option value="card">Credit/Debit Card</option>
                                <option value="upi">UPI</option>
                            </select>
                        </div>
                        
                        <div id="accountSelection" class="mb-3">
                            <label for="fromAccount" class="form-label">From Account</label>
                            <select class="form-select" id="fromAccount" name="fromAccount">
                                <!-- Will be populated with user accounts -->
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="submitPaymentBtn">Make Payment</button>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="includes/footer.jsp" />

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Load user loans
            loadUserLoans();
            
            // Handle payment method change
            document.getElementById('paymentMethod').addEventListener('change', function() {
                const accountSelection = document.getElementById('accountSelection');
                if (this.value === 'account') {
                    accountSelection.style.display = 'block';
                } else {
                    accountSelection.style.display = 'none';
                }
            });
            
            // Handle payment submission
            document.getElementById('submitPaymentBtn').addEventListener('click', function() {
                const form = document.getElementById('paymentForm');
                
                if (!form.checkValidity()) {
                    form.reportValidity();
                    return;
                }
                
                const loanId = document.getElementById('paymentLoanId').value;
                const amount = document.getElementById('paymentAmount').value;
                const paymentMethod = document.getElementById('paymentMethod').value;
                const fromAccount = document.getElementById('fromAccount').value;
                
                // Show loading state
                this.disabled = true;
                this.innerHTML = "<span class='spinner-border spinner-border-sm' role='status' aria-hidden='true'></span> Processing...";
                
                // Submit payment
                const formData = new URLSearchParams();
                formData.append('action', 'makePayment');
                formData.append('loanId', loanId);
                formData.append('amount', amount);
                formData.append('paymentMethod', paymentMethod);
                if (paymentMethod === 'account') {
                    formData.append('fromAccount', fromAccount);
                }
                
                fetch('loan', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: formData
                })
                .then(response => {
                    console.log('Payment Response:', response);
                    return response.text();
                })
                .then(result => {
                    console.log('Payment Result:', result);
                    alert(result);
                    
                    // Close modal and reload loans
                    bootstrap.Modal.getInstance(document.getElementById('paymentModal')).hide();
                    loadUserLoans();
                    
                    // Reset button
                    this.disabled = false;
                    this.innerHTML = "Make Payment";
                })
                .catch(error => {
                    console.error('Error making payment:', error);
                    alert('Failed to process payment. Please try again.');
                    
                    // Reset button
                    this.disabled = false;
                    this.innerHTML = "Make Payment";
                });
            });
        });
        
        function loadUserLoans() {
            // Load user accounts for payment
            fetch('account?action=getUserAccounts')
                .then(response => {
                    console.log('Accounts Response:', response);
                    return response.text();
                })
                .then(data => {
                    console.log('Accounts Data:', data);
                    const accounts = data.split("\n");
                    const accountSelect = document.getElementById('fromAccount');
                    accountSelect.innerHTML = '';
                    
                    for (let i = 1; i < accounts.length; i++) {
                        const account = accounts[i].trim();
                        if (account) {
                            const parts = account.split(",");
                            const idPart = parts[0].trim();
                            const balancePart = parts[1] ? parts[1].trim() : "";
                            const typePart = parts[2] ? parts[2].trim() : "";

                            const id = idPart.split("=")[1].trim();
                            const balance = balancePart.split("=")[1]?.trim() || "0";
                            const type = typePart.split("=")[1]?.trim() || "Unknown";
                            
                            const option = document.createElement('option');
                            option.value = id;
                            option.textContent = "Account #" + id + " (" + type + ") - ₹" + balance;
                            accountSelect.appendChild(option);
                        }
                    }
                })
                .catch(error => {
                    console.error('Error loading accounts:', error);
                });
            
            // Load active loans
            fetch('loan?action=getUserLoans&status=ACTIVE')
                .then(response => {
                    console.log('Active Loans Response:', response);
                    return response.json();
                })
                .then(data => {
                    console.log('Active Loans Data:', data);
                    // Update summary
                    document.getElementById('activeLoanCount').textContent = data.length;
                    
                    let totalOutstanding = 0;
                    let totalMonthlyPayment = 0;
                    let nextPaymentDate = null;
                    
                    data.forEach(loan => {
                        totalOutstanding += loan.remainingAmount || 0;
                        totalMonthlyPayment += loan.monthlyPayment || 0;
                        
                        // Find closest payment date
                        if (!nextPaymentDate || new Date(loan.nextPaymentDate) < new Date(nextPaymentDate)) {
                            nextPaymentDate = loan.nextPaymentDate;
                        }
                    });
                    
                    document.getElementById('totalOutstanding').textContent = "₹" + totalOutstanding.toLocaleString();
                    document.getElementById('totalMonthlyPayment').textContent = "₹" + totalMonthlyPayment.toLocaleString();
                    document.getElementById('nextPaymentDate').textContent = nextPaymentDate ? new Date(nextPaymentDate).toLocaleDateString() : "N/A";
                    
                    // Render active loans
                    renderLoans(data, 'activeLoansContainer');
                })
                .catch(error => {
                    console.error('Error loading active loans:', error);
                    document.getElementById('activeLoansContainer').innerHTML = 
                        "<div class='alert alert-danger'>Error loading your active loans. Please try again later.</div>";
                });
            
            // Load pending loans
            fetch('loan?action=getUserLoans&status=PENDING')
                .then(response => {
                    console.log('Pending Loans Response:', response);
                    return response.json();
                })
                .then(data => {
                    console.log('Pending Loans Data:', data);
                    renderPendingLoans(data, 'pendingLoansContainer');
                })
                .catch(error => {
                    console.error('Error loading pending loans:', error);
                    document.getElementById('pendingLoansContainer').innerHTML = 
                        "<div class='alert alert-danger'>Error loading your pending applications. Please try again later.</div>";
                });

            // Load closed loans
            fetch('loan?action=getUserLoans&status=CLOSED')
                .then(response => {
                    console.log('Closed Loans Response:', response);
                    return response.json();
                })
                .then(data => {
                    console.log('Closed Loans Data:', data);
                    renderLoans(data, 'closedLoansContainer');
                })
                .catch(error => {
                    console.error('Error loading closed loans:', error);
                    document.getElementById('closedLoansContainer').innerHTML = 
                        "<div class='alert alert-danger'>Error loading your closed loans. Please try again later.</div>";
                });
        }

        function renderLoans(loans, containerId) {
            const container = document.getElementById(containerId);
            if (loans.length === 0) {
                container.innerHTML = "<p class='text-center text-muted'>No loans found.</p>";
                return;
            }

            container.innerHTML = '';
            loans.forEach(loan => {
                const loanCard = document.createElement('div');
                loanCard.className = 'card loan-card mb-3';
                loanCard.innerHTML = 
                    "<div class='card-body'>" +
                        "<h5 class='card-title'>Loan #" + loan.id + "</h5>" +
                        "<p class='card-text'>Amount: ₹" + (loan.amount || 0).toLocaleString() + "</p>" +
                        "<p class='card-text'>Remaining: ₹" + (loan.remainingAmount || 0).toLocaleString() + "</p>" +
                        "<p class='card-text'>Monthly Payment: ₹" + (loan.monthlyPayment || 0).toLocaleString() + "</p>" +
                        "<p class='card-text'>Next Payment Date: " + (loan.nextPaymentDate ? new Date(loan.nextPaymentDate).toLocaleDateString() : "N/A") + "</p>" +
                        "<button class='btn btn-primary' data-bs-toggle='modal' data-bs-target='#paymentModal' onclick='openPaymentModal(" + loan.id + ", " + (loan.monthlyPayment || 0) + ")'>Make Payment</button>" +
                    "</div>";
                container.appendChild(loanCard);
            });
        }

        function renderPendingLoans(loans, containerId) {
            const container = document.getElementById(containerId);
            if (loans.length === 0) {
                container.innerHTML = "<p class='text-center text-muted'>No pending applications found.</p>";
                return;
            }

            container.innerHTML = '';
            loans.forEach(loan => {
                const loanCard = document.createElement('div');
                loanCard.className = 'card loan-card mb-3';
                loanCard.innerHTML = 
                    "<div class='card-body'>" +
                        "<h5 class='card-title'>Loan Application #" + loan.id + "</h5>" +
                        "<p class='card-text'>Amount: ₹" + (loan.amount || 0).toLocaleString() + "</p>" +
                        "<p class='card-text'>Status: " + loan.status + "</p>" +
                        "<p class='card-text'>Submitted On: " + (loan.submittedDate ? new Date(loan.submittedDate).toLocaleDateString() : "N/A") + "</p>" +
                    "</div>";
                container.appendChild(loanCard);
            });
        }

        function openPaymentModal(loanId, monthlyPayment) {
            document.getElementById('paymentLoanId').value = loanId;
            document.getElementById('paymentAmount').value = monthlyPayment;
            document.getElementById('monthlyDue').textContent = monthlyPayment.toLocaleString();
        }
    </script>
</body>
</html>