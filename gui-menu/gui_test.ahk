#Requires AutoHotkey v2.0

; 円形メニューの設定
radius := 100  ; 円の半径
centerX := 200  ; GUIの中心座標X
centerY := 200  ; GUIの中心座標Y
buttonCount := 8  ; ボタンの数
buttons := ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight"]

; GUI作成
circleGui := Gui()
; circleGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20") ; 透明ウィンドウ
circleGui.SetFont("s12", "Arial")
circleGui.MarginX := circleGui.MarginY := 0
circleGui.Width := circleGui.Height := centerX * 2
circleGui.BackColor := "White"
; circleGui.WinSetTransColor  := "EEAA99 100"
WinSetTransColor("White", circleGui)
circleGui.Opt("-Caption")


; ボタン配置
Loop buttonCount {
    angle := (A_Index - 1) * (360 / buttonCount)
    x := centerX + radius * Cos(angle * (3.14 / 180)) - 40  ; ボタンの幅補正
    y := centerY - radius * Sin(angle * (3.14 / 180)) - 15  ; ボタンの高さ補正
    ; circleGui.Add("Button", "w80 h30", buttons[A_Index]).Move(x, y)
    ; 正方形のボタンを表示
    btn := circleGui.Add("Button", "w80 h80", buttons[A_Index])
    btn.Move(x, y)
    btn.Opt("+Border")  ; ボタンのスタイル設定
    btn.OnEvent("Click", (*) => MsgBox("You clicked: " . buttons[A_Index]))
    
}

; GUI表示
circleGui.Show("w400 h400 Center")

; ボタンのアクション
circleGui.OnEvent("Close", (*) => ExitApp())

; circleGui.OnEvent("ButtonClick", (btn, *) => {
;     MsgBox("You clicked: " . btn.Text)
; })

; circleGui.OnEvent("ButtonClick", Button1)

; Button1(*) { ; ☓を押したときに実行
;     ; MyGui.Submit()
;     ; MyGuiが存在するか確認し、存在する場合は破棄
;     MsgBox("You clicked: ") ; . btn.Text)
; }