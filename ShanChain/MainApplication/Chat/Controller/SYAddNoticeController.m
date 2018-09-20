//
//  SYAddNoticeController.m
//  ShanChain
//
//  Created by krew on 2017/9/14.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYAddNoticeController.h"
#import "SYTextView.h"
#import "SYComposePhotosView.h"
#import "SYAddNoticeToolView.h"
#import "SYComposeTrendController.h"

@interface SYAddNoticeController ()<SYAddNoticeToolViewDelegate,SYComposeTrendControllerDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UITextField  *titleField;
@property (nonatomic, weak)  SYTextView *textView;
@property (nonatomic, weak)  SYComposePhotosView *photosView;
@property(nonatomic,weak)SYAddNoticeToolView *noticeToolView;

//阿里云参数
@property(nonatomic,strong)NSDictionary *aliDict;

//图片数组
@property(nonatomic,strong)NSMutableArray *pictureArr;

@end

@implementation SYAddNoticeController
#pragma mark -懒加载
- (NSMutableArray *)pictureArr{
    if (!_pictureArr) {
        _pictureArr = [NSMutableArray array];
    }
    return _pictureArr;
}

- (UITextField *)titleField{
    if (!_titleField) {
        _titleField = [[UITextField alloc]init];
        _titleField.placeholder = @"  输入标题";
        _titleField.delegate = self;
        _titleField.borderStyle = UITextBorderStyleNone;
        
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 20.0/667*SCREEN_HEIGHT)];
        leftView.backgroundColor = [UIColor clearColor];
        _titleField.leftView = leftView;
        _titleField.leftViewMode = UITextFieldViewModeAlways;
        
        _titleField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        _titleField.textColor = RGB(102, 102, 102);
        _titleField.font = [UIFont systemFontOfSize:14];
        
        [_titleField setValue:[UIFont systemFontOfSize:12]forKeyPath:@"_placeholderLabel.font"];
        [_titleField setValue:RGB(179, 179, 179) forKeyPath:@"_placeholderLabel.textColor"];
        _titleField.frame = CGRectMake(KSCMargin, (25.0/667) * SCREEN_HEIGHT,SCREEN_WIDTH - 2 * KSCMargin, (20.0/667) * SCREEN_HEIGHT);
    }
    return _titleField;
}

- (SYTextView *)textView{
    if (!_textView) {
        _textView = [[SYTextView alloc]init];
        _textView.alwaysBounceVertical = YES;//垂直向上拥有弹簧效果
        _textView.frame = CGRectMake(KSCMargin, CGRectGetMaxY(self.titleField.frame) + 25, SCREEN_WIDTH - 2 * KSCMargin, SCREEN_HEIGHT - kNavStatusBarHeight);
        _textView.delegate = self;
        
        _textView.placeholder = @"输入内容";
        
        _textView.font = [UIFont systemFontOfSize:12];
        _textView.textColor = RGB(102, 102, 102);
//        _textView.backgroundColor = RGB(213, 18, 76);
        
        //监听键盘
        // 键盘的frame(位置)即将改变, 就会发出UIKeyboardWillChangeFrameNotification
        // 键盘即将弹出, 就会发出UIKeyboardWillShowNotification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return _textView;
}

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加公告";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.titleField];
    
    [self.view addSubview:self.textView];
    
    [self setNavgationBar];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    
    [self setupToolbar];
    
    [self setupPhotosView];
}

#pragma mark -构造方法
- (void)textViewDidChange:(UITextView *)textView{
    
}

- (void)setNavgationBar{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTintColor:RGB(102, 102, 102)];
}

// 添加工具条
- (void)setupToolbar{
    // 1.创建
    SYAddNoticeToolView *toolbar = [[SYAddNoticeToolView alloc] init];
    
    toolbar.width = self.view.width;
    toolbar.delegate = self;
    toolbar.height = 44;
    self.noticeToolView = toolbar;
    // 2.显示
    toolbar.y = self.view.height - toolbar.height -kNavStatusBarHeight;
    [self.view addSubview:toolbar];
}

// 添加显示图片的相册控件
- (void)setupPhotosView{
    SYComposePhotosView *photosView = [[SYComposePhotosView alloc] init];
    photosView.width = self.textView.width;
    photosView.height = self.textView.height;
    self.photosView = photosView;
    photosView.y = 120;
    [self.textView addSubview:photosView];
    self.photosView = photosView;
}

