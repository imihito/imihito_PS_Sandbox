Attribute VB_Name = "M_MergeSort"
Option Explicit

'�I�u�W�F�N�g�̃����o�[�Ń\�[�g(��j��I����)�B
Public Function SortObject( _
                 inBaseCollection As VBA.Collection, _
                 inMemberName As String, _
        Optional inCallType As VBA.VbCallType = VbGet, _
        Optional inAscending As Boolean = True _
    ) As VBA.Collection
    
    Select Case inCallType
        Case VbLet, VbSet
            Call Err.Raise(5, "SortObject", "inCallType�ɂ�VbGet��������VbMethod���w�肵�Ă�������")
    End Select
    
    Dim keyValues()     As Variant: ReDim keyValues(1 To inBaseCollection.Count)
    Dim bufObjects()    As Object:  ReDim bufObjects(1 To inBaseCollection.Count)
    
    Dim i As Long, obj As Object
    i = LBound(keyValues)
    For Each obj In inBaseCollection
        Let keyValues(i) = VBA.CallByName(obj, inMemberName, inCallType)
        Set bufObjects(i) = obj
        i = i + 1
    Next obj
    
    '�\�[�g�����Y�������擾�B
    Dim sortedIndexes() As Long
    sortedIndexes = getSortedIndexes(keyValues, inAscending)
    
    '�o�͗p�ɓ��꒼���B
    Dim returnCol As VBA.Collection: Set returnCol = New VBA.Collection
    For i = 1 To inBaseCollection.Count
        returnCol.Add bufObjects(sortedIndexes(i))
    Next i
    
    Set SortObject = returnCol
    
End Function

'�}�[�W�\�[�g�̖{��
    '�l�̈ꎟ���z���n���ƁA���т������ꍇ�̓Y������Ԃ��B
Private Function getSortedIndexes(inValues() As Variant, inAscending As Boolean) As Long()
    
    Dim inUseUpperResult As Long
    If inAscending Then
        inUseUpperResult = 1
    Else
        inUseUpperResult = -1
    End If
    
    
    '`inValues`�����ɓY�����z��쐬
    Dim basIndexes() As Long
    ReDim basIndexes(LBound(inValues) To UBound(inValues))
    Dim i As Long
    For i = LBound(inValues) To UBound(inValues)
        basIndexes(i) = i
    Next i
    
    '�Y�����z����R�s�[�B
    getSortedIndexes = basIndexes
    
    Call recurseMergeSort( _
            inValues, _
            basIndexes, _
            getSortedIndexes, _
            LBound(inValues), _
            UBound(inValues) - LBound(inValues) + 1, _
            inUseUpperResult)
    
    Erase basIndexes
    
End Function


Private Sub recurseMergeSort( _
        inValues() As Variant, _
        inSrcIndexes() As Long, _
        outDestIndexes() As Long, _
        inStart As Long, _
        inLength As Long, _
        inUseUpperResult As Long)

    Dim halfLen As Long: halfLen = CLng(inLength / 2)

    '�O���������\�[�g
    If halfLen >= 2 Then:               Call recurseMergeSort(inValues, outDestIndexes, inSrcIndexes, inStart, halfLen, inUseUpperResult):
    '�㔼�������\�[�g
    If inLength - halfLen >= 2 Then:    Call recurseMergeSort(inValues, outDestIndexes, inSrcIndexes, inStart + halfLen, inLength - halfLen, inUseUpperResult):
    
    
    '�O�������̓Y�����ƍő�l
    Dim lwIndex   As Long: lwIndex = inStart
    Dim lwMax     As Long: lwMax = inStart + halfLen - 1
    
    '�㔼�����̓Y�����ƍő�l
    Dim upIndex   As Long: upIndex = inStart + halfLen
    Dim upMax     As Long: upMax = inStart + inLength - 1
    
    '�\�[�g��z��̓Y�����ƍő�l
    Dim destIndex As Long: destIndex = inStart
    Dim destMax   As Long: destMax = inStart + inLength - 1

    Dim leftIndex As Long   '�Е����I��������̗]��p
    
    For destIndex = inStart To destMax Step 1
        If compareM( _
                inValues(inSrcIndexes(lwIndex)), _
                inValues(inSrcIndexes(upIndex))) = inUseUpperResult Then
            
            'upIndex�̕����l���������ꍇ�i�����̏ꍇ�j
            outDestIndexes(destIndex) = inSrcIndexes(upIndex)
            
            If upIndex = upMax Then leftIndex = lwIndex: Exit For
            upIndex = upIndex + 1
            
        Else
            '�l������ or lwIndex�̕����l���������ꍇ�i�����̏ꍇ�j
            outDestIndexes(destIndex) = inSrcIndexes(lwIndex)
            
            If lwIndex = lwMax Then leftIndex = upIndex: Exit For
            lwIndex = lwIndex + 1
            
        End If
    Next destIndex
    
    '�c��̕�����
    'Next destIndex���΂������C���N�������g���Ă���X�^�[�g
    For destIndex = destIndex + 1 To destMax Step 1
        outDestIndexes(destIndex) = inSrcIndexes(leftIndex)
        leftIndex = leftIndex + 1
    Next destIndex

End Sub

Private Function compareM(inValue1 As Variant, inValue2 As Variant) As Long
    If inValue1 < inValue2 Then Let compareM = -1: Exit Function
    If inValue1 > inValue2 Then Let compareM = 1:  Exit Function
    Let compareM = 0
End Function

