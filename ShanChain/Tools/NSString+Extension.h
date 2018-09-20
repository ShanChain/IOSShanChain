//

//
//  Created by xc on 15/3/6.
//  Copyright (c) 2015年 xc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (CGSize)sizeWithDictionary:(NSMutableDictionary *)dictionary maxSize:(CGSize)maxSize;

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

- (NSString *)stringByTrim;

- (BOOL)isNotBlank;

+ (BOOL)isBlankString:(NSString *)str;


@end
