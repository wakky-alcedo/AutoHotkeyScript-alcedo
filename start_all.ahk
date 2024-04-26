Array := [
    ,"auto_save.ahk"
    ,"discord_send_setting.ahk"
    ,"insert_link_on_OneNote.ahk"
    ,"today.ahk"
    ,"shift_shortcut.ahk" ]

For index, element in Array {
  Run, %element%
}