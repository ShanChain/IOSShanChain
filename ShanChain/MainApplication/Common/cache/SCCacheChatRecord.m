//
//  SCCacheChatRecord.m
//  ShanChain
//
//  Created by 千千世界 on 2019/3/25.
//  Copyright © 2019 ShanChain. All rights reserved.
//

#import "SCCacheChatRecord.h"
#import "FMDB.h"

@interface SCCacheChatRecord ()

@property (nonnull, strong) FMDatabaseQueue * queue;

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
- (void)createTable {
    
    
     NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SC_CHATRECORD_DB"];
    //创建数据库
    self.queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        if ([db open]) {
            
            BOOL createTable = [db executeUpdate:@"create table if not exists chatRecordTable (record blob)"];
            if (createTable) {
                NSLog(@"创建表成功");
            }
            else{
                NSLog(@"创建表失败");
            }
        }
        
        [db close];
    }];
}
@end






