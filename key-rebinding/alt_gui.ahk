; !CapsLock::  ; ^はCtrl、!はAltの意味
Alt & Ctrl::
    ; ToolTip, Ctrl + Altが押されました
    SetTimer, GuiClose, -5000 ; 5秒後にToolTipを消す
    Gui, Destroy  ; 既存のGUIを破棄

    WinGet, activeWindowProcess, ProcessName, A ; 現在アクティブなウィンドウのプロセス名を取得
    ; MsgBox, %activeWindowProcess%
    WinGetTitle, activeWindowTitle, A ; 現在アクティブなウィンドウのタイトルを取得
    ; MsgBox, %activeWindowTitle%

    ; アクティブウィンドウがVSCodeの場合
    if (activeWindowProcess = "Code.exe") {
        if (InStr(activeWindowTitle, ".md")) {
            Gui, Destroy ; 既存のGUIを破棄
            Gui, Add, Text, , VSCode Markdown
            Gui, Add, Button, gBold, 強調 (&b)
            Gui, Add, Button, gItalic, 斜体 (&i)
            Gui, Add, Button, gStrikethrough, 打ち消し線 (&s)
            Gui, Add, Button, gCheckboxs, チェックボックス (&c)
            Gui, Add, Button, gCitations, 引用 (&q)
            Gui, Add, Button, gInlineCode, インラインコード (&`)
            Gui, Add, Button, gCodeBlock, コードブロック (&k)
            Gui, Add, Button, gBulletPoints, 箇条書き (&.)
            Gui, Add, Button, gTable, テーブル (&t)
        }
    }
    Gui, Add, Text, , default
    Gui, Add, Button, gGoogle, Google検索 (&g)
    Gui, Add, Button, , Google検索 (&n)
    ; Gui, Add, Button, a, Notepad起動 (n)
    Gui, Show
Return

; VSCode用のアクション

SendCmd(cmd) {
    Send, ^m
    Send, ^m
    Sleep, 100
    Send, %cmd%
    Sleep, 100
    Send, {Enter}
}

Bold:
    Gui, Destroy
    ; Send, ^B
    SendCmd("bold")
Return

Italic:
    Gui, Destroy
    ; Send, ^I 
    SendCmd("italic")   
Return

Strikethrough:
    Gui, Destroy
    ; Send, ^+s
    SendCmd("strikethrough")
Return

Checkboxs:
    Gui, Destroy
    ; Send, ^+c
    SendCmd("checkboxs")
Return

Citations:
    Gui, Destroy
    ; Send, ^+q
    SendCmd("citations")
Return

InlineCode:
    Gui, Destroy
    ; Send, ^+`
    SendCmd("inline code")
Return

CodeBlock:
    Gui, Destroy
    ; Send, ^+k
    SendCmd("code block")
Return

BulletPoints:
    Gui, Destroy
    ; Send, ^+.
    SendCmd("bullet points")
Return

Table:
    Gui, Destroy
    ; Send, ^+t
    SendCmd("table")
Return

; default:

; Google検索が選ばれたときのアクション
Google:
    Gui, Destroy
    sendText("aaa")
Return

; Notepad起動が選ばれたときのアクション
ButtonNotepad起動:
    Gui, Destroy
    Run, notepad.exe  ; メモ帳を開く
Return

sendText(text) {
    Gui, Destroy
    Send, %text%
}


; GUIを閉じるときのアクション
GuiEscape: ; Escキーが押されたときに自動的に実行されるラベル
GuiClose: ; ☓を押したときに自動的に実行されるラベル
    Gui, Submit
    Gui, Destroy
Return