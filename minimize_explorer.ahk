#Persistent  ; スクリプトが常駐するように設定
#SingleInstance Force  ; スクリプトの重複実行を防ぐ

; ウィンドウの監視を100ミリ秒ごとに開始
SetTimer, CheckCursor, 100
Return

CheckCursor:
    ; アクティブウィンドウを取得
    WinGet, active_id, ID, A

    ; ウィンドウのクラス名を取得
    WinGetClass, class, ahk_id %active_id%
    
    ; クラス名がエクスプローラやFilesの場合のみ処理
    if (class = "CabinetWClass" || class = "WinUIDesktopWin32WindowClass") ; Filesの実際のクラス名に置き換えてください
    {
        ; ウィンドウの位置とサイズを取得
        WinGetPos, X, Y, Width, Height, ahk_id %active_id%
        
        ; マウスカーソルの位置を取得
        CoordMode, Mouse, Screen
        MouseGetPos, mouseX, mouseY, mouseWin

        ; デバッグ情報を表示
        ;ToolTip Class %class% WinPos %X% %Y% Size %Width% x %Height% MousePos %mouseX% %mouseY%
        ;ToolTip "Class: %class%`nWinPos: (X: %X%, Y: %Y%) Size: (W: %Width%, H: %Height%)`nMousePos: (X: %mouseX%, Y: %mouseY%)"

        ; カーソルがウィンドウ内にあるか確認
        margin := 100
        if (mouseX+margin < X || mouseX-margin > (X + Width) || mouseY+margin < Y || mouseY-margin > (Y + Height))
        {
            ; アクティブウィンドウがドラッグされているか確認
            if (GetKeyState("LButton", "P"))
            {
                ; アクティブウィンドウを最小化
                WinMinimize, ahk_id %active_id%
            }
        }
    }
Return
