; 監視用exeが動いているかを監視し，動いていない場合は再起動するスクリプト

; 監視するアプリケーションのパス
; appPaths := ["close_twitter.exe", "close_privatewindows.exe"]
appPaths := ["monitor_apps.exe"]

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

    ; プロセスが存在するか確認
    Process, Exist, %currentProcessName%
    if ErrorLevel = 0
    {
        ; プロセスが存在しない場合、アプリケーションを再起動
        ToolTip, Restarting %currentProcessName%
        Sleep 1000
        ToolTip
        Run, %currentAppPath%
    }
}
return
