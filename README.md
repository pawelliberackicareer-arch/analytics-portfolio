# Analytics Portfolio — Paweł Liberacki

This repository shows how I work with data: from a business problem, through SQL and data modelling, to a dashboard or tool that people use every day.
> **About the data:** every project here is **rebuilt on synthetic data**. The logic follows real projects I led in a large-scale logistics operation, but no company data, code or internal names are used.

---

## 🗂️ Projects

| # | Project | What it shows | Tools | Status |
|---|---|---|---|---|
| 01 | [Defect rate & DPMO analysis](./01-defect-rate-dpmo) | Multi-stage joins, removing duplicates, DPMO per employee, threshold flags | SQL | 🚧 In progress |
| 02 | [Process flow & star schema](./02-process-flow-star-schema) | Kimball-style model (facts + dimensions), live flow dashboard | SQL, Power BI | 🚧 Planned |
| 03 | [Procurement analytics](./03-procurement-analytics) | 100,000-row dataset, supplier evaluation, anomaly detection, red flags | Excel, Power Query | 🚧 Planned |
| 04 | [Excel / VBA toolkit](./04-excel-vba-toolkit) | Operational tools with user forms: role assignment, shift handover | Excel, VBA | 🚧 Planned |
| 05 | [Financial diagnostic pack](./05-financial-diagnostic-pack) | KPI traffic lights, exception flags, 24-month projection | Excel, Power BI | 🚧 Planned |
| 06 | [Redshift vs BigQuery](./06-redshift-vs-bigquery) | The same analysis written in two SQL dialects | SQL | 🚧 Planned |

---

## 🧭 How each project is organised

Every folder follows the same structure, so it is easy to scan:

1. **Business problem** — what was wrong and why it mattered
2. **Data** — tables, columns and how the synthetic data was made
3. **Approach** — the plan, in plain language
4. **How I built it** — step by step, with checks after every join
5. **Results** — numbers first
6. **Screenshots** — dashboards and tools in action
7. **What I would do next**

```
0X-project-name/
├── README.md
├── sql/          ← queries, numbered in the order they run
├── data/         ← synthetic data or the script that creates it
├── dashboards/   ← .pbix / .xlsx / .xlsm files
└── img/          ← screenshots and GIFs used in the README
```

---

## 👤 About me

Operations & Data Analyst with people-leadership experience (up to 120 direct reports). More on my [GitHub profile](https://github.com/pawelliberackicareer-arch).

📫 pawelliberackicareer@gmail.com
