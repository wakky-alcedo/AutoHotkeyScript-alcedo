#SingleInstance Force  ; スクリプトの重複実行を防ぐ

Persistent ; スクリプトが常駐するように設定
SetTimer(CheckCursor,100) ; ウィンドウの監視を100ミリ秒ごとに開始

; Return

CheckCursor() { ; Ctrlキーが押されているか確認
global ; V1toV2: Made function global
    if !GetKeyState("Ctrl", "P")
        Return  ; 押されていなければ何もしない

    ; アクティブウィンドウを取得
    active_id := WinGetID("A")

    ; ウィンドウのクラス名を取得
    active_class := WinGetClass("ahk_id " active_id)
    
    ; クラス名がエクスプローラやFilesの場合のみ処理
    if (active_class = "CabinetWClass" || active_class = "WinUIDesktopWin32WindowClass") ; Filesの実際のクラス名に置き換えてください
    {
        ; ウィンドウの位置とサイズを取得
        WinGetPos(&X, &Y, &Width, &Height, "ahk_id " active_id)
        
        ; マウスカーソルの位置を取得
        CoordMode("Mouse", "Screen")
        MouseGetPos(&mouseX, &mouseY, &mouseWin)

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
                WinMinimize("ahk_id " active_id)
            }
        }
    }
    Return
}