-- ============================================
-- Quick Check Admin User - Copy & Paste
-- ============================================
-- Copy and paste these queries in MySQL Workbench
-- ============================================

USE trading_journal;

-- ============================================
-- Query 1: Check Admin User Exists
-- ============================================
SELECT * FROM users WHERE username = 'VedPandey18';

-- ============================================
-- Query 2: Check Admin with Subscription
-- ============================================
SELECT 
    u.id,
    u.username,
    u.email,
    u.created_at,
    s.plan_type,
    s.is_active
FROM users u
LEFT JOIN subscriptions s ON u.id = s.user_id
WHERE u.username = 'VedPandey18';

-- ============================================
-- Query 3: Verify Admin Exists (Simple)
-- ============================================
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN '✅ Admin user EXISTS'
        ELSE '❌ Admin user NOT FOUND'
    END as status
FROM users 
WHERE username = 'VedPandey18';

-- ============================================
-- Query 4: View All Users (Including Admin)
-- ============================================
SELECT 
    id,
    username,
    email,
    created_at
FROM users
ORDER BY created_at DESC;

-- ============================================
-- Query 5: Complete Admin Info
-- ============================================
SELECT 
    u.id as user_id,
    u.username,
    u.email,
    u.created_at as user_created,
    s.id as subscription_id,
    s.plan_type,
    s.is_active,
    s.start_date,
    s.created_at as subscription_created
FROM users u
LEFT JOIN subscriptions s ON u.id = s.user_id
WHERE u.username = 'VedPandey18';
