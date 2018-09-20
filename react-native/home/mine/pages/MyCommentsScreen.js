/**
 * Created by wangweilin on 2017-12-06.
 * @providesModule MyCommentsScreen
 */

'use strict';

import React, {Component} from 'react';
import {
    StyleSheet,
    Text,
    View,
    ListView,
    ActivityIndicator,
    Image,
    TouchableWithoutFeedback
} from 'react-native';

import {
    StackNavigator,
} from 'react-navigation';

import {Avatar, List, ListItem} from 'react-native-elements'
import {PullList} from 'react-native-pull';
import SCPropUtils from 'SCPropUtils';
import CommonUrlMap from 'CommonUrlMap';
import SCNetwork from 'SCNetwork';
import SCNavigator from 'SCNavigator';
import CommonHeaderView from 'CommonHeaderView';
import Dimensions from 'Dimensions';
import ImageBuilder from '../utils/ImageBuilder';
import SCDateUtils from 'SCDateUtils';

var {width, height, scale, fontScale} = Dimensions.get('window');
var screenScale = width / 375;
var Platform = require('Platform');


class MyComments extends Component {
    constructor(props) {
        super(props);
        // 下拉列表的参数
        var listDs = new ListView.DataSource({
            rowHasChanged: (r1, r2) => r1 !== r2
        });
        this.lastResultData = {};
        this.listData = [];
        this.characterMap = {};
        this.storyMap = {};
        let fromData = SCPropUtils.getPropsFromNative(props);
        this.state = {
            dataSource: listDs,
            gData: typeof(fromData.gData) === 'undefined' ? '' : fromData.gData,
            characterMap: {},
            storyMap: {},
            listData: [],
            isNoMore: false
        };
        this.isLoading = false;
        this.renderFooter = this.renderFooter.bind(this);
        this.loadMore = this.loadMore.bind(this);
        this.onPullRelease = this.onPullRelease.bind(this);
    }


    componentWillMount() {
        let gData = this.state.gData;
        this.refreshData(gData);
    }

    onPullRelease(resolve) {
        this.refreshData(this.state.gData);
        setTimeout(() => {
            resolve();
        }, 1000);
    }

    refreshData(gData) {
        this.isLoading = true;
        SCNetwork.post(CommonUrlMap.GET_MY_COMMENTS_LIST, {
            userId: gData.userId + '',
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
            this.setState({
                listData: this.listData,
                isNoMore: noMore
            });
            this.getCharacterData(result.data.content);
            this.getStoryData(result.data.content);
        }).catch(err => {
            this.isLoading = false;
        });
    }

    loadMore() {
        if (!this.isLoading && !this.state.isNoMore) {
            if (this.listData.length >= 10 && this.lastResultData.totalElements !== 'undefined' && this.lastResultData.totalElements > this.listData.length) {
                this.isLoading = true;
                SCNetwork.post(CommonUrlMap.GET_MY_COMMENTS_LIST, {
                    userId: this.state.gData.userId + '',
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
                    this.getCharacterData(result.data.content)
                    this.getStoryData(result.data.content);
                    this.lastResultData = result.data;
                    this.isLoading = false;
                    this.setState({
                        listData: this.listData,
                        isNoMore: noMore
                    });
                }).catch(err => {
                    this.isLoading = false;
                });

            }
        }
    }

    /**
     * 获取角色信息并加载到列表展示中
     * @param list
     */
    getCharacterData(list) {
        let characterIdList = [];
        for (var i = 0; i < list.length; i++) {
            if (typeof(this.state.characterMap['characterId' + list[i].characterId]) === 'undefined') {
                characterIdList.push(list[i].characterId)
            }
        }
        if (characterIdList.length === 0) {
            return;
        }
        SCNetwork.post(CommonUrlMap.GET_CHARACTER_BRIEF_INFO_LIST, {
            dataArray: JSON.stringify(characterIdList),
            token: this.state.gData.token
        }).then(result => {
            for (var i = 0; i < result.data.length; i++) {
                this.characterMap['characterId' + result.data[i].characterId + ''] = result.data[i];
            }
            this.setState({characterMap: this.characterMap});
        }).catch(err => {
        });
    }

