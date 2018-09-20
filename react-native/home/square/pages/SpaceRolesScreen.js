/**
 * Created by flyye on 22/9/28.
 *
* @providesModule SpaceRolesScreen
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
import {Avatar, List, ListItem} from 'react-native-elements'
import {PullList} from 'react-native-pull';
var SCNavigator = require('SCNavigator');
var CommonHeaderView = require('CommonHeaderView');
var SCNetwork = require('SCNetwork');
var CommonUrlMap = require('CommonUrlMap')
var SCCacheHelper = require('SCCacheHelper')
var SCPropUtils = require('SCPropUtils')

class SpaceRoles extends Component {

  constructor(props) {
    super(props);
    let userId = '';
    let loginToken = '';
    var listDs = new ListView.DataSource({
      rowHasChanged: (r1, r2) => r1 !== r2
    });
    this.lastResultData = {};
    this.listData = [];
    this.allData = [];
    this.spaceNameMap = {};
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
      if (result.data.totalPages == (result.data.number + 1 || result.data.totalElements == 0)) {
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
    this.refreshData(this.state.gData);
    setTimeout(() => {
      resolve();
    }, 1000);
  }

  loadMore() {
    if (!this.isLoading && !this.state.isNoMore) {
      this.isLoading = true;
      if (this.listData.length >= 10 && this.lastResultData.totalElements !== 'undefined' && this.lastResultData.totalElements > this.listData.length) {
        SCNetwork.post(CommonUrlMap.SPACE_ROLE_MODEL_LIST, {
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
    let gData = this.state.gData;
    return (<View style={{
        flexDirection: 'column'
      }}>
      <View style={{
          height: 0.5 * screenScale,
          backgroundColor: '#EEEEEE'
        }}></View>
      <TouchableWithoutFeedback onPress={() => SCNavigator.pushRNPage('RoleDetailScreen', JSON.stringify({gData: gData, data: rowData}))}>
        <View style={styles.itemContainer}>
          <View style={{
              width: 15 * screenScale
            }}></View>
          <Avatar width={50 * screenScale} height={50 * screenScale} rounded={true} source={{
              uri: rowData.headImg
            }} onPress={() => console.log("Works!")} activeOpacity={0.7}/>
          <View style={{
              flexDirection: 'row',
              flex: 1,
              marginRight: 15 * screenScale,
              marginLeft: 15 * screenScale
            }}>
            <View style={styles.leftText}>
              <Text style={styles.leftTitle}>{rowData.name}</Text>
              <Text style={styles.leftDetail}>{
                  rowData.intro.substring(
                    0, rowData.intro.length > 30
                    ? 30
                    : rowData.intro.length)
                }</Text>
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

const SpaceRolesScreen = StackNavigator({
  SpaceRoles: {
    screen: SpaceRoles,
    navigationOptions: {
      header: ({navigation}) => {
        return (<CommonHeaderView goBack={() => SCNavigator.pop()} isShowRightImg={true} rightStyle={{width: 20 * screenScale,
            height: 20 * screenScale}} rightImg={ImageBuilder.getImage('common_add')} rightAction={() => {
          if(isAndroid){
            SCNavigator.pushNativePage('page_add_role', '');
          }else {
            SCNavigator.pushNativePage('SYAuxiliaryAddController', JSON.stringify({
              data: {
                type: 'add_role'
              }
            }))
          }

        }} isShowBack={true} navigation={navigation} title={'人物'}/>)
      }
    }
  },
  RoleDetail: {
    screen: require('./RoleDetailScreen')
  }
}, {initialRouteName: 'SpaceRoles'});

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
    marginBottom: 13 * screenScale
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
    flex: 1,
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
module.exports = SpaceRolesScreen;
