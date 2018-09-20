/**
 * Created by flyye on 22/9/17.
 * @providesModule PullViewDemo
 */

import React, {Component} from 'react';
import {StyleSheet, Text, View, ActivityIndicator, ListView} from 'react-native';

import {PullList} from 'react-native-pull';
class PullViewDemo extends Component {

  constructor(props) {
    super(props);
    this.dataSource = [];
    this.state = {
      list: (new ListView.DataSource({
        rowHasChanged: (r1, r2) => r1 !== r2
      })).cloneWithRows(this.dataSource)
    };

    this.renderRow = this.renderRow.bind(this);
    this.renderFooter = this.renderFooter.bind(this);
    this.loadMore = this.loadMore.bind(this);
    // this.loadMore();
  }

  onPullRelease(resolve) {
    //do something
    setTimeout(() => {
      resolve();
    }, 3000);
  }

  render() {
    return (<View style={styles.container}>
      <PullList style={{}} onPullRelease={this.onPullRelease} dataSource={this.state.list} pageSize={5} initialListSize={5} renderRow={this.renderRow} onEndReached={this.loadMore} onEndReachedThreshold={60} renderFooter={this.renderFooter}/>
    </View>);
  }

  renderRow(item, sectionID, rowID, highlightRow) {
    return (<View style={{
        height: 50,
        backgroundColor: '#fafafa',
        alignItems: 'center',
        justifyContent: 'center'
      }}>
      <Text>{item.title}</Text>
    </View>);
  }

  renderFooter() {
    if (this.state.nomore) {
      return null;
    }
    return (<View style={{
        height: 100
      }}>
      <ActivityIndicator/>
    </View>);
  }

  loadMore() {
    this.dataSource.push({id: 0, title: `begin to create data ...`});
    for (var i = 0; i < 5; i++) {
      this.dataSource.push({
        id: i + 1,
        title: `this is ${i}`
      })
    }
    this.dataSource.push({id: 6, title: `finish create data ...`});
    setTimeout(() => {
      this.setState({
        list: this.state.list.cloneWithRows(this.dataSource)
      });
    }, 1000);
  }

}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    flexDirection: 'column',
    backgroundColor: '#F5FCFF'
  }
});
module.exports = PullViewDemo;
