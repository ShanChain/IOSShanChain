#import "SYTextView.h"
#import "SYWordStyle.h"
#import "SCCacheTool.h"

static const NSString *SYWordStylePointedName = @"SYWordStylePointedName";
static const NSString *SYWordStylePointedType = @"SYWordStylePointedType";
static const NSString *SYWordStylePointedIdentity = @"SYWordStylePointedIdentity";

@interface SYTextView()<UITextViewDelegate>

@property (weak, nonatomic) UILabel *placeholderLabel;

@property (strong, nonatomic) NSMutableDictionary *pointedDictionary;

@property (assign, nonatomic) BOOL ignoreSelectedRange;

@property (assign, nonatomic) NSRange lastSelectedRange;

@end

@implementation SYTextView

- (NSMutableDictionary *)pointedDictionary {
    if (!_pointedDictionary) {
        _pointedDictionary = [NSMutableDictionary dictionary];
    }
    return _pointedDictionary;
}

- (NSArray *)generateIntroduction {
    NSMutableArray *contentArray = [NSMutableArray array];
    for (NSDictionary *dict in self.pointedDictionary.allValues) {
        [contentArray addObject:dict];
    }
    return contentArray;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // 添加一个显示提醒文字的label（显示占位文字的label）
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:placeholderLabel];
        self.placeholderLabel = placeholderLabel;
        
        // 设置默认的占位文字颜色
        self.placeholderColor = [UIColor lightGrayColor];
        
        // 设置默认的字体
        self.font = [UIFont systemFontOfSize:14];
        
        self.delegate = self;
        
        self.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
        
        // 监听内部文字改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        
        //为该textView增加一个手势事件
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewOnClick)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)textViewOnClick {
    [self becomeFirstResponder];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听文字改变
- (void)textDidChange {
    self.placeholderLabel.hidden = self.hasText;;
}

#pragma mark - 公共方法
- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
    [self textDidChange];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    
    // 设置文字
    self.placeholderLabel.text = placeholder;
    
    // 重新计算子控件的fame
    [self setNeedsLayout];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    
    // 设置颜色
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    self.placeholderLabel.font = font;
    
    // 重新计算子控件的fame
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.placeholderLabel.y = 15;
    self.placeholderLabel.x = 19;
    self.placeholderLabel.width = self.width - 2 * self.placeholderLabel.x;
    // 根据文字计算label的高度
    CGSize maxSize = CGSizeMake(self.placeholderLabel.width, MAXFLOAT);
    CGSize placeholderSize = [self.placeholder sizeWithFont:self.placeholderLabel.font maxSize:maxSize];
    self.placeholderLabel.height = placeholderSize.height;
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    NSRange selectedRange = textView.selectedRange;
    int location = selectedRange.location;
    int endLocation = selectedRange.location + selectedRange.length;
    
    int maxLength = self.attributedText.length;
    if (location == maxLength || self.ignoreSelectedRange) {
        self.ignoreSelectedRange = NO;
        self.lastSelectedRange = textView.selectedRange;
        return;
    }
    
    // 只是光标移动 没有选择一段文字时。只需要改变光标的位置就行
    NSDictionary *attributed = [textView.attributedText attributesAtIndex:location effectiveRange:nil];
    if (attributed[SYWordStylePointedName]) {
        NSString *uuid = attributed[SYWordStylePointedIdentity];
        NSNumber *length = attributed[SYWordStylePointedName];
        int subLength = selectedRange.length > length.intValue ? selectedRange.length : length.intValue;
        if (location + subLength > maxLength) {
            subLength = maxLength - location;
        }
        int lengthCount = 0;
        NSAttributedString *attributedString = [textView.attributedText attributedSubstringFromRange:NSMakeRange(location, subLength)];
        for (int i = 0; i < subLength; i+= 1) {
            NSString *u = [attributedString attribute:SYWordStylePointedIdentity atIndex:i effectiveRange:nil];
            if (u && [u isEqualToString:uuid]) {
                lengthCount = i + 1;
            } else {
                break;
            }
        }
        if (selectedRange.length) {
            location += _lastSelectedRange.location < location ? lengthCount : lengthCount - length.intValue;
        } else {
            location += lengthCount > length.intValue / 2 ? lengthCount - length.intValue : lengthCount;
        }
    }
    
    if (selectedRange.length) {
        NSDictionary *attributed2 = [textView.attributedText attributesAtIndex:endLocation - 1 effectiveRange:nil];
        if (attributed2[SYWordStylePointedName]) {
            NSString *uuid = attributed2[SYWordStylePointedIdentity];
            NSNumber *length = attributed2[SYWordStylePointedName];
            int lengthCount = 0;
            NSAttributedString *attributedString = [textView.attributedText attributedSubstringFromRange:selectedRange];
            for (int i=selectedRange.length - 1; i > 0; i -= 1) {
                NSString *u = [attributedString attribute:SYWordStylePointedIdentity atIndex:i effectiveRange:nil];
                if (u && [u isEqualToString:uuid]) {
                    lengthCount = selectedRange.length - i;
                } else {
                    break;
                }
            }
            
            endLocation += _lastSelectedRange.location + _lastSelectedRange.length < endLocation ? lengthCount - length.intValue : -lengthCount;
        }
    } else {
        endLocation = location + selectedRange.length;
    }
    
    self.ignoreSelectedRange = !(self.selectedRange.location == location && self.selectedRange.length == selectedRange.length);
    self.lastSelectedRange = textView.selectedRange;
    self.selectedRange = NSMakeRange(location, endLocation - location);
//    SCLog(@"range change location: %d length: %d", selectedRange.location, selectedRange.length);
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    textView.typingAttributes = [SYWordStyle topicStyleDictionary];
    if (!text.length && range.length == 1) {
        NSAttributedString *attributedString = [textView.attributedText attributedSubstringFromRange:range];
        NSDictionary *attributed = [attributedString attributesAtIndex:0 effectiveRange:nil];
        if (attributed[SYWordStylePointedName]) {
            NSNumber *length = attributed[SYWordStylePointedName];
            if (length > 1) {
                NSRange selectedRange = textView.selectedRange;
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
                int location = range.location - length.integerValue + range.length;
                [attributedText deleteCharactersInRange:NSMakeRange(location, length.integerValue)];
                textView.attributedText = attributedText;
                [self.pointedDictionary removeObjectForKey:attributed[SYWordStylePointedIdentity]];
                textView.selectedRange = NSMakeRange(location, 0);
                return NO;
            }
        }
    }
    
    if (self.maxWordNum && (textView.text.length + text.length > self.maxWordNum)) {
        return NO;
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    return NO;
}

- (void)insertTopic:(NSString *)name withTopicId:(NSString *)topicId {
    NSString *uuid = [Util uuid];
    NSRange range = self.selectedRange;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:name attributes:[SYWordStyle topicPointedStyleDictionary]];
    [attributedString addAttribute:SYWordStylePointedName value:[NSNumber numberWithUnsignedInteger:name.length] range:NSMakeRange(0, name.length)];
    [attributedString addAttribute:SYWordStylePointedType value:[NSNumber numberWithUnsignedInteger:2] range:NSMakeRange(0, name.length)];
    [attributedString addAttribute:SYWordStylePointedIdentity value:uuid range:NSMakeRange(0, name.length)];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributedText replaceCharactersInRange:range withAttributedString:attributedString];
    self.allowsEditingTextAttributes = YES;
    self.attributedText = attributedText;
    self.allowsEditingTextAttributes = NO;
    
    [self.pointedDictionary setObject:@{
                                        @"beanId": topicId,
                                        @"spaceId": [SCCacheTool.shareInstance getCurrentSpaceId],
                                        @"str": name,
                                        @"type": [NSNumber numberWithInteger:2]
                                        } forKey:uuid];
    self.typingAttributes = [SYWordStyle topicStyleDictionary];
}

