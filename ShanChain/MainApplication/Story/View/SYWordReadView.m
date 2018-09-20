//
//  SYWordReadVIew.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/8.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SYWordReadVIew.h"
#import "SYWordStyle.h"
@interface SYWordReadView()

@property (strong, nonatomic) NSMutableDictionary *imageDictionary;
@property (strong, nonatomic) SYWordStyle *currentStyle;

@property (strong, atomic) NSLock *lock;
@end

@implementation SYWordReadView

- (NSLock *)lock {
    if (!_lock) {
        _lock = [NSLock new];
    }
    return _lock;
}
- (NSMutableDictionary *)imageDictionary {
    if (!_imageDictionary) {
        _imageDictionary = [NSMutableDictionary dictionary];
    }
    
    return _imageDictionary;
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
    self.editable = false;
    self.alwaysBounceVertical = YES;
    self.textContainerInset = UIEdgeInsetsMake(KSCMargin, KSCMargin, KSCMargin, KSCMargin);
    self.selectable = false;
}

- (void)fillNovelTitle:(NSString *)titleText {
    NSString *title = [titleText stringByAppendingString: @"\n"];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:title];
    [attributedText addAttributes:[SYWordStyle novelTitleDictionary] range:NSMakeRange(0, title.length)];
    self.attributedText = attributedText;
}

- (void)fillContentWithJsonArray:(NSArray *)jsonArray withImageArray:(NSArray *)imageArray {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    
    int i = 0;
    for (int index=0; index < jsonArray.count; index += 1) {
        NSDictionary *contentDic = jsonArray[index];
        if (index == 0 && contentDic[@"text"]) {
            [self fillNovelTitle:contentDic[@"text"]];
            attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        } else {
            NSString *imgPath = contentDic[@"imgPath"];
            WS(WeakSelf);
            if (imgPath && [imgPath isNotBlank]) {
                NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
                UIImage *image = imageArray[i];
                imageAttachment.image = image;
                CGFloat w = CGRectGetWidth(self.frame) - (self.textContainerInset.left + self.textContainerInset.right + 12.f);
                imageAttachment.bounds = CGRectMake(0, 0, w, (image.size.height / image.size.width) * w);
                NSMutableAttributedString *imageAttributedString = [NSMutableAttributedString attributedStringWithAttachment:imageAttachment];
                [imageAttributedString insertAttributedString:[[NSAttributedString alloc] initWithString:@"\n"] atIndex:1];
                [imageAttributedString addAttributes:self.typingAttributes range:NSMakeRange(0, imageAttributedString.length)];
                [imageAttributedString addAttribute:NSParagraphStyleAttributeName value:self.currentStyle.paragraphStyle range:NSMakeRange(0, imageAttributedString.length)];
                [attributedString insertAttributedString:imageAttributedString atIndex:attributedString.length];
                i += 1;
            } else {
                NSString *textStr = contentDic[@"text"];
                if (textStr && [textStr isNotBlank]) {
                    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:textStr];
                    [text addAttributes:[SYWordStyle novelBodyDictionary] range:NSMakeRange(0, text.length)];
                    [attributedString insertAttributedString:text atIndex:attributedString.length];
                }
            }
        }
    }
    
    self.allowsEditingTextAttributes = YES;
    self.attributedText = attributedString;
    self.allowsEditingTextAttributes = false;
}

- (void)fillContentWithJsonArray:(NSArray *)jsonArray {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];

    NSMutableArray *imageContentArray = [NSMutableArray array];
    for (int index=0; index < jsonArray.count; index += 1) {
        NSDictionary *contentDic = jsonArray[index];
        if (index == 0 && contentDic[@"text"]) {
            [self fillNovelTitle:contentDic[@"text"]];
            attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        } else {
            NSString *imgPath = contentDic[@"imgPath"];
            if (imgPath && [imgPath isNotBlank]) {
                NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
                UIImage *image = [UIImage imageWithName:@"abs_addanewrole_def_photo_default"];
                imageAttachment.image = image;
                CGFloat w = CGRectGetWidth(self.frame) - (self.textContainerInset.left + self.textContainerInset.right + 12.f);
                imageAttachment.bounds = CGRectMake(0, 0, w, (image.size.height / image.size.width) * w);
                [imageContentArray addObject:@{
                                               @"location":[NSNumber numberWithInteger:attributedString.length],
                                               @"imagePath":imgPath
                                               }];
                NSMutableAttributedString *imageAttributedString = [NSMutableAttributedString attributedStringWithAttachment:imageAttachment];
                [imageAttributedString insertAttributedString:[[NSAttributedString alloc] initWithString:@"\n"] atIndex:1];
                [attributedString insertAttributedString:imageAttributedString atIndex:attributedString.length];
            } else {
                NSString *textStr = contentDic[@"text"];
                if (textStr && [textStr isNotBlank]) {
                    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:textStr];
                    [text addAttributes:[SYWordStyle novelBodyDictionary] range:NSMakeRange(0, text.length)];
                    [attributedString insertAttributedString:text atIndex:attributedString.length];
                }
            }
        }
    }
    
    self.attributedText = attributedString;
    WS(WeakSelf);
    for (NSMutableDictionary *dict in imageContentArray) {
        UIImageView *imageView = [[UIImageView alloc] init];
        NSInteger loc = [dict[@"location"] integerValue];
        [self.imageDictionary setObject:imageView forKey:dict[@"imagePath"]];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"imagePath"]] completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
            [WeakSelf imageLoadedAction:NSMakeRange(loc, 2) withImage:image withPath:dict[@"imagePath"]];
        }];
    }
}

- (void)imageLoadedAction:(NSRange)range withImage:(UIImage *)image withPath:(NSString *)path {
    [self.lock lock];
    [self.imageDictionary removeObjectForKey:path];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
    imageAttachment.image = image;
    CGFloat w = CGRectGetWidth(self.frame) - (self.textContainerInset.left + self.textContainerInset.right + 12.f);
    imageAttachment.bounds = CGRectMake(0, 0, w, (image.size.height / image.size.width) * w);
    NSMutableAttributedString *imageAttributedString = [NSMutableAttributedString attributedStringWithAttachment:imageAttachment];
    [imageAttributedString insertAttributedString:[[NSAttributedString alloc] initWithString:@"\n"] atIndex:1];
    [imageAttributedString addAttributes:self.typingAttributes range:NSMakeRange(0, imageAttributedString.length)];
    [imageAttributedString addAttribute:NSParagraphStyleAttributeName value:self.currentStyle.paragraphStyle range:NSMakeRange(0, imageAttributedString.length)];
    if (range.location < attributedString.length) {
        [attributedString replaceCharactersInRange:range withAttributedString:imageAttributedString];
    }

    self.attributedText = attributedString;
    [self.lock unlock];
}

@end
