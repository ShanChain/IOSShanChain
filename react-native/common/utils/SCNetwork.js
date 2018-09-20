/**
 *@providesModule SCNetwork
 *
 * Created by flyye on 2017/10/17.
 */
var SCNetworkNative = require('NativeModules').SCNetwork;
var SCCacheHelper = require('SCCacheHelper');

/**
 * @method HTTP 请求
 * @param options = {
 *      path    : ''
 *      method  : ''
 *      params  : {}  }
 * @return A Promise(
 *      then
 *      catch
 *  )
 */
function fetch(options) {
  return new Promise((resolve, reject) => {
    SCNetworkNative.fetch(options || {}, (result) => {
      resolve(result);
    }, (err) => {
      reject(err)
    });
  });
}

function uploadImg(options) {
  return new Promise((resolve, reject) => {
    SCNetworkNative.uploadFile(options || {}, (result) => {
      resolve(result);
    }, (err) => {
      reject(err)
    });
  });
}

/**
 *  @method GET 请求
 *  @return @see Network.request
 */
function get(path, params) {
  return fetch({
    path: path,
    params: params || {},
    method: 'get'
  });
}

function post(path, params) {
  return fetch({
    path: path,
    params: params || {},
    method: 'post'
  });
}

function upload(path, params) {
  return fetch({
    path: path,
    params: params || {},
    method: 'upload'
  });
}

module.exports = {
  fetch,
  get,
  post,
  upload,
  uploadImg
};
