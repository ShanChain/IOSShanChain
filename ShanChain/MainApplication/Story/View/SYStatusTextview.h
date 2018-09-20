//
//  SYStatusTextview.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/13.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSString *SYStatusTextviewNotificationTappedRoleName = @"SYStatusTextviewNotificationTappedRoleName";
static const NSString *SYStatusTextviewNotificationTappedTopicName = @"SYStatusTextviewNotificationTappedTopicName";

@interface SYStatusTextview : UITextView
/*
 {
     "content":"就行@墨子\b不喜欢#喷他kill#",
     "imgs": ["http://shanchain-picture.oss-cn-beijing.aliyuncs.com/da7813f3505446e685b76aff4e340fc7.jpg"],
     "spanBeanList":[
         {"beanId":12,"spaceId":16,"str":"墨子","type":1},
         {"beanId":22,"spaceId":16,"str":"喷他kill","type":2}
        ]
 }
 */
- (void)fillContentText:(NSString *)text;

- (void)insertPointedTextWithText:(NSString *)text atIndex:(int)index;

@end
