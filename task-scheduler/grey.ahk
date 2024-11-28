#Requires AutoHotkey v2.0

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

; 時刻の範囲内か，また次に境界をまたぐまでの時間を計算
TimeBetween(startTime, endTime) { ; HHMM形式
    currentTime := A_Now
    ; HHMM形式の数値に今日の日付を複合
    startTime := A_YYYY . A_MM . A_DD . startTime . "00"
    startTimeDiff := DateDiff(startTime, currentTime, "Seconds")
    if(startTimeDiff < 0) {
        startTime := DateAdd(startTime, 1, "Days")
        startTimeDiff := DateDiff(startTime, currentTime, "Seconds")
    }
    endTime := A_YYYY . A_MM . A_DD . endTime . "00"
    endTimeDiff := DateDiff(endTime, currentTime, "Seconds")
    if(endTimeDiff < 0) {
        endTime := DateAdd(endTime, 1, "Days")
        endTimeDiff := DateDiff(endTime, currentTime, "Seconds")
    }
    ; MsgBox(startTime " " endTime " " currentTime)  ; 現在の時刻を表示
    ; MsgBox(startTimeDiff/60/60 " " endTimeDiff/60/60)  ; 残り時間を表示
    if (startTimeDiff < endTimeDiff) {
        return startTimeDiff ; [sec]
    } else {
        return endTimeDiff ; [sec]
    }
}
