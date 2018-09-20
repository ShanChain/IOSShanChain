/**
 * Created by flyye on 2017/12/14.
 *
 * @providesModule SCDatePicker
 */
var Platform = require('Platform');
var BirthdayPicker = require('NativeModules').BirthdayPicker;
var SCDatePickerMdMention = require('NativeModules').SCDatePickerMdMention;

function show() {
  return new Promise((resolve, reject) => {
    if (Platform.OS === 'android') {
      BirthdayPicker.show((result) => {
        resolve(result);
      }, (err) => {
        reject(err)
      });
    } else {
      SCDatePickerMdMention.showDatePicker((result) => {
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
