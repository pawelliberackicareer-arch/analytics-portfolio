# Step 1: load the Olist tables and take a first look
from pathlib import Path

import pandas as pd

DATA_DIR = Path("data/raw")

FILES = {
    "orders": "olist_orders_dataset.csv",
    "items": "olist_order_items_dataset.csv",
    "reviews": "olist_order_reviews_dataset.csv",
    "customers": "olist_customers_dataset.csv",
    "sellers": "olist_sellers_dataset.csv",
}

# 1. Read every CSV file into a DataFrame and keep them in one dictionary
tables = {}
for name, file_name in FILES.items():
    tables[name] = pd.read_csv(DATA_DIR / file_name)

# 2. Size and first rows of each table
for name, df in tables.items():
    print(f"--- {name} ---")
    print(f"rows: {len(df):,}   columns: {df.shape[1]}")
    print(df.head(3))
    print()

# 3. Missing values in the orders table
print("--- missing values in orders ---")
print(tables["orders"].isna().sum())
print()

# 4. Should these columns be unique? Count duplicates
KEYS = {
    "orders": "order_id",
    "customers": "customer_id",
    "sellers": "seller_id",
    "reviews": "order_id",
}
print("--- duplicate keys ---")
for name, key in KEYS.items():
    duplicates = tables[name][key].duplicated().sum()
    print(f"{name}: {duplicates:,} duplicate values in {key}")
