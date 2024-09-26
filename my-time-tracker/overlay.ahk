; 全画面オーバーレイウィンドウを作成するスクリプト

; 新しいGUIウィンドウを作成し、名前をつける（ここでは "Overlay" とします）
; 各ディスプレイの情報を取得
SysGet, MonitorCount, MonitorCount
Loop %MonitorCount%
{
    SysGet, Monitor, Monitor, %A_Index% ; ループの実行回数。1回目は 1
    MonitorWidth := MonitorRight - MonitorLeft
    MonitorHeighth := MonitorBottom - MonitorTop
    ; 新しいGUIウィンドウを作成し、名前をつける（ここでは "Overlay" とします）
    Gui, Overlay%A_Index%: +AlwaysOnTop +ToolWindow
    ;Gui, Overlay%A_Index%: Add, Text, w%A_ScreenWidth% h%A_ScreenHeight% BackgroundTrans
    Gui, Overlay%A_Index%: Color, 808080 ; グレー
    Gui, Overlay%A_Index%: Show, x%MonitorLeft% y%MonitorTop% w%MonitorWidth% h%MonitorHeighth% ; ウィンドウを画面全体に表示

    ; ウィンドウを少し透明にする
    ;WinSet, TransColor, 808080 150, Overlay ; グレー色を透明に設定し、透明度を設定
    WinSet, Transparent, 200, ahk_class AutoHotkeyGUI

    ; キャプションを削除
    Gui, Overlay%A_Index%: -Caption
}




; ESCキーでウィンドウを閉じる
Esc::
    Loop %MonitorCount%
    {
        Gui, Overlay%A_Index%: Destroy
    }
    ExitApp
