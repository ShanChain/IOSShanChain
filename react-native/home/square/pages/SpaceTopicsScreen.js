/**
 * Created by flyye on 22/9/28.
* @providesModule SpaceTopicsScreen
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
var ImageBuilder = require('../utils/ImageBuilder');
var CommonImageBuilder = require('CommonImageBuilder');
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
var SCNetwork = require('SCNetwork');
var CommonUrlMap = require('CommonUrlMap')
var SCCacheHelper = require('SCCacheHelper')
var SCPropUtils = require('SCPropUtils')

class SpaceTopics extends Component {
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
      gData: fromData.gData,

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
    SCNetwork.post(CommonUrlMap.FIND_TOPIC_LIST_BY_SPACEID, {
      spaceId: gData.spaceId,
      token: gData.token
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
    this.refreshData(this.state.fromData.gData);
    setTimeout(() => {
      resolve();
    }, 1000);
  }

  loadMore() {
    if (!this.isLoading && !this.state.isNoMore) {
      if (this.listData.length >= 10 && this.lastResultData.totalElements !== 'undefined' && this.lastResultData.totalElements > this.listData.length) {
        this.isLoading = true;
        SCNetwork.post(CommonUrlMap.FIND_TOPIC_LIST_BY_SPACEID, {
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
          this.isLoading = false;
          this.lastResultData = result.data;
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
            SCNavigator.pushNativePage('page_topic_details', JSON.stringify({gData: this.state.gData, data: rowData}))
          }else{
            SCNavigator.pushNativePage('SYStoryTopicDetailController', JSON.stringify({data: rowData}))
          }
        }}>
        <View style={styles.itemContainer}>
          <View style={{
              width: 15 * screenScale
            }}></View>
          <Image style={{
              width: 70 * screenScale,
              height: 70 * screenScale,
              borderRadius: 8 * screenScale
            }} source={{
              uri: rowData.background
            }}/>
          <View style={{
              flexDirection: 'row',
              flex: 1,
              marginRight: 20 * screenScale,
              marginLeft: 20 * screenScale
            }}>
            <View style={styles.leftText}>
              <Text style={styles.leftTitle}>{
                  rowData.title.length > 15
                    ? rowData.title.substring(0, 15) + '...'
                    : rowData.title
                }</Text>
              <Text style={styles.leftDetail}>{
                  rowData.intro.length > 30
                    ? rowData.intro.substring(0, 30) + '...'
                    : rowData.intro
                }</Text>
              <View style={{
                  flexDirection: 'row',
                  alignItems: 'flex-start'
                }}>
                <Text style={{
                    width: 67 * screenScale,
                    fontSize: 10 * fontScale,
                    color: '#3BBAC8'
                  }}>{rowData.storyNum}次讨论</Text>
                <Text style={{
                    fontSize: 10 * fontScale,
                    color: '#3BBAC8'
                  }}>{rowData.readNum}次阅读</Text>
              </View>
            </View>
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

const SpaceTopicsScreen = StackNavigator({
  SpaceTopics: {
    screen: SpaceTopics,
    navigationOptions: {
      header: ({navigation}) => {
        return (<CommonHeaderView goBack={() => SCNavigator.pop()} isShowRightImg={true} rightStyle={{width: 20 * screenScale,
            height: 20 * screenScale}} rightImg={CommonImageBuilder.getImage('common_add')} rightAction={() =>
          {
            if(isAndroid){
              SCNavigator.pushNativePage('page_add_topic', '')
            }else {
              SCNavigator.pushNativePage('SYAuxiliaryAddController', JSON.stringify({
                data: {
                  type: 'add_topic'
                }
              }))
            }
          }

        } isShowBack={true} navigation={navigation} title={'话题'}/>)
      }
    }
  }
}, {initialRouteName: 'SpaceTopics'});

const styles = StyleSheet.create({
  container: {
    flexDirection: 'column',
    flex: 1,
    backgroundColor: '#EEEEEE',
    alignItems: 'center'
  },
  itemContainer: {
    height: 100 * screenScale,
    flexDirection: 'row',
    backgroundColor: '#FFFFFF',
    alignItems: 'center'
  },
  leftTitle: {
    fontSize: 14 * fontScale,
    color: '#333333',
    marginBottom: 2 * screenScale
  },
  leftDetail: {
    height: 34 * screenScale,
    fontSize: 12 * fontScale,
    marginBottom: 5 * screenScale,
    color: '#B3B3B3'
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
module.exports = SpaceTopicsScreen;
