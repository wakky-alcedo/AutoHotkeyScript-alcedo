#Requires AutoHotkey v2.0
; #MaxHotkeysPerInterval 200      ; ホットキー実行の最大回数を設定

; ----- 設定項目 -----
MULTIPLIER := 2
THRESHOLD := 60 ; 「速い」と判断する時間（ミリ秒）。この時間内に次のスクロールがあれば加速します。
THRESHOLD_2 := 20 ; 「非常に速い」と判断する時間（ミリ秒）。この時間内に次のスクロールがあればさらに加速します。

; 通常スクロール時のスクロール行数
NORMAL_SCROLL_AMOUNT := 1

; 高速スクロール時のスクリロール行数
FAST_SCROLL_AMOUNT := 2

; 超高速スクロール時のスクロール行数
SUPER_FAST_SCROLL_AMOUNT := 4
; --------------------

WheelUp::Scroll(A_EventInfo, "Up")
WheelDown::Scroll(A_EventInfo, "Down")

Scroll(eventInfo, direction)
{
    local scrollAmount
    local timeSince := IsNumber(A_TimeSincePriorHotkey) ? A_TimeSincePriorHotkey : 9999

    ; eventInfoを表示
    ; ToolTip("eventInfo: " . eventInfo, 10, 10)
    ; timeSinceを表示
    ; ToolTip("timeSince: " . timeSince, 10, 30)

    if (timeSince <= THRESHOLD_2) {
        ; 超高速スクロール
        scrollAmount := SUPER_FAST_SCROLL_AMOUNT
    } else if (timeSince <= THRESHOLD) {
        ; 高速スクロール
        scrollAmount := FAST_SCROLL_AMOUNT
    } else {
        ; 通常時のスクロール量
        scrollAmount := NORMAL_SCROLL_AMOUNT
    }
    
    Send "{Wheel" direction " " scrollAmount "}"
}

