#Requires AutoHotkey v2.0

; グローバル変数
overlayGuis := []
buttonGui := ""
isPressed := false
maskHeight := 0
debugTimer := ""
DEBUG_MODE := false  ; デバッグフラグ（true: デバッグ有効, false: デバッグ無効）

; デバッグ情報表示関数
DebugLog(message) {
    global DEBUG_MODE
    if (DEBUG_MODE) {
        ; デバッグメッセージをツールチップで表示
        ToolTip("[DEBUG] " . message, 10, 10)
        SetTimer(() => ToolTip(), -2000)  ; 2秒後に自動で消去
    }
}

Overlay() {
    global overlayGuis, buttonGui, debugTimer, DEBUG_MODE
    DebugLog("Overlay開始 - モニター数: " . SysGet(80))
    MonitorCount := SysGet(80) ; SM_CMONITORS
    
    ; 各モニターにオーバーレイを作成
    Loop MonitorCount
    {
        MonitorLeft := 0
        MonitorTop := 0
        MonitorRight := 0
        MonitorBottom := 0
        MonitorGet(A_Index, &MonitorLeft, &MonitorTop, &MonitorRight, &MonitorBottom)
        MonitorWidth := MonitorRight - MonitorLeft
        MonitorHeight := MonitorBottom - MonitorTop
        
        ; オーバーレイGUIを作成（AlwaysOnTopを削除してボタンより下に配置）
        overlayGui := Gui("+AlwaysOnTop +ToolWindow -Caption", "Overlay" . A_Index)
        overlayGui.BackColor := "0x354e94"
        
        ; 透明なテキストコントロールを全面に配置してクリックイベントを捕捉
        overlayText := overlayGui.Add("Text", "x0 y0 w" . MonitorWidth . " h" . MonitorHeight . " Background" . overlayGui.BackColor)
        overlayText.OnEvent("Click", OnOverlayClick)
        
        overlayGui.Show("x" . MonitorLeft . " y" . MonitorTop . " w" . MonitorWidth . " h" . MonitorHeight)
        WinSetTransparent(200, overlayGui.Hwnd)
        
        overlayGuis.Push(overlayGui)

        ; WinSetAlwaysOnTop(true, overlayGui.Hwnd) ; オーバーレイはボタンより下に配置
    }
    
    ; オーバーレイの後にボタンを作成（確実に最前面に表示）
    CreateCenterButton()
    DebugLog("ボタン作成完了")
    
    ; デバッグ用：20秒後に自動終了
    if (DEBUG_MODE) {
        debugTimer := SetTimer(AutoClose, 20000)
        DebugLog("デバッグタイマー開始: 20秒後に自動終了")
    }
}

; 中央ボタンを作成
CreateCenterButton() {
    global buttonGui
    
    ; プライマリモニターの情報を取得
    MonitorGet(1, &MonitorLeft, &MonitorTop, &MonitorRight, &MonitorBottom)
    MonitorWidth := MonitorRight - MonitorLeft
    MonitorHeight := MonitorBottom - MonitorTop
    
    ; ボタンのサイズと位置
    buttonSize := 120
    buttonX := MonitorLeft + (MonitorWidth - buttonSize) // 2
    buttonY := MonitorTop + (MonitorHeight - buttonSize) // 2
    
    ; ボタン用GUIを作成（より高いZ-orderで作成）
    buttonGui := Gui("+AlwaysOnTop +ToolWindow -Caption +LastFound", "Button")
    buttonGui.BackColor := "0x1a1a1a"
    
    ; 円形ボタンを作成（テキストで代用）
    button := buttonGui.Add("Text", "x10 y10 w100 h100 Center VCenter Border cWhite Background0x444444", "HOLD")
    button.SetFont("s16 Bold", "Arial")
    
    ; ボタンイベントを設定
    button.OnEvent("Click", OnButtonPress)
    
    buttonGui.Show("x" . buttonX . " y" . buttonY . " w" . buttonSize . " h" . buttonSize)
    WinSetTransparent(220, buttonGui.Hwnd)
}

; オーバーレイがクリックされた時の処理（PCスリープ）
OnOverlayClick(*) {
    DebugLog("オーバーレイがクリックされました - PCをスリープ状態にします")
    
    ; 確認ダイアログを表示（デバッグモード時のみ）
    if (DEBUG_MODE) {
        result := MsgBox("PCをスリープ状態にしますか？", "スリープ確認", "YesNo Icon?")
        if (result == "No") {
            DebugLog("スリープがキャンセルされました")
            return
        }
    }

    ; ExitAPPのためのタイマーを設定
    SetTimer(ExitAppFunc, -1000)  ; 1秒後にExitAppFuncを呼び出す
    
    ; PCをスリープ状態にする
    DebugLog("PCをスリープ状態にします")
    DllCall("PowrProf.dll\SetSuspendState", "Int", 0, "Int", 0, "Int", 0)
}

ExitAppFunc() {
    ExitApp
}

; ボタンが押された時の処理
OnButtonPress(*) {
    global isPressed
    DebugLog("ボタンが押されました")
    if (!isPressed) { ; ボタンがまだ押されていない状態で押された時
        isPressed := true
        DebugLog("アニメーション開始")
        StartMaskAnimation()
    }
}



; マスクアニメーション開始
StartMaskAnimation() {
    SetTimer(AnimateMask, 50)
}

