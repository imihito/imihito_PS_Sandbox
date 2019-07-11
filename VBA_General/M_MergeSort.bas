Attribute VB_Name = "M_MergeSort"
Option Explicit

'�I�u�W�F�N�g�̃����o�[�Ń\�[�g(��j��I����)�B
Public Function SortObject( _
                 inCollection As VBA.Collection, _
                 inProcName As String, _
        Optional inCallType As VBA.VbCallType = VBA.VbCallType.VbGet, _
        Optional inAscending As Boolean = True, _
        Optional inCompare As VBA.VbCompareMethod = VBA.VbCompareMethod.vbBinaryCompare _
    ) As VBA.Collection
    
    Select Case inCallType
        Case VBA.VbCallType.VbLet, _
             VBA.VbCallType.VbSet
            Call Err.Raise(5, "SortObject", "inCallType�ɂ�VbGet��������VbMethod���w�肵�Ă�������")
    End Select
    
    Dim sortKeys() As Variant
    ReDim sortKeys(1 To inCollection.Count())
    Dim objs() As Object
    ReDim objs(1 To inCollection.Count())
    
    Dim i As Long, o As Object
    i = LBound(sortKeys)
    For Each o In inCollection
        Let sortKeys(i) = VBA.Interaction.CallByName(o, inProcName, inCallType)
        Set objs(i) = o
        i = i + 1
    Next o
    
    '�\�[�g�����Y�������擾�B
    Dim indexes() As Long
    indexes = getSortedIndexes(sortKeys, inAscending, inCompare)
    
    '�o�͗p�ɓ��꒼���B
    Dim returnCol As VBA.Collection
    Set returnCol = New VBA.Collection
    For i = LBound(indexes) To UBound(indexes)
        returnCol.Add objs(indexes(i))
    Next i
    
    Set SortObject = returnCol
    
End Function


Public Function SortDictionaryByKey( _
                 inDictionary As Object, _
        Optional inAscending As Boolean = True _
    ) As Object 'As Scripting.Dictionary
    
    Dim sortKeys() As Variant
    sortKeys = inDictionary.Keys()
    
    Dim indexes() As Long
    indexes = getSortedIndexes(sortKeys, inAscending, inDictionary.CompareMode)
    
    Dim itms() As Variant
    itms = inDictionary.Items()
    
    Dim returnDic As Object 'As Scripting.Dictionary
    Set returnDic = VBA.Interaction.CreateObject("Scripting.Dictionary")
    returnDic.CompareMode = inDictionary.CompareMode
    
    Dim i As Long
    For i = LBound(indexes) To UBound(indexes)
        returnDic.Add sortKeys(indexes(i)), itms(indexes(i))
    Next i
    
    Set SortDictionaryByKey = returnDic
    
End Function



'�}�[�W�\�[�g�̖{��
    '�l�̈ꎟ���z���n���ƁA���т������ꍇ�̓Y�����̔z���Ԃ��B
    'inValues       :��r�������l�̓������ꎟ���z��(�C�ӂ̌^�̔z������e���邽�߁AVariant �^)
    'inAscending    :�������~�����BTrue �Ȃ珸��(�������l����)�B
    
    'return         :inValues �̒��g�� inAscending �̏��ԂɎ��o���鏇�Ԃɂ����Y�����z��

'e.g.
'getSortedIndexes(Array("a", "c", "b"), True) - > (0, 2, 1)
'getSortedIndexes(Array("b", "c", "b"), False) -> (1, 0, 2)
Private Function getSortedIndexes( _
        inValues As Variant, _
        inAscending As Boolean, _
        inCompare As VBA.VbCompareMethod _
    ) As Long()
    
    If Not VBA.Information.IsArray(inValues) Then Err.Raise 13
    
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
            inUseUpperResult, _
            inCompare _
        )
    
End Function


Private Sub recurseMergeSort( _
        inValues As Variant, _
        inSrcIndexes() As Long, _
        outDestIndexes() As Long, _
        inStart As Long, _
        inLength As Long, _
        inUseUpperResult As Long, _
        inCompare As VBA.VbCompareMethod _
    )

    Dim halfLen As Long
    halfLen = CLng(inLength / 2)

    '�O���������\�[�g
    If halfLen >= 2 Then _
        Call recurseMergeSort(inValues, outDestIndexes, inSrcIndexes, inStart, halfLen, inUseUpperResult, inCompare)
    '�㔼�������\�[�g
    If inLength - halfLen >= 2 Then _
        Call recurseMergeSort(inValues, outDestIndexes, inSrcIndexes, inStart + halfLen, inLength - halfLen, inUseUpperResult, inCompare)
    
    
    '�O�������̓Y�����ƍő�l
    Dim lwIndex As Long
    lwIndex = inStart
    Dim lwLimit As Long
    lwLimit = inStart + halfLen - 1
    
    '�㔼�����̓Y�����ƍő�l
    Dim upIndex As Long
    upIndex = inStart + halfLen
    Dim upLimit As Long
    upLimit = inStart + inLength - 1
    
    '�\�[�g��z��̓Y�����ƍő�l
    Dim destIndex As Long
    destIndex = inStart
    Dim destLimit As Long
    destLimit = inStart + inLength - 1

    Dim remainIndex As Long '�Е����I��������̗]��p
    
    For destIndex = inStart To destLimit Step 1
        If compareM( _
                inValues(inSrcIndexes(lwIndex)), _
                inValues(inSrcIndexes(upIndex)), _
                inCompare _
            ) = inUseUpperResult Then
            
            'upIndex�̕����l���������ꍇ�i�����̏ꍇ�j
            outDestIndexes(destIndex) = inSrcIndexes(upIndex)
            
            If upIndex = upLimit Then
                remainIndex = lwIndex
                Exit For
            End If
            upIndex = upIndex + 1
            
        Else
            '�l������ or lwIndex�̕����l���������ꍇ�i�����̏ꍇ�j
            outDestIndexes(destIndex) = inSrcIndexes(lwIndex)
            
            If lwIndex = lwLimit Then
                remainIndex = upIndex
                Exit For
            End If
            lwIndex = lwIndex + 1
            
        End If
    Next destIndex
    
    '�c��̕�����
    'Next destIndex���΂������C���N�������g���Ă���X�^�[�g
    For destIndex = destIndex + 1 To destLimit Step 1
        outDestIndexes(destIndex) = inSrcIndexes(remainIndex)
        remainIndex = remainIndex + 1
    Next destIndex

End Sub

Private Function compareM( _
        inValue1 As Variant, _
        inValue2 As Variant, _
        inCompare As VBA.VbCompareMethod _
    ) As Long
    Select Case VBA.VbVarType.vbString
        Case VBA.Information.VarType(inValue1), _
             VBA.Information.VarType(inValue2)
            Let compareM = VBA.Strings.StrComp(inValue1, inValue2, inCompare)
            Exit Function
    End Select
    
    
    If inValue1 < inValue2 Then Let compareM = -1: Exit Function
    If inValue1 > inValue2 Then Let compareM = 1:  Exit Function
    Let compareM = 0
End Function

