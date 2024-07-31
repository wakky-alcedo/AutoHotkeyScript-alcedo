; ウィンドウリストを取得 (Zオーダー順)（ウィンドウの前面順序）
WinGet, id, list
; WinGet, id, list, , , Program Manager



; トップレベルウィンドウの枚数をカウント
topLevelCount := 0
; 表面に見えているウィンドウの枚数をカウント
visibleCount := 0

Loop % id {
    this_id := id%A_Index%
    
    ; ウィンドウがトップレベルかどうかを確認
    WinGet, Style, Style, ahk_id %this_id%
    if (Style & 0x40000)  ; WS_CHILD がセットされていない場合、トップレベルウィンドウ
    {
        continue
    }
    
    ; VSCodeウィンドウをフィルタリング
    WinGetClass, class, ahk_id %this_id%
    if (class = "Chrome_WidgetWin_1") {
        ; VSCodeのタイトルを取得してカウント
        WinGetTitle, title, ahk_id %this_id%
        if InStr(title, "Visual Studio Code") {
            continue
        }
    }
    
    topLevelCount++

    ; ここで操作を実行
    ; topLevelCountが一定以下の場合は、ウィンドウをアクティブにする
    ; if (topLevelCount <= 2) {
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


; ; ウィンドウの数を表示
; MsgBox, % "Number of windows: " id



; ; ウィンドウリストを逆順に処理
; Loop % id {
;     ; ウィンドウIDを取得
;     this_id := id%A_Index%
    
;     ; ウィンドウタイトルを取得
;     ; WinGetTitle, title, ahk_id %this_id%
;     ; WinActivate, ahk_id %this_id%
    
;     ; ウィンドウタイトルを表示（デバッグ用）
;     ; MsgBox, % "Window ID: " this_id "`nTitle: " title
    
;     ; ウィンドウが存在するか確認
;     ; if WinExist("ahk_id " this_id) {
;     ;     ; ウィンドウをアクティブにする
;     ;     WinActivate, ahk_id %this_id%
;     ; }
; }