# 06· Private Budget Planner (Poland)

> ✅ **Status:** live · **Tools:** HTML, plain JavaScript, SVG charts (one file, no libraries) · 🔗 **[Open the dashboard](https://pawelliberackicareer-arch.github.io/Private-Budget-Dashboard/)** · 📁 **[Source code](https://github.com/pawelliberackicareer-arch/Private-Budget-Dashboard)**
## Dashboard Preview

<img width="1171" height="1228" alt="image" src="https://github.com/user-attachments/assets/493153b2-c80b-4c36-afa4-e4ef0eeb92d8" />
<img width="1145" height="1159" alt="image" src="https://github.com/user-attachments/assets/11737ef7-93ff-437f-a4c0-8403423dc258" />
<img width="1179" height="777" alt="image" src="https://github.com/user-attachments/assets/739604f5-42ba-4e2b-8105-fe473bcb10a9" />
<img width="1046" height="1173" alt="image" src="https://github.com/user-attachments/assets/a7974ce5-ebb4-4ab8-87b6-8847dc596460" />

## Business problem
Most budget tools show what you already spent. Planning ahead in Poland needs more: take-home pay after ZUS and tax, the PIT-0 tax-free limit for people under 26, and a view of savings, investments and net worth over the year.

**Goal:** a planning dashboard that answers "what if?" in seconds: change a cost or your pay with a slider and see the effect on the whole year.

> **Planner vs tracker:** this project plans the **future** year. [Project 05](../05-budget-tracker-excel-vba) tracks what was **actually** spent.

## What it does

| Feature | What the user sees |
|---|---|
| **City and profile presets** | 19 Polish cities, type of home and age; typical costs filled in for that city (rent, bills, food, car, other) |
| **Monthly budget with sliders** | Costs (investments, food, rent and bills, loan, car and fuel, other) and income; salary as net or gross |
| **Take-home pay** | ZUS, health insurance and income tax for an employment contract, 2026 rules |
| **PIT-0 tracker (under 26)** | The month you go over the 85,528 PLN tax-free limit, pay before and after, tax back in the yearly return |
| **Monthly balance** | What is left each month, how pay is split between costs, savings rate, warning when costs are higher than income |
| **Bank account** | Balance on 1 January, then month by month |
| **Net worth** | Own investments, other assets and liabilities, each with its value, monthly payment and yearly rate; assets, liabilities and net worth for every month |
| **Investment forecast** | Growth over 1 to 30 years with compound return |
| **Tax relief finder** | Any year from 2019: which Polish tax reliefs fit the user (PIT-0, IKZE, IKE, child relief and more), with an estimate of the saving where possible |

**Also:** Polish and English, light and dark mode, works on phone and desktop. Nothing is saved, so every visit starts clean (privacy by design).

## What this project shows
- Translating **tax and payroll rules** into clear calculations
- **Scenario planning:** every input changes the whole 12-month picture at once
- **Dashboard design** for non-experts: sliders, presets and warnings instead of formulas
- Building a complete, shareable tool as **one file** with no dependencies

> This is a planning tool, not tax advice.

---
[← Back to all projects](../README.md)
