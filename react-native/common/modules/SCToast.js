/**
 *@providesModule SCToast
 *
 * Created by flyye on 2017/11/22.
 */

var React = require('react');

import NativeModules from 'NativeModules';
var Platform = require('Platform');
var SCToast = NativeModules.SCToast;
var SCAlertMention = require('NativeModules').SCAlertMention;


function show(msg) {
  if (Platform.OS === 'android') {
    SCToast.show(msg);
  }else{
    SCAlertMention.showMessage(msg);
  }
}
module.exports = {
  show
};
