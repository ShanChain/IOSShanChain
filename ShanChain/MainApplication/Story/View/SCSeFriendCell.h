//
//  SCSeFriendCell.h
//  ShanChain
//
//  Created by krew on 2017/5/31.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYFriendGroup.h"
#import "SYFriend.h"

#import "SYContactModel.h"
#import "SYContactGroupModel.h"

@interface SCSeFriendCell : UITableViewCell

+ (CGFloat)cellHeight;

- (void)setString:(NSString *)string row:(NSIndexPath *)indexPath;

@property(nonatomic,strong)SYFriend *fried;

@property(nonatomic,strong)SYContactModel *model;

@end
