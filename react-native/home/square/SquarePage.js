/**
 * Created by flyye on 22/9/17.
 * @providesModule SquarePage
 */

'use strict';

import React, {Component} from 'react';
import {
  StyleSheet,
  Text,
  View,
  Buttom,
  Image,
  ScrollView,
  ListView,
  TouchableWithoutFeedback,
  ActivityIndicator
} from 'react-native';
import {Avatar} from 'react-native-elements'
import Platform from 'Platform';
var isAndroid = Platform.OS === 'android';
var ImageBuilder = require('./utils/ImageBuilder');
var RoleRowList = require('./components/RoleRowList');
var SpaceBriefItem = require('./components/SpaceBriefItem');
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
var CommonUrlMap = require('CommonUrlMap');
import {PullView} from 'react-native-pull';
var SCPropUtils = require('SCPropUtils');

class SquarePage extends Component {

  constructor(props) {
    super(props);
    let fromData = SCPropUtils.getPropsFromNative(props);
    var listDs = new ListView.DataSource({
      rowHasChanged: (r1, r2) => r1 !== r2
    });

    this.state = {
      dataSource: listDs,
      gData: typeof(fromData.gData) === 'undefined'
        ? ''
        : fromData.gData,
      space: {},
      roleList: [],
      topicList: [],
      notices: []
    };
    this.onPullRelease = this.onPullRelease.bind(this);
  }

  onPullRelease(resolve) {
    this.refreshData(this.state.gData);
    setTimeout(() => {
      resolve();
    }, 1000);
  }

  renderRowRole(rowData, rowID) {
    return (<View style={styles.roleItemContainer}>
      <Avatar width={50 * screenScale} height={50 * screenScale} rounded={true} source={{
          uri: rowData.headImg
        }} onPress={() => SCNavigator.pushRNPage('RoleDetailScreen', JSON.stringify({gData: this.state.gData, data: rowData}))} activeOpacity={0.7}/>
      <Text style={styles.bottomText}>{rowData.name}</Text>
    </View>)
  }

  renderRowTopic(rowData, rowID) {
    return (<View style={styles.topicItemContainer}>
      <TouchableWithoutFeedback onPress={() => {
          if (isAndroid) {
            SCNavigator.pushNativePage('page_topic_details', JSON.stringify({gData: this.state.gData, data: rowData}));
          }else {
              SCNavigator.pushNativePage('SYStoryTopicDetailController', JSON.stringify({data:rowData}));
          }
        }
}>
        <Image style={styles.topicImg} source={{
            uri: rowData.background
          }}/>
      </TouchableWithoutFeedback>
      <View style={{
          height: 0
        }}>
        <Text style={styles.topicTitle}>{
            typeof(rowData.intro) === 'undefined'
              ? ''
              : rowData.intro.substring(0, 15)
          }</Text>
      </View>
      <Text style={styles.topicText}>{rowData.title}</Text>
    </View>)
  }

  componentWillMount() {
    if (typeof(this.state.gData) !== 'undefined' && this.state.gData !== '') {
      this.refreshData(this.state.gData);
    }

  }

  refreshData(data) {
    SCNetwork.post(CommonUrlMap.GET_SPACE_LIST_BY_IDS, {
      jArray: JSON.stringify([data.spaceId]), // 从一个对象中解析出字符串  JSON.parse()【从一个字符串中解析出json对象】
      token: data.token
    }).then(result => {
      this.setState({space: result.data[0]})
      SCCacheHelper.setCache(data.userId, 'spaceInfo', JSON.stringify(result.data[0]))
    }).catch(err => {});
    SCNetwork.post(CommonUrlMap.SPACE_ROLE_MODEL_LIST, {
      spaceId: data.spaceId,
      token: data.token
    }).then(result => {
      this.setState({roleList: result.data.content})
    }).catch(err => {});
    SCNetwork.post(CommonUrlMap.FIND_TOPIC_LIST_BY_SPACEID, {
      spaceId: data.spaceId,
      token: data.token
    }).then(result => {
      this.setState({topicList: result.data.content})
    }).catch(err => {});

  }

