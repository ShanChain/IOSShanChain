//
//  SYAuxiliaryAddController.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/7.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SYAuxiliaryAddType) {
    SYAuxiliaryAddTypeSpace = 0,
    SYAuxiliaryAddTypeTopic,
    SYAuxiliaryAddTypeRole
};

@interface SYAuxiliaryAddObject : NSObject

@property (strong, nonatomic) NSString *navigationTitle;

@property (assign, nonatomic) int maxLenTag;
@property (assign, nonatomic) int maxLenTitle;
@property (assign, nonatomic) int maxLenTitle2;
@property (assign, nonatomic) int maxLenDetail;

@property (strong, nonatomic) NSString *placeholdTitle;
@property (strong, nonatomic) NSString *placeholdTitle2;
@property (strong, nonatomic) NSString *placeholdDetail;
@property (strong, nonatomic) NSString *placeholdTrail;

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *type;

@end

@interface SYAuxiliaryAddController : SCBaseVC

@property (assign, nonatomic) SYAuxiliaryAddType type;

@property (assign, nonatomic) long spaceId;

@property (strong, nonatomic) NSString *topicName;

@end
