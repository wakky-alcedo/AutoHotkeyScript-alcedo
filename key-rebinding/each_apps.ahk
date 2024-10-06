; #Include, %A_ScriptDir%\..\Plugins\IME.ahk
#Include, %A_ScriptDir%\..\PluginList.ahk  ; プラグインをインクルード
#Include, %A_ScriptDir%\..\Plugins\common_functions.ahk


; discord
#IfWinActive,ahk_exe Discord.exe        ; Discordを開いている時だけ

; discord で 送信と改行のキーの設定を変える
Shift & Enter::                         ; Shift & Enter
Shift & NumpadEnter::                   ; Shift & NumpadEnter を押したら
    Send, +{Enter}                      ; Ctrl + Enter を押したことにする
    return

Enter::                                 ; Enter
NumpadEnter::                           ; NumpadEnter を押したら
    Send, ^m                            ; 入力中の文字を確定させる
    return

Ctrl & Enter::                          ; Ctrl + Enter を押したら
Ctrl & NumpadEnter::                    ; Ctrl + NumpadEnter を押したら
Alt & Enter::                           ; Alt + Enter を押したら
Alt & NumpadEnter::                     ; Alt + NumpadEnter を押したら
    Send, {Enter}                       ; Enter を押したことにする
    return

#IfWinActive


; エクスプローラ
; 新しいブランクファイルを作成
#IfWinActive,ahk_class CabinetWClass
!n::
    ; 現在表示中のディレクトリ
    current_dir := get_current_dir()
    ; ファイルを生成(重複しない名前)
    Gui, Add, Edit, v_str_filename w380
    Gui, Add, Button, Default, Append
    Gui, Show, Center w400, ファイル名
    Send, {vkF2}{vkF3}
    Return
    ButtonAppend:
    Gui, Submit
    FileAppend, , %current_dir%\%_str_filename%
    3GuiEscape:
    3GuiClose:
      Gui, Destroy
Return
#IfWinActive


; Excel
; Excelの改行リマップ
; https://zenn.dev/thinkingsinc/articles/3ee9a6bb35ea55#excel%E3%81%AE%E6%94%B9%E8%A1%8C%E3%83%AA%E3%83%9E%E3%83%83%E3%83%97
#IfWinActive,ahk_exe EXCEL.exe
; ※+はShift, !はAltを示す
+Enter:: !Enter
+NumpadEnter:: !Enter
#IfWinActive


; LINE
; LINEの送信リマップ
#IfWinActive,ahk_exe LINE.exe
^Enter:: !Enter
^NumpadEnter:: !Enter
#IfWinActive

