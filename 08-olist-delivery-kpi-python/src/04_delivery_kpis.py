# Step 4: delivery KPIs - overall, by state, by month and by seller
import pandas as pd

orders = pd.read_csv(
    "output/orders_base.csv",
    parse_dates=["order_purchase_timestamp", "order_delivered_customer_date",
                 "order_estimated_delivery_date"],
)
order_sellers = pd.read_csv("output/order_sellers.csv", parse_dates=["order_purchase_timestamp"])

# Small groups give unstable percentages, so we only rank groups above these sizes
MIN_ORDERS_STATE = 500
MIN_ORDERS_MONTH = 500
MIN_ORDERS_SELLER = 30

# 1. Overall KPIs
late_share = orders["is_late"].mean()
late_orders = orders[orders["is_late"]]
on_time_orders = orders[~orders["is_late"]]

overall = pd.DataFrame([
    {"kpi": "Delivered orders", "value": len(orders)},
    {"kpi": "On-time rate (%)", "value": round((1 - late_share) * 100, 1)},
    {"kpi": "Late rate (%)", "value": round(late_share * 100, 1)},
    {"kpi": "Average delivery time (days)", "value": round(orders["delivery_days"].mean(), 1)},
    {"kpi": "Median delivery time (days)", "value": orders["delivery_days"].median()},
    {"kpi": "Late orders: average days late", "value": round(late_orders["delay_days"].mean(), 1)},
    {"kpi": "On-time orders: average days early", "value": round(-on_time_orders["delay_days"].mean(), 1)},
])
print("--- 1. overall ---")
print(overall.to_string(index=False))
print()

# 2. By customer state
by_state = orders.groupby("customer_state", as_index=False).agg(
    orders=("order_id", "count"),
    late_pct=("is_late", "mean"),
    avg_delivery_days=("delivery_days", "mean"),
)
by_state["late_pct"] = (by_state["late_pct"] * 100).round(1)
by_state["avg_delivery_days"] = by_state["avg_delivery_days"].round(1)
by_state = by_state[by_state["orders"] >= MIN_ORDERS_STATE]
by_state = by_state.sort_values("late_pct", ascending=False)
print(f"--- 2. states with the highest late rate (min. {MIN_ORDERS_STATE} orders) ---")
print(by_state.head(10).to_string(index=False))
print()

# 3. By month of purchase
orders["month"] = orders["order_purchase_timestamp"].dt.to_period("M").astype(str)
monthly = orders.groupby("month", as_index=False).agg(
    orders=("order_id", "count"),
    late_pct=("is_late", "mean"),
    avg_delivery_days=("delivery_days", "mean"),
)
monthly["late_pct"] = (monthly["late_pct"] * 100).round(1)
monthly["avg_delivery_days"] = monthly["avg_delivery_days"].round(1)
monthly = monthly[monthly["orders"] >= MIN_ORDERS_MONTH]
print(f"--- 3. month by month (months with min. {MIN_ORDERS_MONTH} orders) ---")
print(monthly.to_string(index=False))
print()

# 4. By seller
by_seller = order_sellers.groupby("seller_id", as_index=False).agg(
    orders=("order_id", "nunique"),
    late_pct=("is_late", "mean"),
    avg_review=("review_score", "mean"),
)
by_seller["late_pct"] = (by_seller["late_pct"] * 100).round(1)
by_seller["avg_review"] = by_seller["avg_review"].round(2)
active = by_seller[by_seller["orders"] >= MIN_ORDERS_SELLER]
print(f"--- 4. sellers with the highest late rate (min. {MIN_ORDERS_SELLER} orders) ---")
print(f"sellers in total: {len(by_seller):,}   with at least {MIN_ORDERS_SELLER} orders: {len(active):,}")
print(active.sort_values("late_pct", ascending=False).head(10).to_string(index=False))

# 5. Save the results for the charts and the Excel report
overall.to_csv("output/kpi_overall.csv", index=False)
by_state.to_csv("output/kpi_by_state.csv", index=False)
monthly.to_csv("output/kpi_monthly.csv", index=False)
active.to_csv("output/kpi_by_seller.csv", index=False)
print()
print("Saved: output/kpi_overall.csv, kpi_by_state.csv, kpi_monthly.csv, kpi_by_seller.csv")
