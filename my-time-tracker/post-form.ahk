; #Requires AutoHotkey v2.0 なんかこれがあるとえらる

; AHK v1.1+

; フォームのアクションURL
url := "https://docs.google.com/forms/u/0/d/e/1FAIpQLSdDyFsFgmjqEOXbkCIpm6Jq_izsLb25qYX1_76iWV1lsgeA0A/formResponse"

; フィールドの名前とその値
field1 := "YPqjbf"
value1 := "122324"


; リクエストデータを作成
postData := field1 "=" value1 ; "&" field2 "=" value2

; HTTPリクエストの設定
MsgBox %postData%
; urlEncodedData := UrlEncode(postData)
urlEncodedData := postData
MsgBox %urlEncodedData%
HttpPost(url, urlEncodedData)

; MsgBox, Googleフォームに回答を送信しました。
ExitApp

; HTTP POSTリクエストを送信する関数
HttpPost(url, data) {
    ; リクエストを送信
    req := ComObjCreate("WinHttp.WinHttpRequest.5.1") ; WinHttpRequest オブジェクトを作成
    req.Open("POST", url, false) ; リクエストを初期化（POST メソッドと URL を指定）
    req.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded") ; リクエストヘッダーを設定
    req.Send(data) ; リクエストデータを送信

    ; レスポンスを取得（オプション）
    ; response := req.ResponseText
    ; MsgBox % "Response: " response
}

; URLエンコードする関数
; UrlEncode(str) {
;     VarSetCapacity(o, StrLen(str) * 3 + 1)
;     VarSetCapacity(u, StrLen(str) * 3 + 1)
;     UrlEscape(str, &o)
;     return o
; }

UrlEncode(str) {
    ; URLエンコード用の文字と対応するエンコード値
    static encode := { " " : "%20", "!" : "%21", "\" : "%22", "#" : "%23", "$" : "%24", "%" : "%25", "&" : "%26", "'" : "%27", "(" : "%28", ")" : "%29", "*" : "%2A", "+" : "%2B", "," : "%2C", "-" : "%2D", "." : "%2E", "/" : "%2F", ":" : "%3A", ";" : "%3B", "<" : "%3C", "=" : "%3D", ">" : "%3E", "?" : "%3F", "@" : "%40", "[" : "%5B", "\\" : "%5C", "]" : "%5D", "^" : "%5E", "_" : "%5F", "`" : "%60", "{" : "%7B", "|" : "%7C", "}" : "%7D", "~" : "%7E" }

    ; エンコードされた文字列を保存する変数
    encodedStr := ""

    ; 各文字を処理
    Loop, Parse, str
    {
        ; 現在の文字を取得
        char := A_LoopField
        
        ; エンコード対象かどうかを確認
        if (encode[char]) {
            ; エンコード値を追加
            encodedStr .= encode[char]
        } else {
            ; エンコード対象でない場合はそのまま追加
            encodedStr .= char
        }
    }

    return encodedStr
}

; テスト
testStr := "Hello World! $&'()*+,-./:;<=>?@[\\]^_`{|}~"
encodedStr := UrlEncode(testStr)
MsgBox % "Encoded: " encodedStr
