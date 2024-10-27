#Requires AutoHotkey v2.0

; サブキーボード

; 1
^!+F7::{
    ; 一定時間内に，3回押すと、スリープ
    ; 押された時間を取得
    static time := 0
    static count := 0
    if(time + 1000 < A_TickCount) {
        time := A_TickCount
        count := 0
        Send("^+!.") ; vivaldiブレイクモード（setの想定）
    }
    count++
    if (count > 3) {
        count := 0
        Send("^+!.") ; vivaldiブレイクモード（resetの想定）
        DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
    }
}

; 2
^!+F8::{
    Run(".\my-time-tracker\my-time-tracker.exe")  ; TimeTrackerを開く
}

; 3
^!+F9::{
    ; シークレットマイクミュート
    ; powertoysの機能
    Send("^+a")
}

; ノブ左回転
^!+F10::{
    ; ボリュームダウン
    static time := 0
    time_diff := (A_TickCount - time + 1) / 1000
    volume_diff := 0.4 / time_diff + 1
    volume_diff := 5 * 50**(-time_diff*0.5) + 1
    ; SoundSetVolume -volume_diff
    Send "{Volume_Down " volume_diff "}"
    time := A_TickCount
}

; ノブ押し込み
^!+F11::{
    ; スピーカー切り替え
    ; DefaultAudioChanger_1.0.3
    Send("^+z")
}

; ノブ右回転
^!+F12::{
    ; ボリュームアップ
    static time := 0
    time_diff := (A_TickCount - time + 1) / 1000
    volume_diff := 0.4 / time_diff + 1
    ; SoundSetVolume -volume_diff
    Send "{Volume_Up " volume_diff "}"
    time := A_TickCount
}
