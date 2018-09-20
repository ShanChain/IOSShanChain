//
//  SYMarkCollection1Cell.h
//  ShanChain
//
//  Created by krew on 2017/8/28.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYMarkCollection1Cell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *itemTitleView;

- (void)updateSelectState:(BOOL)selected;

@end
