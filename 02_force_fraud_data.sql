-- =====================================================================
-- STEP 1: INITIALIZE DATABASE AND WIPE PREVIOUS TABLES
-- =====================================================================
USE corporate_audit;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE transactions;
TRUNCATE TABLE audit_logs;
SET FOREIGN_KEY_CHECKS = 1;

INSERT IGNORE INTO merchant_blacklist (merchant_category, risk_score) VALUES 
('Online Casino', 9), ('Crypto Exchange', 8), ('DarkWeb Broker', 10), ('Offshore Gambling', 9);


-- =====================================================================
-- STEP 2: FORCED INJECTIONS (EXACTLY 35 CLEAN ROWS PER SCENARIO)
-- =====================================================================

-- SCENARIO 1 & 2: 35 Flagged transactions for Account 1 (Spaced 2 mins apart)
INSERT INTO transactions (account_id, amount, transaction_timestamp, merchant_category, status) VALUES
(1, 95000.00, '2026-09-01 10:00:00', 'Online Casino', 'Flagged'),
(1, 96000.00, '2026-09-01 10:02:00', 'Online Casino', 'Flagged'),
(1, 91000.00, '2026-09-01 10:04:00', 'Crypto Exchange', 'Flagged'),
(1, 92000.00, '2026-09-01 10:06:00', 'Crypto Exchange', 'Flagged'),
(1, 98000.00, '2026-09-01 10:08:00', 'DarkWeb Broker', 'Flagged'),
(1, 99000.00, '2026-09-01 10:10:00', 'DarkWeb Broker', 'Flagged'),
(1, 93000.00, '2026-09-01 10:12:00', 'Offshore Gambling', 'Flagged'),
(1, 94000.00, '2026-09-01 10:14:00', 'Offshore Gambling', 'Flagged'),
(1, 95000.00, '2026-09-01 10:16:00', 'Online Casino', 'Flagged'),
(1, 96000.00, '2026-09-01 10:18:00', 'Online Casino', 'Flagged'),
(1, 91000.00, '2026-09-01 10:20:00', 'Crypto Exchange', 'Flagged'),
(1, 92000.00, '2026-09-01 10:22:00', 'Crypto Exchange', 'Flagged'),
(1, 98000.00, '2026-09-01 10:24:00', 'DarkWeb Broker', 'Flagged'),
(1, 99000.00, '2026-09-01 10:26:00', 'DarkWeb Broker', 'Flagged'),
(1, 93000.00, '2026-09-01 10:28:00', 'Offshore Gambling', 'Flagged'),
(1, 94000.00, '2026-09-01 10:30:00', 'Offshore Gambling', 'Flagged'),
(1, 95000.00, '2026-09-01 10:32:00', 'Online Casino', 'Flagged'),
(1, 96000.00, '2026-09-01 10:34:00', 'Online Casino', 'Flagged'),
(1, 91000.00, '2026-09-01 10:36:00', 'Crypto Exchange', 'Flagged'),
(1, 92000.00, '2026-09-01 10:38:00', 'Crypto Exchange', 'Flagged'),
(1, 98000.00, '2026-09-01 10:40:00', 'DarkWeb Broker', 'Flagged'),
(1, 99000.00, '2026-09-01 10:42:00', 'DarkWeb Broker', 'Flagged'),
(1, 93000.00, '2026-09-01 10:44:00', 'Offshore Gambling', 'Flagged'),
(1, 94000.00, '2026-09-01 10:46:00', 'Offshore Gambling', 'Flagged'),
(1, 95000.00, '2026-09-01 10:48:00', 'Online Casino', 'Flagged'),
(1, 96000.00, '2026-09-01 10:50:00', 'Online Casino', 'Flagged'),
(1, 91000.00, '2026-09-01 10:52:00', 'Crypto Exchange', 'Flagged'),
(1, 92000.00, '2026-09-01 10:54:00', 'Crypto Exchange', 'Flagged'),
(1, 98000.00, '2026-09-01 10:56:00', 'DarkWeb Broker', 'Flagged'),
(1, 99000.00, '2026-09-01 10:58:00', 'DarkWeb Broker', 'Flagged'),
(1, 93000.00, '2026-09-01 11:00:00', 'Offshore Gambling', 'Flagged'),
(1, 94000.00, '2026-09-01 11:02:00', 'Offshore Gambling', 'Flagged'),
(1, 95000.00, '2026-09-01 11:04:00', 'Online Casino', 'Flagged'),
(1, 96000.00, '2026-09-01 11:06:00', 'Online Casino', 'Flagged'),
(1, 91000.00, '2026-09-01 11:08:00', 'Crypto Exchange', 'Flagged');

