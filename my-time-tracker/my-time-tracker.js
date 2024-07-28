/**
 * my-time-trackerのGAS
 * この内容をスプレッドシートの拡張機能Apps Script上に配置する
 * 
 * AHKからのリクエストを受け取り，スプレッドシートに記録する
 * 
 * デプロイ設定
 * 種類：ウェブアプリ，実行可能APIの2つを選択
 * 次のユーザーとして実行：自分
 * アクセスできるユーザー：全員
 * 
 * 注意
 * ・最初の1回は自分で実行して，権限の承認をしないといけないかも
 **/

function debug() {
  mainProcess("テスト");
}

function doGet(e) {
  return mainProcess(e.parameter.param);
}

function mainProcess(param) {
  // スプレッドシートのIDとシート名を指定
  // var spreadsheetId = 'YOUR_SPREADSHEET_ID';
  // var sheetName = 'Sheet1';
  
  // スプレッドシートにアクセス
  // var sheet = SpreadsheetApp.openById(spreadsheetId).getSheetByName(sheetName);
  const sheet = SpreadsheetApp.getActiveSheet();

  Logger.log(param);

  // 新しい行にデータを追加
  sheet.appendRow([new Date(), param]);
  sheet.getRange("A:A").setNumberFormat("yyyy/mm/dd(ddd) hh:mm");
  // sheet.getRange(1, 1).setValue(param);
  
  return ContentService.createTextOutput("Received parameter: " + param);
}
