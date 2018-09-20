//
//  SCDialogModule.m
//  ShanChain
//
//  Created by flyye on 2017/10/12.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import "SCDialogModule.h"


@implementation SCDialogModule

RCT_EXPORT_MODULE(SCAlertDialog);

RCT_EXPORT_METHOD(show:(NSDictionary *)options successCallback: (RCTResponseSenderBlock)successCallback errorCallBack  : (RCTResponseErrorBlock)errorCallBack){
    SCLog(@"open alert with options:%@",options);
}

RCT_EXPORT_METHOD(dismiss)
{
 SCLog(@"alert dismiss");
}

@end
