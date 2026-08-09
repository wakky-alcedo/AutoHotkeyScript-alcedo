
#Include "gui_common.ahk"
#Include "gui_default.ahk"
#Include "gui_vscode.ahk"
#Include "gui_vivaldi.ahk"

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
    ; ctrl shift alt を上げる
    Send("{Ctrl Up}{Shift Up}{Alt Up}{LWin Up}")

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
        gui_vscode(activeWindowTitle)
    }

    ; アクティブウィンドウがVivaldiの場合
    if InStr(activeWindowProcess, "vivaldi") {
        gui_vivaldi()
    }

    ; MyGui := Gui.new()
    gui_default()  ; デフォルトのGUIを表示

    ; GUIをマウスカーソルのある位置に表示
    CoordMode "Mouse" , "Screen"
    MouseGetPos &xpos, &ypos
    ; MyGui.Show("xCenter x" . xpos . " yCenter y" . ypos)
    MyGui.Show("x" . xpos-50 . " y" . ypos-200)
}
