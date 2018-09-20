//
//  SCBaseViewController.m
//  ShanChain
//
//  Created by flyye on 2017/12/7.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCBaseViewController.h"

@implementation SCBaseViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"aaaaaaaaaaaaa ===== %@",NSStringFromClass([self class]));
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = RGB(224, 224, 224);
}

@end
