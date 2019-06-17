Attribute VB_Name = "DisableExcelGlobal"
'Excel�̃O���[�o���ȃ����o�[�𖳌������郂�W���[��
'https://qiita.com/nukie_53/items/4e9226ac8f747e772afd

Option Explicit
Option Private Module

'�e�𖾎����Ȃ��Ɗ�Ȃ����́A�g�p�p�x���Ⴛ���ȃ����o�[(���)�̒�`���㏑��(������)�B
'��ʊK�w�̃v���p�e�B��֐��I�ȃ��\�b�h�݂̂��c��B
'Excel���Ŏg���p�B
#Const DisableForInternal = True

'�قƂ�ǂ̃����o�[�̒�`���㏑��(������)�B
'Excel�ȊO��VBA�z�X�g����Excel�𑀍삷��Ƃ��p�B
#Const DisableForExternal = True

'Public Sub Application(): End Sub

#If DisableForInternal Or DisableForExternal Then

'Method override
Public Sub Calculate(a): End Sub
Public Sub DDEExecute(): End Sub
Public Sub DDEInitiate(): End Sub
Public Sub DDEPoke(): End Sub
Public Sub DDERequest(): End Sub
Public Sub DDETerminate(): End Sub

'Property override
Public Sub ActiveCell(): End Sub
Public Sub ActiveChart(): End Sub
Public Sub ActivePrinter(): End Sub
Public Sub ActiveSheet(): End Sub
Public Sub ActiveWindow(): End Sub
Public Sub ActiveWorkbook(): End Sub
Public Sub AddIns(): End Sub
Public Sub Cells(): End Sub
Public Sub Charts(): End Sub
Public Sub Columns(): End Sub
Public Sub CommandBars(): End Sub
Public Sub Creator(): End Sub
Public Sub DDEAppReturnCode(): End Sub
Public Sub Excel4IntlMacroSheets(): End Sub
Public Sub Excel4MacroSheets(): End Sub
Public Sub Names(): End Sub
Public Sub Parent(): End Sub
Public Sub Range(): End Sub
Public Sub Rows(): End Sub
Public Sub Selection(): End Sub
Public Sub Sheets(): End Sub
Public Sub Worksheets(): End Sub

'Hidden Property
Public Sub ActiveDialog(): End Sub
Public Sub ActiveMenuBar(): End Sub
Public Sub Assistant(): End Sub
Public Sub DialogSheets(): End Sub
Public Sub MenuBars(): End Sub
Public Sub Modules(): End Sub
Public Sub ShortcutMenus(): End Sub
Public Sub Toolbars(): End Sub
#End If


#If DisableForExternal Then
'�ŏ�ʃN���X�̃v���p�e�B��֐��I�Ɏg���郁�\�b�h�Q

'Method override
Public Sub Evaluate(): End Sub
Public Sub ExecuteExcel4Macro(): End Sub
Public Sub Intersect(): End Sub
Public Sub Run(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z): End Sub
'Public Sub SendKeys(): End Sub 'VBA has SendKeys method.
Public Sub Union(): End Sub

'Property override
Public Sub ThisWorkbook(): End Sub
Public Sub Windows(): End Sub
Public Sub Workbooks(): End Sub
Public Sub WorksheetFunction(): End Sub
#End If
