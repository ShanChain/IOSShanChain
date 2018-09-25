//
//  SYStoryContentController.m
//  ShanChain
//
//  Created by krew on 2017/9/1.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYStoryContentController.h"
#import "SCContentCell.h"
#import "SCDynamicCell.h"
#import "SCDynamicStatusFrame.h"
#import "SCReportController.h"
#import "SYStoryNovelReadController.h"
#import "SYStoryTransmitController.h"
#import "SYFriendHomePageController.h"
#import "SYStoryTopicDetailController.h"
#import "SCCommonShareDashboardView.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface SYStoryContentController ()<UITableViewDelegate, SCDynamicCellDelegate, UITableViewDataSource, UIActionSheetDelegate, SCContentCellDelegate, UITextViewDelegate> {
    int page;
}

@property (strong, nonatomic) UILabel                  *placeHolderLabel;
@property (strong, nonatomic) UIView                   *contentView;
@property (strong, nonatomic) UIImageView              *contentImgView;
@property (strong, nonatomic) UITextView               *textView;

@property (strong, nonatomic) UITableView              *tableView;
@property (strong, nonatomic) NSMutableArray           *dataArr;

@property (strong, nonatomic) UIButton      *sendBtn;

@property (nonatomic,copy) NSString         *storyId;
@property (nonatomic,strong) NSDictionary    *storyDic;
@property (nonatomic,strong) NSDictionary    *characterDic;

@end

@implementation SYStoryContentController

#pragma mark ------------ 懒加载 -------
- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.frame = CGRectMake(SCREEN_WIDTH - 50, 0, 50, 50);
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:RGB(185, 185, 185) forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_sendBtn addTarget:self action:@selector(publishCommentAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

-(UITextView *)textView{
    if (!_textView) {
        _textView = [UITextView new];
        _textView.delegate = self;
        _textView.frame = CGRectMake(50, 10, SCREEN_WIDTH - 50 - KSCMargin -30, 30);
        [_textView addSubview:self.placeHolderLabel];
    }
    return _textView;
}

-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        UIImageView *contentImgView = [[UIImageView alloc]init];
        contentImgView.image = [UIImage imageNamed:@"abs_home_btn_comment_default"];
        contentImgView.frame = CGRectMake(KSCMargin, KSCMargin, 20, 20);
        [_contentView addSubview:contentImgView];
        
        [_contentView addSubview:self.textView];
        [_contentView addSubview:self.sendBtn];
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        line1.backgroundColor = RGB(246, 246, 246);
        [_contentView addSubview:line1];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
        line2.backgroundColor = RGB(246, 246, 246);

        [_contentView addSubview:line2];
    }
    return _contentView;
}

- (UILabel *)placeHolderLabel {
    if (!_placeHolderLabel) {
        _placeHolderLabel = [UILabel new];
        _placeHolderLabel.frame = CGRectMake(5, 8, 200, 14);
        [_placeHolderLabel makeTextStyleWithTitle:@"在这里说点什么吧" withColor:RGB(171, 171, 171) withFont:[UIFont systemFontOfSize:10] withAlignment:NSTextAlignmentLeft];
    }
    return _placeHolderLabel;
}

-(UIImageView *)contentImgView{
    if (!_contentImgView) {
        _contentImgView = [[UIImageView alloc]init];
        _contentImgView.image = [UIImage imageNamed:@"abs_home_btn_comment_default"];
        _contentImgView.frame = CGRectMake(KSCMargin, KSCMargin, 20, 20);
    }
    return _contentImgView;
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kNavStatusBarHeight- 50)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[SCContentCell class] forCellReuseIdentifier:[SCContentCell cellDequeueReusableIdentifier]];
        [_tableView registerClass:[SCDynamicCell class] forCellReuseIdentifier:[SCDynamicCell cellDequeueReusableIdentifier]];
        [self initRefreshView];
    }
    return _tableView;
}

- (void)registerNotification {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -系统方法
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    /** 结束刷新状态*/
    [self.tableView mj_endRefreshing];
}

