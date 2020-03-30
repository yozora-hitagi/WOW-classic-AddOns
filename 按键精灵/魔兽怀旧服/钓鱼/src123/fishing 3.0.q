[General]
SyntaxVersion=2
BeginHotkey=121
BeginHotkeyMod=0
PauseHotkey=0
PauseHotkeyMod=0
StopHotkey=123
StopHotkeyMod=0
RunOnce=1
EnableWindow=
MacroID=a260adfe-7fd4-4264-8bc9-ba08658a320c
Description=fishing 3.0
Enable=0
AutoRun=0
[Repeat]
Type=0
Number=1
[SetupUI]
Type=2
QUI=
[Relative]
SetupOCXFile=
[Comment]

[UIPackage]
UEsDBBQAAgAIAEivXU+17/a6bgMAAAgkAAAJABEAVUlQYWNrYWdlVVQNAAf8tbhd/LW4Xfy1uF3tWMtPE0Ec/rbl0QeU8irIQ+sD9WKid2O0RBIJPkKLJh6MBYsQSyFbjBj/Ai/+D549+ZfoxcSj3jXh5E3Wb3dn7ZSUsDOz0DTpR35M2TL7zfzm95w4fHz9Mvzj4+epnziEW4jjwEmiT3pmCfGQBWLi7wPHcYLHThcdhb+UHnGG7ln3UvopSUqCkqIMUtKUAUrGP3oMiTkHXRV2NJaxzZ9d5HEXNY423kIFOVpM8C7rmP/Nvl/89fzDNyvOz7cT/rMV3MN16CMBywr4Y8fwBqP83TxKWDJYQUrwTwjfUeUvUd87qOABytjiqIoRxDz+YRF7w87rEWPgw+2ULtqHhW17y8D9sLBZ3zB5hwUzmM43xTr3bzJfwWVPZL5u3GnEv1hTzRf2zET497JOGauoaq4hw/iXFnVKWP6YFP8eYxN1iu4Kshr7j0v8y2Qt4wUeUg9VxdwbxP8B8c6w/D0Sf4n8e8z7Budvqe6/V+KfZ/VRpdiaKxnT4O9ryV/gOazhlTq/Vy8PKei//9D5rxnqf1D4U1j+BPwaXsY1OsViu4OpBvrbzP+ntc49Td4v5ovlWj1frNib6yfEP/fpmdH8p4w8NuNPhb914MbfceFTYe0vKdn/En1P3eua7T8r3heWP9XS/4tcxwb1oJYNJ+n/o3DjcHj+tMR/h9X/jpcDbEqNa1DLQjnuPwm/Lw/LPyDxL3DvNbP4o5z/3Hh18//+q8y+L7kGV+81nfivzJ9pOv8y9b/LNbh6KHjnEGSChm0cjavUfw6Ne68w/EMSf8F7v+9/Yfha2J81psiflfhN44dp/WmKJ5XVgr39pl6xTeff0Jrf6f1LiZa/69W+OtbnxR9l/xuW7O8R+ffIXmUVroOMBv/IIX63/nrNfevcwkxq8Mv35f79k57tuUjRggLuqaP8/RTun1T2Pwo/B7uIoP9U5nfjZVp8jqL/zHM8h/D5dxyR9p/WeajF/xwi7T8x7flB+P1PoL39Z7P/nX7/OYlI+09rhuMlBf2fkfhNsb+/bzb/u+O48o5R6bdGMRFHe2HKb5r/TfvPKO4fLnCcVbC/KTTuHyLoP5Xz7zQi7T8xJ3wqLP8MIu0/rctQi/+ziLT/xFmOFxX2fxaR9p/WFcX9u7k66D8j6L+U7S8v7X+FHrhk4P8Jw/rTtP/rorPxD1BLAQIXCxQAAgAIAEivXU+17/a6bgMAAAgkAAAJAAkAAAAAAAAAAAAAgAAAAABVSVBhY2thZ2VVVAUAB/y1uF1QSwUGAAAAAAEAAQBAAAAApgMAAAAA


