; 自動保存

; UIAライブラリを読み込む
#Include "../UIA.ahk"

; GroupAdd("freq_app", "ahk_exe Code.exe")
GroupAdd("freq_app", "ahk_exe WINWORD.EXE")
; GroupAdd("freq_app", "ahk_exe EXCEL.EXE")
GroupAdd("freq_app", "ahk_class PPTFrameClass") ; パワポ編集画面
;GroupAdd freq_app, ahk_exe POWERPNT.EXE
GroupAdd("freq_app", "ahk_exe Jw_win.exe")
GroupAdd("freq_app", "ahk_exe kicad.exe")
GroupAdd("ask_app", "ahk_exe Inventor.exe")
GroupAdd("ask_app", "ahk_exe SLDWORKS.exe")
GroupAdd("ask_app", "ahk_exe Fusion360.exe")

save()
{
    Send("^s")
    ToolTip("Auto saved!")
    Sleep(1000)
    ToolTip()
    ; SetTimer(OnTimer,-30000) ; 30sec
}

is_ask_app_active() {
    try {
        title := WinGetTitle("A") ; タイトルを取得
        ; UIAライブラリを使用してウィンドウの要素を取得
        windowElement := UIA.ElementFromHandle(WinExist("A"))
        ; ウィンドウの直下にある全ての子要素を取得
        childElements := windowElement.FindAll()
        ; 各要素の情報をリストに追加
        message := ""
        for element in childElements {
            if element.Name != "" {
                message .= element.Name "`n"
            }
            if InStr(element.Name, "ｽｹｯﾁ") && InStr(element.Name, "←") {
                ; MsgBox("スケッチモードです")
                return false
            }
        }
        return true
    } catch Error as e {
        ToolTip("UIAエラー: " e.Message, , , 1)
        SetTimer(() => ToolTip("", , , 1), -2000)
        return false
    }
    return WinActive("ahk_group ask_app")
}

Persistent ; 持続的
SetTimer(OnTimer,5000)
; Return

OnTimer() { ; V1toV2: Added bracket
    ; global ; V1toV2: Made function global
    static freq_count := 0
    static ask_count := 0
    if WinActive("ahk_group freq_app") {
        freq_count := freq_count + 1
        if (freq_count > 6 && A_TimeIdlePhysical > 3000 ) {
            save()
            freq_count := 0
        }
    } else if is_ask_app_active() {
        ask_count := ask_count + 1
        If (ask_count > 30) {
            ; msgboxを表示（最前面，非Activeウィンドウ）
            If (MsgBox("Save?",,0x40001) = "OK"){ ; 0x40000: to the top, 0x1: OK,Cancel
                Sleep(50)
                if is_ask_app_active() { ; MsgBoxを開いている間にウィンドウが変わる可能性があるので再度確認
                    save()
                    ask_count := 0
                }
            } else {
                Sleep(50)
                if is_ask_app_active() { ; MsgBoxを開いている間にウィンドウが変わる可能性があるので再度確認
                    ask_count := 30
                }
            }
        }
    }
    ; Return
} ; V1toV2: Added bracket in the end
; A_TimeIdle：最後に何らかの入力があってからの経過時間をミリ秒で格納。(NT系専用)
