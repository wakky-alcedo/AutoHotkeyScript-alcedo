; 監視用exeが動いているかを監視し，動いていない場合は再起動するスクリプト

; 監視するアプリケーションのパス
; appPaths := ["close_twitter.exe", "close_privatewindows.exe"]
appPaths := ["task_scheduler.exe"]

; アプリケーションのプロセス名
processNames := appPaths

;ToolTip , checkapp
;Sleep 1000
;ToolTip
; プロセスが存在するか確認
Loop, % appPaths.MaxIndex()
{
    ; 現在のアプリケーションのパスとプロセス名を取得
    currentAppPath := appPaths[A_Index]
    currentProcessName := processNames[A_Index]

    Run, %currentAppPath%
}
return