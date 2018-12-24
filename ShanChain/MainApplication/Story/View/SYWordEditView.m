//
//  SYWordEditView.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/1.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SYWordEditView.h"
#import "SYWordStyle.h"
#import "UITextView+Placeholder.h"

@interface SYWordEditView() <UITextViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UIView *titleView;

@property (strong, nonatomic) UILabel *placeholderLabel;

@property (strong, nonatomic) UIView *separatorLineView;

@property (assign, nonatomic) CGRect frameCache;

@property (strong, nonatomic) SYWordStyle *currentWordStyle;

@property (strong, nonatomic) NSMutableDictionary *imageDict;

@property (strong, nonatomic) NSMutableDictionary *imageURLDict;

@end

static CGFloat const kMargin = 15;
static CGFloat const kTitleHeight = 44;
static CGFloat const kCommonSpacing = 15;
NSString * const SYImageAttachmentName = @"SYImageAttachmentName";

@implementation SYWordEditView

- (NSMutableDictionary *)imageDict {
    if (!_imageDict) {
        _imageDict = [NSMutableDictionary dictionary];
    }
    return _imageDict;
}

- (NSMutableDictionary *)imageURLDict {
    if (!_imageURLDict) {
        _imageURLDict = [NSMutableDictionary dictionary];
    }
    return _imageURLDict;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        [_placeholderLabel makeTextStyleWithTitle:@"" withColor:RGB_HEX(0xC9C9CB) withFont:[UIFont systemFontOfSize:15] withAlignment:UITextAlignmentLeft];
    }
    
    return _placeholderLabel;
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
    
    _titleTextField = [[UITextField alloc] init];
    _titleTextField.font = [UIFont boldSystemFontOfSize:16];
    _titleTextField.placeholder = @"标题";
    _titleTextField.delegate = self;
    _titleTextField.textColor = RGB(102, 102, 102);
    _titleTextField.tintColor = RGB(179, 179, 179);
    
    _separatorLineView = [[UIView alloc] init];
    _separatorLineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    _titleView = [[UIView alloc] init];
    
    [_titleView addSubview:_titleTextField];
    [_titleView addSubview:_separatorLineView];
    [self addSubview:_titleView];
    
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.spellCheckingType = UITextSpellCheckingTypeNo;
    
    self.selectable = YES;
    
    self.textContainerInset = UIEdgeInsetsMake(kMargin + kTitleHeight + kCommonSpacing, kCommonSpacing, kCommonSpacing, kCommonSpacing);
    
    self.delegate = self;
    
    self.tintColor = RGB(179, 179, 179);
    
    _isTitleEditing = YES;
    
    _currentWordStyle = [[SYWordStyle alloc] init];
    
    [self updateTextStyle];
    
    [self addSubview:self.placeholderLabel];
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(2 * kMargin + kTitleHeight);
        make.right.mas_equalTo(-kMargin);
        make.height.mas_equalTo(21);
    }];
}

- (void)setPlaceholder:(NSString *)text {
    
    self.placeholderLabel.text = text;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!CGRectEqualToRect(_frameCache, self.frame)) {
        CGRect rect = CGRectInset(self.bounds, kMargin, kMargin);
        rect.origin.y = kMargin;
        rect.size.height = kTitleHeight;
        _titleView.frame = rect;
        
        rect.origin = CGPointMake(5, 0);
        rect.size.height = kTitleHeight - kCommonSpacing;
        _titleTextField.frame = rect;
        
        rect.origin.y = CGRectGetHeight(_titleView.bounds) - 1;
        rect.size.height = 1.f;
        _separatorLineView.frame = rect;
        _frameCache = self.frame;
    }
}
#pragma mark ----------------------------- textView delegate ------------------------
- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = self.text.length > 0;
    self.placeholderLabel.text = self.text.length == 0 ? NSLocalizedString(@"sc_Enter_", nil):@"";
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.isTitleEditing = NO;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.isTitleEditing = YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (self.maxWordNum && (textView.text.length + text.length > self.maxWordNum)) {
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return textField.text.length + string.length <= 25;
}

- (void)becomeResponder {
    if (self.isTitleEditing) {
        [self.titleTextField becomeFirstResponder];
    } else {
        [self becomeFirstResponder];
    }
}

