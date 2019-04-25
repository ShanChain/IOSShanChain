//
//  SCCacheChatRecord.m
//  ShanChain
//
//  Created by 千千世界 on 2019/3/25.
//  Copyright © 2019 ShanChain. All rights reserved.
//

#import "SCCacheChatRecord.h"
#import "FMDB.h"
#import "NSDate+Formatter.h"

@interface SCCacheChatRecord ()

@property (nonnull, strong) FMDatabaseQueue * chatRecordQueue;
@property (nonnull, strong) FMDatabaseQueue * systemInformationQueue;
@end

@implementation SCCacheChatRecord

+(SCCacheChatRecord *)shareInstance{
    static dispatch_once_t onceToken;
    static SCCacheChatRecord *instance = nil;
    if (instance == nil) {
        dispatch_once(&onceToken, ^{
            instance = [[SCCacheChatRecord alloc]init];
        });
    }
    return instance;
}

//根据聊天室ID创建表
- (void)createTableWithRoomId:(NSString *)roomId {
    

    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatRecord.db"];
    
    NSString *tableName = [NSString stringWithFormat:@"chatRecordTable%@",roomId];
    
    NSString * createTableSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(msgid TEXT unique,record TEXT)",tableName];
    
    NSString *selectSql = [NSString stringWithFormat:@"select name from sqlite_master where type = 'table' and name = '%@'", tableName];
    
    //创建数据库
    self.chatRecordQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    [self.chatRecordQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            
            FMResultSet *result = [db executeQuery:selectSql];
            //遍历结果集合
            while ([result next]) {
                
                NSString *name = [result stringForColumn:@"name"];
                
                NSLog(@"tablename%@",name);
                
                if ([name isEqualToString:tableName]) {
                    return;
                }
                
            }
            
            BOOL result1 = [db executeUpdate:createTableSql];
            
            if (result1) {
                SCLog(@"创建chatRecordTable表成功");
            }
            else{
                SCLog(@"创建表失败");
            }
        }
        
        [db close];
    }];
}
// 插入数据
- (void)insertDataWithRoomId:(NSString *)roomId msgid:(NSString *)msgid record:(NSString *)record{
    
    [self.chatRecordQueue inDatabase:^(FMDatabase *db) {
        
        if ([db open]) {
            
            NSString *insertSql = [NSString stringWithFormat:@"insert into chatRecordTable%@ (msgid,record) values(?,?) ",roomId];
            
            BOOL result = [db executeUpdate:insertSql, msgid, record];
            if (result) {
                SCLog(@"%@%@插入数据成功%@",roomId,msgid,record);
            }
            else{
                SCLog(@"插入数据失败");
            }
        }
        [db close];
    }];

}


// 删除数据
- (void)deleteDataWithRoomId:(NSString *)roomId {

    [self.chatRecordQueue inDatabase:^(FMDatabase *db) {
        
        if ([db open]) {
            
            NSString *deleteSql = [NSString stringWithFormat:@"delete from chatRecordTable%@",roomId];
            
            BOOL result = [db executeUpdate:deleteSql];
            if (result) {
                SCLog(@"删除数据成功");
            }
            else{
                SCLog(@"删除数据失败");
            }
        }
        [db close];
    }];

}

// 查询数据
- (NSArray *)selectDataWithRoomId:(NSString *)roomId {
    
    NSMutableArray *recordArray = [NSMutableArray array];
    
    [self.chatRecordQueue inDatabase:^(FMDatabase *db) {
        
        if ([db open]) {
            
            NSString *deleteSql = [NSString stringWithFormat:@"select *from chatRecordTable%@",roomId];
            
            FMResultSet *result = [db executeQuery:deleteSql];
            //遍历结果集合
            while ([result next]) {
                
                NSString *record = [result stringForColumn:@"record"];
                
                [recordArray addObject:record];
                SCLog(@"查询房间%@历史消息%@",roomId,record);
                
                
            }
        }
        [db close];
    }];
    
    return recordArray;
}

//如果表格存在 则销毁
- (void)dropTable {
    
    [self.chatRecordQueue inDatabase:^(FMDatabase *db) {
        
        BOOL result = [db executeUpdate:@"drop table if exists chatRecordTable"];
        
        if (result) {
            
            SCLog(@"删除表成功");
            
        } else {
            
            SCLog(@"删除表失败");
            
        }
        
        [db close];
    }];
    
    
}

#pragma mark  系统消息数据本地缓存

//创建系统消息表
- (void)createSystemInformationTable {
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"systemInformation.db"];
    
    NSString *tableName = @"systemInformationTable";
    
    NSString * createTableSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(id integer primary key autoincrement,type TEXT,title TEXT,extra TEXT,time TEXT)",tableName];
    
    NSString *selectSql = [NSString stringWithFormat:@"select name from sqlite_master where type = 'table' and name = '%@'", tableName];
    
    //创建数据库
    self.systemInformationQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    [self.systemInformationQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            
            FMResultSet *result = [db executeQuery:selectSql];
            //遍历结果集合
            while ([result next]) {
                
                NSString *name = [result stringForColumn:@"name"];
                
                NSLog(@"tablename%@",name);
                
                if ([name isEqualToString:tableName]) {
                    return;
                }
                
            }
            
            BOOL result1 = [db executeUpdate:createTableSql];
            
            if (result1) {
                SCLog(@"创建systemInformationTable表成功");
            }
            else{
                SCLog(@"创建表失败");
            }
        }
        
        [db close];
    }];
}
// 插入系统消息数据
- (void)insertDataWithType:(NSString *)type TITLE:(NSString *)title EXTRA:(NSString *)extra block:(void (^)(BOOL success))block {
    
    [self.systemInformationQueue inDatabase:^(FMDatabase *db) {
        
        if ([db open]) {
            
            NSString *insertSql = [NSString stringWithFormat:@"insert into systemInformationTable (type,title,extra,time) values(?,?,?,?) "];
            NSDate *date = [NSDate date];
            NSString *time = [date yyyyMMddByLineWithDate];
            BOOL result = [db executeUpdate:insertSql, type,title,extra,time];
            if (result) {
                SCLog(@"插入数据成功");
                block(YES);
            }
            else{
                SCLog(@"插入数据失败");
                block(NO);
            }
        }
        [db close];
    }];
    
}
// 查询系统消息数据
- (NSArray *)selectSystemInformationData {
    
    NSMutableArray *recordArray = [NSMutableArray array];
    
    [self.systemInformationQueue inDatabase:^(FMDatabase *db) {
        
        if ([db open]) {
            
            NSString *deleteSql = [NSString stringWithFormat:@"select *from systemInformationTable"];
            
            FMResultSet *result = [db executeQuery:deleteSql];
            //遍历结果集合
            while ([result next]) {
                
                NSString *type = [result stringForColumn:@"type"];
                NSString *title = [result stringForColumn:@"title"];
                NSString *extra = [result stringForColumn:@"extra"];
                NSString *time = [result stringForColumn:@"time"];
                NSDictionary *tmp = @{@"type":type,
                                      @"title":title,
                                      @"extra":extra,
                                      @"time":time,
                                      };
                
                [recordArray addObject:tmp];
                SCLog(@"查询%@",tmp);
                
                
            }
        }
        [db close];
    }];
    
    return recordArray;
}
@end






