/**
 * Created by flyye on 22/9/28.
* @providesModule SpaceNoticeScreen
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
var SCNavigator = require('SCNavigator');
var SCPropUtils = require('SCPropUtils')
var SCCacheHelper = require('SCCacheHelper');
var SCNetwork = require('SCNetwork');
var CommonUrlMap = require('CommonUrlMap');
import {PullView, PullList} from 'react-native-pull';
var SCDateUtils = require('SCDateUtils');

class SpaceNoticeScreen extends Component {

  constructor(props) {
    super(props);
    var listDs = new ListView.DataSource({
      rowHasChanged: (r1, r2) => r1 !== r2
    });
    this.lastResultData = {};
    this.listData = [];
    this.headImgMap = {};
    let fromData = SCPropUtils.getPropsFromNative(props);
    this.state = {
      dataSource: listDs,
      fromData: fromData,
      gData: fromData.gData,
      headImgMap: {},
      listData: [],
      isNoMore: false
    };
    this.isLoading = false;
    this.renderFooter = this.renderFooter.bind(this);
    this.loadMore = this.loadMore.bind(this);
    this.onPullRelease = this.onPullRelease.bind(this);
  }

  componentWillMount() {
    let gData = this.state.fromData.gData;
    this.refreshData(gData);
  }

  refreshData(gData) {
    this.isLoading = true;
    SCNetwork.post(CommonUrlMap.FIND_ANNO_LIST_BY_TITLE, {
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
      this.isLoading = false;
      this.setState({listData: this.listData, isNoMore: noMore});
      this.getHeadImg(result.data.content)
    }).catch(err => {
      this.isLoading = false;
    });
  }
  onPullRelease(resolve) {
    this.refreshData(this.state.fromData.gData);
    setTimeout(() => {
      resolve();
    }, 1000);
  }

  loadMore() {
    if (!this.isLoading && !this.state.isNoMore) {
      if (this.listData.length >= 10 && this.lastResultData.totalElements !== 'undefined' && this.lastResultData.totalElements > this.listData.length) {
        this.isLoading = true;
        SCNetwork.post(CommonUrlMap.FIND_ANNO_LIST_BY_TITLE, {
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
          this.getHeadImg(result.data.content)
          this.lastResultData = result.data;
          this.isLoading = false;
          this.setState({listData: this.listData, isNoMore: noMore});
        }).catch(err => {
          this.isLoading = false;
        });

      }
    }
  }

  getHeadImg(list) {
    let characterIdList = [];
    for (var i = 0; i < list.length; i++) {
      if (typeof(this.state.headImgMap['characterId' + list[i].characterId]) === 'undefined') {
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
        this.headImgMap['characterId' + result.data[i].characterId + ''] = result.data[i].headImg;
      }
      this.setState({headImgMap: this.headImgMap});
    }).catch(err => {});
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
            SCNavigator.pushNativePage('page_notice', JSON.stringify({gData: this.state.gData, data: rowData}))
          }
        }
}>
        <View style={styles.itemContainer}>
          <View style={{
              width: 15 * screenScale
            }}></View>
          <Avatar width={50 * screenScale} height={50 * screenScale} rounded={true} source={{
              uri: typeof(this.state.headImgMap['characterId' + rowData.characterId]) === 'undefined'
                ? ''
                : this.state.headImgMap['characterId' + rowData.characterId + '']
            }} onPress={() => console.log("Works!")} activeOpacity={0.7}/>
          <View style={{
              flexDirection: 'row',
              flex: 1,
              marginRight: 15 * screenScale,
              marginLeft: 15 * screenScale
            }}>
            <View style={styles.leftText}>
              <Text style={styles.leftTitle}>{
                  typeof(rowData.title) === 'undefined'
                    ? ''
                    : rowData.title.substring(0, 10)
                }</Text>
              <Text style={styles.leftDetail}>{
                  typeof(rowData.content) === 'undefined'
                    ? ''
                    : rowData.content.substring(0, 15)
                }
              </Text>
            </View>
            <View style={styles.rightText}>
              <Text style={styles.rightTime}>{SCDateUtils.getContentTimeFormat(rowData.createTime)}</Text>
              <Text style={styles.textLenght}>{rowData.content.length}</Text>
            </View>
          </View>
        </View>
      </TouchableWithoutFeedback>
    </View>)
  }

  render() {
    return (<View style={styles.container}>
      <PullList renderRow={(rowData, sectionId, rowID) => this.renderRow(rowData, rowID)} dataSource={this.state.dataSource.cloneWithRows(this.state.listData)} style={{
          width: 375 * screenScale
        }} onPullRelease={this.onPullRelease} enableEmptySections={true} pageSize={10} initialListSize={10} onEndReached={this.loadMore} onEndReachedThreshold={60} renderFooter={this.renderFooter} removeClippedSubviews={false}/>
    </View>)
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
    height: 70 * screenScale,
    flexDirection: 'row',
    backgroundColor: '#FFFFFF',
    alignItems: 'center'
  },
  leftTitle: {
    fontSize: 14 * fontScale,
    color: '#666666',
    marginBottom: 13 * screenScale,
    marginTop: 5 * screenScale
  },
  leftDetail: {
    fontSize: 12 * fontScale,
    color: '#B3B3B3'
  },
  rightTime: {
    fontSize: 14 * fontScale,
    color: '#888888',
    marginBottom: 13 * screenScale
  },
  textLenght: {
    fontSize: 14 * fontScale,
    color: '#3BBAC8'
  },
  leftText: {
    flex: 160,
    flexDirection: 'column',
    alignItems: 'flex-start'
  },
  rightText: {
    flex: 120,
    flexDirection: 'column',
    alignItems: 'flex-end'
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
module.exports = SpaceNoticeScreen;
