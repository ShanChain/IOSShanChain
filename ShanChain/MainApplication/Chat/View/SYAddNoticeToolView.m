//
//  SYAddNoticeToolView.m
//  ShanChain
//
//  Created by krew on 2017/10/17.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYAddNoticeToolView.h"

@interface SYAddNoticeToolView()

@property(nonatomic,strong)UIView *view;

@end

@implementation SYAddNoticeToolView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(246, 246, 246);
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 46)];
        self.view = view;
        
        //添加所有的子控件
        [self addButtonWithIcon:@"abs_release_btn_image_default1" highIcon:@"abs_release_btn_image_default1" tag:SYAddNoticeToolViewButtonTypePicture];
        [self addButtonWithIcon:@"abs_release_btn_at_default1" highIcon:@"abs_release_btn_at_default1" tag:SYAddNoticeToolViewButtonTypePicture];
        [self layoutSubviews];
    }
    return self;
}

- (UIButton *)addButtonWithIcon:(NSString *)icon highIcon:(NSString *)highIcon tag:(SYAddNoticeToolViewButtonType)tag{
    UIButton *button = [[UIButton alloc] init];
    button.tag = tag;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
    [button setImage:[UIImage imageWithName:highIcon] forState:UIControlStateHighlighted];
    
    [self.view addSubview:button];
    
    [self addSubview:self.view];
    return button;
}

- (void)buttonClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(noticeTool:didClickedButton:)]) {
        [self.delegate noticeTool:self didClickedButton:(int)button.tag];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    int count = (int)self.view.subviews.count  ;
    CGFloat buttonW = (200.0/375*SCREEN_WIDTH) /count ;
    CGFloat buttonH = 20.0;
    for (int i = 0; i<count ; i++) {
        UIButton *button = self.view.subviews[i];
        button.y = 12;
        button.width = 20;
        button.height = buttonH;
        button.x = i * buttonW + 30;
    }
}

@end
