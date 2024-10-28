#Requires AutoHotkey v2.0

close_tab() {
    Send("^w")
    ToolTip("Close Tab!!!")
    Sleep(1000)
    ToolTip("")
}

close_window() {
    Send("!{F4}")
    ToolTip("Close Window!!!")
    Sleep(1000)
    ToolTip("")
}

; 初期処理
SetTimer(OnTimer, -10000) ; 10sec
global twitter_count := 0
global was_twitter := 0
Return

; タイマー内
OnTimer(*) {
    global twitter_count, was_twitter

    ; 現在時刻を取得
    now_time := Format("{:04}", A_Hour, A_Min)
    is_deep_night := (now_time > 2300 or now_time < 700)
    is_deep_deep_night := (now_time > 0 and now_time < 700)

    is_twitter_in_window := false

    ; ウィンドウリストを取得
    id_list := WinGetList()

    for id in id_list {
        title := WinGetTitle("ahk_id " id)

        is_twitter := (InStr(title, "X - ", true) != 0 && InStr(title, "ホーム", true) != 0)
        is_temptation := (InStr(title, "Prime Video", true) != 0 || InStr(title, "DMM TV", true) != 0 || title == "YouTube")
        is_youtube := (InStr(title, "YouTube", true) != 0 && InStr(title, "YouTube Music", true) == 0)
        is_youtube_home := (InStr(title, "YouTube", true) != 0 && InStr(title, "- YouTube -", true) == 0)

        is_twitter_in_window := is_twitter_in_window || is_twitter

        ; 深夜の誘惑チェック
        if (is_deep_night && (is_temptation || is_twitter)) {
            WinActivate("ahk_id " id)
            close_tab()
            continue
        }

        ; 深夜のYouTubeチェック
        if (is_deep_deep_night && is_youtube) {
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
    }

    if (is_twitter_in_window) {
        if (was_twitter || twitter_count > 0) {
            close_tab()
            if (was_twitter) {
                twitter_count := 360
            }
            SetTimer(OnTimer, -5000) ; 5sec
        } else {
            SetTimer(OnTimer, -300000) ; 5min
        }
        was_twitter := 1

        ToolTip("I just noticed you looking at Twitter!!! " twitter_count)
        Sleep(5000)
        ToolTip("")
    } else {
        was_twitter := 0
        if (twitter_count > 0) {
            twitter_count -= 0.5
        }
        SetTimer(OnTimer, -5000) ; 5sec
    }
}
