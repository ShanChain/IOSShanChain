/**
 * Created by flyye on 22/9/27.
 * @providesModule CharacterRequireScreen
 */


'use strict';

import React, {Component} from 'react';
import {
    StyleSheet,
    TextInput,
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

class CharacterRequire extends Component {
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
                <TextInput placeholder='创建新人物时，会显示以上说明，你可以在此写明新人 物的必备信息和基本要求，如必须合情合理地指定人物 特长／技能／武功／发力。不要随意引入能改变格局的 人物…'
                           placeholderTextColor='#B3B3B3'
                           selectionColor='#000000'
                           multiline={true}
                           style={styles.textInput}>

                </TextInput>
            </View>
        );
    }
}

const CharacterRequireScreen = StackNavigator({
        CharacterRequire: {
            screen: CharacterRequire,
            navigationOptions: {
                header: ({navigation}) => {
                    return (<CommonHeaderView
                        goBack={() => SCNavigator.pop()}
                        isShowBack={true}
                        navigation={navigation}
                        title={'人物要求'}
                        isShowRightText={true}
                        rightText='确定'
                        rightAction={() => SCNavigator.pushNativePage('page_add_topic', '')}>
                    </CommonHeaderView>)
                }
            }
        }
    },
    {
        initialRouteName: 'CharacterRequire'
    });


const styles = StyleSheet.create({
    container:{
        backgroundColor:'#FFFFFF',
        flex:1,
    },
    textInput:{
        fontSize: 14 * fontScale,
        margin: 10 * screenScale,
        flex: 1,
        color:'#B3B3B3'
    }

});
module.exports = CharacterRequireScreen;
