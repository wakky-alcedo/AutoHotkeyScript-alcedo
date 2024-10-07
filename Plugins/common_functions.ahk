; 共通関数

; ツールチップ表示用関数
my_tooltip_function(str, delay, WhichToolTip := 1) {
    ToolTip, %str% ,,, %WhichToolTip%                        ; 指定されたメッセージを表示
    ; SetTimer, remove_tooltip, -%delay%     ; 指定時間後にツールチップを消すタイマーを設定
    sleep, %delay%
    ToolTip,,,,%WhichToolTip%  
}
  
; ; ツールチップ消去用関数
; remove_tooltip(WhichToolTip){
;     ToolTip,,,,%WhichToolTip%                            ; ツールチップを消す
; }
  
; ; 全ツールチップ消去用関数
; remove_tooltip_all:
;     SetTimer, remove_tooltip, Off          ; 全ツールチップを削除するためのサブルーチン
;     Loop, 20
;     ToolTip, , , , % A_Index               ; ツールチップをすべて消す
; Return
  
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
  