/**
 * Created by flyye on 22/9/28.
* @providesModule SpaceDramaScreen
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
  ListView
} from 'react-native';

import {StackNavigator} from 'react-navigation';
var ImageBuilder = require('CommonImageBuilder');
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
var SCNavigator = require('SCNavigator');

class SpaceDrama extends Component {

  constructor(props) {
    super(props);
    var listDs = new ListView.DataSource({
      rowHasChanged: (r1, r2) => r1 !== r2
    });

    this.state = {
      dataSource: listDs,
      data: [
        {
          name: '亡命追铺',
          avatar_url: 'https://s3.amazonaws.com/uifaces/faces/twitter/ladylexy/128.jpg',
          subtitle: '叶文洁、艾AA等2人签到',
          updateTime: '9月3日',
          length: '178'
        }, {
          name: '亡命追铺',
          avatar_url: 'https://s3.amazonaws.com/uifaces/faces/twitter/ladylexy/128.jpg',
          subtitle: '叶文洁、艾AA等2人签到',
          updateTime: '9月3日',
          length: '9千8'
        }, {
          name: '亡命追铺',
          avatar_url: 'https://s3.amazonaws.com/uifaces/faces/twitter/ladylexy/128.jpg',
          subtitle: '叶文洁、艾AA等2人签到',
          updateTime: '8:53',
          length: '347'
        }, {
          name: '亡命追铺',
          avatar_url: 'https://s3.amazonaws.com/uifaces/faces/twitter/ladylexy/128.jpg',
          subtitle: '叶文洁、艾AA等2人签到',
          updateTime: '9月3日',
          length: '432'
        }, {
          name: '亡命追铺',
          avatar_url: 'https://s3.amazonaws.com/uifaces/faces/twitter/ladylexy/128.jpg',
          subtitle: '叶文洁、艾AA等2人签到',
          updateTime: '8:53',
          length: '5千3字'
        }, {
          name: '亡命追铺',
          avatar_url: 'https://s3.amazonaws.com/uifaces/faces/twitter/ladylexy/128.jpg',
          subtitle: '叶文洁、艾AA等2人签到',
          updateTime: '9月3日',
          length: '178'
        }, {
          name: '亡命追铺',
          avatar_url: 'https://s3.amazonaws.com/uifaces/faces/twitter/ladylexy/128.jpg',
          subtitle: '叶文洁、艾AA等2人签到',
          updateTime: '9月3日',
          length: '9千8'
        }, {
          name: '亡命追铺',
          avatar_url: 'https://s3.amazonaws.com/uifaces/faces/twitter/ladylexy/128.jpg',
          subtitle: '叶文洁、艾AA等2人签到',
          updateTime: '8:53',
          length: '347'
        }, {
          name: '亡命追铺',
          avatar_url: 'https://s3.amazonaws.com/uifaces/faces/twitter/ladylexy/128.jpg',
          subtitle: '叶文洁、艾AA等2人签到',
          updateTime: '9月3日',
          length: '432'
        }, {
          name: '亡命追铺',
          avatar_url: 'https://s3.amazonaws.com/uifaces/faces/twitter/ladylexy/128.jpg',
          subtitle: '叶文洁、艾AA等2人签到',
          updateTime: '8:53',
          length: '5千3字'
        }
      ]
    };
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
        <View style={{
            width: 15 * screenScale
          }}></View>
        <Avatar width={50 * screenScale} height={50 * screenScale} rounded={true} source={{
            uri: rowData.avatar_url
          }} onPress={() => console.log("Works!")} activeOpacity={0.7}/>
        <View style={{
            flexDirection: 'row',
            flex: 1,
            marginRight: 15 * screenScale,
            marginLeft: 15 * screenScale
          }}>
          <View style={styles.leftText}>
            <Text style={styles.leftTitle}>{rowData.name}</Text>
            <Text style={styles.leftDetail}>{rowData.subtitle}</Text>
          </View>
          <View style={styles.rightText}>
            <Text style={styles.rightTime}>{rowData.updateTime}</Text>
            <Text style={styles.textLenght}>{rowData.length}</Text>
          </View>
        </View>
      </View>
    </View>)
  }

  render() {
    return (<ListView renderRow={(rowData, sectionId, rowID) => this.renderRow(rowData, rowID)} dataSource={this.state.dataSource.cloneWithRows(this.state.data)}/>)
  }
}

const SpaceDramaScreen = StackNavigator({
  SpaceDrama: {
    screen: SpaceDrama,
    navigationOptions: {
      header: ({navigation}) => {
        return (<CommonHeaderView goBack={() => SCNavigator.pop()} isShowBack={true} navigation={navigation} title={'三体-大戏'}></CommonHeaderView>)
      }
    }
  }
}, {initialRouteName: 'SpaceDrama'});

const styles = StyleSheet.create({
  container: {
    flexDirection: 'column',
    flex: 1,
    backgroundColor: '#EEEEEE',
    alignItems: 'center'
  },
  itemContainer: {
    height: 70 * screenScale,
    flexDirection: 'row',
    backgroundColor: '#FFFFFF',
    alignItems: 'center'
  },
  leftTitle: {
    fontSize: 14 * fontScale,
    color: '#666666',
    marginBottom: 13 * screenScale
  },
  leftDetail: {
    fontSize: 12 * fontScale,
    color: '#B3B3B3'
  },
  rightTime: {
    fontSize: 14 * fontScale,
    color: '#888888',
    marginBottom: 13 * screenScale
  },
  textLenght: {
    fontSize: 14 * fontScale,
    color: '#3BBAC8'
  },
  leftText: {
    flex: 220,
    flexDirection: 'column',
    alignItems: 'flex-start'
  },
  rightText: {
    flex: 60,
    flexDirection: 'column',
    alignItems: 'flex-end'
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
module.exports = SpaceDramaScreen;
