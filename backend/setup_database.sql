-- Trading Journal Database Setup
-- Run this in MySQL Workbench

-- Step 1: Use the database (or create if it doesn't exist)
CREATE DATABASE IF NOT EXISTS trading_journal;
USE trading_journal;

-- Step 2: Drop existing tables if they exist (for clean setup)
-- Drop in correct order to handle foreign key constraints
DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS trades;
DROP TABLE IF EXISTS user_roles;  -- Drop this first if it exists (may have FK to users)
DROP TABLE IF EXISTS users;

-- Step 3: Create users table
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at DATETIME(6),
    updated_at DATETIME(6),
    INDEX idx_username (username),
    INDEX idx_email (email)
);

-- Step 4: Create trades table
CREATE TABLE trades (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    instrument VARCHAR(255) NOT NULL,
    trade_type VARCHAR(10) NOT NULL,
    entry_price DECIMAL(19,2) NOT NULL,
    exit_price DECIMAL(19,2) NOT NULL,
    quantity INT NOT NULL,
    lot_size INT DEFAULT 1,
    trade_date DATE NOT NULL,
    notes TEXT,
    profit_loss DECIMAL(19,2),
    created_at DATETIME(6),
    updated_at DATETIME(6),
    CONSTRAINT fk_trades_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_trade_date (trade_date)
);

-- Step 5: Create subscriptions table
CREATE TABLE subscriptions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE,
    plan_type VARCHAR(10) NOT NULL DEFAULT 'FREE',
    razorpay_order_id VARCHAR(255),
    razorpay_payment_id VARCHAR(255),
    razorpay_signature VARCHAR(255),
    start_date DATETIME(6),
    end_date DATETIME(6),
    is_active BOOLEAN DEFAULT FALSE,
    created_at DATETIME(6),
    updated_at DATETIME(6),
    CONSTRAINT fk_subscriptions_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
);

-- Step 6: Verify tables were created
SHOW TABLES;

-- Step 7: Check table structures
DESCRIBE users;
DESCRIBE trades;
DESCRIBE subscriptions;
