; OneNoteでのリンクを挿入を自動化
; 使い方
; 1. URL，タイトルの順にクリップボードにコピー
; 2. OneNote上で，shift+ctrl+vを押す 

#Include, %A_ScriptDir%\PluginList.ahk  ; プラグインをインクルード

; タイトルを貼り付け
paste_title() {
    Send,#v
    Sleep 400
    Send,{Enter}
}

; リンクを貼り付け
paset_link() {
    Send,#v
    Sleep 400
    Send,{Down}
    Send,{Enter}
} 

+^v::
    ;MsgBox, Hello AutoHotkey world
    ;SetKeyDelay[, 300, 2]
    BlockInput, on
    SendMode Input
    is_IME := IME_GET()
    if (is_IME = 1) {
        IME_SET(0) ; 半角に
    }
    Sleep 100

    ; アクティブウィンドウの実行ファイルを取得
    WinGet, active_exe, ProcessName, A

    If(active_exe = "ApplicationFrameHost.exe") ; OneNote
    {
        ; リンクの挿入を開く
        Send,^k
        Sleep 200
        ; リンクを貼り付け
        paset_link()
        Sleep 500
        ; カーソルの移動
        Send,+{Tab}
        Sleep 200
        ; タイトルを貼り付け
        paste_title()
        ;Sleep 500
        ; 確定
        ;Send,{Enter}
    }Else If(active_exe = "slack.exe") ; Slack
    {
        ; リンクの挿入を開く
        Send,^+u
        Sleep 200
        ; タイトルを貼り付け
        Send,^v
        ; カーソルの移動
        Send,{Tab}
        Sleep 200
        ; リンクを貼り付け
        paset_link()
        Sleep 500
        ; 確定
        Send,{Enter}
    }Else If(active_exe = "Discord.exe") ; Discord
    {
        Send,[
        ; タイトルを貼り付け
        Send,^v
        Sleep 100
        ; カーソルの移動
        Send,](<
        Sleep 100
        ; リンクを貼り付け
        paset_link()
        Sleep 500
        ; 確定
        Send,>)
    }Else If(active_exe = "explorer.exe") ; ファイルエクスプローラ
    {
        ; リンクの挿入を開く
        ; 右クリック
        MouseClick, right
        Sleep 200
        Send,w
        Send,s
        Sleep 400
        ; リンクを貼り付け
        paset_link()
        Sleep 500
        ; 次へ
        Send,{Enter}
        Sleep 200
        ; タイトルを貼り付け
        paste_title()
        Sleep 500
        ; 確定
        Send,{Enter}
    }Else{
        Send,[
        ; タイトルを貼り付け
        Send,^v
        Sleep 100
        ; カーソルの移動
        Send,](
        Sleep 100
        ; リンクを貼り付け
        paset_link()
        Sleep 500
        ; 確定
        Send,)
    }

    if (is_IME = 1) {
        IME_SET(1) ; 全角に
    }
    BlockInput, off
    return


; 保存したら自動で再実行するらしい？
;SetTitleMatchMode,2 #IfWinActive  Notepad++
;	~^s::Reload #IfWinActive
