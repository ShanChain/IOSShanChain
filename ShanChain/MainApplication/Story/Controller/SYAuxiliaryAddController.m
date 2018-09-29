//
//  SYAuxiliaryAddController.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/7.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SYAuxiliaryAddController.h"

#import "SYMarkCollection1Cell.h"
#import "SYAddTimeReportController.h"
#import "SCCacheTool.h"
#import "SCAliyunUploadMananger.h"
#import "SYAddRoleReportController.h"
#import "SYStoryPublishController.h"
#import "SYStoryMarkController.h"

static NSString * const SYMarkCollection1CellID = @"SYMarkCollection1Cell";

@implementation SYAuxiliaryAddObject

@end

static int const TagAddField = 100001;
static int const TagTitleField = 100002;
static int const TagTitleField2 = 100003;
static int const TagDetailField = 100004;
@interface SYAuxiliaryAddController
()<UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    BOOL _keyboardIsShown;
}

@property (assign, nonatomic) int pageIndex;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) UIImageView   *iconImageView;

@property (strong, nonatomic) UITextField   *titleField;

@property (strong, nonatomic) UITextField   *titleField2;

@property (strong, nonatomic) UITextView    *detailTextView;

@property (strong, nonatomic) UILabel       *detailPlaceholdLabel;

@property (strong, nonatomic) UILabel       *trailLabel;
// 已选中的标签
@property (nonatomic,strong) NSMutableArray *selectedTagArray;

@property (nonatomic, strong) NSMutableArray *tagsArray;

@property (strong, nonatomic) UITextField   *tagTextField;

@property (strong, nonatomic) NSString *pictureUploadedUrl;

@property (strong, nonatomic) SYAuxiliaryAddObject *auxiliaryObject;

@end

@implementation SYAuxiliaryAddController

#pragma mark -懒加载
- (NSMutableArray *)tagsArray {
    if (!_tagsArray) {
        _tagsArray = [NSMutableArray array];
    }
    return _tagsArray;
}
- (NSMutableArray *)selectedTagArray{
    if (!_selectedTagArray) {
        _selectedTagArray = [NSMutableArray array];
    }
    return _selectedTagArray;
}

- (SYAuxiliaryAddObject *)auxiliaryObject {
    if (!_auxiliaryObject) {
        _auxiliaryObject = [[SYAuxiliaryAddObject alloc] init];
    }

    return _auxiliaryObject;
}

- (UITextField *)tagTextField {
    if (!_tagTextField) {
        _tagTextField = [SYUIFactory textFieldWithPlacehold:@"自定义标签" withFont:[UIFont systemFontOfSize:12] withColor:RGB(102, 102, 102)];
        
        _tagTextField.tag = TagAddField;
        _tagTextField.delegate = self;
        _tagTextField.frame = CGRectMake(SCREEN_WIDTH - 180, 10, 130, 30);
    }
    
    return _tagTextField;
}

-(UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 20;
        layout.minimumLineSpacing = 15;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 200) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.hidden = YES;
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.allowsMultipleSelection = YES;//默认为NO,是否可以多选
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SYMarkCollection1Cell class]) bundle:nil] forCellWithReuseIdentifier:SYMarkCollection1CellID];
        WS(WeakSelf);
        MJRefreshFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            WeakSelf.pageIndex += 1;
            [WeakSelf requestTagList];
        }];
        _collectionView.mj_footer = footer;
        
        [self.scrollView addSubview:_collectionView];
    }
    return _collectionView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(KSCMargin, 10 , 70.0, 70.0)];
        _iconImageView.image = [UIImage imageNamed:@"abs_addarole_def_photo_default"];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 8.0;
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        tapAction.delegate = self;
        [_iconImageView addGestureRecognizer:tapAction];
    }
    return _iconImageView;
}

