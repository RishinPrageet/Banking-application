<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Loans - Banking System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../includes/header.jsp" />

    <div class="container my-5">
        <div class="row justify-content-between align-items-center mb-4">
            <div class="col-auto">
                <h1 class="text-primary">Loan Management</h1>
            </div>
            <div class="col-auto">
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addLoanModal">
                    <i class="bi bi-plus-circle me-2"></i> Add New Loan Type
                </button>
            </div>
        </div>

        <!-- Loan Types Table -->
        <div class="card shadow mb-4">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">Available Loan Types</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Loan Type</th>
                                <th>Interest Rate (%)</th>
                                <th>Maximum Amount (₹)</th>
                                <th>Duration (months)</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="loanTypesTableBody">
                            <tr>
                                <td colspan="6" class="text-center">Loading loan types...</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Loan Applications -->
        <div class="card shadow">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">Loan Applications</h5>
            </div>
            <div class="card-body">
                <ul class="nav nav-tabs mb-3" id="loanApplicationTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="pending-tab" data-bs-toggle="tab" data-bs-target="#pending" type="button" role="tab">Pending</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="approved-tab" data-bs-toggle="tab" data-bs-target="#approved" type="button" role="tab">Approved</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="rejected-tab" data-bs-toggle="tab" data-bs-target="#rejected" type="button" role="tab">Rejected</button>
                    </li>
                </ul>
                <div class="tab-content" id="loanApplicationTabContent">
                    <div class="tab-pane fade show active" id="pending" role="tabpanel">
                        <div id="pendingApplicationsContainer">
                            <p class="text-center">Loading pending applications...</p>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="approved" role="tabpanel">
                        <div id="approvedApplicationsContainer">
                            <p class="text-center">Loading approved applications...</p>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="rejected" role="tabpanel">
                        <div id="rejectedApplicationsContainer">
                            <p class="text-center">Loading rejected applications...</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Loan Modal -->
    <div class="modal fade" id="addLoanModal" tabindex="-1" aria-labelledby="addLoanModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="addLoanModalLabel">Add New Loan Type</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="addLoanForm">
                        <div class="mb-3">
                            <label for="loanType" class="form-label">Loan Type</label>
                            <input type="text" class="form-control" id="loanType" name="loanType" required>
                        </div>
                        <div class="mb-3">
                            <label for="interestRate" class="form-label">Interest Rate (%)</label>
                            <input type="number" class="form-control" id="interestRate" name="interestRate" step="0.01" min="0" max="30" required>
                        </div>
                        <div class="mb-3">
                            <label for="maxAmount" class="form-label">Maximum Amount (₹)</label>
                            <input type="number" class="form-control" id="maxAmount" name="maxAmount" min="0" required>
                        </div>
                        <div class="mb-3">
                            <label for="durationMonths" class="form-label">Maximum Duration (months)</label>
                            <input type="number" class="form-control" id="durationMonths" name="durationMonths" min="1" max="360" required>
                        </div>
                        <div class="mb-3">
                            <label for="eligibilityCriteria" class="form-label">Eligibility Criteria</label>
                            <textarea class="form-control" id="eligibilityCriteria" name="eligibilityCriteria" rows="3" required></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="saveLoanBtn">Save</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Loan Modal -->
    <div class="modal fade" id="editLoanModal" tabindex="-1" aria-labelledby="editLoanModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="editLoanModalLabel">Edit Loan Type</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editLoanForm">
                        <input type="hidden" id="editLoanId" name="id">
                        <div class="mb-3">
                            <label for="editLoanType" class="form-label">Loan Type</label>
                            <input type="text" class="form-control" id="editLoanType" name="loanType" required>
                        </div>
                        <div class="mb-3">
                            <label for="editInterestRate" class="form-label">Interest Rate (%)</label>
                            <input type="number" class="form-control" id="editInterestRate" name="interestRate" step="0.01" min="0" max="30" required>
                        </div>
                        <div class="mb-3">
                            <label for="editMaxAmount" class="form-label">Maximum Amount (₹)</label>
                            <input type="number" class="form-control" id="editMaxAmount" name="maxAmount" min="0" required>
                        </div>
                        <div class="mb-3">
                            <label for="editDurationMonths" class="form-label">Maximum Duration (months)</label>
                            <input type="number" class="form-control" id="editDurationMonths" name="durationMonths" min="1" max="360" required>
                        </div>
                        <div class="mb-3">
                            <label for="editEligibilityCriteria" class="form-label">Eligibility Criteria</label>
                            <textarea class="form-control" id="editEligibilityCriteria" name="eligibilityCriteria" rows="3" required></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="updateLoanBtn">Update</button>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../includes/footer.jsp" />

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Load loan types
        function loadLoanTypes() {
            fetch('../loan?action=viewAll')
                .then(response => response.json())
                .then(data => {
                    const tableBody = document.getElementById('loanTypesTableBody');
                    
                    if (data.length === 0) {
                        tableBody.innerHTML = '<tr><td colspan="6" class="text-center">No loan types found</td></tr>';
                        return;
                    }
                    
                    let tableContent = '';
                    data.forEach(loan => {
                        tableContent += `
                            <tr>
                                <td>${loan.id}</td>
                                <td>${loan.loanType}</td>
                                <td>${loan.interestRate}%</td>
                                <td>₹${loan.maxAmount.toLocaleString()}</td>
                                <td>${loan.durationMonths}</td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary me-1" onclick="editLoan(${loan.id})">Edit</button>
                                    <button class="btn btn-sm btn-outline-danger" onclick="deleteLoan(${loan.id})">Delete</button>
                                </td>
                            </tr>
                        `;
                    });
                    
                    tableBody.innerHTML = tableContent;
                })
                .catch(error => {
                    console.error('Error loading loan types:', error);
                    document.getElementById('loanTypesTableBody').innerHTML = 
                        '<tr><td colspan="6" class="text-center text-danger">Error loading loan types</td></tr>';
                });
        }
        
        // Function to edit loan
        function editLoan(loanId) {
            fetch(`../loan?action=viewDetails&id=${loanId}`)
                .then(response => response.json())
                .then(loan => {
                    document.getElementById('editLoanId').value = loan.id;
                    document.getElementById('editLoanType').value = loan.loanType;
                    document.getElementById('editInterestRate').value = loan.interestRate;
                    document.getElementById('editMaxAmount').value = loan.maxAmount;
                    document.getElementById('editDurationMonths').value = loan.durationMonths;
                    document.getElementById('editEligibilityCriteria').value = loan.eligibilityCriteria;
                    
                    // Show the edit modal
                    new bootstrap.Modal(document.getElementById('editLoanModal')).show();
                })
                .catch(error => {
                    console.error('Error fetching loan details:', error);
                    alert('Failed to load loan details. Please try again.');
                });
        }
        
        // Function to delete loan
        function deleteLoan(loanId) {
            if (confirm('Are you sure you want to delete this loan type? This action cannot be undone.')) {
                fetch(`../loan?action=delete&id=${loanId}`, {
                    method: 'POST'
                })
                .then(response => response.text())
                .then(result => {
                    alert(result);
                    loadLoanTypes(); // Reload the table
                })
                .catch(error => {
                    console.error('Error deleting loan:', error);
                    alert('Failed to delete loan. Please try again.');
                });
            }
        }
        
        // Load loan applications by status
        function loadLoanApplications() {
            // Load pending applications
            fetch('../loan?action=getLoanApplicationsByStatus&status=PENDING')
                .then(response => response.json())
                .then(data => {
                    const container = document.getElementById('pendingApplicationsContainer');
                    if (data.length === 0) {
                        container.innerHTML = '<div class="alert alert-info">No pending loan applications</div>';
                        return;
                    }
                    
                    renderApplications(data, container, 'PENDING');
                })
                .catch(error => {
                    console.error('Error loading pending applications:', error);
                    document.getElementById('pendingApplicationsContainer').innerHTML = 
                        '<div class="alert alert-danger">Error loading pending applications</div>';
                });
            
            // Load approved applications
            fetch('../loan?action=getLoanApplicationsByStatus&status=APPROVED')
                .then(response => response.json())
                .then(data => {
                    const container = document.getElementById('approvedApplicationsContainer');
                    if (data.length === 0) {
                        container.innerHTML = '<div class="alert alert-info">No approved loan applications</div>';
                        return;
                    }
                    
                    renderApplications(data, container, 'APPROVED');
                })
                .catch(error => {
                    console.error('Error loading approved applications:', error);
                    document.getElementById('approvedApplicationsContainer').innerHTML = 
                        '<div class="alert alert-danger">Error loading approved applications</div>';
                });
            
            // Load rejected applications
            fetch('../loan?action=getLoanApplicationsByStatus&status=REJECTED')
                .then(response => response.json())
                .then(data => {
                    const container = document.getElementById('rejectedApplicationsContainer');
                    if (data.length === 0) {
                        container.innerHTML = '<div class="alert alert-info">No rejected loan applications</div>';
                        return;
                    }
                    
                    renderApplications(data, container, 'REJECTED');
                })
                .catch(error => {
                    console.error('Error loading rejected applications:', error);
                    document.getElementById('rejectedApplicationsContainer').innerHTML = 
                        '<div class="alert alert-danger">Error loading rejected applications</div>';
                });
        }
        
        // Render loan applications
        function renderApplications(applications, container, status) {
            let html = `
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>User</th>
                                <th>Loan Type</th>
                                <th>Amount</th>
                                <th>Duration</th>
                                <th>Applied Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
            `;
            
            applications.forEach(app => {
                html += `
                    <tr>
                        <td>${app.id}</td>
                        <td>${app.userName}</td>
                        <td>${app.loanType}</td>
                        <td>₹${app.amount.toLocaleString()}</td>
                        <td>${app.durationMonths} months</td>
                        <td>${new Date(app.startDate).toLocaleDateString()}</td>
                        <td>
                `;
                
                if (status === 'PENDING') {
                    html += `
                        <button class="btn btn-sm btn-success me-1" onclick="updateApplicationStatus(${app.id}, 'APPROVED')">Approve</button>
                        <button class="btn btn-sm btn-danger" onclick="updateApplicationStatus(${app.id}, 'REJECTED')">Reject</button>
                    `;
                } else {
                    html += `<span class="badge ${status === 'APPROVED' ? 'bg-success' : 'bg-danger'}">${status}</span>`;
                }
                
                html += `
                        </td>
                    </tr>
                `;
            });
            
            html += `
                        </tbody>
                    </table>
                </div>
            `;
            
            container.innerHTML = html;
        }
        
        // Update application status
        function updateApplicationStatus(appId, status) {
            fetch('../loan?action=updateStatus', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: `userLoanId=${appId}&status=${status}`
            })
            .then(response => response.text())
            .then(result => {
                alert(result);
                loadLoanApplications(); // Reload applications
            })
            .catch(error => {
                console.error('Error updating application status:', error);
                alert('Failed to update application status. Please try again.');
            });
        }
        
        // Document ready
        document.addEventListener('DOMContentLoaded', function() {
            // Check if user is admin
            fetch('../account?action=checkAdmin')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Not authorized');
                    }
                    return response.text();
                })
                .then(() => {
                    // User is admin, load data
                    loadLoanTypes();
                    loadLoanApplications();
                })
                .catch(error => {
                    console.error('Authorization error:', error);
                    document.body.innerHTML = `
                        <div class="container mt-5">
                            <div class="alert alert-danger">
                                <h4>Access Denied</h4>
                                <p>You are not authorized to access this page.</p>
                                <a href="../index.jsp" class="btn btn-primary">Go to Home</a>
                            </div>
                        </div>
                    `;
                });
            
            // Add loan form submission
            document.getElementById('saveLoanBtn').addEventListener('click', function() {
                const form = document.getElementById('addLoanForm');
                
                if (!form.checkValidity()) {
                    form.reportValidity();
                    return;
                }
                
                const formData = new URLSearchParams();
                formData.append('action', 'create');
                formData.append('loanType', document.getElementById('loanType').value);
                formData.append('interestRate', document.getElementById('interestRate').value);
                formData.append('maxAmount', document.getElementById('maxAmount').value);
                formData.append('durationMonths', document.getElementById('durationMonths').value);
                formData.append('eligibilityCriteria', document.getElementById('eligibilityCriteria').value);
                
                fetch('../loan', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: formData
                })
                .then(response => response.text())
                .then(result => {
                    alert(result);
                    form.reset();
                    bootstrap.Modal.getInstance(document.getElementById('addLoanModal')).hide();
                    loadLoanTypes(); // Reload the table
                })
                .catch(error => {
                    console.error('Error creating loan:', error);
                    alert('Failed to create loan. Please try again.');
                });
            });
            
            // Edit loan form submission
            document.getElementById('updateLoanBtn').addEventListener('click', function() {
                const form = document.getElementById('editLoanForm');
                
                if (!form.checkValidity()) {
                    form.reportValidity();
                    return;
                }
                
                const formData = new URLSearchParams();
                formData.append('action', 'update');
                formData.append('id', document.getElementById('editLoanId').value);
                formData.append('loanType', document.getElementById('editLoanType').value);
                formData.append('interestRate', document.getElementById('editInterestRate').value);
                formData.append('maxAmount', document.getElementById('editMaxAmount').value);
                formData.append('durationMonths', document.getElementById('editDurationMonths').value);
                formData.append('eligibilityCriteria', document.getElementById('editEligibilityCriteria').value);
                
                fetch('../loan', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: formData
                })
                .then(response => response.text())
                .then(result => {
                    alert(result);
                    bootstrap.Modal.getInstance(document.getElementById('editLoanModal')).hide();
                    loadLoanTypes(); // Reload the table
                })
                .catch(error => {
                    console.error('Error updating loan:', error);
                    alert('Failed to update loan. Please try again.');
                });
            });
        });
    </script>
</body>
</html>
