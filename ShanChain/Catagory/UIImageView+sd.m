//
//  UIImageView+sd.m
//  TYWithHHSProject
//
//  Created by Apple on 2018/5/10.
//  Copyright © 2018年 黄宏盛. All rights reserved.
//

#import "UIImageView+sd.h"

@implementation UIImageView (sd)

-(void)_sd_setImageWithURLString:(NSString*)urlString placeholderImage:(UIImage *)placeholder{
    
    NSString  *imageUrl;
    if ([urlString hasPrefix:@"http://"] || [urlString hasPrefix:@"https://"]) {
        imageUrl = urlString;
    }else{
        imageUrl = [NSString stringWithFormat:@"%@%@",Base_url,urlString];
    }
    [self sd_setImageWithURL:[NSURL URLWithString: imageUrl] placeholderImage:placeholder];
}
    
- (void)_sd_setImageWithURLString:(NSString *)urlString{
    [self _sd_setImageWithURLString:urlString placeholderImage:nil];
}
-(void)preventImageViewExtrudeDeformation{
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    [self setContentScaleFactor:[[UIScreen mainScreen] scale]];
}

@end
