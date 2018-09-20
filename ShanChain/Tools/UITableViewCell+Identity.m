//
//  UITableViewCell+Identity.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/25.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "UITableViewCell+Identity.h"

@implementation UITableViewCell(Identity)

+ (NSString *)cellDequeueReusableIdentifier {
    return NSStringFromClass(self);
}

@end
