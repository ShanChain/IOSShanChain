/**
 * Created by flyye on 22/9/17.
 * @providesModule CrossRuleScreen
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
import {StackNavigator} from 'react-navigation';
import {Avatar} from 'react-native-elements'
import Platform from 'Platform';
var isAndroid = Platform.OS === 'android';
var ImageBuilder = require('../utils/ImageBuilder');
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
var SCPropUtils = require('SCPropUtils')
var SCCacheHelper = require('SCCacheHelper');
var SCNetwork = require('SCNetwork');
var CommonUrlMap = require('CommonUrlMap');
import {PullView, PullList} from 'react-native-pull';
var SCDateUtils = require('SCDateUtils');

class CrossRule extends Component {

  constructor(props) {
    super(props);
    var listDs = new ListView.DataSource({
      rowHasChanged: (r1, r2) => r1 !== r2
    });
    this.lastResultData = {};
    this.listData = [];
    let fromData = SCPropUtils.getPropsFromNative(props);
    this.state = {
      dataSource: listDs,
      fromData: fromData,
      listData: [],
      isNoMore: false,
      ruleList: []
    };
    this.renderFooter = this.renderFooter.bind(this);
  }

  componentWillMount() {
    let gData = this.state.fromData.gData;
    this.refreshData(gData);
  }

  refreshData(gData) {
    SCNetwork.post(CommonUrlMap.GET_SPACE_MANAGER_LIST, {
      spaceId: gData.spaceId,
      token: gData.token,
      page: 0 + ''
    }).then(result => {
      let noMore = false;
      if (result.data.totalPages == (result.data.number + 1) || result.data.totalElements == 0) {
        noMore = true;
      }
      this.listData = result.data.content;
      this.lastResultData = result.data;
      this.setState({listData: this.listData, isNoMore: noMore});
    }).catch(err => {});
    SCNetwork.post(CommonUrlMap.FIND_NOTICE_LIST_BY_SPACE, {
      spaceId: gData.spaceId,
      token: gData.token,
      page: 0 + ''
    }).then(result => {
      this.setState({ruleList: result.data.content});
    }).catch(err => {});
  }
  renderRowRole(rowData, rowID) {
    return (<View style={styles.roleItemContainer}>
      <Avatar width={50 * screenScale} height={50 * screenScale} rounded={true} source={{
          uri: rowData.headImg
        }} onPress={() => {
          if (isAndroid) {
            SCNavigator.pushNativePage('page_character_home', JSON.stringify({gData: this.state.fromData.gData, data: rowData}));
          }else{
            SCNavigator.pushNativePage('SYFriendHomePageController', JSON.stringify({data:rowData}));
          }
        }} activeOpacity={0.7}/>
      <Text style={styles.bottomText}>{rowData.name}.{rowData.modelNo}</Text>
    </View>)
  }

  loadMore() {
    if (this.listData.length >= 10 && this.lastResultData.totalElements !== 'undefined' && this.lastResultData.totalElements > this.listData.length) {
      SCNetwork.post(CommonUrlMap.GET_SPACE_MANAGER_LIST, {
        spaceId: this.state.fromData.gData.spaceId,
        token: this.state.fromData.gData.gData.token,
        page: this.lastResultData.number + 1 + ''
      }).then(result => {
        let noMore = false;
        if (result.data.totalPages == (result.data.number + 1) || result.data.totalElements == 0) {
          noMore = true;
        }
        for (var i = 0; i < result.data.content.length; i++) {
          this.listData.push(result.data.content[i]);
        }

        this.lastResultData = result.data;
        this.setState({listData: this.listData, isNoMore: noMore});
      }).catch(err => {});

    }
  }
  renderFooter(isNoMore) {
    if (isNoMore) {
      return null;
    }
    return (<View style={{
        height: 100,
        alignItems: 'center',
        justifyContent: 'center'
      }}>
      <ActivityIndicator size="small" color="gray" style={{
          marginTop: 5
        }}/>
    </View>);
  }

  render() {

    var ruleMap = this.state.ruleList;
    var ruleViewMap = [];
    if (ruleMap.length > 0) {
      for (var i = 0; i < (
        ruleMap.length < 6
        ? ruleMap.length
        : 6); i++) {
        ruleViewMap.push(<Text style={styles.ruleText} key={ruleMap[i].noticeId}>{i + 1}. {ruleMap[i].content}</Text>);
      }
      if (ruleMap.length > 6) {
        ruleViewMap.push(<Text key={ruleMap[i].noticeId} style={{
            color: '#666666',
            fontSize: 12 * fontScale,
            marginBottom: 10 * screenScale
          }}>......</Text>);
      }
    }
    return (<ScrollView>
      <View style={styles.container}>
        <View style={{
            height: 1
          }}></View>
        <View style={styles.role}>
          <TouchableWithoutFeedback onPress={() => SCNavigator.pushRNPage('SpaceLeadersScreen', JSON.stringify({gData: this.state.fromData.gData}))}>
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
                }}>你们的领队</Text>
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
          <ListView renderRow={(rowData, sectionId, rowID) => this.renderRowRole(rowData, rowID)} dataSource={this.state.dataSource.cloneWithRows(this.state.listData)} horizontal={true} renderFooter={() => {
              return this.renderFooter(this.state.isNoMore)
            }} enableEmptySections={true} pageSize={10} initialListSize={10} onEndReached={() => this.loadMore} onEndReachedThreshold={60}/>

        </View>
        <View style={{
            height: 1
          }}></View>
        <View style={styles.topic}>
          <TouchableWithoutFeedback onPress={() => SCNavigator.pushRNPage('SpaceRulesScreen', JSON.stringify({gData: this.state.fromData.gData}))}>
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
                }}>注意事项</Text>
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
          <View style={{
              marginLeft: 15 * screenScale,
              marginRight: 15 * screenScale,
              paddingTop: 20 * screenScale
            }}>
            {
              ruleViewMap.map((elem, index) => {
                return elem;
              })
            }
            <View style={{
                height: 4 * screenScale
              }}></View>
          </View>
        </View>
        <View style={{
            height: 0.5 * screenScale
          }}></View>
        {/* <View style={{
            height: 42 * screenScale,
            backgroundColor: '#FFFFFF',
            alignItems: 'center',
            justifyContent: 'center'
          }}>
          <TouchableWithoutFeedback onPress={() => this.props.navigation.navigate('SpaceNotice', {})}>
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
                }}>公告</Text>
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
        </View> */}
      </View>
    </ScrollView>);
  }
};
const CrossRuleScreen = StackNavigator({
  CrossRule: {
    screen: CrossRule,
    navigationOptions: {
      header: ({navigation}) => {
        return (<CommonHeaderView goBack={() => SCNavigator.pop()} isShowBack={true} navigation={navigation} title={'穿越守则'}></CommonHeaderView>)
      }
    }
  },
  SpaceNotice: {
    screen: require('./SpaceNoticeScreen'),
    navigationOptions: {
      header: ({navigation}) => {
        return (<CommonHeaderView isShowBack={true} navigation={navigation} title={'公告'}></CommonHeaderView>)
      }
    }
  }
}, {initialRouteName: 'CrossRule'});
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
    height: 121 * screenScale,
    flexDirection: 'column',
    backgroundColor: '#FFFFFF'
  },
  topic: {
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
    color: '#FF8200'
  },
  headImg: {
    height: 28 * width / 375,
    marginBottom: 10 * width / 375
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
  ruleText: {
    fontSize: 12 * fontScale,
    color: '#666666',
    marginBottom: 8 * screenScale
  }
});
module.exports = CrossRuleScreen;
