//
//  SCCacheTool.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/10/18.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCCharacterModel.h"
#import "EditInfoService.h"
#import <CoreLocation/CoreLocation.h>

@interface SCCacheTool : NSObject



+(SCCacheTool *)shareInstance;

/**
 获取缓存值信息

 @param userid <#userid description#>
 @param key <#key description#>
 @return <#return value description#>
 */
-(NSString*)getCacheValueInfoWithUserID:(NSString*)userid  andKey:(NSString*)key;

/**
 获取缓存时间信息
 
 @param userid <#userid description#>
 @param key <#key description#>
 @return <#return value description#>
 */
-(NSString*)getCacheTimeInfoWithUserID:(NSString*)userid  andKey:(NSString*)key;

/**
 设置缓存信息

 @param value <#value description#>
 @param userid <#userid description#>
 @param key <#key description#>
 */
-(void)setCacheValue:(NSString*)value  withUserID:(NSString*)userid  andKey:(NSString*)key;


-(void)dropTableWithUserId:(NSString *)userId;

#pragma mark --------------便捷方法----------------------
/**
 获取当前用户
 */
- (NSString *)getCurrentUser;

- (NSString *)getCurrentCharacterId;

- (NSString *)getCurrentSpaceId;

- (NSString *)getCurrentSpaceName;

- (NSString *)getGdata;

- (NSString *)getUserToken;

- (NSString *)getHeadImg;

- (NSString *)getHxUserName;
/*
    "characterInfo": {
    "characterId": 2351,
    "userId": 100023,
    "name": "3123",
    "intro": "21",
    "disc": "  ",
    "headImg": "http://shanchain-picture.oss-cn-beijing.aliyuncs.com/2971c6151337496eb486f414b6bf035c.jpg",
    "spaceId": 16,
    "modelId": 260,
    "modelNo": 3,
    "signature": "",
    "status": 1,
    "createTime": 1513069055000
 }
 */
- (void)cacheCharacterInfo:(NSDictionary *)characterInfo withUserId:(NSString *)userId;


- (NSMutableDictionary *)getCharacterInfo;


@property   (nonatomic,strong)  SCCharacterModel         *characterModel;
@property   (nonatomic,strong)  WalletCurrencyModel         *currencyModel;

@property   (nonatomic,copy)    NSString            *chatRoomId;
@property   (nonatomic,copy)    NSString            *status;//0 未上  1 以上
@property   (nonatomic,assign)   BOOL   isJGSetup; //极光sdk是否连接成功
@property   (nonatomic,strong)    UIImage  *headImage;
@property   (nonatomic,strong)    UIImage  *takeImage; //当前所属聊天室区域截图
@property   (nonatomic,assign)      CLLocationCoordinate2D   pt; //用户当前的经纬度
@end
