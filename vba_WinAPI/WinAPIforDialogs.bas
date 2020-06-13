Attribute VB_Name = "WinAPIforDialogs"
Option Explicit

'TaskDialog �̈����p�̗񋓌^�B
    '�Q�l:https://memos-by-oxalis.hatenablog.com/entry/2019/09/22/223121
Public Enum TaskDialogButtons
    tdOK = 2 ^ 0
    tdYes = 2 ^ 1
    tdNo = 2 ^ 2
    tdCancel = 2 ^ 3 '�ݒ肵�Ȃ��Ɓ~�{�^�����\������Ȃ��B
    tdRetry = 2 ^ 4
    tdClose = 2 ^ 5
    
    tdOKCancel = tdOK Or tdCancel
    tdRetryCancel = tdRetry Or tdCancel
    tdYesNo = tdYes Or tdNo
    tdYesNoCancel = tdYes Or tdNo Or tdCancel
End Enum

Public Enum TaskDialogIcons
    tdNone = 0&
    tdWarning = &HFFFF&     '���F�́�!  vbExclamation �Ƃ��Ɠ����B
    tdError = &HFFFE&       '�ԐF�́��~ vbCritical �Ƃ��Ɠ����B
    tdInformation = &HFFFD& '�F�́�i  vbInformation �Ƃ��Ɠ����B
    tdShield = &HFFFC&
End Enum

Private Enum HRESUT
    S_OK = 0&
End Enum

Private Declare PtrSafe Function _
    TaskDialog Lib "Comctl32.dll" ( _
        ByVal hwndOwner As LongPtr, _
        ByVal hInstance As LongPtr, _
        ByVal pszWindowTitle As LongPtr, _
        ByVal pszMainInstruction As LongPtr, _
        ByVal pszContent As LongPtr, _
        ByVal dwCommonButtons As TaskDialogButtons, _
        ByVal pszIcon As LongPtr, _
        ByRef pnButton As VBA.VbMsgBoxResult _
    ) As HRESUT

'���̃v���Z�X�ōőO�ʂɂ���E�B���h�E�̃n���h�����擾����B
Private Declare PtrSafe Function _
    GetActiveWindow Lib "User32.dll" ( _
    ) As LongPtr

Public Function ShowTaskDialog( _
                 ByVal inContent As String, _
        Optional ByVal inButtons As TaskDialogButtons = TaskDialogButtons.tdOKCancel, _
        Optional ByVal inIcon As TaskDialogIcons = TaskDialogIcons.tdInformation, _
        Optional ByVal inTitle As String, _
        Optional ByVal inHeader As String, _
        Optional ByVal inParentHwnd As LongPtr = 0 _
    ) As VBA.VbMsgBoxResult
Rem .DESCRIPTION
Rem TaskDialog ��\������B
Rem .PARAMETER inContent
Rem �_�C�A���O���ɕ\�����郁�b�Z�[�W�B
Rem .PARAMETER inButtons
Rem �\������{�^���B�ȗ����́uOK�v�{�^���Ɓu�L�����Z���v�{�^�����\�������B
Rem .PARAMETER inIcon
Rem �^�C�g���ƃ_�C�A���O���ɕ\������A�C�R���B�ȗ����͐́���i�̃A�C�R���B
Rem .PARAMETER inTitle
Rem �_�C�A���O�̃^�C�g���ɕ\������镶����B�ȗ����̓z�X�g�A�v���P�[�V�����̃t�@�C����(Excel�ł����"EXCEL.EXE")�B
Rem .PARAMETER inHeader
Rem �_�C�A���O���Ő��ŕ\������镶����B�ȗ����͕\������Ȃ��B
Rem .PARAMETER inParentHwnd
Rem �e�Ƃ���E�B���h�E�̃n���h���B�ȗ����͂��̃v���Z�X�̍őO�ʂ̃E�B���h�E���e�ƂȂ�B
Rem .OUTPUTS
Rem ���[�U�[���������{�^���B
    
    '�e�E�B���h�E���w�肳��Ȃ������ꍇ�A���̃v���Z�X�̍őO�ʂ̃E�B���h�E��e�Ƃ���B
    If inParentHwnd = 0 Then inParentHwnd = GetActiveWindow()
    
    Const NullHInstance = 0
    Dim hr As HRESUT
    hr = TaskDialog( _
            inParentHwnd, _
            NullHInstance, _
            VBA.[_HiddenModule].StrPtr(inTitle), _
            VBA.[_HiddenModule].StrPtr(inHeader), _
            VBA.[_HiddenModule].StrPtr(inContent), _
            inButtons, _
            inIcon, _
            ShowTaskDialog _
        )
    Debug.Assert hr = S_OK
End Function