-- SCENARIO 3: Accounts 2 through 13 executing rapid burst spending (Triggers Structuring)
INSERT INTO transactions (account_id, amount, transaction_timestamp, merchant_category, status) VALUES
(2, 60000.00, '2026-09-02 08:00:00', 'Grocery Store', 'Success'), (2, 55000.00, '2026-09-02 08:05:00', 'Gas Station', 'Success'), (2, 45000.00, '2026-09-02 08:10:00', 'Luxury Retail', 'Success'),
(3, 60000.00, '2026-09-02 08:00:00', 'Grocery Store', 'Success'), (3, 55000.00, '2026-09-02 08:05:00', 'Gas Station', 'Success'), (3, 45000.00, '2026-09-02 08:10:00', 'Luxury Retail', 'Success'),
(4, 60000.00, '2026-09-02 08:00:00', 'Grocery Store', 'Success'), (4, 55000.00, '2026-09-02 08:05:00', 'Gas Station', 'Success'), (4, 45000.00, '2026-09-02 08:10:00', 'Luxury Retail', 'Success'),
(5, 60000.00, '2026-09-02 08:00:00', 'Grocery Store', 'Success'), (5, 55000.00, '2026-09-02 08:05:00', 'Gas Station', 'Success'), (5, 45000.00, '2026-09-02 08:10:00', 'Luxury Retail', 'Success'),
(6, 60000.00, '2026-09-02 08:00:00', 'Grocery Store', 'Success'), (6, 55000.00, '2026-09-02 08:05:00', 'Gas Station', 'Success'), (6, 45000.00, '2026-09-02 08:10:00', 'Luxury Retail', 'Success'),
(7, 60000.00, '2026-09-02 08:00:00', 'Grocery Store', 'Success'), (7, 55000.00, '2026-09-02 08:05:00', 'Gas Station', 'Success'), (7, 45000.00, '2026-09-02 08:10:00', 'Luxury Retail', 'Success'),
(8, 60000.00, '2026-09-02 08:00:00', 'Grocery Store', 'Success'), (8, 55000.00, '2026-09-02 08:05:00', 'Gas Station', 'Success'), (8, 45000.00, '2026-09-02 08:10:00', 'Luxury Retail', 'Success'),
(9, 60000.00, '2026-09-02 08:00:00', 'Grocery Store', 'Success'), (9, 55000.00, '2026-09-02 08:05:00', 'Gas Station', 'Success'), (9, 45000.00, '2026-09-02 08:10:00', 'Luxury Retail', 'Success'),
(10, 60000.00, '2026-09-02 08:00:00', 'Grocery Store', 'Success'), (10, 55000.00, '2026-09-02 08:05:00', 'Gas Station', 'Success'), (10, 45000.00, '2026-09-02 08:10:00', 'Luxury Retail', 'Success'),
(11, 60000.00, '2026-09-02 08:00:00', 'Grocery Store', 'Success'), (11, 55000.00, '2026-09-02 08:05:00', 'Gas Station', 'Success'), (11, 45000.00, '2026-09-02 08:10:00', 'Luxury Retail', 'Success'),
(12, 60000.00, '2026-09-02 08:00:00', 'Grocery Store', 'Success'), (12, 55000.00, '2026-09-02 08:05:00', 'Gas Station', 'Success'), (12, 45000.00, '2026-09-02 08:10:00', 'Luxury Retail', 'Success'),
(13, 60000.00, '2026-09-02 08:00:00', 'Grocery Store', 'Success'), (13, 55000.00, '2026-09-02 08:05:00', 'Gas Station', 'Success'), (13, 45000.00, '2026-09-02 08:10:00', 'Luxury Retail', 'Success');

