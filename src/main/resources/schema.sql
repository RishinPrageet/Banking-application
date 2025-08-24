-- Drop the existing accounts table if necessary (be cautious, this will delete all data)
--DROP TABLE IF EXISTS accounts;

-- Create accounts table with auto-generated ID
CREATE TABLE IF NOT EXISTS accounts (
    id SERIAL PRIMARY KEY, -- Auto-generate ID values
    balance INT NOT NULL CHECK (balance >= 0)
);

ALTER TABLE accounts ADD COLUMN IF NOT EXISTS creation_date DATE DEFAULT CURRENT_DATE;

-- Create transactions table if it doesn't exist
CREATE TABLE IF NOT EXISTS transactions (
    id SERIAL PRIMARY KEY,
    from_account_id INT NOT NULL,
    to_account_id INT NOT NULL,
    amount INT NOT NULL CHECK (amount > 0),
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    type VARCHAR(20) NOT NULL,
    FOREIGN KEY (from_account_id) REFERENCES accounts(id),
    FOREIGN KEY (to_account_id) REFERENCES accounts(id)
);

ALTER TABLE transactions ADD COLUMN IF NOT EXISTS user_id INT REFERENCES users(id);
ALTER TABLE transactions ADD COLUMN IF NOT EXISTS description TEXT;

-- Ensure user_id is indexed for faster queries
CREATE INDEX IF NOT EXISTS idx_transactions_user_id ON transactions(user_id);

-- Create index on timestamp for faster queries
CREATE INDEX IF NOT EXISTS idx_transactions_timestamp ON transactions(timestamp);

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(10) NOT NULL CHECK (role IN ('ADMIN', 'USER')),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Add email column to users table if it doesn't exist
ALTER TABLE users ADD COLUMN IF NOT EXISTS email VARCHAR(100) UNIQUE;

-- Create user_accounts table to link users with their accounts
CREATE TABLE IF NOT EXISTS user_accounts (
    user_id INT NOT NULL,
    account_id INT NOT NULL,
    PRIMARY KEY (user_id, account_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);

-- Create interest_rates table if it doesn't exist
CREATE TABLE IF NOT EXISTS interest_rates (
    account_type VARCHAR(20) PRIMARY KEY,
    rate DECIMAL(5,2) NOT NULL,
    description TEXT,
    last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Insert default interest rates
CREATE TABLE IF NOT EXISTS loans (
    id SERIAL PRIMARY KEY,
    loan_type VARCHAR(50) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    max_amount DECIMAL(12,2),
    duration_months INT,
    eligibility_criteria TEXT
);

CREATE TABLE IF NOT EXISTS user_loans (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    loan_id INT REFERENCES loans(id),
    amount DECIMAL(12,2),
    interest_rate DECIMAL(5,2),
    start_date DATE,
    end_date DATE,
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

INSERT INTO loans (loan_type, interest_rate, max_amount, duration_months, eligibility_criteria) VALUES
('Home Loan', 7.5, 5000000, 240, 'Minimum income 50,000/month, Age 21-60, Salaried or Self-employed'),
('Personal Loan', 12.0, 1000000, 60, 'Minimum income 25,000/month, Age 21-58, Salaried'),
('Car Loan', 9.0, 2000000, 84, 'Minimum income 20,000/month, Age 21-60, Salaried or Self-employed'),
('Education Loan', 10.5, 1500000, 96, 'Student, Admission in recognized institution, Co-applicant required'),
('Gold Loan', 11.0, 500000, 36, 'Gold collateral required, Age 18-65'),
('Business Loan', 13.0, 3000000, 84, 'Business vintage 3+ years, Minimum turnover 10L/year'),
('Two Wheeler Loan', 10.0, 200000, 48, 'Minimum income 10,000/month, Age 18-60'),
('Loan Against Property', 8.5, 4000000, 180, 'Property ownership, Age 25-65, Income proof'),
('Agriculture Loan', 7.0, 1000000, 60, 'Farmer, Land documents required'),
('Travel Loan', 14.0, 500000, 36, 'Minimum income 20,000/month, Age 21-55');

CREATE TABLE IF NOT EXISTS card(
    id SERIAL PRIMARY KEY,
    card_number VARCHAR(16) NOT NULL UNIQUE,
    card_type VARCHAR(20) NOT NULL CHECK (card_type IN ('DEBIT', 'CREDIT')),
    expiration_date DATE NOT NULL,
    cvv INT NOT NULL,
    user_id INT REFERENCES users(id),
    account_id INT REFERENCES accounts(id)
);
CREATE TABLE IF NOT EXISTS card_transactions (
    id SERIAL PRIMARY KEY,
    card_id INT REFERENCES card(id),
    to_account_id INT REFERENCES accounts(id),
    amount DECIMAL(12,2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    transaction_type VARCHAR(20) CHECK (transaction_type IN ('DEPOSIT', 'WITHDRAWAL', 'TRANSFER')),
    description TEXT
);




