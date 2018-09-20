/**
 * Created by flyye on 22/9/29.
* @providesModule ChangeBrandScreen
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

import BackHandler from 'BackHandler';
import {Avatar, List, ListItem} from 'react-native-elements'
import {PullList} from 'react-native-pull';
var SCNavigator = require('SCNavigator');
var SCPropUtils = require('SCPropUtils')
var SCCacheHelper = require('SCCacheHelper');
var SCNetwork = require('SCNetwork');
var CommonUrlMap = require('CommonUrlMap');
var SCPropUtils = require('SCPropUtils');
var AppManager = require('AppManager');

class ChangeBrand extends Component {

  constructor(props) {
    super(props);
    var listDs = new ListView.DataSource({
      rowHasChanged: (r1, r2) => r1 !== r2
    });
    this.lastResultData = {};
    this.listData = [];
    this.allData = [];
    this.isLoading = false;
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
    SCNetwork.post(CommonUrlMap.SPACE_ROLE_MODEL_LIST, {
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
    //do something
    this.refreshData(this.state.gData);
    setTimeout(() => {
      resolve();
    }, 1000);
  }
  loadMore() {
    if (!this.isLoading && !this.state.isNoMore) {
      if (this.listData.length >= 10 && this.lastResultData.totalElements !== 'undefined' && this.lastResultData.totalElements > this.listData.length) {
        SCNetwork.post(CommonUrlMap.SPACE_ROLE_MODEL_LIST, {
          spaceId: this.state.gData.spaceId,
          token: this.state.gData.token
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
            }} onPress={() => console.log("Works!")} activeOpacity={0.7}/>

          <View style={styles.leftText}>
            <Text style={styles.leftTitle}>{rowData.name}</Text>
            <Text style={styles.leftDetail}>{rowData.intro.substring(0, 20)}</Text>
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

const ChangeBrandScreen = StackNavigator({
  ChangeBrand: {
    screen: ChangeBrand,
    navigationOptions: {
      header: ({navigation}) => {
        return (<CommonHeaderView goBack={() => SCNavigator.pop()} isShowBack={true} navigation={navigation} title={'切换名牌'}></CommonHeaderView>)
      }
    }
  }
}, {initialRouteName: 'ChangeBrand'});

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
module.exports = ChangeBrandScreen;
