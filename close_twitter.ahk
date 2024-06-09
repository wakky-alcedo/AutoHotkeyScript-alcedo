;#Requires AutoHotkey v2.0
; �ǂ����CAHK�� Shift JIS�œ����Ă���悤��

colose_tab()
{
    ToolTip , Close Tab!!!
    Sleep 1000
    ToolTip
    send, ^w
}

; ��������
#Persistent
SetTimer,OnTimer,-10000 ; 10sec
twitter_count := 0
Return

; �^�C�}�[��
OnTimer:

WinGetTitle, title, A ; �^�C�g�����擾�iA���Ȃ�̈Ӗ��Ȃ̂��͂킩��Ȃ��j
is_twitter := InStr(title,"X - ", CaseSensitive=ture) != 0
is_tweeting := InStr(title,"�쐬", CaseSensitive=ture) != 0

;ToolTip , %title% %is_twitter% %is_tweeting%
;Sleep 3000
;ToolTip

if (is_twitter = 1 and is_tweeting = 0)
{
    ToolTip , I just noticed you looking at Twitter!!! %twitter_count%
    Sleep 1000
    ToolTip

    if (was_twitter = 1 or twitter_count > 0) {
        colose_tab()
        if (was_twitter = 1) {
            twitter_count := 360
        }
        SetTimer,OnTimer,-10000 ; 10sec
    } else {
        SetTimer,OnTimer,-300000 ; 5min
    }
    was_twitter := 1
}
else
{
    was_twitter := 0
    twitter_count := twitter_count - 1
    SetTimer,OnTimer,-10000 ; 10sec
}

Return
