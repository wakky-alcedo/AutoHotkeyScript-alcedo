#Requires AutoHotkey v2.0

#Include "task_scheduler_common.ahk"

; タスクスケジューラで起動する際は，「最上位の特権で実行する」を有効にすること

; タイマー初期化
OnGreyTimer()
return

; タイマー内
OnGreyTimer(*) {
    ; 現在の時刻を取得し、時刻条件を満たすかを判定
    currentTime := Format("{:02}{:02}", A_Hour, A_Min)

    ; カラーフィルタの状態を確認し切り替え
    regKey := "HKEY_CURRENT_USER\SOFTWARE\Microsoft\ColorFiltering"
    regValue := "Active"
    regHotkeyValue := "HotkeyEnabled"
    regState := RegRead(regKey, regValue)  ; 現在の状態を取得

    ; ToolTip(regState)  ; 現在の状態を表示
    ; Sleep 1000  ; 1秒待機
    ; ToolTip("")  ; ツールチップを消去

    ; 条件: 午前2時 (0200) 以上かつ午前6時 (0600) 未満
    if (currentTime >= "0000" && currentTime < "0700") {
        if (regState == 0) {
            ; カラーフィルタが無効 → 有効化
            RegWrite(1, "REG_DWORD", regKey, regHotkeyValue) ; ショートカットキーの有効化
            Send("^#c")  ; Ctrl + Win + C キーを送信（カラーフィルタの有効化）
            RegWrite(0, "REG_DWORD", regKey, regHotkeyValue) ; ショートカットキーの無効化
        }
    } else {
        if (regState == 1) {
            ; カラーフィルタが有効 → 無効化
            RegWrite(1, "REG_DWORD", regKey, regHotkeyValue) ; ショートカットキーの有効化
            Send("^#c")  ; Ctrl + Win + C キーを送信（カラーフィルタの有効化）
            ; RegWrite(0, "REG_DWORD", regKey, regHotkeyValue) ; ショートカットキーの無効化
        }
    }

    startTime := "2300"
    endTime := "0700"
    diffTime := TimeBetween(startTime, endTime) ; [sec]
    ; ToolTip("残り " diffTime " 秒", , )
    ; Sleep 1000  ; 1秒待機
    ; ToolTip("")  ; ツールチップを消去
    SetTimer(OnGreyTimer, -diffTime * 1000)  ; 残り時間を設定
    return
}
