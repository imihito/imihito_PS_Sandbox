VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "UtilArray"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'�z���v�f��0�ŏ���������API�B
    'cDims�͎������B
    'ppsaOut�͔z��ϐ��B
'https://docs.microsoft.com/ja-jp/previous-versions/windows/desktop/api/oleauto/nf-oleauto-safearrayallocdescriptor
Private Declare PtrSafe Function SafeArrayAllocDescriptor Lib "oleaut32" ( _
        ByVal cDims As Long, _
        ByRef ppsaOut() As Any _
    ) As Long

'�v�f��0��1�����z����쐬����B
Public Function CreateEmptyArray(inElementType As VBA.VbVarType) As Variant
    Select Case inElementType
        Case vbInteger:     Let CreateEmptyArray = EmptyIntegerArray
        Case vbLong:        Let CreateEmptyArray = EmptyLongArray
        Case vbSingle:      Let CreateEmptyArray = EmptySingleArray
        Case vbDouble:      Let CreateEmptyArray = EmptyDoubleArray
        Case vbCurrency:    Let CreateEmptyArray = EmptyCurrencyArray
        Case vbDate:        Let CreateEmptyArray = EmptyDateArray
        Case vbString:      Let CreateEmptyArray = EmptyStringArray
        Case vbObject:      Let CreateEmptyArray = EmptyObjectArray
        Case vbBoolean:     Let CreateEmptyArray = EmptyBooleanArray
        Case vbVariant:     Let CreateEmptyArray = EmptyVariantArray
        Case vbByte:        Let CreateEmptyArray = EmptyByteArray
    #If Win64 Then
        Case vbLongLong:    Let CreateEmptyArray = EmptyLongLongArray
    #End If
        Case Else: Err.Raise 13
    End Select
End Function

Public Property Get EmptyIntegerArray() As Integer()
    Call SafeArrayAllocDescriptor(1, EmptyIntegerArray)
End Property

Public Property Get EmptyLongArray() As Long()
    Call SafeArrayAllocDescriptor(1, EmptyLongArray)
End Property

Public Property Get EmptySingleArray() As Single()
    Call SafeArrayAllocDescriptor(1, EmptySingleArray)
End Property

Public Property Get EmptyDoubleArray() As Double()
    Call SafeArrayAllocDescriptor(1, EmptyDoubleArray)
End Property

Public Property Get EmptyCurrencyArray() As Currency()
    Call SafeArrayAllocDescriptor(1, EmptyCurrencyArray)
End Property

Public Property Get EmptyDateArray() As Date()
    Call SafeArrayAllocDescriptor(1, EmptyDateArray)
End Property

Public Property Get EmptyStringArray() As String()
    Let EmptyStringArray = VBA.Split(VBA.vbNullString)
End Property

Property Get EmptyObjectArray() As Variant '= Object()
    Dim o() As Object '-> Object()
    Let EmptyObjectArray = o
End Property '-> Object(0 To -1)

Public Property Get EmptyBooleanArray() As Boolean()
    Call SafeArrayAllocDescriptor(1, EmptyBooleanArray)
End Property

Public Property Get EmptyVariantArray() As Variant()
    Let EmptyVariantArray = VBA.Array()
End Property

Public Property Get EmptyByteArray() As Byte()
    Let EmptyByteArray = VBA.Constants.vbNullString
End Property

#If Win64 Then
Public Property Get EmptyLongLongArray() As LongLong()
    Call SafeArrayAllocDescriptor(1, EmptyLongLongArray)
End Property
#End If


'�z��̎��������擾����B���������Ă��Ȃ����I�z��̏ꍇ��0�B
Public Function DimensionsOf(ByRef inArray As Variant) As Long '0 To 64
    If Not VBA.Information.IsArray(inArray) Then Err.Raise 13
    
    'VBA�̑������z��̎����̏���B
    Const MAX_DIMENSION = 64

    Dim d As Long, no_mean_var As Long
    On Error Resume Next
        For d = 1 To MAX_DIMENSION
            no_mean_var = LBound(inArray, d)
            If Err.Number <> 0 Then Exit For
        Next d
    On Error GoTo 0

    'VBA��For���͊�������Ǝw�肵�����l+1�ɂȂ�B
    Let DimensionsOf = (d - 1) '0 To 64
End Function

'�z��̗v�f�����擾����B
Public Function SizeOf( _
           ByRef inArray As Variant, _
        Optional inDimension As Long = 1 _
    ) As Long
    
    Let SizeOf = UBound(inArray, inDimension) - LBound(inArray, inDimension) + 1
End Function

Public Function CountAll(ByRef inArray As Variant) As Long
    Dim dimCnt As Long
    dimCnt = Me.DimensionsOf(inArray)
    If dimCnt = 0 Then Exit Function 'return 0
    
    Dim sumSize As Long
    sumSize = 1
    
    Dim d As Long
    For d = 1 To dimCnt
        sumSize = sumSize * Me.SizeOf(inArray, d)
    Next d
    
    Let CountAll = sumSize
End Function


'�z��̉������ς����� ReDim Preserve�B
    'inoutOneDimArray
        '������ς�����1�����z��B
        '����𒼐ڏ���������B
    'inLBound
        '�V���������B
    'inUBound
        '�V��������B
        '���w�莞��inLBound�ɍ��킹�Ď��������B
        'inLength�Ɣr���BinUBound���D��B
    'inLength
        'ReDim��̔z��̒����B
        '���w�莞��inoutOneDimArray�Ɠ����傫���B
        
'�Q�l:https://twitter.com/excelspeedup/status/1143362854856167424
Public Sub ReDimPreserve( _
           ByRef inoutOneDimArray As Variant, _
                 inLBound As Long, _
        Optional inUBound As Long = -2147483648#, _
        Optional inLength As Long = 0 _
    )
    Const LongMinValue As Long = -2147483648#
    
    '2�����z��ȏ���͂����B
    Dim dimCnt As Long
    dimCnt = Me.DimensionsOf(inoutOneDimArray)
    If dimCnt > 1 Then Err.Raise 13
    
    
    '�ȍ~��1�����z�񂩖��������z��B
    
    Dim arraySize As Long
    If inUBound <> LongMinValue Then
        'inUBound���w�肳��Ă���Α傫���͋��܂�B
        arraySize = inUBound - inLBound + 1
    ElseIf inLength > 0 Then
        'inLength���w�肳��Ă���ꍇ�B
        arraySize = inLength
    Else
        'inUBound�EinLength�Ƃ��ɖ��w��Ȃ猳�̔z��̑傫��(dimCnt = 0�Ȃ�G���[)�B
        arraySize = Me.SizeOf(inoutOneDimArray, 1)
    End If
    
    ReDim Preserve inoutOneDimArray(inLBound To inLBound + arraySize - 1)
    
End Sub
