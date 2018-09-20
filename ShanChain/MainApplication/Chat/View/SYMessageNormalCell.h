//
//  SYMessageNormalCell.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/14.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMessageModel.h"
@class IMessageModel;

@protocol SYMessageNormalCellDelegate <NSObject>

- (void)messageNormalCellHeadTapWith:(NSIndexPath *)indexPath withModel:(id<IMessageModel>)model;

@end

@interface SYMessageNormalCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withModel:(id<IMessageModel>)model;

@property (strong, nonatomic) id<IMessageModel> model;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (strong, nonatomic) id<SYMessageNormalCellDelegate> delegate;

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model;

@end
