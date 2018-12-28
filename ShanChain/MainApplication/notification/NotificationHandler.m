//
//  NotificationHandler.m
//  ShanChain
//
//  Created by flyye on 2017/12/11.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationHandler.h"
#import "SCTabbarController.h"
#import "SCTabbarController.h"
#import "ShanChain-Swift.h"

//action_type
static NSString * const MSG_ACTION_TYPE = @"action_type";
static NSString * const MSG_ACTION_TYPE_OPEN_PAGE = @"open_page";
static NSString * const MSG_ACTION_TYPE_RED_POINT = @"red_point";
static NSString * const MSG_ACTION_TYPE_CUSTOM = @"custom_action";

//page_name action_type为open_page时使用
static NSString * const MSG_PAGE_NAME = @"page_name";
static NSString * const MSG_PAGE_STORY = @"story_page";
static NSString * const MSG_PAGE_CHAT = @"chat_page";
static NSString * const MSG_PAGE_MINE = @"mine_page";
static NSString * const MSG_PAGE_SPACE = @"space_page";
static NSString * const MSG_PAGE_SETTING = @"setting_page";
static NSString * const MSG_PAGE_ROLE = @"role_page";
static NSString * const MSG_PAGE_CHARACTER = @"character_page";
static NSString * const MSG_PAGE_CONTACT = @"contact_page";
static NSString * const MSG_PAGE_NOTIFICATION = @"notification_page";

//where action_type为red_point时使用
static NSString * const MSG_WHERE_SETTING = @"setting";
static NSString * const MSG_WHERE_STORY_TAB = @"story_tab";
static NSString * const MSG_WHERE_MINE_TAB = @"mine_tab";
static NSString * const MSG_WHERE_SPACE_TAB = @"space_tab";
static NSString * const MSG_WHERE_CHAT_TAB = @"chat_tab";
static NSString * const MSG_WHERE_CHAT_FATE = @"chat_fate";
static NSString * const MSG_WHERE_SPACE_RULE = @"space_rule";
static NSString * const MSG_WHERE_NOTIFICATION = @"notification";
static NSString * const MSG_WHERE_CHAT_MENU = @"chat_menu";
static NSString * const MSG_WHERE_SPACE_MENU = @"space_menu";


@implementation NotificationHandler

