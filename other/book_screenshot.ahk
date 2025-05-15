#Requires AutoHotkey v2.0

Sleep(2000)

Loop 130 ; todo ここは毎回変更する
{
    ; 1秒待機
    Sleep(1000)
    ; 全画面のスクリーンショットを指定したフォルダに保存（日付と時間を入れる）
    ; FilePath := "C:\Users\takuj\Pictures\Screenshots\" A_Now ".png"
    ; Alt+PrintScreenでスクリーンショットを取る　→　OneDriveに保存
    Send("!{PrintScreen}")
    Sleep(300) ; 100でもいいかも
    ; 右矢印キーを押す
    Send("{Right}")
}


; 1. このスクリプトでスクリーンショットを保存する
; 2. PDF24で，スクリーンショットをPDFに変換する
; 3. トリミング
; 4. OCR
