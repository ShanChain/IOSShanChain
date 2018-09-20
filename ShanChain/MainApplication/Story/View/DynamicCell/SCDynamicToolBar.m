//
//  SCDynamicToolBar.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/22.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SCDynamicToolBar.h"
#import "SCDynamicModel.h"
#import "SCDynamicStatusFrame.h"

@interface SCDynamicToolBar()

@property (nonatomic , strong) NSMutableArray *btns;
@property (nonatomic , strong) NSMutableArray *dividers;

@property (weak, nonatomic) UIButton *buttonShare;//转发
@property (weak, nonatomic) UIButton *buttonComment;//评论
@property (weak, nonatomic) UIButton *buttonSupport;//赞

@end


@implementation SCDynamicToolBar

- (NSMutableArray *)btns {
    if (_btns == nil) {
        self.btns = [[NSMutableArray alloc] init];
    }
    
    return _btns;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.buttonShare = [self makeToolbarButtonWithIcon:@"abs_home_btn_forwarding_default" withSelectIcon:nil withTitle:@""];
        [self.buttonShare addTarget:self action:@selector(buttonShareAction:) forControlEvents:UIControlEventTouchUpInside];
        self.buttonComment  = [self makeToolbarButtonWithIcon:@"abs_home_btn_comment_default" withSelectIcon:nil withTitle:@""];
        [self.buttonComment addTarget:self action:@selector(buttonCommentAction:) forControlEvents:UIControlEventTouchUpInside];
        // 喜欢
        self.buttonSupport  = [self makeToolbarButtonWithIcon:@"abs_home_btn_thumbsup_default" withSelectIcon:@"abs_home_btn_thumbsup_selscted" withTitle:@""];
        [self.buttonSupport addTarget:self action:@selector(buttonSupportAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // 分割线
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = RGB(238, 238, 238);
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.top.equalTo(self).with.offset(0);
            make.height.mas_equalTo(@1);
        }];
        
        UIView *lineView1 = [[UIView alloc]init];
        lineView1.backgroundColor = RGB(238, 238, 238);
        [self addSubview:lineView1];
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.bottom.equalTo(self).with.offset(0);
            make.height.mas_equalTo(@1);
        }];
    }
    
    return self;
}

- (UIButton *)makeToolbarButtonWithIcon:(NSString *)icon withSelectIcon:(NSString *)iconSelected withTitle:(NSString *)title {
    
    UIButton *btn = [[UIButton alloc] init];
    NSString *s = iconSelected ? iconSelected : icon;
    [btn setImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageWithName:s] forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self addSubview:btn];
    
    [self.btns addObject:btn];
    return btn;
}

- (void)layoutSubviews {
    
    // 设置按钮的frame
    int btnCount = (int)self.btns.count;
    CGFloat btnW = 70;
    CGFloat btnH = self.height;
    CGFloat baseX = self.width - btnW * btnCount - 15;
    for (int i = 0; i < btnCount; i++){
        UIButton *btn = self.btns[i];
        btn.width = btnW;
        btn.height = btnH;
        btn.y = 0;
        btn.x = baseX + i * btnW;
    }
}

- (void)buttonCommentAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(toolbarButtonComment)]) {
        [self.delegate toolbarButtonComment];
    }
}

- (void)buttonShareAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(toolbarButtonShare)]) {
        [self.delegate toolbarButtonShare];
    }
}

- (void)buttonSupportAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(toolbarButtonSupportWith:)]) {
        [self.delegate toolbarButtonSupportWith:!button.selected];
    }
}

- (void)setDynamicStatusFrame:(SCDynamicStatusFrame *)dynamicStatusFrame {
    [self updateButtonWithCount:dynamicStatusFrame.dynamicModel.transpond atButton:self.buttonShare];
    [self updateButtonWithCount:dynamicStatusFrame.dynamicModel.supportCount atButton:self.buttonSupport];
    [self updateButtonWithCount:dynamicStatusFrame.dynamicModel.commendCount atButton:self.buttonComment];
    
    self.buttonSupport.selected = dynamicStatusFrame.dynamicModel.isFavorite;
    
    self.buttonShare.hidden = dynamicStatusFrame.dynamicModel.type == 2;
}

- (void)updateButtonWithCount:(int)count atButton:(UIButton *)button {
    NSString  *text = nil;
    if (count > 10000) {
        text = [NSString stringWithFormat:@"%.1f万",count / 10000.0];
    }else if (count > 1000){
        text = [NSString stringWithFormat:@"%.1fk",count / 1000.0];
    }else{
        text = [NSString stringWithFormat:@"%d",count];
    }
    [button setTitle:text forState:UIControlStateNormal];
}

@end
