/**
 * Created by wangweilin on 2017-12-06.
* @providesModule MyPraisesScreen
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
    TouchableWithoutFeedback,
    Modal
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
import Platform from 'Platform';
import ImageViewer from 'react-native-image-zoom-viewer';


var {width, height, scale, fontScale} = Dimensions.get('window');
var screenScale = width / 375;


class MyPraises extends Component {
    constructor(props) {
        super(props);
        // 下拉列表的参数
        var listDs = new ListView.DataSource({
            rowHasChanged: (r1, r2) => r1 !== r2
        });
        this.lastResultData = {};
        this.listData = [];
        this.characterMap = {};
        this.spaceMap = {};
        this.supportMap = {};
        let fromData = SCPropUtils.getPropsFromNative(props);
        this.state = {
            dataSource: listDs,
            gData: typeof(fromData.gData) === 'undefined' ? '' : fromData.gData,
            characterMap: {},
            spaceMap: {},
            supportMap: {},
            listData: [],
            isNoMore: false,
            isVisible: false,
            imageIndex: 0,
            images: []

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
        SCNetwork.post(CommonUrlMap.GET_STORY_SUPPORT_LIST, {
            characterId: gData.characterId + '',
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
            this.getSpaceData(result.data.content);
            this.getSupportData(result.data.content);
        }).catch(err => {
            this.isLoading = false;
        });
    }

    loadMore() {
        if (!this.isLoading && !this.state.isNoMore) {
            if (this.listData.length >= 10 && this.lastResultData.totalElements !== 'undefined' && this.lastResultData.totalElements > this.listData.length) {
                this.isLoading = true;
                SCNetwork.post(CommonUrlMap.GET_STORY_SUPPORT_LIST, {
                    characterId: this.state.gData.characterId + '',
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
                    this.getSpaceData(result.data.content);
                    this.getSupportData(result.data.content);
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
     * 获取时空信息并加载到列表展示中
     * @param list
     */
    getSpaceData(list) {
        let spaceIdList = [];
        for (var i = 0; i < list.length; i++) {
            if (typeof(this.state.spaceMap['spaceId' + list[i].spaceId]) === 'undefined') {
                spaceIdList.push(list[i].spaceId)
            }
        }
        if (spaceIdList.length === 0) {
            return;
        }
        SCNetwork.post(CommonUrlMap.GET_SPACE_LIST_BY_IDS, {
            jArray: JSON.stringify(spaceIdList),
            token: this.state.gData.token
        }).then(result => {
            for (var i = 0; i < result.data.length; i++) {
                this.spaceMap['spaceId' + result.data[i].spaceId + ''] = result.data[i];
            }
            this.setState({spaceMap: this.spaceMap});
        }).catch(err => {
        });
    }

    /**
     * 获取点赞信息并加载到列表展示中
     * @param list
     */
    getSupportData(list) {
        let storyIdList = [];
        for (var i = 0; i < list.length; i++) {
            if (typeof(this.state.supportMap['storyId' + list[i].storyId]) === 'undefined') {
                storyIdList.push(list[i].storyId)
            }
        }
        if (storyIdList.length === 0) {
            return;
        }
        SCNetwork.post(CommonUrlMap.STORY_ISFAV_LIST, {
            checkIdList: JSON.stringify(storyIdList),
            characterId: this.state.gData.characterId,
            token: this.state.gData.token
        }).then(result => {
            for (var i = 0; i < result.data.length; i++) {
                this.supportMap['storyId' + result.data[i].storyId + ''] = result.data[i];
            }
            this.setState({supportMap: this.supportMap});
        }).catch(err => {
        });
    }

    /**
     * 点赞或者取消点赞
     * @param data,action
     */
    changeSupport(data, action) {
        let url = '';
        if (action == 'add') {
            url = CommonUrlMap.STORY_SUPPORT_ADD;
        } else {
            url = CommonUrlMap.STORY_SUPPORT_REMOVE;
        }
        SCNetwork.post(url, {
            storyId: data,
            characterId: this.state.gData.characterId,
            token: this.state.gData.token
        }).then(result => {
        }).catch(err => {
        });
    }

    renderRow(rowData, rowID) {
        let [images,content] = [[],''];
        if (rowData.content == '') {
            try {
                images = JSON.parse(rowData.intro).imgs;
                content = JSON.parse(rowData.intro).content;
            } catch (e) {
                images = [];
                content = '';
            }
        } else {
            content = rowData.intro;
        }
        return (
            <View style={styles.itemContainer}>
                <View style={styles.girdLine}></View>
                <View style={styles.item}>
                    <TouchableWithoutFeedback onPress={() => {
                        if (Platform.OS === 'android') {
                            SCNavigator.pushNativePage('page_story_dynamic', JSON.stringify({
                                gData: this.state.gData,
                                data: {
                                    novel: rowData,
                                    character: this.state.characterMap['characterId' + rowData.characterId]
                                }
                            }));
                        } else {
                            SCNavigator.pushNativePage('SYStoryContentController', JSON.stringify({
                                gData: this.state.gData,
                                data: {
                                    novel: rowData,
                                    character: this.state.characterMap['characterId' + rowData.characterId]
                                }
                            }));
                        }
                    }}>
                        <View style={styles.itemHeader}>
                            <Avatar
                                width={40 * screenScale}
                                height={40 * screenScale}
                                rounded
                                source={{
                                    uri: typeof(this.state.characterMap['characterId' + rowData.characterId]) === 'undefined'
                                        ? ''
                                        : this.state.characterMap['characterId' + rowData.characterId + ''].headImg
                                }}
                                onPress={() => console.log("Works!")}
                                activeOpacity={0.7}
                            />

                            <View style={styles.itemHeaderRight}>
                                <Text style={styles.itemHeaderRightText1}>{
                                    typeof(this.state.characterMap['characterId' + rowData.characterId]) === 'undefined'
                                        ? ''
                                        : this.state.characterMap['characterId' + rowData.characterId + ''].name
                                }</Text>
                                <View style={styles.itemHeaderRightText}>
                                    <Text
                                        style={styles.itemHeaderRightText2}>{SCDateUtils.getContentTimeFormat(rowData.updateTime)}</Text>
                                    <Text
                                        style={styles.itemHeaderRightText3}>来自 {typeof(this.state.spaceMap['spaceId' + rowData.spaceId]) === 'undefined'
                                        ? ''
                                        : this.state.spaceMap['spaceId' + rowData.spaceId + ''].name}</Text>
                                </View>
                            </View>


                        </View>
                    </TouchableWithoutFeedback>
                    <View style={styles.itemMiddle}>
                        {/*<Text style={styles.itemMiddleText1}>#送行墨子号# @冯提莫</Text>*/}
                        <Text style={styles.itemMiddleText2}>
                            {content}
                        </Text>
                        <View>
                            <Modal visible={this.state.isVisible} transparent={true} onRequestClose={() => {
                                this.setState({
                                    isVisible: false,
                                });
                            }}>
                                <ImageViewer
                                    imageUrls={this.state.images} // 照片路径
                                    enableImageZoom={true} // 是否开启手势缩放
                                    index={this.state.imageIndex} // 初始显示第几张
                                    saveToLocalByLongPress={false}
                                    onCancel={() => {
                                        this.setState({
                                            isVisible: false,
                                        });
                                    }}
                                />
                            </Modal>
                        </View>
                        <View style={styles.itemMiddleImages}>
                            {
                                images.map((image, index) => <TouchableWithoutFeedback onPress={() => {
                                    let _images = [];
                                    for (let i = 0; i < images.length; i++) {
                                        _images.push({url: images[i]});
                                    }
                                    this.setState({
                                        isVisible: true,
                                        images: _images,
                                        imageIndex: index
                                    })
                                }}><Image style={styles.itemMiddleImage}
                                          source={{url: image}}/></TouchableWithoutFeedback>)
                            }
                        </View>
                    </View>
                    <View style={styles.girdLine}></View>
                    <View style={styles.itemFooter}>
                        <View style={{flex: 1}}/>
                        <TouchableWithoutFeedback onPress={() => {
                            if (Platform.OS === 'android') {
                                SCNavigator.pushNativePage('page_story_dynamic', JSON.stringify({
                                    gData: this.state.gData,
                                    data: {
                                        novel: rowData,
                                        character: this.state.characterMap['characterId' + rowData.characterId]
                                    }
                                }));
                            } else {
                                SCNavigator.pushNativePage('SYStoryTransmitController', JSON.stringify({
                                    gData: this.state.gData,
                                    data: {
                                        novel: rowData,
                                        character: this.state.characterMap['characterId' + rowData.characterId]
                                    }
                                }));
                            }
                        }}>
                            <View style={styles.itemFooterContent}>
                                <Image style={styles.itemFooterImage}
                                       source={ImageBuilder.getImage('my_forwarding_btn')}/>
                                <Text style={styles.itemFooterText}>{rowData.transpond}</Text>
                            </View>

                        </TouchableWithoutFeedback>
                        <TouchableWithoutFeedback onPress={() => {
                            if (Platform.OS === 'android') {
                                SCNavigator.pushNativePage('page_story_dynamic', JSON.stringify({
                                    gData: this.state.gData,
                                    data: {
                                        novel: rowData,
                                        character: this.state.characterMap['characterId' + rowData.characterId]
                                    }
                                }));
                            } else {
                                SCNavigator.pushNativePage('SYStoryContentController', JSON.stringify({
                                    gData: this.state.gData,
                                    data: {
                                        novel: rowData,
                                        character: this.state.characterMap['characterId' + rowData.characterId]
                                    }
                                }));
                            }
                        }}>
                            <View style={styles.itemFooterContent}>
                                <Image style={styles.itemFooterImage}
                                       source={ImageBuilder.getImage('my_comment_btn')}/>
                                <Text style={styles.itemFooterText}>{rowData.commentCount}</Text>
                            </View>

                        </TouchableWithoutFeedback>
                        <TouchableWithoutFeedback onPress={() => {
                            if (this.state.supportMap['storyId' + rowData.storyId].check == 1) {
                                this.state.supportMap['storyId' + rowData.storyId].check = 0;
                                rowData.supportCount--;
                                this.changeSupport(rowData.storyId, 'remove');
                            } else {
                                this.state.supportMap['storyId' + rowData.storyId].check = 1;
                                rowData.supportCount++;
                                this.changeSupport(rowData.storyId, 'add');
                            }
                            this.forceUpdate();
                        }}>
                            <View style={styles.itemFooterContent}>
                                <Image style={styles.itemFooterImage}
                                       source={((typeof(this.state.supportMap['storyId' + rowData.storyId]) === 'undefined'
                                           ? ''
                                           : this.state.supportMap['storyId' + rowData.storyId].check) == 1 ? ImageBuilder.getImage('heart_red') : ImageBuilder.getImage('heart_gray'))}/>
                                <Text style={styles.itemFooterText}>{rowData.supportCount}</Text>
                            </View>
                        </TouchableWithoutFeedback>
                    </View>
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
        if (!this.isLoading) {
            if (this.state.listData.length > 0) {
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
            } else {
                return (
                    <View style={styles.containerNoContent}>
                        <Image style={styles.containerNoContentImage} source={ImageBuilder.getImage('heart_gray')}/>
                        <Text style={styles.containerNoContentText}>暂时还没添加故事，可以现在去添加~</Text>
                    </View>
                )

            }
        } else {
            return (
                <View style={{height: 100}}>
                    <ActivityIndicator size="small" color="red" style={{marginTop: 5}}/>
                </View>
            );
        }
    }
}

