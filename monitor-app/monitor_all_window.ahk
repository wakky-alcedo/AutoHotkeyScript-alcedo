; �E�B���h�E���X�g���擾
WinGet, id, list
; �E�B���h�E���X�g���擾 (Z�I�[�_�[��)�i�E�B���h�E�̑O�ʏ����j
; WinGet, id, list, , , Program Manager


; �g�b�v���x���E�B���h�E�̖������J�E���g
topLevelCount := 0
; �\�ʂɌ����Ă���E�B���h�E�̖������J�E���g
visibleCount := 0
; ���ׂẴE�B���h�E�̃^�C�g����\������ϐ�
allTitles := ""

Loop % id {
    this_id := id%A_Index%
    
    ; �E�B���h�E�^�C�g�����擾���C�ςȂ������
    WinGetTitle, title, ahk_id %this_id%
    if (title = "" or title = "PopupHost" or title = "Program Manager" or InStr(title,"OCRMODE", CaseSensitive=ture) or InStr(title,"MainWnd", CaseSensitive=ture) or InStr(title,"PfuSsMon", CaseSensitive=ture)) {
        continue
    }
    
    ; �^�C�g�������X�g�ɒǉ�
    allTitles .= "Window ID: " this_id "`nTitle: " title "`n`n"
    
    topLevelCount++

    ; �����ő�������s
    ; topLevelCount�����ȉ��̏ꍇ�́A�E�B���h�E���A�N�e�B�u�ɂ���
    ; if (topLevelCount <= 6) {
    ;     WinActivate, ahk_id %this_id%
    ;     ; WinGetTitle, title, ahk_id %this_id%
    ;     WinGetTitle, title, A ; �^�C�g�����擾�iA���Ȃ�̈Ӗ��Ȃ̂��͂킩��Ȃ��j
    ;     MsgBox, % "Window ID: " this_id "`nTitle: " title
    ; }

}

; �g�b�v���x���E�B���h�E�̖�����\��
MsgBox, �J���Ă���g�b�v���x���E�B���h�E�̖����� %topLevelCount% �ł��B
; �\�ʂɌ����Ă���E�B���h�E�̖�����\��
MsgBox, �\�ʂɌ����Ă���E�B���h�E�̖����� %visibleCount% �ł��B
; ���ׂẴE�B���h�E�̃^�C�g����\��
MsgBox, % allTitles

return