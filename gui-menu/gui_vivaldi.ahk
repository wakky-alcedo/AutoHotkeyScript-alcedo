#Requires AutoHotkey v2.0

#Include "gui_common.ahk"

; vivaldi

gui_vivaldi() {
    MyGui.Add("Text", , "Vivaldi")
    MyGui.Add("Button", "", "強制的にダークページを利用").OnEvent("Click", ForceDarkPage)
    MyGui.Add("Button", "", "タブを非表示").OnEvent("Click", HideTab)
}

ForceDarkPage(*) => sendKey("^!d") ; "すべてのウェブサイトにダークテーマを強制適用"のショートカットキー
HideTab(*) => sendKey("^{F11}") ; タブを非表示