# Setup: turn the workbook into a macro-enabled file

1. Open `workbook/Budget-Tracker.xlsx` and save it as **Excel Macro-Enabled Workbook (`.xlsm`)**.
2. Press **Alt + F11** to open the VBA editor.
3. **File → Import File…** and import `vba/modTransactions.bas` and `vba/modDashboard.bas`.

## Build the form
4. **Insert → UserForm**. In the Properties window set **(Name)** = `frmAddTransaction`, **Caption** = `Add transaction`.
5. Add these controls (Toolbox) and set their **(Name)**:

| Control | (Name) | Settings |
|---|---|---|
| Label | – | Caption `Date (yyyy-mm-dd)` |
| TextBox | `txtDate` | |
| Label | – | Caption `Category` |
| ComboBox | `cboCategory` | **Style** = `2 - fmStyleDropDownList` |
| Label | – | Caption `Amount (PLN)` |
| TextBox | `txtAmount` | |
| Label | – | Caption `Note` |
| TextBox | `txtNote` | |
| Label | `lblStatus` | Caption empty, ForeColor green |
| CommandButton | `btnSave` | Caption `Save`, **Default** = True (Enter saves) |
| CommandButton | `btnClose` | Caption `Close`, **Cancel** = True (Esc closes) |

6. Right-click the form → **View Code**, delete what is there and paste the code from `vba/frmAddTransaction.code.vba`.

## Add the buttons
7. On the **Dashboard** sheet: **Insert → Shapes → Rounded Rectangle**, type the text, right-click → **Assign Macro**:

| Button text | Macro |
|---|---|
| ➕ Add transaction | `ShowAddForm` |
| ◀ Previous | `PreviousMonth` |
| Next ▶ | `NextMonth` |
| 💾 Save month report | `SaveMonthReport` |
| 📄 Export PDF | `ExportDashboardPDF` |

On the **Transactions** sheet add `Sort by date` → `SortTransactions`. On the **Start** sheet add `Clear demo data` → `ClearDemoData`.

8. Save. Test: add a transaction with the form, change the month, save a month report, export a PDF.
