//
//  SYMessageController.m
//  ShanChain
//
//  Created by krew on 2017/9/11.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYMessageController.h"
#import "SYBigDramaController.h"
#import "SYScreenDetailController.h"
#import "SYStorySelectFriendController.h"
#import "SCScreenCell.h"
#import "SYContactsController.h"
#import "SYMessageNormalCell.h"
#import "SYContactModel.h"
#import "EaseTextView.h"
#import "SYFriendHomePageController.h"
#import <UserNotifications/UserNotifications.h>

#define kHaveUnreadAtMessage    @"kHaveAtMessage"
static const NSString *SYWordStylePointedName = @"SYWordStylePointedName";
static const NSString *SYWordStylePointedIdentity = @"SYWordStylePointedIdentity";
@interface SYMessageController ()<EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource,UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate,EMClientDelegate,EMChatManagerDelegate,SYSelectFriendControllerDelegate, SYMessageNormalCellDelegate>{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UIMenuItem *_transpondMenuItem;
    UIMenuItem *_recallItem;
}

@property (assign, nonatomic) int                   type;

@property (strong, nonatomic) NSMutableDictionary   *characterInfo;


@property (strong, nonatomic) NSMutableArray   *mentionArray;
// 情景模式
@property (assign, nonatomic) BOOL isShowScenceView;

@end

@implementation SYMessageController

- (NSMutableDictionary *)characterInfo {
    if (!_characterInfo) {
        _characterInfo = [SCCacheTool.shareInstance getCharacterInfo];
    }
    
    return _characterInfo;
}

- (NSMutableArray *)mentionArray {
    if (!_mentionArray) {
        _mentionArray = [NSMutableArray array];
    }
    
    return _mentionArray;
}
#pragma mark -系统方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.chatToolbar.toolBar setIsGroup:self.conversation.type == EMConversationTypeGroupChat];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dramaAction:) name:SYMessageDidDramaBtnClickNotication object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenAction:) name:SYMessageDidScreenBtnClickNotication object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mentionAction:) name:SYMessageDidMentionBtnClickNotication object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertAction:) name:SYMessageDidAlertBtnClickNotication object:nil];
    
    if (self.conversation.type == EMConversationTypeGroupChat) {
        [self addNavigationRightWithImageName:@"abs_home_btn_more_default" withTarget:self withAction:@selector(moreAction:)];
    }
    
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    self.scrollToBottomWhenAppear = YES;
    self.type = 1;
    
    self.tableView.backgroundColor = RGB_HEX(0xEEEEEE);
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.conversation.type == EMConversationTypeChatRoom) {
        //退出聊天室，删除会话
        if (self.isJoinedChatroom) {
            NSString *chatter = [self.conversation.conversationId copy];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = nil;
                [[EMClient sharedClient].roomManager leaveChatroom:chatter error:&error];
                if (error !=nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Leave chatroom '%@' failed [%@]", chatter, error.errorDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                    });
                }
            });
        } else {
            [[EMClient sharedClient].chatManager deleteConversation:self.conversation.conversationId isDeleteMessages:YES completion:nil];
        }
    }
    [[EMClient sharedClient] removeDelegate:self];
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//
//    if (self.tableView.contentSize.height > self.tableView.frame.size.height) {
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }
//}

- (void)tableViewDidTriggerHeaderRefresh {
    NSString *startMessageId = nil;
    if (self.messsagesSource.count) {
        startMessageId = [(EMMessage *)self.messsagesSource.firstObject messageId];
    }
    SCLog(@"startMessageID ------- %@",startMessageId);
    [EMClient.sharedClient.chatManager asyncFetchHistoryMessagesFromServer:self.conversation.conversationId conversationType:self.conversation.type startMessageId:startMessageId pageSize:10 completion:^(EMCursorResult *aResult, EMError *aError) {
        [super tableViewDidTriggerHeaderRefresh];
    }];
}

