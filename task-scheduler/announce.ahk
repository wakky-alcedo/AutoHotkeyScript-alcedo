#Requires AutoHotkey v2.0

#Include task_scheduler_common.ahk
#Include ..\PluginList.ahk

; タスクスケジューラで起動する際は，「最上位の特権で実行する」を有効にすること

; タイマー初期化
OnAnnounceTimer()

; タイマー内
OnAnnounceTimer(*) {
    ; 時刻の設定
    ; currentTime := A_Now
    nextTimerDiff := 24 * 60 * 60 ; 24時間後のタイマーを設定

    ; 判定および実行，タイマーの設定

    ; 17:00にアナウンス
    startTimeDiff := TimeToStart("17:00", A_Now)
    if (startTimeDiff) == 0 { ; 範囲内
        playWav("music/zunda_17.wav")
        ; SetTimer(OnAnnounceTimer, -startTimeDiff * 1000) ; startまでの時間を設定
        ; return
        startTimeDiff := TimeToStart("20:00", A_Now)
    }
    if (nextTimerDiff > startTimeDiff) {
        nextTimerDiff := startTimeDiff
    }
    
    ; 20:00にアナウンス
    startTimeDiff := TimeToStart("20:00", A_Now)
    if (startTimeDiff) == 0 { ; 範囲内
        playWav("music/zunda_teji.wav")
        startTimeDiff := TimeToStart("23:45", A_Now)
    }
    if (nextTimerDiff > startTimeDiff) {
        nextTimerDiff := startTimeDiff
    }

    ; 23:45にアナウンス
    startTimeDiff := TimeToStart("23:45", A_Now)
    if (startTimeDiff) == 0 { ; 範囲内
        playWav("music/zunda_23.wav")
        startTimeDiff := TimeToStart("17:00", A_Now)
    }
    if (nextTimerDiff > startTimeDiff) {
        nextTimerDiff := startTimeDiff
    }

    tooltip_with_timeout("次のアナウンスまで" nextTimerDiff "秒")
    SetTimer(OnAnnounceTimer, -nextTimerDiff * 1000) ; startまでの時間を設定
    return
}

; WAVファイルを再生する関数
playWav(wavFile) {
    originalVolume := SoundGetVolume()  ; 現在の音量を保存
    SoundSetVolume(5)                 ; 音量を50に設定

    SoundPlay(wavFile, 1)  ; waitの引数を1に設定して、再生が完了するまで待機

    SoundSetVolume(originalVolume)     ; 元の音量に戻す
}