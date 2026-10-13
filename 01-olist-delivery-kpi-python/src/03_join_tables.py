# Step 3: choose the orders to analyse, join the tables and check the row count after every join
import pandas as pd

from load_data import load_tables

tables = load_tables()
orders = tables["orders"]
items = tables["items"]
reviews = tables["reviews"]
customers = tables["customers"]
sellers = tables["sellers"]


def check_rows(step, before, after):
    """Print the row count before and after a step. A join must not add rows by accident."""
    status = "OK" if before == after else "CHANGED - check why"
    print(f"{step:<38} {before:>8,} -> {after:>8,}   {status}")


# 1. Keep only orders we can measure: delivered, with a delivery date, and logical dates
print("--- 1. orders for the delivery analysis ---")
delivered = orders["order_status"] == "delivered"
has_date = orders["order_delivered_customer_date"].notna()
carrier_after_delivery = (
    orders["order_delivered_carrier_date"] > orders["order_delivered_customer_date"]
)
base = orders[delivered & has_date & ~carrier_after_delivery].copy()
print(f"all orders:        {len(orders):>8,}")
print(f"kept for analysis: {len(base):>8,}")
print(f"left out:          {len(orders) - len(base):>8,}")
print()

# 2. One review per order: keep the latest answer
print("--- 2. reviews: one per order ---")
reviews_sorted = reviews.sort_values("review_answer_timestamp")
reviews_one = reviews_sorted.drop_duplicates(subset="order_id", keep="last")
print(f"reviews before: {len(reviews):,}   after: {len(reviews_one):,}")
print()

# 3. Join customers and reviews to the orders (one order = one row must stay true)
print("--- 3. joins on orders ---")
rows_before = len(base)
base = base.merge(
    customers[["customer_id", "customer_state"]],
    on="customer_id", how="left", validate="one_to_one",
)
check_rows("orders + customers", rows_before, len(base))

rows_before = len(base)
base = base.merge(
    reviews_one[["order_id", "review_score"]],
    on="order_id", how="left", validate="one_to_one",
)
check_rows("orders + reviews", rows_before, len(base))
print(f"orders without a review: {base['review_score'].isna().sum():,}")
print()

# 4. Delivery measures for every order
delivered_day = base["order_delivered_customer_date"].dt.normalize()
base["delivery_days"] = (
    base["order_delivered_customer_date"] - base["order_purchase_timestamp"]
).dt.days
base["delay_days"] = (delivered_day - base["order_estimated_delivery_date"]).dt.days
base["is_late"] = base["delay_days"] > 0

# 5. Order + seller level (an order can have more than one seller)
print("--- 4. order + seller table ---")
order_sellers = items.groupby(["order_id", "seller_id"], as_index=False).agg(
    items=("order_item_id", "count"),
    item_value=("price", "sum"),
)
order_sellers["multi_seller_order"] = (
    order_sellers.groupby("order_id")["seller_id"].transform("count") > 1
)

rows_before = len(order_sellers)
order_sellers = order_sellers.merge(
    base[["order_id", "order_purchase_timestamp", "customer_state",
          "delay_days", "is_late", "review_score"]],
    on="order_id", how="inner", validate="many_to_one",
)
print(f"order-seller pairs: {rows_before:,} -> {len(order_sellers):,} "
      f"(pairs of orders left out in part 1 are dropped on purpose)")

rows_before = len(order_sellers)
order_sellers = order_sellers.merge(
    sellers[["seller_id", "seller_state"]],
    on="seller_id", how="left", validate="many_to_one",
)
check_rows("order-sellers + sellers", rows_before, len(order_sellers))
print()

# 6. Save both tables for the next steps
base.to_csv("output/orders_base.csv", index=False)
order_sellers.to_csv("output/order_sellers.csv", index=False)
print("Saved: output/orders_base.csv and output/order_sellers.csv")
print(f"Late orders: {base['is_late'].mean():.1%}")
