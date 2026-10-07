# Runs the whole project from start to finish: python run_all.py
import subprocess
import sys

STEPS = [
    "src/02_quality_checks.py",
    "src/03_join_tables.py",
    "src/04_delivery_kpis.py",
    "src/05_review_impact.py",
    "src/06_seller_dpmo.py",
    "src/07_charts.py",
    "src/08_excel_report.py",
]

for step in STEPS:
    print(f"\n========== {step} ==========")
    subprocess.run([sys.executable, step], check=True)

print("\nDone. Open output/olist_delivery_report.xlsx")