- (void)layoutUI {
    [self initFromRnData];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.type == 1) {
        self.title = @"动态";
        [self addNavigationRightWithImageName:@"abs_home_btn_more_default" withTarget:self withAction:@selector(moreAction:)];
    } else {
        self.title = @"故事长文";
        [self addNavigationRightWithName:@"阅读" withTarget:self withAction:@selector(readNovelAction:)];
    }
    
    [self setKeyBoardAutoHidden];
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.contentView];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)initFromRnData {
    if (self.rnParams != nil) {
        NSDictionary *rnData = [JsonTool dictionaryFromString:self.rnParams];
        NSDictionary *data = [rnData objectForKey:@"data"];
        if ([data objectForKey:@"novel"]) {
            _storyDic = [data objectForKey:@"novel"];
            _storyId = [[_storyDic objectForKey:@"storyId"] stringValue];
        }
        if ([data objectForKey:@"character"]) {
            _characterDic = [data objectForKey:@"character"];
        }
        if ([data objectForKey:@"storyId"]) {
            _storyId = [[data objectForKey:@"storyId"] stringValue];
        }
        
        if([_storyDic[@"type"] intValue] == 1){
            self.detailId = [@"s" stringByAppendingString:[_storyDic[@"storyId"] stringValue]];
        }else if ([_storyDic[@"type"] intValue] == 2){
            self.detailId = [@"n" stringByAppendingString:[_storyDic[@"storyId"] stringValue]];
        }
        
        self.type = [_storyDic[@"type"] intValue];
    }
}

#pragma mark -构造方法
- (void)initRefreshView {
    WS(WeskSelf);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 0;
        [WeskSelf requestStoryDetailComplete:nil];
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [WeskSelf requestCommentListComplete:nil];
    }];
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
}

