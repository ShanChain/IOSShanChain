//
//  SCStoryPublishDashboardView.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/21.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SCStoryPublishDashboardView.h"
#import "YYHud.h"

@implementation SCStoryPublishDashboardView

- (void)presentView {
    for (UIView *sub in self.subviews) {
        [sub removeFromSuperview];
    }
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = RGB_HEX(0xFFFFFF);
    self.opaque = YES;
#warning 取出最上面的View
    [UIApplication.sharedApplication.keyWindow addSubview: self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImageNormal:@"story_publish_select_close" withImageHighlighted:@"story_publish_select_close"];
    [closeButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).with.offset(-30);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    UIImageView *storyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"story_publish_select_story"]];
    UITapGestureRecognizer *tapStory = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectStory:)];
    storyImageView.userInteractionEnabled = YES;
    [storyImageView addGestureRecognizer:tapStory];
    [self addSubview:storyImageView];
    [storyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).with.offset(-80);
        make.bottom.equalTo(closeButton.mas_top).with.offset(-280);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(110);
    }];
    
    UILabel *storyLabel = [[UILabel alloc] init];
    [storyLabel makeTextStyleWithTitle:@"动态" withColor:RGB_HEX(0x2E2E2E) withFont:[UIFont systemFontOfSize:16] withAlignment:UITextAlignmentCenter];
    [storyLabel makeLayerWithRadius:12 withBorderColor:[UIColor clearColor] withBorderWidth:0];
    storyLabel.backgroundColor = RGB_HEX(0xDCDFDD);
    [self addSubview:storyLabel];
    [storyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(storyImageView);
        make.top.equalTo(storyImageView.mas_bottom).with.offset(20);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(25);
    }];
    
    UIImageView *playImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"story_publish_select_play"]];
    UITapGestureRecognizer *tapPlay = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPlay:)];
    playImageView.userInteractionEnabled = YES;
    [playImageView addGestureRecognizer:tapPlay];
    [self addSubview:playImageView];
    [playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).with.offset(80);
        make.bottom.equalTo(storyImageView.mas_bottom);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(110);
    }];
    
    UILabel *playLabel = [[UILabel alloc] init];
    [playLabel makeTextStyleWithTitle:@"演绎" withColor:RGB_HEX(0x2E2E2E) withFont:[UIFont systemFontOfSize:16] withAlignment:UITextAlignmentCenter];
    [playLabel makeLayerWithRadius:12 withBorderColor:[UIColor clearColor] withBorderWidth:0];
    playLabel.backgroundColor = RGB_HEX(0xDCDFDD);
    [self addSubview:playLabel];
    [playLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(playImageView);
        make.top.equalTo(playImageView.mas_bottom).with.offset(20);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(25);
    }];
}

- (void)selectStory:(UITapGestureRecognizer *)tap {
    
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(storyPublishDashboardSelectStory)]) {
        [self.delegate storyPublishDashboardSelectStory];
    }
}

- (void)selectPlay:(UITapGestureRecognizer *)tap {
#pragma mark --这版本视频先不上
    [YYHud showError:@"暂时未开放"];

//    [self removeFromSuperview];
//    if ([self.delegate respondsToSelector:@selector(storyPublishDashboardSelectPlay)]) {
//        [self.delegate storyPublishDashboardSelectPlay];
//    }
}

- (void)closeTap:(UITapGestureRecognizer *)tap {
    [self removeFromSuperview];
    [self endEditing:YES];
}

- (void)cancelAction:(UIButton *)button {
    [self removeFromSuperview];
    [self endEditing:YES];
}

@end
