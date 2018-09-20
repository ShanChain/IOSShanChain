//
//  SCDynamicStatusFrame.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/22.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SCDynamicStatusFrame.h"

@implementation SCDynamicStatusFrame

- (void)setDynamicModel:(SCDynamicModel *)dynamicModel {
    _dynamicModel = dynamicModel;
    
    [self _calculateDetailFrame];

    [self _calculateToolBarFrame];

    [self _calculateChainFrame];

    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(self.dynamicChainFrame.frame));
}

- (CGFloat)dynamicCellHeight {
    return self.frame.size.height;
}

- (void)_calculateDetailFrame {
    SCDynamicDetailStatusFrame *detail = [[SCDynamicDetailStatusFrame alloc] init];
    [detail setDynamicModel:self.dynamicModel];
    self.dynamicDetailFrame = detail;
}

//计算工具条整体frame
- (void)_calculateToolBarFrame {
    self.dynamicToolBarFrame = CGRectMake(0, CGRectGetMaxY(self.dynamicDetailFrame.frame), CGRectGetWidth(self.dynamicDetailFrame.frame), self.dynamicModel.showToolBar ? DSStatusToolbarHeight : 0);
}

// 计算转发链接的frame
- (void)_calculateChainFrame {
    SCDynamicChainStatusFrame *chain = [[SCDynamicChainStatusFrame alloc] init];
    chain.topEdge = CGRectGetMaxY(self.dynamicToolBarFrame);
    [chain setDynamicModel:self.dynamicModel];
    self.dynamicChainFrame = chain;
}

@end
