/**
 * Created by flyye on 22/9/17.
 * @providesModule FeedbackScreen
 *
 */

'use strict';

import React, {Component} from 'react';
import {
  StyleSheet,
  Text,
  View,
  Switch,
  TouchableWithoutFeedback,
  TextInput,
  Image
} from 'react-native';

import {StackNavigator} from 'react-navigation';
import Platform from 'Platform';
var isAndroid = Platform.OS === 'android';
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
var SCCacheHelper = require('SCCacheHelper');
var SCNetwork = require('SCNetwork');
var CommonUrlMap = require('CommonUrlMap')
var SCToast = require('NativeModules').SCToast;
var SCPropUtils = require('SCPropUtils')

class FeedbackScreen extends Component {

  constructor(props) {
    super(props);
    let fromData = SCPropUtils.getPropsFromNative(props);
    this.state = {
      gData: typeof(fromData.gData) === 'undefined'
        ? ''
        : fromData.gData,
      text: ''
    };
  }
  sendFeedback() {
    SCNetwork.post(CommonUrlMap.USER_FEEDBACK, {
      dataString: JSON.stringify({title: '用户反馈', disc: this.state.text, type: 1}),
      userId: this.state.gData.userId + '',
      token: this.state.gData.token
    }).then(result => {
      SCNavigator.pop()
    }).catch(err => {});
  }
  render() {

    return (<View style={styles.container}>
      <View style={styles.headerContainer}>
        <TouchableWithoutFeedback onPress={() => {
            SCNavigator.pop()
          }}>
          <View style={{
              position: 'absolute',
              left: 0,
              height: 40 * screenScale,
              width: 50 * screenScale,
              justifyContent: 'center'
            }}>
            <Image style={styles.headerBack} source={ImageBuilder.getImage('common_btn_back')}/>
          </View>
        </TouchableWithoutFeedback>
        <Text style={styles.headerText}>反馈</Text>
        <TouchableWithoutFeedback onPress={() => this.sendFeedback()}>
          <View style={{
              position: 'absolute',
              right: 0,
              height: 40 * screenScale,
              width: 50 * screenScale,
              justifyContent: 'center'
            }}>
            <Text style={{
                fontSize: 16 * fontScale,
                color: '#333333'
              }}>确定</Text>
          </View>
        </TouchableWithoutFeedback>
      </View>
      <TextInput editable={true} underlineColorAndroid='#EEEEEE' onChangeText={(text) => this.setState({text: text})} placeholder='请输入您想反馈的问题' placeholdertTextColor='#666666' multiline={true} selectionColor='#000000' style={{
          height: 500 * screenScale,
          color: '#333333',
          width: 375 * screenScale,
          fontSize: 16 * fontScale,
          backgroundColor: '#EEEEEE'
        }}></TextInput>
    </View>);
  }
}

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
  girdLine: {
    height: 1,
    width: 375 * screenScale,
    backgroundColor: '#EEEEEE'
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
    width: 10 * screenScale,
    height: 20 * screenScale,
    marginLeft: 15 * screenScale
  }

});

module.exports = FeedbackScreen;
