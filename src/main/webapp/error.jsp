<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Banking System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-8 text-center">
                <div class="card shadow border-danger">
                    <div class="card-body p-5">
                        <div class="mb-4">
                            <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" fill="currentColor" class="bi bi-exclamation-triangle-fill text-danger" viewBox="0 0 16 16">
                                <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
                            </svg>
                        </div>
                        <h1 class="display-5 fw-bold text-danger mb-3">Oops! Something went wrong</h1>
                        <p class="lead mb-4">We're sorry, but an error occurred while processing your request.</p>
                        <div class="d-grid gap-2 d-sm-flex justify-content-sm-center">
                            <a href="index.jsp" class="btn btn-primary btn-lg px-4 gap-3">Go to Home Page</a>
                            <button onclick="window.history.back()" class="btn btn-outline-secondary btn-lg px-4">Go Back</button>
                        </div>
                    </div>
                </div>
                
                <% if (exception != null) { %>
                <div class="card mt-4 shadow">
                    <div class="card-header bg-danger text-white">
                        <h5 class="mb-0">Error Details</h5>
                    </div>
                    <div class="card-body text-start">
                        <p><strong>Error Type:</strong> <%= exception.getClass().getName() %></p>
                        <p><strong>Message:</strong> <%= exception.getMessage() %></p>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>
    
    <jsp:include page="includes/footer.jsp" />
    
    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
