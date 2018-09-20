/**
 * Created by flyye on 22/10/9.
 * @providesModule SpaceRulesScreen
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

var CommonImageBuilder = require('CommonImageBuilder');
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
import {PullList} from 'react-native-pull';

var SCNavigator = require('SCNavigator');
var SCCacheHelper = require('SCCacheHelper');
var SCNetwork = require('SCNetwork');
var CommonUrlMap = require('CommonUrlMap')
var SCPropUtils = require('SCPropUtils')
var SCBottomAlertDialog = require('SCBottomAlertDialog');
var SCInputAlertDialog = require('SCInputAlertDialog');
import Platform from 'Platform';
var isIos = Platform.OS === 'ios';


class SpaceRulesScreen extends Component {

    constructor(props) {
        super(props);
        var listDs = new ListView.DataSource({
            rowHasChanged: (r1, r2) => r1 !== r2
        });
        this.lastResultData = {};
        this.listData = [];
        this.allData = [];
        this.spaceNameMap = {};
        this.checkData = {};
        this.deleteData = {};
        this.isLoading = false;
        let fromData = SCPropUtils.getPropsFromNative(props);
        this.state = {
            dataSource: listDs,
            gData: typeof(fromData.gData) === 'undefined'
                ? ''
                : fromData.gData,
            spaceNameMap: this.spaceNameMap,
            listData: [],
            isNoMore: false,
            deleteData: [],
            checkData: []
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
        SCNetwork.post(CommonUrlMap.FIND_NOTICE_LIST_BY_SPACE, {
            spaceId: gData.spaceId,
            token: gData.token,
            page: 0 + ''
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
        this.refreshData(this.state.gData);
        setTimeout(() => {
            resolve();
        }, 1000);
    }

    loadMore() {
        if (!this.isLoading && !this.state.isNoMore) {
            if (this.listData.length >= 10 && this.lastResultData.totalElements !== 'undefined' && this.lastResultData.totalElements > this.listData.length) {
                this.isLoading = true;
                SCNetwork.post(CommonUrlMap.FIND_NOTICE_LIST_BY_SPACE, {
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
            <View style={styles.itemContainer}>
                {
                    this.state.isDeleteState
                        ? (<TouchableWithoutFeedback onPress={() => {
                            if (this.state.checkData[rowID + 'and' + '1']) {
                                this.checkData[rowID + 'and' + '1'] = false;
                                this.deleteData[rowID + 'and' + '1'] = '';
                                this.setState({checkData: this.checkData, deleteData: this.deleteData});
                            } else {
                                this.checkData[rowID + 'and' + '1'] = true;
                                this.deleteData[rowID + 'and' + '1'] = rowData.noticeId + '';
                                this.setState({checkData: this.checkData, deleteData: this.deleteData});
                            }
                        }}>
                            <View style={{
                                flexDirection: 'row',
                                alignItems: 'center',
                                height: 70 * screenScale,
                                width: 375 * screenScale
                            }}>
                                <Text style={styles.leftTitle}>{rowData.content}</Text>
                                <Image style={{
                                    width: 22 * screenScale,
                                    height: 22 * screenScale,
                                    position: 'absolute',
                                    right: 12 * screenScale,
                                    top: 24 * screenScale
                                }} source={this.state.checkData[rowID + 'and' + '1']
                                    ? ImageBuilder.getImage('check_true')
                                    : ImageBuilder.getImage('check_gray')}/>
                            </View>
                        </TouchableWithoutFeedback>)
                        : (<Text style={styles.leftTitle}>{rowData.content}</Text>)
                }
            </View>
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
                <Text style={styles.headerText}>注意事项</Text>
                <TouchableWithoutFeedback onPress={() => {
                    if (this.state.isDeleteState) {
                        var deleteIdArray = [];
                        for (var key in this.state.deleteData) {
                            if (this.state.deleteData[key].length > 0) {
                                deleteIdArray.push(this.state.deleteData[key]);
                            }
                        }
                        SCNetwork.post(CommonUrlMap.DELETE_SPACE_RULE_LIST, {
                            dataArray: JSON.stringify(deleteIdArray) + '',
                            token: this.state.gData.token
                        }).then(result => {
                            this.setState({isDeleteState: false});
                            this.refreshData(this.state.gData);
                        }).catch(err => {
                        });
                    } else {
                        SCBottomAlertDialog.show({0: '添加', 1: '删除', 2: '取消'}).then((key) => {
                            if (key == 0) {
                                SCInputAlertDialog.show({placeHolder: '添加点什么？', title: '添加注意事项'}).then((value) => {
                                    SCNetwork.post(CommonUrlMap.CHREATE_SPACE_NOTICE, {
                                        spaceId: this.state.gData.spaceId,
                                        token: this.state.gData.token,
                                        content: value.input
                                    }).then(result => {
                                    }).catch(err => {
                                    });
                                })
                            } else if (key == 1) {
                                this.setState({isDeleteState: true})
                            } else {
                                SCBottomAlertDialog.dismiss();
                            }
                        }).catch((err) => {
                        });
                    }
                }}>
                    <View style={{
                        position: 'absolute',
                        right: 0,
                        height: 40 * screenScale,
                        width: 35 * screenScale,
                        justifyContent: 'center'
                    }}>
                        {
                            this.state.isDeleteState
                                ? (<Text style={{
                                    fontSize: 16 * fontScale,
                                    color: '#333333'
                                }}>确定</Text>)
                                : (<Image style={{
                                    height: 6 * screenScale,
                                    width: 18 * screenScale
                                }} source={CommonImageBuilder.getImage('common_menu')}/>)
                        }

                    </View>
                </TouchableWithoutFeedback>
            </View>
            <View style={{
                height: 1,
                backgroundColor: '#FFFFFF'
            }}></View>
                <PullList renderRow={(rowData, sectionId, rowID) => this.renderRow(rowData, rowID)}
                          dataSource={this.state.dataSource.cloneWithRows(this.state.listData)} style={{
                    width: 375 * screenScale,backgroundColor:'#EEEEEE'
                }} onPullRelease={this.onPullRelease} enableEmptySections={true} pageSize={10} initialListSize={10}
                          onEndReached={this.loadMore} onEndReachedThreshold={60} renderFooter={this.renderFooter}
                          removeClippedSubviews={false}/>
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
        height: 70 * screenScale,
        width: 375 * screenScale,
        flexDirection: 'row',
        backgroundColor: '#FFFFFF',
        alignItems: 'center'
    },
    leftTitle: {
        fontSize: 14 * fontScale,
        color: '#666666',
        marginLeft: 15 * screenScale,
        marginRight: 10 * screenScale
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
module.exports = SpaceRulesScreen;
