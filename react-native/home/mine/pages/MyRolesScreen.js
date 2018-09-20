/**
 * Created by flyye on 22/9/28.
* @providesModule MyRolesScreen
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
  ListView,
  ActivityIndicator
} from 'react-native';

import {StackNavigator} from 'react-navigation';
import Platform from 'Platform';
var isAndroid = Platform.OS === 'android';
var ImageBuilder = require('CommonImageBuilder');
var Dimensions = require('Dimensions');
var SCAlertDialog = require('SCAlertDialog');
var {
  width,
  height,
  scale,
  fontScale
} = Dimensions.get('window');
var screenScale = width / 375;
var CommonHeaderView = require('CommonHeaderView');
import {Avatar, List, ListItem} from 'react-native-elements'
import {PullList} from 'react-native-pull';
var SCNavigator = require('SCNavigator');
var SCCacheHelper = require('SCCacheHelper');
var SCNetwork = require('SCNetwork');
var CommonUrlMap = require('CommonUrlMap');
var SCPropUtils = require('SCPropUtils');
var AppManager = require('AppManager');

class MyRoles extends Component {

  constructor(props) {
    super(props);
    var listDs = new ListView.DataSource({
      rowHasChanged: (r1, r2) => r1 !== r2
    });
    this.lastResultData = {};
    this.listData = [];
    this.allData = [];
    this.spaceNameMap = {};
    let fromData = SCPropUtils.getPropsFromNative(props);
    this.state = {
      dataSource: listDs,
      gData: typeof(fromData.gData) === 'undefined'
        ? ''
        : fromData.gData,
      spaceNameMap: this.spaceNameMap,
      listData: [],
      isNoMore: false
    };
    this.isLoading = false;
    this.renderFooter = this.renderFooter.bind(this);
    this.loadMore = this.loadMore.bind(this);
    this.onPullRelease = this.onPullRelease.bind(this);
  }

  componentWillMount() {
    let gData = this.state.gData;
    this.refreshData(gData);
  }

  refreshData(gData) {
    this.isLoading = true;
    SCNetwork.post(CommonUrlMap.FIND_CHARACTER_LIST_BY_USER, {
      userId: gData.userId + '',
      token: gData.token,
      page: 0 + ''
    }).then(result => {
      let noMore = false;
      if (result.data.totalPages == (result.data.number + 1)) {
        noMore = true;
      }
      this.listData = result.data.content;
      this.lastResultData = result.data;
      this.isLoading = false;
      this.setState({listData: this.listData, isNoMore: noMore});
      this.refreshSpaceName(gData, result.data.content)
    }).catch(err => {
      this.isLoading = false;
    });

  }

  onPullRelease(resolve) {
    this.refreshData(this.state.gData);
    setTimeout(() => {
      resolve();
    }, 1000);
  }

  loadMore() {
    if (!this.isLoading && !this.state.isNoMore) {
      if (this.listData.length >= 10 && this.lastResultData.totalElements !== 'undefined' && this.lastResultData.totalElements > this.listData.length) {
        this.isLoading = true;
        SCNetwork.post(CommonUrlMap.FIND_CHARACTER_LIST_BY_USER, {
          userId: this.state.gData.userId + '',
          token: this.state.gData.token,
          page: this.lastResultData.number + 1 + ''
        }).then(result => {
          let noMore = false;
          if (result.data.totalPages == (result.data.number + 1) || result.data.totalElements == 0) {
            noMore = true;
          }
          for (var i = 0; i < result.data.content.length; i++) {
            this.listData.push(result.data.content[i]);
          }
          this.refreshSpaceName(this.state.gData, result.data.content)
          this.lastResultData = result.data;
          this.isLoading = false;
          this.setState({listData: this.listData, isNoMore: noMore});
        }).catch(err => {
          this.isLoading = false;
        });

      }
    }
  }

  refreshSpaceName(gData, characterArray) {
    let spaceIdArray = [];
    for (var i = 0; i < characterArray.length; i++) {
      if (typeof(this.state.spaceNameMap['spaceId' + characterArray[i].spaceId]) === 'undefined') {
        spaceIdArray.push(characterArray[i].spaceId)
      }
    }
    if (spaceIdArray.length === 0) {
      return;
    }
    SCNetwork.post(CommonUrlMap.GET_SPACE_LIST_BY_IDS, {
      jArray: JSON.stringify(spaceIdArray),
      token: gData.token
    }).then(result => {
      for (var i = 0; i < result.data.length; i++) {
        this.spaceNameMap['spaceId' + result.data[i].spaceId + ''] = result.data[i].name;
      }
      this.setState({spaceNameMap: this.state.spaceNameMap});
    }).catch(err => {});
  }
  renderRow(rowData, rowID) {
    return (<View style={{
        flexDirection: 'column'
      }}>
      <View style={{
          height: 0.5 * screenScale,
          backgroundColor: '#EEEEEE'
        }}></View>
      <TouchableWithoutFeedback onPress={() => {
          var options = {
            type: '1',
            title: '切换角色',
            msg: '确定要切换到' + rowData.name + '吗？'
          }
          SCAlertDialog.show(options, () => {
            AppManager.switchRole({
              modelId: rowData.modelId + '',
              spaceId: rowData.spaceId + '',
              userId: this.state.gData.userId + ''
            });
          }, () => {});
        }}>
        <View style={styles.itemContainer}>
          <View style={{
              width: 15 * screenScale
            }}></View>
          <Avatar width={50 * screenScale} height={50 * screenScale} rounded={true} source={{
              uri: rowData.headImg
            }} onPress={() => {
              if (isAndroid) {
                SCNavigator.pushNativePage('page_character_home', JSON.stringify({gData: this.state.gData, data: rowData}));
              }else{
                SCNavigator.pushNativePage('SYFriendHomePageController', JSON.stringify({data:rowData}));
              }
            }} activeOpacity={0.7}/>

          <View style={styles.leftText}>
            <Text style={styles.leftTitle}>{rowData.name + '.' + rowData.modelNo}</Text>
            <Text style={styles.leftDetail}>{rowData.signature}</Text>
          </View>
          <Text style={styles.rightText}>{
              typeof(this.state.spaceNameMap['spaceId' + rowData.spaceId]) === 'undefined'
                ? ''
                : this.state.spaceNameMap['spaceId' + rowData.spaceId]
            }</Text>
        </View>
      </TouchableWithoutFeedback>
    </View>)
  }
  renderFooter() {
    if (this.state.isNoMore) {
      return null;
    }
    return (<View style={{
        height: 100
      }}>
      <ActivityIndicator size="small" color="red" style={{
          marginTop: 5
        }}/>
    </View>);
  }

  render() {
    return (<View style={styles.container}>
      <PullList renderRow={(rowData, sectionId, rowID) => this.renderRow(rowData, rowID)} dataSource={this.state.dataSource.cloneWithRows(this.state.listData)} style={{
          width: 375 * screenScale
        }} onPullRelease={this.onPullRelease} enableEmptySections={true} pageSize={10} initialListSize={10} onEndReached={this.loadMore} onEndReachedThreshold={60} renderFooter={this.renderFooter} removeClippedSubviews={false}/>
    </View>)
  }
}

const MyRolesScreen = StackNavigator({
  MyRoles: {
    screen: MyRoles,
    navigationOptions: {
      header: ({navigation}) => {
        return (<CommonHeaderView goBack={() => SCNavigator.pop()} isShowBack={true} navigation={navigation} title={'我的角色'}></CommonHeaderView>)
      }
    }
  }
}, {initialRouteName: 'MyRoles'});

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
    marginLeft: 15 * screenScale,
    marginBottom: 10 * screenScale
  },
  leftDetail: {
    fontSize: 12 * fontScale,
    color: '#B3B3B3',
    marginLeft: 15 * screenScale
  },
  rightText: {
    fontSize: 14 * fontScale,
    color: '#3BBAC8',
    position: 'absolute',
    top: 10 * screenScale,
    left: 280 * screenScale
  },
  leftText: {
    flexDirection: 'column',
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
module.exports = MyRolesScreen;
