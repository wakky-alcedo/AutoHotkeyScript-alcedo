; どうやら，AHKは Shift JISで動いているようだ
#Requires AutoHotkey v2.0

close_window() {
    Send("!{F4}")
    ToolTip("Close Window!!!")
    Sleep(1000)
    ToolTip("")
}

is_private(title) {
    title := WinGetTitle("A") ; タイトルを取得

    ; Vivaldi
    if (InStr(title, "Vivaldi", true)) {
        color := PixelGetColor(30, 10)
        if (color == 0x764040) {
            return true
        }
    }

    ; Chrom
    if (InStr(title, "Chrom", true)) {
        color := PixelGetColor(50, 40)
        if (color == 0x3C3C3C) {
            return true
        }
    }
    ToolTip(title " " is_privateing " " private_count " " color )
    Sleep(1000)
    ToolTip("")
    return false
}

; 初期処理
SetTimer(OnTimer, -5000) ; 5sec
global private_count := 0
global is_privateing := false
Return

; タイマー内
OnTimer(*) {
    global private_count, is_privateing  ; グローバル変数を宣言

    now_time := Format("{:04}", A_Hour, A_Min) ; 現在時刻を "HHmm" の数値形式で取得
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
            is_youtube_home := (InStr(title, "YouTube", true) and !InStr(title, "- YouTube -", true))

            private_count += 0.5
            is_privateing := true
            if (private_count == 150) {
                ToolTip("last 5 min!!! " private_count)
            }
            if (private_count > 180 or is_deep_night or is_youtube_home) {
                WinActivate("ahk_id " id)
                close_window()
                private_count := 720
                is_privateing := false
                Sleep(5000)
                ToolTip("")
                SetTimer(OnTimer, -5000) ; 5sec
            } else {
                SetTimer(OnTimer, -5000) ; 5sec
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
            SetTimer(OnTimer, -5000) ; 5sec
            ToolTip("")
        }
    }
}
