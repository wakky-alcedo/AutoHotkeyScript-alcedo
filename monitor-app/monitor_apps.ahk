; どうやら，AHKは Shift JISで動いているようだ
#Requires AutoHotkey v2.0

#Include monitor_app_func.ahk


; 初期処理
SetTimer(OnTimer, 6000) ; 6sec(0.1min)
global private_count := 30
global is_privateing := false
global twitter_count := 5
Return

; タイマー内
OnTimer(*) {
    ToolTip("") ; ツールチップを消す

    global private_count, is_privateing, twitter_count  ; グローバル変数を宣言

    now_time := Format("{:04}", A_Hour, A_Min) ; 現在時刻を "HHmm" の数値形式で取得 :が書式設定の開始，0が0埋め，4が4桁を表す
    ; now_time := Format("{:02}{:02}", A_Hour, A_Min)
    is_deep_night := (now_time > 2300 or now_time < 700)
    is_deep_deep_night := (now_time > 0 and now_time < 700)

    ; ウィンドウリストを取得
    id_list := WinGetList()

    for id in id_list {
        ; ウィンドウタイトルを取得し，変なやつを除去
        title := WinGetTitle("ahk_id " id)
        if (title == "" or title == "PopupHost" or title == "Program Manager" or InStr(title, "OCRMODE", true) or InStr(title, "MainWnd", true) or InStr(title, "PfuSsMon", true)) {
            continue
        }

        ; ここで操作を実行
        
        ; 深夜の誘惑チェック
        if (is_deep_night && (is_temptation(title) || is_twitter(title))) {
            WinActivate("ahk_id " id)
            close_tab()
            continue
        }

        ; 深夜のYouTubeチェック
        if (is_deep_deep_night && is_youtube(title)) {
            WinActivate("ahk_id " id)
            close_tab()
            continue
        }

        ; 深夜のタスクスケジューラチェック
        if (is_deep_night && InStr(title, "タスク スケジューラ", true)) {
            WinActivate("ahk_id " id)
            close_window()
            continue
        }

        ; Twitterのチェック
        if (is_twitter) {
            twitter_count -= 0.1
            if (twitter_count < 0) {
                close_tab()
            }
            ToolTip("I just noticed you looking at Twitter!!! " twitter_count)
        } else {
            if (twitter_count < 5) {
                twitter_count += 0.1
            }
        }

        ; プライベートウィンドウのチェック
        if (is_private(title)) {
            private_count -= 0.1
            is_privateing := true
            if (private_count == 5) {
                ToolTip("last 5 min!!! " private_count)
            }
            
            ; ウィンドウを閉じる処理
            if (private_count < 0 or is_deep_night or is_youtube_home(title)) {
                WinActivate("ahk_id " id)
                close_window()
                private_count := 0
            }

            ; ToolTip("I just noticed you looking at private window!!! " private_count)
            break
        } else {
            if (private_count < 30) {
                if (!is_privateing) {
                    private_count += 0.1
                } else {
                    private_count += 0.005
                }
            }
        }
    }
}
