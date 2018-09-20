//
//  SCDynamicChainStatusFrame.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/22.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SCDynamicChainStatusFrame.h"
#import "SCDynamicModel.h"

@implementation SCDynamicChainStatusCellFrame
@end

@implementation SCDynamicChainStatusFrame
- (NSMutableArray *)chains {
    if (!_chains) {
        _chains = [NSMutableArray array];
    }
    
    return _chains;
}

- (void)setDynamicModel:(SCDynamicModel *)dynamicModel {
    if (dynamicModel.showChain && dynamicModel.chains.count) {
        self.prompt = CGRectMake(0, 0, App_Frame_Width, 40);
        int count = dynamicModel.chains.count;
        count = count > 3 ? 3 : count;
        CGFloat top = CGRectGetMaxY(self.prompt);
        CGFloat w = CGRectGetWidth(self.prompt);
        for (int i = 0; i < count; i += 1) {
            SCDynamicChainStatusCellFrame *cellFrame = [[SCDynamicChainStatusCellFrame alloc] init];
            cellFrame.frame = CGRectMake(KSCMargin, top + (67 * i), w - 2 * KSCMargin, 67);
            [self.chains addObject:cellFrame];
        }
        
        self.frame = CGRectMake(0, self.topEdge, w, 67 * count + 40);
    } else {
        self.prompt = CGRectZero;
        self.frame = CGRectMake(0, self.topEdge, App_Frame_Width, 0);
    }
}
@end
