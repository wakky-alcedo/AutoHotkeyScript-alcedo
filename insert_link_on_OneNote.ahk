; OneNoteでのリンクを挿入を自動化
; 使い方
; 1. URL，タイトルの順にクリップボードにコピー
; 2. OneNote上で，shift+ctrl+vを押す 

; IMEの半角全角の切り替え用関数
IME_SET(SetSts, WinTitle="A")    {
	ControlGet,hwnd,HWND,,,%WinTitle%
	if	(WinActive(WinTitle))	{
		ptrSize := !A_PtrSize ? 4 : A_PtrSize
	    VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
	    NumPut(cbSize, stGTI,  0, "UInt")   ;	DWORD   cbSize;
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
    SendMode Input
    IME_SET(0) ; 半角に
    Sleep 100
    Send,^k
    Sleep 200
    Send,#v
    Sleep 200
    Send,{Down}
    Send,{Enter}
    Sleep 100
    Send,+{Tab}
    Sleep 200
    Send,#v
    Sleep 200
    Send,{Enter}
    Sleep 500
    Send,{Enter}
    IME_SET(1) ; 全角に
    return

#IfWinActive


; 保存したら自動で再実行するらしい？
;SetTitleMatchMode,2 #IfWinActive  Notepad++
;	~^s::Reload #IfWinActive