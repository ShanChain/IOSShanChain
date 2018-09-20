/**
 * Created by flyye on 22/9/28.
* @providesModule HeadlinesScreen
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
var SCNavigator = require('SCNavigator');

class Headlines extends Component {

  constructor(props) {
    super(props);
    var listDs = new ListView.DataSource({
      rowHasChanged: (r1, r2) => r1 !== r2
    });

    this.state = {
      dataSource: listDs,
      data: [
        {
          avatar_url: 'topic1',
          title: '习近平等党和国家领导人出席烈士纪念日向人民英雄敬献花篮仪式',
          updateTime: '9月29日',
          spaceName: '大中华世纪园'
        }, {
          avatar_url: 'topic1',
          title: '习近平等党和国家领导人出席烈士纪念日向人民英雄敬献花篮仪式',
          updateTime: '9月29日',
          spaceName: '大中华世纪园'
        }, {
          avatar_url: 'topic1',
          title: '习近平等党和国家领导人出席烈士纪念日向人民英雄敬献花篮仪式',
          updateTime: '9月29日',
          spaceName: '大中华世纪园'
        }, {
          avatar_url: 'topic1',
          title: '习近平等党和国家领导人出席烈士纪念日向人民英雄敬献花篮仪式',
          updateTime: '9月29日',
          spaceName: '大中华世纪园'
        }, {
          avatar_url: 'topic1',
          title: '习近平等党和国家领导人出席烈士纪念日向人民英雄敬献花篮仪式',
          updateTime: '9月29日',
          spaceName: '大中华世纪园'
        }, {
          avatar_url: 'topic1',
          title: '习近平等党和国家领导人出席烈士纪念日向人民英雄敬献花篮仪式',
          updateTime: '9月29日',
          spaceName: '大中华世纪园'
        }, {
          avatar_url: 'topic1',
          title: '习近平等党和国家领导人出席烈士纪念日向人民英雄敬献花篮仪式',
          updateTime: '9月29日',
          spaceName: '大中华世纪园'
        }, {
          avatar_url: 'topic1',
          title: '习近平等党和国家领导人出席烈士纪念日向人民英雄敬献花篮仪式',
          updateTime: '9月29日',
          spaceName: '大中华世纪园'
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
        <Image style={{
            width: 70 * screenScale,
            height: 70 * screenScale
          }} source={ImageBuilder.getImage(rowData.avatar_url)}/>
        <View style={{
            flexDirection: 'row',
            flex: 1,
            marginRight: 20 * screenScale,
            marginLeft: 20 * screenScale
          }}>
          <View style={styles.leftText}>
            <Text style={styles.title}>{rowData.title}</Text>
            <View style={{
                flexDirection: 'row',
                alignItems: 'flex-start'
              }}>
              <Text style={styles.spaceName}>{rowData.spaceName}</Text>
              <View style={{
                  flex: 1
                }}></View>
              <Text style={{
                  fontSize: 12 * fontScale,
                  color: '#B3B3B3'
                }}>{rowData.updateTime}</Text>
            </View>
          </View>
        </View>
      </View>
    </View>)
  }

  render() {
    return (<ListView renderRow={(rowData, sectionId, rowID) => this.renderRow(rowData, rowID)} dataSource={this.state.dataSource.cloneWithRows(this.state.data)}/>)
  }
}

const HeadlinesScreen = StackNavigator({
  Headlines: {
    screen: Headlines,
    navigationOptions: {
      header: ({navigation}) => {
        return (<CommonHeaderView goBack={() => SCNavigator.pop()} isShowBack={true} navigation={navigation} title={'报社头条'}></CommonHeaderView>)
      }
    }
  }
}, {initialRouteName: 'Headlines'});

const styles = StyleSheet.create({
  container: {
    flexDirection: 'column',
    flex: 1,
    backgroundColor: '#EEEEEE',
    alignItems: 'center'
  },
  itemContainer: {
    height: 100 * screenScale,
    flexDirection: 'row',
    backgroundColor: '#FFFFFF',
    alignItems: 'center'
  },
  spaceName: {
    fontSize: 12 * fontScale,
    color: '#3BBAC8'
  },
  title: {
    height: 56 * screenScale,
    fontSize: 16 * fontScale,
    marginBottom: 5 * screenScale,
    color: '#333333'
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
  }

});
module.exports = HeadlinesScreen;
