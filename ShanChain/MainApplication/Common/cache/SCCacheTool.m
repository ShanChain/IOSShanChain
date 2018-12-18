//
//  SCCacheTool.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/10/18.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SCCacheTool.h"
#import "FMDB.h"
#import "SCMD5Tool.h"
#import "CacheModel.h"
#define DataBaseName @"SC_CACHE_DB"
static NSDictionary * cacheDic;//内存字典
static FMDatabase * userInfoDB;//数据库
@implementation SCCacheTool

static SCCacheTool *instance = nil;

+ (SCCacheTool *)shareInstance {
    
    @synchronized(self) {
        if (instance == nil) {
            instance = [[SCCacheTool alloc] init];
            if (userInfoDB == nil) {
                NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:DataBaseName];
                
                userInfoDB = [FMDatabase databaseWithPath:path];
            }
        }
    }
    
    return instance;
}


-(FMDatabaseQueue *)getSharedDatabaseQueue{
    static FMDatabaseQueue *dbQueue=nil;
    if (!dbQueue) {
        NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:DataBaseName];
        dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    }
    return dbQueue;
    
}

-(void)setCacheValue:(NSString *)value withUserID:(NSString *)userid andKey:(NSString *)key{
    
    if (cacheDic == nil) {
        cacheDic = [NSMutableDictionary dictionary];
    }
    
    //保存到内存
    NSString * jointStr = [NSString stringWithFormat:@"%@%@",userid,key];
    NSString * currentTime =[self getCurrentTimeString];
    if (jointStr && ![jointStr isEqualToString:@""]) {
        
        CacheModel * model = [[CacheModel alloc]init];
        model.value = value;
        model.time =  currentTime;
        [cacheDic setValue:model forKey:jointStr];
        
    }else{
        
        SCLog(@"拼接key为空！");
        return;
    }
    //保存到数据库
    
    //暂时用锁，后续使用FMDatabaseQueue，该文件其他地方同理
    @synchronized (userInfoDB) {
        if ([userInfoDB open]) {
            
            if (![self checkHasExistTable:[self getTableNameWithUser:userid]]) {
                // 当前表不存在  创建表
                NSString * createTableSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(cacheKey text unique,cacheValue text,cacheTime text)",[self getTableNameWithUser:userid]];
                if(![userInfoDB executeUpdate:createTableSql]){
                    
//                    SCLog(@"createerror = %@", [userInfoDB lastErrorMessage]);
                    return;
                    
                }
            }
            
            NSString *jointStrMD5 = [SCMD5Tool MD5ForLower32Bate:jointStr];
            NSString *valueEncodeString = [SCBase64 encodeBase64String:value];
            NSString * insertSql = [NSString stringWithFormat:@"insert or replace into %@(cacheKey,cacheValue,cacheTime) values('%@','%@','%@')",[self getTableNameWithUser:userid],jointStrMD5,valueEncodeString,currentTime];
            
            BOOL success = [userInfoDB executeUpdate:insertSql];
            if (!success) {
                SCLog(@"db_error = %@", [userInfoDB lastErrorMessage]);
            }
            
            [userInfoDB close];
        }
    }
    
    
}

//- (void)setCacheValue:(NSDictionary *)value withUserID:(NSString *)userid ankey:(NSString *)key{
//    if (cacheDic == nil) {
//        cacheDic = [NSMutableDictionary dictionary];
//    }
//
//    //保存到内存
//    NSString * jointStr = [NSString stringWithFormat:@"%@%@",userid,key];
//    NSString * currentTime =[self getCurrentTimeString];
//    @synchronized (userInfoDB) {
//        if ([userInfoDB open]) {
//
//            if (![self checkHasExistTable:[self getTableNameWithUser:userid]]) {
//
//                NSString * createTableSql = [NSString stringWithFormat:@"CREATE TABLE %@ (cacheKey text,cacheValue text,cacheTime text)",[self getTableNameWithUser:userid]];
//                if(![userInfoDB executeUpdate:createTableSql]){
//
//                    SCLog(@"createerror = %@", [userInfoDB lastErrorMessage]);
//                    return;
//
//                }
//            }
//
//            NSString *jointStrMD5 = [SCMD5Tool MD5ForLower32Bate:jointStr];
//            NSString *valueEncodeString = [SCBase64 encodeBase64String:value];
//            NSString * insertSql = [NSString stringWithFormat:@"insert or replace into %@ (cacheKey,cacheValue,cacheTime) VALUES ('%@','%@','%@')",[self getTableNameWithUser:userid],jointStrMD5,valueEncodeString,currentTime];
//
//            BOOL success = [userInfoDB executeUpdate:insertSql];
//            if (!success) {
//                SCLog(@"db_error = %@", [userInfoDB lastErrorMessage]);
//            }
//
//            [userInfoDB close];
//        }
//    }
//}

