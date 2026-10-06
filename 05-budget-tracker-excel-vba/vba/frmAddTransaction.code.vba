' =====================================================================
' frmAddTransaction | code behind the "Add transaction" UserForm
' Build the form by hand (see FORM-GUIDE.md), then paste this code into
' the form's code window (right-click the form > View Code).
'
' Controls used:
'   txtDate      TextBox      date of the transaction
'   cboCategory  ComboBox     list of categories (Style = 2 - fmStyleDropDownList)
'   txtAmount    TextBox      amount in PLN
'   txtNote      TextBox      optional note
'   lblStatus    Label        shows "Saved" after each entry
'   btnSave      CommandButton
'   btnClose     CommandButton
' =====================================================================
Option Explicit

' Runs when the form opens: fill the category list and set today's date
Private Sub UserForm_Initialize()
    Dim cell As Range
    For Each cell In ThisWorkbook.Worksheets("Categories") _
                      .ListObjects("tCategories").ListColumns("Category").DataBodyRange
        Me.cboCategory.AddItem cell.Value
    Next cell
    Me.txtDate.Value = Format(Date, "yyyy-mm-dd")
    Me.lblStatus.Caption = ""
End Sub

' Save one transaction and keep the form open for the next one
Private Sub btnSave_Click()
    ' Simple checks before saving
    If Not IsDate(Me.txtDate.Value) Then
        MsgBox "Please enter a valid date (yyyy-mm-dd).", vbExclamation
        Exit Sub
    End If
    If Me.cboCategory.ListIndex = -1 Then
        MsgBox "Please choose a category.", vbExclamation
        Exit Sub
    End If
    If Not IsNumeric(Me.txtAmount.Value) Then
        MsgBox "Please enter the amount as a number.", vbExclamation
        Exit Sub
    End If

    AddTransaction CDate(Me.txtDate.Value), Me.cboCategory.Value, _
                   CDbl(Me.txtAmount.Value), Me.txtNote.Value

    Me.lblStatus.Caption = "Saved: " & Me.cboCategory.Value & " " & Me.txtAmount.Value & " PLN"
    Me.txtAmount.Value = ""
    Me.txtNote.Value = ""
    Me.txtAmount.SetFocus
End Sub

Private Sub btnClose_Click()
    Unload Me
End Sub
