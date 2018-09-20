//
//  SYContactModel.h
//  ShanChain
//
//  Created by krew on 2017/10/19.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYContactModel : NSObject

@property (copy, nonatomic) NSString   *headImg;

@property (assign, nonatomic) long  modelNo;

@property (copy, nonatomic) NSString   *name;

@property (copy, nonatomic) NSString   *intro;

@property (assign, nonatomic) long  characterId;

@property (assign, nonatomic) BOOL  isSelected;

@property (copy, nonatomic) NSString   *hxUserName;

@end
