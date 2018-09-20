/**
 * Created by flyye on 22/9/25.
 * @providesModule SettingScreen
 */

'use strict';

import React, {Component} from 'react';
import {
  StyleSheet,
  Text,
  View,
  Image,
  ScrollView,
  TouchableWithoutFeedback,
  Button
} from 'react-native';

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
var CommonHeaderView = require('CommonHeaderView');
var SCAlertDialog = require('SCAlertDialog');
var SCBottomAlertDialog = require('NativeModules').SCBottomAlertDialog;
var SCNavigator = require('SCNavigator');
var SCPropUtils = require('SCPropUtils')
var SCCacheHelper = require('SCCacheHelper');
var AppManager = require('AppManager');
class Setting extends Component {

  constructor(props) {
    super(props);
    let fromData = SCPropUtils.getPropsFromNative(props);
    this.state = {
      gData: typeof(fromData.gData) === 'undefined'
        ? ''
        : fromData.gData
    };
  }

  render() {
    return (<View style={styles.container}>
      <View style={styles.girdLine}></View>
      <TouchableWithoutFeedback onPress={() => {
          SCNavigator.pushRNPage('MSGSettingScreen', JSON.stringify({gData: this.state.gData}))
        }
}>
        <View style={styles.itemContainer}>
          <Text style={styles.itemText}>消息设置</Text>
          <View style={{
              flex: 1
            }}></View>
          <Image style={styles.itemImg} source={ImageBuilder.getImage('common_right_arrow')}/>
        </View>
      </TouchableWithoutFeedback>
      <View style={styles.girdLine}></View>
      <TouchableWithoutFeedback onPress={() => SCNavigator.pushRNPage('SecurityScreen', JSON.stringify({gData: this.state.gData}))}>
        <View style={styles.itemContainer}>
          <Text style={styles.itemText}>账号与安全</Text>
          <View style={{
              flex: 1
            }}></View>
          <Image style={styles.itemImg} source={ImageBuilder.getImage('common_right_arrow')}/>
        </View>
      </TouchableWithoutFeedback>
      <View style={styles.girdLine}></View>
      {/* <TouchableWithoutFeedback
        onPress={() => this.props.navigation.navigate('RefuseUserSettting', {})}
        >
      <View style={styles.itemContainer}>
        <Text style={styles.itemText}>已屏蔽的人</Text>
          <View style={{flex:1}}></View>
        <Image style={styles.itemImg} source={ImageBuilder.getImage('common_right_arrow')} />
      </View>
    </TouchableWithoutFeedback>
      <View style={styles.girdLine}></View> */
      }
      <TouchableWithoutFeedback onPress={this._CacheClearPress}>
        <View style={styles.itemContainer}>
          <Text style={styles.itemText}>缓存清理</Text>
          <View style={{
              flex: 1
            }}></View>
        </View>
      </TouchableWithoutFeedback>
      <View style={styles.girdLine}></View>
      <TouchableWithoutFeedback onPress={() => SCNavigator.pushRNPage('FeedbackScreen', JSON.stringify({gData: this.state.gData}))}>
        <View style={styles.itemContainer}>
          <Text style={styles.itemText}>意见反馈</Text>
          <View style={{
              flex: 1
            }}></View>
          <Image style={styles.itemImg} source={ImageBuilder.getImage('common_right_arrow')}/>
        </View>
      </TouchableWithoutFeedback>
      <View style={styles.girdLine}></View>
      <TouchableWithoutFeedback onPress={() => {
          SCNavigator.logout();
        }}>
        <View style={styles.exitBtn}>
          <Text style={styles.exitText}>退出当前账号</Text>
        </View>
      </TouchableWithoutFeedback>

    </View>);
  }

  _CacheClearPress() {
    var options = {
      type: '1',
      title: '清除缓存',
      msg: '确定要清除缓存吗？'
    }
    SCAlertDialog.show(options, () => {
      AppManager.clearCache();
    }, () => {});
  }
}

const SettingScreen = StackNavigator({
  Setting: {
    screen: Setting,
    navigationOptions: {
      header: ({navigation}) => {
        return (<CommonHeaderView goBack={() => SCNavigator.pop()} isShowBack={true} navigation={navigation} title={'设置'}></CommonHeaderView>)
      }
    }
  },
  MsgSettting: {
    screen: require('./MSGSettingScreen'),
    navigationOptions: {
      header: ({navigation}) => {
        return (<CommonHeaderView isShowBack={true} navigation={navigation} title={'消息设置'}></CommonHeaderView>)
      }
    }
  },
  RefuseUserSettting: {
    screen: require('./RefuseUserScreen'),
    navigationOptions: {
      header: ({navigation}) => {
        return (<CommonHeaderView isShowBack={true} navigation={navigation} title={'我屏蔽的人'}></CommonHeaderView>)
      }
    }
  }
}, {initialRouteName: 'Setting'});

const styles = StyleSheet.create({
  container: {
    flexDirection: 'column',
    flex: 1,
    backgroundColor: '#FFFFFF',
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
  itemImg: {
    width: 6 * screenScale,
    height: 12 * screenScale,
    marginRight: 15 * screenScale
  },
  girdLine: {
    height: 1,
    width: 375 * screenScale,
    backgroundColor: '#EEEEEE'
  },
  exitBtn: {
    width: 345 * screenScale,
    height: 40 * screenScale,
    marginTop: 34 * screenScale,
    backgroundColor: '#1D6FA3',
    borderRadius: 8 * screenScale,
    alignItems: 'center',
    justifyContent: 'center'
  },
  exitText: {
    fontSize: 14 * fontScale,
    color: '#FFFFFF'
  },
  headerContainer: {
    width: 375 * screenScale,
    height: 40 * screenScale,
    flexDirection: 'row',
    backgroundColor: '#FFFFFF',
    justifyContent: 'center',
    alignItems: 'center'
  },
  headerText: {
    fontSize: 18 * fontScale,
    color: '#666666'
  },
  headerBack: {
    position: 'absolute',
    width: 10 * screenScale,
    height: 20 * screenScale,
    left: 15 * screenScale
  }
});
module.exports = SettingScreen;