- (void)requestStoryDetailComplete:(dispatch_block_t)complete{
//    weakify(self);
//    dispatch_group_t   group = dispatch_group_create();
//    dispatch_queue_t   queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_group_enter(group);
//    dispatch_async(queue, ^{
//        dispatch_group_leave(group);
//    });
//
//    dispatch_group_enter(group);
//    dispatch_async(queue, ^{
//       dispatch_group_leave(group);
//    });
//
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        BLOCK_EXEC(callBlock);
//    });
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableString *s = [NSMutableString stringWithString:[self.detailId copy]];
    [s deleteCharactersInRange:NSMakeRange(0, 1)];
    NSString *dataArrayString = [JsonTool stringFromArray:@[s]];
    [params setObject:dataArrayString forKey:@"dataArray"];
    WS(WeakSelf);
    [[SCNetwork shareInstance] postWithUrl:STORYGET parameters:params success:^(id responseObject) {
        NSMutableArray * data = [responseObject[@"data"] mutableCopy];
        if (data.count <= 0) {
            [SYProgressHUD showError:@"数据请求错误"];
            return;
        }
        
        NSMutableDictionary *dic = [data[0] mutableCopy];
        NSString *characterString = dic[@"characterId"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[JsonTool stringFromArray:@[characterString]] forKey:@"dataArray"];
      
        [[SCNetwork shareInstance] postWithUrl:STORYCAHRACTERQUERYBRIEF parameters:params success:^(id responseObject) {
            NSMutableArray *data2 = responseObject[@"data"];
            NSMutableDictionary *contDic = data2[0];
            
            [dic setObject:contDic forKey:@"info"];
            SCDynamicModel *model = [SCDynamicModel objectWithKeyValues:dic];
            model.detailId = WeakSelf.detailId;
            model.showTextAll = YES;
            model.characterName = contDic[@"name"];
            model.characterImg = contDic[@"headImg"];
            if (dic[@"commentCount"]) {
                model.commendCount = [dic[@"commentCount"] intValue];
            }
            SCDynamicStatusFrame *statusFrame = [[SCDynamicStatusFrame alloc] init];
            statusFrame.dynamicModel = model;
            WeakSelf.dynamicStatusFrame = statusFrame;
            
            NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
            NSMutableString *s = [NSMutableString stringWithString:[WeakSelf.detailId copy]];
            [s deleteCharactersInRange:NSMakeRange(0, 1)];
            [params1 setObject:s forKey:@"checkId"];
            [params1 setObject:[SCCacheTool.shareInstance getCurrentUser] forKey:@"userId"];
//            NSString  *characterId = [self.characterDic objectForKey:@"characterId"];
//            [params1 setObject:_string(characterId) forKey:@"characterId"];
            [params1 setObject:[SCCacheTool shareInstance].getCurrentCharacterId forKey:@"characterId"];
              BLOCK_EXEC(complete);
            [[SCNetwork shareInstance] postWithUrl:STORYISFAVORITE parameters:params1 success:^(id responseObject) {
                WeakSelf.dynamicStatusFrame.dynamicModel.beFav = responseObject[@"data"];
                [WeakSelf.tableView mj_endRefreshing];
                if ([WeakSelf tableView:WeakSelf.tableView numberOfRowsInSection:0]) {
                    SCDynamicCell *cell = [WeakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    if (cell) {
                        cell.dynamicStatusFrame = statusFrame;
                        return;
                    }
                }
              
                [WeakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            } failure:^(NSError *error) {
                [WeakSelf.tableView mj_endRefreshing];
                [WeakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
            [WeakSelf requestCommentListComplete:nil];
        } failure:^(NSError *error) {
            BLOCK_EXEC(complete);
            [WeakSelf.tableView mj_endRefreshing];
            [SYProgressHUD showError:error.description];
        }];
    } failure:^(NSError *error) {
        BLOCK_EXEC(complete);
        [WeakSelf.tableView mj_endRefreshing];
        [SYProgressHUD showError:error.description];
    }];
}

- (void)requestCommentListComplete:(dispatch_block_t)complete{
    SCDynamicModel *model = self.dynamicStatusFrame.dynamicModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableString *s = [NSMutableString stringWithString:self.detailId];
    [s deleteCharactersInRange:NSMakeRange(0, 1)];
    [params setValuesForKeysWithDictionary:@{
                                            // @"characterId":model.characterId,
                                             @"characterId":[SCCacheTool shareInstance].getCurrentCharacterId,
                                             @"page":[NSNumber numberWithInt:page],
                                             @"size":[NSNumber numberWithInt:10],
                                             @"sort":@"createTime,desc",
                                             @"storyId":s
                                             }];
    WS(WeakSelf);
    [[SCNetwork shareInstance] postWithUrl:STORYCOMMENTLIST parameters:params success:^(id responseObject) {
        if (page == 0) {
            [WeakSelf.dataArr removeAllObjects];
        }
        NSDictionary *data = responseObject[@"data"];
        NSArray * content = data[@"content"];
        NSMutableArray *characterIdArr = [NSMutableArray array];
        for (int i = 0; i < content.count; i ++) {
            NSMutableDictionary *dict =content[i];
            NSString *characterIdString = dict[@"characterId"];
            [characterIdArr addObject:characterIdString];
        }
            
        NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
        [params1 setObject:[JsonTool stringFromArray:characterIdArr] forKey:@"dataArray"];
        
        if (!characterIdArr.count) {
            [WeakSelf.tableView mj_endRefreshing];
            return;
        }
        
        [[SCNetwork shareInstance] postWithUrl:STORYCAHRACTERQUERYBRIEF parameters:params1 success:^(id responseObject) {
            NSArray * data = content;
            NSArray * data1 = responseObject[@"data"];
            
            NSMutableArray * newDataArr = [NSMutableArray array];

            NSMutableDictionary *mapDictionary = [NSMutableDictionary dictionary];
            for (int j = 0; j < data1.count; j ++) {
                NSMutableDictionary *d = [data1[j] mutableCopy];
                [mapDictionary setObject:d forKey:d[@"characterId"]];
            }
            for (int i = 0; i < data.count; i ++) {
                NSMutableDictionary *contDic = [data[i] mutableCopy];
                [contDic setObject:mapDictionary[contDic[@"characterId"]] forKey:@"info"];
                [newDataArr addObject:contDic];
                SYComment *commentModel= [SYComment objectWithKeyValues:contDic];
                [_dataArr addObject:commentModel];
            }
            
            [WeakSelf.tableView reloadData];
            [WeakSelf.tableView mj_endRefreshing];
            BLOCK_EXEC(complete);
        } failure:^(NSError *error) {
            SCLog(@"%@",error);
            BLOCK_EXEC(complete);
            [WeakSelf.tableView mj_endRefreshing];
            [SYProgressHUD showError:error.description];
        }];
    } failure:^(NSError *error) {
        [WeakSelf.tableView mj_endRefreshing];
        [SYProgressHUD showError:error.description];
        BLOCK_EXEC(complete);
    }];
}

- (void)readNovelAction:(UIButton *)button {
    SYStoryNovelReadController *readVC = [[SYStoryNovelReadController alloc]init];
    readVC.content = self.dynamicStatusFrame.dynamicModel.content;
    [self.navigationController pushViewController:readVC animated:YES];
}

- (void)moreAction:(UIButton *)button {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *titles = @[@"举报", @"分享"];
    [self addActionTarget:alert titles:titles];
    [self addCancelActionTarget:alert title:@"取消"];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)addActionTarget:(UIAlertController *)alertController titles:(NSString *)titles {
    WS(WeakSelf);
    for (NSString *title in titles) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if ([title isEqualToString:@"举报"]) {
                SCDynamicModel *model = WeakSelf.dynamicStatusFrame.dynamicModel;
                SCReportController *reportVC = [[SCReportController alloc] init];
                reportVC.detailId = model.detailId;
                [WeakSelf.navigationController pushViewController:reportVC animated:YES];
            }
            
            if ([title isEqualToString:@"分享"]) {
            //    [self share_];
                SCCommonShareDashboardView *shareDashboardView = [[SCCommonShareDashboardView alloc] init];
                [shareDashboardView presentView];
            }
        }];
        [action setValue:RGB(0, 118, 255) forKey:@"_titleTextColor"];
        [alertController addAction:action];
    }
}

- (void)share_{
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"topc3"]];
//    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
  
                       
                    //大家请注意：4.1.2版本开始因为UI重构了下，所以这个弹出分享菜单的接口有点改变，如果集成的是4.1.2以及以后版本，如下调用：
                       [ShareSDK showShareActionSheet:nil customItems:nil shareParams:shareParams sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                           switch (state) {
                               case SSDKResponseStateSuccess:
                               {
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                       message:nil
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                                   break;
                               }
                               case SSDKResponseStateFail:
                               {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                   message:[NSString stringWithFormat:@"%@",error]
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                                   break;
                               }
                               default:
                                   break;
                           }
                       }];
    }
}


