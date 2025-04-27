#Requires AutoHotkey v2.0

#SingleInstance Force            ; 多重起動不可

#Warn All, Off ; 警告無しで再起動

; #Include task_scheduler_common.ahk
#Include grey.ahk
#Include muscle.ahk
#Include announce.ahk

; タスクスケジューラで起動する際は，「最上位の特権で実行する」を有効にすること
; SetTimer は，スリープしている間は動かないので，スリープから復帰した際にタイマーを再設定する必要がある

; OnGreyTimer()
; OnMuscleTimer()
; OnAnnounceTimer()
return

; 参考サイト
; [DateAdd - 構文と使用法｜AutoHotkey v2 ](https://ahkscript.github.io/ja/docs/v2/lib/DateAdd.htm)
; [DateDiff - 構文と使用法｜AutoHotkey v2 ](https://ahkscript.github.io/ja/docs/v2/lib/DateDiff.htm)
; [Format - 構文と使用法｜AutoHotkey v2 ](https://ahkscript.github.io/ja/docs/v2/lib/Format.htm)
; [FormatTime - 構文と使用法｜AutoHotkey v2 ](https://ahkscript.github.io/ja/docs/v2/lib/FormatTime.htm)
