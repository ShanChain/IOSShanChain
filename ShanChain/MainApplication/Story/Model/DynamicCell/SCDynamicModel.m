//
//  SCDynamicModel.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/22.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SCDynamicModel.h"

@implementation SCDynamicModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showMore    = NO;
        self.showFloor   = NO;
        self.showTextAll = NO;
        self.showToolBar = YES;
        self.showChain   = YES;
    }
    return self;
}

- (NSMutableArray *)chains {
    if (!_chains) {
        _chains = [NSMutableArray array];
    }
    
    return _chains;
}

-(NSString *)beFav{
    if (![_beFav isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"%@",_beFav];
    }
    return _beFav;
}

- (BOOL)isFavorite {
    return self.beFav.boolValue;
}

// this copy without chain data
- (id)copyWithZone:(NSZone *)zone {
    SCDynamicModel *model = [self.class allocWithZone:zone];
    model.showTextAll = _showTextAll;
    model.showToolBar = _showToolBar;
    model.showFloor = _showFloor;
    model.showMore = _showMore;
    model.showChain = _showChain;
    model.detailId = [_detailId copy];
    model.background = [_background copy];
    model.type = _type;
    model.title = [_title copy];
    model.characterId = [_characterId copy];
    model.characterName = [_characterName copy];
    model.characterImg = [_characterImg copy];
    model.spaceId = [_spaceId copy];
    model.createTime = [_createTime copy];
    model.genNum = [_genNum copy];
    model.intro = [_intro copy];
    model.content = [_content copy];
    model.supportCount = _supportCount;
    model.tail = [_tail copy];
    model.transpond = _transpond;
    model.commendCount = _commendCount;
    model.beFav = [_beFav copy];
    return model;
}

@end