// 取消按钮
- (void)addCancelActionTarget:(UIAlertController *)alertController title:(NSString *)title{
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

- (void)publishCommentAction {
    if (![self.textView.text isNotBlank]) {
        [SYProgressHUD showError:@"请输入评论的内容"];
        return;
    } else {
        self.sendBtn.enabled = NO;
        [self performSelector:@selector(changeButtonState) withObject:nil afterDelay:1.0f];
        SCDynamicModel *model = self.dynamicStatusFrame.dynamicModel;

        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[SCCacheTool.shareInstance getCurrentCharacterId] forKey:@"characterId"];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:self.textView.text forKey:@"content"];
        [dict setObject:@(1) forKey:@"isAnon"];
        [params setObject:[JsonTool stringFromArray:dict] forKey:@"dataString"];
        
        NSMutableString *s = [NSMutableString stringWithString:model.detailId];
        [s deleteCharactersInRange:NSMakeRange(0, 1)];
        [params setObject:s forKey:@"storyId"];
        
        WS(WeakSelf);
        [[SCNetwork shareInstance]postWithUrl:STORYCOMMENTADD parameters:params success:^(id responseObject) {
            [WeakSelf requestStoryDetailComplete:nil];
            WeakSelf.textView.text = @"";
            [SYProgressHUD showSuccess:@"评论成功"];
        } failure:^(NSError *error) {
            SCLog(@"%@",error);
        }];
    }
}

- (void)changeButtonState {
    self.sendBtn.enabled = YES;
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        return;
    }
}