-(NSString*)getCacheValueInfoWithUserID:(NSString *)userid andKey:(NSString *)key{
    if (cacheDic == nil) {
        cacheDic = [NSMutableDictionary dictionary];
    }
    
    NSString * jointStr = [NSString stringWithFormat:@"%@%@",userid,key];
    if (jointStr && ![jointStr isEqualToString:@""]){
        
        CacheModel * m  = [cacheDic objectForKey:jointStr];//从内存获取数据
        NSString *  result = m.value;
        if (result == nil || [result isEqualToString:@""]) {
            @synchronized (userInfoDB) {
                if ([userInfoDB open]) {
                    
                    NSString *jointStrMD5 = [SCMD5Tool MD5ForLower32Bate:jointStr];
                    NSString * querySql = [NSString stringWithFormat:@"select cacheValue,cacheTime from %@ where cacheKey ='%@'",[self getTableNameWithUser:userid],jointStrMD5];
                    FMResultSet * resultSet = [userInfoDB executeQuery:querySql];//从数据库获取数据
                    NSString * dbResult = @"";
                    while ([resultSet next]) {
                        dbResult  =[SCBase64 decodeBase64String:[resultSet stringForColumnIndex:0]];
                        if (dbResult != nil && ![dbResult isEqualToString:@""]&&![dbResult isKindOfClass:[NSNull class]]) {
                            NSString * time = [resultSet stringForColumnIndex:1];
                            CacheModel * model = [[CacheModel alloc]init];
                            model.value = dbResult;
                            model.time = time;
                            [cacheDic setValue:model forKey:jointStr];
                        }
                    }
                    [userInfoDB close];
                    return dbResult;
                }else{
                    
                    return @"";
                }
            }
            
        }else{
            
            return result;
        }
        
    }
    
    return @"";
    
}

-(NSString*)getCacheTimeAndValueWithUserID:(NSString *)userid andKey:(NSString *)key{
    
    NSString * jointStr = [NSString stringWithFormat:@"%@%@",userid,key];
    if (jointStr && ![jointStr isEqualToString:@""]){
        
        CacheModel * m  = [cacheDic objectForKey:jointStr];//从内存获取数据
        NSString *  result = m.value;
        if (result == nil || [result isEqualToString:@""]) {
            @synchronized (userInfoDB) {
                if ([userInfoDB open]) {
                    
                    NSString *jointStrMD5 = [SCMD5Tool MD5ForLower32Bate:jointStr];
                    NSString * querySql = [NSString stringWithFormat:@"select cacheValue,cacheTime from %@ where cacheKey ='%@'",[self getTableNameWithUser:userid],jointStrMD5];
                    FMResultSet * resultSet = [userInfoDB executeQuery:querySql];//从数据库获取数据
                    NSString * dbResult;
                    NSString * time;
                    while ([resultSet next]) {
                        
                        dbResult  =[SCBase64 decodeBase64String:[resultSet stringForColumnIndex:0]];
                        time = [resultSet stringForColumnIndex:1];
                        if (dbResult != nil && ![dbResult isEqualToString:@""]&&![dbResult isKindOfClass:[NSNull class]]) {
                            
                            CacheModel * model = [[CacheModel alloc]init];
                            model.value = dbResult;
                            model.time = time;
                            [cacheDic setValue:model forKey:jointStr];
                        }
                        break;
                        //                        SCLog(@"%@",[resultSet stringForColumn:@"Value"]);
                        //                        SCLog(@"base:%@",[SCBase64 decodeBase64String:[resultSet stringForColumn:@"Value"]]);
                    }
                    [userInfoDB close];
                    NSString * str = [NSString stringWithFormat:@"{\"value\":\"%@\",\"time\":\"%@\"}",dbResult?dbResult:@"",time?time:@""];
                    return str;
                }else{
                    return nil;
                }
            }
        }else{
            
            NSString * str = [NSString stringWithFormat:@"{\"value\":\"%@\",\"time\":\"%@\"}",m.value?m.value:@"",m.time?m.time:@""];
            return str;
            
        }
        
    }
    
    return nil;
    
}

