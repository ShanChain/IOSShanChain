//
//  SCCacheChatRecord.h
//  ShanChain
//
//  Created by 千千世界 on 2019/3/25.
//  Copyright © 2019 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCCacheChatRecord : NSObject

+ (SCCacheChatRecord *)shareInstance;

/// 根据聊天室ID创建表
- (void)createTableWithRoomId:(NSString *)roomId;

/// 插入数据
- (void)insertDataWithRoomId:(NSString *)roomId msgid:(NSString *)msgid record:(NSString *)record;

/// 删除数据
- (void)deleteDataWithRoomId:(NSString *)roomId;

/// 查询数据
- (NSArray *)selectDataWithRoomId:(NSString *)roomId;
/// 如果表格存在 则销毁
- (void)dropTable;


/// 创建系统消息表
- (void)createSystemInformationTable;
/// 插入系统消息数据
- (void)insertDataWithType:(NSString *)type TITLE:(NSString *)title EXTRA:(NSString *)extra block:(void (^)(BOOL success))block;
/// 查询系统消息数据
- (NSArray *)selectSystemInformationData;
@end
