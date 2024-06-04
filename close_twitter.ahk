;#Requires AutoHotkey v2.0

colose_tab()
{
    ToolTip , Close Tab!!!
    Sleep 1000
    ToolTip
    send, ^w
    SetTimer,OnTimer,-30000 ; 30sec
}

; 初期処理
#Persistent
SetTimer,OnTimer,-10000 ; 10sec
twitter_count := 0
Return

; タイマー内
OnTimer:

WinGetTitle, title, A ; タイトルを取得（Aがなんの意味なのかはわからない）
is_twitter := RegExMatch(title,"X - Opera") or RegExMatch(title,"X - Google Chrome") 
is_tweeting := RegExMatch(title,"新しいポストを作成")

if is_twitter = 1 and is_tweeting = 0
{
    if(was_twitter = 1) {
        colose_tab()
        twitter_count := 360
    }
    if(twitter_count > 0) {
        colose_tab()
    }
    was_twitter := 1
    SetTimer,OnTimer,-300000 ; 5min
}
else
{
    was_twitter := 0
    twitter_count := twitter_count - 1
    SetTimer,OnTimer,-10000 ; 10sec
}

Return
