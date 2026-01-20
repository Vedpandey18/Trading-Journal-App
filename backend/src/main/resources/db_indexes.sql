-- Database Indexes for Performance Optimization
-- Run this script to add indexes for faster queries

USE trading_journal;

-- Index on user_id for trades (most common query)
CREATE INDEX IF NOT EXISTS idx_trades_user_id ON trades(user_id);

-- Index on trade_date for date range queries
CREATE INDEX IF NOT EXISTS idx_trades_trade_date ON trades(trade_date);

-- Composite index for user + date queries (common in analytics)
CREATE INDEX IF NOT EXISTS idx_trades_user_date ON trades(user_id, trade_date);

-- Index on user_id for subscriptions
CREATE INDEX IF NOT EXISTS idx_subscriptions_user_id ON subscriptions(user_id);

-- Index on username for faster login lookups
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);

-- Index on email for faster login lookups
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Verify indexes
SHOW INDEX FROM trades;
SHOW INDEX FROM subscriptions;
SHOW INDEX FROM users;
