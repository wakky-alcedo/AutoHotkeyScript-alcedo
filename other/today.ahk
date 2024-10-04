; ショーとカットで今日の日付を代入するようにした

#Include, %A_ScriptDir%\..\Plugins\IME.ahk
; #Include, %A_ScriptDir%\..\PluginList.ahk  ; プラグインをインクルード

; ctrl+;
^vkBB::
    IME_SET(0) ; 半角に
    FormatTime,TimeString,,yyyy/MM/dd
    Send,%TimeString%
    Sleep, 1
    IME_SET(1) ; 全角に
    Return

; ctrl+:
^vkBA::
    IME_SET(0) ; 半角に
    FormatTime,TimeString,,hh:mm
    Send,%TimeString%
    Sleep, 1
    IME_SET(1) ; 全角に
    Return
