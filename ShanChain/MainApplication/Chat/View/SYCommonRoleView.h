//
//  SYCommonRoleView.h
//  ShanChain
//
//  Created by krew on 2017/9/22.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYCommonRoleView;
@protocol SYCommonRoleViewDelegate <NSObject>

- (void)SYCommonRoleViewDidClicked;

@end

@interface SYCommonRoleView : UIView

@property(nonatomic,strong)id<SYCommonRoleViewDelegate> delegate;

- (void) updateDataArray:(NSArray *)array;
@end

