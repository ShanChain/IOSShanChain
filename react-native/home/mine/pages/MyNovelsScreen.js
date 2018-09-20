/**
 * Created by flyye on 22/9/28.
* @providesModule MyNovelsScreen
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
var ImageBuilder = require('CommonImageBuilder');
var Dimensions = require('Dimensions');
var {
  width,
  height,
  scale,
  fontScale
} = Dimensions.get('window');
var Platform = require('Platform');
var screenScale = width / 375;
var CommonHeaderView = require('CommonHeaderView');
import {Avatar, List, ListItem} from 'react-native-elements'
var SCNavigator = require('SCNavigator');
var SCPropUtils = require('SCPropUtils')
var SCCacheHelper = require('SCCacheHelper');
var SCNetwork = require('SCNetwork');
var CommonUrlMap = require('CommonUrlMap');
import {PullList} from 'react-native-pull';

class ExpandListItem extends Component {
  constructor(props) {
    super(props);
    var listDs = new ListView.DataSource({
      rowHasChanged: (r1, r2) => r1 !== r2
    });
    this.lastResultData = {};
    this.listData = [];
    this.allData = [];
    this.isLoading = false;
    this.characterMap = [];
    this.state = {
      dataSource: listDs,
      isExpand: false,
      characterMap: {},
      listData: [],
      isNoMore: false
    }
    this.renderFooter = this.renderFooter.bind(this);
    this.loadMore = this.loadMore.bind(this);
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


          if (typeof(this.state.characterMap['characterId' + rowData.characterId]) !== 'undefined' && typeof(rowData) !== 'undefined') {
            if(Platform.OS === 'android'){
              SCNavigator.pushNativePage('page_novel_dynamic', JSON.stringify({
                gData: this.props.gData,
                data: {
                  novel: rowData,
                  character: this.state.characterMap['characterId' + rowData.characterId]
                }
              }));
            }else {

              SCNavigator.pushNativePage('SYStoryContentController', JSON.stringify({
                gData: this.props.gData,
                data: {
                  novel: rowData,
                  character: this.state.characterMap['characterId' + rowData.characterId]
                }
              }));
            }
          }
        }
}>
        <View style={styles.itemContainer}>
          <View style={{
              width: 15 * screenScale
            }}></View>
          <Avatar width={50 * screenScale} height={50 * screenScale} rounded={true} source={{
              uri: typeof(this.state.characterMap['characterId' + rowData.characterId]) === 'undefined'
                ? ''
                : this.state.characterMap['characterId' + rowData.characterId + ''].headImg
            }} onPress={() => {
              if (Platform.OS === 'android') {
                SCNavigator.pushNativePage('page_character_home', JSON.stringify({gData: this.props.gData, data: this.state.characterMap['characterId' + rowData.characterId]}));
              }else{
                SCNavigator.pushNativePage('SYFriendHomePageController', JSON.stringify({data:this.state.characterMap['characterId' + rowData.characterId]}));
              }
            }} activeOpacity={0.7}/>
          <View style={styles.leftText}>
            <Text style={styles.leftTitle}>{rowData.title.substring(0, 15)}</Text>
          </View>
        </View>
      </TouchableWithoutFeedback>
    </View>)
  }

  expandRefresh(preState) {
    if (!preState) {
      this.isLoading = true;
      SCNetwork.post(CommonUrlMap.GET_MY_STORY_LIST, {
        userId: this.props.gData.userId,
        token: this.props.gData.token,
        type: 2 + '',
        spaceId: this.props.rowData.spaceId + ''
      }).then(result => {
        let noMore = false;
        if (result.data.totalPages == (result.data.number + 1) || result.data.totalElements == 0) {
          noMore = true;
        }
        this.listData = result.data.content;
        this.lastResultData = result.data;
        this.isLoading = false;
        this.setState({
          listData: this.listData,
          isNoMore: noMore,
          isExpand: !preState
        });
        this.getHeadImg(result.data.content);
      }).catch(err => {
        this.isLoading = false;
      });
    } else {
      this.setState({
        isExpand: !preState
      })
    }
  }

  getHeadImg(list) {
    let characterIdList = [];
    list.forEach(function(value, index, arr) {
      if (characterIdList.indexOf(value.characterId) < 0) {
        characterIdList.push(value.characterId);
      }
    });
    SCNetwork.post(CommonUrlMap.GET_CHARACTER_BRIEF_INFO_LIST, {
      dataArray: JSON.stringify(characterIdList),
      token: this.props.gData.token
    }).then(result => {
      if (result.data.length > 0) {
        for (var i = 0; i < result.data.length; i++) {
          this.characterMap['characterId' + result.data[i].characterId] = result.data[i];
        }
        this.setState({characterMap: this.characterMap});
      }
    }).catch(err => {});
  }
  loadMore() {
    if (!this.isLoading && !this.state.isNoMore) {
      if (this.listData.length >= 10 && this.lastResultData.totalElements !== 'undefined' && this.lastResultData.totalElements > this.listData.length) {
        this.isLoading = true;
        SCNetwork.post(CommonUrlMap.GET_MY_STORY_LIST, {
          userId: this.props.gData.userId + '',
          type: 2 + '',
          token: this.props.gData.token,
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
          this.getHeadImg(result.data.content);
        }).catch(err => {
          this.isLoading = false;
        });

      }
    }

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
    if (this.state.isExpand) {
      return (<View style={{
          flexDirection: 'column',
          backgroundColor: '#FFFFFF'
        }}>
        <View style={{
            height: 0.5 * screenScale,
            backgroundColor: '#EEEEEE'
          }}></View>
        <TouchableWithoutFeedback onPress={() => this.expandRefresh(this.state.isExpand)}>
          <View style={{
              height: 60 * screenScale,
              flexDirection: 'row',
              marginLeft: 15 * screenScale,
              marginRight: 15 * screenScale,
              alignItems: 'center'
            }}>
            <Image style={{
                marginRight: 15 * screenScale,
                height: 6 * screenScale,
                width: 12 * screenScale
              }} source={ImageBuilder.getImage('common_btn_more_gray')}/>
            <Text>{this.props.rowData.name}</Text>
            <View style={{
                flex: 1
              }}></View>
          </View>
        </TouchableWithoutFeedback>
        <ListView renderRow={(rowData, sectionId, rowID) => this.renderRow(rowData, rowID)} dataSource={this.state.dataSource.cloneWithRows(this.state.listData)} enableEmptySections={true} onEndReached={this.loadMore} renderFooter={this.renderFooter}/>
      </View>)
    } else {
      return (<View style={{
          flexDirection: 'column',
          backgroundColor: '#FFFFFF'
        }}>
        <View style={{
            height: 0.5 * screenScale,
            backgroundColor: '#EEEEEE'
          }}></View>
        <TouchableWithoutFeedback onPress={() => this.expandRefresh(this.state.isExpand)}>
          <View style={{
              height: 60 * screenScale,
              flexDirection: 'row',
              marginLeft: 15 * screenScale,
              marginRight: 15 * screenScale,
              alignItems: 'center'
            }}>
            <Image style={{
                marginRight: 15 * screenScale,
                height: 12 * screenScale,
                width: 6 * screenScale
              }} source={ImageBuilder.getImage('common_right_arrow')}/>
            <Text>{this.props.rowData.name}</Text>
            <View style={{
                flex: 1
              }}></View>
          </View>
        </TouchableWithoutFeedback>
      </View>)
    }
  }

}

class MyNovels extends Component {

  constructor(props) {
    super(props);
    var listDs = new ListView.DataSource({
      rowHasChanged: (r1, r2) => r1 !== r2
    });
    let fromData = SCPropUtils.getPropsFromNative(props);
    this.state = {
      dataSource: listDs,
      gData: typeof(fromData.gData) === 'undefined'
        ? ''
        : fromData.gData,
      spaceNameMap: [],
      data: []
    };
    this.onPullRelease = this.onPullRelease.bind(this);
  }

  componentWillMount() {
    let gData = this.state.gData;
    this.refreshData(gData);
  }

  refreshData(gData) {
    SCNetwork.post(CommonUrlMap.GET_MY_SPACE_LIST, {
      userId: gData.userId + '',
      token: gData.token,
      type: 'novel'
    }).then(result => {
      this.setState({data: result.data})
    }).catch(err => {});

  }

  onPullRelease(resolve) {
    //do something
    this.refreshData(this.state.gData);
    setTimeout(() => {
      resolve();
    }, 1000);
  }

  renderRow(rowData, rowID) {
    return (<ExpandListItem rowData={rowData} gData={this.state.gData}></ExpandListItem>)
  }

  render() {
    return (<View style={styles.container}>
      <PullList style={{
          width: 375 * screenScale
        }} renderRow={(rowData, sectionId, rowID) => this.renderRow(rowData, rowID)} dataSource={this.state.dataSource.cloneWithRows(this.state.data)} onPullRelease={this.onPullRelease} enableEmptySections={true}/>
    </View>)
  }
}

const MyNovelsScreen = StackNavigator({
  MyNovels: {
    screen: MyNovels,
    navigationOptions: {
      header: ({navigation}) => {
        return (<CommonHeaderView goBack={() => SCNavigator.pop()} isShowBack={true} navigation={navigation} title={'我的小说'}></CommonHeaderView>)
      }
    }
  }
}, {initialRouteName: 'MyNovels'});

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
    alignItems: 'center',
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
module.exports = MyNovelsScreen;
