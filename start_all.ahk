Array := [
    ,"auto_save.ahk"
    ,"discord_send_setting.ahk"
    ,"insert_link.ahk"
    ,"today.ahk"
    ,"shift_shortcut.ahk"
    ; ,"close_twitter.ahk"
    ; ,"close_privatewindows.ahk"
    ,"minimize_explorer.ahk" ]

For index, element in Array {
  Run, %element%
}