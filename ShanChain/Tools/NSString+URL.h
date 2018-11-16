//
//  NSString+URL.h
//  ShanChain
//
//  Created by krew on 2017/7/12.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

- (NSString *)URLEncodedString;
- (NSMutableDictionary *)getURLParameters;

@end
