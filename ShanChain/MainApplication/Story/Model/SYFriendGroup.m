//
//  SYFriendGroup.m
//  ShanChain
//
//  Created by krew on 2017/10/14.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYFriendGroup.h"
#import "SYFriend.h"

@implementation SYFriendGroup

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
            SYFriend *friend = [[SYFriend alloc]init];
            [friend setValuesForKeysWithDictionary:dic];
            [self.list addObject:friend];
        }
    } else {
        [super setValue:value forKey:key];
    }
}

@end