- (UITextField *)titleField {
    if (!_titleField) {
        _titleField = [SYUIFactory textFieldWithPlacehold:self.auxiliaryObject.placeholdTitle withFont:[UIFont systemFontOfSize:12] withColor:RGB(102, 102, 102)];
        _titleField.delegate = self;
        _titleField.tag = TagTitleField;
        _titleField.frame = CGRectMake(115.0, 10.0, 180.0, 30.0);
        _titleField.text = self.auxiliaryObject.title;
        
    }
    return _titleField;
}

- (UITextField *)titleField2 {
    if (!_titleField2) {
        _titleField2 = [SYUIFactory textFieldWithPlacehold:self.auxiliaryObject.placeholdTitle2 withFont:[UIFont systemFontOfSize:12] withColor:RGB(102, 102, 102)];

        _titleField2.delegate = self;
        _titleField2.tag = TagTitleField2;
        _titleField2.frame = CGRectMake(115, 50, 180.0, 30);
    }
    return _titleField2;
}

- (UILabel *)detailPlaceholdLabel {
    if (!_detailPlaceholdLabel) {
        _detailPlaceholdLabel = [UILabel new];
        [_detailPlaceholdLabel makeTextStyleWithTitle:self.auxiliaryObject.placeholdDetail withColor:RGB(179, 179, 179) withFont:[UIFont systemFontOfSize:12] withAlignment:NSTextAlignmentLeft];
        _detailPlaceholdLabel.frame = CGRectMake(15, 8, self.detailTextView.frame.size.width - 20, 20);
    }
    return _detailPlaceholdLabel;
}

- (UITextView *)detailTextView {
    if (!_detailTextView) {
        _detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(KSCMargin, CGRectGetMaxY(self.iconImageView.frame)+15, SCREEN_WIDTH - KSCMargin * 2, (100.0/667)*SCREEN_HEIGHT)];
        _detailTextView.delegate = self;
        _detailTextView.tag = TagDetailField;
        _detailTextView.layer.masksToBounds = YES;
        _detailTextView.layer.cornerRadius = 8.0f;
        _detailTextView.layer.borderColor = [RGB(179, 179, 179)CGColor];
        _detailTextView.layer.borderWidth = 1.0f;
        [_detailTextView addSubview:self.detailPlaceholdLabel];
    }
    return _detailTextView;
}

- (UILabel *)trailLabel {
    if (!_trailLabel) {
        _trailLabel = [[UILabel alloc]init];
        [_trailLabel makeTextStyleWithTitle:self.auxiliaryObject.placeholdTrail withColor:RGB(179, 179, 179) withFont:[UIFont systemFontOfSize:10] withAlignment:NSTextAlignmentLeft];
        _trailLabel.numberOfLines = 0;
        _trailLabel.frame = CGRectMake(KSCMargin, CGRectGetMaxY(self.detailTextView.frame) + 5, SCREEN_WIDTH - 2 * KSCMargin, 50);
    }
    return _trailLabel;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame: self.view.frame];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        
        [self.view addSubview:_scrollView];
    }
    
    return _scrollView;
}

#pragma mark ------------- layout UI ----------------
- (void)setNavigationBar {
    self.title = self.auxiliaryObject.navigationTitle;
    
    [self addNavigationRightWithName:@"确定" withTarget:self withAction:@selector(commitAddAction:)];
}

- (void)setupHeaderLabel {
    UILabel *label = [[UILabel alloc] init];
    [label makeTextStyleWithTitle:@"选择标签" withColor:RGB_HEX(0x666666) withFont:[UIFont systemFontOfSize:14] withAlignment:UITextAlignmentLeft];
    [self.scrollView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(20);
    }];
}

