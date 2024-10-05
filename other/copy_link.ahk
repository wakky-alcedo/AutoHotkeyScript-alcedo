; #Include, %A_ScriptDir%\..\PluginList.ahk  ; プラグインをインクルード
#Include, %A_ScriptDir%\..\Plugins\common_functions.ahk  ; プラグインをインクルード

; Ctrl + Shift + C で実行
^+c::
    ; ChromeまたはEdgeのアクティブウィンドウを取得
    ; if (WinActive("ahk_class Chrome_WidgetWin_1") or WinActive("ahk_class Chrome_WidgetWin_0"))
    ; {
        ; URLの取得 (アドレスバーにフォーカスしてコピー)
        ControlGetFocus, focusCtrl, A
        Send, ^l       ; アドレスバーに移動
        Sleep, 200
        Send, ^c       ; URLをコピー
        ClipWait, 1    ; クリップボードの内容を待つ
        url := Clipboard

        ; タイトルの取得 (ウィンドウタイトル)
        WinGetTitle, title, A
        Clipboard := title
        

        ; URLとタイトルをクリップボードにコピー
        ; Clipboard := "Title: " title "`nURL: " url
        timeout := 3 ; 通知を表示する時間（秒）
        text := "URLとタイトルをクリップボードにコピーしました。`nTitle: " . title . "`nURL: " . url
        ; MsgBox, 0, information, URLとタイトルをクリップボードにコピーしました。`nTitle: %title%`nURL: %url%, %timeout%
        my_tooltip_function(text, timeout * 1000)

    ; }
    ; else
    ; {
    ;     MsgBox, このスクリプトはGoogle ChromeまたはMicrosoft Edgeでのみ動作します。
    ; }
return
