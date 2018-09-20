/**
 * Created by flyye on 2017/11/29.
 *
 * @providesModule SCAlertDialog
 */

import React, {Component} from 'react';
import {AlertIOS} from 'react-native';
var Platform = require('Platform');
var SCAlertDialog = require('NativeModules').SCAlertDialog;

function show(options, sureCallbak, cancelCallbak) {
  // return new Promise((resolve, reject) => {
  if (Platform.OS === 'android') {
    SCAlertDialog.show(options || {}, sureCallbak, cancelCallbak);
  } else {
    AlertIOS.alert(options.title, options.msg, [
      {
        text: '取消',
        onPress: () => cancelCallbak()
      }, {
        text: '确定',
        onPress: () => sureCallbak()
      }
    ])
  }
  // });
}

module.exports = {
  show
};
