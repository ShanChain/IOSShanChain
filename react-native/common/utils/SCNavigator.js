/* *
* @providesModule SCNavigator
* */

'use strict'
// "use strict" 的目的是指定代码在严格条件下执行。严格模式下你不能使用未声明的变量。

var React = require('react');

import NativeModules from 'NativeModules';
import BackHandler from 'BackHandler';

var Platform = require('Platform');
var SCPageNavigator = NativeModules.SCPageNavigator;

var SCNavigator = {
  pushNativePage: function(pageName : string, paramsJson : string, animated = true) {
    if (typeof(paramsJson) === 'undefined') {
      paramsJson = '';
    }
    if (Platform.OS === 'android') {
      SCPageNavigator.startActivity(pageName, paramsJson);
    } else if (Platform.OS === 'ios') {
      SCPageNavigator.pushViewController(pageName, animated, paramsJson);
    }
  },

  pushRNPage: function(pageName : string, paramsJson : string, animated = true) {
    if (typeof(paramsJson) === 'undefined') {
      paramsJson = '';
    }
    if (Platform.OS === 'android') {
      SCPageNavigator.startReactPage(pageName, paramsJson);
    } else if (Platform.OS === 'ios') {
      SCPageNavigator.pushRNViewController(pageName, animated, paramsJson);
    }
  },
  pop: function(animated = true) {
    if (Platform.OS === 'android') {
      BackHandler.exitApp();
    } else if (Platform.OS === 'ios') {
      SCPageNavigator.popViewControllerAnimated(animated);
    }
  },
  logout: function(animated = true) {
    SCPageNavigator.logout();
  }
}

module.exports = SCNavigator;
