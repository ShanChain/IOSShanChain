//
//  SYStoryNovelReadController.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/9.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYStoryNovelReadController : SCBaseVC

// json str
@property (strong, nonatomic) NSString *content;

@property (strong, nonatomic) NSArray *contentArray;

@property (strong, nonatomic) NSMutableArray *imageArray;

@property (assign, nonatomic) BOOL isLocal;

@end
