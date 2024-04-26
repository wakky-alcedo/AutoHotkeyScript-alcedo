; ショーとカットで今日の日付を代入するようにした

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

; ctrl+;
^vkBB::
    IME_SET(0) ; 半角に
    FormatTime,TimeString,,yyyy/MM/dd
    Send,%TimeString%
    Sleep, 1
    IME_SET(1) ; 全角に
    Return

; ctrl+:
^vkBA::
    IME_SET(0) ; 半角に
    FormatTime,TimeString,,hh:mm
    Send,%TimeString%
    Sleep, 1
    IME_SET(1) ; 全角に
    Return
