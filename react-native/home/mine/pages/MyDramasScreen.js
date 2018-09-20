/**
 * Created by flyye on 22/9/28.
* @providesModule MyDramasScreen
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
  ListView
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
    this.state = {
      dataSource: listDs,
      isExpand: false,
      headImgMap: {},
      listData: []
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
      <TouchableWithoutFeedback onPress={() => SCNavigator.pushNativePage('ChangeBrandScreen', JSON.stringify({gData: this.props.gData, data: rowData}))}>
        <View style={styles.itemContainer}>
          <View style={{
              width: 15 * screenScale
            }}></View>
          <Avatar width={50 * screenScale} height={50 * screenScale} rounded={true} source={{
              uri: typeof(this.state.headImgMap['characterId' + rowData.characterId]) === 'undefined'
                ? ''
                : this.state.headImgMap['characterId' + rowData.characterId + '']
            }} onPress={() => console.log("Works!")} activeOpacity={0.7}/>
          <View style={styles.leftText}>
            <Text style={styles.leftTitle}>{rowData.title.substring(0, 15)}</Text>
          </View>
        </View>
      </TouchableWithoutFeedback>
    </View>)
  }

  expandRefresh(preState) {
    if (!preState) {
      SCNetwork.post(CommonUrlMap.GET_MY_STORY_LIST, {
        userId: this.props.gData.userId,
        token: this.props.gData.token,
        type: 2 + '',
        spaceId: this.props.rowData.spaceId + ''
      }).then(result => {
        this.setState({
          listData: result.data.content,
          isExpand: !preState
        });
        this.getHeadImg(result.data.content);
      }).catch(err => {});
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
        var headImgMap = {};
        result.data.forEach(function(value, index, arr) {
          headImgMap['characterId' + value.characterId] = value.headImg;
        });
        this.setState({headImgMap: headImgMap});
      }
    }).catch(err => {});
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
        <ListView renderRow={(rowData, sectionId, rowID) => this.renderRow(rowData, rowID)} dataSource={this.state.dataSource.cloneWithRows(this.state.listData)} enableEmptySections={true}/>
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

class MyDramas extends Component {

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
    if (gData.userId.length == 0) {
      console.log('todo: go to login')
      return;
    }
    SCNetwork.post(CommonUrlMap.GET_MY_SPACE_LIST, {
      userId: gData.userId + '',
      token: gData.token,
      type: 'game'
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

const MyDramasScreen = StackNavigator({
  MyDramas: {
    screen: MyDramas,
    navigationOptions: {
      header: ({navigation}) => {
        return (<CommonHeaderView goBack={() => SCNavigator.pop()} isShowBack={true} navigation={navigation} title={'我的大戏'}></CommonHeaderView>)
      }
    }
  }
}, {initialRouteName: 'MyDramas'});

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
module.exports = MyDramasScreen;
