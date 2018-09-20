//
//  SYMessageToolBar.m
//  ShanChain
//
//  Created by krew on 2017/9/12.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYMessageToolBar.h"

@interface SYMessageToolBar()

@property (strong, nonatomic) NSMutableArray *subButtonArray;

@property (strong, nonatomic) UIButton *scenceButton;
@property (strong, nonatomic) UIButton *mentionButton;
// 增加语意
@property (strong, nonatomic) UIButton *alterButton;


@end

@implementation SYMessageToolBar

- (NSMutableArray *)subButtonArray {
    if (!_subButtonArray) {
        _subButtonArray = [NSMutableArray array];
    }
    
    return _subButtonArray;
}

- (UIButton *)scenceButton {
    if (!_scenceButton) {
        _scenceButton = [[UIButton alloc] init];
        _scenceButton.tag = SYMessageToolBarButtonTypeScreen;
        [_scenceButton setImageNormal:@"abs_dialogue_btn_scene_default" withImageHighlighted:@"abs_dialogue_btn_scene_default"];
        [_scenceButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _scenceButton;
}

- (UIButton *)mentionButton {
    if (!_mentionButton) {
        _mentionButton = [[UIButton alloc] init];
        _mentionButton.tag = SYMessageToolBarButtonTypeMention;
        [_mentionButton setImageNormal:@"abs_release_btn_at_default" withImageHighlighted:@"abs_release_btn_at_default"];
        [_mentionButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _mentionButton;
}

- (UIButton *)alterButton {
    if (!_alterButton) {
        _alterButton = [[UIButton alloc] init];
        _alterButton.tag = SYMessageToolBarButtonTypeAlert;
        [_alterButton setImageNormal:@"abs_release_btn_frame_default1" withImageHighlighted:@"abs_release_btn_frame_default1"];
        [_alterButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _alterButton;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self.subButtonArray addObject: self.scenceButton];
        [self.subButtonArray addObject: self.mentionButton];
        [self.subButtonArray addObject: self.alterButton];
        [self setSwitchView];
        
        [self layoutSubviews];
    }
    return self;
}

- (void)setIsGroup:(BOOL)isGroup {
    _isGroup = isGroup;
    // 是否对戏 移除button 和 添加
    if (!isGroup) {
        int count = self.subButtonArray.count;
        for (int i=0; i<count; i += 1) {
            UIButton *btn = self.subButtonArray[i];
            if (btn.tag == SYMessageToolBarButtonTypeMention) {
                [self.subButtonArray removeObjectAtIndex:i];
                break;
            }
        }
    } else {
        int count = self.subButtonArray.count;
        for (int i=0; i<count; i += 1) {
            UIButton *btn = self.subButtonArray[i];
            if (btn.tag == SYMessageToolBarButtonTypeAlert) {
                [self.subButtonArray insertObject:self.mentionButton atIndex:i];
                [self setNeedsLayout];//标记需要刷新布局
                return;
            } else if (btn.tag == SYMessageToolBarButtonTypeMention) {
                return;
            }
        }
        [self.subButtonArray insertObject:self.mentionButton atIndex:0];
    }
    [self setNeedsLayout];
}

- (void)buttonClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(messageCenter:didClickedButton:)]) {
        [self.delegate messageCenter:self didClickedButton:(int)button.tag];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:UIButton.class]) {
            [v removeFromSuperview];
        }
    }
    
    int count = self.subButtonArray.count ;
    CGFloat buttonW = (160.0/375*SCREEN_WIDTH) / 3 ;
    for (int i = 0; i<count ; i++) {
        UIButton *button = self.subButtonArray[i];
        button.y = 5;
        button.width = 25;
        button.height = 25;
        button.x = i * buttonW + 20;
        [self addSubview:button];
    }
}

- (void)setSwitchView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(235.0/375*SCREEN_WIDTH, 0, SCREEN_WIDTH -235.0/375*SCREEN_WIDTH, 44)];

    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 30.0/375*SCREEN_WIDTH, 17)];
    [label1 makeTextStyleWithTitle:@"对戏" withColor:RGB(102, 102, 102) withFont:[UIFont systemFontOfSize:12] withAlignment:NSTextAlignmentLeft];
    [view addSubview:label1];
    
    UISwitch *switchView = [[UISwitch alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame) + 10, 3 , 50.0/375*SCREEN_WIDTH, 30.0/667*SCREEN_HEIGHT)];
    switchView.on = NO;
    switchView.onTintColor= RGB(59, 186, 200);
    [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [view addSubview: switchView];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(switchView.frame) + 10, 10, 30, 17)];
    [label2 makeTextStyleWithTitle:@"闲聊" withColor:RGB(102, 102, 102) withFont:[UIFont systemFontOfSize:12] withAlignment:NSTextAlignmentLeft];
    [view addSubview:label2];
    [self addSubview:view];
}

- (void)switchAction:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if ([self.delegate respondsToSelector:@selector(composeToolSwitchBtn:)]) {
        [self.delegate composeToolSwitchBtn:isButtonOn];
    }
    
    if (isButtonOn) {
        int count = self.subButtonArray.count;
        for (int i=0; i<count; i += 1) {
            UIButton *btn = self.subButtonArray[i];
            if (btn.tag == SYMessageToolBarButtonTypeScreen) {
                [self.subButtonArray removeObjectAtIndex:i];
                break;
            }
        }
    } else {
        [self.subButtonArray insertObject:self.scenceButton atIndex:0];
    }
    
    [self setNeedsLayout];
}

@end
