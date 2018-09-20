/**
 * Created by flyye on 22/9/17.
 * @providesModule MinePage
 *
 */
'use strict';

import React, {Component} from 'react';
import {
  StyleSheet,
  Text,
  View,
  ActivityIndicator,
  Image,
  ScrollView,
  TouchableWithoutFeedback,
  ToastAndroid,
  ImageBackground
} from 'react-native';
import {StackNavigator} from 'react-navigation';
import {Avatar} from 'react-native-elements';
import Platform from 'Platform';
var isAndroid = Platform.OS === 'android';
var ImageBuilder = require('./utils/ImageBuilder');
var Dimensions = require('Dimensions');
var {
  width,
  height,
  scale,
  fontScale
} = Dimensions.get('window');
var screenScale = width / 375;
var SCNavigator = require('SCNavigator');
var SCCacheHelper = require('SCCacheHelper');
var SCNetwork = require('SCNetwork');
var CommonUrlMap = require('CommonUrlMap');
var SCInputAlertDialog = require('SCInputAlertDialog');
import {PullView} from 'react-native-pull';
var SCPropUtils = require('SCPropUtils');

class MinePage extends Component {

  constructor(props) {
    super(props);
    let fromData = SCPropUtils.getPropsFromNative(props);
    this.state = {
      gData: typeof(fromData.gData) === 'undefined'
        ? ''
        : fromData.gData,
      mineData: {},
      backgroundImg: '',
      isEditSignature: false
    };
    this.onPullRelease = this.onPullRelease.bind(this);
  }
  onPullRelease(resolve) {
    this.refreshData(this.state.gData);
    setTimeout(() => {
      resolve();
    }, 1000);
  }

  componentWillMount() {
    if (typeof(this.state.gData) !== 'undefined' && this.state.gData !== '') {
      this.refreshData(this.state.gData);
    }
  }

  refreshData(data) {
    SCNetwork.post(CommonUrlMap.FIND_CHARACTER_BY_CHARID, {
      characterId: data.characterId,
      token: data.token
    }).then(result => {
      this.setState({mineData: result.data})
      SCCacheHelper.setCache(data.userId, 'characterInfo', JSON.stringify(result.data))
    }).catch(err => {});
    SCNetwork.post(CommonUrlMap.FIND_BACKGROUND_BY_USER, {
      userId: data.userId,
      token: data.token
    }).then(result => {
      this.setState({backgroundImg: result.data.background})
    }).catch(err => {});
  }

