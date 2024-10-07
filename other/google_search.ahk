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
;     Clipboard = %buff%              ;クリップボードの内容を復帰
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
If (WinExist("ahk_class AutoHotkeyGUI")) {
  Return
}
stash := ClipboardAll
Clipboard :=
Send, ^c
ClipWait, 0.05
clip := Clipboard
Clipboard := stash
clip := rm_crlf(clip)
Gui, Add, Edit, v_str_google w380, %clip%
Gui, Add, Button, Default, Search
Gui, Show, Center w400, Google
Send, {vkF2}
clip := ""
Return
ButtonSearch:
  Gui, Submit
  Run, https://www.google.co.jp/search?q=%_str_google%
2GuiEscape:
2GuiClose:
  Gui, Destroy
Return