/**
 * Created by flyye on 22/9/28.
* @providesModule AboutMeScreen
 */

'use strict';

import React, {Component} from 'react';
import {
  StyleSheet,
  Text,
  View,
  Switch,
  TouchableWithoutFeedback,
  Image
} from 'react-native';

import {StackNavigator} from 'react-navigation';
var BirthdayPicker = require('NativeModules').BirthdayPicker;
var SCBottomAlertDialog = require('SCBottomAlertDialog');
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
var SCNavigator = require('SCNavigator');
var SCPropUtils = require('SCPropUtils');
var SCNetwork = require('SCNetwork');
var CommonUrlMap = require('CommonUrlMap');
var SCDatePicker = require('SCDatePicker');

class AboutMe extends Component {
  constructor(props) {
    super(props);
    let fromData = SCPropUtils.getPropsFromNative(props);
    this.state = {
      gData: typeof(fromData.gData) === 'undefined'
        ? ''
        : fromData.gData,
      data: typeof(fromData.data) === 'undefined'
        ? ''
        : fromData.data
    };
  }

  componentWillMount() {
    let gData = this.state.gData;
    this.refreshData(gData);
  }

  refreshData(gData) {
    SCNetwork.post(CommonUrlMap.USERINFO_GET_BY_ID, {
      userId: this.state.gData.userId,
      token: this.state.gData.token
    }).then(result => {
      this.setState({data: result.data});

    }).catch(err => {});
  }

  render() {

    return (<View style={styles.container}>
      <View style={styles.girdLine}></View>
      <TouchableWithoutFeedback onPress={() => {
          SCBottomAlertDialog.show({0: '男', 1: '女', 2: '保密', 3: '取消'}).then((key) => {
            let sex;
            if (key == 0) {
              sex = 0;
            } else if (key == 1) {
              sex = 1;
            } else {
              sex = 2;
            }
            SCNetwork.post(CommonUrlMap.CHANGE_USER_INFO, {
              userId: this.state.gData.userId,
              token: this.state.gData.token,
              dataString: JSON.stringify({sex: sex})
            }).then(result => {
              this.setState({data: result.data})
            }).catch(err => {});
          }).catch((err) => {});
        }}>
        <View style={styles.itemContainer}>
          <View>
            <Text style={styles.leftTitle}>性别</Text>
          </View>
          <View style={{
              flex: 1
            }}></View>
          <Text style={styles.rightText}>{
              typeof(this.state.data.sex) === 'undefined' || this.state.data.sex === 2 || this.state.data.sex === ''
                ? '保密'
                : this.state.data.sex === 0
                  ? '男'
                  : '女'
            }</Text>
          <Image style={styles.rightBtn} source={ImageBuilder.getImage('common_right_arrow')}/>
        </View>

      </TouchableWithoutFeedback>
      <View style={styles.girdLine}></View>
      <TouchableWithoutFeedback onPress={() => {
          SCDatePicker.show().then((result) => {
            SCNetwork.post(CommonUrlMap.CHANGE_USER_INFO, {
              userId: this.state.gData.userId,
              token: this.state.gData.token,
              dataString: JSON.stringify({birthday: result})
            }).then(result => {
              this.setState({data: result.data})
            }).catch(err => {});
          }).catch((err) => {
          });
        }}>
        <View style={styles.itemContainer}>
          <View>
            <Text style={styles.leftTitle}>生日</Text>
          </View>
          <View style={{
              flex: 1
            }}></View>
          <Text style={styles.rightText}>{
              typeof(this.state.data.birthday) === 'undefined' || this.state.data.birthday == ''
                ? '保密'
                : this.state.data.birthday
            }</Text>
          <Image style={styles.rightBtn} source={ImageBuilder.getImage('common_right_arrow')}/>
        </View>
      </TouchableWithoutFeedback>

    </View>);
  }
}

const AboutMeScreen = StackNavigator({
  AboutMe: {
    screen: AboutMe,
    navigationOptions: {
      header: ({navigation}) => {
        return (<CommonHeaderView goBack={() => SCNavigator.pop()} isShowBack={true} navigation={navigation} title={'我的资料'}></CommonHeaderView>)
      }
    }
  }
}, {initialRouteName: 'AboutMe'});

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
  leftTitle: {
    fontSize: 14 * fontScale,
    color: '#666666',
    marginLeft: 15 * screenScale
  },
  leftDetail: {
    fontSize: 12 * fontScale,
    color: '#B3B3B3',
    marginLeft: 15 * screenScale
  },
  rightText: {
    fontSize: 14 * fontScale,
    color: '#B3B3B3',
    marginRight: 10 * screenScale
  },
  girdLine: {
    height: 1,
    width: 375 * screenScale,
    backgroundColor: '#EEEEEE'
  },
  rightBtn: {
    width: 6 * screenScale,
    height: 12 * screenScale,
    marginRight: 15 * screenScale
  }

});
module.exports = AboutMeScreen;