[Script]
//------------------------------------------------
//配置 Config  目录
//------------------------------------------------
ConfigPathErrorFile="C:\fishing"
ConfigPath = ConfigPathErrorFile & "\"
Exist = Plugin.File.ExistFile(ConfigPathErrorFile)
If Exist = 0 Then 
    Call Plugin.File.CreateFolder(ConfigPath)
ElseIf Exist = 1 Then
    MessageBox "请删除文件 " & ConfigPathErrorFile
    Goto endflag
End If


//------------------------------------------------
//license 检查
//------------------------------------------------
GetSN = Plugin.Sys.GetHDDSN()
GetSNMD5 = Plugin.Encrypt.Md5String(GetSN)

IsFile = Plugin.File.IsFileExist(ConfigPath & "fishing.reg")
If not IsFile Then 
    MessageBox "找不到 license ！"
    //写入注册码
    IsFile = Plugin.File.IsFileExist(ConfigPath & "fishing.reg")
    If not IsFile  Then 
        reg_handle = Plugin.File.OpenFile(ConfigPath & "fishing.reg")
        Call Plugin.File.WriteFile(reg_handle,GetSNMD5)
        Call Plugin.File.CloseFile(reg_handle)
    End If

		
    Goto endflag
End If

//读取license
lic_handle = Plugin.File.OpenFile(ConfigPath & "fishing.lic")
license = Plugin.File.ReadFile(lic_handle, 32)
license = UCase(license)
Call Plugin.File.CloseFile(lic_handle)

//计算正确的license
license_answer = Plugin.Encrypt.Md5String(GetSNMD5 & "whoisyourdaddy")
license_answer = UCase(license_answer)

//验证 license
If license = license_answer Then 
    //	MessageBox "验证成功！"
Else 
    MessageBox "license 验证失败！"
    Goto endflag
End If


//全局使用的变量
scrw = Plugin.Sys.GetScRX()
scrh = Plugin.Sys.GetScRY()



//------------------------------------------------
//函数定义
//------------------------------------------------

Dim FindX
Dim FindY
Function Find(x1, y1, x2, y2, colors, t, p)

    Find = -1
    
    For i = 0 To UBound(colors)
        FindColorEx x1, y1, x2, y2, colors(i), t, p, x, y
        If x > 0 And y > 0 Then
            Find = i
            FindX = x
            FindY = y
            //MessageBox FindX
            Exit Function
        End If
    Next
End Function




//------------------------------------------------
//配置查找色
//------------------------------------------------
//RedFeatherColor = "040824|0D0B24|081028"
//YellowCorkWoodColor = "72A089|89BDB0|3191B5|7398BD|3C8EB8|45A7C6|499694|48678B|3D609F|314884"
//HighlightYellowCorkWood = "98DEFB|BEFEFF|9FD6F5|7FB4DF|647397|6D91D2|6595EE|6397EC|55C4F2|6BDAFE|62C7E9|5DC2E7|7198B0|689AC1|5BAFD0"


//IsFile = Plugin.File.IsFileExist(ConfigPath & "fishing.ini")
//If not IsFile  Then 
//    //红色羽毛
//    Call Plugin.File.WriteINI("Color", "RedFeather",RedFeatherColor , ConfigPath & "fishing.ini")
//    //黄色轻木
//    Call Plugin.File.WriteINI("Color", "YellowCorkWood",YellowCorkWoodColor , ConfigPath & "fishing.ini")
//    //高亮的黄色轻木
//    Call Plugin.File.WriteINI("Color", "HighlightYellowCorkWood",HighlightYellowCorkWood , ConfigPath & "fishing.ini")
//End If
//
//RedFeather = Plugin.File.ReadINI("Color", "RedFeather", ConfigPath & "fishing.ini")
//YellowCorkWood = Plugin.File.ReadINI("Color", "YellowCorkWood", ConfigPath & "fishing.ini")
//HighlightYellowCorkWood = Plugin.File.ReadINI("Color", "HighlightYellowCorkWood", ConfigPath & "fishing.ini")

//浮漂的红色羽毛
//aRedFeather = Split(RedFeather, "|")
//浮漂的黄色轻木
//aYellowCorkWood = Split(YellowCorkWood, "|")
//高亮的浮漂的黄色木块 鼠标落上高亮
//aHighlightYellowCorkWood = Split(HighlightYellowCorkWood, "|")



