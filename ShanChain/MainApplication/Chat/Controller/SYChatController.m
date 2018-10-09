//
//  SYChatController.m
//  ShanChain
//
//  Created by krew on 2017/8/22.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYChatController.h"
#import "SYContactsController.h"
#import "SYMessageController.h"
#import "SYScreenDetailController.h"
#import "SYStorySelectFriendController.h"
#import "SYScanController.h"

static NSString * const KSYChatListCellID = @"SYChatListCell";

@interface SYChatController ()<EaseConversationListViewControllerDelegate,EaseConversationListViewControllerDataSource,UIActionSheetDelegate,EMChatManagerDelegate, SYSelectFriendControllerDelegate>

@property (nonatomic, strong) UIView *networkStateView;

@property (strong, nonatomic) NSMutableDictionary *hxUserDict;

@end

@implementation SYChatController

+ (void)removeAllConversationFromLocalDB {
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray *conversationArray = [[NSMutableArray alloc] init];
    for (EMConversation *conversation in conversations) {
        [conversationArray addObject:conversation];
    }
    
    if (conversationArray != [NSNull null] && conversationArray.count > 0) {
        [[EMClient sharedClient].chatManager deleteConversations:conversationArray isDeleteMessages:YES completion:nil];
    }
}

- (NSMutableDictionary *)hxUserDict {
    if(!_hxUserDict) {
        _hxUserDict = [NSMutableDictionary dictionary];
    }
    
    return _hxUserDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
//    [[self networkStateView];
    
    [self addNavigationRightWithImageName:@"abs_home_btn_more_default" withTarget:self withAction:@selector(moreAction:)];
    
    [self tableViewDidTriggerHeaderRefresh];
    
    [self removeEmptyConversationsFromDB];
}
 
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)removeEmptyConversationsFromDB{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.type == EMConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation];
        }
    }
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations isDeleteMessages:YES completion:nil];
    }
}

- (void)tableViewDidTriggerHeaderRefresh {
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSArray* sorted = [conversations sortedArrayUsingComparator: ^(EMConversation *obj1, EMConversation* obj2){
        EMMessage *message1 = [obj1 latestMessage];
        EMMessage *message2 = [obj2 latestMessage];
        return message1.timestamp > message2.timestamp ? NSOrderedAscending : NSOrderedDescending;
    }];
    
    [self.dataArray removeAllObjects];
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *groupArray = [NSMutableArray array];
    for (EMConversation *converstion in sorted) {
        EaseConversationModel *model = [self conversationListViewController:self modelForConversation:converstion];
        [self.dataArray addObject:model];
        if (model.conversation.type == EMConversationTypeGroupChat) {
            [groupArray addObject:model.conversation.conversationId];
        } else {
            [array addObject:model.conversation.conversationId];
        }
    }
    
    
    
    [self requestHXAccountInfo:array];
    [self requestHXGroupInfo:groupArray];
}


- (void)requestHXAccountInfo:(NSArray *)array {
    if (!array.count) {
        [self tableViewDidFinishTriggerHeader:YES reload:YES];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[JsonTool stringFromArray:array] forKey:@"jArray"];
    WS(WeakSelf);
    [[SCNetwork shareInstance] postWithUrl:HXUSERQUERYBATCH parameters:params success:^(id responseObject) {
        NSMutableArray *contentArray = responseObject[@"data"];
        if (contentArray != [NSNull null]) {
            for (NSDictionary *user in contentArray) {
                if (user[@"hx_user_name"]) {
                    [WeakSelf.hxUserDict setObject:user forKey:user[@"hx_user_name"]];
                }
            }
        }
        for (EaseConversationModel *model in WeakSelf.dataArray) {
            if (model.conversation.type == EMConversationTypeChat && WeakSelf.hxUserDict[model.conversation.conversationId]) {
                model.title = WeakSelf.hxUserDict[model.conversation.conversationId][@"name"];
                model.avatarURLPath = WeakSelf.hxUserDict[model.conversation.conversationId][@"head_img"];
            }
        }
        
        [WeakSelf tableViewDidFinishTriggerHeader:YES reload:YES];
    } failure:^(NSError *error) {
        [SYProgressHUD showError:error.description];
    }];
}

- (void)requestHXGroupInfo:(NSArray *)array {
    if (!array.count) {
        [self tableViewDidFinishTriggerHeader:YES reload:YES];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[JsonTool stringFromArray:array] forKey:@"jArray"];
    
    WS(WeakSelf);
    [[SCNetwork shareInstance] postWithUrl:HXGROUPQUERYBATCH parameters:params success:^(id responseObject) {
        NSMutableArray *contentArray = responseObject[@"data"];
        if (contentArray != [NSNull null]) {
            for (NSDictionary *group in contentArray) {
                if (group[@"group_id"]) {
                    [WeakSelf.hxUserDict setObject:group forKey:group[@"group_id"]];
                }
            }
        }
        for (EaseConversationModel *model in WeakSelf.dataArray) {
            if (model.conversation.type == EMConversationTypeGroupChat && WeakSelf.hxUserDict[model.conversation.conversationId]) {
                model.title = WeakSelf.hxUserDict[model.conversation.conversationId][@"group_name"];
                model.avatarURLPath = WeakSelf.hxUserDict[model.conversation.conversationId][@"iconUrl"];
            }
        }
        
        [WeakSelf tableViewDidFinishTriggerHeader:YES reload:YES];
    } failure:^(NSError *error) {
        [SYProgressHUD showError:error.description];
    }];
}

