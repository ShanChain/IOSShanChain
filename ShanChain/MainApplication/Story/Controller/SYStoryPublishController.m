//
//  SYStoryPublishController.m
//  ShanChain
//
//  Created by krew on 2017/8/30.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYStoryPublishController.h"
#import "SYTextView.h"
#import "SYComposeToolbar.h"
#import "SYComposePhotosView.h"
#import "SYComposeTrendController.h"
#import "SYStorySelectFriendController.h"
#import "GWLPhotoLibrayController.h"
#import "SCCacheTool.h"
#import "SYWordEditView.h"
#import "SCAliyunUploadMananger.h"
#import "SYWordStyle.h"
#import "SYStoryNovelReadController.h"
#import "SYStoryListBaseController.h"
#import "SYStoryController.h"
#import "SavePublishContentModel.h"
#import "UIViewController+BackButtonHandler.h"

static const NSString *SYWordStylePointedName = @"SYWordStylePointedName";

@interface SYStoryPublishController ()<SYComposeToolbarDelegate, SYSelectFriendControllerDelegate, SYComposeTrendControllerDelegate, SCAliyunUploadManangerDelegate>{
    CGFloat _keyboardHeight;
}
// 添加小说的插入方式
@property (strong, nonatomic) SYComposeToolbar    *toolbar;
// 动态消息编辑
@property (strong, nonatomic) SYTextView   *textView;
// 动态插入图片的展示
@property (strong, nonatomic) SYComposePhotosView *imageDisplayView;

// 小说长文的标题
@property (strong, nonatomic) SYWordEditView *wordEditView;

// 发布的参数
@property (strong, nonatomic) NSMutableDictionary *params;

@property (strong, nonatomic) NSMutableDictionary *uploadImageDictionary;

@end

@implementation SYStoryPublishController

- (NSMutableDictionary *)uploadImageDictionary {
    if (!_uploadImageDictionary) {
        _uploadImageDictionary = [NSMutableDictionary dictionary];
    }
    return _uploadImageDictionary;
}

- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}

#pragma mark -懒加载

- (SYWordEditView *)wordEditView {
    if (!_wordEditView) {
        _wordEditView = [[SYWordEditView alloc] init];
        _wordEditView.frame = CGRectMake(0, 15, SCREEN_WIDTH, SCREEN_HEIGHT - kNavStatusBarHeight - 44);
        _wordEditView.hidden = YES;
        _wordEditView.maxWordNum = 10000;
        [_wordEditView setPlaceholder:@"请输入内容..."];
        [self.view addSubview:_wordEditView];
    }
    
    return _wordEditView;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SavePublishContentModel  *model = [SCCacheTool shareInstance].editContentModel;
    if (model) {
        self.textView.text = model.dyContent;
        [model.dyImages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.imageDisplayView addImage:obj];
        }];
        self.wordEditView.titleTextField.text = model.fictionTitle;
        self.wordEditView.text = model.fictionContent;
        if (model.fictionContent) {
            [_wordEditView setPlaceholder:@""];
        }
    }
}

- (SYTextView *)textView {
    if (!_textView) {
        _textView = [[SYTextView alloc] init];
        _textView.alwaysBounceVertical = YES;//垂直向上拥有弹簧效果
        _textView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavStatusBarHeight - 44 - 100);
        _textView.tag = -1;
        _textView.placeholder = @"以角色的身份，想想你有什么故事想说……";
        
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.textColor = RGB(102, 102, 102);
        _textView.maxWordNum = 1000;
        _textView.placeholderColor = RGB_HEX(0xB3B3B3);
        [self.view addSubview:_textView];
    }
    
    return _textView;
}

// 添加显示图片的相册控件
- (void)setupPhotosView {
    SYComposePhotosView *photosView = [[SYComposePhotosView alloc] init];
    [self.view addSubview:photosView];
    [photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textView).with.offset(15);
        make.right.equalTo(self.textView).with.offset(-15);
        make.top.equalTo(self.textView.mas_bottom);
        make.height.mas_equalTo(@80);
    }];
    self.imageDisplayView = photosView;
}

