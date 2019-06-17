VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "JsEnv"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'Instance JScript Function object

'e.g.
    'Dim adder As Object: Set adder = JSFunc("a,b", "a+b") 'autoReturn = True
    'Debug.Print adder(2, 6) '->8

    'Dim inRange As Object
    'Set inRange = JSFunc("range,min,max", "v=range.Value;return min<=v&&v<=max;", False) 'autoReturn = False
    'Excel.ActiveCell.Value() = 150
    'Debug.Print inRange(Excel.ActiveCell, 100, 200) '->True

'Arguments
'args
    '`funcBody`���Ŏg�p��������B
    '�����w�莞�̓J���}��؂�Ŏw�肷��B
    '�Q�l:'[Function - JavaScript | MDN](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Function)
'funcBody
    '�֐��{���B
'autoReturn
    '�ȗ��\�B�ȗ���True�B
    'True�̂Ƃ�`funcBody`�̐擪��`return `��ǉ�����B

'Return
    '�C���X�^���X���ꂽJScript��function�I�u�W�F�N�g�B

Public Function NewFunc( _
        args As String, _
        funcBody As String, _
        Optional autoReturn As Boolean = True) As Object

    Const EXEC_SCRIPT = _
            "this.createFunc=" & _
                "function(args,funcBody){" & _
                    "return new Function(args,funcBody);}"

    '�e�평����
    '�֐��I�u�W�F�N�g�̃L���b�V��
    Static funcCache As Object 'As Scripting.Dictionary
    If funcCache Is Nothing Then Set funcCache = VBA.CreateObject("Scripting.Dictionary")

    'JScript���s���B�Q�Ƃ�ێ����Ȃ��ƃC���X�^���X����function�I�u�W�F�N�g��������
    Static htmlDoc    As Object 'As MSHTML.HTMLDocument
    Static createFunc As Object 'JScript function
    
    If htmlDoc Is Nothing Then
        Call funcCache.RemoveAll
        Set htmlDoc = VBA.CreateObject("htmlfile")
        
        'JScript�̃O���[�o���ϐ��Ɋ֐����`
        Call htmlDoc.parentWindow.execScript(EXEC_SCRIPT)
        
        '�쐬�����֐���ÓI�ϐ��ɕۊǁi���������h�~�j
        Set createFunc = htmlDoc.parentWindow.createFunc
    End If


    '�L���b�V���p�ɐ��`
    Dim trimedArgs As String, trimedBody As String
    trimedArgs = VBA.Trim$(args)
    If autoReturn Then
        trimedBody = "return " & VBA.Trim$(funcBody)
    Else
        trimedBody = VBA.Trim$(funcBody)
    End If

    Dim cacheKey As String
    cacheKey = trimedArgs & "|" & trimedBody


    '�L���b�V���ɖ�����ΐV�K�C���X�^���X
    If Not funcCache.Exists(cacheKey) Then
        Call funcCache.Add(cacheKey, createFunc(trimedArgs, trimedBody))
    End If

    Set NewFunc = funcCache.Item(cacheKey)

End Function


Public Function Parse(jsExpression As String) As Variant
    Dim evalFunc As Object
    Set evalFunc = Me.NewFunc("s", "eval('('+s+')')")
    SetVar(Parse) = evalFunc(jsExpression)
End Function


Public Function IsJsObject(ByVal iObject As Object) As Boolean
    Let IsJsObject = Me.NewFunc("o", "o instanceof Object")(iObject)
End Function



Private Property Let SetVar( _
        ByRef outVariable As Variant, _
        inExpression As Variant _
    )
    Select Case True
        Case VBA.IsObject(inExpression), _
             VBA.VarType(inExpression) = vbDataObject
            
            Set outVariable = inExpression
            
        Case Else
            Let outVariable = inExpression
            
    End Select
End Property
