#Persistent                  ; スクリプトを常駐させる
#SingleInstance, Force       ; 多重起動不可
#NoEnv                       ; 環境変数の検索を無効化してパフォーマンスを向上
#UseHook                     ; ホットキーの定義にフックを使用（パフォーマンス向上）
#InstallKeybdHook            ; キーボードフックをインストール
#InstallMouseHook            ; マウスフックをインストール
#HotkeyInterval, 2000        ; ホットキーが無限ループに入らないように検出間隔を設定
#MaxHotkeysPerInterval, 200  ; ホットキー実行の最大回数を設定
Process, Priority,, Realtime ; スクリプトのプロセス優先度をリアルタイムに設定
SendMode, Input              ; SendコマンドをInputモードで高速化
SetWorkingDir %A_ScriptDir%  ; 作業ディレクトリをスクリプトが配置されているフォルダに設定
SetTitleMatchMode, 2         ; ウィンドウタイトルの部分一致を許可
; SetKeyDelay, , 10

; 変数の初期化
#Include, %A_ScriptDir%\Variables.ahk  ; 外部の変数ファイルを読み込む

; メニューアイコン設定
; Menu, Tray, Icon, icon.ico  ; タスクトレイに表示されるアイコンを設定

; プラグインの検出・取り込み
If (search_plugins()) {      ; プラグインが検出されたらスクリプトをリロード
  Reload
}



; プラグイン検出関数
; プラグインを検出して，pluginList.ahkに書き込む
search_plugins() {
  ; Pluginsフォルダ内のAHKファイルを取得し、plugin_filesに格納
  plugin_files := ""
  Loop, %A_ScriptDir%\Plugins\*.ahk {
    plugin_files .= "#" . "Include *i %A_ScriptDir%\Plugins\" . A_LoopFileName . "`n"
  }
  If (plugin_files == "") {  ; プラグインがない場合は終了
    Return 0
  }
  ; PluginList.ahkの内容を読み取り
  file := FileOpen(A_ScriptDir . "\PluginList.ahk", "r `n", "utf-8")
  If (file) {
    plugin_list_old := file.Read(file.Length)  ; 既存のプラグインリストを取得
    file.Close
    If (plugin_list_old == plugin_files) {     ; 変更がなければ終了
      Return 0
    }
  }
  ; 新しいプラグインリストを書き込む
  file := FileOpen(A_ScriptDir . "\PluginList.ahk", "w `n", "utf-8")
  If (!file) {                                ; 書き込みに失敗した場合は終了
    Return 0
  }
  file.Write(plugin_files)                     ; プラグインリストを書き込む
  file.Close
  Return 1
}

; 練習用キー無効化
hotkeys_define(keys_practice, "keys_practice", "On") ; 無効化するキーを動的に設定
keys_practice:
  count++
  If (count > 1)
    my_tooltip_function("そのキーは禁止です(" . count - 1 . "回目)", 1000) ; キーが禁止された際にツールチップを表示
Return

; (AutoExexuteここまで)



#Include, %A_ScriptDir%\PluginList.ahk  ; プラグインをインクルード

#Include, %A_ScriptDir%\start_list.ahk  ; スタートアップスクリプトをインクルード