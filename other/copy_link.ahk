; #Include, %A_ScriptDir%\..\PluginList.ahk  ; プラグインをインクルード
; #Include, %A_ScriptDir%\..\Plugins\common_functions.ahk  ; プラグインをインクルード

; Ctrl + Shift + C で実行
^+c::
    ; ChromeまたはEdgeのアクティブウィンドウを取得
    ; if (WinActive("ahk_class Chrome_WidgetWin_1") or WinActive("ahk_class Chrome_WidgetWin_0"))
    ; {
        ; URLの取得 (アドレスバーにフォーカスしてコピー)
{ ; V1toV2: Added bracket
global ; V1toV2: Made function global
        ; focusCtrl := ControlGetClassNN(ControlGetFocus("A"))
        Send("^l")       ; アドレスバーに移動
        Sleep(200)
        Send("^c")       ; URLをコピー
        Sleep(200)
        Errorlevel := !ClipWait(1)    ; クリップボードの内容を待つ
        url := A_Clipboard

        ; タイトルの取得 (ウィンドウタイトル)
        title := WinGetTitle("A")
        A_Clipboard := title
        

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
} ; V1toV2: Added bracket in the end
