//
//  SCStoryPublishVideoController.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/19.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SCStoryPublishVideoController.h"
#import "SCStoryRecordController.h"
#import "SCAliyunPlayerUploader.h"
#import "SYWordEditView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SCStoryPublishVideoController ()<SCStoryRecordDelegate, SCFileTransforProtocol>

@property (strong, nonatomic) SYWordEditView *textView;

@property (strong, nonatomic) UIImageView *videoDisplayImageView;

@property (strong, nonatomic) UIButton *rightButton;

@property (copy, nonatomic) NSString *videoPath;

@property (copy, nonatomic) NSString *imagePath;

@property (assign, nonatomic) CGFloat textViewHeight;

@property (strong, nonatomic) MPMoviePlayerViewController *playerView;

@end

@implementation SCStoryPublishVideoController

- (SYWordEditView *)textView {
    if (!_textView) {
        _textView = [[SYWordEditView alloc] init];
        _textView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 300);
        self.textViewHeight = SCREEN_HEIGHT - 300;
        _textView.titleTextField.placeholder = @"请输入作品名称";
        [_textView setPlaceholder:@"简介（可忽略）"];
        [self.view addSubview: _textView];
    }
    
    return _textView;
}

- (UIImageView *)videoDisplayImageView {
    if (!_videoDisplayImageView) {
        _videoDisplayImageView = [[UIImageView alloc] init];
        _videoDisplayImageView.contentMode = UIViewContentModeScaleAspectFit;
        _videoDisplayImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterPlayVideo)];
        [_videoDisplayImageView addGestureRecognizer:tap];
        [self.view addSubview:_videoDisplayImageView];
        [_videoDisplayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.width.height.mas_equalTo(112);
            make.bottom.equalTo(self.view).with.offset(-60);
        }];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImageNormal:@"story_publish_item_remove" withImageHighlighted:@"story_publish_item_remove"];
        [_videoDisplayImageView addSubview:closeButton];
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(18);
            make.right.top.mas_equalTo(0);
        }];
        [closeButton addTarget:self action:@selector(removeVideo) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *playerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"story_video_preview"]];
        [_videoDisplayImageView addSubview:playerImageView];
        [playerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(30);
            make.center.mas_equalTo(0);
        }];
        
        _videoDisplayImageView.hidden = YES;
    }
    
    return _videoDisplayImageView;
}

- (void)registerNotification {
    // 键盘的frame(位置)即将改变, 就会发出UIKeyboardWillChangeFrameNotification
    // 键盘即将弹出, 就会发出UIKeyboardWillShowNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //播放完后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification                                                      object:nil];
    //离开全屏时通知，因为默认点击Done是退出全屏，要离开播放器就要覆盖掉这个事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitFullScreen:) name: MPMoviePlayerDidExitFullscreenNotification object:nil];
}