  render() {
    return (<PullView style={{
        width: Dimensions.get('window').width,
        flex: 1
      }} isContentScroll={true} onPullRelease={this.onPullRelease} topIndicatorHeight={60}>
      <View style={styles.container}>
        {
          this.state.notices.length > 0
            ? (<View style={styles.notice} onPress={this.noticePress}>
              <Text style={styles.noticeText}>
                三体公告：更新我才能诞生的难得是vcsc
              </Text>
            </View>)
            : (null)
        }

        <SpaceBriefItem gData={this.state.gData} title={this.state.space.name} spaceSlogan={this.state.space.slogan} starCount={this.state.space.favoriteNum} content={this.state.space.intro} backgroundImg={this.state.space.background} style={styles.sqBackground}></SpaceBriefItem>
        <View style={styles.subContainer}>
          <TouchableWithoutFeedback onPress={() => SCNavigator.pushRNPage('CrossRuleScreen', JSON.stringify({gData: this.state.gData}))}>

            <View style={styles.itemContainer}>
              <Image style={{
                  height: 27 * screenScale,
                  width: 27 * screenScale,
                  marginBottom: 10 * screenScale
                }} source={ImageBuilder.getImage('cross_rule')}></Image>
              <Text style={styles.grayText}>
                穿越守则
              </Text>
            </View>
          </TouchableWithoutFeedback>
          <TouchableWithoutFeedback onPress={() => SCNavigator.pushRNPage('SpaceNovelScreen', JSON.stringify({gData: this.state.gData}))}>

            <View style={styles.itemContainer}>
              <Image style={{
                  height: 28 * screenScale,
                  width: 25 * screenScale,
                  marginBottom: 10 * screenScale
                }} source={ImageBuilder.getImage('long_text')}></Image>
              <Text style={styles.grayText}>
                小说
              </Text>
            </View>
          </TouchableWithoutFeedback>
          {/* <TouchableWithoutFeedback
            onPress={() => SCNavigator.pushRNPage('SpaceDramaScreen',JSON.stringify({gData:this.state.gData}))}>
          <View style={styles.itemContainer}>
            <Image style={{height:28 * screenScale,width:28 * screenScale,marginBottom: 10 * screenScale}} source={ImageBuilder.getImage('drama')}></Image>
            <Text style={styles.grayText}>
              对戏
            </Text>
          </View>
          </TouchableWithoutFeedback> */
          }
        </View>
        <View style={{
            height: 1
          }}></View>
        <View style={styles.role}>
          <TouchableWithoutFeedback onPress={() => SCNavigator.pushRNPage('SpaceRolesScreen', JSON.stringify({gData: this.state.gData}))}>

            <View style={styles.roleTitle}>
              <View style={{
                  height: 18,
                  width: 5,
                  marginLeft: width * 15 / 375,
                  backgroundColor: '#3BBAC8',
                  marginRight: width * 20 / 375
                }}></View>
              <Text style={{
                  color: '#666666',
                  fontSize: 12 * fontScale
                }}>人物</Text>
              <View style={{
                  flex: 5
                }}></View>
              <Image style={{
                  width: width * 6 / 375,
                  height: width * 12 / 375,
                  marginRight: 15 * width / 375
                }} source={ImageBuilder.getImage('right_arrow')}/>
            </View>
          </TouchableWithoutFeedback>
          <ListView renderRow={(rowData, sectionId, rowID) => this.renderRowRole(rowData, rowID)} dataSource={this.state.dataSource.cloneWithRows(this.state.roleList)} horizontal={true} enableEmptySections={true}/>

        </View>
        <View style={{
            height: 1
          }}></View>
        <View style={styles.topic}>
          <TouchableWithoutFeedback onPress={() => SCNavigator.pushRNPage('SpaceTopicsScreen', JSON.stringify({gData: this.state.gData}))}>
            <View style={styles.roleTitle}>
              <View style={{
                  height: 18,
                  width: 5,
                  marginLeft: width * 15 / 375,
                  backgroundColor: '#3BBAC8',
                  marginRight: width * 20 / 375
                }}></View>
              <Text style={{
                  color: '#666666',
                  fontSize: 12 * fontScale
                }}>话题</Text>
              <View style={{
                  flex: 1
                }}></View>
              <Image style={{
                  width: width * 6 / 375,
                  height: width * 12 / 375,
                  marginRight: 15 * width / 375
                }} source={ImageBuilder.getImage('right_arrow')} onPress={this.topicPress}/>
            </View>
          </TouchableWithoutFeedback>
          <ListView renderRow={(rowData, sectionId, rowID) => this.renderRowTopic(rowData, rowID)} dataSource={this.state.dataSource.cloneWithRows(this.state.topicList)} horizontal={true} enableEmptySections={true}/>
        </View>
      </View>
    </PullView>);

  }
};

const styles = StyleSheet.create({
  container: {
    flexDirection: 'column',
    backgroundColor: '#EEEEEE'
  },
  sqBackground: {},
  subContainer: {
    height: height * 88 / 667,
    flexDirection: 'row',
    backgroundColor: '#F0F200'

  },
  role: {
    height: height * 120 / 667,
    flexDirection: 'column',
    backgroundColor: '#FFFFFF'
  },
  topic: {
    height: height * 199 / 667,
    backgroundColor: '#FFFFFF'
  },
  notice: {
    height: height * 36 / 667,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#FFEDDB'
  },
  noticeText: {
    textAlign: 'center',
    justifyContent: 'center',
    fontSize: 12 * fontScale,
    color: '#FF8200',
    backgroundColor: 'rgba(0,0,0,0)'
  },
  itemContainer: {
    flex: 1,
    flexDirection: 'column',
    backgroundColor: '#FFFFFF',
    alignItems: 'center',
    justifyContent: 'center'
  },
  grayText: {
    fontSize: 12 * fontScale,
    color: '#666666'
  },
  roleTitle: {
    flexDirection: 'row',
    height: 23 * screenScale,
    justifyContent: 'center',
    alignItems: 'center'
  },
  roleItemContainer: {
    height: 97 * screenScale,
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    marginLeft: 15 * screenScale
  },
  bottomText: {
    width: 70 * screenScale,
    height: 17 * screenScale,
    textAlign: 'center',
    fontSize: 12 * fontScale,
    color: '#666666',
    marginTop: 10 * screenScale
  },
  topicItemContainer: {
    flexDirection: 'column',
    height: 176 * screenScale,
    marginLeft: 15 * screenScale,
    justifyContent: 'center'
  },
  topicImg: {
    width: 165 * screenScale,
    height: 100 * screenScale
  },
  topicText: {
    height: 28 * screenScale,
    width: 165 * screenScale,
    fontSize: 10 * fontScale,
    color: '#666666',
    marginTop: 10 * screenScale
  },
  topicTitle: {
    position: 'relative',
    top: -20 * screenScale,
    left: 8 * screenScale,
    fontSize: 11 * fontScale,
    color: '#FFFFFF',
    backgroundColor: 'rgba(0,0,0,0)'
  }
});
module.exports = SquarePage;
