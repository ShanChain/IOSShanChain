//
//  PublicShareService.h
//  ShanChain
//
//  Created by 千千世界 on 2018/12/5.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShareContentModel;

@interface PublicShareService : NSObject

typedef void(^JSHARECallHandler)(NSInteger state,NSError *error);

+(void)share:(ShareContentModel *)shareContentModel platform:(NSInteger)platform mediaType:(NSInteger)mediaType handler:(JSHARECallHandler)handler;


@end


@interface ShareContentModel : NSObject

/**
 标题：长度每个平台的限制而不同。
 微信好友：最大 512 字符。
 微信朋友圈：最大 512 字符。
 微信收藏：最大 512 字符。
 QQ：最大 128 字符。
 QQ空间：最大 128 字符。
 新浪微博：分享链接类型，最大 1 K字符。
 JChatPro:消息标题。
 */
@property (nonatomic,strong) NSString *title;

/**
 文本：文本内容，长度每个平台的限制而不同。
 在分享非文本类型时，此字段作为分享内容的描述使用。
 
 微信好友：分享文本类型时，最大 10 K字符。分享非文本类型，最大 1 K字符。
 微信朋友圈：分享文本类型时，最大 10 K字符。分享非文本类型，最大 1 K字符。
 微信收藏：分享文本类型时，最大 10 K字符。分享非文本类型，最大 1 K字符。
 QQ：分享文本类型时，最大 1536 字符。分享非文本类型，最大 512 字符。
 QQ空间：分享文本类型时，最大 128 字符。分享非文本类型，最大 512 字符。
 新浪微博：最大 140 汉字。
 Twitter:最大 140 汉字
 JChatPro:消息内容。不超过4k字节
 */
@property (nonatomic,strong) NSString *text;

/**
 链接：根据媒体类型填入链接，长度每个平台的限制不同。分享非文本及非图片类型时，必要！
 微信好友：最大 10 K字符。
 微信朋友圈：最大 10 K字符。
 微信收藏：最大 10 K字符。
 QQ：最大 512 字符。
 QQ空间：最大 512 字符。
 新浪微博：最大 512 字符。
 Twitter:以Twitter返回结果为准。分享链接时必要,其它情况可选。
 */
@property (nonatomic,strong) NSString *url;


/**
 本地视频AssetURL:分享本地视频到 QQ 空间的必填参数，可传ALAsset的ALAssetPropertyAssetURL，或者PHAsset的localIdentifier。分享到视频类型至 facebook 、facebookMessenger 只能识别 ALAsset 的ALAssetPropertyAssetURL。
 */
@property (nonatomic,strong) NSString *videoAssetURL;

/**
 缩略图：大小限制根据平台不同而不同。
 微信好友：最大 32 K。
 微信朋友圈：最大 32 K。
 微信收藏：最大 32 K。
 QQ：最大 1 M。
 QQ空间：最大 1 M。
 新浪微博：最大 32 K。
 */
@property (nonatomic,strong) NSData *thumbnail;

/**
 JChatPro 网络缩略图地址
 */
@property (nonatomic,copy) NSString *thumbUrl;


/**
 图片：分享JSHAREImage类型，大小限制根据平台不同而不同，当分享JSHARELink类型时没有提供缩略图时，若此参数不为空，JSHARE将会裁剪此参数提供的图片去适配缩略图。
 微信好友：最大 10 M。
 微信朋友圈：最大 10 M。
 微信收藏：最大 10 M。
 QQ：最大 5 M。
 QQ空间：最大 5 M。
 新浪微博：最大 10 M。
 Twitter:最大 5 M。
 JChatPro :分享单张图片。暂无限制
 */
@property (nonatomic,strong) NSData *image;

@end