- (void)layoutUI {
    self.title = @"拍摄演绎短片";
    [self addNavigationBackButton];
    
    [self setKeyBoardAutoHidden];
    _rightButton = [self addNavigationRightWithName:@"开始" withTarget:self withAction:@selector(rightButtonHandle:)];
    [_rightButton setTitle:@"开始" forState:UIControlStateNormal];
    [_rightButton setTitle:@"发布" forState:UIControlStateSelected];
    
    [self textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightButtonHandle:(UIButton *)button {
    if (button.selected) {
        // 发布视频
        [self sureAction];
    } else {
        SCStoryRecordController *vc = [[SCStoryRecordController alloc] init];
        vc.reocodDelegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)sureAction {
    if (![self.textView.titleTextField.text isNotBlank]) {
        [SYProgressHUD showError:@"演绎名称不能为空哦"];
        [self.textView.titleTextField becomeFirstResponder];
        return;
    }
    
    [SYProgressHUD showMessage:@"火速发布演绎中..."];
    if (self.imagePath && self.videoPath) {
        [SCAliyunPlayerUploader.sharedInstance uploadWithVideoPath:self.videoPath withImagePath:self.imagePath title:_textView.titleTextField.text desc:_textView.text];
        SCAliyunPlayerUploader.sharedInstance.delegate = self;
    } else {
        [self publishPlayWithVideoIdentity:nil withImageUrl:nil];
    }
}

- (void)publishPlayWithVideoIdentity:(NSString *)videoIdentity withImageUrl:(NSString *)imageUrl {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.textView.titleTextField.text forKey:@"title"];
    [dict setObject:self.textView.text forKey:@"intro"];
    if (videoIdentity) {
        [dict setObject:videoIdentity forKey:@"vidId"];
    }
    if (imageUrl) {
        [dict setObject:imageUrl forKey:@"background"];
    }
    [params setObject:[JsonTool stringFromDictionary:dict] forKey:@"dataString"];
    [params setObject:[SCCacheTool.shareInstance getCurrentCharacterId] forKey:@"characterId"];
    [params setObject:[SCCacheTool.shareInstance getCurrentSpaceId] forKey:@"spaceId"];
    [params setObject:[SCCacheTool.shareInstance getCurrentUser] forKey:@"userId"];

    [SCNetwork.shareInstance postWithUrl:@"" parameters:params success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        [SYProgressHUD showError:@"发布演绎失败"];
        SCLog(@"%@",error);
    }];
}

- (void)addVideoWithVideoPath:(NSString *)videoPath andImagePath:(NSString *)imagePath {
    self.videoPath = videoPath;
    self.imagePath = imagePath;
    
    self.videoDisplayImageView.hidden = NO;
    self.videoDisplayImageView.image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    self.rightButton.selected = YES;
}

- (void)removeVideo {
    self.videoPath = nil;
    self.imagePath = nil;
    
    self.videoDisplayImageView.image = nil;
    self.rightButton.selected = NO;
    self.videoDisplayImageView.hidden = YES;
}


- (void)keyboardWillHide:(NSNotification *)note {
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    SCLog(@"---- keyboardWillHide view height %f", self.textView.height);
    // 2.动画
    WS(WeakSelf);
    [UIView animateWithDuration:duration animations:^{
        WeakSelf.textView.height = WeakSelf.textViewHeight;
        WeakSelf.videoDisplayImageView.transform = CGAffineTransformIdentity;
    }];
}

- (void)keyboardWillShow:(NSNotification *)note {
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 2.动画
    SCLog(@"------- keyboardWillShow view height %f", self.textView.height);
    WS(WeakSelf);
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        WeakSelf.textView.height        = WeakSelf.textViewHeight - 200;
        WeakSelf.videoDisplayImageView.transform = CGAffineTransformMakeTranslation(0, -220);
    }];
}

#pragma marks ----------------------- Video upload delegate -------------------------
- (void)fileTransforSuccessWithIdentity:(NSString *)indentity {
    if (self.videoPath == indentity) {
        SCLog(@"视频上传成功");
    }
}

- (void)fileTransforProgressWithIdentity:(NSString *)indentity withProgress:(CGFloat)progress {
    if (self.videoPath == indentity) {
    }
}

- (void)fileTransforFailedWithIdentity:(NSString *)indentity withError:(NSError *)error {
    if (self.videoPath == indentity) {
        SCLog(@"视频上传失败, Error:%@", error);
    }
}

#pragma marks ------------------------ record delegate ------------------------------
- (void)storyRecordSuccessWithVideoPath:(NSString *)videoPath andImagePath:(NSString *)imagePath {
    [self addVideoWithVideoPath:videoPath andImagePath:imagePath];
}

- (void)enterPlayVideo {
    if (self.videoPath) {
        NSURL *url = [NSURL fileURLWithPath:self.videoPath];
        [_playerView.view removeFromSuperview];
        _playerView = nil;
        _playerView = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [_playerView.moviePlayer prepareToPlay];
        [self.view addSubview:_playerView.view];
        
        [_playerView.moviePlayer setControlStyle:MPMovieControlStyleDefault];
        
        [_playerView.moviePlayer setFullscreen:YES];
        
        [_playerView.view setFrame:self.view.bounds];
        
    }
}

//播放结束后离开播放器,点击上一曲、下一曲也是播放结束
- (void)movieFinishedCallback:(NSNotification*)notification {
    MPMoviePlayerController* theMovie = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
    [theMovie.view removeFromSuperview];
}

- (void)exitFullScreen:(NSNotification *)notification {
    [_playerView.view removeFromSuperview];
}

@end
