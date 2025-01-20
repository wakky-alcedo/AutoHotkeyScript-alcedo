#Requires AutoHotkey v2.0

#include "gui_common.ahk"

gui_default() {
    MyGui.Add("Text", , "default")
    MyGui.Add("Button", "", "Google検索 (&g)").OnEvent("Click", Google)
    MyGui.Add("Button", "", "Notepad起動 (&n)").OnEvent("Click", NotepadStart)
    MyGui.Add("Button", "", "color picker").OnEvent("Click", RunColorPicker)
    MyGui.Add("Button", "", "スリープ").OnEvent("Click", PCSleep)
    MyGui.Add("Button", "", "time tracker").OnEvent("Click", RunTimeTracker)
    MyGui.Add("Button", "", "Tweet").OnEvent("Click", Tweet)
    MyGui.Add("Button", "", "Tweet (日記)").OnEvent("Click", TweetDiary)
    MyGui.Add("Button", "", "電卓").OnEvent("Click", RunCalculator)
    MyGui.Add("Button", "", "スクリーンショット").OnEvent("Click", ScreenShot)
}

Google(*)               => sendText("aaa")
NotepadStart(*)         => Run("notepad.exe")  ; メモ帳を開く
RunColorPicker(*)       => Send("+#c") ;Run("C:\Windows\System32\colorcpl.exe")  ; カラーピッカーを開く
PCSleep(*)              => DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)  ; スリープ
RunTimeTracker(*)       => Run(".\my-time-tracker\my-time-tracker.exe")  ; TimeTrackerを開く
Tweet(*)                => tweet_content()  ; Tweetを開く
TweetDiary(*)           => tweet_content("%23Wakky習慣の記録")  ; Tweetを開く
; RunCalculator(*)        => Run("calc.exe")  ; Windous電卓を開く
RunCalculator(*)        => Run("..\..\portableApp\qalculate-5.3.0-x64\qalculate\qalculate-qt.exe")  ; Qalculate!電卓を開く
ScreenShot(*)           => Send("#+s")

tweet_content(content := "") {
    ; Vivaldiを開く
    if (content == "") {
        open_vivaldi("https://x.com/intent/post")
    } else {
        open_vivaldi("https://x.com/intent/tweet?text=" content)
    }
    WinWait("ホーム / X", , 5) ; 最大5秒待機

    ; サイズと位置を設定 (例: 横800px, 縦600px、画面左上に配置)
    width := 650
    hight := 400
    WinMove((A_ScreenWidth/2)-(width/2), (A_ScreenHeight/2)-(hight/2), width, hight)
    Send("^{F11}")
}