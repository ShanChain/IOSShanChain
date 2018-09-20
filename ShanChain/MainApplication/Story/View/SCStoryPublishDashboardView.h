//
//  SCStoryPublishDashboardView.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/21.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCStoryPublishDashboardDelegate <NSObject>
// 选择动态
- (void)storyPublishDashboardSelectStory;
// 选择演绎
- (void)storyPublishDashboardSelectPlay;
// 选择小说
- (void)storyPublishDashboardSelectNovel;

@end

@interface SCStoryPublishDashboardView : UIView

@property (strong, nonatomic) id<SCStoryPublishDashboardDelegate> delegate;

- (void)presentView;

@end
