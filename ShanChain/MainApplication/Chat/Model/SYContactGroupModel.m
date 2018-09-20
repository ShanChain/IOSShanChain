//
//  SYContactGroupModel.m
//  ShanChain
//
//  Created by krew on 2017/10/19.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYContactGroupModel.h"
#import "SYContactModel.h"

@implementation SYContactGroupModel

- (NSMutableArray *)list{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

-(id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"list"]) {
        for(NSDictionary *dic in value){
            SYContactModel *contact = [[SYContactModel alloc]init];
            [contact setValuesForKeysWithDictionary:dic];
            [self.list addObject:contact];
        }
    }else
    {
        [super setValue:value forKey:key];
    }
}


@end
