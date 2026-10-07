# Step 5: do late deliveries lead to worse reviews?
import pandas as pd

orders = pd.read_csv("output/orders_base.csv")

# Only orders with a review can tell us anything about reviews
rated = orders[orders["review_score"].notna()].copy()
rated["bad_review"] = rated["review_score"] <= 2
print(f"orders with a review: {len(rated):,} of {len(orders):,}")
print()

# 1. On time vs late
on_time_vs_late = rated.groupby("is_late", as_index=False).agg(
    orders=("order_id", "count"),
    avg_review=("review_score", "mean"),
    bad_review_pct=("bad_review", "mean"),
)
on_time_vs_late["is_late"] = on_time_vs_late["is_late"].map({False: "On time", True: "Late"})
on_time_vs_late["avg_review"] = on_time_vs_late["avg_review"].round(2)
on_time_vs_late["bad_review_pct"] = (on_time_vs_late["bad_review_pct"] * 100).round(1)
print("--- 1. on time vs late ---")
print(on_time_vs_late.to_string(index=False))
print()

# 2. The later the order, the worse the review? Group delays into ranges
bins = [float("-inf"), -7, -1, 0, 3, 7, 14, float("inf")]
labels = ["7+ days early", "1-6 days early", "on the day", "1-3 days late",
          "4-7 days late", "8-14 days late", "15+ days late"]
rated["delay_group"] = pd.cut(rated["delay_days"], bins=bins, labels=labels)

by_delay = rated.groupby("delay_group", as_index=False, observed=True).agg(
    orders=("order_id", "count"),
    avg_review=("review_score", "mean"),
    bad_review_pct=("bad_review", "mean"),
)
by_delay["avg_review"] = by_delay["avg_review"].round(2)
by_delay["bad_review_pct"] = (by_delay["bad_review_pct"] * 100).round(1)
print("--- 2. review score by delay ---")
print(by_delay.to_string(index=False))
print()

# 3. What share of all bad reviews comes from late orders?
late_share_orders = rated["is_late"].mean()
late_share_bad = rated.loc[rated["bad_review"], "is_late"].mean()
print("--- 3. late orders and bad reviews ---")
print(f"late orders are {late_share_orders:.1%} of all rated orders")
print(f"but {late_share_bad:.1%} of all bad reviews (1-2 stars)")

# 4. Save for the report
on_time_vs_late.to_csv("output/kpi_reviews_on_time_vs_late.csv", index=False)
by_delay.to_csv("output/kpi_reviews_by_delay.csv", index=False)
print()
print("Saved: output/kpi_reviews_on_time_vs_late.csv, kpi_reviews_by_delay.csv")
