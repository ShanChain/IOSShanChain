/**
 *@providesModule SCPhotoPicker
 *
 * Created by flyye on 2017/11/02.
 */
var PhotoPicker = require('NativeModules').PhotoPicker;

function selectPhoto() {
  return new Promise((resolve, reject) => {
    PhotoPicker.selectPhoto((result) => {
      resolve(result);
    }, (err) => {
      reject(err)
    });
  });
}

module.exports = {
  selectPhoto
};