// 添加工具条
- (void)setupToolbar {
    // 1.创建
    self.toolbar = [[SYComposeToolbar alloc] init];
    self.toolbar.delegate = self;
    // 2.显示
    [self.view addSubview:self.toolbar];
    [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark ---------- lifeCycle ------------------
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 成为第一响应者（叫出键盘）
    [self.textView becomeFirstResponder];
}

- (void)saveEditContent{
    if (NULLString(self.textView.text) && NULLString(self.wordEditView.titleTextField.text) &&
        NULLString(self.wordEditView.text) &&
        self.imageDisplayView.images.count == 0) {
        [SCCacheTool shareInstance].editContentModel = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self hrShowAlertWithTitle:@"离开" message:@"当前动态未发布，是否保存草稿以便下次继续编辑？" buttonsTitles:@[@"取消",@"保存"] andHandler:^(UIAlertAction * _Nullable action, NSInteger indexOfAction) {
            if (indexOfAction == 1) {
                SavePublishContentModel  *model = [[SavePublishContentModel alloc]init];
                model.dyContent = self.textView.text ?:@"";
                model.dyImages =  self.imageDisplayView.images.count > 0 ? self.imageDisplayView.images:@[];
                model.fictionTitle = self.wordEditView.titleTextField.text ?: @"";;
                model.fictionContent = self.wordEditView.text ?: @"";
                [SCCacheTool shareInstance].editContentModel = model;
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SCCacheTool shareInstance].editContentModel = nil;
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hh_rewriteBackActionFunc:@selector(saveEditContent)];
    //监听键盘
    // 键盘的frame(位置)即将改变, 就会发出UIKeyboardWillChangeFrameNotification
    // 键盘即将弹出, 就会发出UIKeyboardWillShowNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storyTopicCreate:) name:@"SYStoryTopicCreateSuccess" object:nil];
    
    self.title = @"发布动态";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavgationBar];

    [self textView];
    
    [self wordEditView];

    [self setupPhotosView];

    [self setupToolbar];
    
    [self.wordEditView addObserver:self forKeyPath:@"isTitleEditing" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"isTitleEditing"];
}

- (void)dealloc {
    [self.wordEditView removeObserver:self forKeyPath:@"isTitleEditing"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setNavgationBar {
    [self addNavigationRightWithName:@"发布" withTarget:self withAction:@selector(publishAction)];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] forState:UIControlStateNormal];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (keyPath == @"isTitleEditing") {
        BOOL isTitleEditing = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        [self.toolbar changeComposeToolBarShowType:(isTitleEditing ? SYComposeToolbarShowTypeNovelTitle : SYComposeToolbarShowTypeNovelBody)];
    }
}

#pragma mark ---------------------- toolBar action handler ------------------------
- (void)openAlbum {
    GWLPhotoLibrayController *photoSelector = [GWLPhotoLibrayController photoLibrayControllerWithBlock:^(NSArray *images) {
        if (self.toolbar.showType == SYComposeToolbarShowTypeTopic) {
            for (UIImage *image in images) {
                [self.imageDisplayView addImage:image];
            }
            [self.textView becomeFirstResponder];
        } else {
            for (UIImage *image in images) {
                [self.wordEditView insertImage:image];
            }
            
            [self.wordEditView becomeFirstResponder];
        }
    }];
    int maxCount = 0;
    if (self.toolbar.showType == SYComposeToolbarShowTypeTopic) {
        maxCount = 3 - self.imageDisplayView.images.count;
        if (maxCount < 1) {
            [SYProgressHUD showError:@"最多只能添加3张图片哦"];
            return;
        }
    } else {
        maxCount = 9;
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

- (void)previewPublish {
    SYStoryNovelReadController *vc = [[SYStoryNovelReadController alloc] init];
    vc.contentArray = [self.wordEditView generateContentBodyWithImageURLArray:@{} forLocalPreview:YES];
    vc.imageArray = [self.wordEditView getImageArray];
    vc.isLocal = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)publishAction {
    self.params = [NSMutableDictionary dictionary];
    [self.params setObject:SCCacheTool.shareInstance.getCurrentCharacterId forKey:@"characterId"];
    [self.params setObject:SCCacheTool.shareInstance.getCurrentSpaceId forKey:@"spaceId"];
    [self.params setObject:(self.toolbar.showType == SYComposeToolbarShowTypeTopic ? @1 : @2) forKey:@"type"];
    if (self.toolbar.showType == SYComposeToolbarShowTypeTopic) {
        if (![self.textView.text isNotBlank]) {
            [SYProgressHUD showError:@"动态信息不能为空哦"];
            return;
        }
    } else {
        if (![self.wordEditView.titleTextField.text isNotBlank] || ![self.wordEditView.text isNotBlank]) {
            [SYProgressHUD showError:@"标题和内容都不能为空哦"];
            return;
        }
    }
    
    [SYProgressHUD showMessage:@"正在火速发布"];
    [SCAliyunUploadMananger shareInstance].delegate = self;
    if (self.toolbar.showType == SYComposeToolbarShowTypeTopic) {
        [[SCAliyunUploadMananger shareInstance] uploadImageArray:self.imageDisplayView.images];
    } else {
        NSMutableDictionary *imageDictionary = [self.wordEditView getImageDictionary];
        NSMutableArray *imageArray = [NSMutableArray array];
        [self.uploadImageDictionary removeAllObjects];
        int i = 0;
        for (NSString *key in imageDictionary.allKeys) {
            [self.uploadImageDictionary setObject:@{
                                                    @"key":key
                                                    } forKey:[NSNumber numberWithInt:i]];
            [imageArray addObject:imageDictionary[key]];
            i += 1;
        }
        [[SCAliyunUploadMananger shareInstance] uploadImageArray:imageArray];
    }
}


#pragma mark ----------- SCAliyunUploadManangerDelegate -------------------

- (void)aliyunUploadManagerError:(NSError *)error {
    [SYProgressHUD showError: error.description];
}

- (void)aliyunUploadManagerFinishdWithImageURLArray:(NSArray *)array {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.toolbar.showType == SYComposeToolbarShowTypeTopic) {
        
        if ([self.textView.text isNotBlank]) {
            NSMutableDictionary *introDict = [NSMutableDictionary dictionary];
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
            [dict setObject:[JsonTool stringFromDictionary:introDict] forKey:@"intro"];
            [self.params setObject:[JsonTool stringFromArray:topicIds] forKey:@"topicIds"];
        } else {
            [SYProgressHUD showError:@"动态信息不能为空哦"];
            return;
        }
    } else {
        if ([self.wordEditView.titleTextField.text isNotBlank]) {
            [dict setObject:self.wordEditView.titleTextField.text forKey:@"title"];
            NSMutableDictionary *imageDict = [NSMutableDictionary dictionary];
            for (int i=0; i < array.count; i += 1) {
                NSDictionary *dict = [self.uploadImageDictionary objectForKey:[NSNumber numberWithInt:i]];
                if (dict) {
                    [imageDict setObject:array[i] forKey: dict[@"key"]];
                }
            }
            NSMutableDictionary *bodyDict = [JsonTool stringFromArray:[self.wordEditView generateContentBodyWithImageURLArray:imageDict forLocalPreview:NO]];
            if (!bodyDict) {
                return;
            } else {
                [dict setObject:bodyDict forKey:@"content"];
            }
          
            [dict setObject:[self.wordEditView generateIntroduction] forKey:@"intro"];
        } else {
            [SYProgressHUD showError:@"标题不能为空哦"];
            return;
        }
    }
    
    [self.params setObject:[JsonTool stringFromDictionary:dict] forKey:@"dataString"];
    WS(WeakSelf);
    [[SCNetwork shareInstance] postWithUrl:STORYADD parameters:self.params success:^(id responseObject) {
        [SYProgressHUD hideHUD];
        [NSNotificationCenter.defaultCenter postNotificationName:NotificationNameStoryPublishSuccess object:nil];
        SYStoryListBaseController *storyListVC = nil;
        for (UIViewController   *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[SYStoryController class]]) {
                storyListVC = (SYStoryListBaseController*)vc.childViewControllers.lastObject;
                [storyListVC requestData:YES];
                [WeakSelf.navigationController popViewControllerAnimated:YES];
            }
        }
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
        self.toolbar.transform      = CGAffineTransformIdentity;
        self.textView.height        = SCREEN_HEIGHT - kNavStatusBarHeight - 44 - 150;
        self.wordEditView.height    = SCREEN_HEIGHT - kNavStatusBarHeight - 44;
        _keyboardHeight = 0;
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
        
        _keyboardHeight = keyboardH;
        

        CGFloat toolBarY = self.view.height - keyboardH - self.toolbar.height;
        
        self.textView.height        = toolBarY - 100;
        self.wordEditView.height    = toolBarY - 20;
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, -keyboardH);
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
            
        case SYComposeToolbarButtonTypePreView:
            [self previewPublish];
            break;
    }
}

// 切换发布动态的类型 小说 ／ 动态
- (void)composeToolSwitchBtn:(BOOL)isButtonOn {
    if (isButtonOn) {
        [self.wordEditView becomeResponder];
    } else {
        [self.textView becomeFirstResponder];
    }
    
    self.wordEditView.hidden = !isButtonOn;
    self.imageDisplayView.hidden = isButtonOn;
    self.textView.hidden = isButtonOn;
}



#pragma mark ------------ SYSelectFriendControllerDelegate -------------
- (void)selectFriendWithArray:(NSArray *)array {
    if (self.toolbar.showType == SYComposeToolbarShowTypeTopic) {
        for (NSDictionary *dict in array) {
            [self.textView insertMention:dict[@"name"] withCharacterId:dict[@"modelId"]];
        }
    } else {
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
