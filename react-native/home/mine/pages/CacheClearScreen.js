/**
 * Created by flyye on 22/9/27.
 */

'use strict';

import React, {Component} from 'react';
import {StyleSheet, Text, View, Switch, TouchableWithoutFeedback} from 'react-native';

import {StackNavigator} from 'react-navigation';
var ImageBuilder = require('CommonImageBuilder');
var Dimensions = require('Dimensions');
var {
  width,
  height,
  scale,
  fontScale
} = Dimensions.get('window');
var screenScale = width / 375;
var SCNavigator = require('SCNavigator');

class CacheClearScreen extends Component {

  render() {

    return (<View style={styles.container}>
      <View style={styles.girdLine}></View>
      <View style={styles.itemContainer}>
        <Text style={styles.itemText}>推送消息</Text>
        <View style={{
            flex: 1
          }}></View>
        <Switch value={true} style={styles.switchBtn}/>
      </View>
    </View>);
  }
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'column',
    flex: 1,
    backgroundColor: '#EEEEEE',
    alignItems: 'center'
  },
  itemContainer: {
    height: 60 * screenScale,
    flexDirection: 'row',
    backgroundColor: '#FFFFFF',
    alignItems: 'center'
  },
  itemText: {
    fontSize: 14 * fontScale,
    color: '#666666',
    marginLeft: 15 * screenScale
  },
  girdLine: {
    height: 1,
    width: 375 * screenScale,
    backgroundColor: '#EEEEEE'
  },
  switchBtn: {}

});
module.exports = CacheClearScreen;
