; #Include A_ScriptDir '\..\Plugins\IME.ahk'
; #Include A_ScriptDir '\..\PluginList.ahk'  ; プラグインをインクルード
; #Include A_ScriptDir '\..\Plugins\common_functions.ahk'

; Discord
#HotIf WinActive("ahk_exe Discord.exe") ; Discordを開いている時だけ

; Discord で送信と改行のキーの設定を変える
Shift & Enter:: {                       ; Shift & Enter
    Send("+{Enter}")                    ; Shift + Enter を押したことにする
}
Shift & NumpadEnter:: {                 ; Shift & NumpadEnter
    Send("+{Enter}")                    ; Shift + Enter を押したことにする
}

Enter:: {                               ; Enter
    Send("^m")                          ; 入力中の文字を確定させる
}
NumpadEnter:: {                         ; NumpadEnter
    Send("^m")                          ; 入力中の文字を確定させる
}

Ctrl & Enter:: {                        ; Ctrl + Enter
    Send("{Enter}")                     ; Enter を押したことにする
}
Ctrl & NumpadEnter:: {                  ; Ctrl + NumpadEnter
    Send("{Enter}")                     ; Enter を押したことにする
}
Alt & Enter:: {                         ; Alt + Enter
    Send("{Enter}")                     ; Enter を押したことにする
}
Alt & NumpadEnter:: {                   ; Alt + NumpadEnter
    Send("{Enter}")                     ; Enter を押したことにする
}

#HotIf ; ホットキー条件の終了

; エクスプローラ
#HotIf WinActive("ahk_class CabinetWClass") ; エクスプローラがアクティブな場合

global MyGui := "" ; MyGuiをグローバルに宣言

!n:: {                                     ; Alt + n で新しいブランクファイルを作成
    MyGui := Gui("New File")
    MyGui.Add("Edit", "v_str_filename w380")
    ; MyGui.Add("Button", "Default", "Append")
    MyGui.Add("Button", "", "Append").OnEvent("Click", Append)
    MyGui.Show("Center w400", "ファイル名")
    Send("{vkF2}{vkF3}")
}
Append(*){
    current_dir := get_current_dir()       ; 現在表示中のディレクトリを取得
    MyGui.Submit()
    FileAppend "", current_dir "\" Gui.str_filename ; ファイルを生成
    MyGui.Destroy()
}

#HotIf ; ホットキー条件の終了

; Excel
#HotIf WinActive("ahk_exe EXCEL.exe") ; Excelがアクティブな場合

+Enter:: {                               ; Shift + Enter -> Alt + Enter
    Send("!{Enter}")
}
+NumpadEnter:: {                         ; Shift + NumpadEnter -> Alt + Enter
    Send("!{Enter}")
}

#HotIf ; ホットキー条件の終了

; LINE
#HotIf WinActive("ahk_exe LINE.exe") ; LINEがアクティブな場合

^Enter:: {                              ; Ctrl + Enter -> Alt + Enter
    Send("!{Enter}")
}
^NumpadEnter:: {                        ; Ctrl + NumpadEnter -> Alt + Enter
    Send("!{Enter}")
}

#HotIf ; ホットキー条件の終了

; Twitter
#HotIf WinExist("A")
#HotIf InStr(WinGetTitle("A"), "/ X") & !InStr(WinGetTitle("A"), "新しいポストを作成 / X") 

Shift & Enter:: {                       ; Shift & Enter
    Send("+{Enter}")                    ; Shift + Enter を押したことにする
}

Enter:: {                               ; Enter
    Send("^m")                          ; 入力中の文字を確定させる
}
NumpadEnter:: {                         ; NumpadEnter
    Send("^m")                          ; 入力中の文字を確定させる
}

Ctrl & Enter:: {                        ; Ctrl + Enter
    Send("{Enter}")                     ; Enter を押したことにする
}
Ctrl & NumpadEnter:: {                  ; Ctrl + NumpadEnter
    Send("{Enter}")                     ; Enter を押したことにする
}
Alt & Enter:: {                         ; Alt + Enter
    Send("{Enter}")                     ; Enter を押したことにする
}
Alt & NumpadEnter:: {                   ; Alt + NumpadEnter
    Send("{Enter}")                     ; Enter を押したことにする
}

#HotIf
#HotIf 
