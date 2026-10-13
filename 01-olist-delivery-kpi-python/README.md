# Olist delivery KPIs and seller defect rate (Python)

Python (pandas, matplotlib, openpyxl) on the public [Olist e-commerce dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce): 96,447 delivered orders from a Brazilian marketplace, 2016-2018.

**[Open the notebook](olist_analysis.ipynb)** to see the whole analysis step by step, with tables and charts.

I work mostly in SQL (Redshift), Excel/VBA and Power BI. This was my first Python project: I wanted to see how my usual way of working (check the data first, count rows after every join, measure defects as DPMO) carries over to pandas.

## What it does

1. Loads five tables and checks sizes, missing values and duplicate keys.
2. Runs data quality checks and logs every finding (8 delivered orders with no delivery date, 23 handed to the carrier after reaching the customer, 547 orders with more than one review).
3. Joins the tables with `validate=` and prints the row count before and after each join, so a bad join can't quietly duplicate orders.
4. Calculates delivery KPIs overall, by state, by month and by seller.
5. Measures how review scores change with the delivery delay.
6. Scores sellers with a DPMO-style defect rate (late delivery + 1-2 star review) and builds an audit list.
7. Exports a formatted Excel report with charts (`python run_all.py`).

## Findings

- 93.2% of orders arrive on time. Late ones are late by 10.6 days on average, while on-time orders arrive 13.5 days early, so the promised dates are very cautious.
- Reviews drop step by step with the delay: 4.31 for orders 7+ days early, 3.29 at 1-3 days late, 1.67 at 8-14 days late.
- Late orders are 6.7% of rated orders but 32.5% of all 1-2 star reviews.
- The worst months were November 2017 (Black Friday) and February-March 2018 (up to 19% late). The data doesn't explain the 2018 peak.
- The north-east states are worst (MA 17.4%, CE 13.8%). Rio de Janeiro has 12.1% late orders with a fairly short 14.8-day delivery time, so distance alone doesn't explain it.
- 83 of 615 sellers with 30+ orders are above the audit threshold (1.5x the network DPMO). They cause about 20% of seller defects, so audits help but most of the problem is spread across the network.

## Notes on the method

- "Late" compares days, not hours, because the estimated date has no time.
- Network DPMO is total defects divided by total opportunities, not the average of seller rates, so small sellers don't get the same weight as big ones.
- The audit list is sorted by excess defects (defects above what the network rate would give at that seller's volume), not by DPMO, so the audit goes where it fixes the most orders.
- Orders with several sellers are left out of the seller score, since one delivery date can't be split between them.
- Small sellers vary a lot by chance, so a flag should be confirmed over a second period before anyone gets audited.

## Project structure

```
01-olist-delivery-kpi-python/
├── data/raw/                  ← Kaggle CSV files (not in the repo, download them)
├── olist_analysis.ipynb       ← walkthrough with all outputs
├── src/
│   ├── load_data.py           ← shared code: read CSV files, turn date columns into dates
│   ├── 01_load_and_check.py   ← first look
│   ├── 02_quality_checks.py
│   ├── 03_join_tables.py
│   ├── 04_delivery_kpis.py
│   ├── 05_review_impact.py
│   ├── 06_seller_dpmo.py
│   ├── 07_charts.py
│   └── 08_excel_report.py
├── output/                    ← KPI tables, charts and the Excel report
├── run_all.py
└── requirements.txt
```

## How to run

```
python -m venv .venv
.venv\Scripts\activate          (Mac/Linux: source .venv/bin/activate)
pip install -r requirements.txt
```
Open a terminal in this folder (`01-olist-delivery-kpi-python`). Download the dataset from Kaggle and put the CSV files in `data/raw/`, then:
```
python run_all.py
```
Result: `output/olist_delivery_report.xlsx` and the charts in `output/charts/`.

To see the walkthrough, open `olist_analysis.ipynb` in VS Code (or Jupyter) and run all cells.

## Limits

- The link between delay and reviews is strong and step by step, but it is a link, not proof of cause.
- The data does not explain the Feb-Mar 2018 peak: that is a question for the logistics team, not a conclusion.
- The estimated delivery date is set by the marketplace, so "late" measures the promise as much as the delivery.

## What I would do next

- Confirm audit flags over two periods before sending an auditor
- Add the cost of a bad review (e.g. lost repeat orders) to show the money behind the KPIs
- Compare the promised delivery time by state to find where the estimate is too short

---
[Back to all projects](../README.md)
