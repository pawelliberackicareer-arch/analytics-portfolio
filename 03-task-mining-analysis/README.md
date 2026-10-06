# 03 · Task-Mining Analysis

*Analysis of two productivity dashboards from a process / task-mining tool, for a fictional shared-services centre.*

> ✅ **Status:** done · **Skills:** reading dashboards critically, process ownership, KPI thresholds, change management · **Tools:** Task / process-mining dashboards

> 📁 **Case study series:** this is one of three parts of a case study for an **Automation Business Analyst** role (2026): [01 Automation prioritisation](../01-automation-prioritisation) · [02 Process map](../02-process-map) · [03 Task-mining analysis](../03-task-mining-analysis)
>
> **About the data:** company names, systems, people and numbers are changed, and the case is retold in my own words. The analysis, scoring and recommendations are my own work.

---
## Charts overlook

Chart 1 :
<img width="1259" height="405" alt="image" src="https://github.com/user-attachments/assets/ff0c60ec-bf5c-41b2-b9cb-aa0e915bccf1" />

Chart 2 :
<img width="1279" height="559" alt="image" src="https://github.com/user-attachments/assets/3d616037-cf86-4689-ae0b-8bdee1266309" />

## The task (in my words)

Two dashboards were given: **"Process distribution between teams"** and **"Digital presence of employees within a team"**. The question: what do they say about the processes and teams, and what should be done next, both for further analysis and as concrete actions?

## 1. Summary

| Area | Key finding | Main recommendation |
|---|---|---|
| Dashboards | Both charts are hard to read without context: no method note, unclear units, hidden categories, one day of data | Add a method note, axis titles with units, labels inside the bars and a weekly timeline |
| Processes across teams | The same processes are split between several teams (e.g. Invoice processing in Teams A and C, Collections in all 4), so there is no single owner and likely two or more standards | **One owner team per process**; other teams only support at peak volume and follow the owner's standard |
| Digital presence | Large differences between employees (Active time from 2h 40m to 6h 21m), but based on one day and with some categories hidden | Validate the data first, then look at weekly trends at team level; agree team standards with the team lead |
| Thresholds and flags | The dashboard does not flag anything, so users must spot problems themselves | Team- and process-level thresholds based on a baseline; a flag is a signal to ask questions, not a judgement |

## 2. Making the dashboards readable first

A dashboard is only useful if every reader understands it the same way.

| What is missing in Dashboard 1 | Proposed improvement |
|---|---|
| Percent of what? (time, cases, people) | Method note above the chart: what is measured, period, data source |
| Y-axis and X-axis have no titles; team size not shown | Y-axis: "Share of the team's measured working time (%)"; X-axis: "Team (number of FTE)" |
| Values must be read from the scale | Label inside each segment: process name and % |
| No absolute values | Second view in hours / FTE per process, so a 50% share in a small team is not mistaken for a big workload |

| What is missing in Dashboard 2 | Proposed improvement |
|---|---|
| Date filter shows the whole month, chart shows one day | State the period in the title; default view = weekly timeline |
| Active / Passive / Away are not explained | Short definitions under the legend (e.g. Passive = application open, no keyboard or mouse input) |
| Neutral, Private, Leave/PTO and Not measured are switched off | Show all categories by default, or show a note when some are hidden |
| Role and working hours of each employee unknown | Add role and contracted hours (FTE), so part-time staff are not compared with full-time staff |

## 3. Dashboard 1: processes across teams

