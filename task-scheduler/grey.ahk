#Requires AutoHotkey v2.0

; タスクスケジューラで起動する際は，「最上位の特権で実行する」を有効にすること

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

return
