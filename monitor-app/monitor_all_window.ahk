; �E�B���h�E���X�g���擾 (Z�I�[�_�[��)�i�E�B���h�E�̑O�ʏ����j
WinGet, id, list
; WinGet, id, list, , , Program Manager



; �g�b�v���x���E�B���h�E�̖������J�E���g
topLevelCount := 0
; �\�ʂɌ����Ă���E�B���h�E�̖������J�E���g
visibleCount := 0

Loop % id {
    this_id := id%A_Index%
    
    ; �E�B���h�E���g�b�v���x�����ǂ������m�F
    WinGet, Style, Style, ahk_id %this_id%
    if (Style & 0x40000)  ; WS_CHILD ���Z�b�g����Ă��Ȃ��ꍇ�A�g�b�v���x���E�B���h�E
    {
        continue
    }
    
    ; VSCode�E�B���h�E���t�B���^�����O
    WinGetClass, class, ahk_id %this_id%
    if (class = "Chrome_WidgetWin_1") {
        ; VSCode�̃^�C�g�����擾���ăJ�E���g
        WinGetTitle, title, ahk_id %this_id%
        if InStr(title, "Visual Studio Code") {
            continue
        }
    }
    
    topLevelCount++

    ; �����ő�������s
    ; topLevelCount�����ȉ��̏ꍇ�́A�E�B���h�E���A�N�e�B�u�ɂ���
    ; if (topLevelCount <= 2) {
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


; ; �E�B���h�E�̐���\��
; MsgBox, % "Number of windows: " id



; ; �E�B���h�E���X�g���t���ɏ���
; Loop % id {
;     ; �E�B���h�EID���擾
;     this_id := id%A_Index%
    
;     ; �E�B���h�E�^�C�g�����擾
;     ; WinGetTitle, title, ahk_id %this_id%
;     ; WinActivate, ahk_id %this_id%
    
;     ; �E�B���h�E�^�C�g����\���i�f�o�b�O�p�j
;     ; MsgBox, % "Window ID: " this_id "`nTitle: " title
    
;     ; �E�B���h�E�����݂��邩�m�F
;     ; if WinExist("ahk_id " this_id) {
;     ;     ; �E�B���h�E���A�N�e�B�u�ɂ���
;     ;     WinActivate, ahk_id %this_id%
;     ; }
; }