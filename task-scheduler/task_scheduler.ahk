#Requires AutoHotkey v2.0

#SingleInstance Force            ; 多重起動不可

; #Include task_scheduler_common.ahk
#Include grey.ahk
#Include muscle.ahk
#Include announce.ahk

; タスクスケジューラで起動する際は，「最上位の特権で実行する」を有効にすること

OnGreyTimer()
OnMuscleTimer()
return

; 参考サイト
; [DateAdd - 構文と使用法｜AutoHotkey v2 ](https://ahkscript.github.io/ja/docs/v2/lib/DateAdd.htm)
; [DateDiff - 構文と使用法｜AutoHotkey v2 ](https://ahkscript.github.io/ja/docs/v2/lib/DateDiff.htm)
; [Format - 構文と使用法｜AutoHotkey v2 ](https://ahkscript.github.io/ja/docs/v2/lib/Format.htm)
; [FormatTime - 構文と使用法｜AutoHotkey v2 ](https://ahkscript.github.io/ja/docs/v2/lib/FormatTime.htm)
