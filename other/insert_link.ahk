; #Include, %A_ScriptDir%\..\PluginList.ahk  ; プラグインをインクルード
; #Include, %A_ScriptDir%\..\Plugins\IME.ahk

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


; タイトルを貼り付け
paste_title() {
    Send("#v")
    Sleep(500)
    Send("{Enter}")
}

; リンクを貼り付け
paset_link() {
    Sleep(100)
    Send("#v")
    Sleep(400)
    Send("{Down}")
    Sleep(100)
    Send("{Enter}")
} 

^+v:: {
    ; global ; V1toV2: Made function global
    global copyed_link
    global copyed_title
    BlockInput("on")
    SendMode("Input")
    is_IME := IME_GET()
    if (is_IME = 1) {
        IME_SET(0) ; 半角に
    }
    Sleep(100)

    ; アクティブウィンドウの実行ファイルを取得
    active_exe := WinGetProcessName("A")
    If(active_exe = "ApplicationFrameHost.exe") ; OneNote
    {
        ; リンクの挿入を開く
        Send("^k")
        Sleep(200)
        ; リンクを貼り付け
        ; paset_link()
        send_text(copyed_link)
        Sleep(500)
        ; カーソルの移動
        Send("+{Tab}")
        Sleep(200)
        ; タイトルを貼り付け
        ; paste_title()
        send_text(copyed_title)
        ;Sleep 500
        ; 確定
        ;Send,{Enter}
    }Else If(active_exe = "slack.exe") ; Slack
    {
        ; リンクの挿入を開く
        Send("^+u")
        Sleep(200)
        ; タイトルを貼り付け
        ; Send("^v")
        send_text(copyed_title)
        ; カーソルの移動
        Send("{Tab}")
        Sleep(200)
        ; リンクを貼り付け
        ; paset_link()
        send_text(copyed_link)
        Sleep(500)
        ; 確定
        Send("{Enter}")
    ; }Else If(active_exe = "Discord.exe") ; Discord
    ; {
    ;     Send("[")
    ;     ; タイトルを貼り付け
    ;     Send("^v")
    ;     Sleep(100)
    ;     ; カーソルの移動
    ;     Send("](<")
    ;     Sleep(100)
    ;     ; リンクを貼り付け
    ;     paset_link()
    ;     Sleep(500)
    ;     ; 確定
    ;     Send(">)")
    }Else If(active_exe = "explorer.exe") ; ファイルエクスプローラ
    {
        ; リンクの挿入を開く
        ; 右クリック
        MouseClick("right")
        Sleep(200)
        Send("w")
        Send("s")
        Sleep(400)
        ; リンクを貼り付け
        ; paset_link()
        send_text(copyed_link)
        Sleep(500)
        ; 次へ
        Send("{Enter}")
        Sleep(200)
        ; タイトルを貼り付け
        ; paste_title()
        send_text(copyed_title)
        Sleep(500)
        ; 確定
        Send("{Enter}")
    }Else{
        ; Send("[")
        ; ; タイトルを貼り付け
        ; ; Send("^v")
        ; ; Sleep(100)
        ; paste_title()
        ; Sleep(500)
        ; ; カーソルの移動
        ; Send("](")
        ; Sleep(100)
        ; ; リンクを貼り付け
        ; paset_link()
        ; Sleep(500)
        ; Send(")")
        markdown_link := "[" . copyed_title . "](" . copyed_link . ")"
        send_text(markdown_link)
    }

    if (is_IME = 1) {
        IME_SET(1) ; 全角に
    }
    BlockInput("off")
    return
}


; 保存したら自動で再実行するらしい？
;SetTitleMatchMode,2 #IfWinActive  Notepad++
;	~^s::Reload #IfWinActive
