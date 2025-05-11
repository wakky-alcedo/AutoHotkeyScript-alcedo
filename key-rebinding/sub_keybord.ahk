#Requires AutoHotkey v2.0

; サブキーボード
; 各キーに ctrl + alt + shift + F7 ～ F12 を割り当てる

; 音を鳴らす
^!+F6::{
    ; SoundPlay("key-rebinding/yumiya.wav", 0)
    SoundPlay("key-rebinding/泡03・高音・単音.wav", 0) ; mp3よりwavのほうが起動が早い
}
F13::{
    ; SoundPlay("key-rebinding/yumiya.wav", 0)
    ; SoundPlay("key-rebinding/泡03・高音・単音.wav", 0) ; mp3よりwavのほうが起動が早い
    ; ブザーを一瞬鳴らす
    SoundBeep(600, 5) ; 1kHzの音を100ms鳴らす
}

; 1
global keyCount1 := 0
^!+F7 Up::{
    global keyCount1
    keyCount1 += 1
    countTimeout := 300
    SetTimer CheckKeyCount1, -countTimeout
}
CheckKeyCount1(*) {
    global keyCount1

    if keyCount1 = 1 {
        ; 1回押しのアクションをここに記述
        ; MsgBox("1回押しのアクション")
        Send("^+!.") ; vivaldiブレイクモード
    } else if keyCount1 = 2 {
        ; 2回押しのアクションをここに記述
        ; MsgBox("2回押しのアクション")
        ; ロック
        ; Send("{LWin}l")
        DllCall("user32\LockWorkStation") ; ロック
    } else if keyCount1 >= 3 {
        ; 3回押しのアクションをここに記述
        ; MsgBox("3回押しのアクション")
        ; DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0) ; スリープ
        ; DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0) ; ハイバネート 休止状態
        ; スリープショートカット
        Send("#x")
        Sleep(100)
        Send("u")
        Sleep(100)
        Send("s")
    }

    ; カウントをリセット
    keyCount1 := 0
}

; 2
global keyCount2 := 0
global keyTime2 := 0
^!+F8 Up::{
    global keyCount2
    keyCount2 += 1
    global keyTime2 := A_TickCount
    countTimeout := 300
    SetTimer CheckKeyCount2, -countTimeout
}
CheckKeyCount2(*) {
    global keyCount2
    if keyCount2 = 1 {
        ; 1回押しのアクションをここに記述
        ; Run("calc.exe") ; 電卓を開く
        Run("..\..\portableApp\qalculate-5.3.0-x64\qalculate\qalculate-qt.exe")  ; Qalculate!電卓を開く
    } else if keyCount2 = 2 {
        ; 2回押しのアクションをここに記述
        Run(".\my-time-tracker\my-time-tracker.exe")  ; TimeTrackerを開く
    } else if keyCount2 >= 3 {
        ; 3回押しのアクションをここに記述
    }

    ; カウントをリセット
    keyCount2 := 0
}

; 3
global keyCount3 := 0
^!+F9 Up::{
    global keyCount3
    keyCount3 += 1
    countTimeout := 300
    SetTimer CheckKeyCount3, -countTimeout
}
CheckKeyCount3(*) {
    global keyCount3

    if keyCount3 = 1 {
        ; 1回押しのアクションをここに記述
        ; シークレットマイクミュート
        ; powertoysの機能「ビデオ会議のミュート」
        Send("^+a")
    } else if keyCount3 = 2 {
        ; 2回押しのアクションをここに記述
        ; Discordのときのみミュート
        ; Discordのウィンドウがアクティブならミュート
        if WinActive("ahk_exe Discord.exe") {
            Send("^+m")
        }
    } else if keyCount3 >= 3 {
        ; 3回押しのアクションをここに記述
    }

    ; カウントをリセット
    keyCount3 := 0
}

; ノブ回転
global timeSame2 := 0
; ノブ左回転
^!+F10::{
    ; ボリュームダウン
    global keyTime2
    static time := 0
    global timeSame2
    if(keyTime2 + 300 < A_TickCount && timeSame2 + 1000 < A_TickCount) {
        time_diff := (A_TickCount - time + 1) / 1000
        volume_diff := 0.4 / time_diff + 1
        ; volume_diff := 5 * 50**(-time_diff*0.5)
        ; SoundSetVolume -volume_diff
        Send "{Volume_Down " volume_diff "}"
        time := A_TickCount
    } else {
        global keyCount2 := 0

        time_diff := (A_TickCount - timeSame2 + 1) / 1000
        ; volume_diff := (0.4 / time_diff + 1) * 0.01
        volume_diff := 5 * 50**(-time_diff*0.5) * 0.01
        RunWait("..\..\portableApp\nircmd-x64\nircmdc.exe changeappvolume Discord.exe -" volume_diff, , "Hide")
        RunWait("..\..\portableApp\nircmd-x64\nircmdc.exe changeappvolume Zoom.exe -" volume_diff, , "Hide")
        RunWait("..\..\portableApp\nircmd-x64\nircmdc.exe changeappvolume slack.exe -" volume_diff, , "Hide")    
        timeSame2 := A_TickCount
    }
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
    global keyTime2
    static time := 0
    global timeSame2
    if(keyTime2 + 300 < A_TickCount && timeSame2 + 1000 < A_TickCount) {
        time_diff := (A_TickCount - time + 1) / 1000
        volume_diff := 0.4 / time_diff + 1
        ; SoundSetVolume -volume_diff
        Send "{Volume_Up " volume_diff "}"
        time := A_TickCount
    } else {
        global keyCount2 := 0

        time_diff := (A_TickCount - timeSame2 + 1) / 1000
        ; volume_diff := (0.4 / time_diff + 1) * 0.01
        volume_diff := 5 * 50**(-time_diff*0.5) * 0.01
        RunWait("..\..\portableApp\nircmd-x64\nircmdc.exe changeappvolume Discord.exe " volume_diff, , "Hide")
        RunWait("..\..\portableApp\nircmd-x64\nircmdc.exe changeappvolume Zoom.exe " volume_diff, , "Hide")
        RunWait("..\..\portableApp\nircmd-x64\nircmdc.exe changeappvolume slack.exe " volume_diff, , "Hide")    
        timeSame2 := A_TickCount
    }
}
