//
//  SYWordStyle.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/4./Users/shanrongqukuailian/Documents/IOSShanChain/ShanChain/MainApplication/Story/Controller/SYStoryRecommendController.m
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SYWordStyle.h"

@implementation SYWordStyle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultSetting];
    }
    return self;
}

- (void)defaultSetting {
    _font = [UIFont systemFontOfSize:14];
    _lineHeight = 20.0f;
    _textColor = RGB_HEX(0xB3B3B3);
    _indentLevel = 0;
}

- (NSParagraphStyle *)paragraphStyle {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    paragraphStyle.headIndent = 20.0f * self.indentLevel;
    paragraphStyle.firstLineHeadIndent = 20.0f * self.indentLevel;
//    paragraphStyle.paragraphSpacingBefore = 8.f;
//    paragraphStyle.paragraphSpacing = 8.f;
    paragraphStyle.lineSpacing = 2.0f;
    paragraphStyle.minimumLineHeight = _lineHeight;
    return paragraphStyle;
}

+ (NSMutableDictionary *)topicReadStyleDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    dictionary[NSForegroundColorAttributeName] = RGB(102, 102, 102);
    dictionary[NSUnderlineStyleAttributeName] = NSUnderlineStyleNone;
    return dictionary;
}

+ (NSMutableDictionary *)topicReadPointedStyleDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    dictionary[NSForegroundColorAttributeName] = RGB(28, 179, 193);
    dictionary[NSUnderlineStyleAttributeName] = NSUnderlineStyleNone;
    return dictionary;
}

+ (NSMutableDictionary *)topicStyleDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    dictionary[NSForegroundColorAttributeName] = RGB(102, 102, 102);
    dictionary[NSUnderlineStyleAttributeName] = NSUnderlineStyleNone;
    return dictionary;
}

+ (NSMutableDictionary *)topicPointedStyleDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    dictionary[NSForegroundColorAttributeName] = RGB(28, 179, 193);
    dictionary[NSUnderlineStyleAttributeName] = NSUnderlineStyleNone;
    return dictionary;
}

+ (NSMutableDictionary *)novelBodyDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    dictionary[NSForegroundColorAttributeName] = RGB(102, 102, 102);
    dictionary[NSUnderlineStyleAttributeName] = NSUnderlineStyleNone;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    paragraphStyle.lineSpacing = 2.0f;
    paragraphStyle.minimumLineHeight = 20.0f;
    dictionary[NSParagraphStyleAttributeName] = paragraphStyle;
    return dictionary;
}

+ (NSMutableDictionary *)novelTitleDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    dictionary[NSForegroundColorAttributeName] = RGB(102, 102, 102);
    dictionary[NSUnderlineStyleAttributeName] = NSUnderlineStyleNone;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    paragraphStyle.lineSpacing = 4.0f;
    paragraphStyle.minimumLineHeight = 20.0f;
    dictionary[NSParagraphStyleAttributeName] = paragraphStyle;
    return dictionary;
}

@end
