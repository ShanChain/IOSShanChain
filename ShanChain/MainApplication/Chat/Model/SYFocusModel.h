//
//  SYFocusModel.h
//  ShanChain
//
//  Created by krew on 2017/10/18.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYFocusModel : NSObject

@property (nonatomic, assign) long      characterId;

@property(nonatomic, copy)NSString       *headImg;

@property(nonatomic, copy)NSString       *intro;

@property(nonatomic, copy)NSString       *name;

@property(nonatomic, assign) long       modelNo;

@property(nonatomic, assign) int        type;

@property (nonatomic, assign) long      userId;

//是否折叠
@property (nonatomic, assign, getter=isFolded) BOOL folded;

@end