#pragma mark ----------  UIAlertViewDelegate ----------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.cancelButtonIndex != buttonIndex) {
        self.messageTimeIntervalTag = -1;
        [self.conversation deleteAllMessages:nil];
        [self.dataArray removeAllObjects];
        [self.messsagesSource removeAllObjects];
        
        [self.tableView reloadData];
    }
}


#pragma mark -构造方法
- (void)moreAction:(UIButton *)button {
    SYScreenDetailController *screenVC = [[SYScreenDetailController alloc]init];
    screenVC.groupId = self.conversation.conversationId;
    [self.navigationController pushViewController:screenVC animated:YES];
}

- (void)dramaAction:(NSNotification *)notification {
    SYBigDramaController *bigVC = [[SYBigDramaController alloc]init];
    [self.navigationController pushViewController:bigVC animated:YES];
}

- (void)screenAction:(NSNotification *)notification {
    WS(WeakSelf);
    [SYUIFactory popViewWithTitle:@"添加情景" withSecondTitle:@"描述一下时间，地点的基本背景，场景气氛的说明等。" withPlaceholder:@"输入情景文字" withCallback:^(NSString *text) {
        NSDictionary *dict = @{
                               @"headImg":self.characterInfo[@"headImg"],
                               @"nickName":self.characterInfo[@"name"],
                               @"msgAttr":@3,
                               @"groupImg":@"",
                               @"isGroup": self.conversation.type == EMConversationTypeGroupChat ? @"`YES" : @"NO"};
        WeakSelf.isShowScenceView = YES;
        [self sendTextMessage:text withExt:dict];
    }];
}

- (void)mentionAction:(NSNotification *)notification {
    SYStorySelectFriendController *selectVC = [[SYStorySelectFriendController alloc]init];
    selectVC.type = 1;
    selectVC.groupId = self.conversation.conversationId;
    WS(WeakSelf);
    selectVC.callback = ^(NSArray *contentArray) {
        for (SYContactModel *model in contentArray) {
            [WeakSelf insertMentionRole:[@"@" stringByAppendingString:model.name] withHXID:model.hxUserName];
        }
        [WeakSelf.chatToolbar.inputTextView becomeFirstResponder];
    };
    [self.navigationController pushViewController:selectVC animated:YES];
}

- (void)insertMentionRole:(NSString *)name withHXID:(NSString *)hxID{
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:name attributes:self.chatToolbar.inputTextView.typingAttributes];
    NSRange range = self.chatToolbar.inputTextView.selectedRange;
    [attri addAttribute:SYWordStylePointedName value:[NSNumber numberWithUnsignedInteger:name.length] range:NSMakeRange(0, name.length)];
    [attri addAttribute:SYWordStylePointedIdentity value:hxID range:NSMakeRange(0, name.length)];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.chatToolbar.inputTextView.attributedText];
    [attributedText replaceCharactersInRange:range withAttributedString:attri];
    self.chatToolbar.inputTextView.attributedText = attributedText;
    self.chatToolbar.inputTextView.selectedRange = NSMakeRange(range.location + name.length, 0);
}

- (void)alertAction:(NSNotification *)notification {
    NSRange selectedRange = self.chatToolbar.inputTextView.selectedRange;
    NSMutableString *currentText = [NSMutableString stringWithFormat: self.chatToolbar.inputTextView.text];
    [currentText insertString:@"【】" atIndex:selectedRange.location];
    self.chatToolbar.inputTextView.text = currentText;
    self.chatToolbar.inputTextView.selectedRange = NSMakeRange(selectedRange.location + 1, 0);
    [self.chatToolbar.inputTextView becomeFirstResponder];
}

