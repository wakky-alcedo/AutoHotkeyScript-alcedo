; Shift + 0 ;; ()
  +0::Send, {vkF2}{vkF3}+8+9{Left}

; 囲いを作る
; https://forestail.com/software/autohotkey/#toc12
; ctrl + 8
^9::
    InputBox, UserInput, 囲み, 対になる囲み文字を入力, , 240, 130
    If (ErrorLevel = 0)
    {
        If (StrLen(UserInput) > 0)
        {
            surround(UserInput)
        }
    }
return

; ctrl + 8
^8::
    surround("()")
return

; ctrl + [
^[::
    surround("{}")
return

; ctrl + "
^2::
    surround("""")
return

; ctrl + '
^7::
    surround("''")
return

surround(bracket){
    bk=%ClipboardAll%
    Clipboard=
    Send,^x
    ClipWait, 0.5
    If (Clipboard)
    {
        If (StrLen(bracket) >= 2)
        {
            bText := SubStr(bracket, 1 , 1) . Clipboard . SubStr(bracket, 2 , 1)
        }
        Else If (StrLen(bracket) = 1)
        {
            bText := bracket . Clipboard . bracket
        }
        Clipboard=%bText%
        Send, ^v
    }
    Clipboard=%bk%
}