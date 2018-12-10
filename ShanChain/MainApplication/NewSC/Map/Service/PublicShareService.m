//
//  PublicShareService.m
//  ShanChain
//
//  Created by 千千世界 on 2018/12/5.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "PublicShareService.h"
#import "JPUSHService.h"
#import "JSHAREService.h"
#import "CoordnateInfosModel.h"

@class ShareContentModel;

@implementation PublicShareService


+(void)share:(ShareContentModel *)shareContentModel platform:(NSInteger)platform mediaType:(NSInteger)mediaType handler:(JSHARECallHandler)handler{
    JSHAREMessage *msg = [JSHAREMessage message];
    
    if (mediaType == JSHAREText) {
        msg.text = shareContentModel.text;
    }else{
        msg.url = @"https://docs.jiguang.cn/jshare/client/iOS/ios_api/";
    }
    
    switch (mediaType) {
        case JSHAREText:
             msg.text = shareContentModel.text;
            break;
        case JSHAREImage:
            msg.image = shareContentModel.image;
            break;
        case JSHARELink:
            msg.url = shareContentModel.url;
            break;
        default:
            break;
    }
    msg.platform = platform;
    msg.mediaType = mediaType;
    [JSHAREService share:msg handler:^(JSHAREState state, NSError *error) {
          BLOCK_EXEC(handler,state,error)
    }];
}


@end


@implementation ShareContentModel


@end




