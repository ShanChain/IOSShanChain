/**
 * Created by flyye on 22/9/27.
 * @providesModule CopyRightLevelScreen
 */


'use strict';

import React, {Component} from 'react';
import {
    StyleSheet,
    Text,
    View,
    Dimensions
} from 'react-native';

import {
    StackNavigator,
} from 'react-navigation';

import CommonHeaderView from 'CommonHeaderView';
import SCNavigator from 'SCNavigator';

const {width, height, scale, fontScale} = Dimensions.get('window');
const screenScale = width / 375;

class CopyRightLevel extends Component {
    constructor(props) {
        super(props);

    }

    componentWillMount() {

    }

    refreshData() {

    }

    render() {
        return (
            <View style={styles.container}>
                <View style={styles.item}>
                    <Text style={styles.itemText1}>普通授权(默认)</Text>
                    <Text style={styles.itemText2}>要求署名，商业性使用需要许可，修改演绎受到限制</Text>
                </View>
                <View style={styles.line}/>
                <View style={styles.item}>
                    <Text style={styles.itemText1}>自由修改</Text>
                    <Text style={styles.itemText2}>要求署名，商业性使用需要许可，除我之外不得改变开发级别</Text>
                </View>
                <View style={styles.line}/>
                <View style={styles.item}>
                    <Text style={styles.itemText1}>商业授权</Text>
                    <Text style={styles.itemText2}>要求署名，由千千世界官方代理商业授权，修改演绎受到限制</Text>
                </View>
                <View style={styles.line}/>
                <View style={styles.item}>
                    <Text style={styles.itemText1}>充分开放</Text>
                    <Text style={styles.itemText2}>要求署名，由千千世界官方代理商业授权，除我之外不得改变 开发级别</Text>
                </View>
                <View style={styles.line}/>
                <View style={styles.item}>
                    <Text style={styles.itemText1}>公开作品</Text>
                    <Text style={styles.itemText2}>不保留著作权</Text>
                </View>
                <View style={styles.line}/>
            </View>
        );
    }
}

const CopyRightLevelScreen = StackNavigator({
        CopyRightLevel: {
            screen: CopyRightLevel,
            navigationOptions: {
                header: ({navigation}) => {
                    return (<CommonHeaderView goBack={() => SCNavigator.pop()} isShowBack={true} navigation={navigation}
                                              title={'著作权开放级别'}></CommonHeaderView>)
                }
            }
        }
    },
    {
        initialRouteName: 'CopyRightLevel'
    });


const styles = StyleSheet.create({
    container:{
        backgroundColor:'#FFFFFF',
        flex:1
    },
    item: {
        margin: 15 * screenScale,
    },
    itemText1: {
        fontSize: 14 * screenScale,
        color: '#2E2E2E'
    },
    itemText2: {
        marginTop:10*screenScale,
        fontSize: 12 * screenScale,
        color: '#B3B3B3'
    },
    line: {
        backgroundColor: '#F3F3F3',
        height: 1 * screenScale
    }
});
module.exports = CopyRightLevelScreen;
