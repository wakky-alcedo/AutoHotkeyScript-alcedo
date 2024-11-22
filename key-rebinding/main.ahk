OnClipboardChange(ClipChanged)
; 英数キー(CapsLock)を無効化（無反応にする）
; vkF0::Return

; Win + Eでデスクトップフォルダを開く（通常はエクスプローラーが開く）
; #e::Run, %A_Desktop%

; 音量関連の設定
; アプリケーションキーを単独で押した場合は通常の動作を維持
; アプリケーションキー＝windowsキーのこと
AppsKey::Send("{AppsKey}")

; アプリケーションキーと矢印上キーを同時に押して音量を1つ上げる
AppsKey & Up::SoundSetVolume(+1)  ; 音量を1つ上げる

; アプリケーションキーと矢印下キーを同時に押して音量を1つ下げる
AppsKey & Down::SoundSetVolume(-1)

; アプリケーションキーと矢印左キーを同時に押して音量をミュートにする
AppsKey & Left::SoundSetMute(-1)  ; 音量をミュートにする（トグル）

; クリップボードの内容が変更された時に「コピー」と表示するツールチップを300ミリ秒間表示
ClipChanged(Type)
{
    global ; V1toV2: Made function global
    my_tooltip_function("コピー", 300, 20)
    Return
}

; Ctrl + Sを押した時、ファイルを上書き保存し、「上書き保存」と表示するツールチップを300ミリ秒間表示
; ^s::{
;     global ; V1toV2: Made function global
;     Send("^s")
;     my_tooltip_function("上書き保存", 300)
;     Return
; }

; Alt + F10でタイムシフト録画を行った時、録画保存フォルダを開く
~!F10::^!F10

; Ctrl + Alt + F10で手動で録画の保存フォルダを開く
^!F10::Run("D:\Videos\GeforceExperience")

; Ctrl + Shift + Alt + Pで現在のディレクトリのパスをクリップボードにコピー
^+!p::A_Clipboard := get_current_dir()

; Ctrl + 「`」キーを押して現在の日付を「yyyyMMdd」の形式で入力
; ^vkBB::
;   FormatTime, dateStr, , yyyyMMdd
;   Send, {vkF2}{vkF3}%dateStr%
; Return

