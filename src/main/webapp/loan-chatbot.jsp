<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Loan Assistant - Banking System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        
        .chat-container {
            max-width: 1000px;
            margin: 0 auto;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }
        
        .chat-header {
            background-color: #0d6efd;
            color: white;
            padding: 15px 20px;
            border-top-left-radius: 12px;
            border-top-right-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .chat-header h4 {
            margin: 0;
            font-weight: 600;
        }
        
        .chat-body {
            height: 500px;
            overflow-y: auto;
            padding: 20px;
            background-color: #f8f9fa;
        }
        
        .chat-footer {
            padding: 15px 20px;
            background-color: #fff;
            border-top: 1px solid #e9ecef;
        }
        
        .message {
            margin-bottom: 20px;
            max-width: 80%;
        }
        
        .user-message {
            margin-left: auto;
            background-color: #0d6efd;
            color: white;
            border-radius: 18px 18px 0 18px;
            padding: 12px 18px;
        }
        
        .bot-message {
            margin-right: auto;
            background-color: #f1f3f5;
            color: #212529;
            border-radius: 18px 18px 18px 0;
            padding: 12px 18px;
            position: relative;
        }
        
        .bot-message .sources {
            font-size: 0.8rem;
            margin-top: 8px;
            padding-top: 8px;
            border-top: 1px dashed #dee2e6;
        }
        
        .bot-message .source-item {
            display: inline-block;
            background-color: #e9ecef;
            padding: 2px 8px;
            border-radius: 12px;
            margin-right: 5px;
            margin-bottom: 5px;
            font-weight: 500;
        }
        
        .typing-indicator {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .typing-indicator span {
            height: 8px;
            width: 8px;
            background-color: #bbb;
            border-radius: 50%;
            display: inline-block;
            margin: 0 2px;
            animation: typing 1.4s infinite both;
        }
        
        .typing-indicator span:nth-child(2) {
            animation-delay: 0.2s;
        }
        
        .typing-indicator span:nth-child(3) {
            animation-delay: 0.4s;
        }
        
        @keyframes typing {
            0% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-5px);
            }
            100% {
                transform: translateY(0);
            }
        }
        
        .suggested-questions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 15px;
        }
        
        .suggested-question {
            background-color: #e9ecef;
            border: none;
            border-radius: 20px;
            padding: 8px 15px;
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .suggested-question:hover {
            background-color: #dee2e6;
        }
        
        .chat-sidebar {
            background-color: #fff;
            border-left: 1px solid #e9ecef;
            padding: 20px;
        }
        
        .sidebar-section {
            margin-bottom: 30px;
        }
        
        .sidebar-section h5 {
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 15px;
            color: #495057;
        }
        
        .loan-type-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .loan-type-list li {
            padding: 8px 0;
            border-bottom: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
        }
        
        .loan-type-list li:last-child {
            border-bottom: none;
        }
        
        .loan-type {
            font-weight: 500;
        }
        
        .interest-rate {
            color: #0d6efd;
            font-weight: 600;
        }
        
        @media (max-width: 992px) {
            .chat-sidebar {
                border-left: none;
                border-top: 1px solid #e9ecef;
                margin-top: 20px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <div class="container mt-4 mb-5">
        <div class="row">
            <div class="col-lg-8">
                <div class="chat-container">
                    <div class="chat-header">
                        <div>
                            <h4><i class="fas fa-robot me-2"></i> Loan Assistant</h4>
                            <small>Powered by DeepSeek R1</small>
                        </div>
                        <button id="clearChat" class="btn btn-sm btn-outline-light">
                            <i class="fas fa-broom me-1"></i> Clear Chat
                        </button>
                    </div>
                    
                    <div class="chat-body" id="chatBody">
                        <div class="message bot-message">
                            Hello! I'm your loan assistant powered by DeepSeek R1. I can help you with information about our loan products, eligibility criteria, interest rates, and more. What would you like to know?
                        </div>
                        
                        <div class="suggested-questions">
                            <button class="suggested-question">What types of loans do you offer?</button>
                            <button class="suggested-question">What is the interest rate for home loans?</button>
                            <button class="suggested-question">Am I eligible for a personal loan?</button>
                            <button class="suggested-question">What documents are needed for a car loan?</button>
                        </div>
                    </div>
                    
                    <div class="chat-footer">
                        <form id="chatForm" class="d-flex">
                            <input type="text" id="messageInput" class="form-control me-2" placeholder="Type your question here..." required>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-paper-plane"></i>
                            </button>
                        </form>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4">
                <div class="chat-sidebar">
                    <div class="sidebar-section">
                        <h5>Available Loan Types</h5>
                        <ul class="loan-type-list">
                            <li>
                                <span class="loan-type">Home Loan</span>
                                <span class="interest-rate">7.50%</span>
                            </li>
                            <li>
                                <span class="loan-type">Personal Loan</span>
                                <span class="interest-rate">12.00%</span>
                            </li>
                            <li>
                                <span class="loan-type">Car Loan</span>
                                <span class="interest-rate">9.00%</span>
                            </li>
                            <li>
                                <span class="loan-type">Education Loan</span>
                                <span class="interest-rate">10.50%</span>
                            </li>
                            <li>
                                <span class="loan-type">Gold Loan</span>
                                <span class="interest-rate">11.00%</span>
                            </li>
                            <li>
                                <span class="loan-type">Business Loan</span>
                                <span class="interest-rate">13.00%</span>
                            </li>
                        </ul>
                    </div>
                    
                    <div class="sidebar-section">
                        <h5>Quick Links</h5>
                        <div class="d-grid gap-2">
                            <a href="loan-eligibility.jsp" class="btn btn-outline-primary">Check Eligibility</a>
                            <a href="apply-loan.jsp" class="btn btn-outline-primary">Apply for Loan</a>
                            <a href="my-loans.jsp" class="btn btn-outline-primary">View My Loans</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const chatBody = document.getElementById('chatBody');
            const chatForm = document.getElementById('chatForm');
            const messageInput = document.getElementById('messageInput');
            const clearChatBtn = document.getElementById('clearChat');
            const suggestedQuestions = document.querySelectorAll('.suggested-question');
            
            function scrollToBottom() {
                chatBody.scrollTop = chatBody.scrollHeight;
            }
            
            function addMessage(content, isUser = false, sources = null) {
                if (isUser) {
                    console.log("User sent: " + content);
                } else {
                    console.log("Bot replied: " + content + ", sources: " + JSON.stringify(sources));
                }

                const messageDiv = document.createElement('div');
                messageDiv.className = isUser ? 'message user-message' : 'message bot-message';
                messageDiv.textContent = content;
                
                if (sources && sources.length > 0) {
                    const sourcesDiv = document.createElement('div');
                    sourcesDiv.className = 'sources';
                    sourcesDiv.innerHTML = '<strong>Sources:</strong> ';
                    
                    sources.forEach(function(source) {
                        const sourceSpan = document.createElement('span');
                        sourceSpan.className = 'source-item';
                        sourceSpan.textContent = source.loan_type + " (" + source.interest_rate + "%)";
                        sourcesDiv.appendChild(sourceSpan);
                    });
                    
                    messageDiv.appendChild(sourcesDiv);
                }
                
                chatBody.appendChild(messageDiv);
                scrollToBottom();
            }
            
            function showTypingIndicator() {
                const typingDiv = document.createElement('div');
                typingDiv.className = 'typing-indicator';
                typingDiv.id = 'typingIndicator';
                
                for (let i = 0; i < 3; i++) {
                    const dot = document.createElement('span');
                    typingDiv.appendChild(dot);
                }
                
                chatBody.appendChild(typingDiv);
                scrollToBottom();
            }
            
            function hideTypingIndicator() {
                const typingDiv = document.getElementById('typingIndicator');
                if (typingDiv) {
                    chatBody.removeChild(typingDiv);
                }
            }
            
            async function sendMessage(message) {
                try {
                    console.log("Sending message to server: " + message);
                    
                    addMessage(message, true);
                    showTypingIndicator();
                    
                    const response = await fetch('chatbot', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        },
                        body: 'message=' + encodeURIComponent(message)
                    });
                    
                    hideTypingIndicator();
                    
                    if (response.ok) {
                        const data = await response.json();
                        console.log("Received response from server: " + JSON.stringify(data));
                        
                        addMessage(data.response, false, data.sources);
                    } else {
                        throw new Error('Failed to get response from server');
                    }
                } catch (error) {
                    console.error('Error: ' + error);
                    hideTypingIndicator();
                    addMessage('Sorry, I encountered an error. Please try again later.', false);
                }
            }
            
            chatForm.addEventListener('submit', function(e) {
                e.preventDefault();
                const message = messageInput.value.trim();
                if (message) {
                    sendMessage(message);
                    messageInput.value = '';
                }
            });
            
            clearChatBtn.addEventListener('click', function() {
                chatBody.innerHTML = '';
                addMessage("Hello! I'm your loan assistant powered by DeepSeek R1. I can help you with information about our loan products, eligibility criteria, interest rates, and more. What would you like to know?");
            });
            
            suggestedQuestions.forEach(function(button) {
                button.addEventListener('click', function() {
                    const question = button.textContent;
                    sendMessage(question);
                });
            });
            
            scrollToBottom();
        });
    </script>
</body>
</html>
