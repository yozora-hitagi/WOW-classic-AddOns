[General]
SyntaxVersion=2
MacroID=0266fa7d-62a3-4daa-a377-1d1c2397c97d
[Comment]

[Script]
//请在下面写上您的子程序或函数
//写完保存后，在任一命令库上点击右键并选择“刷新”即可


Function 获取网站时间(网站地址)
    //TracePrint lib.网络.获取网络时间_增强版("msdn.microsoft.com") //去微软取时间玩
    //TracePrint lib.网络.获取网络时间_增强版("www.taobao.com") //看看淘宝服务器时间
    //TracePrint lib.网络.获取网络时间_增强版("www.qq.com") //看看qq网站时间
    Dim Http, URL,mt
    If InStr(网站地址, "http://") = 0 Then 
        Url = "http://" & 网站地址
    Else
        Url = 网站地址
    End if
    Set Http = CreateObject("WinHttp.WinHttpRequest.5.1")
    Http.Open "HEAD", URL, True //head方式,因为服务器返回的头部里面就有时间..所以不需要网页了
    Http.Send 
    If Http.waitforresponse() Then 
        mt = Http.getresponseheader("Date") //从头部取到时间..js格式的(带有星期几跟时区的格式,跟vbs不一样)
        mt = Cdate(Mid(mt, 5, len(mt) - 8))  //截取js格式的时间字符串.得到vbs的模式的时间
        获取网站时间 = DateAdd("h", 8, mt) //中国是8时区,而服务器普遍是世界标准时,也就是0时区得时间.所以得加上8小时
    Else 
        获取网站时间 = -1 //失败返回值是 空
    End If
    Set Http = Nothing
End Function



Function MachineCode()
    GetSN = Plugin.Sys.GetHDDSN()
    MachineCode = Plugin.Encrypt.Md5String(GetSN)
End Function

//返回到期日期
Function 生成License(机器码, Tag, valid_days, filepath)

	Tag = "WhoIsYourDaddy" & Tag
	
	//到期日期
	enddate = DateAdd("d", valid_days, Date)

    y = Year(enddate)
    m = Month(enddate)
    d = Day(enddate)
	//明文
    str = 机器码 & "|" & y & "|" & m & "|" & d
    //密文
    iCipher  = Plugin.Encrypt.StringEncode(str, Tag)
    
	//保存文件
    IsFile = Plugin.File.IsFileExist(filepath)
    If IsFile = True Then 
        Call Plugin.File.DeleteFile(filepath)
    End If
    lic_f = Plugin.File.OpenFile(filepath)
    Call Plugin.File.WriteLine(lic_f, iCipher)
    Call Plugin.File.CloseFile(lic_f)
    
    生成License = enddate
    
End Function

//正确则返回到期日期，错误则返回整型错误码
Function 验证License(机器码, Tag, filepath)
	Tag = "WhoIsYourDaddy" & Tag
	
	IsFile = Plugin.File.IsFileExist(filepath)
    
    If IsFile = False Then 
        验证License = - 99999         
        Exit Function
    End If
	
    lic_f = Plugin.File.OpenFile(filepath)
    iCipher = Plugin.File.ReadLine(lic_f)
    iCipher=Trim(iCipher)
    Call Plugin.File.CloseFile(lic_f)
    //明文
    iPlain = Plugin.Encrypt.StringDecode(iCipher, Tag)
    license = Split(iPlain, "|")
    If license(0) = 机器码 Then 
    	年 = Int(license(1))
    	月 = Int(license(2))
    	日 = Int(license(3))
    	
    	验证License = DateSerial(年, 月, 日)
    Else 
    	验证License = - 9999 
    End If

End Function