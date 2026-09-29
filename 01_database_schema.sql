-- Step 1: Create and initialize your new database
CREATE DATABASE IF NOT EXISTS corporate_audit;
USE corporate_audit;

-- Step 2: Build your first primary master table (Users)
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    risk_segment VARCHAR(20) DEFAULT 'Low',
    country VARCHAR(50) NOT NULL
);

-- Step 3: Build the Accounts table with a Foreign Key relationship
CREATE TABLE accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    account_type VARCHAR(30) NOT NULL,
    creation_date DATE NOT NULL,
    balance DECIMAL(15, 2) DEFAULT 0.00,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);


-- Step 4: Build the massive Transactions ledger table
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    transaction_timestamp DATETIME NOT NULL,
    merchant_category VARCHAR(50) NOT NULL,
    status VARCHAR(20) DEFAULT 'Success',
    FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE CASCADE
);

-- Step 5: Build the Merchant Blacklist table
CREATE TABLE merchant_blacklist (
    merchant_id INT PRIMARY KEY AUTO_INCREMENT,
    merchant_category VARCHAR(50) UNIQUE NOT NULL,
    risk_score INT CHECK (risk_score BETWEEN 1 AND 10)
);

-- Step 6: Build the Audit Logs table to track security incidents
CREATE TABLE audit_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    transaction_id INT NOT NULL,
    flagged_reason VARCHAR(255) NOT NULL,
    investigation_status VARCHAR(30) DEFAULT 'Pending Review',
    logged_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id) ON DELETE CASCADE
);

