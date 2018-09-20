/**
 *@providesModule SCCacheHelper
 *
 * Created by flyye on 2017/10/17.
 */

import NativeModules from 'NativeModules';
var CommonCacheHelper = NativeModules.CommonCacheHelper;
var Platform = require('Platform');
const CACHE_OVERTIME = 'CACHE_OVERTIME';
const CACHE_UNDEFINED = 'CACHE_UNDEFINED';
var SCCacheHelper = {
  setCache: function(userId, key, value) {
    CommonCacheHelper.setCache(userId, key, value);
  },
  getCache: function(userId, key) {

    return CommonCacheHelper.getCache(userId, key);

  },
  getCacheAndTime: function(userId, key) {
    if (Platform.OS === 'android') {
      return CommonCacheHelper.getCacheAndTime(userId, key);
    }
  },
  getCacheAsync: function(userId, key) {
    return new Promise((resolve, reject) => {
      CommonCacheHelper.getCacheAsync(userId, key).then(result => {
        if (!result) {
          reject({code: CACHE_UNDEFINED, value: undefined});
          return;
        }
        resolve(result);
      });
    });
  }
}
module.exports = SCCacheHelper;
