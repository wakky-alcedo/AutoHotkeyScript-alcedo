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
 * ・更新したらデプロイし直さないといけない
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
  const today = new Date(); 
  const todayStr = Utilities.formatDate(today, "Asia/Tokyo", 'yyyy/MM/dd(E)');
  // console.log(todayStr);
  const todayRow = organizedSheet.createTextFinder(todayStr).findAll();
  if (todayRow == "") {
    const startTime = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 0, 0, 0);
    const endTime = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 0, 30, 0);
    const endTimeDate = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 23, 59, 59);
    organizedSheet.appendRow([todayStr, startTime, endTime,""]);
    startTime.setMinutes(startTime.getMinutes() + 30);
    endTime.setMinutes(endTime.getMinutes() + 30);
    while (startTime <= endTimeDate) {
      organizedSheet.appendRow(["", startTime, endTime,""]);
      startTime.setMinutes(startTime.getMinutes() + 30);
      endTime.setMinutes(endTime.getMinutes() + 30);
    }
    organizedSheet.getRange("A:A").setNumberFormat("yyyy/mm/dd(ddd)");
    organizedSheet.getRange("B:B").setNumberFormat("HH:mm");
    organizedSheet.getRange("C:C").setNumberFormat("HH:mm");
  }

  // 今の時間を，所定の範囲の保存
  const time = new Date();
  const range = organizedSheet.getRange("B:B");
  const values = range.getValues();

  var ultimate_param

  for (let i = values.length-1; 0 <= i; i--) {
    if (values[i] == "") {
      continue;
    }
    // const cell_time = Utilities.parseDate(values[i]);
    // console.log(values[i][0]);
    if (values[i][0] < time) {
      // その列のC列にparamを記録
      const cell = organizedSheet.getRange(i+1, 4);
      const cellValue = cell.getValue();
      if (cellValue == "") {
        ultimate_param = param
        cell.setValue(param);
      } else {
        ultimate_param = cellValue + ", " + param
        cell.setValue(ultimate_param);
      }
      break;
    }
  }

  return ContentService.createTextOutput("Received parameter: " + param);
}
