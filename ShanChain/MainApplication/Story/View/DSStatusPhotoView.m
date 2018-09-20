//
//  DSStatusPhotoView.m
//  DSLolita
//
//  Created by 张小杨 on 15/5/26.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSStatusPhotoView.h"
#import "UIImageView+WebCache.h"

@interface DSStatusPhotoView()

@property (nonatomic , weak) UIImageView *gifView;

@end


@implementation DSStatusPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
   
    self = [super initWithFrame:frame];
    
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        self.opaque = YES;
        //添加一个gif图标
        UIImage *image = [UIImage imageWithName:@"timeline_image_gif"];//?.png
        UIImageView *gifView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:gifView];
        
        self.gifView = gifView;
    }
    return self;
}

- (void)setPhotoUrl:(NSString *)photoUrl {
    _photoUrl = photoUrl;

   // 1.下载图片
    [self sd_setImageWithURL:[NSURL URLWithString: photoUrl] placeholderImage:[UIImage imageNamed:@"abs_addanewrole_def_photo_default"]];//?.png
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.gifView.x = self.width - self.gifView.width;
    self.gifView.y = self.height - self.gifView.height;
}



@end
