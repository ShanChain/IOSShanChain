//
//  PublicShareService.m
//  ShanChain
//
//  Created by 千千世界 on 2018/12/5.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "PublicShareService.h"

#import "CoordnateInfosModel.h"

@class ShareContentModel;

@implementation PublicShareService

// 通用分享接口
+(void)commonShareWith:(HHShareType)type callBlock:(void (^)(HHBaseModel *, NSError *))callBlock{
    NSMutableDictionary  *mdic = [NSMutableDictionary dictionaryWithCapacity:0];
    [mdic setObject:[SCCacheTool shareInstance].getCurrentCharacterId forKey:@"characterId"];
    NSString *shareContentType;
    if (type == HHShareType_IMAGE) {
        shareContentType = @"SHARE_IMAGE";
    }else{
        shareContentType = @"SHARE_WEBPAGE";
    }
    [mdic setObject:shareContentType forKey:@"type"];
    [[SCNetwork shareInstance]v1_postWithUrl:CommonShare_URL params:mdic.copy showLoading:YES callBlock:callBlock];
}


+(void)share:(ShareContentModel *)shareContentModel platform:(NSInteger)platform mediaType:(NSInteger)mediaType handler:(JSHARECallHandler)handler{
    JSHAREMessage *msg = [JSHAREMessage message];
    msg.title = shareContentModel.title;
    if (mediaType != 3) {
        msg.thumbnail = UIImageJPEGRepresentation([UIImage imageWithData:shareContentModel.thumbnail], 0.2);
    }else{
        msg.image = UIImageJPEGRepresentation([UIImage imageWithData:shareContentModel.thumbnail], 0.2);
    }
    msg.text = shareContentModel.text;
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
        
        if (error.code == 40009) {
            BLOCK_EXEC(handler,state,[SCNetworkError errorWithCode:error.code msg:@"未安装客户端"])
            return ;
        }
          BLOCK_EXEC(handler,state,error)
    }];
}


@end


@implementation ShareContentModel


@end




