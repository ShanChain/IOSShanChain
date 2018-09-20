//
//  SYComposeToolbar.m
//  ShanChain
//
//  Created by krew on 2017/8/30.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYComposeToolbar.h"

@interface SYComposeToolbar()

@property (strong, nonatomic) UIButton *imageButton;

@property (strong, nonatomic) UIButton *mentionButton;

@property (strong, nonatomic) UIButton *topicButton;

@property (strong, nonatomic) UIButton *previewButton;

@property (strong, nonatomic) UIView *switchView;

@end

@implementation SYComposeToolbar

- (SYComposeToolbarShowType)showType {
    if (!_showType) {
        _showType = SYComposeToolbarShowTypeTopic;
    }
    
    return _showType;
}

#pragma mark ------------- lazy load ---------
- (UIButton *)imageButton {
    if (!_imageButton) {
        _imageButton = [self makeButtonWithNormal:@"abs_release_btn_image_default1" withHighlight:@"abs_release_btn_image_default1" withTag:SYComposeToolbarButtonTypePicture];
        _imageButton.frame = CGRectMake(30, 2, 40, 40);
    }
    
    return _imageButton;
}

- (UIButton *)mentionButton {
    if (!_mentionButton) {
        _mentionButton = [self makeButtonWithNormal:@"abs_release_btn_at_default1" withHighlight:@"abs_release_btn_at_default1" withTag:SYComposeToolbarButtonTypeMention];
        CGFloat buttonW = (200.0 / 3);
        _mentionButton.frame = CGRectMake(buttonW + 30, 2, 40, 40);
    }
    
    return _mentionButton;
}

- (UIButton *)topicButton {
    if (!_topicButton) {
        _topicButton = [self makeButtonWithNormal:@"abs_release_btn_topic_default1" withHighlight:@"abs_release_btn_topic_default1" withTag:SYComposeToolbarButtonTypeTrend];
        CGFloat buttonW = (200.0 / 3);
        _topicButton.frame = CGRectMake(buttonW * 2 + 30, 2, 40, 40);
    }
    
    return _topicButton;
}

- (UIButton *)previewButton {
    if (!_previewButton) {
        _previewButton = [self makeButtonWithNormal:@"abs_release_btn_topic_default1" withHighlight:@"abs_release_btn_topic_default1" withTag:SYComposeToolbarButtonTypePreView];
        CGFloat buttonW = (200.0 / 3);
        _previewButton.frame = CGRectMake(buttonW + 30, 2, 40, 40);
    }
    
    return _previewButton;
}

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(246, 246, 246);
        self.status = ICChatBoxStatusNothing; // 起始状态

        //添加所有的子控件
        [self addSubview:self.imageButton];
        
        [self addSubview:self.mentionButton];

        [self addSubview:self.topicButton];
        
        [self addSubview:self.previewButton];
        
        [self setSwitchView];
        
        [self changeComposeToolBarShowType:self.showType];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [tap addTarget:self  action:@selector(clickBaseView:)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)clickBaseView:(UITapGestureRecognizer *)tap {
    [self clickTypeChangeWithTag:SYComposeToolbarButtonTypeNone];
}

- (void)clickTypeChangeWithTag:(NSInteger)tag {
    if ([self.delegate respondsToSelector:@selector(composeTool:didClickedButton:)]) {
        [self.delegate composeTool:self didClickedButton:tag];
    }
}

- (UIButton *)makeButtonWithNormal:(NSString *)icon withHighlight:(NSString *)highIcon withTag:(SYComposeToolbarButtonType)tag {
    UIButton *button = [[UIButton alloc] init];
    button.tag = tag;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
    [button setImage:[UIImage imageWithName:highIcon] forState:UIControlStateHighlighted];
    
    return button;
}

- (void)buttonClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(composeTool:didClickedButton:)]) {
        [self.delegate composeTool:self didClickedButton:(int)button.tag];
    }
}

- (void)setSwitchView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(235.0/375*SCREEN_WIDTH, 0, SCREEN_WIDTH -235.0/375*SCREEN_WIDTH, 44)];
    [self addSubview:view];
    self.switchView = view;
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 14, 30.0/375*SCREEN_WIDTH, 17)];
    label1.text = @"动态";
    label1.textColor = RGB(102, 102, 102);
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = [UIFont systemFontOfSize:12];
    [view addSubview:label1];
    
    UISwitch *switchView = [[UISwitch alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame) + 10, 7.0/667*SCREEN_HEIGHT, 50.0/375*SCREEN_WIDTH, 30.0/667*SCREEN_HEIGHT)];
    switchView.on = NO;
    switchView.onTintColor= RGB(59, 186, 200);
    [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [view addSubview: switchView];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"小说";
    label2.textColor = RGB(102, 102, 102);
    label2.textAlignment = NSTextAlignmentLeft;
    label2.font = [UIFont systemFontOfSize:12];
    [view addSubview:label2];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(switchView.mas_right).with.offset(10);
        make.width.mas_equalTo(30);
        make.centerY.equalTo(view).with.offset(0);
        make.height.mas_equalTo(17);
    }];
}

- (void)hiddenSwithBtn {
    self.switchView.hidden = YES;
}

-(void)switchAction:(id)sender {
    BOOL isButtonOn = [(UISwitch*)sender isOn];
    if (_delegate && [_delegate respondsToSelector:@selector(composeToolSwitchBtn:)]) {
        [_delegate composeToolSwitchBtn:isButtonOn];
    }

    [self changeComposeToolBarShowType:(isButtonOn ? SYComposeToolbarShowTypeNovelTitle : SYComposeToolbarShowTypeTopic)];
    if (!isButtonOn) {
        self.status = ICChatBoxStatusShowKeyboard;
    } else {
        SCLog(@"关");
        self.status = ICChatBoxStatusShowMore;
    }
}

- (void)changeComposeToolBarShowType:(SYComposeToolbarShowType)type {
    self.showType = type;
    
    self.previewButton.hidden   = type != SYComposeToolbarShowTypeNovelBody;
    self.topicButton.hidden     = type != SYComposeToolbarShowTypeTopic;
    self.mentionButton.hidden   = type != SYComposeToolbarShowTypeTopic;
    self.imageButton.hidden     = type == SYComposeToolbarShowTypeNovelTitle;
}

@end
