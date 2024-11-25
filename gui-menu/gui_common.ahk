#Requires AutoHotkey v2.0

global MyGui := "" ; MyGuiをグローバルに宣言

sendKey(text) {
    GuiClose()
    Send(text)
}

sendText(text) {
    GuiClose()
    send_text(text)
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

GuiClose(*) { ; ☓を押したときに実行
    ; MyGui.Submit()
    ; MyGuiが存在するか確認し、存在する場合は破棄
    if (IsObject(MyGui)) {
        MyGui.Destroy()  ; 既存のGUIを破棄
    }
}