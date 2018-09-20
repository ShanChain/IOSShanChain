/**
 * Created by flyye on 22/9/28.
* @providesModule SpaceBGImgScreen
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
var SCNavigator = require('SCNavigator');
var SCNetwork = require('SCNetwork');
var CommonUrlMap = require('CommonUrlMap');
var SCCacheHelper = require('SCCacheHelper');
var SCPropUtils = require('SCPropUtils');
var SCBottomAlertDialog = require('SCBottomAlertDialog');
var SCPhotoPicker = require('SCPhotoPicker');

class SpaceBGImgScreen extends Component {

  constructor(props) {
    super(props);
    var listDs = new ListView.DataSource({
      rowHasChanged: (r1, r2) => r1 !== r2
    });
    this.checkData = {};
    this.deleteData = {};
    let fromData = SCPropUtils.getPropsFromNative(props);
    this.state = {
      dataSource: listDs,
      fromData: fromData,
      data: [],
      isDeleteState: false,
      checkData: {},
      deleteData: {}

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

          {
            this.state.isDeleteState
              ? (<View style={{
                  flexDirection: 'row'
                }}>
                <TouchableWithoutFeedback onPress={() => {
                    if (this.state.checkData[rowID + 'and' + '0']) {
                      this.checkData[rowID + 'and' + '0'] = false;
                      this.deleteData[rowID + 'and' + '0'] = '';
                      this.setState({checkData: this.checkData, deleteData: this.deleteData});
                    } else {
                      this.checkData[rowID + 'and' + '0'] = true;
                      this.deleteData[rowID + 'and' + '0'] = rowData.bgUrl1.id + '';
                      this.setState({checkData: this.checkData, deleteData: this.deleteData});
                    }
                  }}>
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
                      }} source={this.state.checkData[rowID + 'and' + '0']
                        ? ImageBuilder.getImage('check_true')
                        : ImageBuilder.getImage('check_false')}></Image>
                  </Image>
                </TouchableWithoutFeedback>
                <View style={{
                    width: 5 * screenScale
                  }}></View>
                <TouchableWithoutFeedback onPress={() => {
                    if (this.state.checkData[rowID + 'and' + '1']) {
                      this.checkData[rowID + 'and' + '1'] = false;
                      this.deleteData[rowID + 'and' + '1'] = '';
                      this.setState({checkData: this.checkData, deleteData: this.deleteData});
                    } else {
                      this.checkData[rowID + 'and' + '1'] = true;
                      this.deleteData[rowID + 'and' + '1'] = rowData.bgUrl2.id + '';
                      this.setState({checkData: this.checkData, deleteData: this.deleteData});
                    }
                  }}>
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
                      }} source={this.state.checkData[rowID + 'and' + '1']
                        ? ImageBuilder.getImage('check_true')
                        : ImageBuilder.getImage('check_false')}></Image>
                  </Image>
                </TouchableWithoutFeedback>
              </View>)
              : (<View style={{
                  flexDirection: 'row'
                }}>
                <Image resizeMode={Image.resizeMode.cover} style={{
                    width: 180 * screenScale,
                    height: 115 * screenScale
                  }} source={{
                    uri: rowData.bgUrl1.picUrl
                  }}/>
                <View style={{
                    width: 5 * screenScale
                  }}></View>
                <Image resizeMode={Image.resizeMode.cover} style={{
                    width: 180 * screenScale,
                    height: 115 * screenScale
                  }} source={{
                    uri: typeof(rowData.bgUrl2) === 'undefined'
                      ? ''
                      : rowData.bgUrl2.picUrl
                  }}/>
              </View>)
          }

        </View>
      </View>
    </View>)
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
            if (this.state.isDeleteState) {
              var deleteIdArray = [];
              for (var key in this.state.deleteData) {
                if (this.state.deleteData[key].length > 0) {
                  deleteIdArray.push(this.state.deleteData[key]);
                }
              }
              SCNetwork.post(CommonUrlMap.DELETE_SPACE_IMGS, {
                jArray: JSON.stringify(deleteIdArray),
                spaceId: this.state.fromData.gData.spaceId + '',
                token: this.state.fromData.gData.token
              }).then(result => {
                this.setState({isDeleteState: false});
                this.refreshData(this.state.fromData.gData);
              }).catch(err => {});
            } else {
              SCBottomAlertDialog.show({0: '上传', 1: '删除', 2: '取消'}).then((key) => {
                if (key == 0) {
                  SCPhotoPicker.selectPhoto().then((result) => {
                    SCBottomAlertDialog.dismiss();
                    if (result.length > 0) {
                      let options = {
                        filePaths: result
                      };
                      SCNetwork.uploadImg(options).then((result) => {
                        let urlArr = [];
                        result.forEach(function(value, index, array) {
                          urlArr.push(value + '?x-oss-process=image/resize,m_mfit,h_240,w_375');
                        })
                        if (urlArr.length > 0) {
                          SCNetwork.post(CommonUrlMap.ADD_SPACE_IMG, {
                            urlArray: JSON.stringify(urlArr),
                            spaceId: this.state.fromData.gData.spaceId + '',
                            token: this.state.fromData.gData.token,
                            userId: this.state.fromData.gData.userId
                          }).then(result => {

                            this.refreshData(this.state.fromData.gData);
                          }).catch(err => {});
                        }
                      }).catch((err) => {});
                    }
                  });
                } else if (key == 1) {
                  this.setState({isDeleteState: true})
                } else {
                  SCBottomAlertDialog.dismiss();
                }
              }).catch((err) => {});
            }
          }}>
          <View style={{
              position: 'absolute',
              right: 0,
              height: 40 * screenScale,
              width: 50 * screenScale,
              justifyContent: 'center'
            }}>
            {
              this.state.isDeleteState
                ? (<Text style={{
                    fontSize: 16 * fontScale,
                    color: '#333333'
                  }}>确定</Text>)
                : (<Image style={{
                    height: 7 * screenScale,
                    width: 23 * screenScale
                  }} source={CommonImageBuilder.getImage('common_menu')}/>)
            }

          </View>
        </TouchableWithoutFeedback>
      </View>
      <View style={{
          height: 1,
          backgroundColor: '#FFFFFF'
        }}></View>
      <ListView renderRow={(rowData, sectionId, rowID) => this.renderRow(rowData, rowID)} dataSource={this.state.dataSource.cloneWithRows(this.state.data)} enableEmptySections={true}/>
    </View>)
  }
}

// const SpaceBGImgScreen = StackNavigator({
//   SpaceBGImg: {
//     screen: SpaceBGImg,
//     navigationOptions: {
//     header: ({navigation}) => {
//       return (<CommonHeaderView goBack={() => SCNavigator.pop()}
//         isShowRightImg={true}
//         rightImg={CommonImageBuilder.getImage('common_menu')}
//         rightAction={() => {
//         SCBottomAlertDialog.show({0:'上传',1:'删除',2:'取消'}).then((key) => {
//           console.log(key)
//           if(key == 2){
//
//           }else if (key == 1) {
//
//           }else {
//           SCBottomAlertDialog.dismiss();
//           }
//         }).catch((err) => {
//           console.log(err);
//         });
//         }}
//         rightStyle={{width:23 * screenScale,height:7 * screenScale}}
//          isShowBack={true} navigation={navigation} title={'背景图册'} ></CommonHeaderView>)
//     } ,
//   }
//   }
// },
// {
//    initialRouteName: 'SpaceBGImg'
// });

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
module.exports = SpaceBGImgScreen;
