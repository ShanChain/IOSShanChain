//
//  SCDynamicDetailStatusFrame.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/22.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCDynamicModel;
@interface SCDynamicDetailStatusFrame : NSObject
// 1.昵称
@property (assign, nonatomic) CGRect name;
// 标题
@property (assign, nonatomic) CGRect title;
// 2.正文
@property (assign, nonatomic) CGRect content;
// 3.头像
@property (assign, nonatomic) CGRect icon;
// 4.会员图标
@property (assign, nonatomic) CGRect vip;
//4.1 楼数
@property (assign, nonatomic) CGFloat floor;
// 来自
@property (assign, nonatomic) CGRect from;
// 5.更多图标
@property (assign, nonatomic) CGRect more;
// 6.自己的frame
@property (assign, nonatomic) CGRect frame;
// 7.配图的frame
@property (assign, nonatomic) CGRect photos;

- (void)setDynamicModel:(SCDynamicModel *)dynamicModel;

@end
