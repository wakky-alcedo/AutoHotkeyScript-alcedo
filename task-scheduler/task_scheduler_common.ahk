#Requires AutoHotkey v2.0

; ある時刻までの時間を計算
; @param startTime: 開始時刻 (HHMM形式)
; @param currentTime: 現在時刻 (YYYYMMDDHH24MISS形式）
TimeToStart(startTime, currentTime := A_Now) {
    ; HHMM形式の数値に今日の日付を複合
    startTime := A_YYYY . A_MM . A_DD . StrReplace(startTime, ":", "") . "00"
    startTimeDiff := DateDiff(startTime, currentTime, "Seconds")
    if(startTimeDiff < 0) {
        startTime := DateAdd(startTime, 1, "Days")
        startTimeDiff := DateDiff(startTime, currentTime, "Seconds")
    }
    ; MsgBox(startTime " " currentTime)  ; 現在の時刻を表示
    return startTimeDiff ; [sec]
}

; 時刻の範囲内か，また次に境界をまたぐまでの時間を計算
; @param startTime: 開始時刻 (HHMM形式)
; @param endTime: 終了時刻 (HHMM形式)
; @param currentTime: 現在時刻 (YYYYMMDDHH24MISS形式）
TimeBetween(startTime, endTime, currentTime := A_Now) { ; HHMM形式
    ; HHMM形式の数値に今日の日付を複合
    startTimeDiff := TimeToStart(startTime, currentTime)
    endTimeDiff := TimeToStart(endTime, currentTime)
    ; MsgBox(startTimeDiff/60/60 " " endTimeDiff/60/60)  ; 残り時間を表示
    if (startTimeDiff < endTimeDiff) {
        return startTimeDiff ; [sec]
    } else {
        return endTimeDiff ; [sec]
    }
}
