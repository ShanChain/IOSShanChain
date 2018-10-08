/**
 * Created by flyye on 22/9/25.
 * @providesModule SecurityScreen
 */

'use strict';

import React, {Component} from 'react';
import {
  StyleSheet,
  Text,
  View,
  Switch,
  TouchableWithoutFeedback,
  Image
} from 'react-native';

import {StackNavigator} from 'react-navigation';
var Platform = require('Platform');
var ImageBuilder = require('CommonImageBuilder');
var Dimensions = require('Dimensions');
import {PullView} from 'react-native-pull';
var {
  width,
  height,
  scale,
  fontScale
} = Dimensions.get('window');
var CommonHeaderView = require('CommonHeaderView');
var screenScale = width / 375;
var SCAlertDialog = require('SCAlertDialog');
var SCBottomAlertDialog = require('NativeModules').SCBottomAlertDialog;
var SCNavigator = require('SCNavigator');
var SCPropUtils = require('SCPropUtils')
var SCCacheHelper = require('SCCacheHelper');
var SCNetwork = require('SCNetwork');
var CommonUrlMap = require('CommonUrlMap');
var AppManager = require('AppManager');
var SCToast = require('SCToast');

class SecuritySettting extends Component {

  constructor(props) {
    super(props);
    let fromData = SCPropUtils.getPropsFromNative(props); // fromData 全局属性的集合
    this.userInfo = {};
    this.state = {
      gData: typeof(fromData.gData) === 'undefined'
        ? ''
        : fromData.gData,
      bindInfo: {
        email: '',
        fackbook: '',
        mobile: '',
        qq: '',
        wechat: '',
        weibo: ''
      }
    };
    this.onPullRelease = this.onPullRelease.bind(this);
  }

  componentWillMount() {  // 将要装载，在render之前调用
    this.refreshData(this.state.gData);
  }

  refreshData(gData) {
    console.log('willmountaaaaa')
    SCNetwork.post(CommonUrlMap.GET_ACCOUNT_BINDING_INFO, {
      spaceId: gData.spaceId,
      token: gData.token,
      userId: gData.userId
    }).then(result => {

      this.setState({
        bindInfo: {
          email: result.data.email,
          fackbook: result.data.facebook,
          mobile: result.data.mobile,
          qq: result.data.qq,
          wechat: result.data.wechat,
          weibo: result.data.weibo

        }
      })
    }).catch(err => {});
  }

    onPullRelease(resolve) {
        this.refreshData(this.state.gData)
        setTimeout(() => { // 表示延迟1000毫秒后执行 fn 方法
            resolve();
        }, 1000);
    }


