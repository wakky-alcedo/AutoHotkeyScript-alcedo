;#Requires AutoHotkey v2.0
; �ǂ����CAHK�� Shift JIS�œ����Ă���悤��

colose_tab()
{
    send, ^w
    ToolTip , Close Tab!!!
    Sleep 1000
    ToolTip
}

; ��������
#Persistent
SetTimer,OnTimer,-10000 ; 10sec
twitter_count := 0
Return

; �^�C�}�[��
OnTimer:

; �E�B���h�E���X�g���擾
WinGet, id, list

Loop % id {
    this_id := id%A_Index%
    ; �E�B���h�E�^�C�g�����擾���C�ςȂ������
    WinGetTitle, title, ahk_id %this_id%

    is_twitter := InStr(title,"X - ", CaseSensitive=ture) != 0 AND InStr(title,"�z�[��", CaseSensitive=ture) != 0
    is_tweeting := InStr(title,"�V�����|�X�g���쐬", CaseSensitive=ture) != 0 OR InStr(title,"@wakky_robocon", CaseSensitive=ture) OR InStr(title," - ����", CaseSensitive=ture)
    is_temptation := InStr(title,"Prime Video", CaseSensitive=ture) OR InStr(title,"DMM TV", CaseSensitive=ture) OR title = "YouTube"
    is_youtube := InStr(title,"YouTube", CaseSensitive=ture) AND (InStr(title,"YouTube Music", CaseSensitive=ture) == 0)

    FormatTime,now_time,,HHmm
    is_deep_night := 2300 < now_time or now_time < 0700
    is_deep_deep_night := 0000 < now_time and now_time < 0700

    ;ToolTip , %title% %is_twitter% %is_tweeting% %now_time% %is_deep_night%
    ;Sleep 3000
    ;ToolTip

    if (is_deep_night and (is_temptation or is_twitter))
    {
        WinActivate, ahk_id %this_id%
        colose_tab()
    }

    if (is_deep_deep_night and is_youtube)
    {
        WinActivate, ahk_id %this_id%
        colose_tab()
    }

    if (is_twitter = 1 and is_tweeting = 0)
    {
        if (was_twitter = 1 or twitter_count > 0) {
            WinActivate, ahk_id %this_id%
            colose_tab()
            if (was_twitter = 1) {
                twitter_count := 360
            }
            SetTimer,OnTimer,-5000 ; 5sec
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
        if(twitter_count > 0){
            twitter_count := twitter_count - 0.5
        }
        SetTimer,OnTimer,-5000 ; 5sec
    }

}

Return
