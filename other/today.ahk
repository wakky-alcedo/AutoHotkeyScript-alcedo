; ショーとカットで今日の日付を代入するようにした

; #Include, %A_ScriptDir%\PluginList.ahk  ; プラグインをインクルード

; ctrl+;
; ^`;:: {
; ^vkBA::{ ; :のこと
^vkBB::{ ; ;のこと（どうやらPowerToysよりこっちが優先されてしまうらしいのでこうした）
    TimeString := FormatTime(, "yyyy/MM/dd")
    send_text(TimeString)
    Return
}

; ctrl+:
; ^vkBA::{
; ^`:::{
^]::{ ; （どうやらPowerToysよりこっちが優先されてしまうらしいのでこうした）
    TimeString := FormatTime(, "HH:mm")
    send_text(TimeString)
    Return
}
