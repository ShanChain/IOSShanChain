//
//  ApprDataPickeryMd.h
//  smartapc-ios
//
//  Created by 张小杨 on 16/11/25.
//  Copyright © 2016年 list. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ApprDataPickeryMdDelegate <NSObject>

- (void)onSelectDateMd:(NSString *)date;

-(void)onCompletedBtnClicked :(NSString *)date;

- (void)cancalBtnClicked;

@end

@interface ApprDataPickeryMd : NSObject

@property (nonatomic, weak) id<ApprDataPickeryMdDelegate>delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)open:(NSString *)date  index:(int)index ;

- (void)close;

@property(nonatomic,copy)NSString *endDateString;

@end