#pragma mark -UITableView的数据源方法
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dynamicStatusFrame ? 1 : 0;
    } else {
        return self.dataArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        SCDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:[SCDynamicCell cellDequeueReusableIdentifier] forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.dynamicStatusFrame = self.dynamicStatusFrame;
        return cell;
    } else {
        SCContentCell *cell = (SCContentCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SCContentCell class]) forIndexPath:indexPath];
        cell.indexpath = indexPath;
        cell.delegate = self;
        cell.comment = self.dataArr[indexPath.row];
        return cell;
    }
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.dynamicStatusFrame.dynamicCellHeight;
    } else {
        return [SCContentCell cellHeight];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -键盘通知
- (void)keyboardDidShow:(NSNotification*)notification {
    // 1.键盘弹出需要的时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        self.contentView.transform = CGAffineTransformMakeTranslation(0, -keyboardF.size.height);
    }];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    // 1.键盘弹出需要的时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    //    textview 改变字体的行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    
    self.placeHolderLabel.hidden = self.textView.text.length != 0;
}

#pragma mark -DSStatusCellDelegate
// 点赞
- (void)dynamicCellTapButtonSupportWithIndexPath:(NSIndexPath *)indexPath withSupported:(BOOL)isSupported {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSMutableString *s = [NSMutableString stringWithFormat:self.detailId];
    [s deleteCharactersInRange:NSMakeRange(0, 1)];
    [params setObject:s forKey:@"storyId"];
    [params setObject: [SCCacheTool.shareInstance getCurrentCharacterId] forKey:@"characterId"];
    [params setObject:[SCCacheTool.shareInstance getCurrentUser] forKey:@"userId"];
    BOOL  beFav = self.dynamicStatusFrame.dynamicModel.beFav.boolValue;
    NSString *url = !beFav ? STORYSUPPORTADD : STORYSUPPORTREMOVE;
    WS(WeakSelf);
    [self showLoading];
    [[SCNetwork shareInstance]postWithUrl:url parameters:params success:^(id responseObject) {
        [WeakSelf requestStoryDetailComplete:^{
            [WeakSelf hideLoading];
        }];
    } failure:nil];
}

- (void)dynamicCellTapButtonCommentWithIndexPath:(NSIndexPath *)indexPath {
    [self.textView becomeFirstResponder];
}

- (void)dynamicCellTapButtonShareWithIndexPath:(NSIndexPath *)indexPath {
    SCDynamicStatusFrame *statusFrame = self.dynamicStatusFrame;
    NSString *spaceId = [SCCacheTool.shareInstance getCurrentSpaceId];
    if (statusFrame.dynamicModel && [statusFrame.dynamicModel.spaceId isEqualToString:spaceId]) {
        SYStoryTransmitController *vc = [[SYStoryTransmitController alloc] init];
        vc.model = statusFrame.dynamicModel;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [SYProgressHUD showError:@"不同世界不能转发"];
    }
}

- (void)dynamicCellTapButtonIconWithIndexPath:(NSIndexPath *)indexPath {
    SCDynamicStatusFrame *statusFrame = self.dynamicStatusFrame;
    SYFriendHomePageController *vc = [[SYFriendHomePageController alloc] init];
    vc.characterId = statusFrame.dynamicModel.characterId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 评论页点赞

- (void)contentCellTapButtonSupportWithIndexPath:(NSIndexPath *)indexPath withSupported:(BOOL)isSupported {
    SYComment *comment = self.dataArr[indexPath.item];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:@{
                                             @"characterId":[SCCacheTool.shareInstance getCurrentCharacterId],
                                             @"commentId":comment.commentId
                                             }];
    NSString *url = !comment.mySupport.boolValue ? STORYCOMMENTSUPPORTADD : STORYCOMMENTSUPPORTREMOVE;
    weakify(self);
    [self showLoading];
    [[SCNetwork shareInstance]postWithUrl:url parameters:params success:^(id responseObject) {
        [weak_self requestCommentListComplete:^{
            [weak_self hideLoading];
        }];
    } failure:^(NSError *error) {
        [weak_self hideLoading];
    }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    SCDynamicStatusFrame *statusFrame = self.dynamicStatusFrame;
    NSString *spaceId = [SCCacheTool.shareInstance getCurrentSpaceId];
    if (statusFrame.dynamicModel && [statusFrame.dynamicModel.spaceId isEqualToString:spaceId]) {
        return YES;
    } else {
        [SYProgressHUD showError:@"不同世界不能评论"];
        return NO;
    }
}

NSString * _string(id a){
    if (!a) {
        return @"";
    }
    return  [NSString stringWithFormat:@"%@",a];
}

@end
