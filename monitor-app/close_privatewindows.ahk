;#Requires AutoHotkey v2.0
; どうやら，AHKは Shift JISで動いているようだ

colose_window()
{
    send, !{F4}
    ToolTip , Close Window!!!
    Sleep 1000
    ToolTip
}

is_private(title)
{
    WinGetTitle, title, A ; タイトルを取得（Aがなんの意味なのかはわからない）
    ; Vivaldi
    if (InStr(title,"Vivaldi", CaseSensitive==ture) != 0){
        PixelGetColor, color, 30, 10
        if(color == 0x764040) {
            Return true
        }
    }
    ; Chrom
    if (InStr(title,"Chrom", CaseSensitive==ture) != 0){
        PixelGetColor, color, 50, 40
        if(color == 0x3C3C3C) {
            Return true
        }
    }
    Return false
}

; 初期処理
#Persistent
SetTimer,OnTimer,-5000 ; 5sec
private_count := 0
is_privateing := false
Return

; タイマー内
OnTimer:

FormatTime,now_time,,HHmm
is_deep_night := 2300 < now_time or now_time < 0500

;ToolTip , %title% %is_browser% %color% is_private == %is_private%
;Sleep 3000
;ToolTip

; ウィンドウリストを取得
WinGet, id, list

Loop % id {
    this_id := id%A_Index%
    
    ; ウィンドウタイトルを取得し，変なやつを除去
    WinGetTitle, title, ahk_id %this_id%
    if (title = "" or title = "PopupHost" or title = "Program Manager" or InStr(title,"OCRMODE", CaseSensitive=ture) or InStr(title,"MainWnd", CaseSensitive=ture) or InStr(title,"PfuSsMon", CaseSensitive=ture)) {
        continue
    }

    ; ここで操作を実行
    if (is_private(title))
    {
        private_count := private_count + 0.5
        is_privateing := true
        if (private_count == 150) {
            ToolTip , last 5 min!!! %private_count%
        }
        if (private_count > 180 or is_deep_night) {
            WinActivate, ahk_id %this_id%
            colose_window()
            private_count := 720
            is_privateing := false
            Sleep 5000
            ToolTip
            SetTimer,OnTimer,-5000 ; 5sec
        } else {
            SetTimer,OnTimer,-5000 ; 5sec
        }
    
        ToolTip , I just noticed you looking at privatewindow!!! %private_count%
        break
    }
    else
    {
        if(private_count > 0){
            if(and is_privateing == false){
                private_count := private_count - 0.5
            }else{
                private_count := private_count - 0.025
            }
        }
        SetTimer,OnTimer,-5000 ; 5sec
        ToolTip
    }
}

Return
