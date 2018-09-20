//
//  SYStoryTransmitController.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/11/30.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SYStoryTransmitController.h"
#import "SYTextView.h"
#import "SYComposeToolbar.h"
#import "SYComposeTrendController.h"
#import "SYStorySelectFriendController.h"
#import "SCAliyunUploadMananger.h"
#import "GWLPhotoLibrayController.h"
#import "SYComposePhotosView.h"
#import "SYStoryPublishController.h"

@interface SYStoryTransmitController()<SYComposeToolbarDelegate, SYSelectFriendControllerDelegate, SYComposeTrendControllerDelegate, SCAliyunUploadManangerDelegate>

@property (strong, nonatomic) SYTextView *textView;

@property (strong, nonatomic) SYComposeToolbar *toolbar;

@property (strong, nonatomic) SYComposePhotosView *imageDisplayView;

@property (strong, nonatomic) NSMutableDictionary *params;

@end

@implementation SYStoryTransmitController

- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    
    return _params;
}

- (SYTextView *)textView {
    if (!_textView) {
        _textView = [[SYTextView alloc] init];
        _textView.alwaysBounceVertical = YES;//垂直向上拥有弹簧效果
        _textView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavStatusBarHeight - 44 - 250);
        _textView.tag = -1;
        _textView.placeholder = @"以角色的身份，想想你有什么故事想说……";
        
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.textColor = RGB(102, 102, 102);
        _textView.placeholderColor = RGB_HEX(0xB3B3B3);
        _textView.maxWordNum = 1000;
        [self.view addSubview:_textView];
    }
    
    return _textView;
}

// 添加工具条
- (void)setupToolbar {
    // 1.创建
    self.toolbar = [[SYComposeToolbar alloc] init];
    self.toolbar.frame = CGRectMake(0, self.view.height - self.toolbar.height - kNavStatusBarHeight, self.view.width, 44);
    self.toolbar.delegate = self;
    [self.toolbar hiddenSwithBtn];
    // 2.显示
    [self.view addSubview:self.toolbar];
}

- (void)setupTopicView {
    UIView *topicView = [[UIView alloc] init];
    topicView.backgroundColor = RGB_HEX(0xEEEEEE);
    [self.view addSubview:topicView];
    [topicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.height.mas_equalTo(80);
        make.top.equalTo(self.textView.mas_bottom).with.offset(10);
    }];
    
    UIImageView *img = [[UIImageView alloc] init];
    NSMutableDictionary *intro = [JsonTool dictionaryFromString:self.model.intro];
    NSString *imagePath = self.model.characterImg;
    if (intro) {
        NSArray *imageArray = intro[@"imgs"];
        if (imageArray && imageArray.count) {
            imagePath = imageArray[0];
        }
    }
    [img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
    
    [topicView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(80);
        make.left.centerY.equalTo(topicView);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel makeTextStyleWithTitle:[@"@" stringByAppendingString:self.model.characterName] withColor:RGB_HEX(0x666666) withFont:[UIFont systemFontOfSize:14] withAlignment:UITextAlignmentLeft];
    [topicView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topicView).with.offset(16);
        make.left.equalTo(img.mas_right).with.offset(16);
        make.height.mas_equalTo(20);
        make.right.equalTo(topicView).with.offset(-16);
    }];
    
    UILabel *introLabel = [[UILabel alloc] init];
    [introLabel makeTextStyleWithTitle:self.model.characterName withColor:RGB_HEX(0x999999) withFont:[UIFont systemFontOfSize:12] withAlignment:UITextAlignmentLeft];
    [topicView addSubview:introLabel];
    [introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).with.offset(8);
        make.left.equalTo(img.mas_right).with.offset(16);
        make.height.mas_equalTo(17);
        make.right.equalTo(topicView).with.offset(-16);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"转发动态";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self addNavigationRightWithName:@"发布" withTarget:self withAction:@selector(publishAction:)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self textView];
    
    if (!_model) {
        return;
    }
    [self setupTopicView];
    
    [self setupPhotosView];
    
    [self setupToolbar];

    [self.textView becomeFirstResponder];
}

- (void)setupPhotosView {
    SYComposePhotosView *photosView = [[SYComposePhotosView alloc] init];
    [self.view addSubview:photosView];
    [photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textView).with.offset(15);
        make.right.equalTo(self.textView).with.offset(-15);
        make.top.equalTo(self.textView.mas_bottom).with.offset(100);
        make.height.mas_equalTo(@80);
    }];
    self.imageDisplayView = photosView;
}

#pragma mark ---------------------- toolBar action handler ------------------------
- (void)openAlbum {
    GWLPhotoLibrayController *photoSelector = [GWLPhotoLibrayController photoLibrayControllerWithBlock:^(NSArray *images) {
        for (UIImage *image in images) {
            [self.imageDisplayView addImage:image];
        }
        [self.textView becomeFirstResponder];
    }];
    int maxCount = 3 - self.imageDisplayView.images.count;
    if (maxCount < 1) {
        [SYProgressHUD showError:@"最多只能添加3张图片哦"];
        return;
    }
    
    photoSelector.maxCount = maxCount;
    photoSelector.multiAlbumSelect = YES;
    [self presentViewController:photoSelector animated:YES completion:nil];
}

