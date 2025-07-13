#Requires AutoHotkey v2.0

Overlay() {
    global
    MonitorCount := SysGet(80) ; SM_CMONITORS
    Loop MonitorCount
    {
        MonitorLeft := 0
        MonitorTop := 0
        MonitorRight := 0
        MonitorBottom := 0
        MonitorGet(A_Index, &MonitorLeft, &MonitorTop, &MonitorRight, &MonitorBottom)
        MonitorWidth := MonitorRight - MonitorLeft
        MonitorHeight := MonitorBottom - MonitorTop
        
        ; 新しいGUIウィンドウを作成
        overlayGui := Gui("+AlwaysOnTop +ToolWindow -Caption", "Overlay" . A_Index)
        overlayGui.BackColor := "0300cc"
        overlayGui.Show("x" . MonitorLeft . " y" . MonitorTop . " w" . MonitorWidth . " h" . MonitorHeight)
        
        ; ウィンドウを少し透明にする
        ; WinSetTransparent(200, overlayGui.Hwnd)
    }
}

; 終了処理の関数
ClearOverlay() {
    global
    MonitorCount := SysGet(80) ; SM_CMONITORS
    Loop MonitorCount
    {
        try {
            WinClose("Overlay" . A_Index)
        }
    }
}

Overlay() ; 呼び出し
Sleep(1000) ; ウィンドウが表示されるまで待つ
ClearOverlay() ; 終了時に呼び出す