#pragma mark ------------- EaseMessageViewControllerDelegate ----------------
- (UITableViewCell *)messageViewController:(UITableView *)tableView cellForMessageModel:(id<IMessageModel>)messageModel indexPath:(NSIndexPath *)indexPath {
    NSDictionary *ext = messageModel.message.ext;
    NSString  *xx = messageModel.message.from;
    if (ext[HX_EXT_MSG_ATTR] == @3) {
        NSString *screenCellIdentifier = [SCScreenCell cellIdentifier];
        SCScreenCell * screenCell = (SCScreenCell *)[tableView dequeueReusableCellWithIdentifier:screenCellIdentifier];
        if (screenCell == nil) {
            screenCell = [[SCScreenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:screenCellIdentifier];
            screenCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        EMTextMessageBody *body = (EMTextMessageBody*)messageModel.message.body;
        screenCell.title = @"场景";
        screenCell.content = body.text;
        return screenCell;
    }
    if (ext[HX_EXT_MSG_ATTR] == @0 || ext[HX_EXT_MSG_ATTR] == @1) {
        SYMessageNormalCell *cell = nil;
        if (messageModel.isSender) {
            cell = (SYMessageNormalCell *)[tableView dequeueReusableCellWithIdentifier:@"SYMessageNormalCellSender"];
        } else {
            cell = (SYMessageNormalCell *)[tableView dequeueReusableCellWithIdentifier:@"SYMessageNormalCellReceive"];
        }
        if (cell == nil) {
            cell = [[SYMessageNormalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:(messageModel.isSender ? @"SYMessageNormalCellSender" : @"SYMessageNormalCellReceive") withModel:messageModel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.indexPath = indexPath;
        cell.delegate = self;
        [cell setModel:messageModel];
        return cell;
    }
    return nil;
    
    //    正常聊天内容
}

// 点击头像
- (void)messageNormalCellHeadTapWith:(NSIndexPath *)indexPath withModel:(id<IMessageModel>)model {
    NSDictionary *ext = model.message.ext;
    if (ext && ext[HX_EXT_MSG_CHARACTER] && [ext[HX_EXT_MSG_CHARACTER] isNotBlank]) {
        SYFriendHomePageController *vc = [[SYFriendHomePageController alloc] init];
        vc.characterId = ext[HX_EXT_MSG_CHARACTER];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSString *hxId = model.isSender ? model.message.from : model.message.to;
        [params setObject:hxId forKey:@"userName"];
        WS(WeakSelf);
        [[SCNetwork shareInstance] postWithUrl:HXUSERQUERY parameters:params success:^(id responseObject) {
            NSDictionary *contentDict = responseObject[@"data"];
            
            if (contentDict != [NSNull null] && contentDict[@"characterId"]) {
                SYFriendHomePageController *vc = [[SYFriendHomePageController alloc] init];
                vc.characterId = [NSString stringWithFormat:@"%@", contentDict[@"characterId"]];
                [WeakSelf.navigationController pushViewController:vc animated:YES];
            }
        } failure:^(NSError *error) {
            [SYProgressHUD showError:error.description];
        }];
    }
}

- (CGFloat)messageViewController:(EaseMessageViewController *)viewController heightForMessageModel:(id<IMessageModel>)messageModel withCellWidth:(CGFloat)cellWidth {
    NSDictionary *ext = messageModel.message.ext;
    if (ext[HX_EXT_MSG_ATTR] == @3) {
        return [SCScreenCell cellHeightWithModel:messageModel];
    }
    
    if (ext[HX_EXT_MSG_ATTR] == @0 || ext[HX_EXT_MSG_ATTR] == @1 ) {
        return [SYMessageNormalCell cellHeightWithModel:messageModel];
    }
    
    return 0;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController canLongPressRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController didLongPressRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[EaseMessageCell class]]) {
            [cell becomeFirstResponder];
            self.menuIndexPath = indexPath;
            [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
        }
    }
    return YES;
}

- (void)messageViewController:(EaseMessageViewController *)viewController didSelectAvatarMessageModel:(id<IMessageModel>)messageModel {
}

- (void)messageViewController:(EaseMessageViewController *)viewController selectAtTarget:(EaseSelectAtTargetCallback)selectedCallback {
    selectedCallback = selectedCallback;
    EMGroup *chatGroup = nil;
    NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
    for (EMGroup *group in groupArray) {
        if ([group.groupId isEqualToString:self.conversation.conversationId]) {
            chatGroup = group;
            break;
        }
    }
    
    if (chatGroup == nil) {
        chatGroup = [EMGroup groupWithId:self.conversation.conversationId];
    }
    
    if (chatGroup) {
        if (!chatGroup.occupants) {
            __weak SYMessageController* weakSelf = self;
            [self showHudInView:self.view hint:@"Fetching group members..."];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = nil;
                EMGroup *group = [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:chatGroup.groupId error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    __strong SYMessageController *strongSelf = weakSelf;
                    if (strongSelf) {
                        [strongSelf hideHud];
                        if (error) {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Fetching group members failed [%@]", error.errorDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                        } else {
                            NSMutableArray *members = [group.occupants mutableCopy];
                            NSString *loginUser = [EMClient sharedClient].currentUsername;
                            if (loginUser) {
                                [members removeObject:loginUser];
                            }
                            
                            if (![members count]) {
                                return;
                            }
                        }
                    }
                });
            });
        } else {
            NSMutableArray *members = [chatGroup.occupants mutableCopy];
            NSString *loginUser = [EMClient sharedClient].currentUsername;
            if (loginUser) {
                [members removeObject:loginUser];
            }
            if (![members count]) {
                return;
            }
        }
    }
}

