//
//  SYWordStyle.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/4.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYWordStyle : NSObject

@property (assign, nonatomic) BOOL bold;

@property (assign, nonatomic) BOOL italic;

@property (assign, nonatomic) BOOL underline;

@property (strong, nonatomic) UIColor *textColor;

@property (strong, nonatomic) UIFont *font;

@property (assign, nonatomic) CGFloat lineHeight;

@property (assign, nonatomic) NSInteger indentLevel;

@property (readonly, nonatomic) NSParagraphStyle *paragraphStyle;

@property (readonly, nonatomic) NSMutableDictionary *topicStyle;

+ (NSMutableDictionary *)topicReadStyleDictionary;

+ (NSMutableDictionary *)topicReadPointedStyleDictionary;

+ (NSMutableDictionary *)topicStyleDictionary;

+ (NSMutableDictionary *)topicPointedStyleDictionary;

+ (NSMutableDictionary *)novelBodyDictionary;

+ (NSMutableDictionary *)novelTitleDictionary;

@end
