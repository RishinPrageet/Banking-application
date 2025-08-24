<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apply for Loan - Banking System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
        .loan-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border-radius: 10px 10px 0 0;
        }
        .loan-details-card {
            border-radius: 10px;
            overflow: hidden;
        }
        .form-control:focus, .form-select:focus {
            border-color: #28a745;
            box-shadow: 0 0 0 0.25rem rgba(40, 167, 69, 0.25);
        }
        .calculation-box {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
        }
        .progress-container {
            margin: 30px 0;
        }
        .progress {
            height: 8px;
            background-color: #e9ecef;
        }
        .progress-step {
            position: relative;
            text-align: center;
            padding-top: 20px;
        }
        .progress-step::before {
            content: '';
            position: absolute;
            top: -14px;
            left: 50%;
            transform: translateX(-50%);
            width: 20px;
            height: 20px;
            background-color: #fff;
            border: 2px solid #28a745;
            border-radius: 50%;
            z-index: 2;
        }
        .progress-step.active::before {
            background-color: #28a745;
        }
        .progress-step.completed::before {
            background-color: #28a745;
        }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <!-- Progress Bar -->
                <div class="progress-container">
                    <div class="progress">
                        <div class="progress-bar bg-success" role="progressbar" style="width: 33%;" aria-valuenow="33" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                    <div class="row mt-2">
                        <div class="col-4 progress-step active">
                            <small>Application</small>
                        </div>
                        <div class="col-4 progress-step">
                            <small>Verification</small>
                        </div>
                        <div class="col-4 progress-step">
                            <small>Approval</small>
                        </div>
                    </div>
                </div>
                
                <div class="card shadow border-0 loan-details-card">
                    <div class="loan-header p-4">
                        <h2 class="mb-0">Loan Application</h2>
                        <p class="mb-0 opacity-75">Complete your application details</p>
                    </div>
                    
                    <div class="card-body p-4">
                        <div id="loanDetailsContainer" class="mb-4">
                            <div class="d-flex justify-content-center">
                                <div class="spinner-border text-success" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                            </div>
                        </div>
                        
                        <form id="loanApplicationForm" class="mt-4">
                            <input type="hidden" id="loanId" name="loanId">
                            
                            <div class="row mb-4">
                                <div class="col-md-6 mb-3">
                                    <label for="loanAmount" class="form-label">Loan Amount (₹)</label>
                                    <div class="input-group">
                                        <span class="input-group-text">₹</span>
                                        <input type="number" class="form-control" id="loanAmount" name="loanAmount" required>
                                    </div>
                                    <div id="maxAmountHelp" class="form-text">Maximum amount allowed: ₹<span id="maxAmountValue">0</span></div>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="durationMonths" class="form-label">Duration</label>
                                    <select class="form-select" id="durationMonths" name="durationMonths" required>
                                        <!-- Options will be populated based on loan type -->
                                    </select>
                                </div>
                            </div>
                            
                            <div class="calculation-box mb-4">
                                <h5 class="mb-3">Loan Calculation</h5>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="interestRate" class="form-label">Interest Rate</label>
                                        <div class="input-group">
                                            <input type="text" class="form-control" id="interestRate" readonly>
                                            <span class="input-group-text">%</span>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="processingFee" class="form-label">Processing Fee</label>
                                        <div class="input-group">
                                            <span class="input-group-text">₹</span>
                                            <input type="text" class="form-control" id="processingFee" readonly>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="monthlyPayment" class="form-label">Monthly Payment</label>
                                        <div class="input-group">
                                            <span class="input-group-text">₹</span>
                                            <input type="text" class="form-control" id="monthlyPayment" readonly>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="totalRepayment" class="form-label">Total Repayment</label>
                                        <div class="input-group">
                                            <span class="input-group-text">₹</span>
                                            <input type="text" class="form-control" id="totalRepayment" readonly>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="mb-4">
                                <h5>Terms and Conditions</h5>
                                <div class="card">
                                    <div class="card-body bg-light" style="max-height: 150px; overflow-y: auto;">
                                        <small>
                                            <p>By submitting this application, you agree to the following terms:</p>
                                            <ol>
                                                <li>All information provided is accurate and complete.</li>
                                                <li>You authorize the bank to verify your credit history and employment details.</li>
                                                <li>The bank reserves the right to approve or reject the application based on its policies.</li>
                                                <li>Interest rates and terms are subject to change based on final verification.</li>
                                                <li>Processing fees are non-refundable once the application is submitted.</li>
                                                <li>Early repayment may be subject to additional charges as per bank policy.</li>
                                            </ol>
                                        </small>
                                    </div>
                                </div>
                                <div class="form-check mt-2">
                                    <input class="form-check-input" type="checkbox" id="termsAgreement" required>
                                    <label class="form-check-label" for="termsAgreement">
                                        I have read and agree to the terms and conditions
                                    </label>
                                </div>
                            </div>
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-success btn-lg">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check-circle me-2" viewBox="0 0 16 16">
                                        <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                                        <path d="M10.97 4.97a.235.235 0 0 0-.02.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-1.071-1.05z"/>
                                    </svg>
                                    Submit Application
                                </button>
                            </div>
                        </form>
                        
                        <div id="applicationResult" class="mt-4"></div>
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
            // Get loan ID from URL parameter
            const urlParams = new URLSearchParams(window.location.search);
            const loanId = urlParams.get('id');
            
            if (!loanId) {
                document.getElementById('loanDetailsContainer').innerHTML = 
                    '<div class="alert alert-danger">' +
                    '<div class="d-flex align-items-center">' +
                    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-exclamation-triangle-fill me-3" viewBox="0 0 16 16">' +
                    '<path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>' +
                    '</svg>' +
                    '<div>' +
                    '<h4 class="alert-heading">Loan ID Missing</h4>' +
                    '<p class="mb-0">Please select a loan from the eligibility page first.</p>' +
                    '</div>' +
                    '</div>' +
                    '<div class="mt-3">' +
                    '<a href="loan-eligibility.jsp" class="btn btn-primary">Check Loan Eligibility</a>' +
                    '</div>' +
                    '</div>';
                document.getElementById('loanApplicationForm').style.display = 'none';
                return;
            }
            
            document.getElementById('loanId').value = loanId;
            
            // Fetch loan details
            fetch("loan?action=viewDetails&id=" + loanId)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Failed to fetch loan details');
                    }
                    return response.json();
                })
                .then(loan => {
                    // Display loan details
                    let detailsHtml = `
                        <div class="card bg-light">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h4 class="card-title mb-0">` + loan.loanType + `</h4>
                                    <span class="badge bg-success">Available</span>
                                </div>
                                <div class="row">
                                    <div class="col-md-4 mb-2">
                                        <small class="text-muted">Interest Rate</small>
                                        <p class="mb-0 fw-bold">` + loan.interestRate + `%</p>
                                    </div>
                                    <div class="col-md-4 mb-2">
                                        <small class="text-muted">Maximum Amount</small>
                                        <p class="mb-0 fw-bold">₹` + loan.maxAmount.toLocaleString() + `</p>
                                    </div>
                                    <div class="col-md-4 mb-2">
                                        <small class="text-muted">Maximum Duration</small>
                                        <p class="mb-0 fw-bold">` + loan.durationMonths + ` months</p>
                                    </div>
                                </div>
                                <hr>
                                <small class="text-muted">` + loan.eligibilityCriteria + `</small>
                            </div>
                        </div>
                    `;
                    document.getElementById('loanDetailsContainer').innerHTML = detailsHtml;
                    document.getElementById('maxAmountValue').textContent = loan.maxAmount.toLocaleString();
                    document.getElementById('interestRate').value = loan.interestRate;
                    
                    // Set max amount for the input
                    document.getElementById('loanAmount').max = loan.maxAmount;
                    document.getElementById('loanAmount').placeholder = "Up to ₹" + loan.maxAmount.toLocaleString();
                    
                    // Populate duration options
                    const durationSelect = document.getElementById('durationMonths');
                    durationSelect.innerHTML = '';
                    
                    // Add options based on loan type
                    const durationOptions = [12, 24, 36, 48, 60, 72, 84, 96, 120, 180, 240];
                    durationOptions.forEach(months => {
                        if (months <= loan.durationMonths) {
                            const option = document.createElement('option');
                            option.value = months;
                            option.textContent = months + " months (" + (months / 12) + " year" + (months > 12 ? "s" : "") + ")";
                            durationSelect.appendChild(option);
                        }
                    });
                    
                    // Store loan interest rate for calculation
                    window.loanInterestRate = loan.interestRate;
                    
                    // Calculate initial payment estimate
                    calculatePayment();
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('loanDetailsContainer').innerHTML = 
                        `<div class="alert alert-danger">
                            <div class="d-flex align-items-center">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-exclamation-circle-fill me-3" viewBox="0 0 16 16">
                                    <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM8 4a.905.905 0 0 0-.9.995l.35 3.507a.552.552 0 0 0 1.1 0l.35-3.507A.905.905 0 0 0 8 4zm.002 6a1 1 0 1 0 0 2 1 1 0 0 0 0-2z"/>
                                </svg>
                                <div>
                                    <h4 class="alert-heading">Error Loading Loan Details</h4>
                                    <p class="mb-0">` + error.message + `</p>
                                </div>
                            </div>
                            <div class="mt-3">
                                <a href="loan-eligibility.jsp" class="btn btn-primary">Return to Eligibility Check</a>
                            </div>
                        </div>`;
                });
            
            // Add event listeners for calculation
            document.getElementById('loanAmount').addEventListener('input', calculatePayment);
            document.getElementById('durationMonths').addEventListener('change', calculatePayment);
            
            // Handle form submission
            document.getElementById('loanApplicationForm').addEventListener('submit', function(e) {
                e.preventDefault();
                
                if (!document.getElementById('termsAgreement').checked) {
                    alert("Please agree to the terms and conditions to proceed.");
                    return;
                }
                
                const loanId = document.getElementById('loanId').value;
                const loanAmount = document.getElementById('loanAmount').value;
                const durationMonths = document.getElementById('durationMonths').value;
                
                // Show loading state
                const submitButton = this.querySelector('button[type="submit"]');
                const originalButtonText = submitButton.innerHTML;
                submitButton.disabled = true;
                submitButton.innerHTML = `
                    <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
                    Processing...
                `;
                
                // Submit loan application
                const formData = new URLSearchParams();
                formData.append('action', 'apply');
                formData.append('loanId', loanId);
                formData.append('loanAmount', loanAmount);
                formData.append('durationMonths', durationMonths);
                
                fetch('loan', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: formData
                })
                .then(response => response.text())
                .then(result => {
                    const resultDiv = document.getElementById('applicationResult');
                    if (result.includes('successfully')) {
                        // Update progress bar
                        document.querySelector('.progress-bar').style.width = '66%';
                        document.querySelector('.progress-bar').setAttribute('aria-valuenow', '66');
                        document.querySelectorAll('.progress-step')[0].classList.add('completed');
                        document.querySelectorAll('.progress-step')[1].classList.add('active');
                        
                        resultDiv.innerHTML = `
                            <div class="alert alert-success">
                                <div class="text-center mb-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" fill="currentColor" class="bi bi-check-circle" viewBox="0 0 16 16">
                                        <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                                        <path d="M10.97 4.97a.235.235 0 0 0-.02.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-1.071-1.05z"/>
                                    </svg>
                                </div>
                                <h4 class="alert-heading text-center">Application Submitted Successfully!</h4>
                                <p>` + result + `</p>
                                <p>Our team will review your application and contact you shortly. You can check the status of your application in your dashboard.</p>
                                <div class="d-flex justify-content-center mt-3">
                                    <a href="user-dashboard.jsp" class="btn btn-primary">Go to Dashboard</a>
                                </div>
                            </div>
                        `;
                        document.getElementById('loanApplicationForm').style.display = 'none';
                    } else {
                        resultDiv.innerHTML = `
                            <div class="alert alert-danger">
                                <div class="d-flex align-items-center">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-exclamation-circle-fill me-3" viewBox="0 0 16 16">
                                        <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM8 4a.905.905 0 0 0-.9.995l.35 3.507a.552.552 0 0 0 1.1 0l.35-3.507A.905.905 0 0 0 8 4zm.002 6a1 1 0 1 0 0 2 1 1 0 0 0 0-2z"/>
                                    </svg>
                                    <div>
                                        <h4 class="alert-heading">Application Failed</h4>
                                        <p class="mb-0">` + result + `</p>
                                    </div>
                                </div>
                            </div>
                        `;
                        
                        // Reset button
                        submitButton.disabled = false;
                        submitButton.innerHTML = originalButtonText;
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('applicationResult').innerHTML = `
                        <div class="alert alert-danger">
                            <div class="d-flex align-items-center">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-exclamation-circle-fill me-3" viewBox="0 0 16 16">
                                    <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM8 4a.905.905 0 0 0-.9.995l.35 3.507a.552.552 0 0 0 1.1 0l.35-3.507A.905.905 0 0 0 8 4zm.002 6a1 1 0 1 0 0 2 1 1 0 0 0 0-2z"/>
                                </svg>
                                <div>
                                    <h4 class="alert-heading">Error</h4>
                                    <p class="mb-0">` + error.message + `</p>
                                </div>
                            </div>
                        </div>
                    `;
                    
                    // Reset button
                    submitButton.disabled = false;
                    submitButton.innerHTML = originalButtonText;
                });
            });
        });
        
        function calculatePayment() {
            const loanAmount = parseFloat(document.getElementById('loanAmount').value) || 0;
            const durationMonths = parseInt(document.getElementById('durationMonths').value) || 12;
            const interestRate = window.loanInterestRate || 0;
            
            if (loanAmount > 0 && durationMonths > 0) {
                // Calculate monthly interest rate
                const monthlyInterestRate = interestRate / 12 / 100;
                
                // Calculate monthly payment using formula: P = (r * PV) / (1 - (1 + r)^-n)
                // Where P = payment, r = monthly interest rate, PV = loan amount, n = duration in months
                const monthlyPayment = (monthlyInterestRate * loanAmount) / (1 - Math.pow(1 + monthlyInterestRate, -durationMonths));
                
                // Calculate total repayment
                const totalRepayment = monthlyPayment * durationMonths;
                
                // Calculate processing fee (typically 1% of loan amount)
                const processingFee = loanAmount * 0.01;
                
                document.getElementById('monthlyPayment').value = monthlyPayment.toLocaleString(undefined, {maximumFractionDigits: 2});
                document.getElementById('totalRepayment').value = totalRepayment.toLocaleString(undefined, {maximumFractionDigits: 2});
                document.getElementById('processingFee').value = processingFee.toLocaleString(undefined, {maximumFractionDigits: 2});
            } else {
                document.getElementById('monthlyPayment').value = '';
                document.getElementById('totalRepayment').value = '';
                document.getElementById('processingFee').value = '';
            }
        }
    </script>
</body>
</html>
