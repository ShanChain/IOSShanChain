//
//  SCScreenCell.h
//  ShanChain
//
//  Created by krew on 2017/11/1.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SCScreenCell : UITableViewCell


@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *content;

/*
 *  时间显示字体
 */
@property (nonatomic) UIFont *titleLabelFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:12]

/*
 *  时间显示颜色
 */
@property (nonatomic) UIColor *titleLabelColor UI_APPEARANCE_SELECTOR; //default [UIColor grayColor]

+ (NSString *)cellIdentifier;

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model;


@end
