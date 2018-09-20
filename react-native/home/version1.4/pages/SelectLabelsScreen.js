/**
 * Created by wangweilin on 2017-11-28.
 * @providesModule SelectLabelsScreen
 */


'use strict';

import React, {Component} from 'react';
import {
    StyleSheet,
    View,
    Text,
    Dimensions,
    TextInput,
    Image,
    TouchableWithoutFeedback
} from 'react-native';

import {
    StackNavigator,
} from 'react-navigation';

import CommonHeaderView from 'CommonHeaderView';
import SCNavigator from 'SCNavigator';
import ImageBuilder from '../utils/ImageBuilder';

const {width, height, scale, fontScale} = Dimensions.get('window');
const screenScale = width / 375;

class SelectLabels extends Component {
    constructor(props) {
        super(props);
        this.state={
            isPress:false
        }
    }

    componentWillMount() {

    }

    refreshData() {

    }

    render() {
        return (
            <View>
                <View style={styles.header}>
                    <Image style={styles.headerLeftImage}
                           source={ImageBuilder.getImage('search_btn')}/>
                    <TextInput placeholder='自定义标签'
                               placeholderTextColor='#B3B3B3'
                               selectionColor='#000000'
                               style={styles.headerTextInput}
                    ></TextInput>
                    <Image style={styles.headerRigheImage}
                           source={ImageBuilder.getImage('delete_btn')}/>
                </View>
                <View style={styles.middle}>
                    <TouchableWithoutFeedback onPress={() => {
                        if(this.state.isPress){
                            this.setState({
                                isPress:false
                            })
                        }else {
                            this.setState({
                                isPress:true
                            })
                        }
                    }}>
                        <View style={this.state.isPress?styles.middleRowCheckedButton:styles.middleRowButton}>
                            <Text style={this.state.isPress?styles.middleRowCheckedBtnText:styles.middleRowBtnText}>
                                历史
                            </Text>
                        </View>
                    </TouchableWithoutFeedback>
                    <View style={styles.middleRowButton}>
                        <Text style={styles.middleRowBtnText}>
                            历史
                        </Text>
                    </View>
                    <View style={styles.middleRowButton}>
                        <Text style={styles.middleRowBtnText}>
                            军事
                        </Text>
                    </View>
                    <View style={styles.middleRowButton}>
                        <Text style={styles.middleRowBtnText}>
                            历史
                        </Text>
                    </View>
                    <View style={styles.middleRowButton}>
                        <Text style={styles.middleRowBtnText}>
                            军事
                        </Text>
                    </View>
                </View>
            </View>

        );
    }
}

const SelectLabelsScreen = StackNavigator({
        SelectLabels: {
            screen: SelectLabels,
            navigationOptions: {
                header: ({navigation}) => {
                    return (<CommonHeaderView
                        goBack={() => SCNavigator.pop()} isShowBack={true}
                        isShowRightText={true}
                        rightText='确定'
                        rightAction={() => SCNavigator.pushNativePage('page_add_topic', '')}
                        navigation={navigation} title={'选择标签'}>
                    </CommonHeaderView>)
                }
            }
        }
    },
    {
        initialRouteName: 'SelectLabels'
    });


const styles = StyleSheet.create({
    header: {
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: '#FFFFFF',
        borderRadius: 20 * screenScale,
        marginLeft: 15 * screenScale,
        marginRight: 15 * screenScale,
        marginTop: 6 * screenScale,
        marginBottom: 6 * screenScale,
    },
    headerLeftImage: {
        marginLeft: 10 * screenScale,
        width: 20 * screenScale,
        height: 20 * screenScale,
    },
    headerTextInput: {
        fontSize: 14 * fontScale,
        margin: 10 * screenScale,
        color: '#B3B3B3',
        flex: 1
    },
    headerRigheImage: {
        marginRight: 10 * screenScale,
        width: 20 * screenScale,
        height: 20 * screenScale,
    },
    middle: {
        flex: 1,
        flexDirection: 'row',
        flexWrap: 'wrap',
        justifyContent: 'space-around',
        backgroundColor: '#F8F8F8',

    },
    middleRowButton: {
        width: 105 * screenScale,
        height: 40 * screenScale,
        marginTop: 10 * screenScale,
        backgroundColor: '#FFFFFF',
        justifyContent: 'center',
        alignItems: 'center'
    },
    middleRowCheckedButton: {
        width: 105 * screenScale,
        height: 40 * screenScale,
        marginTop: 10 * screenScale,
        backgroundColor: '#00AAF6',
        justifyContent: 'center',
        alignItems: 'center'
    },
    middleRowBtnText: {
        fontSize: 14 * fontScale,
        color: '#666666'
    },
    middleRowCheckedBtnText: {
        fontSize: 14 * fontScale,
        color: '#FFFFFF'
    }

});
module.exports = SelectLabelsScreen;