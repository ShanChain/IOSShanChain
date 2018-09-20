//
//  SYChatListCell.h
//  ShanChain
//
//  Created by krew on 2017/9/8.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYChatListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UIButton *messageCount;

@property (weak, nonatomic) IBOutlet UILabel *screenLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property(nonatomic,strong)NSDictionary *dic;

@property (nonatomic, strong) EMConversation *conversation;


@end
