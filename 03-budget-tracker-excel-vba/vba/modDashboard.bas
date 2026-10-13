Attribute VB_Name = "modDashboard"
Option Explicit
' =====================================================================
' modDashboard | month navigation, month report, PDF export
' The selected month is the named cell SelMonth (Dashboard!C4).
' =====================================================================

Public Sub NextMonth()
    With ThisWorkbook.Names("SelMonth").RefersToRange
        If .Value < 12 Then .Value = .Value + 1
    End With
End Sub

Public Sub PreviousMonth()
    With ThisWorkbook.Names("SelMonth").RefersToRange
        If .Value > 1 Then .Value = .Value - 1
    End With
End Sub

' Copies the selected month's KPIs and category table to a new sheet
' as VALUES, so the numbers stay the same even if transactions change later.
Public Sub SaveMonthReport()
    Dim wsDash As Worksheet, wsRep As Worksheet
    Dim sheetName As String
    Dim yearNo As Long, monthNo As Long

    Set wsDash = ThisWorkbook.Worksheets("Dashboard")
    yearNo = ThisWorkbook.Names("Year").RefersToRange.Value
    monthNo = ThisWorkbook.Names("SelMonth").RefersToRange.Value
    sheetName = "Report " & yearNo & "-" & Format(monthNo, "00")

    ' Faster and without flicker while the macro runs
    Application.ScreenUpdating = False
    Application.Calculation = xlCalculationManual

    ' Replace the report if this month was saved before
    If SheetExists(sheetName) Then
        Application.DisplayAlerts = False
        ThisWorkbook.Worksheets(sheetName).Delete
        Application.DisplayAlerts = True
    End If

    Set wsRep = ThisWorkbook.Worksheets.Add(After:=ThisWorkbook.Worksheets(ThisWorkbook.Worksheets.Count))
    wsRep.Name = sheetName

    ' Title, KPI tiles (rows 7-8) and category table (rows 11-20) as values + formats
    wsDash.Range("B2:K2").Copy
    wsRep.Range("B2").PasteSpecial xlPasteValuesAndNumberFormats
    wsRep.Range("B2").PasteSpecial xlPasteFormats
    wsRep.Range("B4").Value = "Month report: " & wsDash.Range("D4").Value
    wsRep.Range("B5").Value = "Saved on " & Format(Now, "yyyy-mm-dd hh:mm")

    wsDash.Range("B7:J8").Copy
    wsRep.Range("B7").PasteSpecial xlPasteValuesAndNumberFormats
    wsRep.Range("B7").PasteSpecial xlPasteFormats

    wsDash.Range("B11:H20").Copy
    wsRep.Range("B11").PasteSpecial xlPasteValuesAndNumberFormats
    wsRep.Range("B11").PasteSpecial xlPasteFormats

    Application.CutCopyMode = False
    wsRep.Columns("B:K").ColumnWidth = 14
    wsRep.Columns("B").ColumnWidth = 20
    ActiveWindow.DisplayGridlines = False

    Application.Calculation = xlCalculationAutomatic
    Application.ScreenUpdating = True
    wsRep.Range("A1").Select
    MsgBox "Saved as sheet """ & sheetName & """.", vbInformation, "Month report"
End Sub

' Saves the Dashboard as a PDF in the same folder as this workbook
Public Sub ExportDashboardPDF()
    Dim filePath As String
    Dim yearNo As Long, monthNo As Long

    If ThisWorkbook.Path = "" Then
        MsgBox "Save the workbook first, then export.", vbExclamation, "Export PDF"
        Exit Sub
    End If

    yearNo = ThisWorkbook.Names("Year").RefersToRange.Value
    monthNo = ThisWorkbook.Names("SelMonth").RefersToRange.Value
    filePath = ThisWorkbook.Path & Application.PathSeparator & _
               "Budget " & yearNo & "-" & Format(monthNo, "00") & ".pdf"

    ThisWorkbook.Worksheets("Dashboard").ExportAsFixedFormat _
        Type:=xlTypePDF, Filename:=filePath, Quality:=xlQualityStandard, _
        IncludeDocProperties:=False, OpenAfterPublish:=True
End Sub

' True if a sheet with this name exists in the workbook
Private Function SheetExists(ByVal sheetName As String) As Boolean
    Dim ws As Worksheet
    For Each ws In ThisWorkbook.Worksheets
        If ws.Name = sheetName Then
            SheetExists = True
            Exit Function
        End If
    Next ws
    SheetExists = False
End Function
