//
//  SCAliyunPlayerVodViewController.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/19.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SCAliyunPlayerVodView.h"
#import <AliyunVodPlayerViewSDK/AliyunVodPlayerViewSDK.h>
#import "SCFileSessionManager.h"

@interface SCAliyunPlayerVodView()<AliyunVodPlayerViewDelegate>

@property (strong , nonatomic) AliyunVodPlayerView *playerView;

@property (assign, nonatomic) BOOL isLock;

@property (copy, nonatomic) NSString *vid;

@end

@implementation SCAliyunPlayerVodView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _layoutUI];
    }
    return self;
}

- (void)prepareVideoWithVid:(NSString *)vid withCoverUrl:(NSURL *)coverUrl {
    self.vid = vid;
    //测试封面地址，请使用https 地址。
    self.playerView.coverUrl = coverUrl;
//    [self.playerView setTitle:@"1234567890"];
    
    WS(WeakSelf);
    [self getAliyunPlayerVodParams:^(NSString *keyId, NSString *keySecret, NSString *token, NSString *expireTime, NSError *error) {
        [WeakSelf.playerView playViewPrepareWithVid:WeakSelf.vid accessKeyId:keyId accessKeySecret:keySecret securityToken:token];
    }];
}

- (void)prepareVideoWithPlayerURL:(NSURL *)url withCoverURL:(NSURL *)coverURL {
    [self.playerView playViewPrepareWithURL:url];
}

- (void)_layoutUI {
    [self setBackgroundColor:[UIColor whiteColor]];
    CGFloat width = SCREEN_HEIGHT * 9 / 16.0;
    CGFloat height = SCREEN_HEIGHT;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ) {
        width = SCREEN_WIDTH;
        height = SCREEN_WIDTH * 9 / 16.0;
    }
    
    /****************UI播放器集成内容**********************/
    self.playerView = [[AliyunVodPlayerView alloc] initWithFrame:CGRectMake((self.width - width)/2, (self.height - height)/2, width, height)];

    self.playerView.circlePlay = YES;
    self.playerView.delegate = self;
    //设置清晰度。
    self.playerView.quality = AliyunVodPlayerVideoLD;
    
    self.playerView.isLockScreen = NO;
    self.playerView.isLockPortrait = NO;
    self.isLock = self.playerView.isLockScreen || self.playerView.isLockPortrait ? YES : NO;
    
    //maxsize:单位 mb    maxDuration:单位秒 ,在prepare之前调用。
    [self.playerView setPlayingCache:YES saveDir:[SCFileSessionManager getVideoPathWithIdentity:@"1234567890.mp4"] maxSize:300 maxDuration:10000];
    
    //查看缓存文件时打开。
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerun) userInfo:nil repeats:YES];
    
    //播放器播放方式
    SCLog(@"%@",[self.playerView getSDKVersion]);
    [self addSubview:self.playerView];
}

- (void)getAliyunPlayerVodParams:(void (^)(NSString *keyId, NSString *keySecret, NSString *token,NSString *expireTime,  NSError * error)) callback {

}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView onResume:(NSTimeInterval)currentPlayTime {
    
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView onStop:(NSTimeInterval)currentPlayTime {
    
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView onPause:(NSTimeInterval)currentPlayTime {
    
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView lockScreen:(BOOL)isLockScreen {
    
}

@end
