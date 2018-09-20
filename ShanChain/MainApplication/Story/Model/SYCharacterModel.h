//
//  SYCharacterModel.h
//  ShanChain
//
//  Created by krew on 2017/9/28.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYCharacterModel : NSObject

@property (nonatomic, copy) NSString    *name;

@property (nonatomic,copy)NSString       *intro;

@property (nonatomic,strong)NSString     *headImg;

@property (nonatomic, assign) long      modelId;

@property (nonatomic, copy) NSString *characterId;

@property (nonatomic, copy) NSString *createTime;

@property (copy, nonatomic) NSString *disc;

@property (assign, nonatomic) long modelNo;

@property (copy, nonatomic) NSString *signature;

@property (copy, nonatomic) NSString *spaceId;

@property (copy, nonatomic) NSString *userId;

@property (copy, nonatomic) NSString *hxUserName;

@end
