//
//  SYUIFactory.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/8.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SYUIFactory.h"

@implementation SYUIFactory

+ (UITextField *)textFieldWithPlacehold:(NSString *)title withFont:(UIFont *)font withColor:(UIColor *)color {
    UITextField *textField = [[UITextField alloc] init];
    
    textField.layer.masksToBounds = YES;
    textField.placeholder = title;
    textField.layer.cornerRadius = 8.0;
    textField.layer.borderColor = [RGB(179, 179, 179) CGColor];
    textField.layer.borderWidth = 1.0f;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.textColor = color;
    textField.font = font;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    leftView.backgroundColor = [UIColor clearColor];
    textField.leftView = leftView;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.leftViewMode = UITextFieldViewModeAlways;
    [textField setValue:font forKeyPath:@"_placeholderLabel.font"];
    [textField setValue:RGB(179, 179, 179) forKeyPath:@"_placeholderLabel.textColor"];
    return textField;
}


+ (UIView *)emptyViewWithTitle:(NSString *)title withColor:(UIColor *)color withBackgroundColor:(UIColor *)bgColor {
    UIView *emptyView = [[UIView alloc] init];
    emptyView.backgroundColor = bgColor;
    emptyView.opaque = YES;
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel makeTextStyleWithTitle:title withColor:color withFont:[UIFont systemFontOfSize:18] withAlignment:UITextAlignmentCenter];
    [emptyView addSubview: titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(25);
        make.centerY.mas_equalTo(0);
    }];
    
    return emptyView;
}

@end
