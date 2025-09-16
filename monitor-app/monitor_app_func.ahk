#Requires AutoHotkey v2.0

; UIAライブラリを読み込む
#Include "UIA.ahk"

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
        try {
            ; UIAライブラリを使用してウィンドウの要素を取得
            windowElement := UIA.ElementFromHandle(WinExist("A"))
            ; ウィンドウの直下にある全ての子要素を取得
            childElements := windowElement.FindAll()
            ; 各要素の情報をリストに追加
            for element in childElements {
                ; "シークレット" という文字が含まれていないか
                if InStr(element.Name, "シークレット") {
                    return true
                }
            }
        } catch Error as e {
            ToolTip("UIAエラー: " e.Message, , , 1)
            SetTimer(() => ToolTip("", , , 1), -2000)
            return false
        }

    }

    ; Edge
    if (InStr(title, "Microsoft Edge", true) && InStr(title, "InPrivate", true)) {
        return true
    }

    ; ToolTip(title " " color )
    ; Sleep(3000)
    ; ToolTip("")
    return false
}

is_twitter(title) {
    ; return (InStr(title, "X - ", true) != 0 && (InStr(title, "ホーム", true) != 0 || InStr(title, "Home", true) != 0))
    ; return (InStr(title, "X - ", true))
    ; return (InStr(title, "ホーム / X", true) != 0 || InStr(title, "Home / X", true) != 0)
    return (title = "ホーム / X" || title = "Home / X" || title = "X" || title = "話題を検索 / X")
}

is_temptation(title) {
        ; 動画系
    return (InStr(title, "Prime Video", true) != 0
        || InStr(title, "DMM TV", true) != 0
        || InStr(title, "Netflix", true) != 0
        || InStr(title, "Disney+", true) != 0
        || InStr(title, "Hulu", true) != 0
        || InStr(title, "U-NEXT", true) != 0
        || InStr(title, "FOD", true) != 0
        || InStr(title, "Paravi", true) != 0
        || InStr(title, "ABEMA", true) != 0
        || InStr(title, "Rakuten TV", true) != 0
        ; 漫画系
        || InStr(title, "少年ジャンプ", true) != 0
        || InStr(title, "マンガUP!", true) != 0
        || InStr(title, "LINEマンガ", true) != 0
        || InStr(title, "ピッコマ", true) != 0
        || InStr(title, "Kindle", true) != 0
        || InStr(title, "BookLive", true) != 0
        || InStr(title, "コミックシーモア", true) != 0
        || InStr(title, "マンガBANG!", true) != 0
        || InStr(title, "マンガPark", true) != 0
        || InStr(title, "マンガボックス", true) != 0
        || InStr(title, "マンガZERO", true) != 0
        ; なろう系
        || InStr(title, "薬屋のひとりごと", true) != 0
        || InStr(title, "日本国召喚", true) != 0
        || InStr(title, "転校先の清楚可憐な美少女が、", true) != 0
        || InStr(title, "お隣の天使様にいつの間にか駄目人間にされていた件", true)
        || InStr(title, "転生したらスライムだった件", true) != 0
    )
}

is_youtube(title) {
    return (InStr(title, "YouTube", true) != 0 && InStr(title, "YouTube Music", true) == 0)
}

is_youtube_home(title) {
    ; return (is_youtube(title) && InStr(title, "- YouTube", true) == 0)
    return title = "YouTube"
}


saveTextToFile(filePath, text, append := false) {
    mode := append ? "a" : "w" ; 追記モードか書き込みモードを選択
    opened_file := FileOpen(filePath, mode, "utf-8") ; ファイルを開く
    if !opened_file {
        MsgBox("ファイルを開けません: " filePath)
        return false
    }
    opened_file.Write(text "`n") ; テキストを書き込む（改行付き）
    opened_file.Close()
    return true
}

isTextInFile(filePath, searchText) {
    if !FileExist(filePath) {
        MsgBox("ファイルが存在しません: " filePath)
        return false
    }
    opened_file := FileOpen(filePath, "r", "utf-8") ; ファイルを読み取りモードで開く
    if !opened_file {
        MsgBox("ファイルを開けません: " filePath)
        return false
    }
    while !opened_file.AtEOF {
        line := opened_file.ReadLine()
        if InStr(line, searchText, true) {
            opened_file.Close()
            return true
        }
    }
    opened_file.Close()
    return false
}

/**
 * ウィンドウをアクティブ化する
 * @param {String} title ウィンドウのタイトルまたは "ahk_id <ウィンドウID>"
 * @returns {Integer} 成功したら true、失敗したら false
 */
activateWindow(title) {
    try {
        WinActivate(title)
        return true
    } catch Error as e {
        ToolTip("WinActivateエラー: " e.Message, , , 1)
        SetTimer(() => ToolTip("", , , 1), -2000)
        return false
    }
}