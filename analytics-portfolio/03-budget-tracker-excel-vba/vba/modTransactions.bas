Attribute VB_Name = "modTransactions"
Option Explicit
' =====================================================================
' modTransactions | add and sort transactions
' All data lives in one Excel table: tTransactions (sheet Transactions).
' Columns A-D are typed in; Type, Month and Year are formulas in the table.
' =====================================================================

' Opens the "Add transaction" form (button on the Dashboard / Start sheet)
Public Sub ShowAddForm()
    frmAddTransaction.Show
End Sub

' Adds one row to the end of tTransactions.
' The table copies the formulas for Type, Month and Year to the new row by itself.
Public Sub AddTransaction(ByVal txDate As Date, ByVal category As String, _
                          ByVal amount As Double, ByVal note As String)
    Dim tbl As ListObject
    Dim newRow As ListRow

    Set tbl = ThisWorkbook.Worksheets("Transactions").ListObjects("tTransactions")
    Set newRow = tbl.ListRows.Add

    With newRow.Range
        .Cells(1, tbl.ListColumns("Date").Index).Value = txDate
        .Cells(1, tbl.ListColumns("Category").Index).Value = category
        .Cells(1, tbl.ListColumns("Amount").Index).Value = amount
        .Cells(1, tbl.ListColumns("Note").Index).Value = note
    End With
End Sub

' Sorts all transactions by date (oldest first)
Public Sub SortTransactions()
    Dim tbl As ListObject
    Set tbl = ThisWorkbook.Worksheets("Transactions").ListObjects("tTransactions")

    With tbl.Sort
        .SortFields.Clear
        .SortFields.Add Key:=tbl.ListColumns("Date").DataBodyRange, _
                        SortOn:=xlSortOnValues, Order:=xlAscending
        .Header = xlYes
        .Apply
    End With
End Sub

' Deletes every transaction after the user confirms (to start with own data)
Public Sub ClearDemoData()
    Dim tbl As ListObject
    Dim answer As VbMsgBoxResult

    answer = MsgBox("Delete ALL transactions?" & vbCrLf & _
                    "Categories and settings stay as they are.", _
                    vbYesNo + vbExclamation, "Clear demo data")
    If answer <> vbYes Then Exit Sub

    Set tbl = ThisWorkbook.Worksheets("Transactions").ListObjects("tTransactions")
    If tbl.ListRows.Count > 0 Then tbl.DataBodyRange.Delete
    MsgBox "All transactions deleted.", vbInformation, "Clear demo data"
End Sub
