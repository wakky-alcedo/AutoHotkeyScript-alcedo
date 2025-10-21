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
    TimerText := MyGui.Add("Text", "cFFFFFF x0 y0 w180 h70 Center", "00:00")
    MyGui.Show("NA w180 h70 x" (A_ScreenWidth - 220) " y" (A_ScreenHeight - 70))
    StartTime := A_TickCount
    ; ToolTip "タイマー設定前"
    SetTimer(UpdateTimer, 500) ; タイマーを開始
    ; ToolTip "タイマー設定後"
    UpdateTimer() ; 初回実行
    ; ToolTip "開始"
}
#HotIf

#HotIf WinActive("ahk_class screenClass") OR WinActive("ahk_class PodiumParent") ; スライドショーがアクティブな場合のみ有効
; ラップタイム記録用のホットキー
; LButton::
Right::
Left::
Up::
Down::
; Space::
; Enter::
{
    RecordLapTime()
    Send "{" A_ThisHotkey "}"  ; 元のキーを送信
}

; スクロール
WheelUp::
{
    RecordLapTime()
    Send "{Left}"
}

WheelDown::
MButton::
{
    RecordLapTime()
    Send "{Right}"
}

Esc::
{
    Send "{Esc}"
    Global MyGui
    SetTimer(UpdateTimer, 0) ; タイマーを停止
    if IsSet(MyGui)
        MyGui.Destroy()
    ShowLapTimes()  ; ラップタイムを表示
    ; ToolTip "終了"
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
}

RecordLapTime()
{
    Global StartTime
    Global LapTimes
    
    ElapsedTime := (A_TickCount - StartTime) // 1000
    Minutes := Format("{:02d}", ElapsedTime // 60)
    Seconds := Format("{:02d}", Mod(ElapsedTime, 60))
    
    LapTimes.Push(Minutes ":" Seconds)
    
    ; 短時間ラップタイムを表示
    ToolTip "Lap " LapTimes.Length ": " Minutes ":" Seconds
    SetTimer(() => ToolTip(), -1500)  ; 1.5秒後にToolTipを消去
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