  render() {
    return (<PullView style={{
        width: Dimensions.get('window').width
      }} onPullRelease={this.onPullRelease}>
      <View style={styles.container}>
        <ImageBackground source={{
            uri: this.state.backgroundImg
          }} style={{
            flexDirection: 'column',
            alignItems: 'center',
            alignContent: 'center',
            width: width,
            flex:1
        }}>
          <View style={{
              height: 20 * screenScale
            }}></View>
          <Avatar width={70} height={70} rounded={true} source={{
              uri: this.state.mineData.headImg
            }} onPress={() => console.log("Works!")} activeOpacity={0.7}/>
          <View style={{
              height: 0
            }}>
            <TouchableWithoutFeedback onPress={() => {
                SCInputAlertDialog.show({placeHolder: '想说点什么？', title: '发表签名'}).then((value) => {
                  SCNetwork.post(CommonUrlMap.CHANGE_USER_CHARACTER, {
                    userId: this.state.gData.userId,
                    token: this.state.gData.token,
                    characterId: this.state.gData.characterId,
                    dataString: JSON.stringify({signature: value.input})
                  }).then(result => {
                    this.setState({mineData: result.data})
                  }).catch(err => {});
                })
              }}>

              <View style={{
                  width: 60 * screenScale,
                  height: 20 * screenScale,
                  position: 'relative',
                  top: -57 * screenScale,
                  left: 84 * screenScale,
                  backgroundColor: 'rgba(0.3,0,0,0)',
                  flexDirection: 'row',
                  margin: 4 * screenScale
                }}>
                <Image style={{
                    width: 10 * screenScale,
                    height: 10 * screenScale,
                    marginRight: 4 * screenScale
                  }} source={ImageBuilder.getImage('modify_btn')}/>
                <Text style={{
                    fontSize: 10 * screenScale,
                    color: '#FFFFFF'
                  }}>修改签名</Text>
              </View>

            </TouchableWithoutFeedback>
          </View>
          <Text style={{
              color: '#FFFFFF',
              fontSize: 18 * fontScale,
              marginBottom: 5 * width / 375,
              backgroundColor: 'rgba(0,0,0,0)'
            }}>{this.state.mineData.name}
            . {this.state.mineData.modelNo}</Text>
          <Text style={{
              color: '#FFFFFF',
              fontSize: 12 * fontScale,
              backgroundColor: 'rgba(0,0,0,0)'
            }}>{this.state.mineData.signature}</Text>
        </ImageBackground>
        <View style={{
            width: width,
            height: width * 100 / 375,
            flexDirection: 'row'
          }}>

          <TouchableWithoutFeedback onPress={() => SCNavigator.pushRNPage('ChangeBrandScreen', JSON.stringify({gData: this.state.gData}))}>

            <View style={styles.itemContainer}>
              <Image style={{
                  marginTop: 10 * screenScale,
                  width: 24 * screenScale,
                  height: 26 * screenScale
                }} source={ImageBuilder.getImage('role_switch')}></Image>
              <Text style={styles.grayText}>
                切换名牌
              </Text>
            </View>
          </TouchableWithoutFeedback>
        </View>
        <View style={{
            height: 0,
            alignItems: 'center'
          }}>
          <View style={{
              flexDirection: 'row',
              backgroundColor: '#FFFFFF',
              width: 140 * screenScale,
              height: 36 * screenScale,
              position: 'relative',
              top: -118 * screenScale,
              borderRadius: 17 * screenScale,
              alignItems: 'center',
              borderColor: '#B3B3B3',
              borderWidth: 1
            }}>
            <TouchableWithoutFeedback onPress={() => {
                if (isAndroid) {
                  SCNavigator.pushNativePage('page_contact', '')
                }else {
                  SCNavigator.pushNativePage('SYContactsController', '')
                }
              }
}>
              <View style={{
                  justifyContent: 'center',
                  alignItems: 'center',
                  flex: 1
                }}>
                <Text style={{
                    fontSize: 12 * fontScale,
                    color: '#666666'
                  }}>
                  关注
                </Text>
              </View>
            </TouchableWithoutFeedback>
            <View style={{
                width: 1 * screenScale,
                height: 15 * screenScale,
                backgroundColor: '#666666'
              }}></View>
            <TouchableWithoutFeedback onPress={() => {
                if (isAndroid) {
                  SCNavigator.pushNativePage('page_contact', '')
                }else {
                  SCNavigator.pushNativePage('SYContactsController', '')
                }
              }
}>
              <View style={{
                  justifyContent: 'center',
                  alignItems: 'center',
                  flex: 1
                }}>
                <Text style={{
                    fontSize: 12 * fontScale,
                    color: '#666666'
                  }}>
                  粉丝
                </Text>
              </View>
            </TouchableWithoutFeedback>
          </View>
        </View>
        <View style={{
            height: 1
          }}></View>
        <View style={{
            width: width,
            height: width * 90 / 375,
            flexDirection: 'row'
          }}>
          <TouchableWithoutFeedback onPress={() => {
                  SCNavigator.pushRNPage('MyStorysScreen',JSON.stringify({gData:this.state.gData}))
            }
}>
            <View style={styles.itemContainer}>
              <Image style={{
                  width: 22 * screenScale,
                  height: 22 * screenScale
                }} source={ImageBuilder.getImage('story_btn')}></Image>
              <Text style={styles.grayText}>
                我的故事
              </Text>
            </View>
          </TouchableWithoutFeedback>
          <View style={{
              width: 1
            }}></View>
          <TouchableWithoutFeedback onPress={() => SCNavigator.pushRNPage('MyRolesScreen', JSON.stringify({gData: this.state.gData}))}>

            <View style={styles.itemContainer}>
              <Image style={{
                  width: 22 * screenScale,
                  height: 18 * screenScale
                }} source={ImageBuilder.getImage('my_role')}></Image>
              <Text style={styles.grayText}>
                我扮演过的
              </Text>
            </View>
          </TouchableWithoutFeedback>
          <View style={{
              width: 1
            }}></View>
          <TouchableWithoutFeedback onPress={() => SCNavigator.pushRNPage('MyNovelsScreen', JSON.stringify({gData: this.state.gData}))}>

            <View style={styles.itemContainer}>
              <Image style={{
                  width: 22 * screenScale,
                  height: 18 * screenScale
                }} source={ImageBuilder.getImage('my_long_text')}></Image>
              <Text style={styles.grayText}>
                我的小说
              </Text>
            </View>
          </TouchableWithoutFeedback>
        </View>
        <View style={{
            height: 1
          }}></View>
        <View style={{
            width: width,
            height: width * 90 / 375,
            flexDirection: 'row'
          }}>
          {/* <TouchableWithoutFeedback
                          onPress={() => SCNavigator.pushRNPage('MyDramasScreen',JSON.stringify({gData:this.state.gData}))}>

                            <View style={styles.itemContainer}>
                                <Image style={{width: 22 * screenScale, height: 14 * screenScale}}
                                       source={ImageBuilder.getImage('my_drama')}></Image>
                                <Text style={styles.grayText}>
                                    我的戏文
                                </Text>
                            </View>
                        </TouchableWithoutFeedback>
                        <View style={{width: 1}}></View> */
          }
          <TouchableWithoutFeedback onPress={() => {
            SCNavigator.pushRNPage('MyPraisesScreen',JSON.stringify({gData:this.state.gData}))
            }
}>
            <View style={styles.itemContainer}>
              <Image style={{
                  width: 22 * screenScale,
                  height: 22 * screenScale
                }} source={ImageBuilder.getImage('my_thumbsup')}></Image>
              <Text style={styles.grayText}>
                我赞过的
              </Text>
            </View>
          </TouchableWithoutFeedback>
          <View style={{
              width: 1
            }}></View>
          <TouchableWithoutFeedback onPress={() => {
          SCNavigator.pushRNPage('MyCommentsScreen',JSON.stringify({gData:this.state.gData}))
            }
}>
            <View style={styles.itemContainer}>
              <Image style={{
                  width: 22 * screenScale,
                  height: 22 * screenScale
                }} source={ImageBuilder.getImage('my_comment')}></Image>
              <Text style={styles.grayText}>
                我的评论
              </Text>
            </View>
          </TouchableWithoutFeedback>
          <View style={{
              width: 1
            }}></View>
          <TouchableWithoutFeedback onPress={() => SCNavigator.pushRNPage('AboutMeScreen', JSON.stringify({gData: this.state.gData}))}>

            <View style={styles.itemContainer}>
              <Image style={{
                  width: 22 * screenScale,
                  height: 22 * screenScale
                }} source={ImageBuilder.getImage('my_data')}></Image>
              <Text style={styles.grayText}>
                我的资料
              </Text>
            </View>
          </TouchableWithoutFeedback>
        </View>
        <View style={{
            height: 1
          }}></View>
        <View style={{
            width: width,
            height: width * 90 / 375,
            flexDirection: 'row'
          }}>
          <TouchableWithoutFeedback onPress={() => SCNavigator.pushRNPage('SettingScreen', JSON.stringify({gData: this.state.gData}))}>
            <View style={styles.itemContainer}>
              <Image style={{
                  width: 22 * screenScale,
                  height: 22 * screenScale
                }} source={ImageBuilder.getImage('setting_btn')}></Image>

              <Text style={styles.grayText}>
                设置
              </Text>
            </View>
          </TouchableWithoutFeedback>
          <View style={{
              width: 1
            }}></View>
            {/*<TouchableWithoutFeedback onPress={() => SCNavigator.pushRNPage('FramePage', JSON.stringify({gData: this.state.gData}))}>*/}
                {/*<View style={styles.itemContainer}>*/}
                    {/*<Image style={{*/}
                        {/*width: 22 * screenScale,*/}
                        {/*height: 22 * screenScale*/}
                    {/*}} source={ImageBuilder.getImage('setting_btn')}></Image>*/}

                    {/*<Text style={styles.grayText}>*/}
                        {/*设置*/}
                    {/*</Text>*/}
                {/*</View>*/}
            {/*</TouchableWithoutFeedback>*/}
          <View style={{
              flex: 1
            }}></View>
            <View style={{
                flex: 1
            }}></View>
        </View>
      </View>
    </PullView>);
  }
};

const styles = StyleSheet.create({
    container: {
        flexDirection: 'column',
        backgroundColor: '#EEEEEE',
        height: height-103*screenScale
    },
  itemContainer: {
    flex: 1,
    flexDirection: 'column',
    backgroundColor: '#FFFFFF',
    alignItems: 'center',
    justifyContent: 'center'
  },
  grayText: {
    fontSize: 12 * fontScale,
    color: '#666666',
    marginTop: 10 * screenScale
  }
});
module.exports = MinePage;