- (void)setupTagAddView {
    UIView *addView = [[UIView alloc] init];
    [self.scrollView addSubview:addView];
    [addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.collectionView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(self.scrollView.mas_width);
    }];
    
    [addView addSubview:self.tagTextField];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(CGRectGetMaxX(self.tagTextField.frame) + 10, 12.5, 25, 25);
    [addButton setImage:[UIImage imageNamed:@"abs_find_btn_addto_default"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addTagAction:) forControlEvents:UIControlEventTouchUpInside];
    [addView addSubview:addButton];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tagTextField.frame) + 9, CGRectGetWidth(addView.frame), 1)];
    lineView.backgroundColor = RGB(232, 232, 232);
    [addView addSubview:lineView];
}

- (void)setupDetailView {
    UIView *detailView = [[UIView alloc] init];
    [self.scrollView addSubview:detailView];
    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.collectionView.mas_bottom).with.offset(50);
        make.height.mas_equalTo(300);
    }];
    
    [detailView addSubview:self.iconImageView];
    
    [detailView addSubview:self.titleField];
    
    if ([self.auxiliaryObject.placeholdTitle2 isNotBlank]) {
        [detailView addSubview:self.titleField2];
    }

    [detailView addSubview:self.detailTextView];
    
    [detailView addSubview:self.trailLabel];
}

- (void)setupDefaultObject {
    switch (self.type) {
        case SYAuxiliaryAddTypeSpace:
            self.auxiliaryObject.maxLenDetail = 2000;
            self.auxiliaryObject.maxLenTitle = 10;
            self.auxiliaryObject.maxLenTitle2 = 22;
            self.auxiliaryObject.maxLenTag = 4;
            
            self.auxiliaryObject.placeholdTitle = @"请输入世界名城";
            self.auxiliaryObject.placeholdTitle2 = @"请写一句话作为宣传口号";
            self.auxiliaryObject.placeholdDetail = @"简单介绍一下世界吧～";
            self.auxiliaryObject.placeholdTrail = @"请确保角色符合要求，且不要和现有角色重复哦~\n时空管理局和当前时空的管理员都会审核这个角色。如果审核不通过，你可能无法继续使用这个角色。你还可以补充这个角色的人设长文。";

            self.auxiliaryObject.type  = @"space";
            self.auxiliaryObject.navigationTitle = @"添加新时空";
            break;
        case SYAuxiliaryAddTypeTopic:
            self.auxiliaryObject.maxLenDetail = 140;
            self.auxiliaryObject.maxLenTitle = 25;
            self.auxiliaryObject.maxLenTitle2 = 0;
            self.auxiliaryObject.maxLenTag = 4;
            
            self.auxiliaryObject.placeholdTitle = @"请输入话题";
            self.auxiliaryObject.placeholdTitle2 = @"";
            self.auxiliaryObject.placeholdDetail = @"请输入导语～";
            self.auxiliaryObject.placeholdTrail = @"";
            self.auxiliaryObject.title = self.topicName ? self.topicName : @"";

            self.auxiliaryObject.type  = @"topic";
            self.auxiliaryObject.navigationTitle = @"添加新话题";
            break;
        case SYAuxiliaryAddTypeRole:
            self.auxiliaryObject.maxLenDetail = 1000;
            self.auxiliaryObject.maxLenTitle = 16;
            self.auxiliaryObject.maxLenTitle2 = 0;
            self.auxiliaryObject.maxLenTag = 4;
            
            self.auxiliaryObject.placeholdTitle = @"请输入人物昵称";
            self.auxiliaryObject.placeholdTitle2 = @"";
            self.auxiliaryObject.placeholdDetail = @"简单介绍一下人物吧";
            self.auxiliaryObject.placeholdTrail = @"时空管理局和当前时空的管理员都会审核这个角色。如果审核不通过，你可能无法继续使用这个角色。你还可以补充这个角色的人设长文。";
            
            self.auxiliaryObject.type  = @"model";
            self.auxiliaryObject.navigationTitle = @"添加新人物";
            break;
        default:
            break;
    }
}

