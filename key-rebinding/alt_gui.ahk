global MyGui := "" ; MyGuiをグローバルに宣言

Alt & Ctrl:: {
    SetTimer(GuiClose, -5000)  ; 5秒後にGuiCloseを呼び出す
    global MyGui  ; 関数内でMyGuiをグローバルに宣言

    activeWindowProcess := WinGetProcessName("A")  ; 現在アクティブなウィンドウのプロセス名を取得
    activeWindowTitle := WinGetTitle("A")  ; 現在アクティブなウィンドウのタイトルを取得

    if (MyGui) { 
        MyGui.Destroy()  ; 既存のGUIを破棄
    }
    MyGui := Gui()

    ; アクティブウィンドウがVSCodeの場合
    if (activeWindowProcess = "Code.exe") {
        if InStr(activeWindowTitle, ".md") {
            MyGui.Add("Text", , "VSCode Markdown")
            MyGui.Add("Button", "", "強調 (&b)").OnEvent("Click", Bold)
            MyGui.Add("Button", "", "斜体 (&i)").OnEvent("Click", Italic)
            MyGui.Add("Button", "", "打ち消し線 (&s)").OnEvent("Click", Strikethrough)
            MyGui.Add("Button", "", "チェックボックス (&c)").OnEvent("Click", Checkboxs)
            MyGui.Add("Button", "", "引用 (&q)").OnEvent("Click", Citations)
            MyGui.Add("Button", "", "インラインコード (&`)").OnEvent("Click", InlineCode)
            MyGui.Add("Button", "", "コードブロック (&k)").OnEvent("Click", CodeBlock)
            MyGui.Add("Button", "", "箇条書き (&.)").OnEvent("Click", BulletPoints)
            MyGui.Add("Button", "", "テーブル (&t)").OnEvent("Click", Table)
        }
    }

    ; MyGui := Gui.new()
    MyGui.Add("Text", , "default")
    MyGui.Add("Button", "", "Google検索 (&g)").OnEvent("Click", Google)
    MyGui.Add("Button", "", "Notepad起動 (&n)").OnEvent("Click", NotepadStart)
    MyGui.Show()
}

; VSCode用のアクション
SendCmd(cmd) {
    GuiClose()
    Send("^m")
    Send("^m")
    Sleep(100)
    Send(cmd)
    Sleep(100)
    Send("{Enter}")
}

Bold(*) {
    SendCmd("bold")
}

Italic(*) {
    SendCmd("italic")
}

Strikethrough(*) {
    SendCmd("strikethrough")
}

Checkboxs(*) {
    SendCmd("checkboxs")
}

Citations(*) {
    SendCmd("citations")
}

InlineCode(*) {
    SendCmd("inline code")
}

CodeBlock(*) {
    SendCmd("code block")
}

BulletPoints(*) {
    SendCmd("bullet points")
}

Table(*) {
    SendCmd("table")
}

Google(*) {
    sendText("aaa")
}

NotepadStart(*) {
    Run("notepad.exe")  ; メモ帳を開く
}

sendText(text) {
    GuiClose()
    Send(text)
}

GuiEscape() { ; Escキーが押されたときに実行
    GuiClose()
}

GuiClose() { ; ☓を押したときに実行
    ; MyGui.Submit()
    ; MyGuiが存在するか確認し、存在する場合は破棄
    if (IsObject(MyGui)) {
        MyGui.Destroy()  ; 既存のGUIを破棄
    }
}
