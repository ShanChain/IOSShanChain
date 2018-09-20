//
//  JsonTool.m
//  ShanChain
//
//  Created by flyye on 2017/10/23.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonTool.h"

@implementation JsonTool

+ (NSString *)stringFromDictionary:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData =  [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData) {
        SCLog(@"stringFromDictionary 解析失败 error:%@", error);
        return nil;
    } else {
        NSString * jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSMutableString *mutableString = [NSMutableString stringWithString:jsonString];
        [mutableString replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, mutableString.length)];
        [mutableString replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, mutableString.length)];
        return mutableString;
    }
}

+ (NSString *)stringFromArray:(NSArray *)array {
    NSError *error;
    NSData *jsonData =  [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData) {
        SCLog(@"stringFromDictionary 解析失败 error:%@", error);
        return nil;
    } else {
        NSString * jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSMutableString *mutableString = [NSMutableString stringWithString:jsonString];
        [mutableString replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, mutableString.length)];
        [mutableString replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, mutableString.length)];
        return mutableString;
    }
}

+ (NSDictionary *)dictionaryFromString:(NSString *)jsonString {
    NSError *error;
    NSData *jsonStringData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonStringData) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonStringData options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            SCLog(@"解析失败  原字符串: %@", jsonString);
            return nil;
        }
        return dictionary;
    }
    
    SCLog(@"解析失败  原字符串data is empty: %@", jsonString);
    return nil;
}

+ (NSArray *)arrayFromString:(NSString *)jsonString {
    NSError *error;
    NSData *jsonStringData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonStringData) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonStringData options:NSJSONReadingMutableContainers error:&error];
        if (!error && array != [NSNull null]) {
            return array;
        }
    }
    
    SCLog(@"解析失败  原字符串: %@", jsonString);
    return nil;
}

@end
