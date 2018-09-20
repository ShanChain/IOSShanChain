//
//  SCDynamicModel.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/22.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDynamicModel : NSObject <NSCopying>

@property (assign, nonatomic) BOOL showTextAll;

@property (assign, nonatomic) BOOL showToolBar;

@property (assign, nonatomic) BOOL showFloor;

@property (assign, nonatomic) BOOL showMore;

@property (assign, nonatomic) BOOL showChain;

// 动态ID
@property (copy, nonnull) NSString *detailId;
// 动态的类型
@property (assign, nonatomic) int    type;
//标题
@property (copy, nonatomic) NSString *title;
//角色ID
@property (copy, nonatomic) NSString *characterId;
//昵称
@property (copy, nonatomic) NSString *characterName;
//头像
@property (copy, nonatomic) NSString *characterImg;
//世界ID
@property (copy, nonatomic) NSString *spaceId;
//Feed 创建时间
@property (copy, nonatomic) NSString *createTime;

//话题背景图片
@property (copy, nonatomic) NSString *background;
//楼数
@property (copy, nonatomic) NSString *genNum;
//Feed 简要内容
@property (copy, nonatomic) NSString *intro;
// 内容
@property (copy, nonatomic) NSString *content;
//收藏数
@property (assign, nonatomic) int supportCount;
//信息中富文本内容
@property (copy, nonatomic) NSAttributedString *attributedText;
// 来自
@property (strong, nonatomic) NSDictionary *tail;

// 转发数
@property (assign, nonatomic) int transpond;
// 评论数
@property (assign, nonatomic) int commendCount;

@property (copy, nonatomic) NSString *beFav;

@property (readonly, nonatomic) BOOL isFavorite;
// 转发chain
@property (strong, nonatomic) NSMutableArray *chains;

@end
