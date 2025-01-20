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

is_private() {
    if (!WinExist("A")) { ; アクティブなウィンドウがあるか確認
        return false
    }
    title := WinGetTitle("A") ; タイトルを取得

    ; Vivaldi
    if (InStr(title, "Vivaldi", true)) {
        color := PixelGetColor(30, 10)
        if (color == 0x404076) {
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
    ; ToolTip(title " " color )
    ; Sleep(3000)
    ; ToolTip("")
    return false
}

is_twitter(title) {
    return (InStr(title, "X - ", true) != 0 && (InStr(title, "ホーム", true) != 0 || InStr(title, "Home", true) != 0))
}

is_temptation(title) {
    return (InStr(title, "Prime Video", true) != 0 || InStr(title, "DMM TV", true) != 0 || title == "YouTube")
}

is_youtube(title) {
    return (InStr(title, "YouTube", true) != 0 && InStr(title, "YouTube Music", true) == 0)
}

is_youtube_home(title) {
    return (is_youtube(title) && InStr(title, "- YouTube -", true) == 0 && InStr(title, "YouTube -", true) == 1)
}