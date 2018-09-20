/**
 * Created by flyye on 22/9/28.
* @providesModule SpaceBGChooseImgScreen
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
import {Avatar, List, ListItem} from 'react-native-elements'
var SCNavigator = require('SCNavigator');
var SCNetwork = require('SCNetwork');
var CommonUrlMap = require('CommonUrlMap')
var SCCacheHelper = require('SCCacheHelper')
var SCPropUtils = require('SCPropUtils')

class SpaceBGChooseImgScreen extends Component {

  constructor(props) {
    super(props);
    var listDs = new ListView.DataSource({
      rowHasChanged: (r1, r2) => r1 !== r2
    });
    let fromData = SCPropUtils.getPropsFromNative(props);
    this.state = {
      dataSource: listDs,
      fromData: fromData,
      checkData: {
        rowId: 0,
        column: 0
      },
      chooseData: {},
      data: []
    };
  }

  renderRow(rowData, rowID) {
    return (<View style={{
        flexDirection: 'column'
      }}>
      <View style={{
          height: 5 * screenScale
        }}></View>
      <View style={styles.itemContainer}>
        <View style={{
            width: 5 * screenScale
          }}></View>
        <View style={{
            alignItems: 'center',
            justifyContent: 'center'
          }}>
          <View style={{
              flexDirection: 'row'
            }}>
            <TouchableWithoutFeedback onPress={() => this.setState({
                chooseData: rowData.bgUrl1,
                checkData: {
                  rowId: rowID,
                  column: 0
                }
              })}>
              <Image style={{
                  width: 180 * screenScale,
                  height: 115 * screenScale
                }} source={{
                  uri: rowData.bgUrl1.picUrl
                }}>
                <Image style={{
                    width: 22 * screenScale,
                    height: 22 * screenScale,
                    position: 'absolute',
                    right: 8 * screenScale,
                    top: 12 * screenScale
                  }} source={(
                    rowID == this.state.checkData.rowId && this.state.checkData.column == 0)
                    ? ImageBuilder.getImage('check_true')
                    : ImageBuilder.getImage('check_false')}></Image>
              </Image>
            </TouchableWithoutFeedback>
            <View style={{
                width: 5 * screenScale
              }}></View>
            <TouchableWithoutFeedback onPress={() => this.setState({
                chooseData: rowData.bgUrl2,
                checkData: {
                  rowId: rowID,
                  column: 1
                }
              })}>
              <Image style={{
                  width: 180 * screenScale,
                  height: 115 * screenScale
                }} source={{
                  uri: typeof(rowData.bgUrl2) === 'undefined'
                    ? ''
                    : rowData.bgUrl2.picUrl
                }}>
                <Image style={{
                    width: 22 * screenScale,
                    height: 22 * screenScale,
                    position: 'absolute',
                    right: 8 * screenScale,
                    top: 12 * screenScale
                  }} source={(
                    rowID == this.state.checkData.rowId && this.state.checkData.column == 1)
                    ? ImageBuilder.getImage('check_true')
                    : ImageBuilder.getImage('check_false')}></Image>
              </Image>
            </TouchableWithoutFeedback>
          </View>
        </View>
      </View>
    </View>)
  }
  changeBackground(gData) {
    SCNetwork.post(CommonUrlMap.MODIFY_SPACE, {
      dataString: JSON.stringify({background: this.state.chooseData.picUrl}),
      spaceId: gData.spaceId + '',
      token: gData.token
    }).then(result => {
      SCNavigator.pop();
    }).catch(err => {});
  }
  componentWillMount() {
    let gData = this.state.fromData.gData;
    this.refreshData(gData);
  }

  refreshData(gData) {
    SCNetwork.post(CommonUrlMap.GET_SPACE_IMGS, {
      spaceId: gData.spaceId + '',
      token: gData.token
    }).then(result => {
      let combineData = [];
      if (result.data.content.length > 0) {
        var i = 0;
        while (i < result.data.content.length) {
          if (result.data.content[i]) {
            let arrUnit = {
              bgUrl1: {},
              bgUrl2: {}
            };
            arrUnit.bgUrl1 = result.data.content[i];
            if ((result.data.content[i + 1])) {
              arrUnit.bgUrl2 = result.data.content[i + 1];
              i = i + 1;
            }
            i++;
            combineData.push(arrUnit);

          }
        }
      }
      if (typeof(this.state.chooseData.picUrl) === 'undefined' && combineData.length > 0) {
        this.setState({chooseData: combineData[0].bgUrl1});
      }
      this.setState({data: combineData});
    }).catch(err => {});
  }

  render() {
    return (<View style={{
        flexDirection: 'column',
        backgroundColor: '#FFFFFF'
      }}>
      <View style={styles.headerContainer}>
        <TouchableWithoutFeedback onPress={() => {
            SCNavigator.pop()
          }}>
          <View style={{
              position: 'absolute',
              left: 0,
              height: 40 * screenScale,
              width: 50 * screenScale,
              justifyContent: 'center'
            }}>
            <Image style={styles.headerBack} source={ImageBuilder.getImage('btn_back')}/>
          </View>
        </TouchableWithoutFeedback>
        <Text style={styles.headerText}>背景图册</Text>
        <TouchableWithoutFeedback onPress={() => {
            this.changeBackground(this.state.fromData.gData);
          }}>
          <View style={{
              position: 'absolute',
              right: 0,
              height: 40 * screenScale,
              width: 50 * screenScale,
              justifyContent: 'center'
            }}>
            <Text style={{
                fontSize: 16 * fontScale,
                color: '#333333'
              }}>确定</Text>
          </View>
        </TouchableWithoutFeedback>
      </View>
      <View style={{
          height: 1,
          backgroundColor: '#EEEEEE'
        }}></View>
      <ListView renderRow={(rowData, sectionId, rowID) => this.renderRow(rowData, rowID)} dataSource={this.state.dataSource.cloneWithRows(this.state.data)} enableEmptySections={true}/>
    </View>)
  }
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'column',
    flex: 1,
    backgroundColor: '#FFFFFF',
    alignItems: 'center'
  },
  itemContainer: {
    flexDirection: 'row',
    backgroundColor: '#FFFFFF',
    alignItems: 'center'
  },
  spaceName: {
    fontSize: 12 * fontScale,
    color: '#3BBAC8'
  },
  title: {
    height: 56 * screenScale,
    fontSize: 16 * fontScale,
    marginBottom: 5 * screenScale,
    color: '#333333'
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
module.exports = SpaceBGChooseImgScreen;
