//
//  SYScreenInsideCell.h
//  ShanChain
//
//  Created by krew on 2017/9/22.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYScreenInsideCell;

@protocol SYScreenInsideCellDelegate <NSObject>

- (void)setScreenInsideQuitBtnClicked:(NSIndexPath *)indexPath;

@end

@interface SYScreenInsideCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@property(nonatomic,strong)NSDictionary *dic;

@property(nonatomic,strong)NSIndexPath *indexPath;

@property(nonatomic,strong)id<SYScreenInsideCellDelegate> delegate ;

@end
