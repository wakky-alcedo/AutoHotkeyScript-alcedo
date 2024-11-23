; どうやら，AHKは Shift JISで動いているようだ
#Requires AutoHotkey v2.0

#Include monitor_app_func.ahk


; 初期処理
SetTimer(OnTimer, 5000) ; 5sec
global private_count := 0
global is_privateing := false
Return

; タイマー内
OnTimer(*) {
    global private_count, is_privateing  ; グローバル変数を宣言

    now_time := Format("{:04}", A_Hour, A_Min) ; 現在時刻を "HHmm" の数値形式で取得 :が書式設定の開始，0が0埋め，4が4桁を表す
    is_deep_night := (now_time > 2300 or now_time < 500)

    ; ウィンドウリストを取得
    id_list := WinGetList()

    for id in id_list {
        ; ウィンドウタイトルを取得し，変なやつを除去
        title := WinGetTitle("ahk_id " id)
        if (title == "" or title == "PopupHost" or title == "Program Manager" or InStr(title, "OCRMODE", true) or InStr(title, "MainWnd", true) or InStr(title, "PfuSsMon", true)) {
            continue
        }

        ; ここで操作を実行
        if (is_private(title)) {
            private_count += 0.5
            is_privateing := true
            if (private_count == 150) {
                ToolTip("last 5 min!!! " private_count)
            }
            
            ; ウィンドウを閉じる処理
            if (private_count > 180 or is_deep_night or is_youtube_home(title)) {
                WinActivate("ahk_id " id)
                close_window()
                private_count := 720
                is_privateing := false
                Sleep(5000)
                ToolTip("")
            }

            ToolTip("I just noticed you looking at private window!!! " private_count)
            break
        } else {
            if (private_count > 0) {
                if (!is_privateing) {
                    private_count -= 0.5
                } else {
                    private_count -= 0.025
                }
            }
            ToolTip("")
        }
    }
}
