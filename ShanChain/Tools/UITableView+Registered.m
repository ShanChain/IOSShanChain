//
//  UITableView+Registered.m
//  FlyPlusProject
//
//  Created by 黄宏盛 on 2017/8/11.
//  Copyright © 2017年 westAir. All rights reserved.
//

#import "UITableView+Registered.h"

@implementation UITableView (Registered)

- (void)pn_registerNib:(NSString*)nib{
    [self registerNib:[UINib nibWithNibName:nib bundle:nil] forCellReuseIdentifier:nib];
}
@end


@implementation UITableViewCell (Registered)


-(void)setCellDelegate:(id<BaseGeneralCellDelegate>)cellDelegate{
    objc_setAssociatedObject(self, @selector(cellDelegate), cellDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id<BaseGeneralCellDelegate>)cellDelegate{
   return  objc_getAssociatedObject(self, _cmd);
}


@end
