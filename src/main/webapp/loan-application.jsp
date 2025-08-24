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
</head>
<body>
    <jsp:include page="includes/header.jsp" />

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-success text-white">
                        <h3 class="mb-0">Loan Eligibility Check</h3>
                    </div>
                    <div class="card-body">
                        <form id="loanEligibilityForm">
                            <div class="mb-3">
                                <label for="income" class="form-label">Monthly Income (₹)</label>
                                <input type="number" class="form-control" id="income" name="income" required>
                            </div>
                            <div class="mb-3">
                                <label for="age" class="form-label">Age</label>
                                <input type="number" class="form-control" id="age" name="age" required>
                            </div>
                            <div class="mb-3">
                                <label for="employment" class="form-label">Employment Type</label>
                                <select class="form-select" id="employment" name="employment" required>
                                    <option value="Salaried">Salaried</option>
                                    <option value="Self-employed">Self-employed</option>
                                    <option value="Student">Student</option>
                                    <option value="Farmer">Farmer</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="hasGold" class="form-label">Do you have gold for collateral?</label>
                                <select class="form-select" id="hasGold" name="hasGold" required>
                                    <option value="yes">Yes</option>
                                    <option value="no">No</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="hasProperty" class="form-label">Do you own property?</label>
                                <select class="form-select" id="hasProperty" name="hasProperty" required>
                                    <option value="yes">Yes</option>
                                    <option value="no">No</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="hasAdmission" class="form-label">Do you have admission to an institution?</label>
                                <select class="form-select" id="hasAdmission" name="hasAdmission" required>
                                    <option value="yes">Yes</option>
                                    <option value="no">No</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="businessVintage" class="form-label">Years in Business (if applicable)</label>
                                <input type="number" class="form-control" id="businessVintage" name="businessVintage" value="0">
                            </div>
                            <div class="mb-3">
                                <label for="turnover" class="form-label">Annual Turnover (₹)</label>
                                <input type="number" class="form-control" id="turnover" name="turnover" value="0">
                            </div>
                            <button type="submit" class="btn btn-success">Check Eligible Loans</button>
                        </form>
                        <div id="loanResults" class="mt-4"></div>
                    </div>
                </div>
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

            fetch('loan?action=checkEligibility', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(formData)
            })
            .then(response => response.json())
            .then(data => {
                const resultDiv = document.getElementById('loanResults');
                if (data.length === 0) {
                    resultDiv.innerHTML = `<div class="alert alert-warning">No eligible loans found for the provided criteria.</div>`;
                } else {
                    let html = '<h5>Eligible Loan Options</h5><ul class="list-group">';
                    data.forEach(loan => {
                        html += `<li class="list-group-item">
                                    <strong>${loan.loan_type}</strong><br>
                                    Interest Rate: ${loan.interest_rate}%<br>
                                    Max Amount: ₹${loan.max_amount}<br>
                                    Duration: ${loan.duration_months} months<br>
                                    Criteria: ${loan.eligibility_criteria}
                                 </li>`;
                    });
                    html += '</ul>';
                    resultDiv.innerHTML = html;
                }
            })
            .catch(error => {
                console.error('Error fetching eligible loans:', error);
                document.getElementById('loanResults').innerHTML =
                    '<div class="alert alert-danger">Failed to check eligibility. Try again later.</div>';
            });
        });
    </script>
</body>
</html>
