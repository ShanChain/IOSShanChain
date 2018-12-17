//
//  ScanCodeService.h
//  ShanChain
//
//  Created by 千千世界 on 2018/12/17.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScanCodeService : NSObject

// 跳转到扫码二维码界面
+ (void)newInstancetypeWithPushVC:(SCBaseVC*)pushVC;

// 生成二维码
+ (UIImage*)createQRWithString:(NSString*)codeString size:(CGSize)size;

@end
