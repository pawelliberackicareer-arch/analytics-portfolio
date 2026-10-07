# Shared code: read the Olist CSV files. Used by every step from 02 onwards.
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

# Columns that hold dates. Read as text, they cannot be compared or subtracted.
DATE_COLUMNS = {
    "orders": [
        "order_purchase_timestamp",
        "order_approved_at",
        "order_delivered_carrier_date",
        "order_delivered_customer_date",
        "order_estimated_delivery_date",
    ],
    "items": ["shipping_limit_date"],
    "reviews": ["review_creation_date", "review_answer_timestamp"],
}


def load_tables():
    """Read every CSV file and return the tables in one dictionary."""
    tables = {}
    for name, file_name in FILES.items():
        dates = DATE_COLUMNS.get(name, [])
        tables[name] = pd.read_csv(DATA_DIR / file_name, parse_dates=dates)
    return tables
