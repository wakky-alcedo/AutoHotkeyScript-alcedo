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

; タイトルを貼り付け
paste_title() {
    Send,#v
    Sleep 400
    Send,{Enter}
}

; リンクを貼り付け
paset_link() {
    Send,#v
    Sleep 400
    Send,{Down}
    Send,{Enter}
} 

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

    ; アクティブウィンドウの実行ファイルを取得
    WinGet, active_exe, ProcessName, A

    If(active_exe = "ApplicationFrameHost.exe") ; OneNote
    {
        ; リンクの挿入を開く
        Send,^k
        Sleep 200
        ; リンクを貼り付け
        paset_link()
        Sleep 500
        ; カーソルの移動
        Send,+{Tab}
        Sleep 200
        ; タイトルを貼り付け
        paste_title()
        ;Sleep 500
        ; 確定
        ;Send,{Enter}
    }Else If(active_exe = "slack.exe") ; Slack
    {
        ; リンクの挿入を開く
        Send,^+u
        Sleep 200
        ; タイトルを貼り付け
        Send,^v
        ; カーソルの移動
        Send,{Tab}
        Sleep 200
        ; リンクを貼り付け
        paset_link()
        Sleep 500
        ; 確定
        Send,{Enter}
    }Else If(active_exe = "Discord.exe") ; Discord
    {
        Send,[
        ; タイトルを貼り付け
        Send,^v
        Sleep 100
        ; カーソルの移動
        Send,](<
        Sleep 100
        ; リンクを貼り付け
        paset_link()
        Sleep 500
        ; 確定
        Send,>)
    }Else If(active_exe = "explorer.exe") ; ファイルエクスプローラ
    {
        ; リンクの挿入を開く
        ; 右クリック
        MouseClick, right
        Sleep 200
        Send,w
        Send,s
        Sleep 400
        ; リンクを貼り付け
        paset_link()
        Sleep 500
        ; 次へ
        Send,{Enter}
        Sleep 200
        ; タイトルを貼り付け
        paste_title()
        Sleep 500
        ; 確定
        Send,{Enter}
    }Else{
        Send,[
        ; タイトルを貼り付け
        Send,^v
        Sleep 100
        ; カーソルの移動
        Send,](
        Sleep 100
        ; リンクを貼り付け
        paset_link()
        Sleep 500
        ; 確定
        Send,)
    }

    if (is_IME = 1) {
        IME_SET(1) ; 全角に
    }
    BlockInput, off
    return


; 保存したら自動で再実行するらしい？
;SetTitleMatchMode,2 #IfWinActive  Notepad++
;	~^s::Reload #IfWinActive