- (void)insertMention:(NSString *)name withCharacterId:(NSString *)characterId {
    NSString *uuid = [Util uuid];
    NSRange range = self.selectedRange;
    NSString *content = [@"@" stringByAppendingString: name];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content attributes:[SYWordStyle topicPointedStyleDictionary]];
    [attributedString addAttribute:SYWordStylePointedName value:[NSNumber numberWithUnsignedInteger:content.length] range:NSMakeRange(0, content.length)];
    [attributedString addAttribute:SYWordStylePointedType value:[NSNumber numberWithUnsignedInteger:1] range:NSMakeRange(0, content.length)];
    [attributedString addAttribute:SYWordStylePointedIdentity value:uuid range:NSMakeRange(0, content.length)];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributedText replaceCharactersInRange:range withAttributedString:attributedString];
    self.allowsEditingTextAttributes = YES;
    self.attributedText = attributedText;
    self.allowsEditingTextAttributes = NO;
    
    [self.pointedDictionary setObject:@{
                                        @"beanId": characterId,
                                        @"spaceId": [SCCacheTool.shareInstance getCurrentSpaceId],
                                        @"str": name,
                                        @"type": [NSNumber numberWithInteger:1]
                                        } forKey:uuid];
    
    self.typingAttributes = [SYWordStyle topicStyleDictionary];
}

@end
