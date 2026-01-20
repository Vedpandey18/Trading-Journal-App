-- ============================================
-- Create Admin User - Manual SQL Script
-- ============================================
-- Run this in MySQL Workbench if you want to create
-- the admin user manually instead of using DataInitializer
-- ============================================

USE trading_journal;

-- Note: This uses a BCrypt hash for password "Qwertyx201#"
-- The hash was generated using Spring Boot's BCryptPasswordEncoder
-- If you want to use this script, you need to generate a BCrypt hash first

-- Option 1: Use DataInitializer (Recommended)
-- The DataInitializer.java will automatically create this user
-- when the backend starts. Just start the backend and it will be created.

-- Option 2: Manual SQL (if needed)
-- First, you need to get the BCrypt hash from backend logs
-- or generate it using a BCrypt generator

-- Example (replace with actual BCrypt hash):
-- INSERT INTO users (username, email, password, created_at, updated_at)
-- VALUES (
--     'VedPandey18',
--     'Ved201283@gmail.com',
--     '$2a$10$YOUR_BCRYPT_HASH_HERE',  -- Replace with actual BCrypt hash
--     NOW(),
--     NOW()
-- );

-- Then create subscription:
-- INSERT INTO subscriptions (user_id, plan_type, is_active, start_date, created_at, updated_at)
-- VALUES (
--     (SELECT id FROM users WHERE username = 'VedPandey18'),
--     'FREE',
--     TRUE,
--     NOW(),
--     NOW(),
--     NOW()
-- );

-- ============================================
-- RECOMMENDED: Use DataInitializer.java
-- ============================================
-- The DataInitializer will automatically create the admin user
-- when you start the backend. No manual SQL needed!
