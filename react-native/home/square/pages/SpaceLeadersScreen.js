/**
 * Created by flyye on 22/10/9.
* @providesModule SpaceLeadersScreen
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
var CommonUrlMap = require('CommonUrlMap')
var SCPropUtils = require('SCPropUtils')
var SCBottomAlertDialog = require('SCBottomAlertDialog');
let globalGData={};
let globalRefreshData;
var SCChooseContact = require('SCChooseContact');

class SpaceLeaders extends Component {

  constructor(props) {debugger
    super(props);
    var listDs = new ListView.DataSource({
      rowHasChanged: (r1, r2) => r1 !== r2
    });
    this.lastResultData = {};
    this.listData = [];
    this.allData = [];
    this.spaceNameMap = {};
    let fromData = SCPropUtils.getPropsFromNative(props);
    globalGData = typeof(fromData.gData) === 'undefined'
          ? ''
          : fromData.gData;
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
    this.refreshData = this.refreshData.bind(this);
  }

  componentWillMount() {
    this.refreshData();
    globalRefreshData =  this.refreshData;
  }

  refreshData() {
    let gData = this.state.gData;
    this.isLoading = true;
    SCNetwork.post(CommonUrlMap.GET_SPACE_MANAGER_LIST, {
      spaceId: gData.spaceId + '',
      token: gData.token,
      page: 0 + ''
    }).then(result => {
      let noMore = false;
      if (result.data.totalPages == (result.data.number + 1) || result.data.totalElements == 0) {
        noMore = true;
      }
      this.listData = result.data.content;
      this.lastResultData = result.data;
      this.isLoading = false;
      this.setState({listData: this.listData, isNoMore: noMore});

    }).catch(err => {
      this.isLoading = false;
    });

  }

  onPullRelease(resolve) {
    this.refreshData();
    setTimeout(() => {
      resolve();
    }, 1000);
  }

  loadMore() {
    if (!this.isLoading && !this.state.isNoMore) {
      if (this.listData.length >= 10 && this.lastResultData.totalElements !== 'undefined' && this.lastResultData.totalElements > this.listData.length) {
        this.isLoading = true;

        SCNetwork.post(CommonUrlMap.GET_SPACE_MANAGER_LIST, {
          spaceId: this.state.gData.spaceId + '',
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

          this.lastResultData = result.data;
          this.isLoading = false;
          this.setState({listData: this.listData, isNoMore: noMore});
        }).catch(err => {
          this.isLoading = false;
        });

      }
    }
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

        if (isAndroid) {
        SCNavigator.pushNativePage('page_character_home', JSON.stringify({gData: this.state.gData, data: rowData}));
        }else{
          SCNavigator.pushNativePage('SYFriendHomePageController', JSON.stringify({data:rowData}));
        }
        }}>
        <View style={styles.itemContainer}>
          <View style={{
              width: 15 * screenScale
            }}></View>
          <Avatar width={50 * screenScale} height={50 * screenScale} rounded={true} source={{
              uri: rowData.headImg
            }} onPress={() => console.log("Works!")} activeOpacity={0.7}/>

          <View style={styles.leftText}>
            <Text style={styles.leftTitle}>{rowData.name}.{rowData.modelNo}</Text>
            <Text style={styles.leftDetail}>{rowData.signature}</Text>
          </View>

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

function showDialog() {
    SCBottomAlertDialog.show({0: '设置领队', 1: '退出当前领队', 2: '取消'}).then((key) => {
        if (key == 0) {
            if (Platform.OS === 'android') {
                SCNavigator.pushNativePage('page_story_dynamic', JSON.stringify({
                    gData: this.state.gData,
                    data: {
                        novel: rowData,
                        character: this.state.characterMap['characterId' + rowData.characterId]
                    }
                }));
            } else {

             SCChooseContact.choose().then(result => {
              SCNetwork.post(CommonUrlMap.ADD_SPACE_MANAGER, {
                  newAdmin:result.userId,
                  userId: globalGData.userId,
                  spaceId: globalGData.spaceId,
                  token: globalGData.token
              }).then(result => {
               globalRefreshData();
              }).catch(err => {
              });
             }).catch( err => {

             });
            }
        } else if (key == 1) {
            SCNetwork.post(CommonUrlMap.DELETE_SPACE_MANAGER, {
                admin:globalGData.userId,
                userId: globalGData.userId,
                spaceId: globalGData.spaceId,
                token: globalGData.token
            }).then(result => {
              globalRefreshData();
            }).catch(err => {

            });
        } else {
            SCBottomAlertDialog.dismiss();
        }
    }).catch((err) => {});
}

const SpaceLeadersScreen = StackNavigator({
        SpaceLeaders: {
            screen: SpaceLeaders,
            navigationOptions: {
                header: ({navigation}) => {
                    return (<CommonHeaderView
                        goBack={() => SCNavigator.pop()}
                        isShowBack={true} navigation={navigation}
                        title={'领队'}
                        isShowRightImg={true}
                        rightImg={ImageBuilder.getImage('common_menu')}
                        rightAction={() => showDialog()}
                    ></CommonHeaderView>)
                },
            }
        }
    },
    {
        initialRouteName: 'SpaceLeaders'
    });

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
    alignItems: 'flex-start'
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
module.exports = SpaceLeadersScreen;
