//
//  UITableView+Registered.h
//  FlyPlusProject
//
//  Created by 黄宏盛 on 2017/8/11.
//  Copyright © 2017年 westAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Registered)

- (void)pn_registerNib:(NSString*)nib;

@end


@protocol BaseGeneralCellDelegate <NSObject>

@optional
- (void)clickCellSubViewForRowAtIndexPath:(NSIndexPath *)indexPath Object:(id)obj;
- (void)clickCellButtonForRowAtIndexPath:(NSIndexPath *)indexPath Object:(id)obj Button:(UIButton*)sender;
- (void)clickCellButtonForRowIndex:(NSInteger)index;
@end

@interface UITableViewCell (Registered)

@property (nonatomic,weak) id <BaseGeneralCellDelegate>cellDelegate;

@end
