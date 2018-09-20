/**
 * @providesModule StoryPage
 */

'use strict';

import React, {Component} from 'react';
import {StyleSheet, Text, View, Button} from 'react-native';
class StoryPage extends Component {

  render() {
    return (<View style={styles.container}>
      <Text style={styles.welcome}>
        Welcome to 故事sajdsajd!
      </Text>
    </View>);
  }
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF'
  },
  welcome: {
    fontSize: 40,
    textAlign: 'center',
    margin: 10
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5
  }
});
module.exports = StoryPage;
