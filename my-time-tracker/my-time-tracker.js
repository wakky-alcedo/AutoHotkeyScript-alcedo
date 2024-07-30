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

/**
 * デバッグ用
 * @param {string} param
 **/
function debug() {
  Logger.log(mainProcess("テスト"));
}

/**
 * doGet
 * @param {Object} e
 * @return {Object}
 **/
function doGet(e) {
  return mainProcess(e.parameter.param);
}

/**
 * mainProcess
 * @param {string} param
 **/
function mainProcess(param) {  
  // スプレッドシートにアクセス
  const spreadsheet = SpreadsheetApp.getActiveSpreadsheet();
  const rawSheet = spreadsheet.getSheetByName('RawSheet');
  const organizedSheet = spreadsheet.getSheetByName('OrganizedSheat');

  // RawSheet
  // 新しい行にデータを追加
  rawSheet.appendRow([new Date(), param]);
  rawSheet.getRange("A:A").setNumberFormat("yyyy/mm/dd(ddd) hh:mm");

  // OrganizedSheet
  // 今日の日付がシート上になかったら，30分おきの1日分の時間を追加
  // 今の時間が入る行に内容を追加

  return ContentService.createTextOutput("Received parameter: " + param);
}
