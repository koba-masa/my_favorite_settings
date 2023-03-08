Const PADDINGNUM = 2

Dim WshShell
Set WshShell = WScript.CreateObject("WScript.Shell")

Dim fso
Set fso = WScript.CreateObject("Scripting.FileSystemObject")

Dim paramCnt
paramCnt = WScript.Arguments.Count
If paramCnt = 0 Then
    WshShell.Popup "A mount of parameter is wrong!!", 0, "Error", 0 + 48
    WScript.Quit(1)
End If

Dim paramList
Set paramList = WScript.CreateObject("System.Collections.ArrayList")
Dim param
Dim dirFlg
dirFlg = 0
For i = 0 To paramCnt -1
    param = WScript.Arguments(i)
    Select Case param
        Case "-d"
            dirFlg = 1

        Case "-h"
            Call help
            WScript.Quit(0)

        Case Else
            If targetExists(param) <> 0 Then
                WScript.Quit(1)
            End If
            paramList.add param

    End Select
Next

Dim nowDate
nowDate = Replace(FormatDateTime(Now, 2), "/", "")

Dim targetFile
Dim branch
Dim dirPath
If dirFlg = 0 Then
    For Each targetFile In paramList
        branch = checkBranch(targetFile & "." & nowDate)
        Call backup(targetFile, targetFile & "." & nowDate & "." & padding(branch))
    Next
Else
    branch = checkBranch(nowDate)
    dirPath = nowDate & "." & padding(branch)
    fso.CreateFolder(dirPath)
    For Each targetFile In paramList
        Call backup(targetFile, dirPath & "\")
    Next
End If

WScript.Quit(0)

Private Function help()
    WshShell.Popup "-h help" & vbCrLf & _
                   "", _
                   0, "Help", 0 + 64
End Function

Private Function targetExists(target)
    If Not fso.FileExists(target) And Not fso.FolderExists(target) Then
        WshShell.Popup target & " doen not exist.", 0, "Error", 0 + 48
        targetExists = 1
        Exit Function
    End If
    targetExists = 0
End Function

Private Function checkBranch(target)
    Dim count
    count = 1
    Dim tmpTarget
    Do while True
        tmpTarget = target & "." & padding(count)
        If Not fso.FileExists(tmpTarget) And Not fso.FolderExists(tmpTarget) Then
            Exit Do
        End If
        count = count + 1
    Loop
    checkBranch = count
End Function

Private Function padding(target)
    padding = Replace(Space(PADDINGNUM - Len(target)) & target, Space(1), "0")
End Function

Private Function backup(src, dst)
    If fso.FolderExists(src) Then
        fso.CopyFolder src, dst
    Else
        fso.CopyFile src, dst
    End If
End Function

