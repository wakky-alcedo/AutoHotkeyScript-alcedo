; discord で 送信と改行のキーの設定を変える

#IfWinActive,ahk_exe Discord.exe        ; Discordを開いている時だけ

;-----------------------------------------------------------
; IMEの状態の取得
; WinTitle="A" 対象Window
; 戻り値 1:ON / 0:OFF
;-----------------------------------------------------------
IME_GET(WinTitle="A") {
ControlGet,hwnd,HWND,,,%WinTitle%
    if (WinActive(WinTitle)) {
        ptrSize := !A_PtrSize ? 4 : A_PtrSize
        VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
        NumPut(cbSize, stGTI, 0, "UInt") ; DWORD cbSize;
        hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
        ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
        return DllCall("SendMessage"
            , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
            , UInt, 0x0283  ;Message : WM_IME_CONTROL
            ,  Int, 0x0005  ;wParam  : IMC_GETOPENSTATUS
            ,  Int, 0)      ;lParam  : 0
    }
}

;-----------------------------------------------------------
; IMEの状態をセット
; SetSts 1:ON / 0:OFF
; WinTitle="A" 対象Window
; 戻り値 0:成功 / 0以外:失敗
;-----------------------------------------------------------
IME_SET(SetSts, WinTitle="A") {
    ControlGet,hwnd,HWND,,,%WinTitle%
    if (WinActive(WinTitle)) {
        ptrSize := !A_PtrSize ? 4 : A_PtrSize
        VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
        NumPut(cbSize, stGTI, 0, "UInt") ; DWORD cbSize;
        hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
        ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
    }

    return DllCall("SendMessage"
        , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
        , UInt, 0x0283  ;Message : WM_IME_CONTROL
        ,  Int, 0x006   ;wParam  : IMC_SETOPENSTATUS
        ,  Int, SetSts) ;lParam  : 0 or 1
}

;---------------------------------------------------------------------------
; IME 文字入力の状態を返す
; (パクリ元 : http://sites.google.com/site/agkh6mze/scripts#TOC-IME- )
; 標準対応IME : ATOK系 / MS-IME2002 2007 / WXG / SKKIME
; その他のIMEは 入力窓/変換窓を追加指定することで対応可能
;
; WinTitle="A" 対象Window
; ConvCls="" 入力窓のクラス名 (正規表現表記)
; CandCls="" 候補窓のクラス名 (正規表現表記)
; 戻り値 1 : 文字入力中 or 変換中
; 2 : 変換候補窓が出ている
; 0 : その他の状態
;
; ※ MS-Office系で 入力窓のクラス名 を正しく取得するにはIMEのシームレス表示を
; OFFにする必要がある
; オプション-編集と日本語入力-編集中の文字列を文書に挿入モードで入力する
; のチェックを外す
;---------------------------------------------------------------------------
IME_GetConverting(WinTitle="A",ConvCls="",CandCls="") {

    ;IME毎の 入力窓/候補窓Class一覧 ("|" 区切りで適当に足してけばOK)
    ConvCls .= (ConvCls ? "|" : "")                 ;--- 入力窓 ---
            .  "ATOK\d+CompStr"                     ; ATOK系
            .  "|imejpstcnv\d+"                     ; MS-IME系
            .  "|WXGIMEConv"                        ; WXG
            .  "|SKKIME\d+\.*\d+UCompStr"           ; SKKIME Unicode
            .  "|MSCTFIME Composition"              ; Google日本語入力

    CandCls .= (CandCls ? "|" : "")                 ;--- 候補窓 ---
            .  "ATOK\d+Cand"                        ; ATOK系
            .  "|imejpstCandList\d+|imejpstcand\d+" ; MS-IME 2002(8.1)XP付属
            .  "|mscandui\d+\.candidate"            ; MS Office IME-2007
            .  "|WXGIMECand"                        ; WXG
            .  "|SKKIME\d+\.*\d+UCand"              ; SKKIME Unicode
    CandGCls := "GoogleJapaneseInputCandidateWindow" ;Google日本語入力

    Send, %ConvCls%
    Send, %CandCls%
    Send, %CandGCls%

    ControlGet,hwnd,HWND,,,%WinTitle%
    if    (WinActive(WinTitle))    {
        ptrSize := !A_PtrSize ? 4 : A_PtrSize
        VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
        NumPut(cbSize, stGTI,  0, "UInt")   ;    DWORD   cbSize;
        hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
                ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
    }

    WinGet, pid, PID,% "ahk_id " hwnd
    tmm:=A_TitleMatchMode
    Send, %tmm%
    SetTitleMatchMode, RegEx
    ret := WinExist("ahk_class " . CandCls . " ahk_pid " pid) ? 2
        :  WinExist("ahk_class " . CandGCls                 ) ? 2
        :  WinExist("ahk_class " . ConvCls . " ahk_pid " pid) ? 1
        :  0
    SetTitleMatchMode, %tmm%
    Send, %tmm%
    return ret
}



Shift & Enter::                         ; Shift & Enter
Shift & NumpadEnter::                   ; Shift & NumpadEnter を押したら
    Send, +{Enter}                      ; Ctrl + Enter を押したことにする
    return

Enter::                                 ; Enter
NumpadEnter::                           ; NumpadEnter を押したら
    Send, ^m                            ; 入力中の文字を確定させる
    return

Ctrl & Enter::                          ; Ctrl + Enter を押したら
Ctrl & NumpadEnter::                    ; Ctrl + NumpadEnter を押したら
Alt & Enter::                           ; Alt + Enter を押したら
Alt & NumpadEnter::                     ; Alt + NumpadEnter を押したら
    Send, {Enter}                       ; Enter を押したことにする
    return

#IfWinActive