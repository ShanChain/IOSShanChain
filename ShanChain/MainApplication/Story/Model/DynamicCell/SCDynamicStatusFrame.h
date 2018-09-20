//
//  SCDynamicStatusFrame.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/22.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCDynamicDetailStatusFrame.h"
#import "SCDynamicChainStatusFrame.h"
#import "SCDynamicModel.h"

@class SCDynamicModel;
@class SCDynamicDetailStatusFrame;
@class SCDynamicChainStatusFrame;

@interface SCDynamicStatusFrame : NSObject

//Feed模型
@property (strong, nonatomic) SCDynamicModel *dynamicModel;
//Feed detail frame
@property (strong, nonatomic) SCDynamicDetailStatusFrame *dynamicDetailFrame;
//转发 frame
@property (strong, nonatomic) SCDynamicChainStatusFrame *dynamicChainFrame;
//工具条frame
@property (assign, nonatomic) CGRect dynamicToolBarFrame;
//cell高度
@property (readonly, nonatomic) CGFloat dynamicCellHeight;
//cell frame
@property (assign, nonatomic) CGRect frame;

@end