+ (void) handlerNotificationWithCustom:(NSDictionary *)customDic{
    
    if(customDic == nil || [customDic allKeys].count <= 0){
        return;
    }
    NSString *userId = [[SCCacheTool shareInstance] getCurrentUser];
      if (!NULLString(customDic[JM_COMVERSATION_TYPE])) {
                NSString  *conversationType = (NSString*)customDic[JM_COMVERSATION_TYPE];
                NSString  *userName = customDic[JM_USERNAME];
                NSString  *appkey = customDic[JM_APPKET];
                if ([conversationType isEqualToString:@"single"]) {
                    // 单聊
                    [JMSGConversation createSingleConversationWithUsername:userName appKey:appkey completionHandler:^(JMSGConversation * conversation, NSError *error) {
                        if (!error) {
                            [ChatPublicService jg_addFriendFeFocusWithFunsJmUserName:userName];
                            JCChatViewController *chatVC = [[JCChatViewController alloc]initWithConversation:conversation];
                            [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateConversation object:nil];
                            JCNavigationController *nav = [NotificationHandler mainNav];
                            [nav.topViewController.navigationController pushViewController:chatVC animated:YES];
                        }
                    }];
                }else if ([conversationType isEqualToString:@"group"]){
                    // 群聊
                }
            }
    
    
    if(customDic[@"send_userId"] != nil && [[customDic[@"send_userId"] stringValue] isEqualToString:userId]){
        return;
    }
    NSString *isReciveMsg = [[SCCacheTool shareInstance] getCacheValueInfoWithUserID:userId andKey:CACHE_USER_MSG_IS_RECEIVE];
    if(![NSString isBlankString:isReciveMsg] && [isReciveMsg isEqualToString:@"false"]){
        return;
    }
    NSString *msgKey = customDic[@"msg_key"];
    NSDictionary *msgBody = customDic[@"msg_body"];
    NSDictionary *actionBody = msgBody[@"action_body"];
    NSDictionary *params = actionBody[@"params"];
    NSString *time = customDic[@"create_time"];
    
    
    @try {
        if([msgBody[@"action_type"] isEqualToString:@"open_page"]){
            if ([actionBody[@"page_name"] isEqualToString:MSG_PAGE_STORY]){
                UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
                SCTabbarController *tabbarVC=[[SCTabbarController alloc]init];
                [tabbarVC setSelectedIndex:0];
                keyWindow.rootViewController=tabbarVC;
                return;
            }else if ([actionBody[@"page_name"] isEqualToString:MSG_PAGE_CHAT]){
                UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
                SCTabbarController *tabbarVC=[[SCTabbarController alloc]init];
                [tabbarVC setSelectedIndex:1];
                keyWindow.rootViewController=tabbarVC;
                return;
            }else if ([actionBody[@"page_name"] isEqualToString:MSG_PAGE_SPACE]){
                UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
                SCTabbarController *tabbarVC=[[SCTabbarController alloc]init];
                [tabbarVC setSelectedIndex:2];
                keyWindow.rootViewController=tabbarVC;
                return;
            }else if ([actionBody[@"page_name"] isEqualToString:MSG_PAGE_MINE]){
                UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
                SCTabbarController *tabbarVC=[[SCTabbarController alloc]init];
                [tabbarVC setSelectedIndex:3];
                keyWindow.rootViewController=tabbarVC;
                return;
            }else if ([actionBody[@"page_name"] isEqualToString:MSG_PAGE_CHARACTER]){
               
               
            }else if ([actionBody[@"page_name"] isEqualToString:MSG_PAGE_CONTACT]){
              
                return;
            }else if ([actionBody[@"page_name"] isEqualToString:MSG_PAGE_NOTIFICATION]){
       
                return;
            }else if ([actionBody[@"page_name"] isEqualToString:MSG_PAGE_ROLE]){
            
                return;
            }else if ([actionBody[@"page_name"] isEqualToString:MSG_PAGE_SETTING]){
   
                return;
            }
            
        }else if ([msgBody[@"action_type"] isEqualToString:@"red_point"]){
            NSString *msg = [[SCCacheTool shareInstance] getCacheValueInfoWithUserID:userId andKey:CACHE_USER_MSG];
            NSMutableDictionary *msgDic = nil;
            if(msg == nil || [msg isEqualToString:@""] ){
                msgDic = [[NSMutableDictionary alloc] init];
            }else{
                msgDic = [[JsonTool dictionaryFromString:msg] mutableCopy];
            }
            NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
            if([msgKey isEqualToString:MSG_KEY_CHARACTER_BE_FOCUS]){
                NSString *storyId = [params[@"storyId"] stringValue];
                NSString *characterId = [params[@"characterId"] stringValue];
                if([NSString isBlankString:storyId]){
                    return;
                }
                [data setValue:storyId forKey:@"storyId"];
                [data setValue:characterId forKey:@"characterId"];
                [data setValue:time forKey:@"time"];
                [msgDic setValue:data forKey:[MSG_KEY_CHARACTER_BE_FOCUS stringByAppendingString:storyId]];
            }else if ([msgKey isEqualToString:MSG_KEY_STORY_BE_COMMENT]){
                NSString *storyId = [params[@"storyId"] stringValue];
                NSString *characterId = [params[@"characterId"] stringValue];
                if([NSString isBlankString:storyId]){
                    return;
                }
                [data setValue:storyId forKey:@"storyId"];
                [data setValue:characterId forKey:@"characterId"];
                [data setValue:time forKey:@"time"];
                [msgDic setValue:data forKey:[MSG_KEY_STORY_BE_COMMENT stringByAppendingString:storyId]];
            }else if ([msgKey isEqualToString:MSG_KEY_DYNAMIC_BE_FORWARD]){
                NSString *storyId = [params[@"storyId"] stringValue];
                NSString *characterId = [params[@"characterId"] stringValue];
                if([NSString isBlankString:storyId]){
                    return;
                }
                [data setValue:storyId forKey:@"storyId"];
                [data setValue:characterId forKey:@"characterId"];
                [data setValue:time forKey:@"time"];
                [msgDic setValue:data forKey:[MSG_KEY_DYNAMIC_BE_FORWARD stringByAppendingString:storyId]];
            }else if ([msgKey isEqualToString:MSG_KEY_CHARACTER_BE_FOLLOW]){
                [data setValue:[params[@"characterId"] stringValue] forKey:@"characterId"];
                [data setValue:time forKey:@"time"];
                [msgDic setValue:data forKey:MSG_KEY_CHARACTER_BE_FOLLOW];
            }else if ([msgKey isEqualToString:MSG_KEY_STORY_BE_PRAISE]){
                NSString *storyId = [params[@"storyId"] stringValue];
                NSString *characterId = [params[@"characterId"] stringValue];
                if([NSString isBlankString:storyId]){
                    return;
                }
                [data setValue:storyId forKey:@"storyId"];
                [data setValue:characterId forKey:@"characterId"];
                [data setValue:time forKey:@"time"];
                [msgDic setValue:data forKey:[MSG_KEY_STORY_BE_PRAISE stringByAppendingString:storyId]];
            }
            
            if([data allKeys].count == 0){
                return;
            }
            [[SCCacheTool shareInstance] setCacheValue:[JsonTool stringFromDictionary:[msgDic copy]] withUserID:userId andKey:CACHE_USER_MSG];
            [[SCCacheTool shareInstance] setCacheValue:@"false" withUserID:userId andKey:CACHE_USER_MSG_READ_STATUS];
            UIViewController *rootVc = [[SCAppManager shareInstance] getRootViewController];
            if([rootVc isKindOfClass:[SCTabbarController class]]){
                [((SCTabbarController *)rootVc) showBadgeAtIndex:3 badgeValue:@" "];
                [((SCTabbarController *)rootVc) setNotificationsShowStatus:YES];
            }
        }
        
    }
    @catch (NSException *exception) {
         SCLog(@"Exception: %@", exception);
    }
    
}

+ (JCNavigationController*)mainNav{
    JCNavigationController *nav;
    if ([[HHTool mainWindow].rootViewController isKindOfClass:[JCMainTabBarController  class]]) {
        JCMainTabBarController  *tab = (JCMainTabBarController*)[HHTool mainWindow].rootViewController;
        JCNavigationController *navController = tab.selectedViewController;
        nav = navController;
    }else{
        nav = (JCNavigationController*)[HHTool mainWindow].rootViewController;
    }
    return nav;
}



@end
