@echo off

:: 自身を最小化して別のプロセスで実行する処理
:: バッチファイルがダブルクリックで実行された場合に最小化された状態で再起動する
@if not "%~0"==""%~dp0.%~nx0" start /min cmd /c,""%~dp0.%~nx0" %* & goto :eof

:: 現在の時刻を取得（例: 14:35）
set time2=%time::=%

:: 時間と分を取得し、数値だけにする
:: 例: 14:35 → hour=14, minute=35
set hour=%time2:~0,2%
set minute=%time2:~3,2%

:: 時間と分を結合して1つの数値にする（例: 1435）
set time3=%hour%%minute%

:: カラーフィルタの有効状態を確認
:: レジストリキー "Active" の値を取得し、値が 0x0（無効）かどうかを判定する
reg query "HKEY_CURRENT_USER\SOFTWARE\Microsoft\ColorFiltering" /v Active | find "0x0"

:: エラーコード(ErrorLevel)で条件分岐
:: 値が0x0（無効）であれば Set_on ラベルへ、そうでなければ Set_off ラベルへ進む
if %ErrorLevel%==0 goto Set_on else goto Set_off

::-----------------------------------------------
:: カラーフィルタが無効な場合の処理
:Set_on
:: 時刻が 02:00 以上かつ 06:00 未満の場合にフィルタを有効化する
if %time3% lss 0600 if %time3% geq 0200 call "C:\Program Files\bat\gray.exe"

:: スクリプトを終了
goto :eof

::-----------------------------------------------
:: カラーフィルタが有効な場合の処理
:Set_off
:: 時刻が 02:00 以上かつ 06:00 未満の場合にフィルタを無効化する
if %time3% lss 0600 if %time3% geq 0200 call "C:\Program Files\bat\gray.exe"

:: スクリプトを終了
goto :eof


:: コメント
@REM コメン