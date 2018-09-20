/**
 * Created by flyye on 22/9/27.
 * @providesModule CommonHeaderView
 */
'use strict';

import React, {Component} from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image,
    TouchableWithoutFeedback,
    StatusBar
} from 'react-native';

import {StackNavigator} from 'react-navigation';
import Platform from 'Platform';

var isIos = Platform.OS === 'ios';
var ImageBuilder = require('CommonImageBuilder');
var Dimensions = require('Dimensions');
var {
    width,
    height,
    scale,
    fontScale
} = Dimensions.get('window');
var screenScale = width / 375;
const StatusBarManager = require('NativeModules').StatusBarManager;

class NomalHeader extends Component {
    render() {
        this.props = this.props.props;
        return (<View style={styles.headerContainer}>
            <Text style={styles.headerText}>{this.props.title}</Text>
        </View>)
    }
}

class HasBackHeader extends Component {
    render() {
        return this.renderHasBack(this.props.props)
    }

    renderHasBack(props) {
        let goBack = typeof(props.goBack) === 'undefined'
            ? props.navigation.goBack
            : props.goBack;
        return (<View style={styles.headerContainer}>
            <TouchableWithoutFeedback onPress={() => {
                goBack()
            }}>
                <View style={{
                    position: 'absolute',
                    left: 0,
                    height: 40 * screenScale,
                    width: 50 * screenScale,
                    justifyContent: 'center'
                }}>
                    <Image style={styles.headerBack} source={ImageBuilder.getImage('common_btn_back')}/>
                </View>
            </TouchableWithoutFeedback>
            <Text style={styles.headerText}>{props.title}</Text>
        </View>)
    }
}

class HasBackAndRightHeader extends Component {
    render() {
        return this.renderHasBackAndRightImg(this.props.props)
    }

    renderHasBackAndRightImg(props) {
        let goBack = typeof(props.goBack) === 'undefined'
            ? props.navigation.goBack
            : props.goBack;
        let rightImg = props.rightImg;
        let rightAction = props.rightAction;
        let rightStyle = typeof(props.rightStyle) === 'undefined'
            ? {
                width: 18 * screenScale,
                height: 6 * screenScale
            }
            : props.rightStyle;

        return (<View style={styles.headerContainer}>
            <TouchableWithoutFeedback onPress={() => {
                goBack()
            }}>
                <View style={{
                    position: 'absolute',
                    left: 0,
                    height: 40 * screenScale,
                    width: 50 * screenScale,
                    justifyContent: 'center'
                }}>
                    <Image style={styles.headerBack} source={ImageBuilder.getImage('common_btn_back')}/>
                </View>
            </TouchableWithoutFeedback>
            <Text style={styles.headerText}>{props.title}</Text>
            <TouchableWithoutFeedback onPress={rightAction}>
                <View style={{
                    position: 'absolute',
                    right: 0,
                    height: 40 * screenScale,
                    width: 35 * screenScale,
                    justifyContent: 'center'
                }}>
                    <Image style={rightStyle} source={rightImg}/>
                </View>
            </TouchableWithoutFeedback>
        </View>)
    }
}

class HasBackAndRightHeaderText extends Component {
    render() {
        return this.renderHasBackAndRightText(this.props.props)
    }

    renderHasBackAndRightText(props) {
        let goBack = typeof(props.goBack) === 'undefined'
            ? props.navigation.goBack
            : props.goBack;
        let rightText = props.rightText;
        let rightAction = props.rightAction;
        let rightStyle = typeof(props.rightStyle) === 'undefined'
            ? {
                width: 30 * screenScale,
                height: 14 * screenScale,
                color:'#666666'
            }
            : props.rightStyle;

        return (<View style={styles.headerContainer}>
            <TouchableWithoutFeedback onPress={() => {
                goBack()
            }}>
                <View style={{
                    position: 'absolute',
                    left: 0,
                    height: 40 * screenScale,
                    width: 50 * screenScale,
                    justifyContent: 'center'
                }}>
                    <Image style={styles.headerBack} source={ImageBuilder.getImage('common_btn_back')}/>
                </View>
            </TouchableWithoutFeedback>
            <Text style={styles.headerText}>{props.title}</Text>
            <TouchableWithoutFeedback onPress={rightAction}>
                <View style={{
                    position: 'absolute',
                    right: 0,
                    height: 40 * screenScale,
                    width: 35 * screenScale,
                    justifyContent: 'center'
                }}>
                    <Text style={rightStyle}>{rightText}</Text>
                </View>
            </TouchableWithoutFeedback>
        </View>)
    }
}

class CommonHeaderView extends Component {

    render() {
            return this.renderIos(this.props);
    }

    renderIos(props) {
        let realHeader;
        let isShowBack = this.props.isShowBack === true;
        let isShowRightImg = this.props.isShowRightImg === true;
        let isShowRightText = this.props.isShowRightText === true;

        if (isShowBack && !isShowRightImg && !isShowRightText) {
            return (<HasBackHeader props={props}></HasBackHeader>)
        }
        if (isShowBack && isShowRightImg) {
            return (<HasBackAndRightHeader props={props}></HasBackAndRightHeader>)
        }
        if (isShowBack && isShowRightText) {
            return (<HasBackAndRightHeaderText props={props}></HasBackAndRightHeaderText>)
        }
        return (<NomalHeader props={props}></NomalHeader>)

    }

    renderAndroid(props) {
        let isShowBack = this.props.isShowBack === true;
        let isShowRightImg = this.props.isShowBack === true;
        if (isShowBack && !isShowRightImg) {
            return (<HasBackHeader props={props}/>);
        }
        if (isShowBack && isShowRightImg) {
            return (<HasBackAndRightHeader props={props}/>)
        }
        return <NomalHeader props={props}/>
    }
}

const styles = StyleSheet.create({
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
module.exports = CommonHeaderView;