-- SCENARIO 4: Accounts 14 through 48 hitting offshore categories (Triggers Geo Mismatch)
INSERT INTO transactions (account_id, amount, transaction_timestamp, merchant_category, status) VALUES
(14, 135000.00, '2026-09-03 12:00:00', 'Crypto Exchange', 'Success'),
(15, 135000.00, '2026-09-03 12:00:00', 'Crypto Exchange', 'Success'),
(16, 135000.00, '2026-09-03 12:00:00', 'Online Casino', 'Success'),
(17, 135000.00, '2026-09-03 12:00:00', 'Online Casino', 'Success'),
(18, 135000.00, '2026-09-03 12:00:00', 'Offshore Gambling', 'Success'),
(19, 135000.00, '2026-09-03 12:00:00', 'Offshore Gambling', 'Success'),
(20, 135000.00, '2026-09-03 12:00:00', 'Crypto Exchange', 'Success'),
(21, 135000.00, '2026-09-03 12:00:00', 'Crypto Exchange', 'Success'),
(22, 135000.00, '2026-09-03 12:00:00', 'Online Casino', 'Success'),
(23, 135000.00, '2026-09-03 12:00:00', 'Online Casino', 'Success'),
(24, 135000.00, '2026-09-03 12:00:00', 'Offshore Gambling', 'Success'),
(25, 135000.00, '2026-09-03 12:00:00', 'Offshore Gambling', 'Success'),
(26, 135000.00, '2026-09-03 12:00:00', 'Crypto Exchange', 'Success'),
(27, 135000.00, '2026-09-03 12:00:00', 'Crypto Exchange', 'Success'),
(28, 135000.00, '2026-09-03 12:00:00', 'Online Casino', 'Success'),
(29, 135000.00, '2026-09-03 12:00:00', 'Online Casino', 'Success'),
(30, 135000.00, '2026-09-03 12:00:00', 'Offshore Gambling', 'Success'),
(31, 135000.00, '2026-09-03 12:00:00', 'Offshore Gambling', 'Success'),
(32, 135000.00, '2026-09-03 12:00:00', 'Crypto Exchange', 'Success'),
(33, 135000.00, '2026-09-03 12:00:00', 'Crypto Exchange', 'Success'),
(34, 135000.00, '2026-09-03 12:00:00', 'Online Casino', 'Success'),
(35, 135000.00, '2026-09-03 12:00:00', 'Online Casino', 'Success'),
(36, 135000.00, '2026-09-03 12:00:00', 'Offshore Gambling', 'Success'),
(37, 135000.00, '2026-09-03 12:00:00', 'Offshore Gambling', 'Success'),
(38, 135000.00, '2026-09-03 12:00:00', 'Crypto Exchange', 'Success'),
(39, 135000.00, '2026-09-03 12:00:00', 'Crypto Exchange', 'Success'),
(40, 135000.00, '2026-09-03 12:00:00', 'Online Casino', 'Success'),
(41, 135000.00, '2026-09-03 12:00:00', 'Online Casino', 'Success'),
(42, 135000.00, '2026-09-03 12:00:00', 'Offshore Gambling', 'Success'),
(43, 135000.00, '2026-09-03 12:00:00', 'Offshore Gambling', 'Success'),
(44, 135000.00, '2026-09-03 12:00:00', 'Crypto Exchange', 'Success'),
(45, 135000.00, '2026-09-03 12:00:00', 'Crypto Exchange', 'Success'),
(46, 135000.00, '2026-09-03 12:00:00', 'Online Casino', 'Success'),
(47, 135000.00, '2026-09-03 12:00:00', 'Online Casino', 'Success'),
(48, 135000.00, '2026-09-03 12:00:00', 'Offshore Gambling', 'Success');


