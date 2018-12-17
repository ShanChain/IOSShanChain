//
//  CommonShareModel.h
//  ShanChain
//
//  Created by 千千世界 on 2018/12/14.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonShareModel : NSObject

@property   (nonatomic,copy)   NSString   *background;
@property   (nonatomic,copy)   NSString   *intro;
@property   (nonatomic,copy)   NSString   *percentage;
@property   (nonatomic,copy)   NSString   *title;
@property   (nonatomic,copy)   NSString   *characterId;
@property   (nonatomic,copy)   NSString   *url;
@property   (nonatomic,copy)   NSString   *ShareType;
@property (nonatomic,strong)   NSData     *thumbnail;
@property (nonatomic,strong)   NSData     *urlImageData;
@end
