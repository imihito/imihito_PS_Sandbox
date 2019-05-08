Attribute VB_Name = "M_ChangeOneNoteFont"
Option Explicit

'�ȉ��̎Q�Ɛݒ�͕K�{�B
'OneNote = Microsoft OneNote 15.0 Object Library

Public Sub ChangeOneSectionFont()
    'OneNote �擾�B
    Dim appOne As OneNote.Application
    Set appOne = VBA.CreateObject("OneNote.Application")
    
    
    '�őO�ʂ̃Z�N�V������ ID ���擾�B
        'appOne �̌^�𖾎����Ȃ��ƈȉ��̃G���[����������B
            '�I�[�g���[�V���� �G���[�ł��B
            '���C�u�����͓o�^����Ă��܂���
    Dim sectId As String
    sectId = appOne.Windows.CurrentWindow.CurrentSectionId
    
    '�Z�N�V�����̃y�[�W�������� XML ��������擾�B
    Dim hierarchyXml As String
    appOne.GetHierarchy sectId, OneNote.HierarchyScope.hsPages, hierarchyXml
    
    'XML DOM �Ƃ��ă��[�h�B
    Dim hierarchyXmlDoc As Object 'As MSXML2.DOMDocument
    Set hierarchyXmlDoc = newXmlDoc(hierarchyXml)
    
    '�y�[�W���擾���A���ꂼ��̃t�H���g��ύX�B
    Dim node As Object 'As MSXML2.IXMLDOMNode
    For Each node In hierarchyXmlDoc.getElementsByTagName("one:Page")
        ChangeOnePageFont appOne, node.Attributes.getNamedItem("ID").NodeValue
    Next node
    
End Sub


Public Sub ChangeOnePageFont( _
        inAppOne As OneNote.Application, _
        inPageId As String _
    )
    
    '�y�[�W�̓��e���擾�B
    Dim contentsBuf As String
    inAppOne.GetPageContent inPageId, contentsBuf
    
    'XML DOM �Ƃ��ă��[�h�B
    Dim pageXml As Object 'As MSXML2.DOMDocument
    Set pageXml = newXmlDoc(contentsBuf)
    
    '�X�^�C���̃t�H���g��ύX�B
    Const BaseFont = "���S�V�b�N"
    Const NewFont = "Meiryo UI"
    
    'BaseFont ���w�肳��Ă���X�^�C���ɂ��ăt�H���g��ύX����B
    Dim node As Object 'As MSXML2.IXMLDOMNode
    For Each node In pageXml.SelectNodes("//one:QuickStyleDef[@font='" & BaseFont & "']")
        node.Attributes.getNamedItem("font").NodeValue = NewFont
    Next node
    
    
    '�ύX���e�������߂��B
    inAppOne.UpdatePageContent pageXml.XML
    
End Sub

'MSXML2 = Microsoft XML, v3.0
Private Function newXmlDoc(inXmlString As String) As Object 'As MSXML2.DOMDocument
    Dim xmlDoc As Object 'As MSXML2.DOMDocument
    Set xmlDoc = VBA.CreateObject("MSXML2.DOMDocument")
    xmlDoc.LoadXML inXmlString
    Set newXmlDoc = xmlDoc
End Function
