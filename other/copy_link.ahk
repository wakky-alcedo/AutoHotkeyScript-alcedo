; #Include, %A_ScriptDir%\..\PluginList.ahk  ; プラグインをインクルード
; #Include, %A_ScriptDir%\..\Plugins\common_functions.ahk  ; プラグインをインクルード

global copyed_link := ""
global copyed_title := ""

; Ctrl + Shift + C で実行
^+c::{
    ; global ; V1toV2: Made function global
    global copyed_link
    global copyed_title
    ; focusCtrl := ControlGetClassNN(ControlGetFocus("A"))
    Send("^l")       ; アドレスバーに移動
    Sleep(200)
    Send("^c")       ; URLをコピー
    Sleep(200)
    Errorlevel := !ClipWait(1)    ; クリップボードの内容を待つ
    copyed_link := A_Clipboard

    ; タイトルの取得 (ウィンドウタイトル)
    copyed_title := WinGetTitle("A")
    position := InStr(copyed_title, " - ", , -1)  ; これは左から最初に見つかる位置
    if (position > 0) {
        copyed_title := SubStr(copyed_title, 1, position)
    }
    A_Clipboard := copyed_title
    

    ; URLとタイトルをクリップボードにコピー
    ; Clipboard := "Title: " copyed_title "`nURL: " copyed_link
    timeout := 3 ; 通知を表示する時間（秒）
    text := "URLとタイトルをクリップボードにコピーしました。`nTitle: " . copyed_title . "`nURL: " . copyed_link
    ; MsgBox, 0, information, URLとタイトルをクリップボードにコピーしました。`nTitle: %copyed_title%`nURL: %copyed_link%, %timeout%
    my_tooltip_function(text, timeout * 1000)
    return
} ; V1toV2: Added bracket in the end
