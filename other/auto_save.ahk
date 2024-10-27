; 自動保存

GroupAdd("high_freq_app", "ahk_exe Code.exe")
GroupAdd("high_freq_app", "ahk_exe WINWORD.EXE")
GroupAdd("high_freq_app", "ahk_exe EXCEL.EXE")
GroupAdd("high_freq_app", "ahk_class PPTFrameClass") ; パワポ編集画面
;GroupAdd high_freq_app, ahk_exe POWERPNT.EXE
GroupAdd("low_freq_app", "ahk_exe Inventor.exe")
GroupAdd("high_freq_app", "ahk_exe Jw_win.exe")

save()
{
    Send("^s")
    ToolTip("Auto saved!")
    Sleep(1000)
    ToolTip()
    SetTimer(OnTimer,-30000) ; 30sec
}

Persistent ; 持続的
SetTimer(OnTimer,-5000)
; Return

OnTimer() { ; V1toV2: Added bracket
    global ; V1toV2: Made function global
    If (A_TimeIdlePhysical > 3000) { ; 作業していない時間を指定3秒
        if WinActive("ahk_group high_freq_app")
        {
            save()
        }
        Else     if WinActive("ahk_group low_freq_app")
        {
            count := count + 1
            If (count > 20) {
                save()
                count := 0
            }
        } Else {
            SetTimer(OnTimer,-30000)
        }
    } Else {
        SetTimer(OnTimer,-5000)
    }
    ; Return
} ; V1toV2: Added bracket in the end
; A_TimeIdle：最後に何らかの入力があってからの経過時間をミリ秒で格納。(NT系専用)
