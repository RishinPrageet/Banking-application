<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Check Loan Eligibility - Banking System</title>
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
        .form-section {
            background-color: #f8f9fa;
            border-radius: 10px;
        }
        .results-section {
            min-height: 200px;
        }
        .eligibility-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border-radius: 10px 10px 0 0;
        }
        .loan-type-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            font-size: 0.8rem;
        }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />

    <div class="container my-5">
        <div class="row">
            <div class="col-12 mb-4">
                <div class="card shadow border-0">
                    <div class="card-body p-0">
                        <div class="eligibility-header p-4">
                            <h2 class="mb-0">Loan Eligibility Check</h2>
                            <p class="mb-0 opacity-75">Find the perfect loan for your needs</p>
                        </div>
                        <div class="p-4 form-section">
                            <form id="loanEligibilityForm" class="row g-3">
                                <div class="col-md-6">
                                    <label for="income" class="form-label">Monthly Income (₹)</label>
                                    <div class="input-group">
                                        <span class="input-group-text">₹</span>
                                        <input type="number" class="form-control" id="income" name="income" placeholder="Enter your monthly income" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="age" class="form-label">Age</label>
                                    <input type="number" class="form-control" id="age" name="age" placeholder="Enter your age" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="employment" class="form-label">Employment Type</label>
                                    <select class="form-select" id="employment" name="employment" required>
                                        <option value="" selected disabled>Select employment type</option>
                                        <option value="Salaried">Salaried</option>
                                        <option value="Self-employed">Self-employed</option>
                                        <option value="Student">Student</option>
                                        <option value="Farmer">Farmer</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="businessVintage" class="form-label">Years in Business/Employment</label>
                                    <input type="number" class="form-control" id="businessVintage" name="businessVintage" placeholder="Enter years of experience" value="0">
                                </div>
                                
                                <div class="col-12">
                                    <hr class="my-3">
                                    <h5>Additional Information</h5>
                                </div>
                                
                                <div class="col-md-4">
                                    <label for="hasGold" class="form-label">Do you have gold for collateral?</label>
                                    <select class="form-select" id="hasGold" name="hasGold" required>
                                        <option value="yes">Yes</option>
                                        <option value="no" selected>No</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label for="hasProperty" class="form-label">Do you own property?</label>
                                    <select class="form-select" id="hasProperty" name="hasProperty" required>
                                        <option value="yes">Yes</option>
                                        <option value="no" selected>No</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label for="hasAdmission" class="form-label">Have admission to an institution?</label>
                                    <select class="form-select" id="hasAdmission" name="hasAdmission" required>
                                        <option value="yes">Yes</option>
                                        <option value="no" selected>No</option>
                                    </select>
                                </div>
                                
                                <div class="col-md-6">
                                    <label for="turnover" class="form-label">Annual Business Turnover (₹)</label>
                                    <div class="input-group">
                                        <span class="input-group-text">₹</span>
                                        <input type="number" class="form-control" id="turnover" name="turnover" placeholder="For business loans" value="0">
                                    </div>
                                </div>
                                
                                <div class="col-12 text-center mt-4">
                                    <button type="submit" class="btn btn-success btn-lg px-5">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-search me-2" viewBox="0 0 16 16">
                                            <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/>
                                        </svg>
                                        Check Eligible Loans
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-12 results-section">
                <div id="loanResults"></div>
            </div>
        </div>
    </div>

    <jsp:include page="includes/footer.jsp" />

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        document.getElementById('loanEligibilityForm').addEventListener('submit', function(e) {
            e.preventDefault();

            const formData = {
                income: parseInt(document.getElementById('income').value),
                age: parseInt(document.getElementById('age').value),
                employment: document.getElementById('employment').value,
                hasGold: document.getElementById('hasGold').value === 'yes',
                hasProperty: document.getElementById('hasProperty').value === 'yes',
                hasAdmission: document.getElementById('hasAdmission').value === 'yes',
                businessVintage: parseInt(document.getElementById('businessVintage').value),
                turnover: parseInt(document.getElementById('turnover').value)
            };

            // Show loading indicator
            const resultDiv = document.getElementById("loanResults");
            resultDiv.innerHTML = 
                "<div class='text-center my-5'>" +
                    "<div class='spinner-border text-success' role='status' style='width: 3rem; height: 3rem;'>" +
                        "<span class='visually-hidden'>Loading...</span>" +
                    "</div>" +
                    "<p class='mt-3 fs-5'>Analyzing your profile and checking eligible loans...</p>" +
                "</div>";

            fetch("loan?action=checkEligibility", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(formData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.length === 0) {
                    resultDiv.innerHTML = 
                        "<div class='alert alert-warning shadow-sm'>" +
                            "<div class='d-flex align-items-center'>" +
                                "<svg xmlns='http://www.w3.org/2000/svg' width='24' height='24' fill='currentColor' class='bi bi-exclamation-triangle-fill me-3' viewBox='0 0 16 16'>" +
                                    "<path d='M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z'/>" +
                                "</svg>" +
                                "<div>" +
                                    "<h4 class='alert-heading'>No Eligible Loans Found</h4>" +
                                    "<p class='mb-0'>Based on the information provided, we couldn't find any eligible loans for you at this time. Try adjusting your criteria or contact our support team for assistance.</p>" +
                                "</div>" +
                            "</div>" +
                        "</div>";
                } else {
                    let html = 
                        "<div class='mb-4'>" +
                            "<h3 class='text-success'>" +
                                "<svg xmlns='http://www.w3.org/2000/svg' width='24' height='24' fill='currentColor' class='bi bi-check-circle-fill me-2' viewBox='0 0 16 16'>" +
                                    "<path d='M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z'/>" +
                                "</svg>" +
                                "Good News! You're eligible for " + data.length + " loan option" + (data.length > 1 ? "s" : "") +
                            "</h3>" +
                            "<p class='text-muted'>Based on your profile, we've found the following loan options for you:</p>" +
                        "</div>" +
                        "<div class='row'>";

                    data.forEach(function(loan) {
                        // Determine card color based on loan type
                        let cardColor = "success";
                        let badgeClass = "bg-success";
                        
                        if (loan.loanType.includes("Home") || loan.loanType.includes("Property")) {
                            cardColor = "primary";
                            badgeClass = "bg-primary";
                        } else if (loan.loanType.includes("Education")) {
                            cardColor = "info";
                            badgeClass = "bg-info";
                        } else if (loan.loanType.includes("Business")) {
                            cardColor = "warning";
                            badgeClass = "bg-warning text-dark";
                        } else if (loan.loanType.includes("Gold")) {
                            cardColor = "warning";
                            badgeClass = "bg-warning text-dark";
                        } else if (loan.loanType.includes("Personal")) {
                            cardColor = "danger";
                            badgeClass = "bg-danger";
                        }

                        html += 
                            "<div class='col-md-6 col-lg-4 mb-4'>" +
                                "<div class='card h-100 border-" + cardColor + " shadow-sm loan-card'>" +
                                    "<span class='badge " + badgeClass + " loan-type-badge'>" + loan.loanType + "</span>" +
                                    "<div class='card-body'>" +
                                        "<h5 class='card-title text-" + cardColor + "'>" + loan.loanType + "</h5>" +
                                        "<div class='mb-3'>" +
                                            "<div class='d-flex justify-content-between align-items-center mb-2'>" +
                                                "<span>Interest Rate:</span>" +
                                                "<span class='fw-bold'>" + loan.interestRate + "%</span>" +
                                            "</div>" +
                                            "<div class='d-flex justify-content-between align-items-center mb-2'>" +
                                                "<span>Maximum Amount:</span>" +
                                                "<span class='fw-bold'>₹" + loan.maxAmount.toLocaleString() + "</span>" +
                                            "</div>" +
                                            "<div class='d-flex justify-content-between align-items-center'>" +
                                                "<span>Duration:</span>" +
                                                "<span class='fw-bold'>" + loan.durationMonths + " months</span>" +
                                            "</div>" +
                                        "</div>" +
                                        "<p class='card-text small text-muted'>" + loan.eligibilityCriteria + "</p>" +
                                    "</div>" +
                                    "<div class='card-footer bg-transparent border-top-0'>" +
                                        "<a href='apply-loan.jsp?id=" + loan.id + "' class='btn btn-" + cardColor + " w-100'>" +
                                            "<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='currentColor' class='bi bi-arrow-right-circle me-2' viewBox='0 0 16 16'>" +
                                                "<path fill-rule='evenodd' d='M1 8a7 7 0 1 0 14 0A7 7 0 0 0 1 8zm15 0A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM4.5 7.5a.5.5 0 0 0 0 1h5.793l-2.147 2.146a.5.5 0 0 0 .708.708l3-3a.5.5 0 0 0 0-.708l-3-3a.5.5 0 1 0-.708.708L10.293 7.5H4.5z'/>" +
                                            "</svg>" +
                                            "Apply Now" +
                                        "</a>" +
                                    "</div>" +
                                "</div>" +
                            "</div>";
                    });

                    html += "</div>";
                    resultDiv.innerHTML = html;

                    // Scroll to results
                    resultDiv.scrollIntoView({ behavior: "smooth", block: "start" });
                }
            })
            .catch(error => {
                console.error("Error fetching eligible loans:", error);
                document.getElementById("loanResults").innerHTML = 
                    "<div class='alert alert-danger'>" +
                        "<div class='d-flex align-items-center'>" +
                            "<svg xmlns='http://www.w3.org/2000/svg' width='24' height='24' fill='currentColor' class='bi bi-exclamation-circle-fill me-3' viewBox='0 0 16 16'>" +
                                "<path d='M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM8 4a.905.905 0 0 0-.9.995l-.35 3.507a.552.552 0 0 0 1.1 0l.35-3.507A.905.905 0 0 0 8 4zm.002 6a1 1 0 1 0 0 2 1 1 0 0 0 0-2z'/>" +
                            "</svg>" +
                            "<div>" +
                                "<h4 class='alert-heading'>Error</h4>" +
                                "<p class='mb-0'>Failed to check eligibility. Please try again later or contact support.</p>" +
                            "</div>" +
                        "</div>" +
                    "</div>";
            });
        });
    </script>
</body>
</html>
