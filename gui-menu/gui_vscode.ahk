#Requires AutoHotkey v2.0

gui_vscode(activeWindowTitle) {
    MyGui.Add("Text", , "VSCode")
    if InStr(activeWindowTitle, ".md") {
        MyGui.Add("Text", , "VSCode Markdown")
        MyGui.Add("Button", "", "強調 (&b)").OnEvent("Click", Bold)
        MyGui.Add("Button", "", "斜体 (&i)").OnEvent("Click", Italic)
        MyGui.Add("Button", "", "打ち消し線 (&s)").OnEvent("Click", Strikethrough)

        MyGui.Add("Button", "", "引用 (&q)").OnEvent("Click", Citations)
        MyGui.Add("Button", "", "数式 (&m)").OnEvent("Click", Formula)
        MyGui.Add("Button", "", "インラインコード (&`)").OnEvent("Click", InlineCode)
        MyGui.Add("Button", "", "コードブロック (&k)").OnEvent("Click", CodeBlock)

        MyGui.Add("Button", "", "箇条書き (&.)").OnEvent("Click", BulletPoints)
        MyGui.Add("Button", "", "番号付き箇条書き (&,)").OnEvent("Click", NumberedBulletPoints)
        MyGui.Add("Button", "", "チェックボックス (&h)").OnEvent("Click", Checkboxs)
        
        MyGui.Add("Button", "", "テーブル (&t)").OnEvent("Click", Table)
    }
    MyGui.Add("Button", "", "計算機 (&c)").OnEvent("Click", Calculator)
}

; VSCode用のアクション
; 拡張機能：Markdown Shortcuts
SendCmdMSGUI(cmd) {
    GuiClose()
    Send("^m")
    Send("^m")
    Sleep(100)
    send_text(cmd)
    Sleep(100)
    Send("{Enter}")
}
Bold(*)                 => SendCmdMSGUI("bold")
Italic(*)               => SendCmdMSGUI("italic")
Strikethrough(*)        => SendCmdMSGUI("strikethrough")
Checkboxs(*)            => SendCmdMSGUI("checkboxes")
Citations(*)            => SendCmdMSGUI("citations")
Formula(*)              => Send("$$")
InlineCode(*)           => SendCmdMSGUI("inline code")
CodeBlock(*)            => SendCmdMSGUI("code block")
BulletPoints(*)         => SendCmdMSGUI("bullet points")
NumberedBulletPoints(*) => SendCmdMSGUI("number list")
Table(*)                => SendCmdMSGUI("table")

; 短縮キー
#HotIf InStr(WinGetTitle("A"), ".md") && InStr(WinGetTitle("A"), "Visual Studio Code")
^b::Bold()
^i::Italic()
; ^s::Strikethrough()
^q::Citations()
^m::Formula()
^`::InlineCode()
^k::CodeBlock()
^.::BulletPoints()
^,::NumberedBulletPoints()
^h::Checkboxs()
^t::Table()
#HotIf

; 拡張機能：Calculator
Calculator(*) {
    GuiClose()
    Send("^l")
    Send("+{Left}")
    SendCmdGUI("calculator evaluate")
    Sleep(200)
    Send("{Right}")
}