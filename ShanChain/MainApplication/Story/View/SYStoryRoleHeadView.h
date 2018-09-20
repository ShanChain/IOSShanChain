//
//  SYStoryRoleHeadView.h
//  ShanChain
//
//  Created by krew on 2017/8/28.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  SYStoryRoleHeadViewDelegate<NSObject>

- (void) storyRoleHeadCollectionBtnClicked;

@end

@interface SYStoryRoleHeadView : UIView
@property(nonatomic,strong)id<SYStoryRoleHeadViewDelegate> delegate;

@property (nonatomic, copy) NSString    *name;
@property(nonatomic,  copy) NSString    *intro;
@property(nonatomic,strong)NSDictionary *bgPic;
@property(nonatomic,strong)NSString     *slogan;


@end