- (void)moreAction:(UIButton *)button {
    if([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        NSArray *titles = @[@"新建群组", @"联系人"];
        [self addActionTarget:alert titles:titles];
        [self addCancelActionTarget:alert title:@"取消"];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
        [sheet showInView:self.view];
    }
}

#pragma mark ------------------------- 网络连接提示View --------------
- (UIView *)networkStateView {
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        _networkStateView.backgroundColor = [UIColor redColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}

#pragma mark -- 点击cell回调
- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel{
    if (conversationModel) {
        EMConversation *conversation = conversationModel.conversation;
        if (conversation) {
            SYMessageController *chatController = [[SYMessageController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
            chatController.title = conversationModel.title;
            [self.navigationController pushViewController:chatController animated:YES];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
        
        [self.tableView reloadData];
    }
}

- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController modelForConversation:(EMConversation *)conversation {
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    return model;
}

- (NSAttributedString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@""];
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        NSString *latestMessageTitle = @"";
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    latestMessageTitle = @"[动画表情]";
                }
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
        
        if (conversationModel.conversation.type == EMConversationTypeGroupChat) {
            if (lastMessage.direction == EMMessageDirectionReceive) {
                NSString *from = lastMessage.from;
                NSDictionary  *ext = lastMessage.ext;
                latestMessageTitle = [NSString stringWithFormat:@"%@: %@", ext[@"nickName"], latestMessageTitle];
            }
        }
        
        
//        if (lastMessage.direction == EMMessageDirectionReceive) {
//            NSString *from = lastMessage.from;
//            if (self.hxUserDict[from]) {
//                latestMessageTitle = [NSString stringWithFormat:@"%@: %@", self.hxUserDict[from][@"name"], latestMessageTitle];
//            } else {
//                latestMessageTitle = [NSString stringWithFormat:@"%@: %@", from, latestMessageTitle];
//            }
//        }
        
        NSDictionary *ext = conversationModel.conversation.ext;
        attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
    }
    
    return attributedStr;
}

//- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel {
//    NSString *latestMessageTime = @"";
//    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
//    if (lastMessage) {
//        double timeInterval = lastMessage.timestamp ;
//        if(timeInterval > 140000000000) {
//            timeInterval = timeInterval / 1000;
//        }
//        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
//        [formatter setDateFormat:@"YYYY-MM-dd"];
//        latestMessageTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
//    }
//    return latestMessageTime;
//}

- (void)addActionTarget:(UIAlertController *)alertController titles:(NSString *)titles {
    for (NSString *title in titles) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
           if ([title isEqualToString:@"新建群组"]) {
               SYStorySelectFriendController *selectVC = [[SYStorySelectFriendController alloc]init];
               selectVC.type = 2;
               selectVC.delegate = self;
               [self.navigationController pushViewController:selectVC animated:YES];
           } else if ([title isEqualToString:@"联系人"]) {
               SYContactsController *reportVC = [[SYContactsController alloc]init];
               [self.navigationController pushViewController:reportVC animated:YES];
           }
        }];
        [action setValue:RGB(0, 118, 255) forKey:@"_titleTextColor"];
        [alertController addAction:action];
    }
}

// 取消按钮
- (void)addCancelActionTarget:(UIAlertController *)alertController title:(NSString *)title {
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [action setValue:RGB(0, 118,255) forKey:@"_titleTextColor"];
    [alertController addAction:action];
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    for (UIView *subViwe in actionSheet.subviews) {
        if ([subViwe isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subViwe;
            [button setTitleColor:RGB(212, 0, 0) forState:UIControlStateNormal];
        }
    }
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        return;
    } else {
        SCLog(@"你已经屏蔽");
    }
}

- (void)refresh {
    [self refreshAndSortView];
}

-( void)refreshDataSource {
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)isConnect:(BOOL)isConnect {
    if (!isConnect) {
        self.tableView.tableHeaderView = _networkStateView;
    } else {
        self.tableView.tableHeaderView = nil;
    }
    
}

- (void)networkChanged:(EMConnectionState)connectionState {
    if (connectionState == EMConnectionDisconnected) {
        self.tableView.tableHeaderView = _networkStateView;
    } else {
        self.tableView.tableHeaderView = nil;
    }
}

//让tableView可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    //删除
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [[EMClient sharedClient].chatManager deleteConversation:model.conversation.conversationId isDeleteMessages:YES completion:nil];
        if (self.dataArray.count > indexPath.row) {
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
    deleteRowAction.backgroundColor = RGB(254, 56, 36);
    
//    //详情
//    UITableViewRowAction *detailRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"详情" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        SYScreenDetailController *detailVC = [[SYScreenDetailController alloc]init];
//        [self.navigationController pushViewController:detailVC animated:YES];
//    }];
//    detailRowAction.backgroundColor = RGB(143, 142, 148);
//
//    //置顶
//    UITableViewRowAction *firstRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//
//    }];
//    firstRowAction.backgroundColor = RGB(139, 219, 84);

//    return @[deleteRowAction, detailRowAction,firstRowAction];
    return @[deleteRowAction];
}

- (void)selectFriendWithOpenGroupChat:(NSString *)groupId withGroupName:(NSString *)name {
    SYMessageController *chatController = [[SYMessageController alloc] initWithConversationChatter:groupId conversationType:EMConversationTypeGroupChat];
    chatController.title = name;
    [self.navigationController pushViewController:chatController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
