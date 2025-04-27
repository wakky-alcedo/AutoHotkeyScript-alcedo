#Requires AutoHotkey v2.0

originalVolume := SoundGetVolume()  ; 現在の音量を保存

; Send("{Media_Play_Pause}")               ; メディアの一時停止
SoundSetVolume(50)                 ; 音量を50に設定

; mp3Path := "C:\Users\taku\Downloads\zunda_dinner.mp3"
; Run('wmplayer.exe "' mp3Path '"')   ; MP3再生（クオートを正しく扱う）
; Run('powershell -WindowStyle Hidden -Command (New-Object Media.SoundPlayer "' mp3Path '").PlaySync();')
; Sleep(5000)  ; 再生の時間（必要に応じて変更）

wavPath := "zunda_17.wav"
SoundPlay(wavPath, 1)  ; waitの引数を1に設定して、再生が完了するまで待機

SoundSetVolume(originalVolume)     ; 元の音量に戻す
; Send("{Media_Play}")         ; メディアの再開
