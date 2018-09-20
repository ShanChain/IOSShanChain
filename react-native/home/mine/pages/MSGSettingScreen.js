/**
 * Created by flyye on 22/9/27.
 *@providesModule MSGSettingScreen
 */

'use strict';

import React, {Component} from 'react';
import {StyleSheet, Text, View, Switch, TouchableWithoutFeedback} from 'react-native';

import {StackNavigator} from 'react-navigation';
var ImageBuilder = require('CommonImageBuilder');
var CommonHeaderView = require('CommonHeaderView');
var Dimensions = require('Dimensions');
var {
  width,
  height,
  scale,
  fontScale
} = Dimensions.get('window');
var screenScale = width / 375;
var SCNavigator = require('SCNavigator');
var SCNavigator = require('SCNavigator');
var SCPropUtils = require('SCPropUtils')
var SCCacheHelper = require('SCCacheHelper');
var SCNetwork = require('SCNetwork');
var CommonUrlMap = require('CommonUrlMap');
import {PullList} from 'react-native-pull';
var SCDateUtils = require('SCDateUtils');

class MsgSettting extends Component {
  constructor(props) {
    super(props);
    let fromData = SCPropUtils.getPropsFromNative(props);
    this.state = {
      gData: fromData.gData,
      msgStatus: typeof(isMsgReceive) !== 'undefined' && isMsgReceive === 'false'
        ? false
        : true
    };

  }

  componentWillMount() {
    SCCacheHelper.getCacheAsync(this.state.gData.userId, 'isMsgReceive').then((result) => {
      this.setState({
        msgStatus: typeof(result) !== 'undefined' && result === 'false'
          ? false
          : true
      });
    });
  }
  render() {

    return (<View style={styles.container}>
      <View style={styles.girdLine}></View>
      <View style={styles.itemContainer}>
        <Text style={styles.itemText}>推送消息</Text>
        <View style={{
            flex: 1
          }}></View>
        <Switch value={this.state.msgStatus} onTintColor='#3BBAC8' onValueChange={(value) => {
            if (value) {
              SCCacheHelper.setCache(this.state.gData.userId, 'isMsgReceive', 'true');
            } else {
              SCCacheHelper.setCache(this.state.gData.userId, 'isMsgReceive', 'false');
            }
            this.setState({msgStatus: value});
          }}/>
      </View>
    </View>);
  }
}

const MSGSettingScreen = StackNavigator({
  MsgSettting: {
    screen: MsgSettting,
    navigationOptions: {
      header: ({navigation}) => {
        return (<CommonHeaderView goBack={() => SCNavigator.pop()} isShowBack={true} navigation={navigation} title={'消息设置'}></CommonHeaderView>)
      }
    }
  }
}, {initialRouteName: 'MsgSettting'});

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
  }
});
module.exports = MSGSettingScreen;
