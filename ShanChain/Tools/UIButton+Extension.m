//
//  UIButton+Extension.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/7.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

- (void)setTitleNormal:(NSString *)title withImageNormal:(NSString *)imageName {
    [self setTitle:title forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)setImageNormal:(NSString *)normal withImageHighlighted:(NSString *)hl {
    [self setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:hl] forState:UIControlStateHighlighted];
    [self setImage:[UIImage imageNamed:hl] forState:UIControlStateSelected];
}

- (void)setTitleNormal:(NSString *)title withTitleColor:(UIColor *)color {
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateNormal];
}


- (void)setFreeMovement{
    [self addTarget:self action:@selector(dragMoving:withEvent: )forControlEvents: UIControlEventTouchDragInside];
    [self addTarget:self action:@selector(dragEnded:withEvent: )forControlEvents:UIControlEventTouchUpOutside];
}

- (void) dragMoving: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self];
}

- (void) dragEnded: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self];
}

-(void)buttonAction:(UIButton *)sender
{
    NSLog(@"起飞");
}


@end
