//
//  JPushUserInfo.h
//  ShanChain
//
//  Created by 千千世界 on 2018/12/14.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPushUserInfo : NSObject

@property  (nonatomic,copy)   NSString   *_j_business;
@property  (nonatomic,copy)   NSString   *_j_msgid;
@property  (nonatomic,copy)   NSString   *_j_uid;
@property  (nonatomic,copy)   NSString   *msgContent;
@property  (nonatomic,copy)   NSString   *sysPage;
@property  (nonatomic,copy)   NSString   *title;
@property  (nonatomic,copy)   NSString   *url;
@property  (nonatomic,copy)   NSString   *extra;
@property  (nonatomic,copy)   NSString   *type;
@end


@interface JPushUserInfo_aps : NSObject

@property  (nonatomic,copy)   NSString   *alert;
@property  (nonatomic,copy)   NSString   *badge;
@property  (nonatomic,copy)   NSString   *sound;

@end
