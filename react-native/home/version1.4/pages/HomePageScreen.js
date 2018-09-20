/**
 * Created by flyye on 22/9/27.
 * @providesModule HomePageScreen
 */


'use strict';

import React, {Component} from 'react';
import {
    StyleSheet,
    Text,
    View,
    ImageBackground,
    TouchableWithoutFeedback,
    Dimensions
} from 'react-native';

import {
    StackNavigator,
} from 'react-navigation';

import CommonHeaderView from 'CommonHeaderView';
import SCNavigator from 'SCNavigator';

const {width, height,scale,fontScale} = Dimensions.get('window');
const screenScale = width / 375;

class HomePage extends Component{
    constructor(props) {
        super(props);

    }

    componentWillMount() {

    }

    refreshData(){

    }

    render(){
        return (
            <View>
                <ImageBackground source={{uri: 'http://shanchain-web.oss-cn-beijing.aliyuncs.com/app_home/img/learn.png'}} style={styles.header}>
                </ImageBackground>
                <View style={styles.middle}>
                    <Text style={styles.middleText1}>三国历史狂想</Text>
                    <Text style={styles.middleText2}>梦回三国，再战金戈铁马</Text>
                    <View style={styles.middleButtons}>
                        <View style={styles.middleButton}>
                            <Text style={styles.middleBtnText}>
                                历史
                            </Text>
                        </View>
                        <View style={styles.middleButton}>
                            <Text style={styles.middleBtnText}>
                                军事
                            </Text>
                        </View>
                    </View>
                </View>
                <View style={styles.footer}>
                    <Text style={styles.footerText}>
                        史书上的只言片语，不足以描绘出一个灿烂的三国，对那些热血的历史细节，你是否也有各种各样的设想和猜测？
                        史书上的只言片语，不足以描绘出一个灿烂的三国，对那些热血的历史细节，你是否也有各种各样的设想和猜测？
                        史书上的只言片语，不足以描绘出一个灿烂的三国，对那些热血的历史细节，你是否也有各种各样的设想和猜测？
                    </Text>
                    <TouchableWithoutFeedback>
                        <View style={styles.footerButton}>
                            <Text style={styles.footerButtonText}>
                                愉快地走进这个世界
                            </Text>
                        </View>
                    </TouchableWithoutFeedback>
                </View>
            </View>
        );
    }
}

const HomePageScreen = StackNavigator({
        HomePage: {
            screen: HomePage,
            navigationOptions: {
                header: ({navigation}) => {
                    return (<CommonHeaderView goBack={() => SCNavigator.pop()} isShowBack={true} navigation={navigation} title={'欢迎来到新世界'} ></CommonHeaderView>)
                }
            }
        }
    },
    {
        initialRouteName: 'HomePage'
    });


const styles = StyleSheet.create({
    header: {
        width: width,
        height: 195 * screenScale,
    },
    middle: {
        width: width,
        height: 110 * screenScale,
        padding: 20 * screenScale
    },
    middleText1: {
        fontSize: 16 * fontScale,
        color: '#2E2E2E',
        marginBottom: 14 * screenScale,
    },
    middleText2: {
        fontSize: 12 * fontScale,
        color: '#B3B3B3',
        marginBottom: 14 * screenScale,
    },
    middleButtons: {
        flexDirection: 'row',
    },
    middleButton: {
        width: 50 * screenScale,
        height: 24 * screenScale,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#00AAF6',
        borderRadius: 20 * screenScale,
        marginRight: 10 * screenScale
    },
    middleBtnText: {
        fontSize: 12 * fontScale,
        color: '#FFFFFF'
    },
    footer: {
        padding: 20 * screenScale
    },
    footerText:{
        fontSize: 14 * fontScale,
        color: '#666666',
    },
    footerButton:{
        marginTop:20*screenScale,
        width: width-40*screenScale,
        height: 42 * screenScale,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#00AAF6',
        borderRadius: 20 * screenScale
    },
    footerButtonText:{
        fontSize: 14 * fontScale,
        color: '#FFFFFF'
    }

});
module.exports = HomePageScreen;
