//
//  SYContactsModel.m
//  ShanChain
//
//  Created by krew on 2017/9/11.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYContactsModel.h"
@implementation SYContactsModel
//初始化方法
- (instancetype) initWithItem:(NSMutableArray *)item{
    if (self = [super init]) {
        self.folded=YES;
        _items = item;
    }
    return self;
}

//每个组内有多少联系人
- (NSUInteger) size {
    return _items.count;
}

//-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    
//}
//
//-(id)valueForUndefinedKey:(NSString *)key{
//    return nil;
//}

@end
