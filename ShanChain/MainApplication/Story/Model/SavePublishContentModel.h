//
//  SavePublishContentModel.h
//  ShanChain
//
//  Created by 千千世界 on 2018/10/10.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SavePublishContentModel : NSObject

@property   (nonatomic,copy)    NSString   *dyContent; //动态内容
@property   (nonatomic,copy)    NSArray    *dyImages; // 动态的图片数组

@property   (nonatomic,copy)    NSString   *fictionTitle; //小说标题
@property   (nonatomic,copy)    NSString   *fictionContent; //小说内容

@end
