; ショーとカットで今日の日付を代入するようにした

; #Include, %A_ScriptDir%\PluginList.ahk  ; プラグインをインクルード

; ctrl+;
; ^`;:: {
; ^vkBB::{ ; ;のこと
^vkBA::{ ; :のこと（どうやらPowerToysよりこっちが優先されてしまうらしいのでこうした）
    IME_SET(0) ; 半角に
    Sleep 10
    TimeString := FormatTime(, "yyyy/MM/dd")
    Send(TimeString)
    Sleep(1)
    IME_SET(1) ; 全角に
    Return
}

; ctrl+:
; ^vkBA::{
; ^`:::{
^]::{
    IME_SET(0) ; 半角に
    TimeString := FormatTime(, "hh:mm")
    Send(TimeString)
    Sleep(1)
    IME_SET(1) ; 全角に
    Return
}
