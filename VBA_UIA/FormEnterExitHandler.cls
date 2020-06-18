VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "FormEnterExitHandler"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'UIAutomation �� FocusChange �C�x���g���g���āA
'���[�U�[�t�H�[���� Enter/Exit �C�x���g���[���I�ɍČ�����N���X�B

'���ӎ���
    '- �Q�Ɛݒ�Ƃ��� UIAutomationClient(C:\Windows\System32\UIAutomationCore.dll)���K�{�B
    '- �I�u�W�F�N�g�̃v���p�e�B�́uInstancing�v���u2- PublicNotCreatable�v�ɕύX���Ă������ƁB

'Events
    'FocusChanged   :�Ď��Ώۂ̃��[�U�[�t�H�[�����Ńt�H�[�J�X�̈ړ����N�����Ƃ��ɔ�������C�x���g�B
    
'Methods
    'Bind   :���[�U�[�t�H�[�������̃N���X�̊Ď��ΏۂƂ��Đݒ肷��B
    'Dispose:�C�x���g�w�ǂ𒆎~����B�ł��邾�����[�U�[�t�H�[�������O�ɌĂ�ł��������B
    
Option Explicit

'�Ď��Ώۂ̃��[�U�[�t�H�[�����Ńt�H�[�J�X�̈ړ����N�����Ƃ��ɔ�������C�x���g�B
'CurrentFocusedControl  :���݃t�H�[�J�X����Ă���R���g���[��(=Enter)�B
'PreviousFocusedControl :���O�Ƀt�H�[�J�X����Ă����R���g���[��(=Exit)�BNothing ���n����邱�Ƃ�����B
Public Event FocusChanged( _
        ByVal CurrentFocusedControl As MSForms.Control, _
        ByVal PreviousFocusedControl As MSForms.Control _
    )

'UIAutomation ����p�̊�{�N���X�B
Private cuia As UIAutomationClient.CUIAutomation

'FocusChangedEvent ���󂯎�邽�߂ɃC���^�[�t�F�C�X����������B
Implements UIAutomationClient.IUIAutomationFocusChangedEventHandler


'���O/���݃t�H�[�J�X����Ă����R���g���[���B
Private previousFocusedControl_ As MSForms.Control
Private currentFocusedControl_ As MSForms.Control


'�Ď��Ώۂ� UI �v�f�ƁAMSForms.Control�B
Private targetUIElements_() As UIAutomationClient.IUIAutomationElement
Private targetControls_() As MSForms.Control
    '���l
        'IUIAutomationElement ���n�߁AUIAutomation �֘A�̂قƂ�ǂ̃I�u�W�F�N�g�� IDispatch ���������Ă��Ȃ��B
        '���̂��߁A�x���o�C���f�B���O���ł����A�^�𖾎����Ȃ��Ƃ����鑀�삪�ł��Ȃ�(DispCallFunc �Ƃ����g���Θb�͕�)�B
            '�܂� Object �^�ϐ��ɓ��炸�AIsObject �� False ��Ԃ��B
        '���̊֌W���AVariant �^�ϐ��ɂ���Č^���������Ă��܂��Ɨl�X�ȉӏ��ňӐ}���Ȃ����삪�N���₷���B
        '�܂�A��L�̔z��� Scripting.Dictionary �� VBA.Collection �ł̑�p�� NG �ƂȂ�B


'�Ď��Ώۂ̐e�̃��[�U�[�t�H�[���� UI �v�f�B
Private formUiElement_ As UIAutomationClient.IUIAutomationElement
Private Const UserFormClassName = "F3 Server 05c80000"
'ElementFromIAccessible �o�R�̎擾���� "ThunderDFrame" �̈�i���̏�L�̃N���X���̗v�f�ƂȂ�B


'���[�U�[�t�H�[�������̃N���X�̊Ď��ΏۂƂ��Đݒ肷��B
Public Function Bind(ByVal inForm As MSForms.UserForm) As FormEnterExitHandler
    Set Bind = Me
    If inForm.Controls.Count = 0 Then Exit Function
    
    '�t�H�[�����̃R���g�[���ɂ��āAUI �v�f�ƃR���g���[�����̂��̂��擾����B
    ReDim targetUIElements_(0 To inForm.Controls.Count - 1)
    ReDim targetControls_(0 To inForm.Controls.Count - 1)
    
    Dim i As Long
    i = LBound(targetUIElements_)
    
    Dim c As MSForms.Control
    For Each c In inForm.Controls
        Set targetUIElements_(i) = cuia.ElementFromIAccessible(c, 0)
        Set targetControls_(i) = c
        i = i + 1
    Next c
    
    
    '�e�̃t�H�[����ۊǂ���B
    Set formUiElement_ = cuia.ElementFromIAccessible(inForm, 0)
    Debug.Assert parentFormIsAlive()
    
    '�C�x���g�w�ǊJ�n�B
    Call cuia.AddFocusChangedEventHandler(cuia.CreateCacheRequest(), Me)
End Function


'�C�x���g�w�ǂ𒆎~����B
    '�Ă΂Ȃ��Ă���������悤�ɂ͂��Ă��邯��ǁA�Ă񂾕����ǂ��B
Public Sub Dispose()
    cuia.RemoveAllEventHandlers
    
    Set previousFocusedControl_ = Nothing
    Set currentFocusedControl_ = Nothing
    Erase targetControls_, targetUIElements_
    targetControls_ = CVar(targetControls_)
End Sub

Private Sub Class_Initialize()
    targetControls_ = CVar(targetControls_) '0 To -1 �̔z��ɂ���(targetUIElements_ �ɑ΂��Ă͂��̕��@�ł͕s��)�B
    Set cuia = New UIAutomationClient.CUIAutomation
End Sub

Private Sub Class_Terminate()
    Call Me.Dispose '���܂�Ӗ��͖���(�C�x���g�w�ǒ��� CUIAutomation ���Q�Ƃ������Ă��邽�߁ATerminate ����Ȃ�)�B
End Sub


'�t�H�[�J�X�ύX�C�x���g�̃n���h���[�B
Private Sub IUIAutomationFocusChangedEventHandler_HandleFocusChangedEvent(ByVal sender As UIAutomationClient.IUIAutomationElement)
    If Not parentFormIsAlive() Then
        Call Me.Dispose
        Exit Sub
    End If
    
    Dim i As Long
    i = IndexOfUIElement(sender)
    If i < LBound(targetControls_) Then Exit Sub
    If targetControls_(i) Is currentFocusedControl_ Then Exit Sub
    
    Set previousFocusedControl_ = currentFocusedControl_
    Set currentFocusedControl_ = targetControls_(i)
    
    RaiseEvent FocusChanged(currentFocusedControl_, previousFocusedControl_)
End Sub


Private Function IndexOfUIElement(ByVal inUiaElement As UIAutomationClient.IUIAutomationElement) As Long
    Dim i As Long
    For i = LBound(targetControls_) To UBound(targetControls_) 'targetUIElements_ �ł͂Ȃ��AtargetControls_ �Ȃ̂͂킴��(��z��΍�)�B
        If CBool(cuia.CompareElements(targetUIElements_(i), inUiaElement)) Then
            Let IndexOfUIElement = i
            Exit Function
        End If
    Next i
    Let IndexOfUIElement = LBound(targetControls_) - 1
End Function


Private Function parentFormIsAlive() As Boolean
    If formUiElement_ Is Nothing Then Exit Function
    Let parentFormIsAlive = (formUiElement_.CurrentClassName = UserFormClassName)
End Function