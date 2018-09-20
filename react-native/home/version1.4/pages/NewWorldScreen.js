/**
 * Created by wangweilin on 2017-11-28.
 * @providesModule NewWorldScreen
 */


'use strict';

import React, {Component} from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image,
    Dimensions,
    TextInput,
    TouchableWithoutFeedback
} from 'react-native';

import {
    StackNavigator,
} from 'react-navigation';

import CommonHeaderView from 'CommonHeaderView';
import SCNavigator from 'SCNavigator';
import CommonImageBuilder from 'CommonImageBuilder';


const {width, height, scale, fontScale} = Dimensions.get('window');
const screenScale = width / 375;

class NewWorld extends Component {
    constructor(props) {
        super(props);

    }

    componentWillMount() {

    }

    refreshData() {

    }

    render() {
        return (
            <View>
                <View style={styles.itemContainer}>
                    <Text style={styles.leftTitle}>头像</Text>
                    <Image style={styles.headerImg}
                           source={{uri: 'http://shanchain-web.oss-cn-beijing.aliyuncs.com/app_home/img/learn.png'}}></Image>
                    <View style={{flex: 1}}/>
                    <TouchableWithoutFeedback>
                        <View style={styles.right}>
                            <Text style={styles.rightBlueText}>更换</Text>
                            <Image style={styles.rightBtn} source={CommonImageBuilder.getImage('common_right_arrow')}></Image>
                        </View>
                    </TouchableWithoutFeedback>
                </View>
                <View style={styles.girdWidenLine}></View>

                <View style={styles.itemContainer}>
                    <Text style={styles.leftTitle}>新世界名称</Text>
                    <TextInput placeholder='请输入新世界名称'
                               placeholderTextColor='#B3B3B3'
                               selectionColor='#000000'
                               style={styles.textInput}></TextInput>
                </View>
                <View style={styles.girdLine}></View>

                <View style={styles.itemContainer}>
                    <Text style={styles.leftTitle}>宣传口号</Text>
                    <TextInput placeholder='请写一句话作为宣传口号'
                               placeholderTextColor='#B3B3B3'
                               selectionColor='#000000'
                               style={styles.textInput}></TextInput>
                </View>
                <View style={styles.girdLine}></View>

                <View style={styles.itemContainer}>
                    <Text style={styles.leftTitle}>介绍新世界</Text>
                    <TextInput placeholder='请先简要介绍你心中的这个世界（原创）'
                               placeholderTextColor='#B3B3B3'
                               selectionColor='#000000'
                               style={styles.textInput}></TextInput>
                </View>
                <View style={styles.girdLine}></View>

                <View style={styles.itemContainer}>
                    <Text style={styles.leftTitle}>地理／地图</Text>
                    <View style={{flex: 1}}/>
                    <Text style={styles.rightText}>1/9张</Text>
                    <Image style={styles.rightBtn} source={CommonImageBuilder.getImage('common_right_arrow')}></Image>
                </View>
                <View style={styles.girdLine}></View>

                <View style={styles.itemContainer}>
                    <Text style={styles.leftTitle}>势力／组织</Text>
                    <View style={{flex: 1}}/>
                    <Text style={styles.rightText}>张衡号、渡江社、宣河盐帮等3个</Text>
                    <Image style={styles.rightBtn} source={CommonImageBuilder.getImage('common_right_arrow')}></Image>
                </View>
                <View style={styles.girdLine}></View>

                <View style={styles.itemContainer}>
                    <Text style={styles.leftTitle}>历史／文化</Text>
                    <View style={{flex: 1}}/>
                    <Text style={styles.rightText}>共2篇</Text>
                    <Image style={styles.rightBtn} source={CommonImageBuilder.getImage('common_right_arrow')}></Image>
                </View>
                <View style={styles.girdLine}></View>

                <View style={styles.itemContainer}>
                    <Text style={styles.leftTitle}>选择标签</Text>
                    <View style={{flex: 1}}/>
                    <Text style={styles.rightText}>现代</Text>
                    <Image style={styles.rightBtn} source={CommonImageBuilder.getImage('common_right_arrow')}></Image>
                </View>
                <View style={styles.girdLine}></View>

                <View style={styles.itemContainer}>
                    <Text style={styles.leftTitle}>故事主线</Text>
                    <View style={{flex: 1}}/>
                    <Text style={styles.rightText}>选填</Text>
                    <Image style={styles.rightBtn} source={CommonImageBuilder.getImage('common_right_arrow')}></Image>
                </View>
                <View style={styles.girdLine}></View>

                <View style={styles.itemContainer}>
                    <Text style={styles.leftTitle}>人物要求</Text>
                    <View style={{flex: 1}}/>
                    <Text style={styles.rightText}>选填(随时可以修改)</Text>
                    <Image style={styles.rightBtn} source={CommonImageBuilder.getImage('common_right_arrow')}></Image>
                </View>
                <View style={styles.girdLine}></View>

                <View style={styles.itemContainer}>
                    <Text style={styles.leftTitle}>开放级别</Text>
                    <View style={{flex: 1}}/>
                    <Text style={styles.rightText}>普通授权(默认)</Text>
                    <Image style={styles.rightBtn} source={CommonImageBuilder.getImage('common_right_arrow')}></Image>
                </View>
                <View style={styles.girdLine}></View>
            </View>
        );
    }
}

const NewWorldScreen = StackNavigator({
        NewWorld: {
            screen: NewWorld,
            navigationOptions: {
                header: ({navigation}) => {
                    return (<CommonHeaderView
                        goBack={() => SCNavigator.pop()} isShowBack={true}
                        isShowRightText={true}
                        rightText='确定'
                        rightAction={() => SCNavigator.pushNativePage('page_add_topic', '')}
                        navigation={navigation} title={'添加新世界'}>
                    </CommonHeaderView>)
                }
            }
        }
    },
    {
        initialRouteName: 'NewWorld'
    });


const styles = StyleSheet.create({
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
    headerImg: {
        marginLeft: 10 * screenScale,
        width: 40 * screenScale,
        height: 40 * screenScale,
        borderRadius: 20 * screenScale
    },
    right:{
        flexDirection: 'row',
    },
    rightBlueText: {
        fontSize: 12 * fontScale,
        marginRight: 10 * screenScale,
        color: '#00AAF6'
    },
    rightText: {
        fontSize: 14 * fontScale,
        color: '#B3B3B3',
        marginRight: 10 * screenScale
    },
    rightBtn: {
        width: 6 * screenScale,
        height: 12 * screenScale,
        marginRight: 15 * screenScale,
    },
    girdLine: {
        height: 1,
        width: 375 * screenScale,
        backgroundColor: '#EEEEEE'
    },
    girdWidenLine: {
        height: 5,
        width: 375 * screenScale,
        backgroundColor: '#EEEEEE'
    },
    textInput: {
        height: 40 * screenScale,
        fontSize: 14 * fontScale,
        marginLeft: 30 * screenScale,
        flex: 1
    }
});
module.exports = NewWorldScreen;