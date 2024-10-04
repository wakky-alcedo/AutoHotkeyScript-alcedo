Array := [
    ,"other\auto_save.ahk"
    ,"key-rebinding\discord_send_setting.ahk"
    ,"other\insert_link.ahk"
    ,"other\today.ahk"
    ,"key-rebinding\shift_shortcut.ahk"
    ; ,"close_twitter.ahk"
    ; ,"close_privatewindows.ahk"
    ,"other\minimize_explorer.ahk" ]

#SingleInstance, Force       ; 同じスクリプトが実行中の場合、再実行時にリロードする

For index, element in Array {
  Run, %element%
}