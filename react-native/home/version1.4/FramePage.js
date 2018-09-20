/**
 * Created by flyye on 22/9/17.
 * @providesModule FramePage
 *
 */
'use strict';

import React, {Component} from 'react';
import {StyleSheet, Text, View, Button} from 'react-native';
import {DrawerNavigator, StackNavigator} from 'react-navigation';
import MyNovelsScreen from 'MyNovelsScreen';

import Dimensions from 'Dimensions';

var {
    width,
    height,
    scale,
    fontScale
} = Dimensions.get('window');
var screenScale = width / 375;

const HomeScreen = ({navigation}) => (
    <View style={{flex: 1, alignItems: 'center', justifyContent: 'center'}}>
        <Text>Home Screen</Text>
        <Button
            onPress={() => navigation.navigate('Details')}
            title="Go to details"
        />
    </View>
);

const DetailsScreen = () => (
    <View style={{flex: 1, alignItems: 'center', justifyContent: 'center'}}>
        <Text>Details Screen</Text>
    </View>
);

const RootNavigator = StackNavigator({
    Home: {
        screen: HomeScreen,
        navigationOptions: {
            headerTitle: 'Home',
            headerRight: <Button title="Info" />
        },
    },
    Details: {
        screen: DetailsScreen,
        navigationOptions: {
            headerTitle: 'Details',
            headerRight: <Button title="Info" />
        },
    },
});

const TabsNavigator = DrawerNavigator({
    RootNavigator: {
        screen: RootNavigator,
        navigationOptions: {
            headerTitle: 'RootNavigator',
        },
    },
    MyNovelsScreen: {
        screen: MyNovelsScreen,
        navigationOptions: {
            headerTitle: 'MyNovelsScreen',
        },
    },
});


class FramePage extends Component {
    constructor(props) {
        super(props);

    }

    componentWillMount() {

    }

    render() {
        return (
            <View style={styles.container}>
                <TabsNavigator/>
            </View>
        );
    }
};

const styles = StyleSheet.create({
    container: {
        flex: 1
    }
});

module.exports = FramePage;
