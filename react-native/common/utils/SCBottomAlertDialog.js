/**
 * Created by flyye on 2017/10/23.
 *
 * @providesModule SCBottomAlertDialog
 */
var Platform = require('Platform');
var SCBottomAlertDialog = require('NativeModules').SCBottomAlertDialog;
var SCAlertMention = require('NativeModules').SCAlertMention;

function show(options) {
  return new Promise((resolve, reject) => {
    if (Platform.OS === 'android') {
      SCBottomAlertDialog.show(options || {}, (result) => {
        resolve(result);
      }, (err) => {
        reject(err)
      });
    } else {
      SCAlertMention.alert(options || {}, (result) => {
        resolve(result);
      }, (err) => {
        reject(err)
      });
    }

  });
}

function dismiss() {
  return new Promise((resolve, reject) => {
    if (Platform.OS === 'android') {
      SCBottomAlertDialog.dismiss();
    } else {
      SCAlertMention.cancel();
    }

  });
}

module.exports = {
  show,
  dismiss
};
