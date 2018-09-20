//
//  DSStatusPhotoView.h
//  DSLolita
//
//  Created by 张小杨 on 15/5/26.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSStatusPhotoView : UIImageView


@property (nonatomic , copy) NSString *photoUrl;

- (void)setPhoto:(NSString *)photo;
@end
