/**
 * Created by flyye on 2017/10/9.
* @providesModule RoleDetailScreen
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
  Button,
  ScrollView,
  ImageBackground,
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
var heightScale = height / 667;
import {Avatar, List, ListItem} from 'react-native-elements'
var CommonHeaderView = require('CommonHeaderView');
import {PullList} from 'react-native-pull';
var SCNavigator = require('SCNavigator');
var SCCacheHelper = require('SCCacheHelper');
var SCNetwork = require('SCNetwork');
var CommonUrlMap = require('CommonUrlMap');
var SCPropUtils = require('SCPropUtils');
var AppManager = require('AppManager');

class RoleDetail extends Component {

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
    this.focusMap = {};

    this.state = {
      dataSource: listDs,
      loginToken: typeof(props.loginToken) === 'undefined'
        ? ''
        : props.loginToken,
      modelId: typeof(fromData.modelId) === 'undefined'
        ? ''
        : fromData.modelId,
      gData: typeof(fromData.gData) === 'undefined'
        ? ''
        : fromData.gData,
      detailData: typeof(fromData.data) === 'undefined'
        ? ''
        : fromData.data,
      listData: [],
      focusMap: {},
      isFans: false,
      isNoMore: false
    };
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
      <View style={styles.itemContainer}>
        <View style={{
            width: 15 * screenScale
          }}></View>
        <Avatar width={60 * screenScale} height={60 * screenScale} rounded={true} source={{
            uri: rowData.headImg
          }} onPress={() => {
            if (isAndroid) {
              SCNavigator.pushNativePage('page_character_home', JSON.stringify({gData: this.state.gData, data: rowData}));
            }else{
              SCNavigator.pushNativePage('SYFriendHomePageController', JSON.stringify({data:rowData}));
            }
          }} activeOpacity={0.7}/>
        <View style={{
            flexDirection: 'row',
            flex: 1,
            marginRight: 15 * screenScale,
            marginLeft: 15 * screenScale
          }}>
          <View style={styles.leftText}>
            <Text style={styles.leftTitle}>{rowData.name + '.' + rowData.modelNo}</Text>
            <Text style={styles.leftDetail}>{rowData.signature.substring(0, 20)}</Text>
          </View>
          <View style={{
              flex: 1
            }}></View>
          <TouchableWithoutFeedback onPress={() => {
              if (this.state.gData.characterId == rowData.characterId || this.state.focusMap['characterId' + rowData.characterId]) {} else {
                SCNetwork.post(CommonUrlMap.ADD_CHATACTER_FOCUS, {
                  characterId: rowData.characterId + '',
                  funsCharacterId: this.state.gData.characterId + '',
                  token: this.state.gData.token
                }).then(result => {
                  this.focusMap['characterId' + rowData.characterId + ''] = true;
                  this.setState({focusMap: this.focusMap});
                }).catch(err => {});
              }
            }}>
            {
              this.state.gData.characterId == rowData.characterId || this.state.focusMap['characterId' + rowData.characterId]
                ? (
                  this.state.gData.characterId == rowData.characterId
                  ? (<View style={{
                      flexDirection: 'column',
                      alignItems: 'center',
                      justifyContent: 'center',
                      marginRight: 15 * screenScale
                    }}>
                    <Text style={{
                        fontSize: 12 * screenScale,
                        color: '#999999'
                      }}>自己</Text>
                  </View>)
                  : (<View style={{
                      flexDirection: 'column',
                      alignItems: 'center',
                      justifyContent: 'center',
                      marginRight: 15 * screenScale
                    }}>
                    <Image style={{
                        width: 22 * screenScale,
                        height: 22 * screenScale
                      }} source={ImageBuilder.getImage('common_focus_true')}></Image>
                    <Text style={{
                        fontSize: 12 * screenScale,
                        color: '#999999'
                      }}>已关注</Text>
                  </View>))
                : (<View style={{
                    flexDirection: 'column',
                    alignItems: 'center',
                    justifyContent: 'center',
                    marginRight: 15 * screenScale
                  }}>
                  <Image style={{
                      width: 22 * screenScale,
                      height: 22 * screenScale
                    }} source={ImageBuilder.getImage('common_add_follow')}></Image>
                  <Text style={{
                      fontSize: 12 * screenScale,
                      color: '#3BBAC8'
                    }}>加关注</Text>
                </View>)
            }

          </TouchableWithoutFeedback>
        </View>

      </View>
    </View>)
  }

  componentWillMount() {
    let gData = this.state.gData;
    this.refreshData(gData);
  }

  refreshData(gData) {
    if (this.state.detailData === '') {
      SCNetwork.post(CommonUrlMap.SPACE_ROLE_MODEL, {
        modelId: this.state.modelId + '',
        token: gData.token
      }).then(result => {
        this.setState({detailData: result.data})
        this.refreshListData(gData, result.data.modelId)
      }).catch(err => {});
    } else {
      this.refreshListData(gData, this.state.detailData.modelId)
    }

  }
  loadMore() {
    if (!this.isLoading && !this.state.isNoMore) {
      if (this.listData.length >= 10 && this.lastResultData.totalElements !== 'undefined' && this.lastResultData.totalElements > this.listData.length) {
        this.isLoading = true;
        SCNetwork.post(CommonUrlMap.FIND_CHARACTER_LIST_BY_MODEL, {
          modelId: this.state.detailData.modelId + '',
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
          this.refreshFocusMap(this.state.gData, result.data.content);
        }).catch(err => {
          this.isLoading = false;
        });

      }
    }

  }

  refreshListData(gData, modelId) {
    this.isLoading = true;
    SCNetwork.post(CommonUrlMap.FIND_CHARACTER_LIST_BY_MODEL, {
      modelId: modelId + '',
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
      this.refreshFocusMap(gData, result.data.content);
    }).catch(err => {
      this.isLoading = false;
    });
    SCNetwork.post(CommonUrlMap.GET_MODEL_FAV_STATUS, {
      checkId: modelId + '',
      spaceId: gData.spaceId,
      token: gData.token,
      userId: gData.userId
    }).then(result => {
      this.setState({isFans: result.data})
    }).catch(err => {});
  }

  refreshFocusMap(gData, characterArray) {
    let characterIdArray = [];
    for (var i = 0; i < characterArray.length; i++) {
      if (typeof(this.state.focusMap['characterId' + characterArray[i].characterId]) === 'undefined') {
        characterIdArray.push(characterArray[i].characterId)
      }
    }
    if (characterIdArray.length === 0) {
      return;
    }
    SCNetwork.post(CommonUrlMap.CHARACTER_FOCUS_CHECK, {
      checkIdList: JSON.stringify(characterIdArray),
      spaceId: gData.spaceId,
      token: gData.token,
      userId: gData.userId
    }).then(result => {
      for (var i = 0; i < result.data.length; i++) {
        this.focusMap['characterId' + result.data[i].characterId + ''] = result.data[i].check;
      }
      this.setState({focusMap: this.focusMap});
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
  render() {
    var data = this.state.detailData;
    var tagViewMap = [];
    var tagMap = typeof(data.tagMap) === 'undefined'
      ? []
      : data.tagMap;
    for (var i = 0; i < tagMap.length; i++) {
      if (i === tagMap.length) {
        tagViewMap.push(<View key={i}>
          <View style={{
              width: (
                tagMap[i].tagName.length > 4
                ? 80
                : 25 * tagMap[i].tagName.length) * screenScale,
              height: 25 * screenScale,
              alignItems: 'center',
              justifyContent: 'center',
              backgroundColor: '#BBBBBB',
              borderRadius: 13 * screenScale
            }}>
            <Text style={styles.tagText}>{tagMap[i].tagName}</Text>
          </View>
        </View>);
      } else {
        tagViewMap.push(<View key={i} style={{
            flexDirection: 'row'
          }}>
          <View style={{
              width: (
                tagMap[i].tagName.length > 4
                ? 80
                : 25 * tagMap[i].tagName.length) * screenScale,
              height: 25 * screenScale,
              alignItems: 'center',
              justifyContent: 'center',
              backgroundColor: '#BBBBBB',
              borderRadius: 13 * screenScale
            }}>
            <Text style={styles.tagText}>{data.tagMap[i].tagName}</Text>
          </View>
          <View style={{
              width: 10 * screenScale
            }}></View>
        </View>);
      }
    }
    return (<View style={styles.container}>
      <View style={{
          height: 40 * screenScale
        }}></View>
      <View style={{
          width: 375 * screenScale,
          height: 60 * screenScale,
          alignItems: 'center',
          justifyContent: 'center'
        }}>
        <Avatar width={60 * screenScale} height={60 * screenScale} rounded={true} source={{
            uri: data.headImg
          }} onPress={() => console.log("Works!")} activeOpacity={0.7}/>
        <TouchableWithoutFeedback onPress={() => {
            if (!this.state.isFans) {
              SCNetwork.post(CommonUrlMap.ADD_CHATACTER_SUPPORT, {
                modelId: this.state.detailData.modelId + '',
                token: this.state.gData.token,
                userId: this.state.gData.userId + ''
              }).then(result => {
                let data = this.state.detailData;
                data.supportNum++;
                this.setState({isFans: true, detailData: data});
              }).catch(err => {});
            } else {
              SCNetwork.post(CommonUrlMap.CANCEL_SUPPORT_CHARACTER, {
                modelId: this.state.detailData.modelId + '',
                token: this.state.gData.token,
                userId: this.state.gData.userId + ''
              }).then(result => {
                let data = this.state.detailData;
                data.supportNum--;
                this.setState({isFans: false, detailData: data});
              }).catch(err => {});
            }
          }}>
          <View style={{
              flexDirection: 'column',
              position: 'absolute',
              left: 250 * screenScale,
              width: 62 * screenScale,
              alignItems: 'center',
              justifyContent: 'center'
            }}>
            <Image style={{
                marginBottom: 5 * screenScale,
                height: 22 * screenScale,
                width: 22 * screenScale
              }} source={this.state.isFans
                ? ImageBuilder.getImage('common_like_true')
                : ImageBuilder.getImage('common_like_false')}/>
            <Text style={{
                fontSize: 12 * fontScale,
                color: '#B3B3B3'
              }}>{data.supportNum}比心</Text>
          </View>
        </TouchableWithoutFeedback>
      </View>

      <View style={{
          height: 10 * screenScale
        }}></View>
      <Text style={{
          fontSize: 15 * fontScale,
          color: '#666666'
        }}>{data.name}</Text>
      <View style={{
          flexDirection: 'row',
          height: 25 * screenScale,
          marginLeft: 92 * screenScale,
          marginRight: 92 * screenScale,
          alignItems: 'center',
          justifyContent: 'center',
          marginBottom: 15 * screenScale,
          marginTop: 15 * screenScale
        }}>
        {
          tagViewMap.map((elem, index) => {
            return elem;
          })
        }
      </View>
      <ScrollView style={{
          height: 50 * screenScale,
          width: 375 * screenScale,
          marginBottom: 15 * screenScale
        }}>
        <Text style={{
            fontSize: 12 * fontScale,
            color: '#666666',
            marginLeft: 15 * screenScale,
            marginRight: 15 * screenScale
          }}>
          {data.intro}
        </Text>
      </ScrollView>
      <TouchableWithoutFeedback onPress={() => {
          AppManager.switchRole({
            modelId: this.state.detailData.modelId + '',
            spaceId: this.state.detailData.spaceId + '',
            userId: this.state.gData.userId + ''
          });
        }}>
        <ImageBackground style={{
            width: 345 * screenScale,
            height: 44 * screenScale,
            borderRadius: 10 * screenScale,
            alignItems: 'center',
            justifyContent: 'center',
            marginBottom: 15 * screenScale
          }} source={ImageBuilder.getImage('common_btn_green')}>
          <Text style={{
              fontSize: 14 * fontScale,
              color: '#FFFFFF',
              backgroundColor: 'rgba(0,0,0,0)'
            }}>穿越成TA</Text>
        </ImageBackground>
      </TouchableWithoutFeedback>
      <View style={{
          width: 375 * screenScale,
          marginBottom: 8 * screenScale
        }}>
        <Text style={{
            fontSize: 12 * fontScale,
            color: '#B3B3B3',
            marginLeft: 15 * screenScale
          }}>目前有{this.state.listData.length}名穿越者持有TA的名牌</Text>
      </View>
      <ListView width={375 * screenScale} height={(266 + (height - 667) * screenScale) * screenScale} renderRow={(rowData, sectionId, rowID) => this.renderRow(rowData, rowID)} dataSource={this.state.dataSource.cloneWithRows(this.state.listData)} enableEmptySections={true} onEndReached={this.loadMore} renderFooter={this.renderFooter}/>
    </View>)
  }
}

const RoleDetailScreen = StackNavigator({
  RoleDetail: {
    screen: RoleDetail,
    navigationOptions: {
      header: ({navigation}) => {
        return (<CommonHeaderView goBack={() => SCNavigator.pop()} isShowBack={true} navigation={navigation} title={'人物概况'}></CommonHeaderView>)
      }
    }
  }
}, {initialRouteName: 'RoleDetail'});

const styles = StyleSheet.create({
  container: {
    flexDirection: 'column',
    backgroundColor: '#FFFFFF',
    alignItems: 'center',
    justifyContent: 'center'
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
    flexDirection: 'column',
    alignItems: 'flex-start',
    width: 226 * screenScale
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
  },
  tagText: {
    fontSize: 12 * fontScale,
    color: '#FFFFFF',
    borderRadius: 13 * screenScale
  },
  tagContainer: {
    width: 50 * screenScale,
    height: 25 * screenScale,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#BBBBBB',
    borderRadius: 13 * screenScale
  }

});
module.exports = RoleDetailScreen;
