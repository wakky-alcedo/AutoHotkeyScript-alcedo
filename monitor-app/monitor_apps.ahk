; どうやら，AHKは Shift JISで動いているようだ
#Requires AutoHotkey v2.0

#NoTrayIcon ; タスクトレイにアイコンを表示しない

#Include monitor_app_func.ahk
; #Include ..\Plugins\common_functions.ahk

; 初期処理
SetTimer(OnTimer, 6000) ; 6sec(0.1min)
Return

; タイマー内
OnTimer(*) {
    ; ツールチップの1~4を消す
    Loop 4 {
        ToolTip("", , , A_Index)
    }

    ; 以下のcountの単位はmin
    const_private_count := 30
    const_twitter_count := 5
    const_youtubehome_count := 5

    static private_count := const_private_count
    static twitter_count := const_twitter_count
    static youtubehome_count := const_youtubehome_count

    is_private_buff := false
    is_twitter_buff := false
    is_youtubehome_buff := false
    is_yotube_buff := false

    ; now_time := Format("{:04}", A_Hour, A_Min) ; 現在時刻を "HHmm" の数値形式で取得 :が書式設定の開始，0が0埋め，4が4桁を表す
    now_time := Format("{:02}{:02}", A_Hour, A_Min)
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

        ; 各要素のチェック
        ; 深夜の誘惑チェック
        if (is_deep_night && (is_temptation(title) || is_twitter(title))) {
            WinActivate("ahk_id " id)
            close_tab()
            continue
        }

        ; YouTubeチェック
        if (is_youtube_home(title)) {
            if (youtubehome_count <= 0 || is_deep_night){
                WinActivate("ahk_id " id)
                close_tab()
            } else {
                youtubehome_count -= 0.1
                is_youtubehome_buff := true
                ; my_tooltip_nodelay("youtube home %youtubehome_count%" , 2)
                ToolTip("youtube home" Round(youtubehome_count,1), , , 2)
            }
            continue
        }
        if (is_youtube(title)) {
            is_yotube_buff := true
            continue
        }

        ; Twitterのチェック
        if (is_twitter(title)) {
            if (twitter_count <= 0) {
                WinActivate("ahk_id " id)
                close_tab()
            } else {
                twitter_count -= 0.1
                is_twitter_buff := true
                ToolTip("twitter" Round(twitter_count,1), , , 3)
            }
            continue
        }

        ; プライベートウィンドウのチェック
        if (is_private(title)) {
            if (private_count <= 0 or is_deep_night or is_youtube_home(title)) {
                ; ウィンドウを閉じる処理
                WinActivate("ahk_id " id)
                close_window()
                private_count := 0
            } else {
                private_count -= 0.1
                is_private_buff := true
                ToolTip("private window" Round(private_count,1), , , 4)
            }
            continue
        }

        
        ; システム系のチェック
        ; 深夜のタスクスケジューラチェック
        if (is_deep_night && InStr(title, "タスク スケジューラ", true)) {
            WinActivate("ahk_id " id)
            close_window()
            ; ↓これを有効化しておかないと，うまく閉じれない
            ; https://syunsetsu.hatenablog.com/entry/2022/09/11/113247
            continue
        }

        ; タスクマネージャのチェック
        if (InStr(title, "タスク マネージャ", true) 
            && (twitter_count < const_twitter_count
                || private_count < const_private_count
                || youtubehome_count < const_youtubehome_count)) {
            WinActivate("ahk_id " id)
            close_window()
            continue
        }
    }

    ; 値を増やす
    if (!is_private_buff && private_count < const_private_count) {
        private_count += 0.05
    }
    if (!is_twitter_buff && twitter_count < const_twitter_count) {
        twitter_count += 0.05
    }
    if (!is_youtubehome_buff && !is_yotube_buff && youtubehome_count < const_youtubehome_count) {
        youtubehome_count += 0.05
    }
}
