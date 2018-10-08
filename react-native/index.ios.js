/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */
'use strict';

console.disableYellowBox = true;

var React = require('react-native');
var {
  AppRegistry,
} = React;
//主页

AppRegistry.registerComponent('StoryPage', () => require('StoryPage'));
AppRegistry.registerComponent('ChatPage', () => require('ChatPage'));
AppRegistry.registerComponent('SquarePage', () => require('SquarePage'));
AppRegistry.registerComponent('MinePage', () => require('MinePage'))

//故事

//对话

//广场
// AppRegistry.registerComponent('CrossRulePage', () => require('CrossRulePage'));
AppRegistry.registerComponent('SpaceNovelScreen', () => require('SpaceNovelScreen'));
AppRegistry.registerComponent('SpaceDramaScreen', () => require('SpaceDramaScreen'));
AppRegistry.registerComponent('SpaceRolesScreen', () => require('SpaceRolesScreen'));
AppRegistry.registerComponent('SpaceTopicsScreen', () => require('SpaceTopicsScreen'));
AppRegistry.registerComponent('HeadlinesScreen', () => require('HeadlinesScreen'));
AppRegistry.registerComponent('SpaceBGImgScreen', () => require('SpaceBGImgScreen'));
AppRegistry.registerComponent('SpaceBGChooseImgScreen', () => require('SpaceBGChooseImgScreen'));
AppRegistry.registerComponent('SpaceIntroScreen', () => require('SpaceIntroScreen'));
AppRegistry.registerComponent('CrossRuleScreen', () => require('CrossRuleScreen'));
AppRegistry.registerComponent('NotificationScreen', () => require('NotificationScreen'));
AppRegistry.registerComponent('RoleDetailScreen', () => require('RoleDetailScreen'));
AppRegistry.registerComponent('SpaceLeadersScreen', () => require('SpaceLeadersScreen'));

AppRegistry.registerComponent('SpaceRulesScreen', () => require('SpaceRulesScreen'));

// AppRegistry.registerComponent('SpaceManagerPage', () => require('SpaceManagerPage'));
// AppRegistry.registerComponent('SquareBGManagerPage', () => require('SquareBGManagerPage'));
// AppRegistry.registerComponent('ResentTopicsPage', () => require('ResentTopicsPage'));
//
// //我的
// AppRegistry.registerComponent('FansPage', () => require('FansPage'));
// AppRegistry.registerComponent('UserPage', () => require('UserPage'));
// AppRegistry.registerComponent('MyStoriesPage', () => require('MyStoriesPage'));
// AppRegistry.registerComponent('MyChatsPage', () => require('MyChatsPage'));
AppRegistry.registerComponent('MyNovelsScreen', () => require('MyNovelsScreen'));
AppRegistry.registerComponent('MyDramasScreen', () => require('MyDramasScreen'));
AppRegistry.registerComponent('MyRolesScreen', () => require('MyRolesScreen'));
AppRegistry.registerComponent('ChangeBrandScreen', () => require('ChangeBrandScreen'));
AppRegistry.registerComponent('EmptyScreen', () => require('EmptyScreen'));
AppRegistry.registerComponent('MyDraftScreen', () => require('MyDraftScreen'));
AppRegistry.registerComponent('FeedbackScreen', () => require('FeedbackScreen'));
AppRegistry.registerComponent('MyChatsScreen', () => require('MyChatsScreen'));
AppRegistry.registerComponent('SecurityScreen', () => require('SecurityScreen'));
AppRegistry.registerComponent('MSGSettingScreen', () => require('MSGSettingScreen'));
// AppRegistry.registerComponent('MyDraftPage', () => require('MyDraftPage'));
AppRegistry.registerComponent('AboutMeScreen', () => require('AboutMeScreen'));
AppRegistry.registerComponent('SettingScreen', () => require('SettingScreen'));
AppRegistry.registerComponent('MyCommentsScreen', () => require('MyCommentsScreen'));
AppRegistry.registerComponent('MyPraisesScreen', () => require('MyPraisesScreen'));
AppRegistry.registerComponent('MyStorysScreen', () => require('MyStorysScreen'));
AppRegistry.registerComponent('FramePage', () => require('FramePage'));
