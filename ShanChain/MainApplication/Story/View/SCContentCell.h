//
//  SCContentCell.h
//  ShanChain
//
//  Created by krew on 2017/6/1.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYComment.h"

@class SCContentCell;

@protocol SCContentCellDelegate <NSObject>

- (void)contentCellTapButtonSupportWithIndexPath:(NSIndexPath *)indexPath withSupported:(BOOL)isSupported;

@end

@interface SCContentCell : UITableViewCell

+ (CGFloat)cellHeight;

@property (strong, nonatomic) id<SCContentCellDelegate> delegate;

@property (strong, nonatomic) SYComment *comment;

@property (strong, nonatomic) NSIndexPath *indexpath;

@end
