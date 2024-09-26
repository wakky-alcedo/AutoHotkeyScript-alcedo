#Include .env.local.ahk
; MsgBox %DEPLOY_ID%
url := "https://script.google.com/macros/s/" . DEPLOY_ID . "/exec"
QUERY := "param=Hello%20World"
request := url . "?" . QUERY
; MsgBox, %request%
HttpObj := ComObjCreate("WinHttp.WinHttpRequest.5.1")
; HttpObj := ComObjCreate("MSXML2.XMLHTTP")
HttpObj.open("GET", request, false)
HttpObj.send()
HttpObj.WaitForResponse()

Status := HttpObj.Status ; なんか一時的に別の変数に入れないとMsgBoxで表示されない
; MsgBox, %Status%

if (Status == 200)
{
    ResponseText := HttpObj.ResponseText
    MsgBox, %ResponseText%
}
else
{
    MsgBox, Failed to send request. Status: %Status%
}
