; vk1C：無変換キー

; iキーと組み合わせて上矢印キー（↑）を送信
vk1D & i::Send, {Blind}{Up}

; kキーと組み合わせて下矢印キー（↓）を送信
vk1D & k::Send, {Blind}{Down}

; jキーと組み合わせて左矢印キー（←）を送信
vk1D & j::Send, {Blind}{Left}

; lキーと組み合わせて右矢印キー（→）を送信
vk1D & l::Send, {Blind}{Right}

; hキーと組み合わせてHomeキーを送信
vk1D & h::Send, {Blind}{Home}

; 「`」キー（通常はバッククォート）と組み合わせてEndキーを送信
vk1D & vkBB::Send, {Blind}{End}

; oキーと組み合わせてPage Upキーを送信
vk1D & o::Send, {Blind}{PgUp}

; pキーと組み合わせてPage Downキーを送信
vk1D & p::Send, {Blind}{PgDn}

; uキーと組み合わせて、上矢印キー（↑）を4回送信
vk1D & u::Send, {Blind}{Up 4}

; コンマ（,）キーと組み合わせて、下矢印キー（↓）を4回送信
vk1D & ,::Send, {Blind}{Down 4}

; ピリオド（.）キーと組み合わせて、右矢印キー（→）を4回送信
vk1D & .::Send, {Blind}{Right 4}

; mキーと組み合わせて、左矢印キー（←）を4回送信
vk1D & m::Send, {Blind}{Left 4}

; スペースキーと組み合わせてEnterキーを送信
vk1D & Space::Send, {Blind}{Enter}

; nキーと組み合わせてBackspaceキーを送信
vk1D & n::Send, {Blind}{Backspace}

; スラッシュ（/）キーと組み合わせてDeleteキーを送信
vk1D & /::Send,{Blind}{Delete}

; Enterキーと組み合わせて行挿入を行う
; Ctrlキーが押されている場合、上方向にカーソルを移動して行末にEnter
; 押されていない場合、カーソルを行末に移動してからEnter
vk1D & Enter::
  If (GetKeyState("Ctrl", "P")) {
    Send, {Up}{End}{Enter}
  } Else {
    Send, {End}{Enter}
  }
Return

; F2キーと組み合わせて半角英数に切り替える
vk1D & vkF2::Send, {vkF2}{vkF3}

; カスタム矢印入力
; iキーと組み合わせて上矢印（↑）を入力
vk1D & Up::Send, {vkF2}{vkF3}↑{vkF2}

; kキーと組み合わせて下矢印（↓）を入力
vk1D & Down::Send, {vkF2}{vkF3}↓{vkF2}

; jキーと組み合わせて左矢印（←）を入力
vk1D & Left::Send, {vkF2}{vkF3}←{vkF2}

; lキーと組み合わせて右矢印（→）を入力
vk1D & Right::Send, {vkF2}{vkF3}→{vkF2}
