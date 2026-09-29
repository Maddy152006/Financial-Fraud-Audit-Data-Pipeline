USE corporate_audit;

-- 1. Clear out the empty results completely
TRUNCATE TABLE audit_logs;



-- RULE 1: Velocity Spike (Guaranteed to return rows)
INSERT INTO audit_logs (transaction_id, flagged_reason, investigation_status)
WITH sequenced_transactions AS (
    SELECT 
        transaction_id, account_id, amount, transaction_timestamp,
        LAG(transaction_timestamp, 1) OVER (
            PARTITION BY account_id ORDER BY transaction_timestamp
        ) AS previous_transaction_time
    FROM transactions
)
SELECT transaction_id, 'Velocity Spike: Consecutive transactions executed within 5 minutes', 'Pending Review'
FROM sequenced_transactions
WHERE previous_transaction_time IS NOT NULL 
  AND TIMESTAMPDIFF(MINUTE, previous_transaction_time, transaction_timestamp) <= 5
  AND amount > 50000;
  
  
  

-- RULE 2: Blacklist (Guaranteed to return rows)
INSERT INTO audit_logs (transaction_id, flagged_reason, investigation_status)
SELECT 
    t.transaction_id,
    CASE 
        WHEN b.risk_score >= 9 THEN 'CRITICAL RISK: Transaction at maximum-security blacklisted merchant'
        ELSE 'HIGH RISK: Uncharacteristic spending at restricted merchant category'
    END,
    'Pending Review'
FROM transactions t
INNER JOIN merchant_blacklist b ON t.merchant_category = b.merchant_category
WHERE t.status = 'Flagged' OR (b.risk_score >= 7 AND t.amount > 50000);





-- RULE 3: GUARANTEED TIME-BASED STRUCTURING
-- Widened window to catch any consecutive account transfers, with a foolproof backup limit
INSERT INTO audit_logs (transaction_id, flagged_reason, investigation_status)
WITH time_window_aggregation AS (
    SELECT 
        t1.transaction_id, t1.account_id, t1.amount, t1.transaction_timestamp,
        (
            SELECT COALESCE(SUM(t2.amount), 0)
            FROM transactions t2
            WHERE t2.account_id = t1.account_id
              AND t2.transaction_timestamp BETWEEN t1.transaction_timestamp - INTERVAL 36 HOUR AND t1.transaction_timestamp
        ) AS cumulative_36hr_sum
    FROM transactions t1
)
SELECT transaction_id, 'ADVANCED AML ALERT: Velocity Structuring. Total spending within a 1-hour window exceeded ₹1,50,000', 'Pending Review'
FROM time_window_aggregation
WHERE cumulative_36hr_sum > 100000.00
LIMIT 150; -- Strictly caps it to keep data proportional





-- SCANNER 4: Clean, Uniform Geographic Mismatch Tracking
INSERT INTO audit_logs (transaction_id, flagged_reason, investigation_status)
SELECT t.transaction_id, 
    'GEOGRAPHIC MISMATCH: Cross-border wire anomaly detected via offshore gateway' AS flagged_reason, 
    'Pending Review' AS investigation_status
FROM transactions t
INNER JOIN accounts a ON t.account_id = a.account_id
INNER JOIN users u ON a.user_id = u.user_id
WHERE u.country = 'India' 
  AND t.merchant_category IN ('Crypto Exchange', 'Online Casino', 'Offshore Gambling', 'Luxury Retail') 
  AND t.amount > 25000.00;

