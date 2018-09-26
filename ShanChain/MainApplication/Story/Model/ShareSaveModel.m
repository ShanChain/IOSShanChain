//
//  ShareSaveModel.m
//  ShanChain
//
//  Created by 千千世界 on 2018/9/25.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "ShareSaveModel.h"

@implementation ShareSaveModel



-(UIImage *)thumbImage{
    UIImage *result;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_background]];
    result = [UIImage imageWithData:data];
    return [result mc_resetSizeOfImageData:result maxSize:20];
}

@end
