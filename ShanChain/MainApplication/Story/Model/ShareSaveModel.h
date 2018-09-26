//
//  ShareSaveModel.h
//  ShanChain
//
//  Created by 千千世界 on 2018/9/25.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareSaveModel : NSObject

@property  (nonatomic,copy)    NSString   *shareId;
@property  (nonatomic,copy)    NSString   *title;
@property  (nonatomic,copy)    NSString   *intro;
@property  (nonatomic,copy)    NSString   *background;
@property  (nonatomic,copy)    NSString   *url;
@property  (nonatomic,copy)    NSString   *type;
@property  (nonatomic,copy)    NSString   *contentId;
@property  (nonatomic,strong)  UIImage    *thumbImage;

@end
