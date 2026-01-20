-- ============================================
-- Trading Journal - MySQL Database Tables
-- ============================================
-- This file contains the complete database schema
-- Run this in MySQL Workbench to create all tables
-- ============================================

-- Create database (if not exists)
CREATE DATABASE IF NOT EXISTS trading_journal;
USE trading_journal;

-- ============================================
-- Table: users
-- ============================================
-- Stores user account information
-- ============================================

DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS trades;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at DATETIME(6),
    updated_at DATETIME(6),
    INDEX idx_username (username),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: trades
-- ============================================
-- Stores trading records for each user
-- ============================================

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
    CONSTRAINT fk_trades_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_trade_date (trade_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: subscriptions
-- ============================================
-- Stores user subscription information
-- ============================================

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
    CONSTRAINT fk_subscriptions_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Sample Queries
-- ============================================

-- View all users
-- SELECT * FROM users;

-- View all trades
-- SELECT * FROM trades;

-- View all subscriptions
-- SELECT * FROM subscriptions;

-- View users with their subscriptions
-- SELECT u.id, u.username, u.email, u.created_at, s.plan_type, s.is_active
-- FROM users u
-- LEFT JOIN subscriptions s ON u.id = s.user_id;

-- View trades with user information
-- SELECT t.id, u.username, t.instrument, t.trade_type, t.entry_price, t.exit_price, t.profit_loss, t.trade_date
-- FROM trades t
-- JOIN users u ON t.user_id = u.id
-- ORDER BY t.trade_date DESC;

-- Count trades per user
-- SELECT u.username, COUNT(t.id) as total_trades, SUM(t.profit_loss) as total_pnl
-- FROM users u
-- LEFT JOIN trades t ON u.id = t.user_id
-- GROUP BY u.id, u.username;
