# Step 7: charts for the report, saved as PNG files
from pathlib import Path

import matplotlib.pyplot as plt
import pandas as pd

CHART_DIR = Path("output/charts")
CHART_DIR.mkdir(parents=True, exist_ok=True)

monthly = pd.read_csv("output/kpi_monthly.csv")
by_state = pd.read_csv("output/kpi_by_state.csv")
by_delay = pd.read_csv("output/kpi_reviews_by_delay.csv")
sellers = pd.read_csv("output/kpi_seller_dpmo.csv")
overall = pd.read_csv("output/kpi_overall.csv")
network = pd.read_csv("output/kpi_dpmo_network.csv")

late_rate = overall.loc[overall["kpi"] == "Late rate (%)", "value"].iloc[0]
threshold = network["audit_threshold"].iloc[0]


def save(fig, file_name):
    """Save a chart as a PNG file and close it to free memory."""
    fig.tight_layout()
    fig.savefig(CHART_DIR / file_name, dpi=150)
    plt.close(fig)
    print(f"Saved: {CHART_DIR / file_name}")


# 1. Late rate month by month
fig, ax = plt.subplots(figsize=(10, 4))
ax.plot(monthly["month"], monthly["late_pct"], marker="o", color="#1F3864")
ax.axhline(late_rate, color="grey", linestyle="--", label=f"Average ({late_rate}%)")
ax.set_title("Late deliveries by month of purchase")
ax.set_ylabel("Late orders (%)")
ax.tick_params(axis="x", rotation=45)
ax.legend()
save(fig, "01_late_rate_by_month.png")

# 2. Late rate by customer state (10 worst)
top_states = by_state.sort_values("late_pct", ascending=False).head(10)
fig, ax = plt.subplots(figsize=(8, 4.5))
ax.barh(top_states["customer_state"], top_states["late_pct"], color="#C55A11")
ax.invert_yaxis()
ax.set_title("States with the highest late rate (min. 500 orders)")
ax.set_xlabel("Late orders (%)")
save(fig, "02_late_rate_by_state.png")

# 3. Review score by delay
fig, ax = plt.subplots(figsize=(9, 4.5))
ax.bar(by_delay["delay_group"], by_delay["avg_review"], color="#0B6E69")
ax.set_title("Average review score by delivery delay")
ax.set_ylabel("Average review (1-5)")
ax.set_ylim(0, 5)
ax.tick_params(axis="x", rotation=30)
for x, value in zip(by_delay["delay_group"], by_delay["avg_review"]):
    ax.text(x, value + 0.08, f"{value:.2f}", ha="center")
save(fig, "03_review_by_delay.png")

# 4. Sellers: orders vs DPMO, flagged sellers in red
flagged = sellers[sellers["audit_flag"]]
normal = sellers[~sellers["audit_flag"]]
fig, ax = plt.subplots(figsize=(9, 5))
ax.scatter(normal["orders"], normal["dpmo"], s=15, alpha=0.5, color="grey", label="Below threshold")
ax.scatter(flagged["orders"], flagged["dpmo"], s=25, color="#C00000", label="Flagged for audit")
ax.axhline(threshold, color="#C00000", linestyle="--", label=f"Audit threshold ({threshold:,.0f})")
ax.set_xscale("log")
ax.xaxis.set_major_formatter(plt.FuncFormatter(lambda x, _: f"{x:,.0f}"))
ax.yaxis.set_major_formatter(plt.FuncFormatter(lambda y, _: f"{y:,.0f}"))
ax.set_title("Seller defect rate (DPMO) vs number of orders")
ax.set_xlabel("Orders (log scale)")
ax.set_ylabel("DPMO")
ax.legend()
save(fig, "04_seller_dpmo.png")
