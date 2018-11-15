//
//  SYGuiderScrollview.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/16.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SYGuiderScrollview.h"

@interface SYGuiderScrollview()<UIScrollViewDelegate>

@property (strong, nonatomic) UIButton *enterButton;

@end

@implementation SYGuiderScrollview

- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [[UIButton alloc] init];
        [_enterButton setTitleColor:RGB_HEX(0xFFFFFF) forState:UIControlStateNormal];
        [_enterButton setTitle:@"加入千千世界" forState:UIControlStateNormal];
        [_enterButton setFont:[UIFont systemFontOfSize:14]];
        _enterButton.backgroundColor = [UIColor clearColor];
        [_enterButton addTarget:self action:@selector(enterQianQian:) forControlEvents:UIControlEventTouchUpInside];
        [_enterButton makeLayerWithRadius:0 withBorderColor:RGB_HEX(0xFFFFFF) withBorderWidth:1];
    }
    return _enterButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _layoutUI];
    }
    return self;
}

- (void)_layoutUI {
    self.pagingEnabled = true;
    self.contentSize = CGSizeMake(3 * self.frame.size.width, self.frame.size.height);
    self.delegate = self;
    self.bounces = NO;
    
    //        guide_icon_1;
    // 第一栏
    UIView *view1 = [[UIView alloc] init];
    [self addSubview:view1];
    view1.backgroundColor = RGB_HEX(0x49B8FD);
    view1.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIImageView *one = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_icon_1"]];
    one.contentMode = UIViewContentModeScaleToFill;
    [view1 addSubview:one];
//    CGSize size = one.image.size;
//    CGFloat p = size.height / size.width;
//    CGFloat w = self.frame.size.width * 0.6;
//    CGFloat h = w * p;
//    [one mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(view1).with.offset(10);
//        make.centerX.equalTo(view1).with.offset(25);
//        make.width.mas_equalTo(w);
//        make.height.mas_equalTo(h);
//    }];
    
//    UILabel *lab = [[UILabel alloc] init];
//    [lab makeTextStyleWithTitle:@"点击图标可添加属于自己的新世界" withColor:RGB_HEX(0xFFFFFF) withFont:[UIFont systemFontOfSize:14] withAlignment:UITextAlignmentCenter];
//    [view1 addSubview:lab];
//    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(20);
//        make.bottom.equalTo(one.mas_top).offset(-40);
//        make.left.right.mas_equalTo(0);
//    }];
//
//    UILabel *title1 = [[UILabel alloc] init];
//    [title1 makeTextStyleWithTitle:@"添加新世界" withColor:RGB_HEX(0xFFFFFF) withFont:[UIFont systemFontOfSize:20] withAlignment:UITextAlignmentCenter];
//    [view1 addSubview:title1];
//    [title1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(28);
//        make.bottom.equalTo(lab.mas_top).offset(-25);
//        make.left.right.mas_equalTo(0);
//    }];
    
    // 第二栏
    UIView *view2 = [[UIView alloc] init];
    [self addSubview:view2];
    view2.backgroundColor = RGB_HEX(0xF5B32B);
    view2.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    UIImageView *two = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_icon_2"]];
    two.contentMode = UIViewContentModeScaleToFill;

    [view2 addSubview:two];
//    [two mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(view2).with.offset(10);
//        make.centerX.equalTo(view2).with.offset(3);
//        make.width.mas_equalTo(w);
//        make.height.mas_equalTo(h);
//    }];
    
//    UILabel *lab2 = [[UILabel alloc] init];
//    [lab2 makeTextStyleWithTitle:@"点击头像可进入世界，也可添加自己喜欢的角色" withColor:RGB_HEX(0xFFFFFF) withFont:[UIFont systemFontOfSize:14] withAlignment:UITextAlignmentCenter];
//    [view2 addSubview:lab2];
//    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(20);
//        make.bottom.equalTo(two.mas_top).offset(-40);
//        make.left.right.mas_equalTo(0);
//    }];
//
//    UILabel *title2 = [[UILabel alloc] init];
//    [title2 makeTextStyleWithTitle:@"添加新角色" withColor:RGB_HEX(0xFFFFFF) withFont:[UIFont systemFontOfSize:20] withAlignment:UITextAlignmentCenter];
//    [view2 addSubview:title2];
//    [title2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(28);
//        make.bottom.equalTo(lab2.mas_top).offset(-25);
//        make.left.right.mas_equalTo(0);
//    }];
    
    // 第三栏
    UIView *view3 = [[UIView alloc] init];
    [self addSubview:view3];
    view3.backgroundColor = RGB_HEX(0x80C40D);
    view3.frame = CGRectMake(2 * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    UIImageView *three = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_icon_3"]];
    three.contentMode = UIViewContentModeScaleToFill;

    [view3 addSubview:three];
//    [three mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(view3).with.offset(10);
//        make.centerX.equalTo(view3).with.offset(25);
//        make.width.mas_equalTo(w);
//        make.height.mas_equalTo(h);
//    }];
    
//    UILabel *lab3 = [[UILabel alloc] init];
//    [lab3 makeTextStyleWithTitle:@"选择好角色后，点击进入世界" withColor:RGB_HEX(0xFFFFFF) withFont:[UIFont systemFontOfSize:14] withAlignment:UITextAlignmentCenter];
//    [view3 addSubview:lab3];
//    [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(20);
//        make.bottom.equalTo(three.mas_top).offset(-40);
//        make.left.right.mas_equalTo(0);
//    }];
//
//    UILabel *title3 = [[UILabel alloc] init];
//    [title3 makeTextStyleWithTitle:@"进入世界" withColor:RGB_HEX(0xFFFFFF) withFont:[UIFont systemFontOfSize:20] withAlignment:UITextAlignmentCenter];
//    [view3 addSubview:title3];
//    [title3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(28);
//        make.bottom.equalTo(lab3.mas_top).offset(-18);
//        make.left.right.mas_equalTo(0);
//    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint contentOffset = scrollView.contentOffset;
    int index = (int)(contentOffset.x / self.frame.size.width);
    if (index == 2) {
        [self.superview addSubview: self.enterButton];
        self.enterButton.frame = CGRectMake((self.frame.size.width - 140)/2, self.frame.size.height - 120, 140, 35);
    } else {
        [self.enterButton removeFromSuperview];
    }
}

- (void)enterQianQian:(UIButton *)button {
    NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [NSUserDefaults.standardUserDefaults setObject:@"true" forKey:[@"qianqianfirstenter-" stringByAppendingString:versionString]];
    [UIView animateWithDuration:0.3 animations:^{
        [self.enterButton removeFromSuperview];
        [self removeFromSuperview];
    }];
}

@end
