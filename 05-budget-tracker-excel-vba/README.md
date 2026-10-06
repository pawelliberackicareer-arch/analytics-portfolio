# 05 · Personal Budget Tracker (Excel + VBA)

> ✅ **Status:** workbook and VBA code done · **Tools:** Excel (tables, SUMIFS, named ranges, data validation, conditional formatting, charts), VBA (UserForm, ListObject, PDF export) · **Data:** invented demo data

## Dashboard preview

<img width="1486" height="1055" alt="image" src="https://github.com/user-attachments/assets/c6553282-93eb-4c09-b2a1-a241e8156ad9" />
<img width="1339" height="843" alt="image" src="https://github.com/user-attachments/assets/7eef38e9-9a24-4be6-9557-b0c02aa2f6a5" />

## Business problem
I tracked my own spending in a large Excel sheet: one column per day (almost 500 columns), one row per category, and summary formulas that scanned the whole row up to the last Excel column. It worked, but it was slow, hard to read for anyone else, and easy to break: the balance formula was typed by hand in each column and was not the same everywhere.

**Goal:** rebuild it so that anyone can use it: one simple place to enter data, one dashboard to read, and buttons for the repetitive work.

## Before → after

| | Before | After |
|---|---|---|
| Data layout | Wide: 1 column per day, ~500 columns | **Long:** one row per transaction in an Excel table |
| Adding data | Find the right day column and category row | **Form** with a category list, or type one row |
| Summary formulas | `SUMPRODUCT` over whole rows to the last column | `SUMIFS` on table columns, fast and readable |
| Balance | Hand-typed formula per column, not the same in every column | **One rule** for every month, explained on the sheet |
| Budget | None | Monthly budget per category, with traffic-light colours |
| Settings | Values scattered in column A | One **Settings** sheet with **named ranges** (`Year`, `OpenBalance`, …) |
| Repetitive work | Manual | **Macros:** add, sort, change month, save month report, export PDF |

## Workbook structure

| Sheet | What it does |
|---|---|
| `Start` | How to use the file and what each button does |
| `Dashboard` | Pick a month: 8 KPIs, expenses by category vs budget, the whole year month by month, 3 charts |
| `Transactions` | Table `tTransactions`: date, category, amount, note. Type, month and year fill in by themselves |
| `Categories` | Table `tCategories`: category, type, monthly budget |
| `Settings` | Year, opening balances, income target, money I owe |

**Balance logic (the same for every month):**
- Account balance = opening balance + income + money paid back to me − expenses − investments − loan payments − money lent
- Net worth = account balance + investments − loan left − money I owe
- Money moved to investments or used for the loan is **not** counted as an expense, but it lowers the account balance.

## VBA

| Macro | What it does |
|---|---|
| `ShowAddForm` | Opens the **Add transaction** UserForm (category list from the table, today's date, simple checks before saving; the form stays open for the next entry) |
| `AddTransaction` | Adds one row to `tTransactions` with `ListRows.Add`; the table fills in its formula columns by itself |
| `SortTransactions` | Sorts the table by date |
| `NextMonth` / `PreviousMonth` | Moves the dashboard one month forward or back |
| `SaveMonthReport` | Copies the month's KPIs and category table to a new sheet **as values** (screen updating and calculation are switched off while it runs, so it is fast and does not flicker) |
| `ExportDashboardPDF` | Saves the dashboard as `Budget YYYY-MM.pdf` next to the workbook |
| `ClearDemoData` | Deletes all transactions after a Yes/No question |

Code: [`vba/modTransactions.bas`](vba/modTransactions.bas) · [`vba/modDashboard.bas`](vba/modDashboard.bas) · [`vba/frmAddTransaction.code.vba`](vba/frmAddTransaction.code.vba)

## How to set it up
GitHub shows `.xlsm` files only as a download, so the code is kept as text files. Setup takes about 10 minutes: see [`SETUP.md`](SETUP.md).

## What I would do next
- Import a bank statement (CSV) with Power Query instead of typing transactions
- Add a "this month vs same month last year" view

---
[← Back to all projects](../README.md)
