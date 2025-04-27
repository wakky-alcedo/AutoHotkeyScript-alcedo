#Requires AutoHotkey v2.0

#Include task_scheduler_common.ahk

; タスクスケジューラで起動する際は，「最上位の特権で実行する」を有効にすること

; タイマー初期化
OnGreyTimer()

; タイマー内
OnGreyTimer(*) {
    ; カラーフィルタの状態を確認
    regKey := "HKEY_CURRENT_USER\SOFTWARE\Microsoft\ColorFiltering"
    regValue := "Active"
    regHotkeyValue := "HotkeyEnabled"
    regState := RegRead(regKey, regValue)  ; 現在の状態を取得

    ; ToolTip(regState)  ; 現在の状態を表示
    ; Sleep 1000  ; 1秒待機
    ; ToolTip("")  ; ツールチップを消去

    ; 時刻の設定
    startTime := "2300"
    endTime := "0700"
    currentTime := A_Now
    startTimeDiff := TimeToStart(startTime, currentTime)
    endTimeDiff := TimeToStart(endTime, currentTime)

    ; 判定および実行，タイマーの設定
    if (startTimeDiff > endTimeDiff) { ; 範囲内
        ; MsgBox("Grey!")
        if (regState == 0) {
            ; カラーフィルタが無効 → 有効化
            RegWrite(1, "REG_DWORD", regKey, regHotkeyValue) ; ショートカットキーの有効化
            Send("^#c")  ; Ctrl + Win + C キーを送信（カラーフィルタの有効化）
            RegWrite(0, "REG_DWORD", regKey, regHotkeyValue) ; ショートカットキーの無効化
        }
        SetTimer(OnGreyTimer, -endTimeDiff * 1000) ; endまでの時間を設定
    } else {
        if (regState == 1) {
            ; カラーフィルタが有効 → 無効化
            RegWrite(1, "REG_DWORD", regKey, regHotkeyValue) ; ショートカットキーの有効化
            Send("^#c")  ; Ctrl + Win + C キーを送信（カラーフィルタの有効化）
            ; RegWrite(0, "REG_DWORD", regKey, regHotkeyValue) ; ショートカットキーの無効化
        }
        SetTimer(OnGreyTimer, -startTimeDiff * 1000) ; startまでの時間を設定
    }
    return
}
