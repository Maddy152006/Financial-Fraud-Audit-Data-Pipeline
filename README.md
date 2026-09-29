# Corporate Fraud & Financial Risk Audit Pipeline

An end-to-end data engineering and forensic analytics pipeline designed to identify high-risk financial anomalies within high-velocity transactional databases. This project builds a complete Snowflake data architecture in **MySQL**, runs advanced automated audit heuristic logic, and translates data trends into an interactive executive dashboard in **Power BI**.

---

## Repository Structure & Execution Sequence
The project files are modularly sequenced to reflect a professional production pipeline:
*   **`01_database_schema.sql`**: The warehouse structural layout defining tables, data types, constraints, and relational boundaries.
*   **`02_force_fraud_data.sql`**: The transactional dataset builder holding explicit injection data to test and calibrate audit detection thresholds.
*   **`02_mock_data_loader.py`**: A python automated loading script utilizing `mysql-connector` to populate baseline records.
*   **`03_fraud_detection_queries.sql`**: The logic processing tier carrying advanced analytical models to flag threat profiles.
*   **`03.5_bi_table_aggregation_view.sql`**: The analytics consolidation layer that aggregates logs into a unique, non-inflated dataset.
*   **`04_fraud_audit_dashboard.pbix`**: The Power BI reporting file showcasing interactive financial metrics.

---

## 📊 Relational Database Architecture
The database is structured around a central transactional ledger referencing master customer profiles and compliance lookups:

*   **`users`**: Tracks core customer records (`user_id`, name, country) alongside a compliance `risk_segment` classification (**Low**, **Medium**, **High**).
*   **`accounts`**: Maps individual financial wallets (`account_id`, type, creation date, live balance) directly back to a parent user identity.
*   **`transactions`**: The unedited primary ledger tracking live financial swipe entries (`transaction_id`, amount, timestamp, merchant category, status).
*   **`merchant_blacklist`**: A security lookup dimension used to score external vendor risk from **1 to 10** based on standard compliance danger.
*   **`audit_logs`**: The security investigation inbox storing caught alerts with explicit tracking states (`flagged_reason`, status, logged time).

---

## Forensic Audit Scanners & Analytics Logic

The system scans raw transactional logs across four core financial risk vectors:

### 1. Stolen Card Velocity Spike Tracker
Uses an SQL Window Function partitioned across account timelines to evaluate consecutive micro-gaps. If an account logs high-value transfers spaced less than 5 minutes apart, it indicates a compromised account card.
```sql
WITH sequenced_transactions AS (
    SELECT transaction_id, account_id, amount, transaction_timestamp,
        LAG(transaction_timestamp, 1) OVER (
            PARTITION BY account_id ORDER BY transaction_timestamp
        ) AS previous_transaction_time
    FROM transactions
)
SELECT transaction_id
FROM sequenced_transactions
WHERE previous_transaction_time IS NOT NULL 
  AND TIMESTAMPDIFF(MINUTE, previous_transaction_time, transaction_timestamp) <= 5
  AND amount > 50000;
```

### 2. Blacklist Lookup Ring
Cross-references transactional operational streams against compliance lookups using an `INNER JOIN` coupled with conditional `CASE WHEN` logic to dynamically gauge severity levels.

### 3. Anti-Money Laundering (AML) Structuring & Smurfing Tracker
Money launderers bypass static caps by distributing massive transfers into localized smaller increments. This scanner builds a rolling time-based sliding window using a correlated self-joining subquery inside a CTE to flag rapid cumulative spend spikes breaking a ₹1,50,000 threshold within a 1-hour window.
```sql
WITH time_window_aggregation AS (
    SELECT t1.transaction_id, t1.account_id, t1.amount, t1.transaction_timestamp,
        (
            SELECT COALESCE(SUM(t2.amount), 0)
            FROM transactions t2
            WHERE t2.account_id = t1.account_id
              AND t2.transaction_timestamp BETWEEN t1.transaction_timestamp - INTERVAL 1 HOUR AND t1.transaction_timestamp
        ) AS cumulative_1hr_sum
    FROM transactions t1
)
SELECT transaction_id 
FROM time_window_aggregation 
WHERE cumulative_1hr_sum > 150000.00;
```

### 4. Cross-Border Geographic Mismatch Ring
Tracks multi-tier account hops where domestic-profile users interface with high-risk offshore clearance channels (Crypto, Casinos, Gambling systems) at an altered threshold of ₹55,000.

---

## 📈 Power BI Data Optimization & View Aggregation
To prevent visualization inflation where a single high-risk transaction breaking multiple rules multi-counts total financial figures inside the Power BI layout, a dedicated aggregation view flattens database rows. 

By grouping datasets across unique transaction boundaries via **`GROUP BY`** and **`AVG()` data normalization overrides**, the presentation layout balances **883 absolute unique security incident logs** while pinning financial exposure perfectly under a realistic **30M ceiling**.

---

## How to Run the Pipeline
1. Clone this repository to your local directory machine.
2. Run `01_database_schema.sql` inside your local MySQL instance to create the schema.
3. Execute `02_force_fraud_data.sql` to populate your transactional ledger testing baseline.
4. Execute `03_fraud_detection_queries.sql` and `03.5_bi_table_aggregation_view.sql` to calculate and capture risk logs.
5. Export the resulting view matrix layout to a clean flat file named `fraud_dashboard_data.csv`.
6. Open `04_fraud_audit_dashboard.pbix` in Power BI Desktop and click **Refresh** to populate the interactive analytics report screen.
