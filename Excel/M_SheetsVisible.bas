Attribute VB_Name = "M_SheetsVisible"
Option Explicit

Private Sub SheetsVisibleSample()
    '�V�[�g3���̃u�b�N��p�ӁB
    Dim wb As Excel.Workbook
    Set wb = Workbooks.Add(XlWBATemplate.xlWBATWorksheet)
    wb.Worksheets.Add
    wb.Worksheets.Add
    
    Stop
    
    '1, 3�Ԗڂ̃V�[�g�̏W�����擾�B
    Dim shts As Excel.Sheets
    Set shts = wb.Worksheets.Item(VBA.Array(1, 3))
    
    '������ʏ��\����OK(1, 3�Ԗڂ̃V�[�g����\���ɂȂ�)�B
    shts.Visible = XlSheetVisibility.xlSheetHidden
    
    '�ȉ���NG
    '�\��������...
    shts.Visible = XlSheetVisibility.xlSheetVisible
    '�蓮����ŕ\���ł��Ȃ�������...
    shts.Visible = XlSheetVisibility.xlSheetVeryHidden
    
End Sub
