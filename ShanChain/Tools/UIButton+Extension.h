//
//  UIButton+Extension.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/7.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton (Extension)

- (void)setTitleNormal:(NSString *)title withImageNormal:(NSString *)imageName;

- (void)setTitleNormal:(NSString *)title withTitleColor:(UIColor *)color;

- (void)setImageNormal:(NSString *)normal withImageHighlighted:(NSString *)hl;

@end
