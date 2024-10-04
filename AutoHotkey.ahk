#Persistent                  ; スクリプトを常駐させる
#SingleInstance, Force       ; 同じスクリプトが実行中の場合、再実行時にリロードする
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

; 共通関数

; ツールチップ表示用関数
my_tooltip_function(str, delay) {
  ToolTip, %str%                         ; 指定されたメッセージを表示
  SetTimer, remove_tooltip, -%delay%     ; 指定時間後にツールチップを消すタイマーを設定
}

; ツールチップ消去用関数
remove_tooltip:
  ToolTip                                ; ツールチップを消す
Return

; 全ツールチップ消去用関数
remove_tooltip_all:
  SetTimer, remove_tooltip, Off          ; 全ツールチップを削除するためのサブルーチン
  Loop, 20
  ToolTip, , , , % A_Index               ; ツールチップをすべて消す
Return

; カレントディレクトリ取得
; エクスプローラのカレントディレクトリを取得し，テキストを返す
get_current_dir() {
  explorerHwnd := WinActive("ahk_class CabinetWClass") ; アクティブなエクスプローラウィンドウのハンドルを取得
  If (explorerHwnd) {
    for window in ComObjCreate("Shell.Application").Windows {
      If (window.hwnd==explorerHwnd)
        Return window.Document.Folder.Self.Path  ; アクティブなエクスプローラウィンドウのパスを返す
    }
  }
}

; ホットキー定義用関数
; keys: ホットキーとして設定するキーのリスト
; label: ホットキーが押された時に実行するラベル
; OnOff: ホットキーの有効・無効を指定（On: 有効, Off: 無効）
hotkeys_define(keys, label, OnOff) {
  Loop, PARSE, keys, `,                   ; 指定されたキーリストをパースしてホットキーを設定
    Hotkey, %A_LoopField%, %label%, %OnOff%
  Return
}

disable_keys:
Return

; 改行コード除去
; str: 改行コードを除去する文字列
rm_crlf(str) {
  str := RegExReplace(str, "\n", "")      ; 改行（\n）を除去
  str := RegExReplace(str, "\r", "")      ; キャリッジリターン（\r）を除去
  Return str
}
