; Excelの改行リマップ
; https://zenn.dev/thinkingsinc/articles/3ee9a6bb35ea55#excel%E3%81%AE%E6%94%B9%E8%A1%8C%E3%83%AA%E3%83%9E%E3%83%83%E3%83%97
#IfWinActive,ahk_exe EXCEL.exe
    ; ※+はShift, !はAltを示す
    +Enter:: !Enter
    +NumpadEnter:: !Enter
#IfWinActive