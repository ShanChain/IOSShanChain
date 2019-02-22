//
//  ScanCodeService.m
//  ShanChain
//
//  Created by 千千世界 on 2018/12/17.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "ScanCodeService.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"


@implementation ScanCodeService


+(void)newInstancetypeWithPushVC:(SCBaseVC*)pushVC{
    if (![HHTool checkCameraPermission]) {
        return;
    }
    //添加一些扫码或相册结果处理
    QQLBXScanViewController *vc = [QQLBXScanViewController new];
    vc.libraryType = [Global sharedManager].libraryType;
    vc.scanCodeType = [Global sharedManager].scanCodeType;
    vc.style = [StyleDIY qqStyle];
    vc.isNeedScanImage = NO;
    //镜头拉远拉近功能
//    vc.isVideoZoom = YES;
    [pushVC pushPage:vc Animated:YES];
}

// 生成二维码
+(UIImage*)createQRWithString:(NSString*)codeString size:(CGSize)size{
    return [LBXScanNative createQRWithString:codeString QRSize:size];
}

@end






