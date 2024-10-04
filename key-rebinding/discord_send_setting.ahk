; discord で 送信と改行のキーの設定を変える

; #Include, %A_ScriptDir%\..\Plugins\IME.ahk
#Include, %A_ScriptDir%\..\PluginList.ahk  ; プラグインをインクルード

#IfWinActive,ahk_exe Discord.exe        ; Discordを開いている時だけ

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