-(void)initFromRnData{
    if (self.rnParams != nil) {
        NSDictionary *rnData = [JsonTool dictionaryFromString:self.rnParams];
        NSDictionary *data = [rnData objectForKey:@"data"];
        if ([data objectForKey:@"type"]) {
            if([[data objectForKey:@"type"] isEqualToString:@"add_role"]){
                self.type = SYAuxiliaryAddTypeRole;
            }else if([[data objectForKey:@"type"] isEqualToString:@"add_topic"]){
                self.type = SYAuxiliaryAddTypeTopic;
            }else if([[data objectForKey:@"type"] isEqualToString:@"add_space"]){
                self.type = SYAuxiliaryAddTypeSpace;
            }
        }else{
            return;
        }
    }
}

#pragma mark -系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pictureUploadedUrl = @"";
    [self initFromRnData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupDefaultObject];
    [self setNavigationBar];
    
    [self scrollView];
    
    [self setupHeaderLabel];
    
    [self collectionView];
    [self setupTagAddView];
    [self setupDetailView];
    
    [self setKeyBoardAutoHidden];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.pageIndex = 0;
    [self requestTagList];
    
    [self.view endEditing:YES];
}

#pragma mark -构造方法
- (void)tapAction:(UIButton *)button {
    //调用系统相册的类
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    //设置的选取的照片是否可编辑
    pickerController.allowsEditing  = YES;
    //设置相册呈现样式
    pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;//图片分组形式列表存在
    pickerController.delegate = self;
    [self.navigationController presentViewController:pickerController animated:YES completion:^{
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *resultImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *image = [resultImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.iconImageView.image = image;
    WS(WeakSelf);
    [SCAliyunUploadMananger uploadImage:image withCompressionQuality:0.5 withCallBack:^(NSString *url) {
        WeakSelf.pictureUploadedUrl = url;
    } withErrorCallBack:^(NSError *error) {
        [SYProgressHUD showError:error.description];
    }];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ------------------ Helper -----------------------
- (void)requestTagList {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:self.pageIndex] forKey:@"page"];
    [params setObject:[NSNumber numberWithInt:20] forKey:@"size"];
    [params setObject:@"desc" forKey:@"sort"];
    [params setObject:self.auxiliaryObject.type forKey:@"type"];
    
    WS(WeakSelf);
    [[SCNetwork shareInstance] postWithUrl:STORYTAGQUERY parameters:params success:^(id responseObject) {
        WeakSelf.collectionView.hidden = NO;
        [WeakSelf.collectionView.mj_footer endRefreshing];
        NSMutableDictionary *data = responseObject[@"data"];
        NSMutableArray *arr = [data[@"content"] mutableCopy];
        [WeakSelf.collectionView.mj_footer endRefreshing];
        if (!arr.count) {
            WeakSelf.pageIndex -= 1;
        }
        for (int i = 0; i < arr.count; i ++) {
            NSMutableDictionary *dict = [arr[i] mutableCopy];
            [WeakSelf.tagsArray addObject:dict];
        }
        [WeakSelf.collectionView reloadData];
    } failure:^(NSError *error) {
        [WeakSelf.collectionView.mj_footer endRefreshing];
        SCLog(@"%@",error);
    }];
}

- (void)addTagAction:(UIButton *)button {
    if ([self.tagTextField.text isNotBlank]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"0" forKey:@"rate"];
        [dict setObject:@"0" forKey:@"tagId"];
        [dict setObject:@1 forKey:@"isSelected"];
        [dict setObject:self.tagTextField.text forKey:@"tagName"];
        [self.tagsArray addObject:dict];
        [self.collectionView reloadData];
    } else {
        [SYProgressHUD showError:@"不能添加空的标签哦"];
        return;
    }
}

- (void)commitAddAction:(UIButton *)button {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    if (![self.pictureUploadedUrl isNotBlank]) {
//        [SYProgressHUD showError:@"请上传一张图片"];
//        return;
//    }
    
    if (NULLString(self.detailTextView.text)) {
        [SYProgressHUD showError:@"来点简要的描述吧"];
        return;
    }

    if (NULLString(self.titleField.text)) {
        [SYProgressHUD showError:@"标题不能为空哦"];
        return;
    }
    
    if ([self.auxiliaryObject.placeholdTitle2 isNotBlank] && ![self.titleField2.text isNotBlank]) {
        [SYProgressHUD showError:@"说明不能为空哦"];
        return;
    }
    
    [params setObject:[JsonTool stringFromArray:self.selectedTagArray] forKey:@"jArray"];
    
    WS(WeakSelf);
    switch (self.type) {
        case SYAuxiliaryAddTypeTopic: {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:self.pictureUploadedUrl forKey:@"background"];
            [dict setObject:self.detailTextView.text forKey:@"intro"];
            [dict setObject:self.titleField.text forKey:@"title"];
            [params setObject:[SCCacheTool.shareInstance getCurrentCharacterId] forKey:@"characterId"];
            [params setObject:[SCCacheTool.shareInstance getCurrentSpaceId] forKey:@"spaceId"];
            [params setObject:[JsonTool stringFromArray:dict] forKey:@"dataString"];
            [SCNetwork.shareInstance postWithUrl:STORYTOPICCREATE parameters:params success:^(id responseObject) {
                NSDictionary *data = responseObject[@"data"];
                if (data[@"title"] && data[@"topicId"]) {
                    [NSNotificationCenter.defaultCenter postNotificationName:@"SYStoryTopicCreateSuccess" object:nil userInfo:@{@"topicName": [[@"#" stringByAppendingString:data[@"title"]] stringByAppendingString:@"#"], @"topicId":data[@"topicId"]}];
                    [WeakSelf popToViewControllerClass:SYStoryPublishController.class withAnimation:true];
                }
            } failure:nil];
            break;
        }
        case SYAuxiliaryAddTypeSpace: {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:self.pictureUploadedUrl forKey:@"background"];
            [dict setObject:self.detailTextView.text forKey:@"intro"];
            [dict setObject:self.titleField.text forKey:@"name"];
            [dict setObject:self.titleField2.text forKey:@"slogan"];
            [dict setObject:[SCCacheTool.shareInstance getCurrentUser] forKey:@"userId"];
            [params setObject:[JsonTool stringFromArray:dict] forKey:@"dataString"];
            [[SCNetwork shareInstance] postWithUrl:STORYSPACECREATE parameters:params success:^(id responseObject) {
                NSDictionary *content = responseObject[@"data"];
                if (content != [NSNull null] && content[@"spaceId"]) {
                    NSMutableDictionary *praram2 = [NSMutableDictionary dictionary];
                    [praram2 setObject:[SCCacheTool.shareInstance getCurrentUser] forKey:@"userId"];
                    [praram2 setObject:content[@"spaceId"] forKey:@"spaceId"];
                    [[SCNetwork shareInstance] postWithUrl:FOCUS_SPACE parameters:praram2 success:^(id responseObject) {
                        [WeakSelf popToViewControllerClass:SYStoryMarkController.class withAnimation:true];
                    } failure:^(NSError *error){
                        [WeakSelf popToViewControllerClass:SYStoryMarkController.class withAnimation:true];
                        SCLog(@"%@", error);
                    }];
                } else {
                    [WeakSelf popToViewControllerClass:SYStoryMarkController.class withAnimation:true];
                }
            } failure:nil];
            break;
        }
        case SYAuxiliaryAddTypeRole: {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:self.pictureUploadedUrl forKey:@"headImg"];
            [dict setObject:self.detailTextView.text forKey:@"intro"];
            [dict setObject:self.titleField.text forKey:@"name"];
            [params setObject:[JsonTool stringFromArray:dict] forKey:@"dataString"];
            [params setObject:[NSNumber numberWithLong:self.spaceId] forKey:@"spaceId"];
            [params setObject:[SCCacheTool.shareInstance getCurrentUser] forKey:@"userId"];
            [[SCNetwork shareInstance]postWithUrl:STORYCHARATERCREATE parameters:params success:^(id responseObject) {
                SYAddRoleReportController *addVC = [[SYAddRoleReportController alloc]init];
                [WeakSelf.navigationController pushViewController:addVC animated:YES];
            } failure:^(NSError *error) {
                
            }];
            break;
        }
    }
}

