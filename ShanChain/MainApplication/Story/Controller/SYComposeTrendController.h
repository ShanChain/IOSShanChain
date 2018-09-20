//
//  SYComposeTrendController.h
//  ShanChain
//
//  Created by krew on 2017/8/30.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYComposeTrendController;

@protocol SYComposeTrendControllerDelegate <NSObject>

- (void)composeTrendControllerWithText:(NSString *)string withTopicId:(long)topicId;

@end

@interface SYComposeTrendController : SCBaseViewController

@property(nonatomic,strong)id <SYComposeTrendControllerDelegate> delegate;

@end
