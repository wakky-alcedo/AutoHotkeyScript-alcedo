; ウィンドウリストを取得
WinGet, id, list
; ウィンドウリストを取得 (Zオーダー順)（ウィンドウの前面順序）
; WinGet, id, list, , , Program Manager


; トップレベルウィンドウの枚数をカウント
topLevelCount := 0
; 表面に見えているウィンドウの枚数をカウント
visibleCount := 0
; すべてのウィンドウのタイトルを表示する変数
allTitles := ""

Loop % id {
    this_id := id%A_Index%
    
    ; ウィンドウタイトルを取得し，変なやつを除去
    WinGetTitle, title, ahk_id %this_id%
    if (title = "" or title = "PopupHost" or title = "Program Manager" or InStr(title,"OCRMODE", CaseSensitive=ture) or InStr(title,"MainWnd", CaseSensitive=ture) or InStr(title,"PfuSsMon", CaseSensitive=ture)) {
        continue
    }
    
    ; タイトルをリストに追加
    allTitles .= "Window ID: " this_id "`nTitle: " title "`n`n"
    
    topLevelCount++

    ; ここで操作を実行
    ; topLevelCountが一定以下の場合は、ウィンドウをアクティブにする
    ; if (topLevelCount <= 6) {
    ;     WinActivate, ahk_id %this_id%
    ;     ; WinGetTitle, title, ahk_id %this_id%
    ;     WinGetTitle, title, A ; タイトルを取得（Aがなんの意味なのかはわからない）
    ;     MsgBox, % "Window ID: " this_id "`nTitle: " title
    ; }

}

; トップレベルウィンドウの枚数を表示
MsgBox, 開いているトップレベルウィンドウの枚数は %topLevelCount% です。
; 表面に見えているウィンドウの枚数を表示
MsgBox, 表面に見えているウィンドウの枚数は %visibleCount% です。
; すべてのウィンドウのタイトルを表示
MsgBox, % allTitles

return