#pragma mark -UICollectionView的数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.tagsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SYMarkCollection1Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SYMarkCollection1CellID forIndexPath:indexPath];
    NSDictionary *d = self.tagsArray[indexPath.item];
    cell.itemTitleLabel.text = [d objectForKey:@"tagName"];
    [cell updateSelectState:[d objectForKey:@"isSelected"]];
    cell.itemTitleView.userInteractionEnabled = false;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dict = self.tagsArray[indexPath.item];
    if (dict[@"isSelected"]) {
        [dict removeObjectForKey:@"isSelected"];
        [self.selectedTagArray removeObject:dict[@"tagName"]];
        
    } else {
        [dict setObject:@1 forKey:@"isSelected"];
        [self.selectedTagArray addObject:dict[@"tagName"]];
    }
    
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake((self.view.frame.size.width-20 * 3 - 15 * 2 ) / 4, 30);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 15, 20, 15);
}

#pragma mark -UITextViewDelegate代理方法
-(void)textViewDidChange:(UITextView *)textView{
    //    textview 改变字体的行间距
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 5;// 字体的行间距
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName:[UIFont systemFontOfSize:14],
//
//                                 NSParagraphStyleAttributeName:paragraphStyle
//                                 };
//    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    self.detailPlaceholdLabel.hidden = self.detailTextView.text.length;
   
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    int count = textView.text.length;
    int replaceCount = text.length;
    int maxLen = self.auxiliaryObject.maxLenDetail;
    
    if ((count + replaceCount) > maxLen) {
        textView.text = [textView.text stringByAppendingString:[text substringWithRange:NSMakeRange(0, maxLen - count)]];
        return false;
    }
    return true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    int count = textField.text.length;
    int replaceCount = string.length;
    int maxLen = 0;
    switch (textField.tag) {
        case TagAddField:
            maxLen = self.auxiliaryObject.maxLenTag;
            break;
        case TagTitleField:
            maxLen = self.auxiliaryObject.maxLenTitle;
            break;
        case TagTitleField2:
            maxLen = self.auxiliaryObject.maxLenTitle2;
            break;
        default:
            break;
    }
    
    if ((count + replaceCount) > maxLen) {
        textField.text = [textField.text stringByAppendingString:[string substringWithRange:NSMakeRange(0, maxLen - count)]];
        return false;
    }
    return true;
}

- (void)keyboardDidShow:(NSNotification*)notification {
    CGRect begin = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect end = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect responderFrame = self.view.frame;
    for (UIView *v in self.scrollView.subviews) {
        if (v.isFirstResponder) {
            responderFrame = v.frame;
        } else {
            for (UIView *d in v.subviews) {
                if (d.isFirstResponder) {
                    // d.frme相对self.view的位置
                    responderFrame = [d convertRect:d.frame toView:self.view];
                }
            }
        }
    }
    
    // 第三方键盘回调三次问题，监听仅执行最后一次
    WS(WeakSelf);
    CGFloat offsetY = 0;
    if (end.origin.y - CGRectGetMaxY(responderFrame) - 20 < 0) {
        offsetY = CGRectGetMaxY(responderFrame) - end.origin.y + 20;
    }
    [Util commonViewAnimation:^{
        WeakSelf.scrollView.contentOffset = CGPointMake(0, offsetY);
    } completion:nil];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    WS(WeakSelf);
    [Util commonViewAnimation:^{
        WeakSelf.scrollView.contentOffset = CGPointMake(0, 0);
    } completion:nil];
}

@end
