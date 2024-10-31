global MyGui := "" ; MyGuiをグローバルに宣言


; ^!Shift::
; +!Ctrl::
; ^+Alt::
^#Shift::
+#Ctrl::
^+LWin::
; LWin & Ctrl:: 
; Ctrl & LWin::
; LWin & Ctrl & Shift:: 
; Ctrl & LWin & Shift::
; Shift & LWin & Ctrl:: 
; Shift & Ctrl & LWin::
; LWin & Shift & Ctrl:: 
; Ctrl & Shift & LWin::
{
    SetTimer(GuiClose, -5000)  ; 5秒後にGuiCloseを呼び出す
    global MyGui  ; 関数内でMyGuiをグローバルに宣言

    activeWindowProcess := WinGetProcessName("A")  ; 現在アクティブなウィンドウのプロセス名を取得
    activeWindowTitle := WinGetTitle("A")  ; 現在アクティブなウィンドウのタイトルを取得

    if (MyGui) { 
        MyGui.Destroy()  ; 既存のGUIを破棄
    }
    MyGui := Gui()
    MyGui.OnEvent("Escape", GuiClose) ; [ESC] キーで閉じる
    MyGui.OnEvent("Close", GuiClose) ; X で閉じる

    MyGui.Add("Text", , activeWindowTitle)

    ; アクティブウィンドウがVSCodeの場合
    if InStr(activeWindowTitle, "Visual Studio Code") {
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

    ; アクティブウィンドウがVivaldiの場合
    if InStr(activeWindowProcess, "vivaldi") {
        MyGui.Add("Text", , "Vivaldi")
        MyGui.Add("Button", "", "強制的にダークページを利用").OnEvent("Click", ForceDarkPage)
    }

    ; MyGui := Gui.new()
    MyGui.Add("Text", , "default")
    MyGui.Add("Button", "", "Google検索 (&g)").OnEvent("Click", Google)
    MyGui.Add("Button", "", "Notepad起動 (&n)").OnEvent("Click", NotepadStart)
    MyGui.Add("Button", "", "color picker").OnEvent("Click", RunColorPicker)
    MyGui.Add("Button", "", "スリープ").OnEvent("Click", PCSleep)
    MyGui.Add("Button", "", "time tracker").OnEvent("Click", RunTimeTracker)

    MyGui.Show()
}

SendTextGUI(text) {
    GuiClose()
    send_text(text)
}

SendCmdGUI(cmd) {
    GuiClose()
    Send("^+p")
    Sleep(100)
    send_text(cmd)
    Sleep(100)
    Send("{Enter}")
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

; vivaldi
ForceDarkPage(*) => sendKey("^!d") ; "すべてのウェブサイトにダークテーマを強制適用"のショートカットキー

Google(*)               => sendText("aaa")
NotepadStart(*)         => Run("notepad.exe")  ; メモ帳を開く
RunColorPicker(*)       => Send("+#c") ;Run("C:\Windows\System32\colorcpl.exe")  ; カラーピッカーを開く
PCSleep(*)              => DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)  ; スリープ
RunTimeTracker(*)       => Run(".\my-time-tracker\my-time-tracker.exe")  ; TimeTrackerを開く

sendKey(text) {
    GuiClose()
    Send(text)
}

sendText(text) {
    GuiClose()
    send_text(text)
}

GuiClose(*) { ; ☓を押したときに実行
    ; MyGui.Submit()
    ; MyGuiが存在するか確認し、存在する場合は破棄
    if (IsObject(MyGui)) {
        MyGui.Destroy()  ; 既存のGUIを破棄
    }
}
