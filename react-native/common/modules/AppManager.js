/**
 * Created by flyye on 2017/11/07.
 *
 * @providesModule AppManager
 */
var Platform = require('Platform');
var AppManagerModule = require('NativeModules').AppManagerModule;

function switchRole(options) {
  return new Promise((resolve, reject) => {
    if (Platform.OS === 'android') {
      AppManagerModule.switchRole(options || {});
    } else {
      AppManagerModule.switchRole(options || {});
    }
  });
}

function clearCache() {
  return new Promise((resolve, reject) => {
      AppManagerModule.clearCache();
  });
}
function bindOtherAccount(userType) {
    AppManagerModule.bindOtherAccount(userType);
}

module.exports = {
  switchRole,
  clearCache,
  bindOtherAccount
};
