//
//  SCDynamicChainStatusFrame.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/22.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCDynamicModel;

@interface SCDynamicChainStatusFrame : NSObject

// 剩余楼层哪个label的frame
@property (assign, nonatomic) CGRect prompt;

// 楼层cell 的frame数组
@property (strong, nonatomic) NSMutableArray *chains;

@property (assign, nonatomic) CGRect frame;

@property (assign, nonatomic) CGFloat topEdge;

- (void)setDynamicModel:(SCDynamicModel *)dynamicModel;

@end

@interface SCDynamicChainStatusCellFrame : NSObject

@property (assign, nonatomic) CGRect frame;

@end
