//
//  SCProgressHUD.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/8.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYProgressHUD : NSObject

+ (void)showError:(NSString *)msg;

+ (void)showMessage:(NSString *)msg;

+ (void)showSuccess:(NSString *)msg;

+ (void)hideHUD;

@end
