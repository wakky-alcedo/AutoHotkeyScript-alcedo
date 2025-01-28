#Requires AutoHotkey v2.0

; インサートキーのリバインディング
Ins::Send("#h")

; ins+←　で　スクロール
Ins & Left::Send("{WheelUp}")

; ins+→　で　スクロール
Ins & Right::Send("{WheelDown}")




Home::Send("{Tab}")