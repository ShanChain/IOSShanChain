//
//  SCCharacterModel.h
//  ShanChain
//
//  Created by 千千世界 on 2018/11/9.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCCharacterModel_hxAccount,SCCharacterModel_characterInfo;

@interface SCCharacterModel : NSObject

@property  (nonatomic,strong)  SCCharacterModel_hxAccount  *hxAccount;
@property  (nonatomic,strong)  SCCharacterModel_characterInfo  *characterInfo;

@end



@interface SCCharacterModel_hxAccount : NSObject

@property  (nonatomic,copy)  NSString  *hxUserName;
@property  (nonatomic,copy)  NSString  *characterId;
@property  (nonatomic,copy)  NSString  *userId;
@property  (nonatomic,copy)  NSString  *hxPassword;

@end



@interface SCCharacterModel_characterInfo : NSObject

@property  (nonatomic,copy)  NSString  *characterId;
@property  (nonatomic,copy)  NSString  *userId;
@property  (nonatomic,copy)  NSString  *name;
@property  (nonatomic,copy)  NSString  *intro;
@property  (nonatomic,copy)  NSString  *disc;
@property  (nonatomic,copy)  NSString  *headImg;
@property  (nonatomic,copy)  NSString  *modelNo;
@property  (nonatomic,copy)  NSString  *signature;
@property  (nonatomic,copy)  NSString  *status;
@property  (nonatomic,copy)  NSString  *createTime;
@property  (nonatomic,copy)  NSString  *sex;
@property  (nonatomic,copy)  NSString  *groupSet;
@property  (nonatomic,assign)  BOOL  allowNotify;// 是否开启推送

@end
