;#Requires AutoHotkey v2.0
; どうやら，AHKは Shift JISで動いているようだ

colose_tab()
{
    ToolTip , Close Tab!!!
    Sleep 1000
    ToolTip
    send, ^w
}

; 初期処理
#Persistent
SetTimer,OnTimer,-10000 ; 10sec
twitter_count := 0
Return

; タイマー内
OnTimer:

WinGetTitle, title, A ; タイトルを取得（Aがなんの意味なのかはわからない）
is_browser := InStr(title,"Vivaldi", CaseSensitive=ture) != 0
PixelGetColor, color, 30, 10
is_private := 0
if(color == 0x764040){
    is_private = 1
}

;ToolTip , %title% %is_browser% %color% is_private = %is_private%
;Sleep 3000
;ToolTip

if (is_browser = 1 and is_private = 0)
{
    if (was_twitter = 1 or twitter_count > 0) {
        colose_tab()
        if (was_twitter = 1) {
            twitter_count := 360
        }
        SetTimer,OnTimer,-10000 ; 10sec
    } else {
        SetTimer,OnTimer,-1800000 ; 30min
    }
    was_twitter := 1

    ToolTip , I just noticed you looking at Twitter!!! %twitter_count%
    Sleep 5000
    ToolTip
}
else
{
    was_twitter := 0
    twitter_count := twitter_count - 1
    SetTimer,OnTimer,-10000 ; 10sec
}

Return
