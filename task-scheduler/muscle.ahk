#Requires AutoHotkey v2.0

#Include "task_scheduler_common.ahk"
#Include ..\Plugins\common_functions.ahk

; タイマー初期化
OnMuscleTimer()

; タイマー内
OnMuscleTimer(*) {
    ; 時刻の設定
    startTime := "1930"
    endTime := "2100"
    currentTime := A_Now
    startTimeDiff := TimeToStart(startTime, currentTime)
    endTimeDiff := TimeToStart(endTime, currentTime)

    ; 判定および実行，タイマーの設定
    if (startTimeDiff > endTimeDiff) { ; 範囲内
        ; Vivaldiを開く
        open_vivaldi("https://www.youtube.com/watch?v=cQsupVhKcDg&ab_channel=%E3%82%B6%E3%83%BB%E3%81%8D%E3%82%93%E3%81%AB%E3%81%8FTV%E3%80%90TheMuscleTV%E3%80%91")
        WinWait("高強度で全身を7分半で追い込む", , 5) ; 最大5秒待機

        ; サイズと位置を設定 (例: 横800px, 縦600px、画面左上に配置)
        width := A_ScreenWidth / 2
        height := width * 12/16 ; A_ScreenHeight
        WinMove((A_ScreenWidth/2)-(width/2), (A_ScreenHeight/2)-(height/2), width, height)
        Send("^{F11}") ; フルスクリーン表示
    }
    SetTimer(OnMuscleTimer, -startTimeDiff * 1000) ; startまでの時間を設定
    return
}