- (void)sureAction{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    if ([self.titleField.text isNotBlank]) {
//        [dict setObject:self.titleField.text forKey:@"title"];
//    }else{
//        return;
//    }
//    
//    if ([self.textView.text isNotBlank]) {
//        [dict setObject:self.textView.text  forKey:@"content"];
//    }else{
//        return;
//    }
    
//    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:dict];
//    NSString *from = [[EMClient sharedClient] currentUsername];
//    
//    NSDictionary *ext =  @{@"headImg":@"http://7xrpiy.com1.z0.glb.clouddn.com/babyShow/1462945613-0",@"nickName":@"zxy000",@"msgAttr":@"2",@"groupImg":@"",@"isGroup":@"NO"};
//    
//    EMMessage *message = [[EMMessage alloc]initWithConversationID:@"27847047577601" from:from to:@"27847047577601" body:body ext:ext];
//    
//    [[EMClient sharedClient].chatManager importMessages:@[message] completion:^(EMError *aError) {
//        
//    }];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"32404160970754" forKey:@"groupId"];
    
    if ([self.titleField.text isNotBlank]) {
        [params setObject:self.titleField.text forKey:@"title"];
    }else{
        [SYProgressHUD showError:@"请输入标题"];
        return;
    }
    
    if ([self.textView.text isNotBlank]) {
        [params setObject:self.textView.text forKey:@"notice"];
    }else{
        [SYProgressHUD showError:@"请输入内容"];
        return;
    }
    
//    //   [params setObject:@"hello" forKey:@"token"];
    
    [[SCNetwork shareInstance]postWithUrl:HXGROUPNOTICEADD parameters:params success:^(id responseObject) {
        if ([responseObject[@"code"]isEqualToString:SC_COMMON_SUC_CODE]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        SCLog(@"%@",error);
    }];
    
}

#pragma mark - 键盘处理
/**
 *  键盘即将隐藏：工具条（toolbar）随着键盘移动
 */
- (void)keyboardWillHide:(NSNotification *)note{
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        self.noticeToolView.transform = CGAffineTransformIdentity;//回复之前的位置
    }];
}

/**
 *  键盘即将弹出
 */
- (void)keyboardWillShow:(NSNotification *)note{
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;
        self.noticeToolView.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
        
        self.noticeToolView.y = self.view.height - keyboardH - self.noticeToolView.height;
    }];
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}

#pragma mark -SYAddNoticeToolViewDelegate

- (void)noticeTool:(SYAddNoticeToolView *)toolbar didClickedButton:(SYAddNoticeToolViewButtonType)buttonType{
    switch (buttonType) {

        case SYAddNoticeToolViewButtonTypePicture: // 相册
            [self openAlbum];
            break;
            
        case SYAddNoticeToolViewButtonTypeMention: // @
            [self openTrend];
            break;
            
        default:
            break;
    }
}

- (void)openAlbum{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

- (void)openTrend{
    SYComposeTrendController *trendVC = [[SYComposeTrendController alloc]init];
    [self.navigationController pushViewController:trendVC animated:YES];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (CGRectGetMaxY(self.textView.frame) > 100 && CGRectGetMaxY(self.textView.frame) < 200) {
        [UIView animateWithDuration:0.5 animations:^{
            self.photosView.y = self.photosView.y + 5;
        }];
    }else if (CGRectGetMaxY(self.textView.frame) >  200){
        [UIView animateWithDuration:0.5 animations:^{
            self.photosView.y = self.photosView.y + 10;
        }];
    }else{
        self.photosView.y = self.photosView.y - 0;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];//销毁modal控制器
    
    // 1.取出选中的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    if ([APIClient networkType] > 0) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        [self updateImg: imageData image:image];//接口
    }else{
        [SYProgressHUD showError:kNotReachableTip];
    }
    
    // 2.添加图片到相册中
    [self.photosView addImage:image];
}

- (void)updateImg:(NSData *)imageData image:(UIImage *)image {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (image) {
        if ([APIClient networkType] > 0) {
            [params setObject:@(1) forKey:@"num"];
            
            [[SCNetwork shareInstance]postWithUrl:STORYUPLOADAPP parameters:params success:^(id responseObject) {
                if ([responseObject[@"code"]isEqualToString:SC_COMMON_SUC_CODE]) {
                    self.aliDict = responseObject[@"data"];
                    [self updateImg:imageData image:image cb:^(NSString *str) {
                        
                    }];
                }
            } failure:^(NSError *error) {
                SCLog(@"%@",error);
            }];
            
        }
    }
}

//上传阿里云 拿到地址
- (void)updateImg:(NSData *)imageData image:(UIImage *)image cb:(void(^)(NSString *))cb {
    //    NSString *uuid = [Util uuid];
    NSString *uuid = self.aliDict[@"uuidList"][0];
    NSString *kAliFileAccessKeyId = self.aliDict[@"accessKeyId"];
    NSString *kAliFileAccessKeySecret = self.aliDict[@"accessKeySecret"];
    NSString *kAliFileSecurityToken = self.aliDict[@"securityToken"];
    //  'project' + "/" + self.projectId + "/" + self.updateTypeName + "/" + uuid + ".jpg";
    //  'project/' + self.projectId + "/" + self.updateTypeName + "/" + uuid + ".jpg";
    NSString *updateUri = [NSString stringWithFormat:@"%@/%@.jpg?x-oss-process=image/resize,m_fixed,h_1100,w_733",kAliFileHost,uuid];
    [self.pictureArr addObject:updateUri];
    NSString *endpoint = kEndPoint;
    
    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:kAliFileAccessKeyId secretKeyId:kAliFileAccessKeySecret securityToken:kAliFileSecurityToken];
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
    //
    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
    put.bucketName = kAliFileBucketName;
    put.objectKey = updateUri;
    put.uploadingData = imageData;
    put.contentType = @"image/jpeg";
    
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
    };
    
    OSSTask *putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            SCLog(@"阿里云上传成功!");
            //GCD 写主线程
            dispatch_async(dispatch_get_main_queue(), ^{
            });
            if (cb) {
                cb(uuid);
            }
        } else {
            SCLog(@"阿里云上传失败, error: %@" , task.error);
            if (cb) {
                cb(nil);
            }
        }
        return nil;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
