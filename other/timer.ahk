#Requires AutoHotkey v2.0
#SingleInstance Force
Global MyGui := Gui()
Global LapTimes := []  ; ラップタイムを記録する配列
; ====================================================================================
; ホットキー定義セクション
; ====================================================================================
#HotIf WinActive("ahk_exe POWERPNT.EXE") ; PowerPointがアクティブな時のみ有効
F5::
{
    Global MyGui := Gui()
    Global StartTime
    Global TimerText
    Global LapTimes := []  ; ラップタイムをリセット
    if IsSet(MyGui)
        MyGui.Destroy()
    Send "{F5}" ; スライドショーを開始
    ; ★修正点1: スライドショーへの移行を安定させるため、わずかに待機
    Send "^l" ; レーザーポインタモードに切り替え
    Sleep 200

    MyGui := Gui()
    MyGui.Opt("+AlwaysOnTop -Caption +ToolWindow")
    MyGui.BackColor := "000000"
    MyGui.SetFont("s40", "Arial")
    TimerText := MyGui.Add("Text", "cFFFFFF x0 y0 w180 h70 Center", "--:--")
    MyGui.Show("NA w180 h70 x" (A_ScreenWidth - 220) " y" (A_ScreenHeight - 70))
    ; StartTime は最初のキー押下時に設定される
    SetTimer(UpdateTimer, 500) ; 表示更新タイマーを開始（最初のキー押下を待つ）
}
#HotIf

#HotIf WinActive("ahk_class screenClass") OR WinActive("ahk_class PodiumParent") ; スライドショーがアクティブな場合のみ有効
; ページ戻り
Right::
Up::
; WheelUp::
PgUp::
Ctrl::
{
    ; RecordLapTime()
    Send "{PgUp}"
}

; ページ送り（ラップタイム記録）
Left::
Down::
; WheelDown::
; LButton::
; MButton::
; Space::
; Enter::
PgDn::
Shift::
{
    if !RecordLapTime()  ; タイマー開始時以外のみキーを送信
        Send "{PgDn}"
}

Esc::
{
    Send "{Esc}"
    Sleep 200
    Send "{Esc}"  ; スライドショーを終了するためにもう一度Escを送信
    Sleep 200
    StopTimerAndCleanup()
    ; Send "{Esc}"  ; スライドショーを終了
}
#HotIf
; ====================================================================================
; 関数定義セクション
; ====================================================================================
UpdateTimer()
{
    Global MyGui
    Global StartTime
    Global TimerText
    ; ToolTip "UpdateTimer呼び出し : " A_TickCount
    try ; 万が一、ウィンドウが予期せず閉じた場合などのエラーを防ぐ
    {
        ; if not IsSet(MyGui)
        ;     return
        if !IsSet(StartTime)
        {
            TimerText.Text := "--:--"
            return
        }
        ElapsedTime := (A_TickCount - StartTime) // 1000
        Minutes := Format("{:02d}", ElapsedTime // 60)
        Seconds := Format("{:02d}", Mod(ElapsedTime, 60))
        TimerText.Text := Minutes ":" Seconds
        
        ; ToolTipを変数定義後に移動
        ; ToolTip "経過時間: " Minutes ":" Seconds
    }
    catch Error as e
    {
        ; エラーが発生した場合の処理
        ToolTip "タイマーエラー: " e.Message
    }

    ; 画面を確認し，スライドショーモードではなくなったら自動終了
    if !WinActive("ahk_class screenClass") AND !WinActive("ahk_class PodiumParent")
    {
        StopTimerAndCleanup()
    }
}

RecordLapTime()
{
    Global StartTime
    Global LapTimes
    
    ; タイマーが未開始の場合、この時点で開始
    if !IsSet(StartTime)
    {
        StartTime := A_TickCount
        ToolTip "タイマー開始"
        SetTimer(() => ToolTip(), -800)  ; 0.8秒後にToolTipを消去
        return true  ; 最初のキー押下はラップタイムとして記録せず、キー送信もスキップ
    }
    
    ElapsedTime := (A_TickCount - StartTime) // 1000
    Minutes := Format("{:02d}", ElapsedTime // 60)
    Seconds := Format("{:02d}", Mod(ElapsedTime, 60))
    
    LapTimes.Push(Minutes ":" Seconds)
    
    ; 短時間ラップタイムを表示
    ; ToolTip "Lap " LapTimes.Length ": " Minutes ":" Seconds
    ; SetTimer(() => ToolTip(), -1500)  ; 1.5秒後にToolTipを消去
    return false  ; ラップタイム記録時はキーを送信
}

ShowLapTimes()
{
    Global LapTimes
    
    if LapTimes.Length = 0
        return
    
    LapText := "Lap Times:`n"
    Loop LapTimes.Length
    {
        LapText .= "Lap " A_Index ": " LapTimes[A_Index] "`n"
    }
    
    MsgBox LapText, "Lap Times", "OK"
}

StopTimerAndCleanup()
{
    Global MyGui
    Global StartTime
    SetTimer(UpdateTimer, 0) ; タイマーを停止
    try
        if IsSet(MyGui)
            MyGui.Destroy()
    ; StartTime をリセット
    if IsSet(StartTime)
        Unset(&StartTime)
    ShowLapTimes()  ; ラップタイムを表示
    ; ToolTip "終了"
}