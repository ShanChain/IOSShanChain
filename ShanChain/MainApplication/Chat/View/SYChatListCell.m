//
//  SYChatListCell.m
//  ShanChain
//
//  Created by krew on 2017/9/8.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYChatListCell.h"

@implementation SYChatListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.cornerRadius = 25.0f;
    
    self.messageCount.layer.masksToBounds = YES;
    self.messageCount.layer.cornerRadius = 7.0f;
    self.messageCount.titleLabel.font = [UIFont systemFontOfSize:8.0];
    
}


- (void)setDic:(NSDictionary *)dic{
    
    _dic = dic;
    
    self.imgView.image = [UIImage imageNamed:dic[@"icon"]];
    
    if ([dic[@"isSelected"] isEqualToString:@"0"]) {
        [self.messageCount setTitleColor:RGB(59, 186, 200) forState:UIControlStateNormal];
        [self.messageCount setBackgroundColor:RGB(59, 186, 200)];
    }
    [self.messageCount setTitle:dic[@"messageCount"] forState:UIControlStateNormal];
    self.screenLabel.text = dic[@"screen"];
    self.timeLabel.text = dic[@"time"];
    self.contentLabel.text = dic[@"content"];
    self.nameLabel.text = dic[@"name"];
    
}

- (void) setConversation:(EMConversation *)conversation{
    _conversation = conversation;
    self.nameLabel.text = conversation.conversationId;
    if ([conversation unreadMessagesCount] > 0) {
        self.messageCount.hidden = ![conversation unreadMessagesCount];
        [self.messageCount setTitle:[NSString stringWithFormat:@"%ld", [conversation unreadMessagesCount]] forState:UIControlStateNormal];
    }
    self.contentLabel.text = conversation.latestMessage;
    
    EMMessage *message =  conversation.latestMessage;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:message.timestamp/1000.0];
    // 时间
//    self.timeLabel.text = [date formattedDateWithFormat:@"HH:MM"];
    self.timeLabel.text = @"09 38";
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