Values read from the chart (approximate, share of each team's time):

| Process | Team A | Team B | Team C | Team D | Teams doing it |
|---|---|---|---|---|---|
| Invoice processing (AP) | 43% | — | 54% | — | 2 |
| Order data validation | 12% | 52% | 30% | — | 3 |
| Quote validation | 24% | — | 12% | — | 2 |
| Collections | 3% | 23% | 4% | 40% | **4** |
| Cancellations | 18% | 25% | — | — | 2 |
| Billing adjustments | — | — | — | 60% | 1 |
| **Processes per team** | **5** | **3** | **4** | **2** | |

**What the data suggests:**
- **No single owner for most processes.** Two teams doing the same process usually means two ways of working, different quality and different handling times, and nobody clearly responsible for the standard.
- **Collections is done by all four teams**, and Order data validation by three: the first places to check for different standards.
- **Team A is the most fragmented:** five processes, three under 20% of its time. Switching costs focus and makes training harder.
- **Team D is the most specialised:** efficient, but the only team doing Billing adjustments, a single point of failure.
- **Limit of this chart:** it shows shares, not hours or volumes. All conclusions must be checked with hours and case volumes.

**Recommendation: one owner team per process.**
- **Owner team:** responsible for the standard way of working, documentation, training and KPIs.
- **Supporting team (only if volume requires it):** works strictly to the owner's standard and reports to the same KPIs.
- **Cross-training:** at least one or two trained people outside the owner team for every process.

| Process | Proposed owner (team with the largest share today, to validate) | Note |
|---|---|---|
| Invoice processing (AP) | Team C | Team A supports only at peak, using Team C's standard |
| Order data validation | Team B | Teams A and C hand over or support |
| Quote validation | Team A | |
| Collections | Team D | Small shares in Teams A and C move to Team D |
| Cancellations | Team B | |
| Billing adjustments | Team D | Add a cross-trained backup in another team |

## 4. Dashboard 2: digital presence of employees

Values read from the chart for one day, one team:

| Employee | Active | Passive | Away | Total | Active share |
|---|---|---|---|---|---|
| Employee_A | 6h 21m | 0h 55m | 1h 50m | 9h 06m | 70% |
| Employee_B | 4h 10m | 2h 31m | 2h 10m | 8h 51m | 47% |
| Employee_C | 4h 18m | 3h 04m | 2h 10m | 9h 32m | 45% |
| Employee_D | 3h 01m | 0h 28m | 1h 23m | 4h 52m | 62% |
| Employee_E | 4h 48m | 2h 25m | 1h 39m | 8h 52m | 54% |
| Employee_F | 6h 04m | 0h 53m | 1h 54m | 8h 51m | 69% |
| Employee_G | 4h 31m | 2h 06m | 1h 55m | 8h 32m | 53% |
| Employee_H | 2h 40m | 1h 16m | 1h 16m | 5h 12m | 51% |
| Employee_I, _J | no data | no data | no data | — | — |
| **Average (8 people)** | **4h 29m** | **1h 42m** | **1h 47m** | | |

**What the data suggests:**
- **Very large differences between employees:** Active time from 2h 40m to 6h 21m, Passive from 28 minutes to over 3 hours. If these people have the same role, there is **no common standard** for how the work and the day are organised.
- **Two clear patterns:** Employees A and F have high Active and little Passive time; Employees B, C, E and G have 2–3 hours of Passive time.
- **Away time is high for almost everyone** (average ~1h 47m), more than a normal lunch break.
- **Employees D and H have a short day (~5 hours)**, and Employees I and J show no data at all.

**Why the data is not yet enough to act on individuals:**
- **One day only:** a training session, meetings or a system problem can make any single day look unusual.
- **Hidden categories:** Leave/PTO, Private, Neutral and Not measured are switched off, which most likely explains the short or missing days.
- **Roles and contracted hours are unknown:** part-time staff cannot be compared one to one.
- **Passive and Away are not "doing nothing":** Passive can be reading documents or waiting for a slow system; Away can be meetings, phone calls or paper-based work.

So the differences are a strong reason to **investigate**, not yet a reason for corrective action against specific people.

## 5. Proposed weekly view

- **X-axis:** weeks. **Y-axis:** average hours per working day (Active, Passive, Away), leave days excluded.
- **Team view first:** if the whole team changes in the same week, the cause is usually a system or workload change, not people.
- **Spread inside the team:** without names on the main view; details available to the team lead when needed.
- **Flag only after a lasting change:** outside the agreed range for 2–3 weeks in a row, not a single day.

## 6. Thresholds and flags

| KPI (team or process level) | How the threshold is set | Flag rule |
|---|---|---|
| Away time per working day (team average) | Range agreed with management, checked against a 2–3 month baseline | Above the range 2–3 weeks in a row |
| Passive time per working day (team average) | Team baseline (median of several months) | Clearly above baseline 2–3 weeks in a row → drill into applications |
| Handling time per case, per process | Best-performing team for the same process | A team clearly slower than the owner standard |
| Measurement coverage | % of employees with data on a working day | Below e.g. 90% → fix the data before analysis |
| Process split between teams | Owner model (section 3) | A process spreading to a new team without agreement |

**Rules for using the flags:** team and process level first (flags point to *where* to look, not *who* to blame); thresholds come from data and are reviewed every quarter; a flag is always read together with output data (cases closed per process).

## 7. Recommendations: further analysis

1. **Validate the data:** at least one full month, all categories switched on, role and contracted hours (FTE) for each employee.
2. **Move to weekly views** for presence data and add hours / FTE per process for Dashboard 1.
3. **Combine time data with output data** (cases closed per process). Productivity is output per hour, not time at the computer.
4. **Compare the same process across teams:** handling time, number of steps and rework. The best team's way of working becomes the standard.
5. **Drill into Passive time by application** to find slow systems, waiting time and copy-paste work, often automation opportunities.
6. **Run a team workshop** on what takes time away from the computer.

## 8. Recommendations: actions

- **Introduce process ownership:** one owner team per process, support only at peak, one standard per process.
- **Reduce fragmentation in Team A** by handing over its smallest processes to the owner teams.
- **Build cross-training** so single-team processes always have a trained backup.
- **Agree team standards with the team lead** once the data is validated, set together with the team, not imposed from one day of data.
- **Look at individual differences only if they remain** after the full analysis, through the normal line-manager conversation.
- **Shortlist automation candidates** from the Passive-time drill-down and from high-volume processes shared by several teams.
- **Communicate clearly** that task mining is used to improve processes, not to watch individuals. This builds trust, gives better data and supports GDPR and employee-representation rules.
- **Set a baseline now** so the effect of every change can be measured later.

## 9. Suggested timeline

| When | What |
|---|---|
| Weeks 1–2 | Data validation; dashboard improvements (method note, axes, labels, all categories) |
| Weeks 3–4 | Weekly view and baseline; first comparison of shared processes across teams |
| Month 2 | Team workshops; agree process owners and team standards; Passive-time drill-down |
| Month 3 | Thresholds and flags live; automation shortlist; first measurement against the baseline |

## 10. Questions for the client

- What does the percentage in Dashboard 1 measure: time, cases or people? How many FTE does each team have?
- Do all employees in the presence dashboard have the same role and contracted hours?
- Why were some categories (Leave/PTO, Not measured) switched off in the view?
- Is case volume per process available, so time can be compared with output?
- Have employees and their representatives been informed about how task-mining data is used?

---
[← Back to all projects](../README.md)
