//
//  SYContactsModel.h
//  ShanChain
//
//  Created by krew on 2017/9/11.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYContactsModel : NSObject

/**头像*/
@property (nonatomic,strong) UIImageView  *icon;

/**姓名*/
@property (nonatomic,strong) UILabel      *name;

/**内容*/
@property (nonatomic,strong)UILabel      *content;

//联系人数据
@property (nonatomic, strong)NSMutableArray *items;
//大小(分组中有多少项)
@property (nonatomic, readonly) NSUInteger size;
//是否折叠
@property (nonatomic, assign, getter=isFolded) BOOL folded;

//初始化方法
- (instancetype) initWithItem:(NSMutableArray *)item;


@end
