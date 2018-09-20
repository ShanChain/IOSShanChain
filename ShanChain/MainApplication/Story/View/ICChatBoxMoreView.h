//
//  ICChatBoxMoreView.h
//  XZ_WeChat
//
//  Created by zhang on 16/3/11.
//  Copyright © 2016年 gxz All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICChatBoxMoreViewItem.h"

typedef NS_ENUM(NSInteger, ICChatBoxItem){
    ICChatBoxItemPicture = 0,   // picture
    ICChatBoxItemMention,      // mention
    ICChatBoxItemTrend,       // Trend
    ICChatBoxItemDoc  ,        // doc
    ICChatBoxItemReading
};

@class ICChatBoxMoreView;
@protocol ICChatBoxMoreViewDelegate <NSObject>
/**
 *  点击更多的类型
 *
 *  @param chatBoxMoreView ICChatBoxMoreView
 *  @param itemType        类型
 */
- (void)chatBoxMoreView:(ICChatBoxMoreView *)chatBoxMoreView didSelectItem:(ICChatBoxItem)itemType;

@end

@interface ICChatBoxMoreView : UIView

@property (nonatomic, weak) id<ICChatBoxMoreViewDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *items;


@end
