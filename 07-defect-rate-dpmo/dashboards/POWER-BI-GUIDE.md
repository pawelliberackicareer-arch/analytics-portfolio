# Power BI Report: Build Guide

This guide builds the management report for the DPMO project. Every number is already calculated in SQL, so the report needs **no calculated measures**: only data modelling, visuals and formatting.

## 1. Load the data

**Option A: CSV files.** *Get Data → Text/CSV*, load every file from [`../data`](../data):

| File | Used for |
|---|---|
| `vw_department_week.csv` | KPI cards, DPMO trend |
| `vw_shift_week.csv` | DPMO by shift |
| `vw_manager_week.csv` | DPMO by manager |
| `vw_top_offenders.csv` | Top offenders table |
| `vw_incorrect_trend.csv` | Incorrect escalations trend |
| `vw_segment_week.csv` | Tenure and employment-type split |
| `vw_corrective_actions.csv` | Audit and action log |
| `vw_person_week.csv` | Drill-through detail |
| `calendar_weeks.csv`, `managers.csv`, `employees.csv` | Dimension tables |

**Option B: database.** *Get Data → PostgreSQL* (or Amazon Redshift) and select the same views.

## 2. Data model

- `calendar_weeks[report_week]` → `report_week` in every weekly view (one-to-many)
- `managers[manager_login]` → `vw_manager_week`, `vw_person_week`, `vw_corrective_actions`
- `employees[login]` → `vw_person_week`, `vw_top_offenders`, `vw_corrective_actions`
- Set `report_week` to **Don't summarize** in every table.
- **Important:** DPMO and percentage columns must use **Don't summarize** (or *Average* on a single row). A ratio is never added up.

## 3. Pages

### Page 1 · Overview
- **Slicer:** `calendar_weeks[report_week]` (between)
- **Cards:** latest-week `dpmo`, `incorrect_escalations`, `people_above_threshold`, `audits_done` (filter the card visual to the last week)
- **Line chart:** X = `report_week`; Y = `dpmo` and `dpmo_threshold` (threshold as a dashed red line)
- **Column chart:** `incorrect_escalation_pct` by week

### Page 2 · Shifts & managers
- **Line chart:** `vw_shift_week`, X = week, Y = `dpmo`, legend = `shift`
- **Matrix:** rows = `manager_login`, columns = `report_week`, values = `dpmo`; conditional formatting: background colour rules (green < 3,000, amber 3,000–5,000, red > 5,000)

### Page 3 · Top offenders
- **Table:** `vw_top_offenders`, sorted by `offender_rank`; Top N filter = 15
- Columns: login, manager, shift, `dpmo_period`, `dpmo_last_4_weeks`, `weeks_flagged`, `audits_failed`, `current_disciplinary_step`
- Conditional formatting: data bars on `dpmo_period`, icons on `current_disciplinary_step`
- **Drill-through** to a person page built on `vw_person_week` (weekly rate vs peer rate)

### Page 4 · Incorrect escalations trend
- **Column chart:** `incorrect_escalations` by week
- **Line:** `cumulative_incorrect`
- **Table:** `change_vs_prev_week`, `change_vs_prev_week_pct` (red up arrow / green down arrow)

### Page 5 · Corrective actions
- **Table:** `vw_corrective_actions` (week, login, manager, errors found, result, action, step, follow-up week)
- **Stacked column chart:** count of actions by week, legend = `corrective_action`
- **Slicer:** `manager_login`

## 4. Publish
- Publish to the Power BI Service workspace, set a weekly scheduled refresh, and share the report link with management.
- Save screenshots of pages 1–3 in [`../img`](../img) and add them to the project README.
