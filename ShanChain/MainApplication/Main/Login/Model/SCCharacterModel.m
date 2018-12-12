//
//  SCCharacterModel.m
//  ShanChain
//
//  Created by 千千世界 on 2018/11/9.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "SCCharacterModel.h"

@implementation SCCharacterModel

//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    // value should be Class or Class name.
//    return @{@"shadows" : [Shadow class],
//             @"borders" : Border.class,
//             @"attachments" : @"Attachment" };
//}

@end


@implementation SCCharacterModel_hxAccount

@end


@implementation SCCharacterModel_characterInfo

-(NSString *)headImg{
    if (!_headImg) {
        return DefaultAvatar;
    }
    return _headImg;
}

@end
