;#Requires AutoHotkey v2.0
; どうやら，AHKは Shift JISで動いているようだ

colose_window()
{
    ToolTip , Close Tab!!!
    Sleep 1000
    ToolTip
    send, !{F4}
}

; 初期処理
#Persistent
SetTimer,OnTimer,-10000 ; 10sec
private_count := 0
is_privateing := false
Return

; タイマー内
OnTimer:

WinGetTitle, title, A ; タイトルを取得（Aがなんの意味なのかはわからない）
is_browser := InStr(title,"Vivaldi", CaseSensitive==ture) != 0
PixelGetColor, color, 30, 10
is_private := color == 0x764040 ? true : false

;ToolTip , %title% %is_browser% %color% is_private == %is_private%
;Sleep 3000
;ToolTip

if (is_browser == 1 and is_private == 1)
{
    private_count := private_count + 1
    is_privateing := true
    if (private_count == 150) {
        ToolTip , last 5 min!!! %private_count%
    }
    if (private_count > 180) {
        colose_window()
        private_count := 720
        is_privateing := false
        ToolTip , I just noticed you looking at privatewindow!!! %private_count%
        Sleep 5000
        ToolTip
        SetTimer,OnTimer,-10000 ; 10sec
    } else {
        SetTimer,OnTimer,-10000 ; 10sec
    }

    ToolTip , I just noticed you looking at privatewindow!!! %private_count%
}
else
{
    if(private_count > 0){
        if(and is_privateing == false){
            private_count := private_count - 1
        }else{
            private_count := private_count - 0.05
        }
    }
    SetTimer,OnTimer,-10000 ; 10sec
    ToolTip
}

Return
