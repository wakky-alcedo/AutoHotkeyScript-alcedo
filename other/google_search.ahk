; インプットボックスからGoogle検索
; https://note.com/taki321/n/n44810e88e250
; !g::
;     buff = %ClipboardAll%
;     Clipboard =
;     Send,^{c}
;     ClipWait, 3

;     InputBox, strGgl, WEB Search, ,,375, 110,,,,,%Clipboard%
;     If ErrorLevel = 0
;     {
;         strURL := getURL(strGgl)     ;検索用URL作成
;         Run, %strURL%                ;検索実行
;     }
;     Else{}
;     A_Clipboard = %buff%              ;クリップボードの内容を復帰
; Return

;選択肢した文字をクエリ文字列として結合
; getURL(str) {
;     if(str != "")
;         {
;             Return "http://www.google.com/search?q=" . str
;         }
;     Return "" 
; }

!g::
; が同じ場合に必要
; Gosub, toggle_deactivation

; 多重起動防止
{ ; V1toV2: Added bracket
    global ; V1toV2: Made function global
    If (WinExist("ahk_class AutoHotkeyGUI")) {
        Return
    }
    stash := ClipboardAll()
    A_Clipboard := ""
    Send("^c")
    Errorlevel := !ClipWait(0.05)
    clip := A_Clipboard
    A_Clipboard := stash
    clip := rm_crlf(clip)
    myGui := Gui()
    ogcEdit_str_google := myGui.Add("Edit", "v_str_google w380", clip)
    ogcButtonSearch := myGui.Add("Button", "Default", "Search")
    ogcButtonSearch.OnEvent("Click", ButtonSearch.Bind("Normal"))
    myGui.Title := "Google"
    myGui.Show("Center w400")
    Send("{vkF2}")
    clip := ""
    Return
} ; V1toV2: Added bracket before function

ButtonSearch(A_GuiEvent := "", GuiCtrlObj := "", Info := "", *)
{ ; V1toV2: Added bracket
    global ; V1toV2: Made function global
    oSaved := myGui.Submit()
    _str_google := oSaved._str_google
    Run("https://www.google.co.jp/search?q=" _str_google)
    _2GuiEscape:
    _2GuiClose:
    myGui.Destroy()
    Return
} ; V1toV2: Added bracket in the end