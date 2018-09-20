/**
 * Created by flyye on 2017/11/06.
 *
 * @providesModule SCInputAlertDialog
 */
var Platform = require('Platform');
var SCInputAlertDialog = require('NativeModules').SCInputAlertDialog;
var SCAlertMention = require('NativeModules').SCAlertMention;

function show(options) {
  return new Promise((resolve, reject) => {
    if (Platform.OS === 'android') {
      SCInputAlertDialog.show(options || {}, (result) => {
        resolve(result);
      }, (err) => {
        reject(err)
      });
    } else {
      SCAlertMention.showInputDialog(options || {}, (result) => {
        resolve(result);
      }, (err) => {
        reject(err)
      });
    }

  });
}

module.exports = {
  show
};
