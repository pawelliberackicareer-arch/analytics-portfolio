# Step 2: data quality checks. Every finding goes into output/quality_log.csv
import pandas as pd

from load_data import load_tables

tables = load_tables()
orders = tables["orders"]
items = tables["items"]
reviews = tables["reviews"]

checks = []


def add_check(table, check, rows):
    """Save one finding to the list and print it."""
    checks.append({"table": table, "check": check, "rows": int(rows)})
    print(f"{table:<8} | {check:<50} | {rows:>6,}")


# 1. Are the dates real dates now? (should say datetime64)
print("--- column types in orders ---")
print(orders.dtypes)
print()

# 2. How many orders are in each status?
print("--- order status ---")
print(orders["order_status"].value_counts())
print()

# 3. Which orders have no delivery date?
no_delivery = orders["order_delivered_customer_date"].isna()
print("--- orders with no delivery date, by status ---")
print(orders.loc[no_delivery, "order_status"].value_counts())
print()

# 4. Checks that should all return 0 (or a small number we must handle)
print("--- quality checks ---")
delivered = orders["order_status"] == "delivered"
add_check("orders", "status delivered but no delivery date",
          (delivered & no_delivery).sum())
add_check("orders", "delivered before it was bought",
          (orders["order_delivered_customer_date"] < orders["order_purchase_timestamp"]).sum())
add_check("orders", "given to carrier after it reached the customer",
          (orders["order_delivered_carrier_date"] > orders["order_delivered_customer_date"]).sum())
add_check("items", "price zero or below",
          (items["price"] <= 0).sum())
add_check("reviews", "review score outside 1-5",
          (~reviews["review_score"].between(1, 5)).sum())

reviews_per_order = reviews.groupby("order_id").size()
add_check("reviews", "orders with more than one review",
          (reviews_per_order > 1).sum())

sellers_per_order = items.groupby("order_id")["seller_id"].nunique()
add_check("items", "orders with more than one seller",
          (sellers_per_order > 1).sum())

# 5. Save the log so the Excel report can show it later
log = pd.DataFrame(checks)
log.to_csv("output/quality_log.csv", index=False)
print()
print("Saved: output/quality_log.csv")