#pragma mark - EaseMessageViewControllerDataSource

- (void)sendTextMessage:(NSString *)text {
    [self.mentionArray removeAllObjects];
    [self.chatToolbar.inputTextView.attributedText enumerateAttributesInRange:NSMakeRange(0, self.chatToolbar.inputTextView.attributedText.length) options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        if (attrs[SYWordStylePointedName] && attrs[SYWordStylePointedIdentity]) {
            NSString *hxId = attrs[SYWordStylePointedIdentity];
            if ([self.mentionArray indexOfObject: hxId] == NSNotFound) {
                [self.mentionArray addObject:hxId];
            }
        }
    }];
    
    [super sendTextMessage:text];
}

- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController modelForMessage:(EMMessage *)message {
    
    id<IMessageModel> model = nil;
    
    model = [[EaseMessageModel alloc] initWithMessage:message];
    
    if (model.isSender) {
        if (!model.message.ext) {
            int sendTextType = self.isShowScenceView ? 3 : self.type;

            model.message.ext = @{
                                  HX_EXT_MSG_HEAD_IMG:self.characterInfo[@"headImg"],
                                  HX_EXT_MSG_NICK_NAME:self.characterInfo[@"name"],
                                  HX_EXT_MSG_ATTR:[NSNumber numberWithInt:sendTextType],
                                  HX_EXT_MSG_IS_GROUP:self.conversation.type == EMConversationTypeGroupChat ? @"true" : @"false",
                                  HX_EXT_MSG_AT_LIST:self.mentionArray,
                                  HX_EXT_MSG_CHARACTER:[NSString stringWithFormat:@"%@", self.characterInfo[@"characterId"]]
                                  };
            self.isShowScenceView = NO;
        }
        //头像
        model.avatarURLPath = self.characterInfo[HX_EXT_MSG_HEAD_IMG];
        //昵称
        model.nickname = self.characterInfo[@"name"];
        //头像占位图
    } else {
        //头像
        model.avatarURLPath = model.message.ext[HX_EXT_MSG_HEAD_IMG];
        //昵称
        model.nickname = model.message.ext[HX_EXT_MSG_NICK_NAME];
    }
    //头像占位图
    model.failImageName = @"abs_addanewrole_def_photo_default";
    return model;
}

- (NSDictionary*)emotionExtFormessageViewController:(EaseMessageViewController *)viewController easeEmotion:(EaseEmotion*)easeEmotion{
    return @{MESSAGE_ATTR_EXPRESSION_ID:easeEmotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)};
}

- (void)messageViewControllerMarkAllMessagesAsRead:(EaseMessageViewController *)viewController {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
}

