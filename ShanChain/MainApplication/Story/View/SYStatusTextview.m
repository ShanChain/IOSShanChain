//
//  SYStatusTextview.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/13.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SYStatusTextview.h"
#import "SYWordStyle.h"

static const NSString *SYWordStylePointedIdentity = @"SYWordStylePointedIdentity";
@interface SYStatusTextview()<UITextViewDelegate>

@property (strong, nonatomic) SYWordStyle *currentStyle;

@property (copy, nonatomic) NSMutableDictionary *pointedDictionary;

@end

@implementation SYStatusTextview

- (NSMutableDictionary *)pointedDictionary {
    if (!_pointedDictionary) {
        _pointedDictionary = [NSMutableDictionary dictionary];
    }
    
    return _pointedDictionary;
}

- (void)fillContentText:(NSString *)text {
    if ([text rangeOfString:@"content"].location !=NSNotFound) {
        NSDictionary *contentDictionary = [JsonTool dictionaryFromString:text];
        NSString *text = contentDictionary[@"content"];
        NSArray *pointedArray = contentDictionary[@"spanBeanList"];
        if ([pointedArray isKindOfClass:[NSString class]]) {
            self.attributedText = [self formateKeyWordWithString:text withKeyWordArray:[JsonTool dictionaryFromString:contentDictionary[@"spanBeanList"]]];
        } else {
            self.attributedText = [self formateKeyWordWithString:text withKeyWordArray:pointedArray];
        }
    } else {
        self.attributedText = [self formateKeyWordWithString:text withKeyWordArray:@[]];
    }
}

- (SYWordStyle *)currentStyle {
    if(!_currentStyle) {
        _currentStyle = [[SYWordStyle alloc] init];
    }
    
    return _currentStyle;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.alwaysBounceVertical = NO;
    self.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.showsVerticalScrollIndicator = NO;
    self.selectable = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.scrollEnabled = NO;
    self.editable = NO;
    self.delegate = self;
    
    self.linkTextAttributes = [SYWordStyle topicReadPointedStyleDictionary];
}

- (NSAttributedString *)formateKeyWordWithString:(NSString *)text withKeyWordArray:(NSArray *)keywordArray {
    NSMutableAttributedString *attrbuteString = [[NSMutableAttributedString alloc] initWithString:text];
    [attrbuteString addAttributes:[SYWordStyle topicReadStyleDictionary] range:NSMakeRange(0, text.length)];
    for (NSDictionary *pointed in keywordArray) {
        NSNumber *type = pointed[@"type"];
        NSString *key = type.intValue == 1 ? [@"@" stringByAppendingString:pointed[@"str"]] : [[@"#" stringByAppendingString:pointed[@"str"]] stringByAppendingString:@"#"];
        int start = 0;
        NSRange range = NSMakeRange(0, 0);
        while (true) {
            range = [text rangeOfString:key options:NSCaseInsensitiveSearch range:NSMakeRange(start, text.length - start)];
            if (range.location != NSNotFound) {
                NSString *uuid = [Util uuid];
                [attrbuteString addAttribute:NSLinkAttributeName value:[NSURL URLWithString:[@"shanchain://" stringByAppendingString:uuid]] range:range];
                [self.pointedDictionary setObject:pointed forKey:uuid];
            } else {
                break;
            }
            start = range.location + range.length;
            
        }
    }
    return attrbuteString;
}

- (void)insertPointedTextWithText:(NSString *)text atIndex:(int)index {
    NSAttributedString *lead = [[NSAttributedString alloc] initWithString:text attributes:[SYWordStyle topicReadPointedStyleDictionary]];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributedText insertAttributedString:lead atIndex:index];
    self.attributedText = attributedText;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    NSString *url = URL.absoluteString;
    NSRange range = [url rangeOfString:@"shanchain://"];
    if (range.location != NSNotFound) {
        NSDictionary *contentDic = self.pointedDictionary[[url substringFromIndex:(range.location + range.length)]];
        NSNumber *type = contentDic[@"type"];
        if (type.intValue == 1) {
            // 点击人物
            [NSNotificationCenter.defaultCenter postNotificationName:SYStatusTextviewNotificationTappedRoleName object:nil userInfo:contentDic];
        } else {
            // 点击话题
            [NSNotificationCenter.defaultCenter postNotificationName:SYStatusTextviewNotificationTappedTopicName object:nil userInfo:contentDic];
        }

    }
    return NO;
}


@end
