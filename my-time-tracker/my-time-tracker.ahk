; 全画面オーバーレイウィンドウを作成するスクリプト

; オーバーレイウィンドウを作成する関数
; 新しいGUIウィンドウを作成し、名前をつける（ここでは "Overlay" とします）
; 各ディスプレイの情報を取得
Overlay() {
    SysGet, MonitorCount, MonitorCount
    Loop %MonitorCount%
    {
        SysGet, Monitor, Monitor, %A_Index% ; ループの実行回数。1回目は 1
        MonitorWidth := MonitorRight - MonitorLeft
        MonitorHeighth := MonitorBottom - MonitorTop
        ; 新しいGUIウィンドウを作成し、名前をつける（ここでは "Overlay" とします）
        Gui, Overlay%A_Index%: +AlwaysOnTop +ToolWindow
        ;Gui, Overlay%A_Index%: Add, Text, w%A_ScreenWidth% h%A_ScreenHeight% BackgroundTrans
        Gui, Overlay%A_Index%: Color, 808080 ; グレー
        Gui, Overlay%A_Index%: Show, x%MonitorLeft% y%MonitorTop% w%MonitorWidth% h%MonitorHeighth% ; ウィンドウを画面全体に表示

        ; ウィンドウを少し透明にする
        ;WinSet, TransColor, 808080 150, Overlay ; グレー色を透明に設定し、透明度を設定
        WinSet, Transparent, 200, ahk_class AutoHotkeyGUI

        ; キャプションを削除
        Gui, Overlay%A_Index%: -Caption
    }
}

; 終了処理の関数
ExitScript() {
    SysGet, MonitorCount, MonitorCount
    Loop %MonitorCount%
    {
        Gui, Overlay%A_Index%: Destroy
    }
    ExitApp
    return
}

; モーダルダイアログを表示する関数
ShowModal() {
    ; GUI作成
    Gui, Add, Text,, Describe your activity: ; テキストラベルを追加
    Gui, Add, Edit, vActivityEdit w300 h30 ; 入力フィールドを追加。vActivityEditは、入力内容を格納する変数
    Gui, Add, Button, gSaveActivity, Save Activity ; 保存ボタンを追加。クリック時にSaveActivityラベルを呼び出す
    Gui, Add, Button, gCancelActivity, Cancel ; キャンセルボタンを追加。クリック時にCancelActivityラベルを呼び出す
    Gui, Show, w400 h150, Activity Logger ; ダイアログを表示。w400は幅、h150は高さ、Activity Loggerはウィンドウタイトル
    ; ウィンドウを最前面に設定
    WinSet, AlwaysOnTop, On, Activity Logger ; ダイアログを常に最前面に表示
}

; 保存ボタンがクリックされたときに呼ばれる関数
SaveActivity() {
    Gui, Submit ; ユーザーの入力内容を変数に保存
    Gui, Destroy ; ダイアログを閉じる
    if (ActivityEdit = "") {
        ShowModal() ; モーダルダイアログを再表示
        return
    }
    ; MsgBox, 262144, , You entered: %ActivityEdit% ; 入力内容をメッセージボックスで表示
    PostGas(ActivityEdit)
    ExitScript() ; スクリプトを終了
    return
}

; キャンセルボタンがクリックされたときに呼ばれる関数
CancelActivity() {
    Gui, Destroy ; ダイアログを閉じる
    ExitScript() ; スクリプトを終了
    return
}

PostGas(param) {
    #Include .env.local.ahk
    url := "https://script.google.com/macros/s/" . DEPLOY_ID . "/exec"
    QUERY := "param=" . param
    request := url . "?" . QUERY
    HttpObj := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    HttpObj.open("GET", request, false)
    HttpObj.send()
    HttpObj.WaitForResponse()

    Status := HttpObj.Status ; なんか一時的に別の変数に入れないとMsgBoxで表示されない

    if (Status == 200)
    {
        ResponseText := HttpObj.ResponseText
        MsgBox, 262144, , %ResponseText%
    }
    else
    {
        MsgBox, 262144, , Failed to send request. Status: %Status%
    }
}

; グローバル変数を定義
global ActivityEdit

; オーバーレイウィンドウを作成
Overlay()

; スクリプトのメイン部分
; モーダルダイアログを表示する
ShowModal()

; スクリプト終了処理
; OnExit, ExitScript ; スクリプト終了時にExitScriptラベルを呼び出す
return

; ESCキーでウィンドウを閉じる
Esc::
    ExitScript()
