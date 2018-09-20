//
//  SCNetworkModule.m
//  ShanChain
//
//  Created by flyye on 2017/10/22.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCNetworkModule.h"
#import "SCNetwork.h"

@implementation SCNetworkModule


RCT_EXPORT_MODULE(SCNetwork);

RCT_EXPORT_METHOD(fetch
                  : (NSDictionary *)options successCallback
                  : (RCTResponseSenderBlock)successCallback errorCallBack
                  : (RCTResponseErrorBlock)errorCallBack) {
    [[SCNetwork shareInstance] rnRequest:options successCallback:successCallback errorCallBack:errorCallBack];
    
}

@end
