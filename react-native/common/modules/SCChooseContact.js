/**
 * Created by flyye on 2017/12/16.
 *
 * @providesModule SCChooseContact
 */
var Platform = require('Platform');
var SCPageNavigator = require('NativeModules').SCPageNavigator;

function choose() {
  return new Promise((resolve, reject) => {
    if (Platform.OS === 'android') {

    } else {
      SCPageNavigator.chooseContact((result) => {
        resolve(result);
      }, (err) => {
        reject(err)
      });
    }

  });
}

module.exports = {
  choose
};
