//
//  SYPoppedAuxiliaryView.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/13.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SYPoppedAuxiliaryView.h"
#import "SYTextView.h"

@interface SYPoppedAuxiliaryView()

@property (strong, nonatomic) SYTextView *textView;

@end

@implementation SYPoppedAuxiliaryView

- (void)presentView {
    for (UIView *sub in self.subviews) {
        [sub removeFromSuperview];
    }
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = RGBA(216, 216, 216, 0.3);
#warning 取出最上面的View
    [UIApplication.sharedApplication.keyWindow addSubview: self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    
    UIView *popView=[[UIView alloc] init];
    popView.layer.masksToBounds = YES;
    popView.layer.cornerRadius = 10.0;
    popView.backgroundColor = RGB(255, 255, 255);
    [self addSubview: popView];
    [popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(100);
        make.width.mas_equalTo(SCREEN_WIDTH - 30 * 2);
        make.height.mas_equalTo(250);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleNormal:@"取消" withTitleColor:RGB(59, 186, 200)];
    [btn makeLayerWithRadius:8.0f withBorderColor:RGB(59, 186, 200) withBorderWidth:1.0f];
    [btn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [popView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(popView).with.offset(-50);
        make.bottom.equalTo(popView).with.offset(-20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.backgroundColor = RGB(59, 186, 200);
    btn1.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn1 setTitleNormal:@"确定" withTitleColor:RGB(255, 255, 255)];
    [btn1 makeLayerWithRadius:8.0f withBorderColor:RGB(59, 186, 200) withBorderWidth:1.0f];
    [btn1 addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    [popView addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(popView).with.offset(50);
        make.bottom.equalTo(popView).with.offset(-20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];

    UILabel *titleLabel = [[UILabel alloc] init];
    NSString *t = self.title ? self.title : @"发表签名";
    [titleLabel makeTextStyleWithTitle:t withColor:RGB(102, 102, 102) withFont:[UIFont systemFontOfSize:14] withAlignment:NSTextAlignmentCenter];
    [popView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(popView);
        make.top.equalTo(popView).with.offset(15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(15);
    }];
    
    if (self.secondTitle) {
        UILabel * descriptionLabel = [[UILabel alloc] init];
        [descriptionLabel makeTextStyleWithTitle:self.secondTitle withColor:RGB(179, 179, 179) withFont:[UIFont systemFontOfSize:12] withAlignment:NSTextAlignmentLeft];
        [popView addSubview:descriptionLabel];
        [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(popView);
            make.top.equalTo(popView).with.offset(40);
            make.right.equalTo(popView).with.offset(-15);
            make.height.mas_equalTo(20);
        }];
    }
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(238, 238, 238);
    [popView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(popView);
        if (self.title) {
            make.top.equalTo(popView).with.offset(65);
        } else {
            make.top.equalTo(popView).with.offset(40);
        }
        make.width.equalTo(popView);
        make.height.mas_equalTo(1);
    }];

    SYTextView *textView = [[SYTextView alloc] init];
    textView.placeholder = self.placeholder;
    [popView addSubview:textView];
    self.textView = textView;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.equalTo(popView);
        make.right.equalTo(popView);
        make.height.mas_equalTo(80);
    }];
    
    [self.textView becomeFirstResponder];
}

- (void)closeTap:(UITapGestureRecognizer *)tap {
    [self removeFromSuperview];
    [self endEditing:YES];
}

- (void)cancelAction:(UIButton *)button {
    [self removeFromSuperview];
    [self endEditing:YES];
}

- (void)commitAction:(UIButton *)button {
    if (![self.textView.text isNotBlank]) {
        [SYProgressHUD showError:@"不能为空哦"];
        return;
    }
    
    self.callback(self.textView.text);
    [self removeFromSuperview];
}

@end
