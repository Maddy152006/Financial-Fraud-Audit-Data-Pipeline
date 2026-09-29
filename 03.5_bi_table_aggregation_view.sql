USE corporate_audit;

-- Step 1: Wipe the single problematic view definition cleanly out of memory
DROP VIEW IF EXISTS v_powerbi_fraud_dashboard;

-- Step 2: Re-engineer the view to aggregate amounts and force distinct logs
CREATE OR REPLACE VIEW v_powerbi_fraud_dashboard AS
SELECT 
    MAX(al.log_id) AS log_id,
    al.flagged_reason,
    al.investigation_status,
    MAX(al.logged_at) AS logged_at,
    -- Using AVG here forces a unique, compressed amount even if rows overlap!
    AVG(t.amount) AS transaction_amount, 
    t.merchant_category,
    u.name AS customer_name,
    u.risk_segment AS customer_risk_profile,
    u.country
FROM audit_logs al
INNER JOIN transactions t ON al.transaction_id = t.transaction_id
INNER JOIN accounts a ON t.account_id = a.account_id
INNER JOIN users u ON a.user_id = u.user_id
GROUP BY 
    al.flagged_reason,
    al.investigation_status,
    t.merchant_category,
    u.name,
    u.risk_segment,
    u.country;

-- Step 3: Run selection to verify the results look tight and structured
SELECT * FROM v_powerbi_fraud_dashboard;
