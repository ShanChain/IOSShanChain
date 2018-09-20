/**
 * Created by flyye on 22/9/28.
* @providesModule EmptyScreen
 */

'use strict';

import React, {Component} from 'react';
import {
  StyleSheet,
  Text,
  View,
  Switch,
  TouchableWithoutFeedback,
  Image
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
var SCNavigator = require('SCNavigator');

class EmptyPage extends Component {

  constructor(props) {
    super(props);
    this.state = {
      page: {
        MyDramasScreen: {
          title: '我的大戏',
          detail: '暂时还没添加大戏，可以现在去对戏～',
          imageName: 'my_drama_empty'
        },
        MyRolesScreen: {
          title: '我的角色',
          detail: '暂时还没添加角色，可以现在去添加～',
          imageName: 'my_role_empty'
        },
        MyDraftScreen: {
          title: '我的草稿',
          detail: '暂时还没草稿～',
          imageName: 'my_draft_empty'
        },
        MyStoryScreen: {
          title: '我的故事',
          detail: '暂时还没添加故事哦～',
          imageName: 'my_story_empty'
        },
        MyCommentsScreen: {
          title: '我的评论',
          detail: '暂时还没评论哦～',
          imageName: 'my_comment_empty'
        },
        MyLikedScreen: {
          title: '我赞赏的',
          detail: '暂时还没赞过哦～',
          imageName: 'my_liked_empty'
        }
      }
    }
  }

  getScreenState(screen) {
    switch (screen) {
      case 'MyDramasScreen':
        return this.state.page.MyDramasScreen
      case 'MyRolesScreen':
        return this.state.page.MyRolesScreen
      case 'MyDraftScreen':
        return this.state.page.MyDraftScreen
      case 'MyStoryScreen':
        return this.state.page.MyStoryScreen
      case 'MyCommentsScreen':
        return this.state.page.MyCommentsScreen
      case 'MyLikedScreen':
        return this.state.page.MyLikedScreen
      default:
        return this.state.page.MyCommentsScreen
    }
  }
  render() {
    let screenProps = JSON.parse(this.props.screenProps)
    return (<View style={styles.container}>
      <TouchableWithoutFeedback >
        <Image style={{
            height: 120 * screenScale,
            width: 120 * screenScale,
            marginBottom: 20 * screenScale
          }} source={ImageBuilder.getImage(this.getScreenState(screenProps.screenName).imageName)}/>
      </TouchableWithoutFeedback>
      <Text style={{
          fontSize: 18 * fontScale,
          color: '#666666'
        }}>{this.getScreenState(screenProps.screenName).detail}</Text>
    </View>);
  }
}

const EmptyScreen = StackNavigator({
  EmptyPage: {
    screen: EmptyPage,
    navigationOptions: {
      header: ({navigation}) => {
        return (<CommonHeaderView goBack={() => SCNavigator.pop()} isShowBack={true} navigation={navigation} title='我的草稿'></CommonHeaderView>)
      }
    }
  }
}, {initialRouteName: 'EmptyPage'});

const styles = StyleSheet.create({
  container: {
    flexDirection: 'column',
    flex: 1,
    backgroundColor: '#EEEEEE',
    alignItems: 'center',
    justifyContent: 'center'
  }
});
module.exports = EmptyScreen;
