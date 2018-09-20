//
//  JsonTool.h
//  ShanChain
//
//  Created by flyye on 2017/10/23.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#ifndef JsonTool_h
#define JsonTool_h

#import <Foundation/Foundation.h>


@interface JsonTool : NSObject

+ (NSString *)stringFromDictionary:(NSDictionary *)dict;

+ (NSString *)stringFromArray:(NSArray *)array;

+ (NSDictionary *)dictionaryFromString:(NSString *)jsonString;

+ (NSArray *)arrayFromString:(NSString *)jsonString;

@end

#endif /* JsonTool_h */