; マスクアニメーション
AnimateMask() {
    global overlayGuis, maskHeight, isPressed
    
    ; ボタンが離されている場合はアニメーション停止
    ; if (!isPressed) {
    if (!GetKeyState("LButton", "P")) {
        DebugLog("ボタンが離されました - アニメーション停止")
        SetTimer(AnimateMask, 0)  ; タイマーを停止
        ResetMask()
        isPressed := false  ; ボタンの押下状態をリセット
        return
    }
    
    ; プライマリモニターの高さを取得
    MonitorGet(1, , , , &MonitorBottom)  ; 下端座標を取得
    MonitorGet(1, , &MonitorTop, , )     ; 上端座標を取得
    MonitorHeight := MonitorBottom - MonitorTop  ; モニター高さを計算
    
    ; マスクの高さを段階的に増加（8ピクセルずつ）
    maskHeight += 8
    
    ; デバッグ情報：進行状況
    if (DEBUG_MODE && Mod(maskHeight, 40) == 0) {  ; 5フレームごとに表示
        progress := Round((maskHeight / MonitorHeight) * 100)
        DebugLog("アニメーション進行: " . progress . "% (高さ: " . maskHeight . ")")
    }
    
    ; アニメーション完了判定
    if (maskHeight >= MonitorHeight) {
        ; アニメーション完了時の処理
        DebugLog("アニメーション完了 - 終了処理開始")
        SetTimer(AnimateMask, 0)  ; タイマーを停止
        Sleep(500) ; 少し待って視覚的効果を演出
        ClearOverlay()  ; 全てのGUIを閉じる
        ExitApp  ; アプリケーション終了
        return
    }
    
    ; 各オーバーレイの透明部分を更新
    UpdateMask()
}

; マスクを更新
UpdateMask() {
    global overlayGuis, maskHeight, buttonGui
    
    ; 各モニターのオーバーレイをループで処理
    Loop overlayGuis.Length {
        ; 現在のモニターのGUIオブジェクトを取得
        gui := overlayGuis[A_Index]
        
        ; モニター情報を取得（位置とサイズ）
        MonitorGet(A_Index, &MonitorLeft, &MonitorTop, &MonitorRight, &MonitorBottom)
        MonitorWidth := MonitorRight - MonitorLeft  ; モニター幅を計算
        MonitorHeight := MonitorBottom - MonitorTop  ; モニター高さを計算
        
        ; 透明領域を作成（下から上に向かって幕が上がる効果）
        if (maskHeight > 0) {
            ; 透明にする高さを計算（最大でもモニター高さまで）
            transparentHeight := Min(maskHeight, MonitorHeight)
            ; 残りのオーバーレイ高さを計算
            newHeight := MonitorHeight - transparentHeight
            
            ; まだ表示する部分がある場合
            if (newHeight > 0) {
                ; オーバーレイのサイズを変更（上部のみ表示）
                gui.Show("x" . MonitorLeft . " y" . MonitorTop . " w" . MonitorWidth . " h" . newHeight)
            } else {
                ; 完全に透明にする場合はGU, isPressedIを非表示
                gui.Hide()
            }
        }
    }
}

; マスクをリセット
ResetMask() {
    global overlayGuis, maskHeight, buttonGui
    
    DebugLog("マスクリセット開始")
    ; マスクの高さを0にリセット
    maskHeight := 0
    
    ; 各オーバーレイを元のサイズに戻す
    Loop overlayGuis.Length {
        ; 現在のモニターのGUIオブジェクトを取得
        gui := overlayGuis[A_Index]
        
        ; モニター情報を取得（位置とサイズ）
        MonitorGet(A_Index, &MonitorLeft, &MonitorTop, &MonitorRight, &MonitorBottom)
        MonitorWidth := MonitorRight - MonitorLeft  ; モニター幅を計算
        MonitorHeight := MonitorBottom - MonitorTop  ; モニター高さを計算
        
        ; オーバーレイを元のフルサイズで表示
        gui.Show("x" . MonitorLeft . " y" . MonitorTop . " w" . MonitorWidth . " h" . MonitorHeight)
    }
    
    ; ボタンを確実に最前面に移動（オーバーレイ復元後）
    if (buttonGui) {
        WinSetAlwaysOnTop(true, buttonGui.Hwnd)
        DebugLog("ボタンを最前面に移動")
    }

    ; isPressed := false  ; ボタンの押下状態をリセット
}

; デバッグ用：自動終了
AutoClose() {
    global debugTimer
    if (debugTimer) {
        SetTimer(debugTimer, 0)
        debugTimer := ""
    }
    ClearOverlay()
    ExitApp
}

; 終了処理の関数
ClearOverlay() {
    global overlayGuis, buttonGui, debugTimer
    
    DebugLog("終了処理開始")
    ; タイマーを停止
    if (debugTimer) {
        SetTimer(debugTimer, 0)
        DebugLog("デバッグタイマー停止")
    }
    SetTimer(AnimateMask, 0)
    DebugLog("アニメーションタイマー停止")
    
    ; すべてのGUIを閉じる
    for gui in overlayGuis {
        try {
            gui.Close()
        }
    }
    
    if (buttonGui) {
        try {
            buttonGui.Close()
        }
    }
}

; ESCキーで強制終了
Esc::ClearOverlay()

Overlay() ; 呼び出し