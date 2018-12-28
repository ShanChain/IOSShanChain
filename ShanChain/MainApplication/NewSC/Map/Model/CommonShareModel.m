//
//  CommonShareModel.m
//  ShanChain
//
//  Created by 千千世界 on 2018/12/14.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "CommonShareModel.h"

@implementation CommonShareModel


-(NSData *)thumbnail{
    
    return UIImageJPEGRepresentation([UIImage imageFromURLString:_background], 0.1);
}

-(NSData *)urlImageData{
    return [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:_url]];
}

@end