const MyPraisesScreen = StackNavigator({
        MyPraises: {
            screen: MyPraises,
            navigationOptions: {
                header: ({navigation}) => {
                    return (<CommonHeaderView goBack={() => SCNavigator.pop()} isShowBack={true} navigation={navigation}
                                              title={'我赞过的'}></CommonHeaderView>)
                },
            }
        }
    },
    {
        initialRouteName: 'MyPraises'
    });


const styles = StyleSheet.create({
    containerNoContent: {
        flexDirection: 'column',
        flex: 1,
        backgroundColor: '#EEEEEE',
        alignItems: 'center',
        paddingTop: height * 0.2
    },
    containerNoContentImage: {
        width: 120 * screenScale,
        height: 120 * screenScale,
        marginBottom: 30 * screenScale
    },
    containerNoContentText: {
        color: '#666666',
        fontSize: 18 * fontScale
    },
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
        flexDirection: 'column',
        backgroundColor: '#FFFFFF',
    },
    itemHeader: {
        padding: 15 * screenScale,
        flexDirection: 'row',

    },
    itemHeaderRight: {
        flexDirection: 'column',
        justifyContent: 'center',
        marginLeft: 15 * screenScale,
    },
    itemHeaderRightText1: {
        fontSize: 14 * fontScale,
        color: '#666666'
    },
    itemHeaderRightText: {
        marginTop: 10 * screenScale,
        flexDirection: 'row',
    },
    itemHeaderRightText2: {
        marginRight: 20,
        fontSize: 12 * fontScale,
        color: '#B3B3B3'
    },
    itemHeaderRightText3: {
        fontSize: 12 * fontScale,
        color: '#3BBAC8'
    },
    itemMiddle: {
        flexDirection: 'column',
        padding: 15 * screenScale,
        paddingTop: 0 * screenScale
    },
    itemMiddleText1: {
        fontSize: 12 * fontScale,
        color: '#3BBAC8'
    },
    itemMiddleText2: {
        fontSize: 12 * fontScale,
        color: '#666666'
    },
    itemMiddleImages: {
        flexDirection: 'row',
        marginTop: 10 * screenScale,
    },
    itemMiddleImage: {
        width: width * 0.25,
        height: width * 0.25,
        marginRight: 20 * screenScale
    },
    itemFooter: {
        padding: 8 * screenScale,
        flexDirection: 'row',
        alignItems: 'center',
    },
    itemFooterContent: {
        flexDirection: 'row',
        alignItems: 'center',
        marginRight: 30 * screenScale

    },
    itemFooterImage: {
        width: 22 * screenScale,
        height: 22 * screenScale,
        marginRight: 5 * screenScale
    },
    itemFooterText: {
        width: 15 * screenScale,
        color: '#B3B3B3',
        fontSize: 12 * fontScale
    }

});
module.exports = MyPraisesScreen;