//------------------------------------------------
//配置查找色
//------------------------------------------------


Rem begin

//鼠标移动到左下角
//MoveTo 50 + Int(Rnd * 50), scrh - 50 - Int(Rnd * 50)
//Delay 500 + Int(Rnd * 500)

//KeyPress "F11", 1

//FindPic 0, Int(scrh * 3 / 4), scrw, scrh, "Attachment:\fishlogo.bmp", 0.5, intX, intY
//If intX > 0 And intY > 0 Then 
//    MoveTo intX + Int(Rnd * 10),intY + Int(Rnd * 10)
//    LeftClick 1
//    Delay 1000 + Int(Rnd * 2000)
//    //    MoveTo Int(Rnd * 1000), Int(Rnd * 500)
//Else 
//    MessageBox "没找到钓鱼图标，请拖到屏幕下方的动作条！"
//    Goto endflag
//End If

MoveTo 1164+Int(Rnd * 20),688+Int(Rnd * 20)
LeftClick 1
Delay 1000 + Int(Rnd * 2000)


rx1 = Int(scrw / 3)
ry1 = Int(scrh / 3)
rx2 = Int(scrw * 2 / 3)
ry2 = Int(scrh * 2 / 3)

//暴力查找浮漂的循环
For msx = rx2 To rx1 Step -12
    For msy = ry2 To ry1 Step -1
        MoveTo msx, msy
        ms = GetCursorShape(0)
        //如果找到鱼漂就跳出
        If ms = 1884068285 Then 
            Goto find_buoy
        End If
    Next
Next
Goto begin

//找到浮漂
Rem find_buoy
intv=5
For x = msx To 0 Step - 1 
    MoveTo x, msy
    Delay intv
    ms = GetCursorShape(0)
    If not ms = 1884068285 Then 
        X1 = x + 2
        Goto gotX1
    End If 
Next
Rem gotX1

For y = msy To 0 Step - 1 
    MoveTo X1, y
    Delay intv
    ms = GetCursorShape(0)
    If not ms = 1884068285 Then 
        Y1 = y + 2
        Goto gotY1
    End If 
Next
Rem gotY1

For y = msy To scrh Step 1 
    MoveTo msx, y
    Delay intv
    ms = GetCursorShape(0)
    If not ms = 1884068285 Then 
        Y2 = y - 2
        Goto gotY2
    End If 
Next
Rem gotY2

For x = msx To scrw Step 1
    MoveTo x, Y2
    Delay intv
    ms = GetCursorShape(0)
    If not ms = 1884068285 Then 
        X2 = x - 2
        Goto gotX2
    End If 
Next
Rem gotX2


nmsx = X1 + Int((X2 - X1) * 3 / 4)
nmsy = Y1 + Int((Y2 - Y1) * 2 / 3)

MoveTo nmsx, nmsy




Delay Int(Rnd * 1000)

//通过检测鼠标样式，判断鼠标是否落在浮漂上
ms = GetCursorShape(0)
If Not ms = 1884068285  Then Goto begin


YCWHColor=Plugin.Color.GetPixelColor(nmsx,nmsy ,0)

starttime = Plugin.Sys.GetTime()
While True

    FindColorEx msx-10,msy -10,msx+5,msy +5,"YCWHColor",1,0.7,intX,intY
    If intX < 0 Or intY < 0 Then 
        Goto success
    End If

    //    F = Find(ycwx - 10, ycwy - 10, ycwx + 10, ycwy + 10, aHighlightYellowCorkWood, 0, 0.8)
    //    If F < 0  Then 
    //        Goto success
    //    End If

    
    //如果没鱼上钩，30秒后重新抛竿
    nowtime = Plugin.Sys.GetTime()
    If nowtime - starttime > 30000 Then 
        Goto begin
    End If
Wend

//检测到鱼上钩，拉杆操作
Rem success
//点击右键，拉杆
RightClick 1
//等待自动拾取
Delay 1000 + Int(Rnd * 3000)


//正常结束，重新开始
Goto begin



//结束标记
Rem endflag



