; OneNoteでのリンクを挿入を自動化
; 使い方
; 1. URL，タイトルの順にクリップボードにコピー
; 2. OneNote上で，shift+ctrl+vを押す 

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
; IMEの半角全角の切り替え
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


#IfWinActive ahk_exe ApplicationFrameHost.exe ;実行ファイル名
+^v::
    ;MsgBox, Hello AutoHotkey world
    ;SetKeyDelay[, 300, 2]
    BlockInput, on
    SendMode Input
    is_IME := IME_GET()
    if (is_IME = 1) {
        IME_SET(0) ; 半角に
    }
    Sleep 100
    
    ; リンクの挿入を開く
    Send,^k
    Sleep 200
    ; リンクを貼り付け
    Send,#v
    Sleep 200
    Send,{Down}
    Send,{Enter}
    Sleep 400
    ; カーソルの移動
    Send,+{Tab}
    Sleep 200
    ; タイトルを貼り付け
    Send,#v
    Sleep 200
    Send,{Enter}
    ;Sleep 500
    ; 確定
    ;Send,{Enter}

    if (is_IME = 1) {
        IME_SET(1) ; 全角に
    }
    BlockInput, off
    return

#IfWinActive


; 保存したら自動で再実行するらしい？
;SetTitleMatchMode,2 #IfWinActive  Notepad++
;	~^s::Reload #IfWinActive