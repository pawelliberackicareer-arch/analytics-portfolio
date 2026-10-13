# Step 6: seller defect rate in DPMO style, with a threshold for audit
import pandas as pd

order_sellers = pd.read_csv("output/order_sellers.csv")

MIN_ORDERS = 30          # only judge sellers with enough orders
THRESHOLD_FACTOR = 1.5   # audit if a seller's DPMO is 50% above the network DPMO

# 1. Use only orders with one seller: there we know who is responsible
single = order_sellers[~order_sellers["multi_seller_order"]].copy()
print(f"order-seller pairs: {len(order_sellers):,}   single-seller orders used: {len(single):,}")
print()

# 2. Each order has 2 chances to go wrong: late delivery and a bad review (1-2 stars)
single["has_review"] = single["review_score"].notna()
single["bad_review"] = single["review_score"] <= 2

sellers = single.groupby("seller_id", as_index=False).agg(
    orders=("order_id", "count"),
    late=("is_late", "sum"),
    rated=("has_review", "sum"),
    bad_reviews=("bad_review", "sum"),
)
sellers["opportunities"] = sellers["orders"] + sellers["rated"]
sellers["defects"] = sellers["late"] + sellers["bad_reviews"]
sellers["dpmo"] = (sellers["defects"] / sellers["opportunities"] * 1_000_000).round(0)

# 3. Network DPMO = all defects / all opportunities (never the average of seller DPMOs)
network_dpmo = sellers["defects"].sum() / sellers["opportunities"].sum() * 1_000_000
threshold = network_dpmo * THRESHOLD_FACTOR
print("--- 1. network ---")
print(f"network DPMO:     {network_dpmo:,.0f}")
print(f"audit threshold:  {threshold:,.0f}  ({THRESHOLD_FACTOR}x network)")
print()

# 4. Flag sellers above the threshold
active = sellers[sellers["orders"] >= MIN_ORDERS].copy()
active["audit_flag"] = active["dpmo"] > threshold
expected_defects = active["opportunities"] * network_dpmo / 1_000_000
active["excess_defects"] = (active["defects"] - expected_defects).round(1)

audit = active[active["audit_flag"]].sort_values("excess_defects", ascending=False)
print("--- 2. audit list ---")
print(f"sellers with at least {MIN_ORDERS} orders: {len(active):,}")
print(f"flagged for audit: {len(audit):,}")
share = audit["defects"].sum() / active["defects"].sum()
print(f"flagged sellers cause {share:.1%} of the defects of all active sellers")
print()
print("Top 15, sorted by excess defects (biggest impact first):")
columns = ["seller_id", "orders", "late", "bad_reviews", "dpmo", "excess_defects"]
print(audit[columns].head(15).to_string(index=False))

# 5. Save
active.to_csv("output/kpi_seller_dpmo.csv", index=False)
audit.to_csv("output/audit_list.csv", index=False)
network = pd.DataFrame([{"network_dpmo": round(network_dpmo), "audit_threshold": round(threshold),
                         "sellers_active": len(active), "sellers_flagged": len(audit)}])
network.to_csv("output/kpi_dpmo_network.csv", index=False)
print()
print("Saved: output/kpi_seller_dpmo.csv, audit_list.csv, kpi_dpmo_network.csv")
