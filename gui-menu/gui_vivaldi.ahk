#Requires AutoHotkey v2.0

#Include "gui_common.ahk"

gui_vivaldi() {
    MyGui.Add("Text", , "Vivaldi")
    MyGui.Add("Button", "", "強制的にダークページを利用").OnEvent("Click", ForceDarkPage)
}