    /**
     * 获取故事信息并加载到列表展示中
     * @param list
     */
    getStoryData(list) {
        let storyIdList = [];
        for (var i = 0; i < list.length; i++) {
            if (typeof(this.state.storyMap['storyId' + list[i].storyId]) === 'undefined') {
                storyIdList.push(list[i].storyId)
            }
        }
        if (storyIdList.length === 0) {
            return;
        }
        SCNetwork.post(CommonUrlMap.GET_STORY_BY_LIST, {
            dataArray: JSON.stringify(storyIdList),
            token: this.state.gData.token
        }).then(result => {
            for (var i = 0; i < result.data.length; i++) {
                this.storyMap['storyId' + result.data[i].storyId + ''] = result.data[i];
            }
            this.setState({storyMap: this.storyMap});
        }).catch(err => {
        });
    }

    renderRow(rowData, rowID) {
        let content = '';
        if(typeof(this.state.storyMap['storyId' + rowData.storyId]) === 'undefined'){
            content='';
        }else {
            if(this.state.storyMap['storyId' + rowData.storyId + ''].content != ''){
               content=this.state.storyMap['storyId' + rowData.storyId + ''].intro;
            }else {
                try {
                    content=JSON.parse(this.state.storyMap['storyId' + rowData.storyId + ''].intro).content
                }catch (e){
                    content='';
                }
            }
        }
        return (
            <View style={styles.itemContainer}>
                <View style={styles.girdLine}></View>
                <View style={styles.item}>
                    <Avatar
                        width={50 * screenScale}
                        height={50 * screenScale}
                        rounded
                        source={{
                            uri: typeof(this.state.characterMap['characterId' + rowData.characterId]) === 'undefined'
                                ? ''
                                : this.state.characterMap['characterId' + rowData.characterId + ''].headImg
                        }}
                        onPress={() => {
                          if (Platform.OS === 'android') {
                            SCNavigator.pushNativePage('page_character_home', JSON.stringify({gData: this.state.gData, data: this.state.characterMap['characterId' + rowData.characterId + '']}));
                          }else{
                            SCNavigator.pushNativePage('SYFriendHomePageController', JSON.stringify({data:this.state.characterMap['characterId' + rowData.characterId + '']}));
                          }
                        }}
                        activeOpacity={0.7}
                    />

                    <TouchableWithoutFeedback onPress={() => {


                        if (typeof(this.state.storyMap['storyId' + rowData.storyId + '']) !== 'undefined' && typeof(rowData) !== 'undefined') {
                          if(Platform.OS === 'android'){
                            if(this.state.storyMap['storyId' + rowData.storyId + ''].type == 1){
                              SCNavigator.pushNativePage('page_story_dynamic', JSON.stringify({
                                gData: this.props.gData,
                                data: {
                                  novel: this.state.storyMap['storyId' + rowData.storyId + ''],
                                  character: this.state.characterMap['characterId' + rowData.characterId + '']
                                }
                              }));
                            }else if(this.state.storyMap['storyId' + rowData.storyId + ''].type == 2) {
                              SCNavigator.pushNativePage('page_novel_dynamic', JSON.stringify({
                                gData: this.props.gData,
                                data: {
                                  novel: this.state.storyMap['storyId' + rowData.storyId + ''],
                                  character: this.state.characterMap['characterId' + rowData.characterId + '']
                                }
                              }));
                            }

                          }else {

                            SCNavigator.pushNativePage('SYStoryContentController', JSON.stringify({
                              gData: this.state.gData,
                              data: {
                                novel: this.state.storyMap['storyId' + rowData.storyId + ''],
                                character: this.state.characterMap['characterId' + rowData.characterId + '']
                              }
                            }));
                          }
                        }
                      }
              }>
                    <View style={styles.itemRight}>
                        <View style={styles.itemRightHeader}>
                            <Text
                                style={styles.itemRightHeaderText1}>{typeof(this.state.characterMap['characterId' + rowData.characterId]) === 'undefined'
                                ? ''
                                : this.state.characterMap['characterId' + rowData.characterId + ''].name}</Text>
                            <Text style={styles.itemRightHeaderText2}>评论</Text>
                            <View style={{flex: 1}}/>
                            <Text
                                style={styles.itemRightHeaderText3}>{SCDateUtils.getContentTimeFormat(rowData.createTime)}</Text>
                            <View style={styles.itemRightHeader4}>
                                <Image style={styles.itemRightHeader4Image}
                                       source={ImageBuilder.getImage('heart_gray')}/>
                                <Text style={styles.itemRightHeader4Text}>{rowData.supportCount}</Text>
                            </View>
                        </View>
                        <View style={styles.itemRightMiddle}>
                            <Text style={styles.itemRightMiddleText}>{rowData.content}</Text>
                        </View>
                        <View style={styles.itemRightFooter}>
                            <Text
                                style={styles.itemRightFooterText}>{content}</Text>
                        </View>
                    </View>
                </TouchableWithoutFeedback>
                </View>
            </View>
        )
    }

