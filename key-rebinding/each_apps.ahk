; #Include A_ScriptDir '\..\Plugins\IME.ahk'
; #Include A_ScriptDir '\..\PluginList.ahk'  ; プラグインをインクルード
; #Include A_ScriptDir '\..\Plugins\common_functions.ahk'

; -----------------------------------------------------------------------
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

; -----------------------------------------------------------------------
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

; -----------------------------------------------------------------------
; Excel
#HotIf WinActive("ahk_exe EXCEL.exe") ; Excelがアクティブな場合

+Enter:: {                               ; Shift + Enter -> Alt + Enter
    Send("!{Enter}")
}
+NumpadEnter:: {                         ; Shift + NumpadEnter -> Alt + Enter
    Send("!{Enter}")
}

#HotIf ; ホットキー条件の終了

; -----------------------------------------------------------------------
; LINE
#HotIf WinActive("ahk_exe LINE.exe") ; LINEがアクティブな場合

^Enter:: {                              ; Ctrl + Enter -> Alt + Enter
    Send("!{Enter}")
}
^NumpadEnter:: {                        ; Ctrl + NumpadEnter -> Alt + Enter
    Send("!{Enter}")
}

#HotIf ; ホットキー条件の終了

; -----------------------------------------------------------------------
; ブラウザ
#HotIf is_browser() ; ブラウザがアクティブな場合

; Twitter
is_twitter_dm() {
    return InStr(WinGetTitle("A"), "/ X") & !InStr(WinGetTitle("A"), "新しいポストを作成 / X") & !InStr(WinGetTitle("A"), "ホーム / X") 
}

Enter:: {                               ; Enter
    if (is_twitter_dm()) {
        Send("^m")                      ; 入力中の文字を確定させる
    } else {
        Send("{Enter}")                 ; Enter を押したことにする
    }
}
NumpadEnter:: {                         ; NumpadEnter
    if (is_twitter_dm()) {
        Send("^m")                      ; 入力中の文字を確定させる
    } else {
        Send("{Enter}")                 ; Enter を押したことにする
    }
}

Ctrl & Enter:: {                        ; Ctrl + Enter
    if (is_twitter_dm()) {
        Send("{Enter}")                 ; Enter を押したことにする
    } else {
        Send("^{Enter}")           ; Ctrl + Enter を押したことにする
    }
}
Ctrl & NumpadEnter:: {                  ; Ctrl + NumpadEnter
    if (is_twitter_dm()) {
        Send("{Enter}")                 ; Enter を押したことにする
    } else {
        Send("^{Enter}")           ; Ctrl + Enter を押したことにする
    }
}
Alt & Enter:: {                         ; Alt + Enter
    if (is_twitter_dm()) {
        Send("{Enter}")                 ; Enter を押したことにする
    } else {
        Send("!{Enter}")            ; Alt + Enter を押したことにする
    }
}
Alt & NumpadEnter:: {                   ; Alt + NumpadEnter
    if (is_twitter_dm()) {
        Send("{Enter}")                 ; Enter を押したことにする
    } else {
        Send("!{Enter}")            ; Alt + Enter を押したことにする
    }
}

; -----------------------------------------------------------------------
; Vivaldi
#HotIf WinActive("ahk_exe Vivaldi.exe") ; Vivaldiがアクティブな場合
^k::{ ; Open search bar 
    Send("^c") ; Copy
    Send("^k") ; Open search bar
    Sleep(50) ; Wait for the search bar to open
    Send("^v") ; Paste
    Send("^a") ; Select all
}

; ^j::{ ; Open Transfer panel
;     Send("^c") ; Copy
;     Send("^j") ; Open downloads
;     Sleep(100) ; Wait for the panel to open
;     Send("^v") ; Paste
;     Send("{Enter}") ; Confirm the search
; }

#Hotif ; Vivaldi
#HotIf ; ブラウザがアクティブな場合

; -----------------------------------------------------------------------
#HotIf WinActive("ahk_exe Notion.exe") ; Notionがアクティブな場合

^f::Send("^k") ; 検索
^WheelUp::Send("^+{vkBBsc027}") ; 拡大
^WheelDown::Send("^-") ; 縮小
^.::Send("^+5") ; リスト
^/::Send("^+6") ; 番号付きリスト
#HotIf ; Notion

; -----------------------------------------------------------------------
; TeraTerm
#HotIf WinActive("ahk_exe ttermpro.exe") ; TeraTermがアクティブ場合
; スペースキーを押されたときに，alt+Iとalt+nを交互に送信する
Space:: {
    static toggle := false
    if (toggle) {
        Send("!i") ; alt + i
    } else {
        Send("!n") ; alt + n
        Send("{Enter}")
    }
    toggle := !toggle
}
#HotIf ; TeraTerm

; -----------------------------------------------------------------------
; Inventor
#HotIf WinActive("ahk_exe Inventor.exe") ; Inventorがアクティブな場合
Ins::Send("!v")     ; 表示設定
Home::Send("{F7}")   ; スケッチのとき断面表示
PgUp::Send("!E")   ; スケッチのときスケッチ終了
End::Shift
#HotIf ; Inventor