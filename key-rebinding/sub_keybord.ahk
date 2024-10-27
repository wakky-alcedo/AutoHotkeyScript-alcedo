#Requires AutoHotkey v2.0

; サブキーボード
; 各キーに ctrl + alt + shift + F7 ～ F12 を割り当てる

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
global keyCount2 := 0
^!+F8::{
    global keyCount2
    keyCount2 += 1
    countTimeout := 300
    SetTimer CheckkeyCount2, -countTimeout
}

CheckkeyCount2(*) {
    global keyCount2

    if keyCount2 = 1 {
        ; 1回押しのアクションをここに記述
        ; MsgBox("1回押しのアクション")
        Run(".\my-time-tracker\my-time-tracker.exe")  ; TimeTrackerを開く
    } else if keyCount2 = 2 {
        ; 2回押しのアクションをここに記述
        ; MsgBox("2回押しのアクション")
        Run("calc.exe") ; 電卓を開く
    } else if keyCount2 >= 3 {
        ; 3回押しのアクションをここに記述
        ; MsgBox("3回押しのアクション")

    }

    ; カウントをリセット
    keyCount2 := 0
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