#pragma mark - EMClientDelegate
- (void)userAccountDidLoginFromOtherDevice{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)userAccountDidRemoveFromServer{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)userDidForbidByServer{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)_recallWithMessage:(EMMessage *)msg text:(NSString *)text isSave:(BOOL)isSave {
    EMMessage *message = [EaseSDKHelper sendTextMessage:text to:msg.conversationId messageType:msg.chatType messageExt:@{@"em_recall":@(YES)}];
    message.isRead = YES;
    [message setTimestamp:msg.timestamp];
    [message setLocalTime:msg.localTime];
    id<IMessageModel> newModel = [[EaseMessageModel alloc] initWithMessage:message];
    __block NSUInteger index = NSNotFound;
    [self.dataArray enumerateObjectsUsingBlock:^(EaseMessageModel *model, NSUInteger idx, BOOL *stop){
        if ([model conformsToProtocol:@protocol(IMessageModel)]) {
            if ([msg.messageId isEqualToString:model.message.messageId]){
                index = idx;
                *stop = YES;
            }
        }
    }];
    if (index != NSNotFound) {
        __block NSUInteger sourceIndex = NSNotFound;
        [self.messsagesSource enumerateObjectsUsingBlock:^(EMMessage *message, NSUInteger idx, BOOL *stop){
            if ([message isKindOfClass:[EMMessage class]]) {
                if ([msg.messageId isEqualToString:message.messageId]) {
                    sourceIndex = idx;
                    *stop = YES;
                }
            }
        }];
        if (sourceIndex != NSNotFound) {
            [self.messsagesSource replaceObjectAtIndex:sourceIndex withObject:newModel.message];
        }
        [self.dataArray replaceObjectAtIndex:index withObject:newModel];
        [self.tableView reloadData];
    }
    
    if (isSave) {
        [self.conversation insertMessage:message error:nil];
    }
}

- (void)messagesDidRecall:(NSArray *)aMessages{
    for (EMMessage *msg in aMessages) {
        if (![self.conversation.conversationId isEqualToString:msg.conversationId]){
            continue;
        }
        
        NSString *text;
        if ([msg.from isEqualToString:[EMClient sharedClient].currentUsername]) {
            text = [NSString stringWithFormat:NSLocalizedString(@"message.recall", @"You recall a message")];
        } else {
            text = [NSString stringWithFormat:NSLocalizedString(@"message.recallByOthers", @"%@ recall a message"),msg.from];
        }
        
        [self _recallWithMessage:msg text:text isSave:NO];
    }
}

- (void)chatToolbarSwitchBtn:(int)type{
    self.type = 1 - type;
}

- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages {
    for (EMMessage *message in aCmdMessages) {
        // cmd消息中的扩展属性
        NSDictionary *ext = message.ext;
        SCLog(@"cmd消息中的扩展属性是 -- %@",ext);
    }
}

// 收到消息回调
- (void)messagesDidReceive:(NSArray *)aMessages {
    for (EMMessage *message in aMessages) {
        // 消息中的扩展属性
//        NSDictionary *ext = message.ext;
//        NSString * msgAttr = [ext objectForKey:@"msgAttr"];
        [self _configurationRemotelyPush:message];
    }
}

- (void)_configurationRemotelyPush:(EMMessage*)message{
    
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    // App在后台
    if (state == UIApplicationStateBackground) {
        //发送本地推送
        if (NSClassFromString(@"UNUserNotificationCenter")) { // ios 10
            // 设置触发时间
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            content.sound = [UNNotificationSound defaultSound];
            // 提醒，可以根据需要进行弹出，比如显示消息详情，或者是显示“您有一条新消息”
            content.body = @"您有一条新消息";
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:message.messageId content:content trigger:trigger];
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
        }else {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate = [NSDate date]; //触发通知的时间
            notification.alertBody = @"您有一条新消息";
            notification.alertAction = @"Open";
            notification.timeZone = [NSTimeZone defaultTimeZone];
            notification.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }
}


@end
