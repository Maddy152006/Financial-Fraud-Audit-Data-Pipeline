import mysql.connector
from datetime import datetime, timedelta
import random

# =====================================================================
# CONFIGURATION: Update 'YOUR_ROOT_PASSWORD' with your actual password
# =====================================================================
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'Madhavan@1234',  # <--- Change this to your password!
    'database': 'corporate_audit'
}

def load_mock_data():
    try:
        # 1. Connect to local MySQL server
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()
        print("Successfully connected to MySQL Server.")

        # 2. Insert Merchant Blacklist Lookup Data
        blacklist_data = [
            ('Online Casino', 9),
            ('Crypto Exchange', 8),
            ('DarkWeb Broker', 10),
            ('Shell Electronics', 7),
            ('Offshore Gambling', 9),
            ('Luxury Retail', 3),
            ('Grocery Store', 1),
            ('Gas Station', 1)
        ]
        cursor.executemany(
            "INSERT IGNORE INTO merchant_blacklist (merchant_category, risk_score) VALUES (%s, %s)",
            blacklist_data
        )
        print("Merchant Blacklist data inserted.")

        # 3. Generate and Insert Users (100 distinct users)
        names = ["Aarav", "Vivaan", "Aditya", "Sai", "Arjun", "Madhav", "Rahul", "Priya", "Ananya", "Riya"]
        surnames = ["Sharma", "Verma", "Ramanujan", "Iyer", "Nair", "Reddy", "Mehta", "Patel", "Joshi", "Das"]
        segments = ['Low', 'Low', 'Low', 'Medium', 'Medium', 'High'] # Weighted towards Low/Medium risk
        countries = ['India', 'India', 'Singapore', 'Malaysia', 'India', 'Thailand']

        users = []
        for _ in range(100):
            full_name = f"{random.choice(names)} {random.choice(surnames)}"
            users.append((full_name, random.choice(segments), random.choice(countries)))
        
        cursor.executemany("INSERT INTO users (name, risk_segment, country) VALUES (%s, %s, %s)", users)
        print("100 users successfully loaded.")

        # 4. Generate and Insert Accounts (Each user gets 1 or 2 accounts)
        cursor.execute("SELECT user_id FROM users")
        user_ids = [row[0] for row in cursor.fetchall()]
        
        accounts = []
        acc_types = ['Savings', 'Current', 'Corporate Credit']
        for u_id in user_ids:
            num_accounts = random.choice([1, 2])
            for _ in range(num_accounts):
                balance = round(random.uniform(5000, 500000), 2)
                # Random account creation date over the last year
                created_date = (datetime.now() - timedelta(days=random.randint(30, 365))).date()
                accounts.append((u_id, random.choice(acc_types), created_date, balance))
        
        cursor.executemany("INSERT INTO accounts (user_id, account_type, creation_date, balance) VALUES (%s, %s, %s, %s)", accounts)
        print(f"{len(accounts)} accounts successfully mapped to users.")

        # 5. Generate and Insert Transaction Ledger Logs (10,000 operational rows)
        cursor.execute("SELECT account_id FROM accounts")
        account_ids = [row[0] for row in cursor.fetchall()]
        categories = ['Grocery Store', 'Gas Station', 'Luxury Retail', 'Online Casino', 'Crypto Exchange', 'Shell Electronics']
        
        transactions = []
        start_time = datetime.now() - timedelta(days=30) # Track last 30 days of data
        
        print("Generating 10,000 transaction ledger records...")
        for _ in range(10000):
            acc_id = random.choice(account_ids)
            amount = round(random.uniform(10, 150000), 2)
            # Advance timestamps incrementally to simulate continuous time flows
            start_time += timedelta(minutes=random.randint(1, 15))
            cat = random.choice(categories)
            
            # Simple simulation: Flag high amounts spent at suspicious blacklisted venues
            status = 'Success'
            if cat in ['Online Casino', 'Crypto Exchange', 'DarkWeb Broker'] and amount > 80000:
                status = 'Flagged'
                
            transactions.append((acc_id, amount, start_time, cat, status))
            
        cursor.executemany(
            "INSERT INTO transactions (account_id, amount, transaction_timestamp, merchant_category, status) VALUES (%s, %s, %s, %s, %s)", 
            transactions
        )
        print("10,000 transaction records successfully pushed to database ledger.")

        # Commit all structural insertions safely
        conn.commit()
        print("\n🎉 ALL MOCK DATA INSURED AND LOADED SUCCESSFULLY!")

    except mysql.connector.Error as err:
        print(f"Database Error encountered: {err}")
    finally:
        if 'conn' in locals() and conn.is_connected():
            cursor.close()
            conn.close()

if __name__ == "__main__":
    load_mock_data()
