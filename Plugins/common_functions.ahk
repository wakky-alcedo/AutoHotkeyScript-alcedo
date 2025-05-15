; 共通関数

; ツールチップ表示用関数
my_tooltip_function(str, delay, WhichToolTip := 1) {
  ToolTip(str, , , WhichToolTip)           ; 指定されたメッセージを表示
  Sleep(delay)
  ToolTip("", , , WhichToolTip)            ; ツールチップを消す
}

tooltip_with_timeout(msg, whichToolTip := 1, timeout := 2000, x := 0, y := 0) {
  SetTimer(() => Tooltip("", x, y, whichToolTip), -timeout) ; 指定時間後にTooltipを非表示にする
  Tooltip(msg, x, y, whichToolTip) ; Tooltipを表示
}

msgBox_with_timeout(msg, title := "MyTitle", timeout := 2000) {
  SetTimer(() => WinClose(title), -timeout) ; 指定時間後にMsgBoxを閉じる
  MsgBox(msg, title)
}

my_tooltip_nodelay(str, WhichToolTip := 1) {
  ToolTip(str, , , WhichToolTip)           ; 指定されたメッセージを表示
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

; 半角入力
send_text(str) {
  conv_mode := IME_GetConvMode()                ; IMEの状態を取得
  state := IME_GET()                            ; IMEの状態を取得
  IME_SetConvMode(0)                           ; IMEを半角入力に設定
  IME_SET(0)                                   ; 半角入力に設定
  ; Sleep 10
  Send(str)
  Sleep 100
  IME_SetConvMode(conv_mode)                    ; IMEの状態を元に戻す
  IME_SET(state)                                ; IMEの状態を元に戻す
}

; ブラウザであるかどうか確認
is_browser() {
  If WinActive("ahk_exe chrome.exe") ; Chrome
    || WinActive("ahk_exe msedge.exe") ; Edge
    || WinActive("ahk_exe opera.exe") ; Opera
    || WinActive("ahk_exe vivaldi.exe") ; Vivaldi
      Return True
  Else
      Return False
}

open_vivaldi(url) {
  ; [common] fix: vivaldiのフォルダはPCによって違うので，修正
  ; Vivaldiを開く
  If A_ComputerName == 'HP-ENVY-X360' {
    ; ノートPCの場合は、Vivaldiを開く
    Run("C:\Users\takuj\AppData\Local\Vivaldi\Application\vivaldi.exe --new-window " url)
  } Else {
    ; デスクトップの場合は、Vivaldiを開く
    ; Run("C:\Program Files\Vivaldi\Application\vivaldi.exe --new-window " url)
    ; Run("C:\Users\KAWASEMI\AppData\Local\Vivaldi\Application\vivaldi.exe --new-window " url)
  }
}

get_time() {
  ; 現在時刻を取得
  Return Format("{:02}{:02}", A_Hour, A_Min)
}

get_date() {
  ; 現在日付を取得
  Return Format("{:04}{:02}{:02}", A_Year, A_MM, A_DD)
}

format_window_title(title) {
  position := InStr(title, " - ", , -1)  ; 最右の「 - 」の位置を取得
  if (position > 0) {
      title := SubStr(title, 1, position-1) ; 最も左から「 - 」の手前までを取得 
  }
  title := RegExReplace(title, "\(\d+\) ")
  return title
}

is_window_on_primary_monitor(hwnd) {
  ; ウィンドウの位置とサイズを取得
  WinGetPos(&x, &y, &w, &h, hwnd)
  ; ウィンドウの中央位置を計算
  centerX := x + w // 2
  centerY := y + h // 2

  ; プライマリモニターの情報を取得
  MonitorGet , &Left, &Top, &Right, &Bottom

  ; ウィンドウの中央がプライマリモニターの範囲内にあるかチェック
  return (centerX >= Left && centerX <= Right
       && centerY >= Top && centerY <= Bottom)
}