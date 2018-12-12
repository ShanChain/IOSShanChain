//
//  SCDynamicLoginViewController.h
//  ShanChain
//
//  Created by 千千世界 on 2018/12/11.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "SCBaseVC.h"

typedef NS_ENUM(NSInteger,SC_LoginType) {
    LoginType_dynamic,
    LoginType_bindPhoneNumber
};



@interface SCDynamicLoginViewController : SCBaseVC

@property  (nonatomic,assign)  SC_LoginType  loginType;
@property  (nonatomic,copy)    NSString    *encryptOpenId;

@end
