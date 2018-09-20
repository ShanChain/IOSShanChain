/**
 * Created by flyye on 21/9/17.
 */

'use strict';

import React, {Component} from 'react';
import {
  StyleSheet,
  Text,
  View,
  Buttom,
  Image,
  ScrollView,
  ImageBackground,
  TouchableWithoutFeedback
} from 'react-native';
var createReactClass = require('create-react-class');
var ImageBuilder = require('../utils/ImageBuilder');
var Dimensions = require('Dimensions');
var {
  width,
  height,
  scale,
  fontScale
} = Dimensions.get('window');
var screenScale = width / 375;
var SCCacheHelper = require('SCCacheHelper');
var SCNetwork = require('SCNetwork');
var SCNavigator = require('SCNavigator');
var CommonUrlMap = require('CommonUrlMap')
var SCPropUtils = require('SCPropUtils')

export default class SpaceBriefItem extends React.PureComponent {

  static defaultProps = {
    title: '',
    spaceSlogan: '',
    starCount: 0,
    content: '',
    backgroundImg: '',
    isFans: false,
    isExpand: false
  };

  constructor(props) {
    super(props);
    this.state = {
      gData: typeof(props.gData) === 'undefined'
        ? ''
        : props.gData,
      isFans: false,
      starCount: 0
    };
  }
  componentWillMount() {
    let gData = this.state.gData;
    if (gData !== '') {
      this.refreshData(gData);
    }
  }

  componentWillReceiveProps() {
    this.setState({starCount: this.props.starCount});
  }

  refreshData(gData) {
    SCNetwork.post(CommonUrlMap.IS_SPACE_IS_FAV, {
      spaceId: gData.spaceId,
      token: gData.token,
      userId: gData.userId
    }).then(result => {
      this.setState({isFans: result.data})
    }).catch(err => {});
  }

  setFansPress(isFans) {
    if (isFans) {
      SCNetwork.post(CommonUrlMap.FOCUS_SPACE, {
        spaceId: this.state.gData.spaceId,
        token: this.state.gData.token,
        userId: this.state.gData.userId
      }).then(result => {
        this.setState({
          isFans: true,
          starCount: this.state.starCount + 1
        })
      }).catch(err => {});
    } else {
      SCNetwork.post(CommonUrlMap.CANCEL_FOCUS_SPACE, {
        spaceId: this.state.gData.spaceId,
        token: this.state.gData.token,
        userId: this.state.gData.userId
      }).then(result => {
        this.setState({
          isFans: false,
          starCount: this.state.starCount - 1
        })
      }).catch(err => {});
    }

  }

  render() {
    let {title, spaceSlogan, starCount, content, backgroundImg} = this.props;

    return (<View style={styles.container}>
      <TouchableWithoutFeedback onPress={() => {
          //  SCNavigator.pushRNPage('SpaceBGChooseImgScreen',JSON.stringify({gData:this.state.gData}))

        }}>
        <ImageBackground style={{
            flex: 1,
            width: width,
            flexDirection: 'column',
            justifyContent: 'center'
          }} source={{
            uri: backgroundImg
          }}>
          <View style={styles.SpaceAbout}>
            <View style={styles.titleContainer}>
              <Text style={{
                  fontSize: 14 * fontScale,
                  color: '#FFFFFF',
                  marginBottom: width * 10 / 375,
                  backgroundColor: 'rgba(0,0,0,0)'
                }}>
                {title}
              </Text>
              <Text style={styles.spaceText}>
                {spaceSlogan.substring(0, 25)}
              </Text>
            </View>
            <TouchableWithoutFeedback onPress={() => this.setFansPress(!this.state.isFans)}>
              <View style={styles.fans}>
                <Image style={{
                    width: width * 21 / 375,
                    height: width * 21 / 375,
                    marginBottom: width * 10 / 375
                  }} source={this.state.isFans
                    ? ImageBuilder.getImage('follow_true')
                    : ImageBuilder.getImage('follow_false')}/>
                <Text style={styles.spaceText}>{this.state.starCount}收藏</Text>
              </View>
            </TouchableWithoutFeedback>
          </View>
          <View style={styles.flexSpace} onPress={this.spacePress}></View>
          <View >
            {
              this.state.isExpand
                ? (<Text style={{
                    margin: width * 10 / 375,
                    height: 80 * screenScale,
                    fontSize: 12 * fontScale,
                    color: '#FFFFFF',
                    backgroundColor: 'rgba(0,0,0,0)'
                  }} onPress={this.breviaryPress}>
                  {content}
                </Text>)
                : (<Text style={{
                    margin: width * 10 / 375,
                    height: 50 * screenScale,
                    fontSize: 12 * fontScale,
                    color: '#FFFFFF',
                    backgroundColor: 'rgba(0,0,0,0)'
                  }} onPress={this.breviaryPress}>
                  {content}
                </Text>)
            }

            <TouchableWithoutFeedback onPress={() => this.setState({
                isExpand: !this.state.isExpand
              })}>
              <View style={styles.expendContent}>
                <Text style={{
                    fontSize: 12 * fontScale,
                    color: '#3BBAC8',
                    backgroundColor: 'rgba(0,0,0,0)'
                  }} onPress={this.expendPress}>
                  {
                    this.state.isExpand
                      ? '收缩'
                      : '展开'
                  }
                  <Image style={{
                      height: 6 * screenScale,
                      width: 12 * screenScale
                    }} source={ImageBuilder.getImage('btn_more_blue')}></Image>
                </Text>
              </View>
            </TouchableWithoutFeedback>
          </View>
        </ImageBackground>
      </TouchableWithoutFeedback>
    </View>)
  }
}

const styles = StyleSheet.create({
  container: {
    height: height * 240 / 667,
    flexDirection: 'column'

  },
  spaceText: {
    fontSize: 14 * fontScale,
    color: '#FFFFFF',
    backgroundColor: 'rgba(0,0,0,0)'
  },
  SpaceAbout: {
    height: 70 * screenScale,
    margin: width * 10 / 375,
    flexDirection: 'row'
  },
  flexSpace: {
    flex: 1
  },
  titleContainer: {
    flex: 228,
    flexDirection: 'column'
  },
  fans: {
    flex: 117,
    alignItems: 'flex-end'
  },
  expendContent: {
    flexDirection: 'row',
    position: 'absolute',
    bottom: 10 * screenScale,
    right: 10 * screenScale
  }
});
module.exports = SpaceBriefItem;