    render() {
        return (<View style={styles.container}>
            <View style={styles.girdLine}></View>
            <PullView onPullRelease={this.onPullRelease}>
                <TouchableWithoutFeedback onPress={() => {
                    if (this.state.bindInfo.mobile === '') {
                        if (Platform.OS === 'android') {
                            SCNavigator.pushNativePage('bind_info', JSON.stringify({
                                data: {
                                    type: 'BIND_MOBILE',
                                    isNeedPW: 'true'
                                }
                            }));
                        } else {
                            SCNavigator.pushNativePage('SCInitPasswordController', JSON.stringify({
                                data: {
                                    type: 'BIND_MOBILE',
                                    isNeedPW: 'false'
                                }
                            }));
                        }
                    } else {
                        var options = {
                            type: '1',
                            title: '更换手机号',
                            msg: '确定要更换手机号吗？'
                        }
                        SCAlertDialog.show(options, () => {
                            if (Platform.OS === 'android') {
                                SCNavigator.pushNativePage('bind_info', JSON.stringify({
                                    data: {
                                        type: 'BIND_MOBILE',
                                        isNeedPW: 'false'
                                    }
                                }));
                            } else {
                                SCNavigator.pushNativePage('SCInitPasswordController', JSON.stringify({
                                    data: {
                                        type: 'BIND_MOBILE',
                                        isNeedPW: 'false'
                                    }
                                }));
                            }
                        }, () => {
                        });
                    }
                }}>
                    <View style={styles.itemContainer}>
                        <View>
                            <Text style={styles.leftTitle}>绑定手机号</Text>
                            <Text style={styles.leftDetail}>{
                                this.state.bindInfo.mobile === ''
                                    ? ''
                                    : this.state.bindInfo.mobile.substring(0, 3) + 'xxxx' + this.state.bindInfo.mobile.substring(this.state.bindInfo.mobile.length - 4, this.state.bindInfo.mobile.length)
                            }</Text>
                        </View>
                        <View style={{
                            flex: 1
                        }}></View>
                        <Text style={styles.rightText}>{
                            this.state.bindInfo.mobile === ''
                                ? '点击绑定'
                                : '已绑定'
                        }</Text>
                        <Image style={styles.rightBtn} source={ImageBuilder.getImage('common_right_arrow')}/>

                    </View>
                </TouchableWithoutFeedback>
                <View style={styles.girdLine}></View>
                <TouchableWithoutFeedback onPress={() => {
                    if (this.state.bindInfo.wechat === '') {
                        AppManager.bindOtherAccount('USER_TYPE_WEIXIN');
                    } else {
                        var options = {
                            type: '1',
                            title: '解除绑定',
                            msg: '确定要解除微信绑定吗？'
                        }
                        SCAlertDialog.show(options, () => {
                            if (this.state.bindInfo.qq === '' && this.state.bindInfo.weibo === '' && this.state.bindInfo.mobile === '') {
                                SCToast.show('请先绑定其它某个账号，再解绑');
                                return;
                            }
                            SCNetwork.post(CommonUrlMap.BIND_OTHER_ACCOUNT, {
                                userType: 'USER_TYPE_WEIXIN',
                                token: this.state.gData.token,
                                userId: this.state.gData.userId,
                                otherAccount: ''
                            }).then(result => {
                                this.refreshData(this.state.gData);
                            }).catch(err => {
                            });
                        }, () => {
                        });
                    }
                }}>
                    <View style={styles.itemContainer}>
                        <View>
                            <Text style={styles.leftTitle}>绑定微信</Text>
                            {/* <Text style={styles.leftDetail}>{this.state.bindInfo.wechat}</Text> */}
                        </View>
                        <View style={{
                            flex: 1
                        }}></View>
                        <Text style={styles.rightText}>{
                            this.state.bindInfo.wechat === ''
                                ? '点击绑定'
                                : '已绑定'
                        }</Text>
                        <Image style={styles.rightBtn} source={ImageBuilder.getImage('common_right_arrow')}/>

                    </View>
                </TouchableWithoutFeedback>
                <View style={styles.girdLine}></View>
                <TouchableWithoutFeedback onPress={() => {

                    if (this.state.bindInfo.qq === '') {
                        AppManager.bindOtherAccount('USER_TYPE_QQ');
                    } else {
                        var options = {
                            type: '1',
                            title: '解除绑定',
                            msg: '确定要解除QQ绑定吗？'
                        }
                        SCAlertDialog.show(options, () => {
                            if (this.state.bindInfo.weibo === '' && this.state.bindInfo.wechat === '' && this.state.bindInfo.mobile === '') {
                                SCToast.show('请先绑定其它某个账号，再解绑');
                                return;
                            }
                            SCNetwork.post(CommonUrlMap.BIND_OTHER_ACCOUNT, {
                                userType: 'USER_TYPE_QQ',
                                token: this.state.gData.token,
                                otherAccount: '',
                                userId: this.state.gData.userId
                            }).then(result => {
                                this.refreshData(this.state.gData);
                            }).catch(err => {
                            });
                        }, () => {
                        });
                    }
                }}>
                    <View style={styles.itemContainer}>
                        <View>
                            <Text style={styles.leftTitle}>绑定QQ</Text>
                            {/* <Text style={styles.leftDetail}>{this.state.bindInfo.qq}</Text> */}
                        </View>
                        <View style={{
                            flex: 1
                        }}></View>
                        <Text style={styles.rightText}>{
                            this.state.bindInfo.qq === ''
                                ? '点击绑定'
                                : '已绑定'
                        }</Text>
                        <Image style={styles.rightBtn} source={ImageBuilder.getImage('common_right_arrow')}/>

                    </View>
                </TouchableWithoutFeedback>
                <View style={styles.girdLine}></View>
                <TouchableWithoutFeedback onPress={() => {
                    if (this.state.bindInfo.weibo === '') {
                        AppManager.bindOtherAccount('USER_TYPE_WEIBO');
                    } else {
                        var options = {
                            type: '1',
                            title: '解除绑定',
                            msg: '确定要解除微博绑定吗？'
                        }
                        SCAlertDialog.show(options, () => {
                            if (this.state.bindInfo.qq === '' && this.state.bindInfo.wechat === '' && this.state.bindInfo.mobile === '') {
                                SCToast.show('请先绑定其它某个账号,再解绑');
                                return;
                            }
                            SCNetwork.post(CommonUrlMap.BIND_OTHER_ACCOUNT, {
                                userType: 'USER_TYPE_WEIBO',
                                token: this.state.gData.token,
                                userId: this.state.gData.userId,
                                otherAccount: ''
                            }).then(result => {
                                this.refreshData(this.state.gData);
                            }).catch((err) => {
                                console.log(err)
                            });
                        }, () => {
                        });
                    }
                }}>
                    <View style={styles.itemContainer}>
                        <View>
                            <Text style={styles.leftTitle}>绑定微博</Text>
                            {/* <Text style={styles.leftDetail}>{this.state.bindInfo.weibo}</Text> */}
                        </View>
                        <View style={{
                            flex: 1
                        }}></View>
                        <Text style={styles.rightText}>{
                            this.state.bindInfo.weibo === ''
                                ? '点击绑定'
                                : '已绑定'
                        }</Text>
                        <Image style={styles.rightBtn} source={ImageBuilder.getImage('common_right_arrow')}/>

                    </View>
                </TouchableWithoutFeedback>
                <View style={{
                    height: 20 * screenScale
                }}></View>
                <TouchableWithoutFeedback onPress={() => {
                    if (this.state.bindInfo.password === '') {
                        if (Platform.OS === 'android') {
                            SCNavigator.pushNativePage('bind_info', JSON.stringify({
                                data: {
                                    type: 'BIND_MOBILE',
                                    isNeedPW: 'true'
                                }
                            }));
                        } else {
                            SCNavigator.pushNativePage('SCInitPasswordController', JSON.stringify({
                                data: {
                                    type: 'RESET_PASSWORD',
                                    isNeedPW: 'true'
                                }
                            }));
                        }
                    } else {
                        if (Platform.OS === 'android') {
                            SCNavigator.pushNativePage('bind_info', JSON.stringify({
                                data: {
                                    type: 'RESET_PASSWORD',
                                    isNeedPW: 'true'
                                }
                            }));
                        } else {
                            SCNavigator.pushNativePage('SCInitPasswordController', JSON.stringify({
                                data: {
                                    type: 'RESET_PASSWORD',
                                    isNeedPW: 'true'
                                }
                            }));
                        }
                    }
                }}>
                    <View style={styles.itemContainer}>
                        <View>
                            <Text style={styles.leftTitle}>修改密码</Text>
                        </View>
                        <View style={{
                            flex: 1
                        }}></View>
                        <Text style={styles.rightText}>{
                            this.state.bindInfo.password === 'false'
                                ? '点击绑定'
                                : '已绑定'
                        }</Text>
                        <Image style={styles.rightBtn} source={ImageBuilder.getImage('common_right_arrow')}/>

                    </View>
                </TouchableWithoutFeedback>
            </PullView>

        </View>);
    }
}

const SecurityScreen = StackNavigator({

    SecuritySettting: {
        screen: SecuritySettting,
        navigationOptions: {
            header: ({navigation}) => {
                return (<CommonHeaderView isShowBack={true} goBack={() => SCNavigator.pop()} navigation={navigation}
                                          title={'安全设置'}></CommonHeaderView>)
            }
        }
    }
}, {initialRouteName: 'SecuritySettting'});

const styles = StyleSheet.create({
  container: {
    flexDirection: 'column',
    flex: 1,
    backgroundColor: '#EEEEEE',
    alignItems: 'center'
  },
  itemContainer: {
    height: 60 * screenScale,
    flexDirection: 'row',
    backgroundColor: '#FFFFFF',
    alignItems: 'center'
  },
  leftTitle: {
    fontSize: 14 * fontScale,
    color: '#666666',
    marginLeft: 15 * screenScale
  },
  leftDetail: {
    fontSize: 12 * fontScale,
    color: '#B3B3B3',
    marginLeft: 15 * screenScale
  },
  rightText: {
    fontSize: 14 * fontScale,
    color: '#B3B3B3',
    marginRight: 10 * screenScale
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
module.exports = SecurityScreen;