#pragma mark ----------------------------- insert image -----------------------------
- (void)insertImage:(UIImage *)image {
    NSString *imageKey = [self genUUID];
    NSRange range = self.selectedRange;
    NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
    imageAttachment.image = image;
    CGFloat w = CGRectGetWidth(self.frame) - (self.textContainerInset.left + self.textContainerInset.right + 12.f);
    imageAttachment.bounds = CGRectMake(0, 0, w, (image.size.height / image.size.width) * w);
    
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
    [attributedString insertAttributedString:[[NSAttributedString alloc] initWithString:@"\n"] atIndex:1];    // 图片前后都插入换行符
    if (range.location != 0 && ![[self.text substringWithRange:NSMakeRange(range.location - 1, 1)] isEqualToString:@"\n"]) {
        // 上一个字符不为"\n"则图片前添加一个换行 且 不是第一个位置
        [attributedString insertAttributedString:[[NSAttributedString alloc] initWithString:@"\n"] atIndex:0];
    }
    NSMutableDictionary *ty = [self.typingAttributes mutableCopy];
    ty[SYImageAttachmentName] = imageKey;
    [attributedString addAttributes:ty range:NSMakeRange(0, attributedString.length)];

    [attributedString addAttribute:NSParagraphStyleAttributeName value:self.currentWordStyle.paragraphStyle range:NSMakeRange(0, attributedString.length)];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributedText replaceCharactersInRange:range withAttributedString:attributedString];
    self.allowsEditingTextAttributes = YES;
    self.attributedText = attributedText;
    self.allowsEditingTextAttributes = NO;
    
    [self.imageDict setObject:image forKey: imageKey];
    
    self.selectedRange = NSMakeRange(range.location + 3, 0);
}
// title 放在第一个位置
- (NSMutableArray *)generateContentBodyWithImageURLArray:(NSDictionary *)imageDictionary forLocalPreview:(BOOL)preview {
    [self.imageURLDict setValuesForKeysWithDictionary:imageDictionary];
    NSMutableArray *rangeArray = [[NSMutableArray alloc] init];
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        if (attrs[@"NSAttachment"]) {
            [rangeArray addObject:@{
                                    @"start": [NSNumber numberWithLong:range.location],
                                    @"length": [NSNumber numberWithUnsignedInteger:range.length],
                                    SYImageAttachmentName: attrs[SYImageAttachmentName]
                                    }];
        }
    }];
    
    if (!preview && self.imageURLDict.allKeys.count != rangeArray.count) {
        [SYProgressHUD showError:@"还有图片没有上传哦"];
        return nil;
    }
    
    NSMutableArray *bodyContent = [NSMutableArray array];
    int index = 0;
    [bodyContent addObject:@{
                             @"img":@"false",
                             @"index":[NSNumber numberWithInt:index],
                             @"text":self.titleTextField.text ? self.titleTextField.text : @""
                             }];
    index += 1;
    if (!rangeArray.count) {
        [bodyContent addObject:@{
                                 @"img":@"false",
                                 @"index":[NSNumber numberWithInt:index],
                                 @"text":self.text
                                 }];
    } else {
        NSMutableDictionary *lastRange = [NSMutableDictionary dictionary];
        [lastRange setValue:[NSNumber numberWithInteger:0] forKey:@"start"];
        [lastRange setValue:[NSNumber numberWithInteger:0] forKey:@"length"];
        for (NSMutableDictionary *range in rangeArray) {
            if (range[@"start"]) {
                int start = [lastRange[@"start"] intValue] + [lastRange[@"length"] intValue];
                int end = [range[@"start"] intValue];
                NSAttributedString *attributedString = [self.attributedText attributedSubstringFromRange:NSMakeRange(start, end - start)];
                if (![attributedString.string isEqualToString:@"\n"]) {
                    [bodyContent addObject:@{
                                             @"img":@"false",
                                             @"index":[NSNumber numberWithInt:index],
                                             @"text":attributedString.string
                                             }];
                }
                lastRange = range;
                index += 1;
                if (range[SYImageAttachmentName] && self.imageURLDict[range[SYImageAttachmentName]]) {
                    [bodyContent addObject:@{
                                             @"img":@"true",
                                             @"index":[NSNumber numberWithInt:index],
                                             @"imgPath": self.imageURLDict[range[SYImageAttachmentName]]
                                             }];
                    // for preview
                } else if (preview) {
                    [bodyContent addObject:@{
                                             @"img":@"true",
                                             @"index":[NSNumber numberWithInt:index],
                                             @"imgPath": @"Local Preview Image"
                                             }];
                } else {
                    SCLog(@"get image upload url error:\n %@", range);
                }

                index += 1;
            }
        }
        
        int start = [lastRange[@"start"] intValue] + [lastRange[@"length"] intValue];
        NSAttributedString *attributedString = [self.attributedText attributedSubstringFromRange:NSMakeRange(start, self.attributedText.length - start)];
        
        if ([attributedString.string isNotBlank] && ![attributedString.string isEqualToString:@"\n"]) {
            [bodyContent addObject:@{
                                     @"img":@"false",
                                     @"index":[NSNumber numberWithInt:index],
                                     @"text": attributedString.string
                                     }];
        }
    }
    return bodyContent;
}

- (NSMutableDictionary *)getImageDictionary {
    NSMutableDictionary *imageDictionary = [NSMutableDictionary dictionary];
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        if (attrs[@"NSAttachment"]) {
            NSTextAttachment *attachment = attrs[@"NSAttachment"];
            NSString *imageKey = attrs[SYImageAttachmentName];
            if (imageKey && !self.imageURLDict[imageKey]) {
                [imageDictionary setObject:self.imageDict[imageKey] forKey:imageKey];
            }
        }
    }];
    return imageDictionary;
}

- (NSMutableArray *)getImageArray {
    NSMutableArray *imageArray = [NSMutableArray array];
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        if (attrs[@"NSAttachment"]) {
            NSTextAttachment *attachment = attrs[@"NSAttachment"];
            NSString *imageKey = attrs[SYImageAttachmentName];
            if (imageKey) {
                [imageArray addObject:self.imageDict[imageKey]];
            }
        }
    }];
    return imageArray;
}

- (NSString *)generateIntroduction {
    NSMutableArray *contentArray = [[NSMutableArray alloc] init];
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        if (!attrs[@"NSAttachment"]) {
            NSAttributedString *attributedString = [self.attributedText attributedSubstringFromRange:range];
            if (![attributedString.string isEqualToString:@"\n"]) {
                [contentArray addObject:attributedString.string];
            }
        }
    }];
    
    return [contentArray componentsJoinedByString:@""];
}

- (void)updateTextStyle {
    self.typingAttributes = [SYWordStyle novelBodyDictionary];
}

- (NSString *)genUUID {
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

@end
