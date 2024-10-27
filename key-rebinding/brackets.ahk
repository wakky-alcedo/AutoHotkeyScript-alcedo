; Shift + 0 ;; ()
; 半角にして，括弧を入力し，カーソルを左に
+0::Send("{vkF2}{vkF3}+8+9{Left}")

; 囲いを作る
^9:: {
    UserInput := InputBox("対になる囲み文字を入力", "囲み")
    if (UserInput.Result == "OK" && StrLen(UserInput.Value) > 0) {
        surround(UserInput.Value)
    }
}

; ctrl + 8
^8::surround("()")

; ctrl + [
^[::surround("{}")

; ctrl + "
; ^2::surround("""")

; ctrl + '
^7::surround("''")

surround(bracket) {
    bk := ClipboardAll()
    Clipboard := ""
    Send("^x")
    if ClipWait(0.5) {
        if (StrLen(bracket) >= 2) {
            bText := SubStr(bracket, 1, 1) . Clipboard . SubStr(bracket, 2, 1)
        } else if (StrLen(bracket) = 1) {
            bText := bracket . Clipboard . bracket
        }
        Clipboard := bText
        Send("^v")
    }
    Clipboard := bk
}