    renderFooter() {
        if (this.state.isNoMore) {
            return null;
        }
        return (
            <View style={{height: 100}}>
                <ActivityIndicator size="small" color="red" style={{marginTop: 5}}/>
            </View>
        );
    }

    render() {
        return (
            <View style={styles.container}>
                <PullList
                    renderRow={(rowData, sectionId, rowID) => this.renderRow(rowData, rowID)}
                    dataSource={this.state.dataSource.cloneWithRows(this.state.listData)}
                    style={{width: 375 * screenScale}}
                    onPullRelease={this.onPullRelease}
                    enableEmptySections={true}
                    pageSize={10}
                    initialListSize={10}
                    onEndReached={this.loadMore}
                    onEndReachedThreshold={60}
                    renderFooter={this.renderFooter}
                    removeClippedSubviews={false}
                />
            </View>
        )
    }
}

const MyCommentsScreen = StackNavigator({
        MyComments: {
            screen: MyComments,
            navigationOptions: {
                header: ({navigation}) => {
                    return (<CommonHeaderView goBack={() => SCNavigator.pop()} isShowBack={true} navigation={navigation}
                                              title={'我评论的'}></CommonHeaderView>)
                },
            }
        }
    },
    {
        initialRouteName: 'MyComments'
    });


const styles = StyleSheet.create({
    container: {
        flexDirection: 'column',
        flex: 1,
        backgroundColor: '#EEEEEE',
        alignItems: 'center'
    },
    itemContainer: {
        flexDirection: 'column'
    },
    girdLine: {
        height: 1,
        width: 375 * screenScale,
        backgroundColor: '#EEEEEE'
    },
    item: {
        width: width,
        padding: 20 * screenScale,
        flexDirection: 'row',
        backgroundColor: '#FFFFFF',
    },
    itemRight: {
        flex: 1,
        marginLeft: 15 * screenScale
    },
    itemRightHeader: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    itemRightHeaderText1: {
        color: '#666666',
        fontSize: 14 * fontScale,
        marginRight: 15 * screenScale
    },
    itemRightHeaderText2: {
        color: '#3BBAC8',
        fontSize: 10 * fontScale
    },
    itemRightHeaderText3: {
        color: '#888888',
        fontSize: 12 * fontScale,
        marginRight: 15 * screenScale
    },
    itemRightHeader4: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    itemRightHeader4Image: {
        width: 12 * screenScale,
        height: 11 * screenScale,
        marginRight: 5 * screenScale
    },
    itemRightHeader4Text: {
        color: '#B3B3B3',
        fontSize: 10 * fontScale
    },
    itemRightMiddle: {
        marginTop: 10 * screenScale
    },
    itemRightMiddleText: {
        color: '#B3B3B3',
        fontSize: 12 * fontScale
    },
    itemRightFooter: {
        marginTop: 10 * screenScale,
        backgroundColor: '#F7F7F7',
        padding: 8 * screenScale
    },
    itemRightFooterText: {
        color: '#666666',
        fontSize: 12 * fontScale
    }
});
module.exports = MyCommentsScreen;