- (void)openTrend {
    SYComposeTrendController *vc = [[SYComposeTrendController alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openMention {
    SYStorySelectFriendController *vc = [[SYStorySelectFriendController alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)publishAction:(UIButton *)button {
    self.params = [NSMutableDictionary dictionary];
    [self.params setObject:SCCacheTool.shareInstance.getCurrentCharacterId forKey:@"characterId"];
    if (![self.textView.text isNotBlank]) {
        [SYProgressHUD showError:@"动态信息不能为空哦"];
        return;
    }
    
    [SYProgressHUD showMessage:@"正在火速发布"];
    [SCAliyunUploadMananger shareInstance].delegate = self;
    [[SCAliyunUploadMananger shareInstance] uploadImageArray:self.imageDisplayView.images];
}

#pragma mark ----------- SCAliyunUploadManangerDelegate ----------------
- (void)aliyunUploadManagerError:(NSError *)error {
    [SYProgressHUD showError: error.description];
}

- (void)aliyunUploadManagerFinishdWithImageURLArray:(NSArray *)array {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableDictionary *introDict = [NSMutableDictionary dictionary];
    if ([self.textView.text isNotBlank]) {
        NSMutableDictionary *intro = [NSMutableDictionary dictionary];
        [introDict setObject:self.textView.text forKey:@"content"];
        [introDict setObject:array forKey:@"imgs"];

        NSArray *pointedArray = [self.textView generateIntroduction];
        NSMutableArray *topicIds = [NSMutableArray array];
        for (NSDictionary *dict in pointedArray) {
            NSNumber *type = dict[@"type"];
            if (type.intValue == 2) {
                [topicIds addObject:dict[@"beanId"]];
            }
        }
        [introDict setObject:pointedArray forKey:@"spanBeanList"];
        [dict setObject:[JsonTool stringFromArray:introDict] forKey:@"intro"];

        [self.params setObject:[JsonTool stringFromArray:topicIds] forKey:@"topicIds"];
    } else {
        [SYProgressHUD showError:@"动态信息不能为空哦"];
        return;
    }
    
    NSMutableString *s = [[NSMutableString alloc] initWithString:self.model.detailId];
    [s deleteCharactersInRange:NSMakeRange(0, 1)];
    [self.params setObject:s forKey:@"storyId"];
    [self.params setObject:[JsonTool stringFromArray:dict] forKey:@"dataString"];
    WS(WeakSelf);
    [[SCNetwork shareInstance] postWithUrl:STORYTRANSMIT parameters:self.params success:^(id responseObject) {
        [SYProgressHUD hideHUD];
        [NSNotificationCenter.defaultCenter postNotificationName:NotificationNameStoryPublishSuccess object:nil];
        [WeakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [SYProgressHUD showError:error.description];
        SCLog(@"%@",error);
    }];
}

#pragma mark ------------ 键盘处理 -----------------

- (void)keyboardWillHide:(NSNotification *)note {
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        
        self.toolbar.y              = self.view.height - self.toolbar.height;
        self.textView.height        = SCREEN_HEIGHT - kNavStatusBarHeight - 44 - 250;
    }];
}

- (void)keyboardWillShow:(NSNotification *)note {
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 2.动画
    
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;
        
        CGFloat toolBarY = self.view.height - keyboardH - self.toolbar.height;
        
        self.textView.height        = toolBarY - 200;
        self.toolbar.y = toolBarY;
    }];
}

#pragma mark ----------- UIScrollViewDelegate ----------------------
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - SWComposeToolbarDelegate
- (void)composeTool:(SYComposeToolbar *)toolbar didClickedButton:(SYComposeToolbarButtonType)buttonType {
    switch (buttonType) {
        case SYComposeToolbarButtonTypeNone:
            [self.view endEditing:YES];
            break;
            
        case SYComposeToolbarButtonTypePicture: // 相册
            [self openAlbum];
            break;
            
        case SYComposeToolbarButtonTypeTrend: // @
            [self openTrend];
            break;
            
        case SYComposeToolbarButtonTypeMention: // 话题
            [self openMention];
            break;
    }
}

#pragma mark ------------ SYSelectFriendControllerDelegate -------------
- (void)selectFriendWithArray:(NSArray *)array {
    for (NSDictionary *dict in array) {
        [self.textView insertMention:dict[@"name"] withCharacterId:dict[@"modelId"]];
    }
}

- (void)storyTopicCreate:(NSNotification *)notification {
    NSDictionary *content = [notification.userInfo mutableCopy];
    if (content[@"topicName"] && content[@"topicId"]) {
        [self composeTrendControllerWithText:content[@"topicName"] withTopicId:[content[@"topicId"] longValue]];
    }
}

#pragma mark SYComposeTrendControllerDelegate
- (void)composeTrendControllerWithText:(NSString *)string withTopicId:(long)topicId {
    [self.textView insertTopic:string withTopicId:[NSString stringWithFormat:@"%ld", topicId]];
}

@end
