//
//  SCShareManager.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/21.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SCShareManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/NSMutableDictionary+SSDKShare.h>

@implementation SCShareManager

+ (void)shareContentWithTitle:(NSString *)title andImageUrl:(NSString *)imageUrl andContent:(NSString *)content andPlatformType:(SSDKPlatformType)platformType {
    NSMutableDictionary *paramDictionary = [NSMutableDictionary dictionary];
    switch (platformType) {
        case SSDKPlatformTypeQQ: {
            [paramDictionary SSDKSetupQQParamsByText:content title:title url:nil thumbImage:nil image:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformTypeQQ];
            break;
        }
        default:
            break;
    }
    
    [ShareSDK share:platformType parameters:paramDictionary onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        if (error) {
            
        } else {
            switch (state) {
                case SSDKResponseStateCancel:
                    break;
                case SSDKResponseStateFail:
                    break;
                default:
                    break;
            }
        }
    }];
}

@end