-(NSString * )getCurrentTimeString{
    NSDate *date = [NSDate date];
    NSString *DateTime = [DateFormat() stringFromDate:date];
    SCLog(@"%@============年-月-日  时：分：秒=====================",DateTime);
    return DateTime;
}


static NSDateFormatter* DateFormat(){
    static dispatch_once_t onceToken;
    static NSDateFormatter  *formatter;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    });
    return formatter;
}


//监测数据库中我要需要的表是否已经存在
-(BOOL)checkHasExistTable:(NSString*)tableName{
    NSString *existsSql = [NSString stringWithFormat:@"select count(name) as countNum from sqlite_master where type = 'table' and name = '%@'",tableName];
    @synchronized (userInfoDB) {
        FMResultSet *rs = [userInfoDB executeQuery:existsSql];
        if ([rs next]) {
            NSInteger count = [rs intForColumn:@"countNum"];
            SCLog(@"The table count: %li", count);
            if (count >= 1) {
                SCLog(@"存在");
                return YES;
            }
            
        }
        return NO;
    }
    
}

-(NSString *) getTableNameWithUser:(NSString *) userId{
    if([userId isEqualToString:@"0"]){
        return @"SC_DataCache";
    }
    
    NSString *tableName = [NSString stringWithFormat:@"%@%@",@"SC_",[SCMD5Tool MD5ForUpper32Bate:userId]];
    return tableName;
}

-(void)dropTableWithUserId:(NSString *)userId{
    
    @synchronized (userInfoDB) {
        
        if ([userInfoDB open]) {
            
            NSString *dropSql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS '%@'",[self getTableNameWithUser:userId]];
            BOOL  isOk = [userInfoDB executeStatements:dropSql];
            
            [userInfoDB close];
        }
    }
}



- (NSString *)getHxUserName{
    return [self getCacheValueInfoWithUserID:[self getCurrentUser] andKey:CACHE_HX_USER_NAME];
}
- (NSString *)getCurrentUser {
    return [self getCacheValueInfoWithUserID:@"0" andKey:@"curUser"];
}

- (NSString *)getUserToken {
    return [self getCacheValueInfoWithUserID:[self getCurrentUser] andKey:@"token"];
}

- (NSString *)getCurrentSpaceId {
    return [self getCacheValueInfoWithUserID:[self getCurrentUser] andKey:@"spaceId"];
}

- (NSString *)getCurrentSpaceName {
    return [self getCacheValueInfoWithUserID:[self getCurrentUser] andKey:@"spaceName"];
}

- (NSString *)getCurrentCharacterId {
    return [self getCacheValueInfoWithUserID:[self getCurrentUser] andKey:@"characterId"];
}

- (NSString *)getGdata{
    return [self getCacheValueInfoWithUserID:[self getCurrentUser] andKey:CACHE_GDATA];
}

- (NSString*)getHeadImg{
    return [self getCacheValueInfoWithUserID:[self getCurrentUser] andKey:@"headImg"];
}

- (NSMutableDictionary *)getCharacterInfo {
    NSMutableDictionary *characterInfo = [JsonTool dictionaryFromString:[self getCacheValueInfoWithUserID:[self getCurrentUser] andKey:CACHE_CHARACTER_INFO]];
    if (!characterInfo) {
        return [NSMutableDictionary dictionary];
    } else {
        return characterInfo;
    }
}
    
- (void)cacheCharacterInfo:(NSDictionary *)characterInfo withUserId:(NSString *)userId {
        [self setCacheValue:[JsonTool stringFromDictionary:characterInfo] withUserID:userId andKey:CACHE_CHARACTER_INFO];
}


-(SCCharacterModel *)characterModel{
    if (!_characterModel) {
        _characterModel = [[SCCharacterModel alloc]init];
        SCCharacterModel_characterInfo  *info = [SCCharacterModel_characterInfo mj_objectWithKeyValues:[self getCharacterInfo]];
        _characterModel.characterInfo = info;
        
    }
    return _characterModel;
}

- (NSString *)status{
    return @"1";
//    if ([_status isKindOfClass:[NSNumber class]]) {
//        return [NSString stringWithFormat:@"%@",_status];
//    }
//    return _status;
}

-(NSString *)chatRoomId{
    if (!_chatRoomId) {
        return @"111";  // 卡劵调试用的ID
    }
    return _chatRoomId;
}

@end
    
