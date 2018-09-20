/**
 * Created by flyye on 22/9/28.
* @providesModule NotificationScreen
 */

'use strict';

import React, {Component} from 'react';
import {
  StyleSheet,
  Text,
  View,
  Switch,
  TouchableWithoutFeedback,
  Image,
  ScrollView,
  ListView,
  ActivityIndicator
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
import {Avatar, List, ListItem} from 'react-native-elements';
var CommonHeaderView = require('CommonHeaderView');
var SCNavigator = require('SCNavigator');
var SCPropUtils = require('SCPropUtils')
var SCCacheHelper = require('SCCacheHelper');
var SCNetwork = require('SCNetwork');
var CommonUrlMap = require('CommonUrlMap');
import {PullList} from 'react-native-pull';
var SCDateUtils = require('SCDateUtils');

class NotificationPage extends Component {

  constructor(props) {
    super(props);
    var listDs = new ListView.DataSource({
      rowHasChanged: (r1, r2) => r1 !== r2
    });
    this.lastResultData = {};
    this.msgKeyList = [];
    this.characterMap = [];
    this.storyMap = [];
    let fromData = SCPropUtils.getPropsFromNative(props);
    this.state = {
      dataSource: listDs,
      fromData: fromData,
      gData: fromData.gData,
      isNoMore: false,
      characterMap: [],
      storyMap: [],
      msgJson: {},
      msgKeyList: []
    };
  }

  componentWillMount() {
    SCCacheHelper.getCacheAsync(this.state.gData.userId, 'userMessage').then((result) => {
      this.refreshData(result);
    });

  }
  refreshData(msgString) {
    let characterIdList = [];
    let storyIdList = [];
    if ( msgString === '') {
      return;
    }
    var msgJson = JSON.parse(msgString);
    for (var key in msgJson) {
      if (msgJson[key].hasOwnProperty("characterId")) {
        characterIdList.push(msgJson[key].characterId);
      }
      this.msgKeyList.push(key);
      if (msgJson[key].hasOwnProperty("storyId")) {
        storyIdList.push(msgJson[key].storyId);
      }
    }

    if (characterIdList.length === 0) {
      return;
    }
    SCNetwork.post(CommonUrlMap.GET_CHARACTER_BRIEF_INFO_LIST, {
      dataArray: JSON.stringify(characterIdList),
      token: this.state.fromData.gData.token
    }).then(result => {
      for (var i = 0; i < result.data.length; i++) {
        this.characterMap['characterId' + result.data[i].characterId + ''] = result.data[i];
      }
      this.setState({characterMap: this.characterMap, msgJson: msgJson, msgKeyList: this.msgKeyList});
    }).catch(err => {});
    SCNetwork.post(CommonUrlMap.GET_STORY_BY_LIST, {
      dataArray: JSON.stringify(storyIdList),
      token: this.state.fromData.gData.token
    }).then(result => {
      for (var i = 0; i < result.data.length; i++) {
        this.storyMap['storyId' + result.data[i].storyId + ''] = result.data[i];
      }
      this.setState({storyMap: this.storyMap, msgJson: msgJson, msgKeyList: this.msgKeyList});
    }).catch(err => {});
  }

  renderRow(rowData, rowID) {

    var msg = this.state.msgJson[rowData];
    var characterId = msg.characterId;
    var storyId = msg.storyId;
    var storyInfo = this.state.storyMap['storyId' + msg.storyId];
    var characterInfo = this.characterMap['characterId' + characterId];
    var msgContent = '';
    if (rowData === 'MSG_CHARACTER_BE_FOCUS' + storyId) {
      msgContent = '在故事中@了你，等着你哦';
    } else if (rowData === 'MSG_STORY_BE_COMMENT' + storyId) {
      if (typeof(storyInfo) !== 'undefined' && storyInfo.type == 2) {
        msgContent = '评论了你的小说，赶快去看看吧';
      } else {
        msgContent = '评论了你的故事，赶快去看看吧';
      }
    } else if (rowData === 'MSG_STORY_BE_PRAISE' + storyId) {
      if (typeof(storyInfo) !== 'undefined' && storyInfo.type == 2) {
        msgContent = '赞了你的小说';
      } else {
        msgContent = '赞了你的故事';
      }
    } else if (rowData === 'MSG_COMMENT_BE_PRAISE' + storyId) {
      msgContent = '赞了你的评论';
    } else if (rowData === 'MSG_DYNAMIC_BE_FORWARD' + storyId) {
      msgContent = '转发了你的故事，快来看看吧';
    } else if (rowData === 'MSG_CHARACTER_BE_FOLLOW') {
      msgContent = '关注了你，快来看看他(她)的世界';
    }

    return (<View style={{
        flexDirection: 'column'
      }}>
      <View style={{
          height: 1 * screenScale,
          backgroundColor: '#EEEEEE'
        }}></View>
      <TouchableWithoutFeedback onPress={() => {debugger

          if (typeof(characterInfo) !== 'undefined' && typeof(rowData) !== 'undefined' && typeof(storyInfo) !== 'undefined') {
            if (storyInfo.type == 1) {
              if(Platform.OS === 'android'){
                SCNavigator.pushNativePage('page_story_dynamic', JSON.stringify({
                  gData: this.state.gData,
                  data: {
                    novel: storyInfo,
                    character: characterInfo
                  }
                }));
              }else {
                SCNavigator.pushNativePage('SYStoryContentController', JSON.stringify({
                  gData: this.state.gData,
                  data: {
                    novel: storyInfo,
                    character: characterInfo
                  }
                }));
              }
            } else if (storyInfo.type == 2) {
              if(Platform.OS === 'android'){
                SCNavigator.pushNativePage('page_novel_dynamic', JSON.stringify({
                  gData: this.state.gData,
                  data: {
                    novel: storyInfo,
                    character: characterInfo
                  }
                }));
              }else {
                SCNavigator.pushNativePage('SYStoryContentController', JSON.stringify({
                  gData: this.state.gData,
                  data: {
                    novel: storyInfo,
                    character: characterInfo
                  }
                }));
              }
            } else if (rowData === 'MSG_CHARACTER_BE_FOLLOW') {
              if (isAndroid) {
                SCNavigator.pushNativePage('page_character_home', JSON.stringify({gData: this.state.gData, data: characterInfo}));
              }else{
                SCNavigator.pushNativePage('SYFriendHomePageController', JSON.stringify({data:characterInfo}));
              }

            }
          } else if (rowData === 'MSG_CHARACTER_BE_FOLLOW') {
            if (isAndroid) {
              SCNavigator.pushNativePage('page_character_home', JSON.stringify({gData: this.state.gData, data: characterInfo}));
            }else{
              SCNavigator.pushNativePage('SYFriendHomePageController', JSON.stringify({data:characterInfo}));
            }
          }
        }
}>
        <View style={styles.itemContainer}>
          <View style={{
              width: 15 * screenScale
            }}></View>
          <Avatar width={50 * screenScale} height={50 * screenScale} rounded={true} source={{
              uri: typeof(this.state.characterMap['characterId' + characterId]) === 'undefined'
                ? ''
                : this.state.characterMap['characterId' + characterId + ''].headImg
            }} onPress={() => {
              if (isAndroid) {
              SCNavigator.pushNativePage('page_character_home', JSON.stringify({gData: this.state.fromData.gData, data: characterInfo}));
              }else{
                SCNavigator.pushNativePage('SYFriendHomePageController', JSON.stringify({data:characterInfo}));
              }

            }} activeOpacity={0.7}/>
          <View style={{
              flexDirection: 'row',
              flex: 1,
              marginRight: 15 * screenScale,
              marginLeft: 15 * screenScale
            }}>
            <View style={styles.leftText}>
              <Text style={styles.leftName}>@{characterInfo.name}</Text>
              <Text style={styles.leftTitle}>{msgContent}</Text>
            </View>
            <View style={styles.rightText}>
              <Text style={styles.rightTime}>{SCDateUtils.getContentTimeFormat(this.state.msgJson[rowData].time)}</Text>
            </View>
          </View>
        </View>
      </TouchableWithoutFeedback>

    </View>)
  }

  getHeadImg(list) {
    let characterIdList = [];
    for (var i = 0; i < list.length; i++) {
      if (typeof(this.state.characterMap['characterId' + list[i].characterId]) === 'undefined') {
        characterIdList.push(list[i].characterId)
      }
    }
    if (characterIdList.length === 0) {
      return;
    }
    SCNetwork.post(CommonUrlMap.GET_CHARACTER_BRIEF_INFO_LIST, {
      dataArray: JSON.stringify(characterIdList),
      token: this.state.fromData.gData.token
    }).then(result => {
      for (var i = 0; i < result.data.length; i++) {
        this.characterMap['characterId' + result.data[i].characterId + ''] = result.data[i];
      }
      this.setState({characterMap: this.characterMap});
    }).catch(err => {});
  }

  render() {
    return (<View>
          <ListView renderRow={(rowData, sectionId, rowID) => this.renderRow(rowData, rowID)} dataSource={this.state.dataSource.cloneWithRows(this.state.msgKeyList)} width={375 * screenScale} enableEmptySections={true}/>
    </View>)
  }
}

const NotificationScreen = StackNavigator({
  NotificationPage: {
    screen: NotificationPage,
    navigationOptions: {
      header: ({navigation}) => {
        return (<CommonHeaderView goBack={() => SCNavigator.pop()} isShowRightImg={true} isShowBack={true} navigation={navigation} title={'通知'}/>)
      }
    }
  }
}, {initialRouteName: 'NotificationPage'});

const styles = StyleSheet.create({
  container: {
    flexDirection: 'column',
    flex: 1,
    backgroundColor: '#EEEEEE',
    alignItems: 'center'
  },
  itemContainer: {
    height: 70 * screenScale,
    flexDirection: 'row',
    backgroundColor: '#FFFFFF',
    alignItems: 'center'
  },
  leftTitle: {
    fontSize: 14 * fontScale,
    color: '#666666',
    marginTop: 10 * screenScale
  },
  leftName: {
    fontSize: 14 * fontScale,
    marginTop: 10 * screenScale,
    color: '#3BBAC8'
  },
  leftDetail: {
    fontSize: 12 * fontScale,
    color: '#B3B3B3'
  },
  rightTime: {
    fontSize: 12 * fontScale,
    position: 'absolute',
    top: -10,
    color: '#888888'
  },
  rightText: {
    flex: 1,
    flexDirection: 'column',
    alignItems: 'flex-end'
  },
  leftText: {
    flex: 3,
    flexDirection: 'row',
    justifyContent: 'flex-start'
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
module.exports = NotificationScreen;
