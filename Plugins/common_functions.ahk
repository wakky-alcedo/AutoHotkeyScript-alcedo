; 共通関数

; ツールチップ表示用関数
my_tooltip_function(str, delay, WhichToolTip := 1) {
  ToolTip(str, , , WhichToolTip)           ; 指定されたメッセージを表示
  Sleep(delay)
  ToolTip("", , , WhichToolTip)            ; ツールチップを消す
}

; ; ツールチップ消去用関数
; remove_tooltip(WhichToolTip) {
;     ToolTip("", , , WhichToolTip)            ; ツールチップを消す
; }

; ; 全ツールチップ消去用関数
; remove_tooltip_all() {
;     for i in 1..20 {
;         ToolTip("", , , i)                   ; すべてのツールチップを消す
;     }
; }

; カレントディレクトリ取得
; エクスプローラのカレントディレクトリを取得し，テキストを返す
get_current_dir() {
  explorerHwnd := WinActive("ahk_class CabinetWClass") ; アクティブなエクスプローラウィンドウのハンドルを取得
  If (explorerHwnd) {
      for window in ComObject("Shell.Application").Windows {
          If (window.hwnd == explorerHwnd)
              Return window.Document.Folder.Self.Path  ; アクティブなエクスプローラウィンドウのパスを返す
      }
  }
}

; ホットキー定義用関数
; keys: ホットキーとして設定するキーのリスト
; func: ホットキーが押された時に実行する関数
; OnOff: ホットキーの有効・無効を指定（"On": 有効, "Off": 無効）
hotkeys_define(keys, func, OnOff) {
  Loop Parse, keys, ","
      Hotkey(A_LoopField, func, OnOff)
}

disable_keys() {
  Return
}

; 改行コード除去
; str: 改行コードを除去する文字列
rm_crlf(str) {
  str := RegExReplace(str, "`n", "")      ; 改行（\n）を除去
  str := RegExReplace(str, "`r", "")      ; キャリッジリターン（\r）を除去
  Return str
}
