# Analytics Portfolio — Paweł Liberacki

This repository shows how I work: from a business problem, through process analysis and data, to a dashboard, a tool or a clear recommendation.

> **About the data:** no real company data is used. Case studies are retold in my own words with changed names and numbers, and datasets are anonymised or synthetic. Shares, trends and conclusions are kept, so the analysis stays the same.

---

## 🗂️ Projects

| # | Project | What it shows | Tools | Status |
|---|---|---|---|---|
| 01 | [Automation prioritisation](./01-automation-prioritisation) | Scoring model for 4 processes, ranking, roadmap, "fix first, automate second" solution design | Excel, Power Query, SharePoint, RPA concepts | ✅ Done |
| 02 | [Process map (BPMN)](./02-process-map) | Swimlane map of a manual process, weak points, to-be idea | BPMN, draw.io, Mermaid | ✅ Done |
| 03 | [Task-mining analysis](./03-task-mining-analysis) | Critical reading of productivity dashboards, process ownership, KPI thresholds | Task-mining dashboards | ✅ Done |
| 04 | [Procurement intelligence dashboard](./04-procurement-dashboard) | 100,000 transactions, anomaly detection (μ+2σ, split orders), supplier risk scorecard, red flags | Excel | ✅ Done |
| 05 | [Personal budget tracker](./05-budget-tracker-excel-vba) | Wide sheet rebuilt into a table-based tracker: budget vs actual, balance and net worth, UserForm and macros | Excel, VBA | ✅ Done |
| 06 | [Private budget planner](./06-budget-planner-dashboard) | Live web dashboard: take-home pay after ZUS and tax, PIT-0 tracker, net worth, tax relief finder | HTML, JavaScript, SVG | ✅ Live |
| 07 | [Defect rate & DPMO](./07-defect-rate-dpmo) | 3-stage SQL pipeline (458k units), over-escalation flags vs peers, DPMO, audit queue, corrective actions, Power BI report | SQL, Power BI | ✅ SQL done · Power BI in progress |

> Projects 01–03 are three parts of one case study for an Automation Business Analyst role.

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
