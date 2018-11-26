//
//  NSObject+customProperty.m
//  ShanChain
//
//  Created by 千千世界 on 2018/11/26.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "NSObject+customProperty.h"

@implementation NSObject (customProperty)


-(void)setMark:(NSString *)mark{
    objc_setAssociatedObject(self, @selector(mark), mark, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)mark{
    return objc_getAssociatedObject(self, _cmd);
}

@end
