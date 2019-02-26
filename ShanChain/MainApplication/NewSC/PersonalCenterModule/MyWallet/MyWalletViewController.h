//
//  MyWalletViewController.h
//  ShanChain
//
//  Created by 千千世界 on 2018/11/16.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "SCBaseVC.h"

@interface MyWalletViewController : SCBaseVC

@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, assign) BOOL   isShowNav;

- (void)_deallocCache;

@end
