[General]
SyntaxVersion=2
MacroID=0266fa7d-62a3-4daa-a377-1d1c2397c97d
[Comment]

[Script]
//��������д�������ӳ������
//д�걣�������һ������ϵ���Ҽ���ѡ��ˢ�¡�����


Function ��ȡ��վʱ��(��վ��ַ)
    //TracePrint lib.����.��ȡ����ʱ��_��ǿ��("msdn.microsoft.com") //ȥ΢��ȡʱ����
    //TracePrint lib.����.��ȡ����ʱ��_��ǿ��("www.taobao.com") //�����Ա�������ʱ��
    //TracePrint lib.����.��ȡ����ʱ��_��ǿ��("www.qq.com") //����qq��վʱ��
    Dim Http, URL,mt
    If InStr(��վ��ַ, "http://") = 0 Then 
        Url = "http://" & ��վ��ַ
    Else
        Url = ��վ��ַ
    End if
    Set Http = CreateObject("WinHttp.WinHttpRequest.5.1")
    Http.Open "HEAD", URL, True //head��ʽ,��Ϊ���������ص�ͷ���������ʱ��..���Բ���Ҫ��ҳ��
    Http.Send 
    If Http.waitforresponse() Then 
        mt = Http.getresponseheader("Date") //��ͷ��ȡ��ʱ��..js��ʽ��(�������ڼ���ʱ���ĸ�ʽ,��vbs��һ��)
        mt = Cdate(Mid(mt, 5, len(mt) - 8))  //��ȡjs��ʽ��ʱ���ַ���.�õ�vbs��ģʽ��ʱ��
        ��ȡ��վʱ�� = DateAdd("h", 8, mt) //�й���8ʱ��,���������ձ��������׼ʱ,Ҳ����0ʱ����ʱ��.���Եü���8Сʱ
    Else 
        ��ȡ��վʱ�� = -1 //ʧ�ܷ���ֵ�� ��
    End If
    Set Http = Nothing
End Function



Function MachineCode()
    GetSN = Plugin.Sys.GetHDDSN()
    MachineCode = Plugin.Encrypt.Md5String(GetSN)
End Function

//���ص�������
Function ����License(������, Tag, valid_days, filepath)

	Tag = "WhoIsYourDaddy" & Tag
	
	//��������
	enddate = DateAdd("d", valid_days, Date)

    y = Year(enddate)
    m = Month(enddate)
    d = Day(enddate)
	//����
    str = ������ & "|" & y & "|" & m & "|" & d
    //����
    iCipher  = Plugin.Encrypt.StringEncode(str, Tag)
    
	//�����ļ�
    IsFile = Plugin.File.IsFileExist(filepath)
    If IsFile = True Then 
        Call Plugin.File.DeleteFile(filepath)
    End If
    lic_f = Plugin.File.OpenFile(filepath)
    Call Plugin.File.WriteLine(lic_f, iCipher)
    Call Plugin.File.CloseFile(lic_f)
    
    ����License = enddate
    
End Function

//��ȷ�򷵻ص������ڣ������򷵻����ʹ�����
Function ��֤License(������, Tag, filepath)
	Tag = "WhoIsYourDaddy" & Tag
	
	IsFile = Plugin.File.IsFileExist(filepath)
    
    If IsFile = False Then 
        ��֤License = - 99999         
        Exit Function
    End If
	
    lic_f = Plugin.File.OpenFile(filepath)
    iCipher = Plugin.File.ReadLine(lic_f)
    iCipher=Trim(iCipher)
    Call Plugin.File.CloseFile(lic_f)
    //����
    iPlain = Plugin.Encrypt.StringDecode(iCipher, Tag)
    license = Split(iPlain, "|")
    If license(0) = ������ Then 
    	�� = Int(license(1))
    	�� = Int(license(2))
    	�� = Int(license(3))
    	
    	��֤License = DateSerial(��, ��, ��)
    Else 
    	��֤License = - 9999 
    End If

End Function