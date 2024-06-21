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
is_twitter := InStr(title,"X - ", CaseSensitive=ture) != 0 AND InStr(title,"ホーム", CaseSensitive=ture) != 0
is_tweeting := InStr(title,"新しいポストを作成", CaseSensitive=ture) != 0 OR InStr(title,"@wakky_robocon", CaseSensitive=ture) OR InStr(title," - 検索", CaseSensitive=ture)
FormatTime,now_time,,HHmm
is_deep_night := now_time < 0500

;ToolTip , %title% %is_twitter% %is_tweeting% %now_time% %is_deep_night%
;Sleep 3000
;ToolTip

if (is_twitter = 1 and (is_tweeting = 0 or is_deep_night = 1))
{
    if (was_twitter = 1 or twitter_count > 0 or is_deep_night = 1) {
        colose_tab()
        if (was_twitter = 1) {
            twitter_count := 360
        }
        SetTimer,OnTimer,-10000 ; 10sec
    } else {
        SetTimer,OnTimer,-300000 ; 5min
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
