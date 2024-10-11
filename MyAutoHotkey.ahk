; #Persistent                     ; スクリプトを常駐させる
#SingleInstance Force            ; 多重起動不可
; #NoEnv                          ; 環境変数の検索を無効化してパフォーマンスを向上
#UseHook                        ; ホットキーの定義にフックを使用（パフォーマンス向上）
; #InstallKeybdHook               ; キーボードフックをインストール
; #InstallMouseHook               ; マウスフックをインストール
; #HotkeyInterval 2000            ; ホットキーが無限ループに入らないように検出間隔を設定
; #MaxHotkeysPerInterval 200      ; ホットキー実行の最大回数を設定
; ProcessSetPriority 'Realtime'   ; スクリプトのプロセス優先度をリアルタイムに設定
; SendMode 'Input'                ; SendコマンドをInputモードで高速化
; SetWorkingDir A_ScriptDir       ; 作業ディレクトリをスクリプトが配置されているフォルダに設定
; SetTitleMatchMode 2             ; ウィンドウタイトルの部分一致を許可

; 変数の初期化
#Include "%A_ScriptDir%\Variables.ahk"  ; 外部の変数ファイルを読み込む

#Include "%A_ScriptDir%\PluginList.ahk"  ; プラグインをインクルード

; メニューアイコン設定
; MenuSetIcon 'icon.ico'  ; タスクトレイに表示されるアイコンを設定

; プラグインの検出・取り込み
if search_plugins()  ; プラグインが検出されたらスクリプトをリロード
    Reload

; プラグイン検出関数
; プラグインを検出して，pluginList.ahkに書き込む
search_plugins() {
    plugin_files := ''
    Loop Files, A_ScriptDir '\Plugins\*.ahk' {
        plugin_files .= '#Include "*i Plugins\' A_LoopFileName '"`n'
    }
    if (plugin_files == '')  ; プラグインがない場合は終了
        return 0

    if FileExist(A_ScriptDir '\PluginList.ahk') {
        plugin_list_old := FileRead(A_ScriptDir '\PluginList.ahk')
        if (plugin_list_old == plugin_files)  ; 変更がなければ終了
            return 0
    }

    file := FileOpen(A_ScriptDir '\PluginList.ahk', 'w')
    if !file
        return 0
    file.Write(plugin_files) ; プラグインリストを書き込む
    file.Close()
    return 1
}

; 練習用キー無効化
hotkeys_define(keys_practice, 'keys_practice', 'On') ; 無効化するキーを動的に設定

keys_practice(*) {
    static count := 0
    count++
    if (count > 1)
        my_tooltip_function('そのキーは禁止です (' . count - 1 . '回目)', 1000) ; キーが禁止された際にツールチップを表示
}

; (AutoExexuteここまで)


#Include "%A_ScriptDir%\start_list.ahk"  ; スタートアップスクリプトをインクルード
