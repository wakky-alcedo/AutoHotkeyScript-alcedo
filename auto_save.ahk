; 自動保存

GroupAdd high_freq_app, ahk_exe Code.exe
GroupAdd high_freq_app, ahk_exe WINWORD.EXE
GroupAdd high_freq_app, ahk_exe EXCEL.EXE
GroupAdd high_freq_app, ahk_exe POWERPNT.EXE
GroupAdd  low_freq_app, ahk_exe Inventor.exe
GroupAdd high_freq_app, ahk_exe Jw_win.exe



#Persistent
SetTimer,OnTimer,-5000
Return

OnTimer:
If (A_TimeIdlePhysical > 3000) { ; 作業していない時間を指定3秒
    IfWinActive ahk_group high_freq_app
    {
        send, ^s
        ToolTip , Auto saved!
        Sleep 1000
        ToolTip
        SetTimer,OnTimer,-30000 ; 30sec
    }
    Else IfWinActive ahk_group low_freq_app
    {
        send, ^s
        ToolTip , Auto saved!
        Sleep 1000
        ToolTip
        SetTimer,OnTimer,-600000 ; 10min
    } Else {
        SetTimer,OnTimer,-30000
    }
} Else {
    SetTimer,OnTimer,-5000
}
Return
; A_TimeIdle：最後に何らかの入力があってからの経過時間をミリ秒で格納。(NT系専用)
